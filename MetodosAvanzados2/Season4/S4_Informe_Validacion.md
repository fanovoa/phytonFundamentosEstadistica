# Práctica 4 · Informe de ejecución y verificación

**Curso:** Métodos alternativos de regresión lineal  
**Entorno de prueba:** R 4.4.3, Linux, noviembre de 2026  
**Estado:** los tres laboratorios principales y la lógica del panel Shiny fueron ejecutados con datos reales. Las extensiones Keras3 y SBERT permanecen opcionales.

## 1. Qué se comprobó realmente

| Componente | Comprobación | Resultado |
|---|---|---|
| Laboratorio STS | Carga de datos oficiales, GloVe, transformación de tres particiones, LS/LAD/Huber, bootstrap, prueba, simulación de etiquetas | Ejecución completa y HTML generado |
| Laboratorio CLEAR | Descarga del Excel oficial, auditoría de columnas, ingeniería de variables, tres regresiones, validación, prueba y contaminación | Ejecución completa y HTML generado |
| Red neuronal desde cero en R | Retropropagación, diferencia finita del gradiente, Adam, entrenamiento con MSE/MAE/Huber, parada temprana y comparación con regresión lineal | Ejecución completa y HTML generado |
| Interfaz Shiny | Creación de la aplicación y verificación de resultados reactivos del servidor, tabla, predicciones e interpretación | Pruebas de servidor superadas |
| Scripts R | Análisis sintáctico con `parse()` | Cinco de cinco válidos |
| Descarga alternativa STS | Lectura con `nanoparquet` de los tres archivos oficiales y conversión a TSV con comillas protegidas | 8.628 filas y **0 diferencias** de texto/puntuación frente al TSV de referencia al releer con `readr` |
| Informes HTML | Construcción mediante `rmarkdown::render()` | Tres documentos generados |
| Keras3 / TensorFlow | Bloque opcional del laboratorio STS | **No ejecutado** en esta revisión |
| SBERT preentrenado | Bloque opcional que requiere `reticulate` y pesos externos | **No ejecutado** en esta revisión |

Estos resultados no suponen una comprobación de la aplicación Shiny en todos los navegadores de los estudiantes; la interfaz se comprobó mediante el servidor de pruebas de `shiny`.

## 2. Base oficial STS Benchmark

