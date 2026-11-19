# ================================================================
# SESIÓN 4 · Métodos de regresión e inteligencia artificial
# Código R extraído del cuaderno: S4_Laboratorio_STS.Rmd
# Ejecutar desde la carpeta S4_IA_Regresion de forma secuencial.
# Cada bloque está explicado con detalle en el archivo R Markdown.
# ================================================================

# Opciones editables del laboratorio principal.
params <- list(
  iteraciones_glove = 25L,
  bootstrap = 120L,
  contaminar = 0.10,
  correr_red = FALSE,   # TRUE exige keras3 y backend instalado
  correr_sbert = FALSE  # TRUE exige reticulate y pesos descargados
)

# ---- BLOQUE: setup ----

knitr::opts_chunk$set(echo=TRUE, warning=FALSE, message=FALSE,
                      fig.width=10.2, fig.height=5.5,
                      fig.align="center", dev="svg")
obligatorios <- c("readr", "dplyr", "ggplot2", "text2vec",
                  "quantreg", "MASS", "knitr", "svglite")
faltan <- obligatorios[!vapply(obligatorios, requireNamespace, logical(1), quietly=TRUE)]
if (length(faltan)) {
  stop("Faltan bibliotecas: ", paste(faltan, collapse=", "),
       ". Ejecute el bloque de instalación de la sección 1.")
}
dir.create("datos", showWarnings=FALSE)
dir.create("figuras", showWarnings=FALSE)
set.seed(20261116)
color_ls <- "#2685E8"
color_lad <- "#EA4C91"
color_huber <- "#11B99A"
tema <- function() {
  ggplot2::theme_minimal(base_size=14) +
    ggplot2::theme(
      plot.title=ggplot2::element_text(face="bold", size=18, colour="#12243B"),
      plot.subtitle=ggplot2::element_text(colour="#56667C"),
      panel.grid.minor=ggplot2::element_blank(),
      legend.position="bottom",
      axis.text=ggplot2::element_text(colour="#344357")
    )
}

# ---- BLOQUE: descargar-sts ----

# PASO 1. Descargar el archivo oficial una sola vez; no usamos ejemplos inventados.
destino <- file.path("datos", "stsbenchmark.tsv.gz")
if (!file.exists(destino)) {
  download.file(
    url="https://sbert.net/datasets/stsbenchmark.tsv.gz",
    destfile=destino, mode="wb", quiet=TRUE
  )
}

# PASO 2. Leer TSV comprimido. Las oraciones se conservan como texto UTF-8.
sts <- readr::read_tsv(
  destino,
  col_types=readr::cols(.default=readr::col_character()),
  show_col_types=FALSE, progress=FALSE
)

# PASO 3. Validar el esquema y convertir la puntuación a numérica.
necesarias <- c("split", "sentence1", "sentence2", "score")
stopifnot(all(necesarias %in% names(sts)))
sts$score <- as.numeric(sts$score)
stopifnot(all(is.finite(sts$score)))
if (max(sts$score) > 1.01) sts$score <- sts$score / 5
stopifnot(all(sts$score >= 0 & sts$score <= 1))
sts$split <- tolower(sts$split)
sts$split[sts$split == "dev"] <- "validation"

# PASO 4. Respetar las particiones oficiales, sin repartir filas al azar.
ent <- as.data.frame(sts[sts$split == "train", ])
val <- as.data.frame(sts[sts$split == "validation", ])
pru <- as.data.frame(sts[sts$split == "test", ])
stopifnot(nrow(ent)>100, nrow(val)>100, nrow(pru)>100)

# PASO 5. Inspección de la base.
print(data.frame(Particion=c("Entrenamiento","Validación","Prueba"),
                 Pares=c(nrow(ent),nrow(val),nrow(pru))))
print(head(ent[c("sentence1","sentence2","score")], 3))
print(summary(ent$score))

# ---- BLOQUE: grafica-distribucion ----

ggplot2::ggplot(ent, ggplot2::aes(x=score)) +
  ggplot2::geom_histogram(bins=28, fill=color_ls, colour="white", linewidth=0.45) +
  ggplot2::geom_vline(xintercept=median(ent$score),
                      linetype="dashed", colour=color_lad, linewidth=1.1) +
  ggplot2::labs(title="Similitudes etiquetadas por personas",
    subtitle="Línea rosada: mediana de entrenamiento",
    x="Similitud humana normalizada", y="Número de pares") + tema()

