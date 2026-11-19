# ================================================================
# SESIÓN 4 · Métodos de regresión e inteligencia artificial
# Código R extraído del cuaderno: S4_Ampliacion_CLEAR.Rmd
# Ejecutar desde la carpeta S4_IA_Regresion de forma secuencial.
# Cada bloque está explicado con detalle en el archivo R Markdown.
# ================================================================

# ---- BLOQUE: clear-setup ----

knitr::opts_chunk$set(echo=TRUE, warning=FALSE, message=FALSE,
                      fig.align="center", fig.width=10, fig.height=5.4, dev="svg")
necesarios <- c("readxl","ggplot2","quantreg","MASS","knitr")
faltantes <- necesarios[!vapply(necesarios,requireNamespace,logical(1),quietly=TRUE)]
if (length(faltantes))
  stop("Instale antes los paquetes: ", paste(faltantes,collapse=", "))
dir.create("datos",showWarnings=FALSE)
set.seed(20261116)

# ---- BLOQUE: clear-datos ----

# PASO 1. Descargar el archivo del repositorio ORIGINAL de los autores.
destino <- "datos/CLEAR_corpus_final.xlsx"
if (!file.exists(destino)) {
  # mode="wb" evita que se alteren los bytes de un archivo Excel.
  download.file(
    "https://raw.githubusercontent.com/scrosseye/CLEAR-Corpus/main/CLEAR_corpus_final.xlsx",
    destfile=destino, mode="wb", quiet=TRUE
  )
}

# PASO 2. Leer los nombres tal como aparecen en la hoja de cálculo.
raw <- readxl::read_xlsx(destino)
# dim() muestra: (número de filas, número de columnas).
print(dim(raw))
# names() enumera los títulos originales; NO son estimaciones estadísticas.
print(names(raw))

# PASO 3. Extraer exactamente la respuesta y las variables de contexto.
columnas <- c("Excerpt","BT_easiness","Google WC","Sentence Count",
              "Paragraphs","Categ","s.e.")
stopifnot(all(columnas %in% names(raw)))
# data.frame() construye una tabla usando columnas del archivo.
# as.character() guarda texto; as.numeric() guarda cantidades numéricas.
dat <- data.frame(
  texto=as.character(raw[["Excerpt"]]),
  facilidad=as.numeric(raw[["BT_easiness"]]),
  palabras=as.numeric(raw[["Google WC"]]),
  oraciones=as.numeric(raw[["Sentence Count"]]),
  parrafos=as.numeric(raw[["Paragraphs"]]),
  categoria=as.character(raw[["Categ"]]),
  error_etiqueta=as.numeric(raw[["s.e."]])
)
dat <- dat[complete.cases(dat[c("texto","facilidad","palabras",
                                 "oraciones","parrafos")]),]
# Eliminar conteos no positivos que impedirían dividir palabras/oraciones.
dat <- dat[dat$palabras>0 & dat$oraciones>0 & dat$parrafos>0,]

# PASO 4. Inspección estadística transparente.
cat("Fragmentos con datos utilizables:",nrow(dat),"\n")
print(summary(dat[c("facilidad","palabras","oraciones","parrafos")]))
print(table(dat$categoria, useNA="ifany"))
print(summary(dat$error_etiqueta))

# ---- BLOQUE: clear-ejemplos ----

# PASO 5. Inspeccionar ejemplos contrastantes SIN eliminar el contenido textual.
# order() devuelve posiciones en orden de facilidad creciente.
ord <- order(dat$facilidad)
# head(ord,2) = primeras dos posiciones; tail(ord,2) = últimas dos.
ejemplos <- dat[c(head(ord,2),tail(ord,2)),
                c("facilidad","palabras","oraciones","texto")]
# Recortar SOLO la visualización: 130 caracteres, no la fuente original.
ejemplos$texto <- substr(ejemplos$texto, 1, 130)
print(ejemplos, row.names=FALSE)

# ---- BLOQUE: clear-sintaxis-inicial ----

# Crear dos ejemplos didácticos: NO son filas del corpus oficial.
mini_textos <- c("El sol sale.","La luna ilumina la noche.")
# strsplit() divide cada cadena siguiendo una expresión de separación.
print(strsplit(mini_textos," "))
# nchar() cuenta caracteres; aquí contamos los de la primera frase completa.
print(nchar(mini_textos[1]))
# c() y data.frame() permiten armar una tabla pequeña con dos columnas.
mini_tabla <- data.frame(texto=mini_textos,oraciones=c(1,1))
print(mini_tabla,row.names=FALSE)

# ---- BLOQUE: clear-features ----

