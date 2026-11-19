# Guía para el docente — Práctica 4

## Orientación de la sesión

**Pregunta de apertura:** *¿por qué las pérdidas que utilizamos en la regresión clásica siguen importando cuando la máquina aprende representaciones de oraciones y entrena redes neuronales?*

El estudiante debe acabar con dos conclusiones diferentes pero relacionadas:

- La representación lingüística (embeddings) proporciona variables que pueden entrar en una regresión.
- El algoritmo de entrenamiento de una red también utiliza pérdidas MSE/MAE/Huber; se diferencian las funciones de predicción, no la necesidad de definir un error.

La actividad parte de las sesiones previas sobre LS, LAD y regresión M de Huber. El material original del curso incluía `LifeCycleSavings`; aquí el concepto estadístico se conserva en dos aplicaciones de IA.

## Respuestas esperadas a los problemas centrales

**1. Interpretación de coeficientes.** Si el predictor está estandarizado, un coeficiente \(\beta\) indica cambio en la salida ante una desviación estándar original de ese predictor, controlando los restantes. Para volver a una variación de 0.10 de coseno: calcular \(\beta\cdot 0.10/s_{\text{coseno}}\), con \(s\) estimada solo en entrenamiento.

**2. Diferencia conceptual LS/LAD.** LS aproxima la media condicional bajo especificación adecuada; LAD con \(\tau=0.5\), la mediana condicional. Dos signos parecidos no significan que estimen el mismo parámetro poblacional. Huber estima un centro robusto determinado por su función de puntuación y escala.

**3. Lectura del bootstrap LAD.** El error estándar evalúa variación de la estimación por remuestreo, condicionado al esquema aplicado. No es una medida del tamaño del residuo ni una certificación de causalidad. La semilla y el número de réplicas deben quedar registrados.

**4. Lectura de Huber.** Pesos bajos reducen la influencia de observaciones de residuo grande. No deben confundirse con «probabilidad de etiqueta falsa». `summary.rlm` no suministra p-valores clásicos que puedan reportarse sin precaución.

**5. Comparación de métricas.** MAE y RMSE se miden en puntos de similitud normalizada; Spearman es adimensional. Si MAE es de 0.12 (número hipotético), el promedio de discrepancia absoluta equivale a 0.60 puntos de la escala 0 a 5. El docente debe exigir el número calculado en cada equipo, no el del ejemplo.

**6. Contaminación.** Las etiquetas invertidas se generan artificialmente en una copia de train. Val y test permanecen intactos. Un resultado de una semilla no demuestra una propiedad general; se exigen dos niveles de perturbación y distintas semillas.

**7. Embeddings de GloVe.** La función objetivo es cuadrática y ponderada sobre coocurrencias; el producto interno entre dos vectores que son parámetros simultáneos la convierte en optimización no convexa global, no un único sistema de ecuaciones normales.

**8. Red neuronal.** Un perceptrón multicapa puede usar exactamente MSE, MAE o Huber para obtener gradientes. La comparación necesita una métrica común para selección, porque una pérdida `val_loss` de MSE no tiene la misma escala que una pérdida de MAE.

**9. CLEAR.** La respuesta `BT_easiness` es una medida relativa continua de facilidad derivada de juicios humanos, no una proporción. Las variables de longitud son indicadores aproximados, no una «definición» de legibilidad.

## Preguntas de retroalimentación por salida de R

| Salida visible | Pregunta del docente | Señal de comprensión |
|--|--|--|
| `head(sts)` | ¿Qué es una fila y cuál es la etiqueta? | Un par de frases, una puntuación humana |
| `summary(score)` | ¿Qué dicen mediana y rango? | Centralidad y escala de similitud |
| Dimensiones de GloVe | ¿Qué representan 40 columnas? | Coordenadas latentes de representación |
| `summary(lm)` | ¿Cuál es el efecto de +0.10 de coseno original? | Reescalamiento correcto por desviación estándar |
| `summary(rq)` | ¿Por qué no hablar de media? | Cuantil condicional 50 % |
| `summary(rlm)` | ¿Por qué no reportar su t como p clásico? | Justificación inferencial distinta |
| Gráfico de pesos | ¿Un peso bajo significa error humano? | No; influencia estadística reducida |
| Tabla MAE/RMSE | ¿Cuál es la unidad? | Puntos de puntuación humana |
| Spearman | ¿Es calibración? | No; calidad de ordenamiento |
| `val_loss` de red | ¿Qué se puede comparar? | Métrica común sobre misma validación |

## Rúbrica breve sugerida (20 puntos)

- **Construcción y trazabilidad de datos (4):** identifica fuente, respetó splits y no filtró información.
- **Interpretación matemática de salidas (6):** explica coeficientes, estandarización, inferencia y residuos sin confusiones.
- **Comparación fuera de muestra (4):** calcula métricas comunes y elige usando validación.
- **Robustez experimental (3):** separa datos simulados de reales; prueba semillas y contaminación.
- **Defensa de aplicación IA (3):** relaciona embedding, función predictiva y pérdida, reconoce una limitación.

## Errores frecuentes a detectar

1. Creer que un embedding «ya predice» la etiqueta humana.
2. Hablar de causalidad por encontrar coeficientes significativos.
3. Convertir un coeficiente estandarizado directamente en puntos del coseno original.
4. Optimizar hiperparámetros mirando repetidamente test.
5. Comparar números absolutos de `val_loss` de MSE y MAE.
6. Denominar `MASS::rlm` equivalente exacto a `keras3::loss_huber(delta=.15)`.
7. Tomar la robustez a errores de respuesta como robustez a alto apalancamiento.
8. Interpretar `BT_easiness` como probabilidad o porcentaje.

## Trabajo posterior

Pedir un informe de dos páginas con la decisión de modelo para un sistema educativo, dos tablas de métricas, una figura de robustez y las interpretaciones escritas con sus números reales. El estudiante debe distinguir claramente hechos observados, decisiones de modelado y limitaciones.

La solución **no incluye cifras finales inventadas**: las estimaciones dependerán de la versión oficial descargada, las iteraciones GloVe y la ejecución real del laboratorio en R.
