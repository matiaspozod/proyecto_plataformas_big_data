-- INF3862 · E1 · Matías Pozo Díaz · 16-11-2026
-- SQL conceptual: documenta el diseño; no es un pipeline ejecutable.
-- :parametro indica un valor enviado por la aplicación o el analista.
-- Las tablas limpias y analíticas se construirán en E2.

-- T1 · OLTP · Cambiar el usuario vinculado a un reloj como una unidad.
BEGIN;
SELECT device_id FROM dispositivo
WHERE device_id = :reloj FOR UPDATE;
-- Validar existencia del usuario destino y :instante posterior al inicio.
UPDATE vinculacion SET fin = :instante
WHERE device_id = :reloj AND fin IS NULL;
INSERT INTO vinculacion
  (vinculacion_id, device_id, AuthorId, inicio, fin, zona_horaria)
VALUES (:id_nuevo, :reloj, :usuario, :instante, NULL, :zona);
COMMIT;
-- Ante cualquier error: ROLLBACK de toda la transacción.
-- UNIQUE parcial(device_id) WHERE fin IS NULL y prohibición de intervalos
-- superpuestos por dispositivo. El bloqueo serializa cambios del mismo reloj.

-- T2 · OLTP · Registrar una receta preparada.
INSERT INTO comida(comida_id, AuthorId, RecipeId, fecha_hora, porciones)
VALUES (:id_solicitud, :usuario, :receta, :instante_utc, :porciones);
-- PK comida_id, FK a usuario y receta, CHECK(porciones > 0).
-- Si el ID ya existe con el mismo contenido: devolver el registro existente.
-- Si el ID ya existe con contenido distinto: rechazar el conflicto.
-- La aplicación conserva el mismo ID al reintentar la misma solicitud.

-- T3 · OLTP · Mostrar las últimas 20 comidas de un usuario.
SELECT c.comida_id, c.fecha_hora, r.nombre, c.porciones
FROM comida c JOIN receta r ON r.RecipeId = c.RecipeId
WHERE c.AuthorId = :usuario
ORDER BY c.fecha_hora DESC, c.comida_id DESC LIMIT 20;

-- A1 · OLAP · Comparar cada indicador entre días de mayor y menor actividad.
-- La clase usa pasos respecto de la mediana de los 28 días previos.
-- Las medias del día promedian registros de comida válidos, sin ponderar
-- por porciones. Cada día pesa igual en la media de su grupo.
WITH valores AS (
  SELECT h.usuario_id, h.clase_actividad, v.metrica, v.valor
  FROM hecho_usuario_dia h
  CROSS JOIN LATERAL (VALUES
    ('proteina_g_100kcal', h.proteina_100kcal_media),
    ('fibra_g_100kcal', h.fibra_100kcal_media),
    ('preparacion_min', h.prep_min_media)
  ) AS v(metrica, valor)
  WHERE h.fecha_local BETWEEN :desde AND :hasta
    AND h.dia_cerrado AND h.dia_valido
    AND h.clase_actividad IN ('mayor', 'menor')
    AND v.valor IS NOT NULL
), resumen AS (
  SELECT usuario_id, metrica, clase_actividad,
         COUNT(*) AS dias, AVG(valor) AS media
  FROM valores GROUP BY usuario_id, metrica, clase_actividad
)
SELECT a.usuario_id, a.metrica, a.dias AS dias_mayor,
       b.dias AS dias_menor, a.media AS media_mayor,
       b.media AS media_menor, a.media-b.media AS diferencia
FROM resumen a JOIN resumen b
  ON a.usuario_id=b.usuario_id AND a.metrica=b.metrica
WHERE a.clase_actividad='mayor' AND b.clase_actividad='menor'
  AND a.dias>=3 AND b.dias>=3;
-- Un resumen de la cohorte promedia estas diferencias por métrica, con
-- igual peso por usuario, e informa cuántos usuarios resultan comparables.

-- A2 · OLAP · Evolución semanal de actividad y características de recetas.
SELECT h.usuario_id, f.anio_iso, f.semana_iso,
       AVG(h.pasos_dia) AS pasos_medios,
       AVG(h.minutos_sesion) AS minutos_sesion_medios,
       AVG(h.proteina_100kcal_media) AS proteina_media,
       AVG(h.prep_min_media) AS preparacion_media,
       COUNT(*) AS dias_reloj_validos,
       COUNT(h.proteina_100kcal_media) AS dias_con_proteina,
       COUNT(h.prep_min_media) AS dias_con_tiempo
FROM hecho_usuario_dia h JOIN dim_fecha f ON h.fecha_id=f.fecha_id
WHERE h.fecha_local BETWEEN :desde AND :hasta
  AND h.dia_cerrado AND h.dia_valido
GROUP BY h.usuario_id, f.anio_iso, f.semana_iso;
-- AVG ignora NULL. Cada denominador se muestra; ausencia de comida no es cero.

-- A3 · OLAP · Categorías de recetas según actividad, dentro de cada usuario.
WITH conteos AS (
 SELECT c.usuario_id, h.clase_actividad, r.categoria,
        COUNT(*) AS registros
 FROM hecho_comida c JOIN dim_receta r ON c.receta_id=r.receta_id
 JOIN hecho_usuario_dia h ON c.usuario_id=h.usuario_id
                        AND c.fecha_id=h.fecha_id
 WHERE h.fecha_local BETWEEN :desde AND :hasta
   AND c.fecha_local BETWEEN :desde AND :hasta
   AND h.dia_cerrado AND h.dia_valido
   AND h.clase_actividad IN ('mayor','menor')
   AND c.receta_id<>0
 GROUP BY c.usuario_id,h.clase_actividad,r.categoria
)
SELECT *, 1.0*registros / SUM(registros) OVER
  (PARTITION BY usuario_id,clase_actividad) AS proporcion
FROM conteos;
-- Una fila de comida equivale a un registro, no a una persona ni una porción.
-- RecipeCategory nula se presenta como 'Sin categoría'; receta desconocida
-- (clave 0) se excluye del reparto y se informa como incidencia aparte.

-- F1 · Frontera · Abrir la tarjeta personal de comparación ya calculada.
SELECT metrica, media_mayor, media_menor, diferencia, n_mayor, n_menor,
       corte_recepcion_utc
FROM resumen_usuario_metricas
WHERE usuario_id=:usuario AND ventana_dias=28;
-- Lectura puntual con patrón OLTP sobre una tabla de servicio derivada de A1.
-- El cálculo amplio es OLAP y ocurre fuera de la base operacional.