# ---- BLOQUE: entrenar-glove ----

# PASO 1. Usar SOLO las oraciones de entrenamiento para aprender el vocabulario.
# Así evitamos incorporar el texto de validación/prueba al ajuste del embedding.
# Mantener el mismo tratamiento de mayúsculas en el aprendizaje y la
# posterior búsqueda de palabras; de otro modo habrá falsos desconocidos.
corpus_ent <- tolower(c(ent$sentence1, ent$sentence2))

# PASO 2. Tokenizar y conservar palabras que aparezcan al menos dos veces.
iter1 <- text2vec::itoken(corpus_ent, tokenizer=text2vec::word_tokenizer,
                         progressbar=FALSE)
vocab <- text2vec::create_vocabulary(iter1)
vocab <- text2vec::prune_vocabulary(vocab, term_count_min=2)
vectorizador <- text2vec::vocab_vectorizer(vocab)

# PASO 3. Crear la matriz dispersa de coocurrencias; ventana de cinco palabras.
iter2 <- text2vec::itoken(corpus_ent, tokenizer=text2vec::word_tokenizer,
                         progressbar=FALSE)
mat_cooc <- text2vec::create_tcm(iter2, vectorizador, skip_grams_window=5L)

# PASO 4. Ajustar GloVe a esa matriz: 40 dimensiones de representación.
glove <- text2vec::GlobalVectors$new(rank=40L, x_max=10)
vect_principal <- glove$fit_transform(
  mat_cooc, n_iter=as.integer(params$iteraciones_glove),
  convergence_tol=0.01
)
vect_palabras <- vect_principal + t(glove$components)

# PASO 5. Verificar dimensiones de los objetos.
print(data.frame(
  Objeto=c("Vocabulario", "Matriz de coocurrencias", "Embeddings de palabras"),
  Filas=c(nrow(vocab), nrow(mat_cooc), nrow(vect_palabras)),
  Columnas=c(NA, ncol(mat_cooc), ncol(vect_palabras))
))

# ---- BLOQUE: funciones-embeddings ----

# PASO 6. Función transparente que convierte una oración en un vector.
tokenizar <- function(frase) {
  z <- unlist(strsplit(tolower(frase), "[^[:alpha:]']+"))
  z[nzchar(z)]
}

embedding_oracion <- function(frase, tabla=vect_palabras) {
  palabras <- tokenizar(frase)
  presentes <- palabras[palabras %in% rownames(tabla)]
  # No inventar un vector para palabras desconocidas: usar un vector cero.
  if (length(presentes)==0L) return(rep(0, ncol(tabla)))
  colMeans(tabla[presentes, , drop=FALSE])
}

# PASO 7. Similaridad coseno, superposición léxica y diferencia de longitud.
coseno_filas <- function(A, B) {
  denominador <- sqrt(rowSums(A*A)) * sqrt(rowSums(B*B))
  ifelse(denominador > 0, rowSums(A*B)/denominador, 0)
}
jaccard_textos <- function(a,b) {
  x <- unique(tokenizar(a)); y <- unique(tokenizar(b))
  if (length(union(x,y))==0L) return(0)
  length(intersect(x,y))/length(union(x,y))
}

caracterizar_pares <- function(base) {
  # PASO 8. Cada fila conserva su par original y su etiqueta humana.
  n <- nrow(base)
  A <- t(vapply(base$sentence1, embedding_oracion,
                FUN.VALUE=numeric(ncol(vect_palabras))))
  B <- t(vapply(base$sentence2, embedding_oracion,
                FUN.VALUE=numeric(ncol(vect_palabras))))
  base$cos_glove <- coseno_filas(A,B)
  base$jaccard <- mapply(jaccard_textos, base$sentence1, base$sentence2)
  n_a <- vapply(base$sentence1, function(x) length(tokenizar(x)), integer(1))
  n_b <- vapply(base$sentence2, function(x) length(tokenizar(x)), integer(1))
  base$dif_log_long <- abs(log1p(n_a) - log1p(n_b))
  base
}