Se usó la distribución normalizada de `sentence-transformers/stsb`, procedente del [repositorio oficial](https://huggingface.co/datasets/sentence-transformers/stsb). El servidor principal sugerido para los estudiantes es [STS Benchmark TSV](https://sbert.net/datasets/stsbenchmark.tsv.gz).

| Partición | Pares originales | Finalidad |
|---|---:|---|
| Entrenamiento | 5.749 | Ajustar embeddings y parámetros supervisados |
| Validación | 1.500 | Comparar métodos y elegir |
| Prueba | 1.379 | Examinar generalización tras elegir |

Puntuación humana normalizada: entre 0 y 1; la mediana en entrenamiento fue aproximadamente 0,60. La distribución original emplea escala 0–5, de modo que las métricas de error de la práctica pueden multiplicarse por cinco para expresarlas en la escala original.

### Regresiones lineales con el mismo vector de características

| Modelo | MAE validación | RMSE validación | MAE prueba | RMSE prueba | Spearman prueba |
|---|---:|---:|---:|---:|---:|
| LS | 0,1933 | 0,2313 | 0,2122 | 0,2532 | 0,5598 |
| LAD | **0,1926** | 0,2314 | **0,2115** | 0,2533 | 0,5591 |
| M de Huber | 0,1929 | 0,2314 | 0,2116 | **0,2528** | **0,5600** |

**Lectura para el estudiante.** El criterio de selección fue MAE de validación, por lo que se eligió LAD **antes** de mirar prueba. Un MAE de 0,2115 para LAD significa que la magnitud del error absoluto promedio fue de 0,2115 puntos en la escala 0–1, o aproximadamente 1,06 puntos en la escala STS original de 0–5. Los valores de error son cercanos y no justifican una afirmación general de superioridad de una técnica.

**Fenómeno importante:** la correlación simple entre coseno GloVe y etiqueta fue aproximadamente **+0,236**, pero la pendiente parcial LS estandarizada del coseno resultó aproximadamente **−0,042**. La correlación entre coseno y Jaccard fue aproximadamente **+0,601**. La inversión de signo al controlar por los otros predictores es un ejemplo real de que correlación simple y coeficiente de regresión múltiple responden preguntas diferentes; no es evidencia causal.

El entrenamiento GloVe puede presentar pequeñas diferencias entre ejecuciones por detalles numéricos del algoritmo; los valores anteriores corresponden a la corrida incluida en los `.html` y `.md` entregados.

## 3. Red neuronal en R puro: contraste real

La red implementa una arquitectura **3–8–1**, equivalente a 41 parámetros entrenables, con activaciones `tanh` y sigmoide, retropropagación analítica y optimizador Adam programados en R. Las tres variantes parten de la misma inicialización y se diferencian en la pérdida de entrenamiento.

La auditoría de una derivada de retropropagación contrastó gradiente analítico y diferencias finitas. La discrepancia absoluta observada fue aproximadamente **1,67 × 10⁻¹³**, por debajo de la tolerancia programada de `1e-5`.

| Modelo | MAE validación | MAE prueba | RMSE prueba | Spearman prueba |
|---|---:|---:|---:|---:|
| Red_MSE | **0,1860** | 0,2039 | **0,2477** | **0,5808** |
| Red_MAE | 0,1879 | 0,2037 | 0,2513 | 0,5726 |
| Red_Huber | 0,1874 | **0,2035** | 0,2504 | 0,5747 |

**Interpretación esencial:** se preseleccionó **Red_MSE** por MAE de validación, aunque en prueba Red_Huber mostró un MAE levemente menor. Cambiar la selección en función de prueba sería una evaluación sesgada. Las tres redes obtuvieron menor MAE de prueba que las regresiones lineales con estas características y esta configuración, pero esto demuestra una diferencia en **este experimento**, no que las redes siempre sean superiores.

Las salidas de R incluyen también el número de épocas realizadas, la mejor época retenida y la curva de error de validación. El estudiante debe justificar el papel de la parada temprana y de la función objetivo, sin confundir pérdidas de entrenamiento con métricas de evaluación.

## 4. CLEAR Corpus: un segundo problema real de IA educativa

Se descargó `CLEAR_corpus_final.xlsx` del [repositorio de los autores](https://github.com/scrosseye/CLEAR-Corpus) y se verificó que la hoja contiene **4.724 fragmentos y 28 campos**. La transformación produjo 3.306 ejemplos de entrenamiento, 708 de validación y 710 de prueba. La respuesta `BT_easiness` es un índice de facilidad relativa, no porcentaje ni probabilidad.

| Modelo | MAE validación | MAE prueba | RMSE prueba | Spearman prueba |
|---|---:|---:|---:|---:|
| LS | 0,6846 | **0,6885** | **0,8616** | 0,5361 |
| LAD | **0,6838** | 0,6908 | 0,8649 | **0,5398** |
| M de Huber | 0,6843 | 0,6889 | 0,8624 | 0,5374 |

**Interpretación esencial:** LAD fue seleccionado con validación, pero LS obtuvo el MAE más pequeño en la partición final de prueba. Esto ilustra de forma transparente que **ganar en validación no garantiza ganar en prueba** y que diferencias pequeñas pueden invertir posiciones. Las métricas tienen unidades del índice de facilidad CLEAR; no deben convertirse a porcentajes de acierto.

La fuente CLEAR está publicada bajo licencia [CC BY-NC-SA 4.0](https://github.com/scrosseye/CLEAR-Corpus/blob/main/README.md); por ello, la entrega remite al repositorio oficial para descargar el Excel y no incluye la base original íntegra.

## 5. Panel interactivo Shiny

Se comprobó el servidor de la aplicación con `shiny::testServer()` en distintas configuraciones:

- **0 % de contaminación, 350 pares de entrenamiento:** tres modelos estimados, tres métricas finitas y salidas reactivas disponibles.
- **25 % de contaminación, 2.500 pares de entrenamiento:** 625 etiquetas alteradas únicamente en una copia local del entrenamiento; tablas, predicciones por caso y texto de interpretación generados correctamente.
- **Escenario adicional de 10 % y 900 pares:** 90 etiquetas invertidas; LAD presentó el menor MAE de validación en esa corrida, aproximadamente 0,1992.

El parámetro de reactividad se ajustó para que la aplicación muestre resultados con los valores iniciales y se actualice con el botón del panel. No se han cambiado los archivos STS originales durante el experimento.

## 6. Paquetes de R usados en la comprobación

| Paquete | Versión | Función principal |
|---|---|---|
| R | 4.4.3 | Motor de cálculo |
| rmarkdown | 2.32 | Generación de tres informes HTML |
| knitr | 1.52 | Ejecución e inclusión de resultados |
| ggplot2 | 4.0.4 | Visualización |
| text2vec | 0.6.6 | Embeddings GloVe |
| quantreg | 6.1 | Ajuste LAD |
| MASS | 7.3-66 | Ajuste M de Huber |
| shiny | 1.14.0 | Panel interactivo |
| readxl | 1.6.0 | Datos CLEAR |
| svglite | 2.2.2 | Gráficos SVG |
| dplyr | 1.2.1 | Transformación de datos |
| readr | 2.2.0 | Lectura TSV |

## 7. Reproducir la verificación en RStudio

1. Descomprima el ZIP en una ruta corta y abra esa carpeta en RStudio.
2. Instale las dependencias con el primer bloque del laboratorio STS. También necesita `rmarkdown` para compilar.
3. Abra `S4_Laboratorio_STS.Rmd` y pulse **Knit**. El primer entrenamiento descargará la fuente y creará `datos/STS_features_app.rds`.
4. Abra `S4_Red_Neuronal_R_Base.Rmd` y pulse **Knit**. Compruebe el error de diferencia finita, la tabla de seis modelos y la selección por validación.
5. Ejecute `shiny::runApp("app")` desde la carpeta principal para explorar el ruido de etiquetas.
6. Abra `S4_Ampliacion_CLEAR.Rmd`, pulse **Knit** y compare los resultados de legibilidad.

Si la URL de STS no responde en su conexión, descargue el conjunto desde [Sentence-Transformers/STSB](https://huggingface.co/datasets/sentence-transformers/stsb) siguiendo la guía de fuentes. No mezcle puntuaciones 0–5 y 0–1: conserve la normalización declarada antes de ajustar cualquier modelo.

La conversión alternativa se implementó en `S4_Descarga_Alternativa_STS.R`. Se comprobó su proceso de lectura/escritura con los archivos Parquet oficiales almacenados temporalmente: al releer el TSV comprimido, se conservaron exactamente las 8.628 frases de cada columna y las puntuaciones. En esta ejecución aislada la descarga con el método HTTPS propio de R presentó problemas de certificados; el código incluye por eso una segunda opción mediante `curl --location`. La conversión local quedó verificada; el comportamiento de red específico de cada estudiante dependerá de su equipo.

## 8. Límites honestos de la validación

- Los tres informes HTML del paquete contienen **salidas efectivamente calculadas**, no textos ni gráficos simulados.
- El entrenamiento en R puro sí se ejecutó; los ejemplos opcionales de `keras3` y SBERT no se ejecutaron con sus backends externos.
- El test de Shiny comprobó la **lógica del servidor**. La inspección visual en un navegador de escritorio, la experiencia móvil y la accesibilidad completa deben revisarse antes de impartir la sesión.
- Los resultados no constituyen una evaluación publicable de modelos NLP de producción: el GloVe usado tiene corpus y dimensionalidad deliberadamente modestos por motivos pedagógicos.
- No se distribuyen completos los corpus originales de terceros; la práctica los descarga desde las fuentes oficiales según las condiciones de licencia.

## 9. Cuaderno integral para RStudio (actualización del 17 de noviembre)

Se agregó **`S4_Sesion4_RStudio_Completa.Rmd`**, que agrupa en el mismo orden los tres laboratorios de esta entrega, conserva sus explicaciones y añade una guía inicial de ejecución y un diccionario de interpretación estadística. Se incorporó el CSS en el propio archivo para que pueda descargarse individualmente.

**Verificaciones de la versión integral inicial:** se corroboró que contenía los 39 bloques de R de los cuadernos previamente ejecutados, con identificadores diferentes, que las opciones YAML se preservaban y que el módulo de redes referenciaba el archivo RDS creado por el primero. El documento pasó una conversión estructural de Markdown mediante Pandoc, sin ejecutar los fragmentos R. **Tras la ampliación pedagógica del apartado 11, la nueva versión tiene 40 bloques** (se agregó un ejercicio introductorio `eval=FALSE`). Las ejecuciones verificadas anteriormente corresponden a los tres módulos **por separado** (sus HTML incluidos constituyen la evidencia). En esta actualización no estaba disponible el intérprete R para volver a compilar el documento integral; se recomienda pulsar **Knit** desde RStudio antes de la clase, con las dependencias instaladas y acceso a las fuentes de datos.

## 10. Corrección del contraste de las salidas de R

En los archivos HTML generados, las líneas impresas por `print()`, `summary()` y otras funciones de R se presentan habitualmente como `<pre><code>`. El CSS anterior daba color de texto casi blanco al elemento `code` y color de fondo muy claro a su elemento `pre` padre. Por eso las cifras parecían invisibles hasta resaltarlas con el cursor.

Se corrigió el defecto mediante una regla más específica (`pre:not(.r):not(.sourceCode) code`), que establece **texto oscuro `#20334d` sobre fondo `#f1f7ff`** para las salidas. El código fuente (`pre.sourceCode`) conserva el diseño oscuro original. Se aplicó la corrección a la hoja externa que leen los tres `.Rmd` modulares, al CSS integrado del `.Rmd` completo y a los tres HTML ya compilados. La intervención no cambia datos, estimaciones, gráficos ni código R.

**Verificaciones:** la regla específica figura en las dos hojas de estilo; los tres HTML originales incorporan una única regla adicional cada uno; la versión unificada conserva etiquetas de bloques R únicas (ahora son 40, tras la ampliación pedagógica). En esta actualización no se pudo abrir un navegador gráfico del entorno para observar una captura (limitación del contenedor), pero la causa de la invisibilidad se verificó en el HTML real y en los selectores CSS. El contraste cromático ahora se revisa también de forma cuantitativa.

## 11. Revisión pedagógica: fórmula y lectura de R (17 de noviembre de 2026)

Por solicitud docente se amplió `S4_Laboratorio_STS.Rmd` con una secuencia de aprendizaje pensada para estudiantes que dominan nociones estadísticas pero **todavía no conocen suficientemente la sintaxis de R**:

1. Glosario de operadores (`<-`, `$`, `[`, `[[`, `::`, `==`), funciones y bloques reproducibles; microejercicio marcado `eval=FALSE`.
2. Explicación de importación de STS, particiones oficiales, normalización de etiquetas y lectura de los primeros resultados.
3. Desglose conceptual de la construcción de GloVe, significado de la matriz de coocurrencias, embeddings de oraciones, coseno, Jaccard y diferencias logarítmicas de longitud.
4. Fórmula de regresión múltiple escrita con variables explicativas originales y con sus versiones estandarizadas; intercepto y tres pendientes; despiece de `paste()`, `paste0()` y `as.formula()`.
5. Interpretación paso a paso de `lm`, `rq`, `rlm`, `coef`, `predict`, `summary`, bootstrap, métricas, selección por validación, gráfica de errores y perturbación controlada de etiquetas.
6. Notas de navegación para los módulos opcionales de Keras y Sentence-BERT, aclarando qué puede omitir un principiante.

La instrucción que construye `formula_modelo` se conserva en esencia; se añadió `print(formula_modelo)` para que el estudiante vea la fórmula efectivamente generada. Se mejoró la impresión de la tabla de intervalos bootstrap: ahora se mantienen visibles **los nombres de los coeficientes** junto a las estimaciones y sus límites.

La nueva versión del laboratorio modular contiene **22 chunks R** (20 evaluables y 2 demostrativos no evaluados). El documento integral reúne **40 chunks R**, todos con identificadores únicos. El script independiente `S4_Laboratorio_STS.R` fue sincronizado con los 20 bloques evaluables y sus comentarios. Las transformaciones estadísticas, fuentes de datos, particiones y funciones de pérdida se conservaron sin alteraciones.

Como mejora de portabilidad, el archivo `S4_Laboratorio_STS.Rmd` ahora incorpora directamente el CSS corregido de alto contraste y ya no requiere que `assets/estilo_lab.css` esté disponible al compilarse de manera independiente. El generador del cuaderno integral elimina el CSS duplicado del módulo STS; se confirmó que **ambos archivos contienen una única hoja de estilo integrada**.

Los tres HTML precompilados en el paquete corresponden al procesamiento real previamente ejecutado; **no incluyen todavía el nuevo texto pedagógico**. La versión ampliada debe compilarse con RStudio para combinar el nuevo texto con las salidas recalculadas. En esta actualización del entorno no se contó con un intérprete R para repetir el *Knit* completo; sí se verificó la estructura de bloques, su unicidad, la generación del script R y la consistencia de los nombres de predictores.

## 12. Extensión de la pedagogía a redes neuronales y CLEAR

**Actualización del 17 de noviembre de 2026.** Se amplió en profundidad
el texto y los comentarios de los **dos cuadernos restantes**, manteniendo
las bases reales, las particiones y los objetivos estadísticos:

1. `S4_Red_Neuronal_R_Base.Rmd`: diccionario de R; interpretación
   de `as.matrix`, listas, `[[`, `lapply`, `vapply`, `%*%`,
   `crossprod`, `tcrossprod`, `sweep`; dimensiones de la arquitectura
   3–8–1; práctica autónoma de multiplicación de matrices; ecuaciones
   de propagación y retropropagación; derivadas de MSE, MAE y Huber;
   ecuaciones de Adam y parada temprana; traducción de `as.formula`
   a una regresión lineal múltiple; lectura de tablas, curvas y
   selecciones de validación/prueba; interpretación de condicionales.
2. `S4_Ampliacion_CLEAR.Rmd`: diccionario de R; ecuación estadística
   de la respuesta y tres predictores; explicación de cada columna
   del Excel oficial; limpieza de casos completos; tokenización
   y `vapply`; ejercicio básico de cadenas de texto; división
   70 % / 15 % / 15 %; comparación de LS, LAD y Huber;
   lectura del resumen de modelos y sus incertidumbres; ejemplo
   aplicado de predicción con medianas de entrenamiento;
   métricas MAE/RMSE/Spearman y diseño matemático de la simulación.
3. Los tres cuadernos modulares contienen **su propia hoja CSS
   incorporada**, y el archivo completo combina una única copia
   de ese estilo, con textos de consola de alto contraste y
   mapas conceptuales luminosos.

**Control estructural de esta entrega:**

- STS: 22 chunks R (20 ejecutables, 2 ejercicios con `eval=FALSE`).
- Red neuronal: 11 chunks R (10 ejecutables, 1 demostrativo
  con `eval=FALSE`).
- CLEAR: 12 chunks R (11 ejecutables, 1 demostrativo
  con `eval=FALSE`).
- **Cuaderno integral: 45 chunks R con 45 etiquetas distintas**,
  procedentes de los tres módulos, sin etiquetas `setup`
  repetidas. Se sincronizaron los tres scripts R independientes
  con los bloques ejecutables de sus cuadernos.
- La generación y lectura estructural de los dos `.Rmd` mediante
  Pandoc completó sin errores sintácticos de Markdown.

**Alcance de la comprobación:** el intérprete R no está instalado
en el entorno de esta actualización, por lo que **no se afirma
haber ejecutado de nuevo los 45 bloques**. Los tres HTML y los
Markdown computados que acompañan al ZIP muestran **las salidas
reales obtenidas y verificadas en la versión anterior**, con
contraste corregido; no se han fabricado nuevas tablas de
resultados para cubrir esta ausencia. Al pulsar `Knit` en
RStudio, se ejecutarán los bloques adicionales y aparecerán
las explicaciones ampliadas junto a las nuevas salidas reales.

