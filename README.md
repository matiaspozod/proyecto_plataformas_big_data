# Actividad física y características de las recetas registradas

**Autor:** Matías Pozo Díaz  
**Curso:** INF3862 · Plataformas Big Data para Data Science  
**Etapa:** Entrega 1 · 16 de noviembre de 2026

## Objetivo

Comparar, dentro de cada usuario, las características de las recetas registradas entre sus días de mayor y menor actividad física. Se integran recetas Food.com, comidas registradas, dispositivos, sesiones y mediciones del wearable. El resultado final será un dashboard descriptivo; no representa toda la alimentación ni permite atribuir causalidad.

Indicadores propuestos: densidad de proteína y fibra de las recetas (g por 100 kcal) y tiempo de preparación. La comparación usa el historial de cada persona y exige cobertura suficiente del reloj y días comparables en ambos grupos.

## Entregables

| Archivo | Contenido |
| --- | --- |
| [Informe E1](entregas/E1/informe_E1_Matias_Pozo.pdf) | Tres páginas de informe principal y nueve páginas de anexos identificados A-I. |
| [Fuente editable](entregas/E1/informe_E1.md) | Texto y tablas del informe, consultas y referencias a los diagramas. |
| [Consultas](entregas/E1/anexos/consultas.sql) | Tres consultas OLTP, tres OLAP y un caso frontera; SQL aproximado. |
| [Diagrama relacional](entregas/E1/anexos/diagrama_relacional.svg) | Entidades, claves y relaciones operacionales. |
| [Arquitectura inicial](entregas/E1/anexos/arquitectura_inicial.svg) | Fuentes, recepción, almacenamiento y consumo. |
| [Datos](datos/README.md) | Origen, ubicación local, disponibilidad y límites de los datos. |
| [Registro de decisiones](decisiones.md) | Decisiones iniciales, alternativas y motivos. |

## Alcance de E1

Esta entrega contiene diseño, consultas conceptuales y una inspección básica de los archivos disponibles. No incluye un pipeline ni exige ejecutar el SQL. Los tiempos de respuesta son objetivos de diseño; el crecimiento de la aplicación es un escenario explícito, no una medición.

Se verificaron los conteos y tamaños de recetas, reseñas, dispositivos, comidas y sesiones. Se detectaron 48 sesiones repetidas y 48 comidas sin receta en el catálogo. La carpeta de mediciones no estuvo disponible para inspección: su volumen, cobertura y calidad reales están pendientes. El modelo de recepción se basa en el diccionario del profesor y la captura de su estructura.

Los umbrales de cobertura y clasificación se revisarán en E2 si la muestra no permite comparaciones suficientes. No se ha generado una tabla analítica ni se presentan resultados de actividad física.

## Reproducibilidad y siguientes etapas

- Los datasets se obtienen desde Canvas y se mantienen fuera del repositorio; ver `datos/README.md`.
- El inventario de los archivos inspeccionados y sus hashes está en `datos/inventario_fuentes.json`.
- E2 incorporará un notebook ejecutable, reglas de limpieza y las consultas A1-A3 sobre tablas analíticas.
- Desde E2 se incluirán `pyproject.toml` y `uv.lock`, con instrucciones para `uv sync` y `uv run`. No se incluyen entornos vacíos ni comandos de ejecución de un pipeline inexistente en E1.
- E3 desarrollará el dashboard, su referencia histórica y la arquitectura con herramientas concretas.

## Publicación de la entrega

1. Crear un repositorio **público** de GitHub para este proyecto.
2. Subir el contenido de esta carpeta conservando la organización. No subir datasets ni el ZIP completo como único entregable.
3. Comprobar desde el repositorio que el PDF se puede abrir y que el README enlaza a él.
4. Registrar el enlace del repositorio en el Excel indicado en Canvas por el profesor.

El enunciado fija el cierre de E1 el 16 de noviembre de 2026 a las 23:59. Este paquete prepara los archivos; su creación no implica que se hayan publicado en GitHub o registrado en el Excel.

## Referencias

Enunciado del proyecto INF3862, clases 0 y 1, LEEME general y diccionario del wearable proporcionados por el profesor. Catálogo Food.com: [Recipes and Reviews](https://www.kaggle.com/datasets/irkaal/foodcom-recipes-and-reviews), licencia CC0 según el LEEME del curso. Datos del wearable sintéticos, creados por el equipo docente.
