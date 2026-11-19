# Práctica 4 — Regresión clásica, embeddings y redes neuronales

**Curso:** Métodos alternativos de regresión lineal · R/RStudio  
**Propósito:** mostrar con dos problemas reales que las pérdidas LS, LAD y Huber están presentes en algoritmos actuales de NLP y aprendizaje supervisado.

**Corrección de visualización (17 de noviembre de 2026):** se ajustó el contraste
de los bloques de salida de R en los cuatro cuadernos. Las salidas impresas
ahora usan **texto azul oscuro sobre fondo azul muy claro**, mientras que el
código R conserva su fondo oscuro. La corrección también se aplicó a los
tres HTML ya compilados. Si RStudio muestra una versión antigua, vuelva a
pulsar **Knit** y abra el HTML recién generado.

**Ampliación didáctica de los tres laboratorios (17 de noviembre de 2026):**
`S4_Laboratorio_STS.Rmd` explica desde cero la sintaxis utilizada, el flujo
de datos, la geometría de GloVe, las tres características de cada pareja de
frases, la ecuación de regresión múltiple (incluida la estandarización), la
construcción de `formula_modelo`, los ajustes LS/LAD/Huber, las salidas de
R, el bootstrap y las métricas de validación. Ahora también:

- **La red neuronal** explica cada operador matricial de R, sus dimensiones,
  la propagación hacia delante, la regla de la cadena, las 41 derivadas,
  Adam y la lectura de las tablas de validación y prueba.
- **CLEAR** incorpora una guía de sintaxis, la ecuación matemática completa,
  limpieza del Excel, construcción de predictores, interpretación de
  coeficientes y salidas de los tres métodos, un perfil de predicción
  ilustrativo y el diseño de una simulación de robustez.

Los **tres** `.Rmd` modulares y el cuaderno integral contienen el mismo
CSS de alto contraste en su interior: **se pueden descargar por separado**
sin depender de la carpeta `assets/`. Los tres `.R` independientes se
han sincronizado con sus cuadernos. **Los HTML y los `.md` precompilados
siguen mostrando los resultados reales verificados en la versión anterior
y no incorporan aún las nuevas explicaciones**: pulse **Knit** sobre los
`.Rmd` nuevos para producir los HTML con el texto ampliado y los resultados
que genere su equipo.

## Material incluido

| Archivo | Para qué sirve |
|---|---|
| **`S4_Sesion4_RStudio_Completa.Rmd`** | **Archivo principal para RStudio.** Integra los tres laboratorios (STS, redes neuronales en R puro y CLEAR) en un único cuaderno con **45 bloques R**, guías de sintaxis, explicaciones matemáticas y lecturas de salidas. Incluye el estilo visual dentro del propio archivo, por lo que se puede descargar por separado. |
| `S4_Presentacion.pdf` | Presentación visual para desarrollar en clase, con fórmulas, gráficos, ejemplos y preguntas |
| `S4_Presentacion.pptx` | Versión PowerPoint con el mismo diseño visual que el PDF, apropiada para proyección (las láminas se insertan como imágenes para conservar la composición) |
| `S4_Presentacion_Editable.pptx` | Versión PowerPoint alternativa cuyos cuadros de texto sí se pueden editar; su composición es más sencilla |
| `S4_Guia_Teorica.pdf` | Explicación matemática completa de LS/LAD/Huber, GloVe y redes neuronales |
| `S4_Laboratorio_STS.Rmd` | Laboratorio principal real **ampliado para principiantes en R**: STS Benchmark, GloVe, formulación matemática exacta, sintaxis paso a paso, LS/LAD/Huber y análisis de resultados |
| `S4_Laboratorio_STS.R` | Código de R extraído del R Markdown, para ejecución por bloques |
| `S4_Laboratorio_STS.html` | **Informe ya ejecutado** con tablas, salidas reales de R, gráficos vectoriales e interpretaciones |
| `S4_Laboratorio_STS.md` | Salidas computadas en texto Markdown para estudiar o auditar sin volver a ejecutar |
| `S4_Ampliacion_CLEAR.Rmd` | Caso real de legibilidad **ampliado para principiantes**: ecuaciones, funciones de R explicadas, lectura de cada salida y ejercicios progresivos |
| `S4_Ampliacion_CLEAR.R` | Código R de la ampliación |
| `S4_Ampliacion_CLEAR.html` | Ampliación **ejecutada y validada**, con sus resultados interpretados |
| `S4_Red_Neuronal_R_Base.Rmd` | Red neuronal 3–8–1 en R **con guía paso a paso de matrices, gradientes, Adam, pérdidas y métricas**, más ejemplos numéricos y ejercicios |
| `S4_Red_Neuronal_R_Base.R` | Código de la red neuronal en R puro, comentado paso a paso |
| `S4_Red_Neuronal_R_Base.html` | Red neuronal **ejecutada con STS real**, incluyendo auditoría numérica de gradiente, comparación con los tres modelos clásicos y explicación |
| `S4_Descarga_Alternativa_STS.R` | Descarga alternativa de STS desde los archivos Parquet oficiales, íntegramente en R; se usa solo si falla `sbert.net` |
| `S4_Informe_Validacion.md` | Registro del entorno, pruebas efectuadas, cifras de los casos reales y límites de lo verificado |
| `S4_Guia_Docente.pdf` | Solucionario razonado, errores frecuentes, secuencia y criterios para retroalimentar |
| `app/app.R` | Panel gráfico Shiny para comparar los tres métodos bajo perturbaciones de etiquetas |
| `assets/estilo_lab.css` | Estilo visual luminoso para HTML de R Markdown |
| `S4_Fuentes_Verificadas.md` | Procedencia de datos, documentación científica y límites metodológicos |
| `fuentes/S4_Guia_Teorica.tex` | Fuente matemática AMS-LaTeX de la guía teórica, para quien quiera modificarla |

