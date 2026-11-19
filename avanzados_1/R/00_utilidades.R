# =============================================================================
# 00_utilidades.R
# Proyecto: Nivel y dispersion geografica de los precios mayoristas de
#           alimentos en Colombia, 2024 (SIPSA - DANE)
# Autor:    Victor Fabian Novoa Rojas
# Curso:    Analitica / Estadistica avanzada 1 - Maestria en IA, U. de La Sabana
#
# Funciones auxiliares comunes. Solo usa R base (sin paquetes externos).
# =============================================================================

# --- Rutas del proyecto ------------------------------------------------------
# Todos los scripts asumen que el directorio de trabajo es la raiz del proyecto.
RUTA_DATOS   <- file.path("datos")
RUTA_FIGURAS <- file.path("salidas", "figuras")
RUTA_TABLAS  <- file.path("salidas", "tablas")

crear_carpetas <- function() {
  for (p in c(RUTA_DATOS, RUTA_FIGURAS, RUTA_TABLAS)) {
    if (!dir.exists(p)) dir.create(p, recursive = TRUE)
  }
  invisible(TRUE)
}

# --- Paleta de color ---------------------------------------------------------
# Paleta cualitativa sobria, legible y distinguible en escala de grises.
PALETA <- c("#2F6F9F", "#C8553D", "#5B8C5A", "#D4A029",
            "#7D5BA6", "#3E8E8A", "#A65B7B", "#8A8D93")

COL_PRIM <- "#2F6F9F"   # azul principal
COL_SEC  <- "#C8553D"   # terracota (contraste / referencias)
COL_GRIS <- "#8A8D93"

paleta_n <- function(n) rep(PALETA, length.out = n)

# --- Guardado de figuras -----------------------------------------------------
# Envoltura para producir PNG consistentes sin depender de ggplot2.
fig <- function(nombre, expr, ancho = 1800, alto = 1100, res = 170) {
  archivo <- file.path(RUTA_FIGURAS, paste0(nombre, ".png"))
  png(archivo, width = ancho, height = alto, res = res)
  op <- par(mar = c(4.6, 4.6, 3.2, 1.4), mgp = c(2.8, 0.7, 0),
            cex.main = 1.05, font.main = 1, col.axis = "gray25",
            col.lab = "gray15", fg = "gray40", las = 1)
  on.exit({ par(op); dev.off() }, add = TRUE)
  force(expr)
  message("  [figura] ", archivo)
  invisible(archivo)
}

# --- Guardado de tablas ------------------------------------------------------
tabla <- function(nombre, df) {
  archivo <- file.path(RUTA_TABLAS, paste0(nombre, ".csv"))
  write.csv2(df, archivo, row.names = FALSE, fileEncoding = "UTF-8")
  message("  [tabla ] ", archivo)
  invisible(archivo)
}

# --- Estadisticos descriptivos ----------------------------------------------
# Asimetria y curtosis muestrales (coeficientes de Fisher, sin paquetes).
asimetria <- function(x) {
  x <- x[is.finite(x)]; n <- length(x)
  if (n < 3) return(NA_real_)
  m <- mean(x); s <- sqrt(sum((x - m)^2) / n)
  (sum((x - m)^3) / n) / s^3
}

curtosis_exceso <- function(x) {
  x <- x[is.finite(x)]; n <- length(x)
  if (n < 4) return(NA_real_)
  m <- mean(x); s <- sqrt(sum((x - m)^2) / n)
  (sum((x - m)^4) / n) / s^4 - 3
}

# Coeficiente de variacion en porcentaje.
cv_pct <- function(x) {
  x <- x[is.finite(x)]
  if (length(x) < 2 || mean(x) == 0) return(NA_real_)
  100 * sd(x) / mean(x)
}

# Resumen descriptivo completo de un vector numerico.
resumen_num <- function(x, digitos = 2) {
  x <- x[is.finite(x)]
  q <- as.numeric(quantile(x, c(0.25, 0.50, 0.75)))
  data.frame(
    n          = length(x),
    media      = round(mean(x), digitos),
    mediana    = round(q[2], digitos),
    desv_est   = round(sd(x), digitos),
    cv_pct     = round(cv_pct(x), digitos),
    minimo     = round(min(x), digitos),
    q1         = round(q[1], digitos),
    q3         = round(q[3], digitos),
    maximo     = round(max(x), digitos),
    rango_iq   = round(q[3] - q[1], digitos),
    asimetria  = round(asimetria(x), digitos),
    curtosis   = round(curtosis_exceso(x), digitos)
  )
}

# Intervalo de confianza para la media (t de Student).
ic_media <- function(x, conf = 0.95) {
  x <- x[is.finite(x)]; n <- length(x)
  if (n < 2) return(c(inferior = NA, media = NA, superior = NA, n = n))
  ee <- sd(x) / sqrt(n)
  t  <- qt(1 - (1 - conf) / 2, df = n - 1)
  c(inferior = mean(x) - t * ee, media = mean(x), superior = mean(x) + t * ee, n = n)
}

# Regla de Tukey para valores atipicos.
limites_tukey <- function(x, k = 1.5) {
  q <- as.numeric(quantile(x[is.finite(x)], c(0.25, 0.75)))
  ri <- q[2] - q[1]
  c(inferior = q[1] - k * ri, superior = q[2] + k * ri)
}

# --- Formato -----------------------------------------------------------------
fmt_cop <- function(x, dec = 0) {
  paste0("$", formatC(x, format = "f", digits = dec,
                      big.mark = ".", decimal.mark = ","))
}

fmt_pct <- function(x, dec = 1) {
  paste0(formatC(x, format = "f", digits = dec, decimal.mark = ","), "%")
}

# Acorta etiquetas largas para que quepan en los ejes de los graficos.
acortar <- function(x, n = 22) {
  ifelse(nchar(x) > n, paste0(substr(x, 1, n - 1), "…"), x)
}

message("00_utilidades.R cargado.")