# PASO 9. Transformar las tres particiones con el MISMO vocabulario entrenado.
ent <- caracterizar_pares(ent)
val <- caracterizar_pares(val)
pru <- caracterizar_pares(pru)

print(head(ent[c("score","cos_glove","jaccard","dif_log_long")], 5))

# ---- BLOQUE: dispersograma ----

ggplot2::ggplot(ent, ggplot2::aes(x=cos_glove,y=score)) +
  ggplot2::geom_point(alpha=0.22, colour=color_ls, size=1.2) +
  ggplot2::geom_smooth(method="lm", se=FALSE,
                       colour=color_lad, linewidth=1.15) +
  ggplot2::labs(title="Geometría vectorial y similitud humana",
                subtitle="Una recta captura tendencia media, pero no toda la variabilidad",
                x="Coseno de los embeddings", y="Similitud humana [0,1]") +
  tema()

# ---- BLOQUE: escalar ----

# PASO 1. Elegir características que estarán disponibles en todos los modelos.
variables <- c("cos_glove","jaccard","dif_log_long")

# PASO 2. Calcular media y desviación SOLO en entrenamiento.
centro <- vapply(ent[variables], mean, numeric(1))
escala <- vapply(ent[variables], sd, numeric(1))
escala[escala == 0] <- 1

# PASO 3. Aplicar la misma transformación a train, validación y test.
normalizar <- function(base) {
  for (nm in variables) {
    base[[paste0(nm,"_z")]] <- (base[[nm]]-centro[[nm]])/escala[[nm]]
  }
  base
}
ent <- normalizar(ent)
val <- normalizar(val)
pru <- normalizar(pru)
predictores <- paste0(variables,"_z")
formula_modelo <- as.formula(paste("score ~", paste(predictores,collapse="+")))
# PASO 4. Mostrar la ecuación que R acaba de construir (todavía sin estimar).
print(formula_modelo)
# PASO 5. Mostrar los valores que se usaron para estandarizar cada variable.
print(data.frame(Variable=variables, Media_entrenamiento=round(centro,3),
                 Desviacion_entrenamiento=round(escala,3)))

# ---- BLOQUE: ajustar-tres ----

# PASO 1. LS: minimiza suma de errores al cuadrado.
modelo_ls <- stats::lm(formula_modelo, data=ent)

# PASO 2. LAD: minimiza suma de errores absolutos, cuantil tau=0.5.
modelo_lad <- quantreg::rq(formula_modelo, tau=0.5, data=ent)

# PASO 3. M de Huber: contribución aproximadamente cuadrática para residuos
# pequeños y lineal en magnitud para residuos grandes (escala robusta interna).
modelo_huber <- MASS::rlm(formula_modelo, data=ent,
                         method="M", psi=MASS::psi.huber, maxit=200)

# PASO 3B. Guardar SOLO características derivadas para la interfaz Shiny.
# Este archivo se crea localmente con datos STS oficiales al ejecutar la práctica.
saveRDS(list(
  train=ent[c("score",predictores,"sentence1","sentence2")],
  valid=val[c("score",predictores,"sentence1","sentence2")],
  test=pru[c("score",predictores,"sentence1","sentence2")],
  predictores=predictores
), file="datos/STS_features_app.rds")

# PASO 4. Examinar las salidas que ofrecen las tres funciones.
summary(modelo_ls)
summary(modelo_lad, se="boot", R=as.integer(params$bootstrap))
summary(modelo_huber)

# ---- BLOQUE: interpretacion-ls ----

# PASO 5. Transformar coeficientes a frases de interpretación numérica.
# coef() devuelve un vector con el intercepto y las tres pendientes.
coef_ls <- coef(modelo_ls)
# [["cos_glove_z"]] elige UNA pendiente por su nombre.
# Se divide por la desviación original para deshacer la estandarización.
b_cos_unidad <- unname(coef_ls[["cos_glove_z"]]/escala[["cos_glove"]])
# sprintf() inserta valores numéricos en un texto; cat() lo muestra.
cat(sprintf(
  "LS: aumentar el coseno original en 0.10, manteniendo constantes Jaccard y longitud, se asocia con un cambio estimado de %+.3f puntos en la similitud humana.\n",
  0.10*b_cos_unidad
))
cat(sprintf(
  "El R² ajustado es %.3f. Esta cifra describe entrenamiento, no rendimiento en prueba.\n",
  summary(modelo_ls)$adj.r.squared
))

