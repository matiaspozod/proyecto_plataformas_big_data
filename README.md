# Proyecto del curso

**Pontificia Universidad Católica de Chile**  
**INF3862 — Plataformas Big Data para Data Science**

## Actividad física y características de las recetas registradas

**Alumno:** Matías Pozo Díaz.

## Caso de uso

Una aplicación de recetas basada en Food.com incorpora información de relojes inteligentes y permite que sus usuarios registren qué recetas preparan.

Este proyecto diseña una plataforma de datos para integrar ambas fuentes y construir un dashboard personal. El usuario podrá consultar cómo cambian las características de sus preparaciones entre días de mayor y menor actividad física, y utilizar esa información para planificar sus próximas recetas.

El dashboard combinará:

- **Actividad:** pasos y sesiones registrados por los relojes.
- **Preparaciones:** recetas registradas por cada usuario y momento del registro.
- **Características de las recetas:** información nutricional, categorías y tiempos de preparación disponibles en Food.com.

La pregunta principal es:

**¿Cómo varían las características de las recetas que registra un mismo usuario entre sus días de mayor y menor actividad física?**

Inicialmente se compararán la densidad de proteína, la densidad de fibra y el tiempo de preparación. La clasificación de actividad utilizará el historial de cada persona y considerará la disponibilidad de mediciones.

Los resultados describirán asociaciones entre registros de Food.com y datos sintéticos de relojes. No representan toda la alimentación del usuario ni permiten concluir que la actividad física causa cambios en sus elecciones de recetas.

## Decisiones de diseño

La aplicación y el dashboard requieren formas distintas de trabajar con los datos:

| Necesidad | Diseño propuesto | Justificación |
| --- | --- | --- |
| Registrar comidas, gestionar relojes y consultar el historial reciente. | Modelo operacional relacional, con claves, restricciones y transacciones. | Estas operaciones leen o modifican pocos registros y necesitan respuestas rápidas y consistentes. |
| Comparar muchos días y relacionar actividad con recetas. | Modelo analítico con hechos por usuario-día y por comida, y dimensiones de usuario, fecha y receta. | Permite integrar fuentes y calcular agregaciones históricas. |
| Conservar los datos recibidos y repetir su procesamiento. | Almacenamiento de archivos originales, separado de las tablas preparadas. | Mantiene la trazabilidad y permite revisar errores o modificar reglas. |
| Consultar las tablas analíticas eficientemente. | Parquet columnar y particiones temporales. | Las consultas utilizan determinadas columnas y períodos del historial. |

El catálogo de Food.com también alimentará la tabla operacional de recetas, utilizada para validar las referencias de las comidas registradas. Este recorrido complementa el flujo hacia el almacenamiento analítico mostrado en el diagrama de arquitectura.

Las mediciones y las comidas se agregarán por separado antes de combinar sus resúmenes diarios. Esto evita multiplicar registros al relacionar varias mediciones con varias comidas del mismo usuario.

## Entregas

| Entrega | Fecha | Contenido |
| --- | --- | --- |
| E1 — Diseño de datos | 16 de noviembre de 2026 | Objetivo, fuentes y recepción, modelos OLTP/OLAP, consultas y arquitectura inicial. |
| E2 — Ingesta y procesamiento | 30 de noviembre de 2026 | Notebook, capas de datos, reglas de calidad, consultas y análisis de rendimiento y escala. |
| E3 — Datos para el objetivo y arquitectura final | 14 de diciembre de 2026 | Dataset analítico, dashboard, comparación con una referencia y arquitectura con herramientas concretas. |

## Entrega 1

El [informe E1](entregas/E1/informe_E1_Matias_Pozo.pdf) desarrolla los requisitos del enunciado:

1. Objetivo y cinco preguntas guía: resultado, datos, operaciones, exigencias y recursos.
2. Fuentes: unidad de registro, formato, volumen, recepción, problemas y tratamiento del esquema.
3. Modelo operacional: entidades, claves, relaciones y una regla que requiere una transacción.
4. Modelo analítico: granularidad, medidas, dimensiones, ubicación y organización física.
5. Consultas: tres OLTP, tres OLAP y un caso en la frontera entre ambas cargas.
6. Arquitectura inicial: fuentes, recepción, almacenamiento y consumo.

El SQL es aproximado y documenta el diseño. La implementación se desarrollará en E2.

## Datos y disponibilidad

Los datos se obtienen desde Canvas. Las instrucciones de ubicación y selección de la muestra están en [datos/README.md](datos/README.md). Los datasets no se incluyen en el repositorio.

Se inspeccionaron los archivos de recetas, dispositivos, comidas y sesiones. Se identificaron 48 sesiones repetidas y 48 comidas cuyo identificador de receta no aparece en el catálogo.

La carpeta de mediciones no estuvo disponible durante la preparación de E1. Su estructura se documentó a partir del diccionario del curso y de una captura de pantalla. Su volumen y calidad reales quedan pendientes de verificación.

Las cantidades observadas se distinguen de los supuestos de crecimiento y de los objetivos de rendimiento.

## Archivos del proyecto

| Ubicación | Contenido |
| --- | --- |
| [entregas/E1/informe_E1_Matias_Pozo.pdf](entregas/E1/informe_E1_Matias_Pozo.pdf) | Informe y anexos de E1. |
| [entregas/E1/informe_E1.md](entregas/E1/informe_E1.md) | Fuente editable del contenido. |
| [entregas/E1/anexos/consultas.sql](entregas/E1/anexos/consultas.sql) | Consultas y justificaciones operacionales y analíticas. |
| [entregas/E1/anexos/](entregas/E1/anexos/) | Diagramas del modelo operacional y la arquitectura. |
| [datos/README.md](datos/README.md) | Obtención, ubicación y selección de los datos. |
| [datos/inventario_fuentes.json](datos/inventario_fuentes.json) | Conteos, tamaños y hashes de los archivos inspeccionados. |
| [decisiones.md](decisiones.md) | Decisiones, alternativas consideradas y motivos. |

## Ejecución y siguientes etapas

E1 no requiere ejecutar un pipeline. Desde E2 se incorporarán el notebook, `pyproject.toml`, `uv.lock` y las instrucciones para preparar el entorno y reproducir el procesamiento.

Las decisiones iniciales se revisarán al trabajar con las mediciones reales. Los cambios y sus motivos quedarán registrados en `decisiones.md`.
