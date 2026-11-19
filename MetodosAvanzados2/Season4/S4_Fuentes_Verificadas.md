# Fuentes técnicas, académicas y de datos — Práctica 4

Las siguientes direcciones corresponden a publicaciones, repositorios de autores o documentación de los proyectos informáticos. Se seleccionaron recursos primarios, no recopilaciones de terceros.

## Conjuntos de datos reales

### STS Benchmark

- **Fuente de descarga utilizada en R:** https://sbert.net/datasets/stsbenchmark.tsv.gz
- **Ficha de dataset oficial normalizado:** https://huggingface.co/datasets/sentence-transformers/stsb
- **Archivos alternativos de las tres particiones en Parquet** (si no funciona la redirección de `sbert.net`): https://huggingface.co/datasets/sentence-transformers/stsb/tree/main/data. El archivo **`S4_Descarga_Alternativa_STS.R`** automatiza en R esa descarga y conversión mediante `nanoparquet` y `readr`. Las puntuaciones de esta edición **ya están entre 0 y 1**: no las divida de nuevo por cinco.
- **Documentación del problema y entrenamiento STS:** https://sbert.net/examples/sentence_transformer/training/sts/README.html
- **Publicación de evaluación STS:** Cer et al. (2017), https://aclanthology.org/S17-2001/
- **Variables empleadas:** `split`, `sentence1`, `sentence2`, `score`. Se conservan las particiones train/dev/test originales, sin barajar las filas para resegmentar.
- **Unidad de respuesta:** originalmente similitud humana 0 a 5; se convierte a 0 a 1 al descargarla si hace falta.
- **Tamaño de referencia:** 5.749 train, 1.500 validation/dev y 1.379 test en versiones de STS Benchmark ampliamente distribuidas. El R Markdown imprime y valida el número efectivamente recibido, sin suponer una cifra fija.
- **Limitación:** las etiquetas agregan evaluaciones humanas y no constituyen una verdad semántica perfecta. El corpus está principalmente en inglés.

### CLEAR Corpus

- **Repositorio original:** https://github.com/scrosseye/CLEAR-Corpus
- **Archivo Excel original utilizado en R:** https://raw.githubusercontent.com/scrosseye/CLEAR-Corpus/main/CLEAR_corpus_final.xlsx
- **Publicación primaria:** Crossley y colaboradores (2022), https://pmc.ncbi.nlm.nih.gov/articles/PMC10027808/
- **Variables:** `Excerpt`, `BT_easiness`, `Google WC`, `Sentence Count`, `Paragraphs`, `Categ`, `s.e.`.
- **Naturaleza de etiqueta:** puntuación continua de facilidad de lectura mediante modelo Bradley–Terry a partir de juicios humanos; valores más altos indican más facilidad relativa, **no probabilidades**.
- **Tamaño de referencia:** 4.724 fragmentos en el corpus final; el cuaderno contabiliza el número válido después de su limpieza explícita.
- **Licencia:** [CC BY-NC-SA 4.0, según el README original](https://github.com/scrosseye/CLEAR-Corpus/blob/main/README.md). Incluye restricciones para reutilización comercial y redistribución. La presente práctica solo los descarga directamente al ejecutar R.

## Artículos fundacionales: embeddings y aprendizaje

1. **GloVe**: Pennington, J., Socher, R. y Manning, C. (2014). *GloVe: Global Vectors for Word Representation*. Proceedings EMNLP. https://aclanthology.org/D14-1162/
2. **Sentence-BERT**: Reimers, N. y Gurevych, I. (2019). *Sentence-BERT: Sentence Embeddings using Siamese BERT-Networks*. Proceedings EMNLP. https://aclanthology.org/D19-1410/
3. **Adam**: Kingma, D. P. y Ba, J. (2015). *Adam: A Method for Stochastic Optimization*. ICLR. https://arxiv.org/abs/1412.6980 (aplicación pedagógica completamente escrita en R en `S4_Red_Neuronal_R_Base.Rmd`).
4. **Documentación Sentence-Transformers**: pérdidas `CosineSimilarityLoss` y función predeterminada MSE: https://sbert.net/docs/package_reference/sentence_transformer/losses.html
5. **Modelo preentrenado MiniLM**, opcional para embeddings de frases: https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2

## Software y documentos de referencia

- `text2vec`: https://text2vec.org/glove.html (GloVe sobre matriz dispersa de coocurrencias)
- `MASS::rlm`: https://search.r-project.org/CRAN/refmans/MASS/html/rlm.html (regresión M con función psi de Huber)
- `quantreg::rq`: https://search.r-project.org/CRAN/refmans/quantreg/html/rq.html (regresión por cuantiles, tau 0.5 para LAD)
- `quantreg::summary.rq`: https://search.r-project.org/CRAN/refmans/quantreg/html/summary.rq.html (inferencia bootstrap)
- `keras3` (R): https://keras3.posit.co/ (construcción y entrenamiento de MLP, MSE/MAE/Huber)
- `reticulate`: https://rstudio.github.io/reticulate/ (comunicación desde R con biblioteca de embeddings preentrenados)
- `readxl` (R): https://readxl.tidyverse.org/ (lectura de base Excel CLEAR)
- `nanoparquet` (R): https://nanoparquet.r-lib.org/reference/read_parquet.html (alternativa ligera para leer los archivos oficiales Parquet de STS)
- Birkes, D. y Dodge, Y. (1993). *Alternative Methods of Regression*. Libro guía de las sesiones del curso (copia suministrada por el profesor).

## Precisiones de reproducibilidad

- Un objetivo **GloVe ponderado en cuadrados** no convierte el entrenamiento conjunto de vectores de palabras en una sola regresión OLS convexa.
- El ajuste `MASS::rlm` y la pérdida neuronal Huber tienen escalas/umbrales de distinta parametrización; deben compararse conceptualmente y calibrarse por separado.
- Los modelos lineales producen interpretaciones condicionales en la escala de salida; una red neuronal no aporta la misma interpretación de coeficientes.
- El nuevo laboratorio de red neuronal calcula y verifica analíticamente los gradientes de MSE/MAE/Huber y permite comparar directamente una red no lineal con los ajustes lineales. No depende de Keras3 ni TensorFlow.
- No hay base para atribuir causalidad a cosenos o longitudes textuales.
- La red de ejemplo usa embeddings ya construidos y características derivadas. **No entrena BERT de extremo a extremo.**
- La evaluación del rendimiento debe separar entrenamiento, validación y prueba.
- El código opcional Sentence-BERT puede requerir varios cientos de MB y conexión a internet para obtener los pesos.