# ---- BLOQUE: signo-condicional ----

# PASO 1. Calcular la correlación marginal y la correlación entre predictores.
cor_marginal <- cor(ent$cos_glove, ent$score)
cor_entre_rasgos <- cor(ent$cos_glove, ent$jaccard)

# PASO 2. Comparar con el coeficiente PARCIAL de la regresión múltiple.
beta_parcial <- coef(modelo_ls)[["cos_glove_z"]]
cat(sprintf("Correlación simple coseno–etiqueta: %+.3f.\n", cor_marginal))
cat(sprintf("Correlación coseno–Jaccard: %+.3f.\n", cor_entre_rasgos))
cat(sprintf("Pendiente LS parcial del coseno estandarizado: %+.3f.\n",
            beta_parcial))

# ---- BLOQUE: interpretacion-lad ----

# Recuperar la pendiente de la regresión de la mediana (tau=0.5).
# La división convierte una unidad estandarizada a una unidad de coseno.
b_cos_lad <- unname(coef(modelo_lad)[["cos_glove_z"]]/escala[["cos_glove"]])
cat(sprintf(
  "LAD: ante un incremento de 0.10 en el coseno original, el modelo estima un cambio de %+.3f puntos en la MEDIANA condicional de similitud, manteniendo fijos los otros predictores.\n",
  0.10*b_cos_lad
))

# ---- BLOQUE: interpretacion-huber ----

# Extraer la misma pendiente del ajuste M de Huber y desestandarizarla.
b_cos_huber <- unname(coef(modelo_huber)[["cos_glove_z"]]/escala[["cos_glove"]])
cat(sprintf(
  "Huber: un aumento de 0.10 en el coseno original se asocia con %+.3f puntos de variación del ajuste robusto, dejando constantes las demás variables.\n",
  0.10*b_cos_huber
))
cat(sprintf(
  "Escala robusta de residuos (modelo M): %.4f. Proporción de pesos inferiores a 0.8: %.1f%%.\n",
  modelo_huber$s, mean(modelo_huber$w < 0.8)*100
))

# ---- BLOQUE: pesos-huber ----

# Cada fila combina el peso asignado por Huber y su residuo.
data_pesos <- data.frame(peso=modelo_huber$w,
                        residual=as.numeric(resid(modelo_huber)))
# El eje horizontal muestra el tamaño del error, sin importar el signo.
# El eje vertical muestra la importancia relativa dada a esa fila.
ggplot2::ggplot(data_pesos, ggplot2::aes(x=abs(residual),y=peso)) +
  ggplot2::geom_point(alpha=0.32, colour=color_huber) +
  ggplot2::labs(title="¿Qué observaciones reciben menos peso?",
                subtitle="Huber reduce la influencia de residuos grandes",
                x="Valor absoluto del residuo", y="Peso robusto") +
  ggplot2::coord_cartesian(ylim=c(0,1.05)) + tema()

# ---- BLOQUE: bootstrap-huber ----

# PASO 1. Definir una réplica de bootstrap sobre pares completos.
una_replica <- function(i) {
  muestra <- ent[sample.int(nrow(ent), replace=TRUE), , drop=FALSE]
  ajuste <- tryCatch(
    MASS::rlm(formula_modelo, data=muestra, method="M",
              psi=MASS::psi.huber, maxit=150),
    error=function(e) NULL
  )
  if (is.null(ajuste)) return(rep(NA_real_, length(coef(modelo_huber))))
  as.numeric(coef(ajuste))
}

# PASO 2. Construir B réplicas con semilla reproducible.
set.seed(504)
replicas <- replicate(as.integer(params$bootstrap), una_replica(1))
rownames(replicas) <- names(coef(modelo_huber))

# PASO 3. Cuantiles 2.5 % y 97.5 % para cada pendiente.
ic_huber <- t(apply(replicas, 1, stats::quantile,
                    probs=c(0.025,0.975), na.rm=TRUE))
