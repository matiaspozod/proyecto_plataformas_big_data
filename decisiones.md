# Registro de decisiones

| Fecha | Decisión | Alternativas consideradas | Motivo | Entrega inicial / cambio |
| --- | --- | --- | --- | --- |
| 2026-11-16 | Comparar recetas registradas entre días de mayor y menor actividad dentro del usuario. | Dashboard general, recomendador, predicción de continuidad. | Pregunta concreta, integración útil entre fuentes y producto descriptivo viable. | E1 / inicial |
| 2026-11-16 | Usar recetas, comidas, dispositivos, sesiones y mediciones; excluir reseñas del alcance. | Incorporar calificaciones y textos. | Las reseñas no son necesarias para la pregunta elegida. | E1 / inicial |
| 2026-11-16 | Indicadores: proteína y fibra por 100 kcal, tiempo de preparación. | Calorías consumidas y balance energético. | Describen recetas; no requieren asumir que los registros capturan toda la dieta o todo el gasto. Validar unidades antes de implementar. | E1 / inicial |
| 2026-11-16 | Promediar comidas dentro de cada día y días dentro de cada grupo, sin ponderar por porciones. | Promedio de todas las comidas juntas, ponderación por porciones. | La unidad principal es usuario-día; evita sobreponderar días con más registros. | E1 / inicial |
| 2026-11-16 | Comparar pasos con mediana de los 28 días calendario anteriores; exigir 14 días válidos. | Umbral absoluto de pasos, mediana del período completo. | Clasificación relativa y solo con historia anterior; revisar disponibilidad al recibir mediciones. Igualdad se clasifica como similar. | E1 / inicial |
| 2026-11-16 | Exigir cobertura de al menos 75% de intervalos de cinco minutos. | Contar muestras o asumir que un faltante es cero. | Frecuencias distintas y sesiones de diez segundos hacen inadecuado usar el número bruto de muestras. Umbral provisional. | E1 / inicial |
| 2026-11-16 | Al menos tres días por grupo y métrica para una comparación. | Mostrar cualquier diferencia disponible. | Evitar comparaciones apoyadas en un único día; no es un criterio de significación estadística. | E1 / inicial |
| 2026-11-16 | Modelo operacional relacional; separar reloj e historial de vínculos. | Documento único por usuario, vínculo sobrescrito. | Integridad, transacciones y atribución temporal de los eventos. | E1 / inicial |
| 2026-11-16 | Hechos usuario-día y comida; agregar fuentes antes de cruzarlas. | Unir mediciones y comidas directamente. | Evitar multiplicación de filas y sumas infladas; conservar detalle por receta. | E1 / inicial |
| 2026-11-16 | Conservar crudos y usar Parquet dimensional por mes; sin Lakehouse inicialmente. | Delta/Iceberg, particiones por usuario o por día. | Solución local simple; menos archivos pequeños. Reevaluar necesidad de gestión transaccional sobre archivos. | E1 / inicial |
| 2026-11-16 | Cierre a 48 h del final del día local y corrección dirigida de atrasos posteriores. | Streaming, ignorar atrasos, ventana rígida sin corrección. | El objetivo tolera actualización diaria; preservar exactitud y revisar también los 28 días siguientes afectados por la referencia. | E1 / inicial |
| 2026-11-16 | Publicar conjuntos completos de archivos mediante manifiesto; servir resumen a la app. | Leer archivos mientras se sobrescriben; calcular el historial en cada solicitud. | Evitar mezclar versiones y competir con la operación. | E1 / inicial |
| 2026-11-16 | Recetas desconocidas con clave 0; duplicados idénticos se eliminan en limpio. | Borrar todo registro problemático o imputar nutrientes. | Se observaron 48 comidas huérfanas y 48 sesiones duplicadas; mantener trazabilidad y denominadores. | E1 / inicial |
| 2026-11-16 | Declarar volumen real de mediciones pendiente y crecimiento como escenario. | Estimar filas reales desde la captura. | La carpeta no estuvo disponible; la captura no demuestra su volumen ni contenido. | E1 / inicial |

Los parámetros iniciales no son resultados empíricos ni recomendaciones de salud. Todo cambio conservará la decisión anterior, su motivo y la entrega en la que se modificó.
