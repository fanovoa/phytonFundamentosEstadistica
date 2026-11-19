# ================================================================
# PRÁCTICA 4 · Descarga ALTERNATIVA oficial de STS Benchmark
# ================================================================
# PROPÓSITO
#   Algunos proveedores bloquean o ralentizan la redirección de sbert.net.
#   Este script obtiene las tres particiones oficiales desde Hugging Face,
#   usando únicamente código R, y prepara un TSV comprimido compatible con
#   los demás laboratorios.
#
# REQUISITO (ejecutar una sola vez en la consola de R):
#   install.packages(c("nanoparquet", "readr"))
#
# USO desde la carpeta S4_IA_Regresion:
#   source("S4_Descarga_Alternativa_STS.R")
#
# También acepta una ruta de salida personalizada cuando se usa Rscript:
#   Rscript S4_Descarga_Alternativa_STS.R /tmp/sts_verificacion.tsv.gz
#
# Datos oficiales: https://huggingface.co/datasets/sentence-transformers/stsb
# Puntuación YA normalizada entre 0 y 1 (NO dividir de nuevo por 5).
# ================================================================

# PASO 1. Comprobar bibliotecas disponibles.
for (paquete in c("nanoparquet", "readr")) {
  if (!requireNamespace(paquete, quietly=TRUE)) {
    stop("Instale antes: install.packages(\"",paquete,"\")")
  }
}

# PASO 2. Elegir el archivo que leen los otros cuadernos.
argumentos <- commandArgs(trailingOnly=TRUE)
destino <- if (length(argumentos)) argumentos[[1]] else
  file.path("datos","stsbenchmark.tsv.gz")
dir.create(dirname(destino),showWarnings=FALSE,recursive=TRUE)
# Evitar descargas innecesarias y conservar cualquier archivo ya existente.
if (file.exists(destino)) {
  stop("Ya existe el archivo de salida: ", destino,
       ". Elija una ruta nueva o verifique el archivo existente.")
}

# PASO 3. Una URL oficial por partición: nunca reordenamos ni resegmentamos.
particiones <- c("train","validation","test")
base_url <- paste0(
  "https://huggingface.co/datasets/sentence-transformers/stsb/",
  "resolve/main/data/")

# PASO 4. Descargar temporalmente cada archivo en su formato Parquet original.
leer_parte <- function(etiqueta) {
  archivo <- tempfile(fileext=".parquet")
  on.exit(unlink(archivo),add=TRUE)
  direccion <- paste0(base_url,etiqueta,"-00000-of-00001.parquet")
  es_parquet <- function(f) {
    file.exists(f) && file.info(f)$size>=1000 &&
      identical(readBin(f,what="raw",n=4L),charToRaw("PAR1"))
  }
  # Algunos entornos aislados de R no encuentran los certificados HTTPS.
  # Probamos primero la vía normal y, si falla, el ejecutable curl.
  descargado <- tryCatch({
    suppressWarnings(utils::download.file(
      direccion,destfile=archivo,mode="wb",quiet=TRUE))
    es_parquet(archivo)
  },error=function(e) FALSE)
  if (!isTRUE(descargado)) {
    utils::download.file(direccion,destfile=archivo,method="curl",
                         mode="wb",extra="--location",quiet=TRUE)
  }
  if (!es_parquet(archivo)) {
    stop("La descarga oficial está incompleta para: ", etiqueta)
  }

  # PASO 5. Convertir a tabla R sin depender de Python ni de Arrow.
  datos <- nanoparquet::read_parquet(archivo)
  stopifnot(all(c("sentence1","sentence2","score") %in% names(datos)))
  data.frame(
    split=rep(etiqueta,nrow(datos)),
    sentence1=as.character(datos$sentence1),
    sentence2=as.character(datos$sentence2),
    score=as.numeric(datos$score),
    stringsAsFactors=FALSE
  )
}

# PASO 6. Combinar las tres particiones manteniendo su identidad.
datos_sts <- do.call(rbind,lapply(particiones,leer_parte))
stopifnot(nrow(datos_sts)==5749+1500+1379,
          all(is.finite(datos_sts$score)),
          all(datos_sts$score>=0 & datos_sts$score<=1))

# PASO 7. Guardar un archivo que readr::read_tsv() podrá leer directamente.
# Un archivo de salida existente se conserva: jamás lo reemplazamos a ciegas.
# quote="all" es esencial: algunas frases contienen comillas dobles.
# Sin comillas delimitadoras, write_tsv con quote="none" duplicaría los
# signos y alteraría silenciosamente el texto al releerlo.
readr::write_tsv(datos_sts, destino, quote="all", escape="double")

# PASO 8. Leer de vuelta y verificar que ninguna oración/puntuación se perdió.
comprobacion <- readr::read_tsv(
  destino, col_types=readr::cols(.default=readr::col_character()),
  progress=FALSE,show_col_types=FALSE,trim_ws=FALSE)
stopifnot(nrow(comprobacion)==nrow(datos_sts),
          identical(unique(comprobacion$split),particiones),
          identical(comprobacion$sentence1, datos_sts$sentence1),
          identical(comprobacion$sentence2, datos_sts$sentence2),
          max(abs(as.numeric(comprobacion$score)-datos_sts$score))<1e-12)

cat("Archivo listo:",destino,"\n")
print(data.frame(Particion=particiones,
                 Pares=as.integer(table(factor(datos_sts$split,
                                                levels=particiones)))))
cat("La escala de score ya es [0,1]; no necesita normalización adicional.\n")