tabla_ic <- data.frame(Variable=rownames(ic_huber),
  Estimacion=as.numeric(coef(modelo_huber)),
  LI_95=ic_huber[,1], LS_95=ic_huber[,2])
# PASO 4. Redondear los NÚMEROS, pero conservar la columna de nombres.
# Así se ve a qué coeficiente corresponde cada intervalo.
tabla_ic$Estimacion <- round(tabla_ic$Estimacion, 3)
tabla_ic$LI_95 <- round(tabla_ic$LI_95, 3)
tabla_ic$LS_95 <- round(tabla_ic$LS_95, 3)
print(tabla_ic, row.names=FALSE)

# ---- BLOQUE: evaluar ----

# PASO 1. Funciones de evaluación comunes a todos los algoritmos.
metricas <- function(verdad, prediccion, nombre) {
  stopifnot(length(verdad)==length(prediccion),
            all(is.finite(prediccion)))
  data.frame(Modelo=nombre,
    MAE=mean(abs(verdad-prediccion)),
    RMSE=sqrt(mean((verdad-prediccion)^2)),
    Spearman=unname(cor(verdad,prediccion, method="spearman")))
}
predecir_3 <- function(datos, modelos=list(
  LS=modelo_ls, LAD=modelo_lad, Huber=modelo_huber)) {
  lapply(modelos, function(m) as.numeric(predict(m, newdata=datos)))
}
metricas_tres <- function(datos) {
  pp <- predecir_3(datos)
  do.call(rbind, Map(function(n,p) metricas(datos$score,p,n),
                     names(pp), pp))
}

# PASO 2. Validación y SOLO después prueba, sin volver a ajustar con test.
validacion <- metricas_tres(val)
validacion <- validacion[order(validacion$MAE),]
print(transform(validacion, MAE=round(MAE,4),
                RMSE=round(RMSE,4), Spearman=round(Spearman,4)),
      row.names=FALSE)

# PASO 3. Elegir por MAE de validación, congelar la decisión.
elegido <- validacion$Modelo[1]
cat("Modelo seleccionado con validación:", elegido, "\n")

# PASO 4. Evaluar los tres modelos una única vez sobre prueba.
prueba <- metricas_tres(pru)
prueba <- prueba[order(prueba$MAE),]
print(transform(prueba, MAE=round(MAE,4),
                RMSE=round(RMSE,4), Spearman=round(Spearman,4)),
      row.names=FALSE)

# ---- BLOQUE: lectura-evaluacion ----

# PASO 5. Narrar resultados con cifras reales, NO prediseñadas.
mejor <- validacion[1,]
cat(sprintf(
  "En validación, %s obtuvo el menor MAE (%.4f). Esto equivale a %.3f puntos en la escala STS original de 0 a 5.\n",
  mejor$Modelo, mejor$MAE, 5*mejor$MAE
))
fila_test <- subset(prueba, Modelo==elegido)
cat(sprintf(
  "En prueba, el modelo preseleccionado %s produjo MAE=%.4f, RMSE=%.4f y Spearman=%.3f.\n",
  elegido, fila_test$MAE, fila_test$RMSE, fila_test$Spearman
))

# ---- BLOQUE: comparar-graficamente ----

pp_test <- predecir_3(pru)
# PASO 6. Una regresión sin restricción puede predecir fuera de [0,1].
# Este porcentaje es un diagnóstico, NO una nueva métrica para elegir modelo.
print(data.frame(
  Modelo=names(pp_test),
  Porcentaje_fuera_01=round(100*vapply(pp_test,
    function(p) mean(p < 0 | p > 1), numeric(1)), 2)
), row.names=FALSE)
tabla_errores <- do.call(rbind, lapply(names(pp_test), function(nombre) {
  data.frame(Modelo=nombre, error=abs(pru$score-pp_test[[nombre]]))
}))
ggplot2::ggplot(tabla_errores,
                ggplot2::aes(x=Modelo,y=error,fill=Modelo)) +
  ggplot2::geom_boxplot(outlier.alpha=0.12) +
  ggplot2::scale_fill_manual(values=c(LS=color_ls,LAD=color_lad,Huber=color_huber)) +
  ggplot2::labs(title="Errores en frases que no se usaron para entrenar",
                subtitle="Compare mediana, dispersión y cola de errores",
                x=NULL,y="Error absoluto de predicción") +
  tema() + ggplot2::theme(legend.position="none")

