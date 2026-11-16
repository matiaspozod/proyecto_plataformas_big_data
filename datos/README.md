# Datos del proyecto

Los archivos se obtienen del material del proyecto en Canvas. No se redistribuyen en este repositorio. Conservar los originales sin sobrescribirlos.

## Ubicación local sugerida

| Ruta | Archivo original |
| --- | --- |
| `datos/local/foodcom/recipes.parquet` | Catálogo de recetas Food.com. |
| `datos/local/foodcom/reviews.parquet` | Reseñas; disponibles pero fuera del alcance analítico elegido. |
| `datos/local/wearable/dispositivos.csv` | Relojes y sus vínculos con usuarios. |
| `datos/local/wearable/comidas.csv` | Recetas preparadas registradas por usuario. |
| `datos/local/wearable/sesiones.jsonl` | Actividades registradas. |
| `datos/local/wearable/mediciones/AAAA-MM-DD/HH.jsonl.gz` | Mediciones agrupadas por fecha y hora de recepción. |

La captura de Windows puede ocultar la extensión `.gz`. El formato completo se toma del diccionario del profesor. No renombrar o descomprimir masivamente los archivos antes de verificar su extensión real.

## Disponibilidad y evidencia en E1

| Fuente | Filas físicas | Tamaño exacto, bytes |
| --- | ---: | ---: |
| recipes.parquet | 522517 | 178723234 |
| reviews.parquet | 1401982 | 173762142 |
| dispositivos.csv | 315 | 19833 |
| comidas.csv | 22106 | 1006514 |
| sesiones.jsonl | 4840 | 779391 |
| mediciones/ | Pendiente de medir | Pendiente de medir |

Las cifras son anteriores a limpieza. `inventario_fuentes.json` conserva hashes SHA-256 y la fecha de inspección para identificar los archivos usados, sin incluir sus registros. La captura de pantalla no permite inferir el tamaño total, número de días completo o número de mediciones.

## Reglas semánticas que deben conservarse

- `AuthorId` en recetas identifica al autor de la receta; en comidas identifica a quien la registra. No son roles intercambiables.
- Todas las marcas originales están en UTC. El día analítico es local según la zona del usuario; los cambios de horario alteran la duración del día.
- La carpeta de mediciones se organiza por recepción, no por momento de medición. Deben revisarse también archivos de recepción posteriores al intervalo analizado.
- Pulso S usa `device_id`, `ts_medicion`, `ts_recepcion`, `frecuencia_cardiaca`, `pasos`, `calorias`.
- FitBand 2 usa `dev`, `timestamp` (epoch en milisegundos), `received_at`, `fc`, `steps`, `kcal`.
- Pasos y calorías son incrementos desde la medición anterior. Fuera de sesiones, Pulso S mide cada minuto y FitBand 2 cada cinco; durante las sesiones ambos miden cada diez segundos.
- No sumar calorías de las sesiones y de las mediciones como fuentes independientes de gasto.
- Las recetas con calorías cero no admiten cálculo de gramos por 100 kcal. La validez de cada indicador tiene su propio denominador.

## Muestra prevista para E2

1. Una vez recibidas las mediciones, inventariar todos los archivos y registrar fechas, filas, bytes comprimidos y problemas de lectura.
2. Seleccionar de forma determinista hasta 50 usuarios con al menos un vínculo, ordenando `AuthorId` y tomando los primeros 50. Conservar la lista seleccionada y la regla usada; no elegir usuarios por el resultado de su comparación.
3. Mantener el período completo disponible, aproximadamente 60 días, para contar con historia y ventana de comparación. Procesar los lotes de recepción necesarios hasta la fecha de corte fijada; no filtrar solo por el nombre de la carpeta.
4. Cargar comidas y sesiones de esos usuarios, sus vínculos y las recetas referidas. Conservar las referencias desconocidas como incidencias.
5. Verificar cuántos días y usuarios cumplen cobertura, historia y tamaño mínimo de cada grupo. Si son insuficientes, ampliar la muestra o revisar los umbrales con justificación en `decisiones.md`.

## Pendiente antes de la implementación

Verificar volumen real de mediciones; distribución de retrasos; coherencia de los incrementos; conflictos entre relojes; suficiente cobertura por usuario y día; unidades y base común de las columnas nutricionales; comportamiento de duraciones ISO 8601. Un fallo en estos controles debe quedar documentado y no resolverse inventando valores.