# PASO 1. Una función de R que cuenta longitud media de palabra.
promedio_long_palabra <- function(texto) {
  # Convertir todas las letras en minúsculas.
  # Separar donde aparezcan caracteres que NO sean letras.
  tokens <- unlist(strsplit(tolower(texto),"[^[:alpha:]]+"))
  # nzchar(token) es TRUE si el token no está vacío.
  tokens <- tokens[nzchar(tokens)]
  # Si el texto no contiene letras reconocibles, declarar NA.
  if (!length(tokens)) return(NA_real_)
  # nchar() cuenta las letras de CADA token; mean() calcula la media.
  mean(nchar(tokens))
}

# PASO 2. Crear rasgos cuantitativos; usar log evita escalas muy distintas.
# log1p(w) es igual a log(1+w); NO es log(w).
dat$log_palabras <- log1p(dat$palabras)
# La división se realiza fila a fila para todo el vector numérico.
dat$palabras_por_oracion <- dat$palabras/dat$oraciones
# Repetir la función: un único promedio numérico para CADA texto.
dat$long_palabra <- vapply(dat$texto,promedio_long_palabra,numeric(1))
# Quitar filas incompletas antes de separar los conjuntos.
dat <- dat[complete.cases(dat[c("facilidad","log_palabras",
                                "palabras_por_oracion","long_palabra")]),]

# PASO 3. Reservar entrenamiento, validación y prueba ANTES de estimar.
set.seed(523)
# Mezclar posiciones de filas, de 1 a nrow(dat), sin cambiar su contenido.
orden <- sample.int(nrow(dat))
# floor() redondea hacia abajo el 70 % y el 15 % de textos.
n_ent <- floor(.70*nrow(dat))
n_val <- floor(.15*nrow(dat))
# Indices de train, valid y test no se repiten ni se traslapan.
train <- dat[orden[seq_len(n_ent)],]
valid <- dat[orden[seq.int(n_ent+1,n_ent+n_val)],]
test  <- dat[orden[seq.int(n_ent+n_val+1,nrow(dat))],]
print(data.frame(Particion=c("Train","Validacion","Test"),
                 Textos=c(nrow(train),nrow(valid),nrow(test))))

# ---- BLOQUE: clear-grafico ----

ggplot2::ggplot(train,ggplot2::aes(x=long_palabra,y=facilidad)) +
  ggplot2::geom_point(alpha=.25,color="#2788EF") +
  ggplot2::geom_smooth(method="lm",colour="#EA4C91",se=FALSE,linewidth=1.2) +
  ggplot2::labs(title="La longitud de palabra explica una parte del problema",
                x="Longitud media de palabra",y="Facilidad relativa de lectura") +
  ggplot2::theme_minimal(base_size=14)

# ---- BLOQUE: clear-ajustar ----

# PASO 1. Todas las técnicas reciben la misma fórmula múltiple.
f <- facilidad ~ log_palabras + palabras_por_oracion + long_palabra

# PASO 2. Ajustar cada método SOLO con textos de entrenamiento.
# lm() estima los coeficientes mediante mínimos cuadrados.
m_ls <- lm(f, data=train)
# rq(...,tau=.5) estima el cuantil 0.5, es decir, la mediana.
m_lad <- quantreg::rq(f, tau=.5, data=train)
# rlm() usa estimación robusta M; psi.huber limita influencia de
# residuos grandes, después de ajustar por su escala robusta.
m_huber <- MASS::rlm(f,data=train,method="M",
                     psi=MASS::psi.huber,maxit=200)

# PASO 3. Imprimir las tres salidas.
# summary() no vuelve a entrenar: resume el modelo ya ajustado.
summary(m_ls)
# se="boot" pide incertidumbre por remuestreo; R=150 repeticiones.
summary(m_lad,se="boot",R=150)
# La salida robusta no debe leerse como tabla clásica de valores p.
summary(m_huber)

# ---- BLOQUE: clear-interpretar ----

# PASO 4. Imprimir frases con valores REALES calculados por los estudiantes.
# for (nom in c(...)) recorre los nombres de los tres predictores.
for (nom in c("log_palabras","palabras_por_oracion","long_palabra")) {
  # coef(m_ls)[[nom]] extrae el valor estimado del coeficiente de "nom".
  # sprintf("%+.4f",valor) escribe signo y cuatro decimales.
  cat(sprintf(
    "LS: si %s aumenta una unidad con las demás constantes, la facilidad estimada cambia %+.4f puntos CLEAR.\n",
    nom, coef(m_ls)[[nom]]
  ))
}
cat(sprintf("R² ajustado LS en entrenamiento: %.3f.\n",
            summary(m_ls)$adj.r.squared))