# ---- BLOQUE: experimento-contaminacion ----

# PASO 1. Copia de entrenamiento. La fuente original permanece intacta.
set.seed(1212)
ent_ruido <- ent
n_ruido <- round(nrow(ent_ruido)*params$contaminar)
indices <- sample.int(nrow(ent_ruido), size=n_ruido)

# PASO 2. Invertir artificialmente 0 y 1 para los ejemplos elegidos.
# Es una perturbación deliberadamente fuerte y fácil de explicar.
ent_ruido$score[indices] <- ifelse(ent_ruido$score[indices] >= 0.5, 0, 1)

# PASO 3. Reestimar con EXACTAMENTE las mismas variables.
ajustes_ruido <- list(
  LS=lm(formula_modelo, data=ent_ruido),
  LAD=quantreg::rq(formula_modelo, tau=0.5, data=ent_ruido),
  Huber=MASS::rlm(formula_modelo, method="M",
                   psi=MASS::psi.huber, data=ent_ruido, maxit=200)
)

# PASO 4. Evaluación en validación LIMPIA: varía entrenamiento, no la prueba.
tab_ruido <- do.call(rbind, lapply(names(ajustes_ruido), function(nm)
  metricas(val$score, predict(ajustes_ruido[[nm]],newdata=val), nm)))
comparar_mae <- merge(
  validacion[c("Modelo","MAE")],
  tab_ruido[c("Modelo","MAE")],
  by="Modelo", suffixes=c("_limpio","_ruido")
)
comparar_mae$Cambio <- comparar_mae$MAE_ruido-comparar_mae$MAE_limpio
print(transform(comparar_mae,
  MAE_limpio=round(MAE_limpio,4),
  MAE_ruido=round(MAE_ruido,4),
  Cambio=round(Cambio,4)), row.names=FALSE)

# ---- BLOQUE: red-neuronal-opcional ----

# IMPORTANTE. Este bloque se ejecuta SOLO con params$correr_red: true
# y tras instalar keras3 y un backend compatible (normalmente TensorFlow).
#
# install.packages(c("keras3","reticulate"))
# keras3::install_keras(backend="tensorflow")