## Ruta recomendada para el estudiante

1. Abra **`S4_Sesion4_RStudio_Completa.Rmd`** en RStudio. Es el **cuaderno integral** y no necesita ejecutar los otros tres `.Rmd` por separado. Los laboratorios separados se mantienen para facilitar el trabajo por módulos.
2. Instale una sola vez las bibliotecas CRAN indicadas en la sección 1. Para el núcleo de la práctica **no necesita GPU ni Python**: los embeddings de palabras GloVe se aprenden en R con `text2vec`.
3. Puede **abrir los tres HTML ya ejecutados de la versión anterior** (`S4_Laboratorio_STS.html`, `S4_Red_Neuronal_R_Base.html`, `S4_Ampliacion_CLEAR.html`) para ver salidas reales sin instalar nada. Para obtener **las explicaciones nuevas con salidas recién calculadas**, pulse **Knit → Knit to HTML** sobre el cuaderno integral. El código descargará STS Benchmark de `https://sbert.net/datasets/stsbenchmark.tsv.gz` y guardará una copia en `datos/`. **Si no responde**, ejecute una sola vez `install.packages("nanoparquet")` y después `source("S4_Descarga_Alternativa_STS.R")` desde la carpeta de la práctica; este script obtiene las tres particiones desde la fuente oficial alternativa. Luego pulse Knit nuevamente.
4. Lea **cada interpretación** justo después de cada bloque que imprime resultados. El cuaderno imprime frases con los coeficientes y las métricas efectivamente calculadas.
5. Al terminar el bloque 5, el cuaderno genera `datos/STS_features_app.rds`. Abra después `app/app.R` en RStudio y ejecute `shiny::runApp("app")` desde la carpeta de esta práctica.
6. En el **Módulo II del cuaderno integral** se construye una red neuronal 3–8–1 desde cero. **No necesita Python, GPU ni TensorFlow:** el entrenamiento de las tres redes se implementa en R puro.
7. En el **Módulo III del cuaderno integral** se estudia el caso autónomo de recomendación de lecturas. Descarga el archivo `CLEAR_corpus_final.xlsx` del GitHub original de los autores.

**Orden de ejecución recomendado:** un solo clic en **Knit** sobre `S4_Sesion4_RStudio_Completa.Rmd`, que respeta internamente la secuencia STS → red neuronal en R puro → CLEAR. El panel Shiny queda como recurso adicional.

### Opciones de cómputo

