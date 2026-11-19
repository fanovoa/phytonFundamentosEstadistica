# =============================================================================
# ejecutar_todo.R
#
# Reproduce el proyecto completo de punta a punta.
# Ejecutar desde la raiz del proyecto:  source("ejecutar_todo.R")
#
# Requisitos: solo R base. El informe en .Rmd requiere ademas rmarkdown.
# =============================================================================

t0 <- Sys.time()

cat("\n>>> 1/3  Carga y enriquecimiento de los datos\n")
source(file.path("R", "01_carga_y_enriquecimiento.R"))

cat("\n>>> 2/3  Analisis exploratorio (figuras y tablas)\n")
log_aed <- file.path("salidas", "log_aed.txt")
con <- file(log_aed, open = "wt", encoding = "UTF-8")
sink(con, split = TRUE)            # resultados por consola y por archivo
sink(con, type = "message")        # avisos de figuras y tablas guardadas
source(file.path("R", "02_analisis_exploratorio.R"))
sink(type = "message"); sink(); close(con)
cat("Salida de consola guardada en", log_aed, "\n")

cat("\n>>> 3/3  Informe\n")
if (requireNamespace("rmarkdown", quietly = TRUE)) {
  rmarkdown::render(file.path("informe", "informe_fase1.Rmd"),
                    output_dir = "informe", quiet = TRUE)
  cat("Informe generado en informe/informe_fase1.html\n")
} else {
  cat("El paquete 'rmarkdown' no esta instalado; se omite la generacion del\n",
      "informe HTML. Instalelo con install.packages('rmarkdown') o consulte\n",
      "el informe ya renderizado que acompana al proyecto.\n", sep = "")
}

cat("\nProceso completo en",
    round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1), "segundos.\n")