if (isTRUE(params$correr_red)) {
  if (!requireNamespace("keras3",quietly=TRUE))
    stop("Instale keras3 y su backend antes de activar la red neuronal.")

  # PASO 1. Utilizar matrices con las MISMAS columnas de regresión clásica.
  Xent <- as.matrix(ent[predictores])
  Xval <- as.matrix(val[predictores])
  Xpru <- as.matrix(pru[predictores])
  yent <- as.numeric(ent$score)
  yval <- as.numeric(val$score)

  # PASO 2. Crear una red pequeña: 3 entradas, 12 y 8 neuronas ocultas.
  crear_red <- function(perdida) {
    keras3::set_random_seed(100)
    red <- keras3::keras_model_sequential(input_shape=c(length(predictores))) |>
      keras3::layer_dense(units=12, activation="relu") |>
      keras3::layer_dense(units=8, activation="relu") |>
      keras3::layer_dense(units=1, activation="sigmoid")
    keras3::compile(red,
      optimizer=keras3::optimizer_adam(learning_rate=0.002),
      loss=perdida,
      metrics=list(keras3::metric_mean_absolute_error()))
    red
  }

  # PASO 3. Definir exactamente tres funciones de pérdida.
  perdidas <- list(
    MSE="mse",
    MAE="mae",
    Huber=function(y_true,y_pred) keras3::loss_huber(y_true,y_pred,delta=0.15)
  )

  # PASO 4. Entrenar con la MISMA validación y parada temprana.
  redes <- list()
  historiales <- list()
  for (nombre in names(perdidas)) {
    red <- crear_red(perdidas[[nombre]])
    hist <- keras3::fit(
      red, Xent, yent,
      validation_data=list(Xval,yval),
      epochs=60, batch_size=32, verbose=0,
      callbacks=list(keras3::callback_early_stopping(
        monitor="val_loss", patience=6, restore_best_weights=TRUE))
    )
    redes[[nombre]] <- red
    historiales[[nombre]] <- hist
  }

  # PASO 5. Comparar las tres redes mediante la MISMA métrica de VALIDACIÓN.
  # val_loss NO sirve para comparar directamente MSE, MAE y Huber: las
  # tres pérdidas tienen escalas diferentes. Aquí el MAE sí es común.
  tabla_redes_val <- do.call(rbind, lapply(names(redes), function(nm) {
    pred <- as.numeric(keras3::predict(redes[[nm]],Xval,verbose=0))
    metricas(yval,pred,paste0("Red_",nm))
  }))
  tabla_redes_val <- tabla_redes_val[order(tabla_redes_val$MAE),]
  print(tabla_redes_val)
  red_elegida <- sub("^Red_", "", tabla_redes_val$Modelo[1])
  cat("Red seleccionada exclusivamente por MAE en validación:",
      red_elegida, "\n")

  # PASO 6. Congelar la selección; usar test como evaluación independiente.
  tabla_redes <- do.call(rbind, lapply(names(redes), function(nm) {
    pred <- as.numeric(keras3::predict(redes[[nm]],Xpru,verbose=0))
    metricas(pru$score,pred,paste0("Red_",nm))
  }))
  print(tabla_redes)

  # PASO 7. Explicar cada salida en la misma escala STS.
  for (j in seq_len(nrow(tabla_redes))) {
    z <- tabla_redes[j,]
    cat(sprintf(
      "%s: MAE de %.4f = %.3f puntos de similitud STS original; RMSE=%.4f; Spearman=%.3f.\n",
      z$Modelo,z$MAE,5*z$MAE,z$RMSE,z$Spearman))
  }
  cat("Resultado de la red seleccionada (NO de la mejor a posteriori en test):\n")
  print(subset(tabla_redes, Modelo==paste0("Red_",red_elegida)))

  # PASO 8. Inspeccionar las últimas épocas de la red seleccionada.
  # Las pérdidas no son métricas intercambiables entre entrenamientos.
  registro <- as.data.frame(historiales[[red_elegida]])
  print(utils::tail(registro, 5))
} else {
  cat("Módulo de red neuronal desactivado para permitir la ejecución rápida.\n")
  cat("Cambie el parámetro YAML correr_red: true cuando instale keras3 y TensorFlow.\n")
}

# ---- BLOQUE: sbert-opcional ----

if (isTRUE(params$correr_sbert)) {
  if (!requireNamespace("reticulate",quietly=TRUE))
    stop("Instale reticulate para activar el módulo Sentence-BERT.")

  # PASO 1. Declarar la dependencia y descargar un modelo preentrenado.
  reticulate::py_require("sentence-transformers")
  st <- reticulate::import("sentence_transformers")
  encoder <- st$SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2",
                                    device="cpu")

  # PASO 2. Procesar una SUBMUESTRA DE VALIDACIÓN, definida antes de mirar resultados.
  set.seed(108)
  filas <- sample.int(nrow(val), min(200L,nrow(val)))
  muestra <- val[filas,,drop=FALSE]
  A <- reticulate::py_to_r(encoder$encode(
    as.list(muestra$sentence1), batch_size=32L, show_progress_bar=FALSE))
  B <- reticulate::py_to_r(encoder$encode(
    as.list(muestra$sentence2), batch_size=32L, show_progress_bar=FALSE))

  # PASO 3. Comparar correlaciones exploratorias sobre validación, no test.
  m <- data.frame(etiqueta=muestra$score,
    cos_glove=muestra$cos_glove,
    cos_sbert=coseno_filas(as.matrix(A),as.matrix(B)))
  print(data.frame(
    Embedding=c("GloVe didáctico","SBERT preentrenado"),
    Spearman=c(cor(m$etiqueta,m$cos_glove,method="spearman"),
               cor(m$etiqueta,m$cos_sbert,method="spearman"))
  ))
} else cat("SBERT opcional: desactivado.\n")