En el encabezado YAML de `S4_Laboratorio_STS.Rmd`:

- `iteraciones_glove: 25` controla la iteración de aprendizaje del embedding. Puede bajarse para demostración en máquinas modestas, reportando el cambio.
- `bootstrap: 120` controla replicaciones para la incertidumbre de Huber y LAD. Para una práctica final se recomiendan más, siempre que el tiempo lo permita.
- `contaminar: 0.10` altera un 10 % de las etiquetas **solo en una copia de entrenamiento** para analizar robustez.
- `correr_red: false` desactiva **la implementación adicional con `keras3`** del cuaderno principal. La red neuronal construida de cero en `S4_Red_Neuronal_R_Base.Rmd` sí funciona sin TensorFlow y ya fue probada.
- `correr_sbert: false` desactiva la sección pesada de embeddings de frases preentrenados. Al activarla se requiere `reticulate`, descarga de pesos y más memoria.

## Evidencias a entregar en la actividad

1. Una tabla con **MAE/RMSE/Spearman** de validación y de prueba para LS/LAD/Huber, con interpretación en puntos reales de similitud.
2. Dos interpretaciones completas de pendientes: una LS y una LAD (en la escala del coseno original).
3. Un gráfico de los pesos robustos con el significado de un peso bajo.
4. Una prueba de sensibilidad con **dos niveles** de contaminación simulada y **dos semillas**.
5. Una recomendación razonada para una aplicación de búsqueda o recomendación educativa. Debe incluir una limitación y una consideración de costo de error.
6. Del laboratorio de redes: verificación del gradiente por diferencias finitas, gráfica de MAE por época y comparación **seis modelos / tres métricas** en validación y prueba.

## Trazabilidad y responsabilidad

- STS Benchmark y CLEAR Corpus son **datos reales de terceros**; su descarga ocurre en R desde sus fuentes originales. El material **no contiene datos sintéticos presentados como observados**.
- Los `.html` y `.md` entregados contienen **cálculos ejecutados con R 4.4.3 y datos oficiales**. Al recompilar en otro ordenador se recalculan las salidas; GloVe puede exhibir diferencias numéricas menores entre equipos y configuraciones.
- La carpeta `datos/` empieza vacía en el ZIP y se llena al ejecutar los cuadernos. El fichero de características de Shiny también se genera localmente. **Los corpus originales no se redistribuyen** en el paquete; sus fuentes y condiciones de uso se documentan.
- Las etiquetas «corruptas» son **simulaciones controladas** y no acusaciones sobre anotadores reales.
- La comparación entre red y regresiones lineales exige respetar entrada común, misma partición y misma métrica. La red es una profundización opcional.
- Los tres cuadernos y los cuatro scripts R **pasaron pruebas de sintaxis y ejecución en una versión anterior**, y Shiny superó pruebas de servidor con controles y métricas reales. **Las ampliaciones pedagógicas nuevas no se han vuelto a ejecutar en R aquí**, porque el entorno actual no incluye R; se verificaron estructuralmente. Consulte `S4_Informe_Validacion.md`.
- Los bloques extra de **Keras3 y SBERT** siguen siendo opcionales y **no se probaron con sus backends** en esta validación. La red neuronal implementada en R puro **sí** se entrenó y contrastó de extremo a extremo.

## Plan sugerido de clase (110 minutos)

| Minutos | Núcleo |
|--|--|
| 0–12 | Problema NLP con parejas de frases |
| 12–27 | Pérdidas, gradientes y robustez |
| 27–47 | Datos STS + GloVe en R |
| 47–68 | LS, LAD y Huber, salidas interpretadas |
| 68–85 | Validación, test y ruido simulado |
| 85–100 | Red neuronal en R puro: retropropagación, pérdidas y curvas de aprendizaje |
| 100–110 | Resultados comparados, caso CLEAR y debate |

El caso CLEAR también funciona como trabajo autónomo de 45–60 minutos.

---

**Sobre el material de partida:** se tuvo presente la sesión 4 del ZIP del curso, que utilizaba `LifeCycleSavings` y diagnóstico de regresión clásica. En este rediseño se conserva el método y se expande a aplicaciones contemporáneas de IA.
