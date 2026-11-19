% Práctica 4: Regresión clásica y NLP
% Métodos alternativos de regresión
% Noviembre de 2026

# ¿Dos frases pueden significar lo mismo?

- «A young child is running in the park.»
- «A little kid jogs outside.»
- ¿Qué número asignaría a su similitud semántica?

---

# Qué cambia cuando entrenamos un sistema de NLP

- La representación del texto proporciona las variables.
- La función predictiva produce la estimación.
- La pérdida determina qué errores pesan más.

---

# STS Benchmark: datos oficiales

![Particiones STS Benchmark](figuras/particiones_sts.png){width=70%}

---

# La respuesta: similitud evaluada por personas

- y = puntuación humana normalizada
- x = información numérica que obtiene R de las oraciones
- ŷ = salida de la regresión o de la red neuronal

---

# Misma predicción, tres conceptos de error

- LS: suma de cuadrados de residuos.
- LAD: suma de valores absolutos.
- Huber: cuadrática para residuales pequeños y lineal para grandes.

---

# Las curvas explican decisiones diferentes

![Pérdidas LS, LAD y Huber](figuras/perdidas_claro.png){width=75%}

---

# Huber reduce la influencia de errores grandes

![Peso robusto Huber](figuras/pesos_huber.png){width=75%}

---

# GloVe aprende embeddings con mínimos cuadrados

- Coocurrencias de palabras → vectores latentes.
- Objetivo: errores cuadrados ponderados de log-frecuencias.
- Su optimización es no convexa conjuntamente.

---

# Tres características de cada par

- 1. Coseno de embeddings de oraciones.
- 2. Jaccard de palabras compartidas.
- 3. Diferencia de longitudes logarítmicas.

---

# Qué significa summary(lm) en un problema NLP

- Estimate: cambio asociado de similitud con otros predictores fijos.
- Std. Error y t: inferencia bajo supuestos.
- R² ajustado: ajuste de train, no predicción de test.

---

# LAD responde una pregunta estadística distinta

- LS se vincula con media condicional.
- LAD (tau = 0.5) con mediana condicional.
- Bootstrap cuantifica incertidumbre aproximada.

---

# Pesos de Huber: influencia variable

![Peso robusto Huber](figuras/pesos_huber.png){width=75%}

---

# Entrenamiento, validación y prueba

- Entrenamiento: estima parámetros.
- Validación: elige el modelo.
- Prueba: cuantifica el resultado final, una vez cerrada la elección.

---

# MAE, RMSE y Spearman miden cosas distintas

- MAE: magnitud habitual del error.
- RMSE: amplifica errores grandes.
- Spearman: qué tan bien ordenamos pares.

---

# Un experimento de robustez bien definido

- Se modifican artificialmente 10 % de etiquetas de train.
- Validación queda limpia.
- Repetimos semillas y magnitud de la perturbación.

---

# Red neuronal y funciones de pérdida

- Arquitectura: 3 variables, 12 y 8 neuronas ocultas, salida sigmoide.
- Retropropagación de MSE, MAE o Huber.

---

# Tres pérdidas opcionales en keras3

- loss = «mse»  →  penalización cuadrática.
- loss = «mae»  →  penalización absoluta.
- loss_huber(..., delta=0.15)  →  pérdida intermedia.

---

# La comparación necesita reglas compartidas

- Mismas variables, mismos conjuntos.
- Selección por una métrica común de validación.
- Una val_loss de MSE no es comparable numéricamente a una de MAE.

---

# Dos ubicaciones distintas para LS en NLP

- GloVe: mínimos cuadrados ponderados para aprender vectores.
- STS: mínimos cuadrados sobre similitud humana de frases.
- Ambos son usos reales de la misma idea matemática.

---

# CLEAR Corpus: IA aplicada a educación

- 4.724 fragmentos con facilidad de lectura basada en juicios humanos.
- Predictores: longitud, palabras por oración y longitud media de palabra.
- «Más alto» = mayor facilidad relativa, no porcentaje.

---

# Preguntas para equipos

- ¿Qué efecto tiene el ruido en cada método?
- ¿Cuándo elegiríamos MAE frente a RMSE?
- ¿Ayuda una red al problema o solo aumenta complejidad?

---

# Ruta de clase de 110 minutos

- 12 min motivación; 15 min pérdidas; 20 min GloVe.
- 21 min regresiones; 17 min evaluación.
- 15 min redes y 10 min discusión educativa.

---

# Las tres ideas que deben permanecer

- Embedding = representación numérica.
- Regresión o red = función de predicción.
- LS, LAD o Huber = regla para penalizar errores.

---