cat(sprintf("Escala robusta interna de Huber: %.3f.\n",m_huber$s))

# ---- BLOQUE: clear-perfil-referencia ----

# PASO 1. Un data.frame con UNA fila y los nombres exactos de la fórmula.
perfil <- data.frame(
  log_palabras=median(train$log_palabras),
  palabras_por_oracion=median(train$palabras_por_oracion),
  long_palabra=median(train$long_palabra))
print(round(perfil,3))

# PASO 2. Predecir usando cada modelo YA entrenado.
# newdata=perfil significa: pronosticar ese nuevo conjunto de rasgos.
pred_perfil <- data.frame(
  Modelo=c("LS","LAD","Huber"),
  Facilidad_predicha=c(
    as.numeric(predict(m_ls,newdata=perfil)),
    as.numeric(predict(m_lad,newdata=perfil)),
    as.numeric(predict(m_huber,newdata=perfil))))
print(transform(pred_perfil,
                Facilidad_predicha=round(Facilidad_predicha,3)),
      row.names=FALSE)

# ---- BLOQUE: clear-metricas ----

# PASO 1. Métricas en la unidad original del índice CLEAR.
# y = valores humanos; p = predicciones; nom = nombre del modelo.
evaluar <- function(y,p,nom) data.frame(
  Modelo=nom,MAE=mean(abs(y-p)),
  RMSE=sqrt(mean((y-p)^2)),
  Spearman=unname(cor(y,p,method="spearman")))

# PASO 2. Guardar modelos diferentes dentro de UNA lista con nombres.
modelos <- list(LS=m_ls,LAD=m_lad,Huber=m_huber)
tabla_para <- function(base) {
  # lapply() aplica la MISMA función de evaluación a los tres modelos.
  # predict(...,newdata=base) NO vuelve a entrenar coeficientes.
  # do.call(rbind,...) apila las filas de resultados.
  do.call(rbind, lapply(names(modelos),function(nom)
    evaluar(base$facilidad, as.numeric(predict(modelos[[nom]],newdata=base)),
            nom)))
}
# Validación: ordenar por menor MAE (nuestro criterio decidido de antemano).
valores_valid <- tabla_para(valid)
print(valores_valid[order(valores_valid$MAE),],row.names=FALSE)
# which.min() devuelve la posición del valor MAE más pequeño.
elegido <- valores_valid$Modelo[which.min(valores_valid$MAE)]
cat("Elegido por MAE de validación:",elegido,"\n")

# PASO 2. Abrir test después de congelar la elección.
valores_test <- tabla_para(test)
print(valores_test[order(valores_test$MAE),],row.names=FALSE)

# ---- BLOQUE: clear-ruido ----

# PASO 1. Copiar etiquetas para simular contaminación SOLO en train.
set.seed(771)
# Una copia distinta evita alterar las etiquetas originales.
train_ruido <- train
# sample.int() elige posiciones sin repetición por defecto.
filas_ruido <- sample.int(nrow(train_ruido),round(.08*nrow(train_ruido)))

# PASO 2. Sumar de forma artificial una perturbación de gran tamaño.
# La base oficial NO contiene esta columna y NO se edita el archivo descargado.
# sd() calcula la desviación estándar en la escala de facilidad.
tam <- 3*sd(train$facilidad)
# sample(c(-tam,tam), ...,replace=TRUE) selecciona un signo para cada fila.
train_ruido$facilidad[filas_ruido] <- train_ruido$facilidad[filas_ruido]+
  sample(c(-tam,tam),length(filas_ruido),replace=TRUE)

# PASO 3. Repetir los tres métodos con entradas idénticas.
# Los textos y las características NO cambian; solo algunas etiquetas train.
ruido <- list(
  LS=lm(f,data=train_ruido),
  LAD=quantreg::rq(f,tau=.5,data=train_ruido),
  Huber=MASS::rlm(f,data=train_ruido,psi=MASS::psi.huber,
                   method="M",maxit=200))
resultado_ruido <- do.call(rbind,lapply(names(ruido),function(nom)
  evaluar(valid$facilidad,predict(ruido[[nom]],newdata=valid),nom)))
# merge() empareja cada método original con su versión perturbada.
comparacion <- merge(valores_valid[c("Modelo","MAE")],
                     resultado_ruido[c("Modelo","MAE")],
                     by="Modelo",suffixes=c("_original","_simulado"))
# Una resta positiva indica aumento de error en la validación LIMPIA.
comparacion$deterioro <- comparacion$MAE_simulado-comparacion$MAE_original
print(comparacion,row.names=FALSE)

