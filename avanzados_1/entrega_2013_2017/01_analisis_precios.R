# =============================================================================
# 01_analisis_precios.R
#
# Actividad evaluable 1 - Metodos estadisticos avanzados 1 (Unidad 2)
# Tema 2: "Cual es el precio justo? Analisis de precios en el mercado local"
#
# Fuente: DANE - SIPSA, precios mayoristas mensuales 2013-2017.
#
# Ejecutar desde la carpeta entrega_2013_2017:
#     source("01_analisis_precios.R")
#
# Requisitos: SOLO R base. No instala ni carga ningun paquete.
#   En este equipo no estan disponibles dplyr, ggplot2 ni readxl; ademas el
#   proyecto hermano de la carpeta superior ya adopta la politica de R base.
#   Los cinco graficos que exige la guia -barras, sectores, histograma, caja
#   y dispersion- son funciones de R base: barplot, pie, hist, boxplot, plot.
# =============================================================================

options(stringsAsFactors = FALSE, OutDec = ".", scipen = 999)

RUTA_CSV  <- file.path("datos", "mensual_2013_2017.csv")
RUTA_XLSX <- "C:/Users/victor.novoa/Downloads/Mensual_2013_2017.xlsx"
DIR_FIG   <- file.path("salidas", "figuras")
DIR_TAB   <- file.path("salidas", "tablas")
dir.create(DIR_FIG, recursive = TRUE, showWarnings = FALSE)
dir.create(DIR_TAB, recursive = TRUE, showWarnings = FALSE)

titulo <- function(x) cat("\n\n", strrep("=", 78), "\n", x, "\n",
                          strrep("=", 78), "\n", sep = "")
guardar_tabla <- function(x, archivo) {
  write.csv(x, file.path(DIR_TAB, archivo), row.names = FALSE, fileEncoding = "UTF-8")
  message("  tabla guardada: ", archivo)
}
abrir_fig <- function(archivo, ancho = 1500, alto = 950) {
  png(file.path(DIR_FIG, archivo), width = ancho, height = alto, res = 150)
}
cerrar_fig <- function(archivo) { dev.off(); message("  figura guardada: ", archivo) }

# Paleta estable para todo el analisis. Los colores codifican informacion,
# no son decorativos; se declaran una sola vez.
COL_GRUPO <- c(
  "PROCESADOS"                    = "#1B6CA8",
  "CARNES"                        = "#8C2D04",
  "PESCADOS"                      = "#3690C0",
  "LACTEOS Y HUEVOS"              = "#F0A202",
  "FRUTAS"                        = "#D81B60",
  "VERDURAS Y HORTALIZAS"         = "#2E8B57",
  "GRANOS Y CEREALES"             = "#7B5AA6",
  "TUBERCULOS, RAICES Y PLATANOS" = "#B8860B")
COL_MERCADO <- c("Central mayorista urbana"   = "#1B6CA8",
                 "Mercado municipal / acopio" = "#E8871A")

# Nombres cortos solo para las etiquetas de los ejes: la categoria completa
# "TUBERCULOS, RAICES Y PLATANOS" no cabe en el margen del grafico.
ETIQUETA_GRUPO <- c(
  "PROCESADOS"                    = "PROCESADOS",
  "CARNES"                        = "CARNES",
  "PESCADOS"                      = "PESCADOS",
  "LACTEOS Y HUEVOS"              = "LACTEOS Y HUEVOS",
  "FRUTAS"                        = "FRUTAS",
  "VERDURAS Y HORTALIZAS"         = "VERDURAS Y HORTALIZAS",
  "GRANOS Y CEREALES"             = "GRANOS Y CEREALES",
  "TUBERCULOS, RAICES Y PLATANOS" = "TUBERCULOS Y PLATANOS")


# =============================================================================
titulo("1. CARGA DE LOS DATOS")
# =============================================================================
# El insumo original es un .xlsx. Como readxl no esta disponible en este
# equipo, se trabaja sobre una exportacion a CSV UTF-8 del mismo archivo.
# Si quien reproduce el analisis tiene readxl, se lee el .xlsx directamente:
# ambas rutas producen exactamente el mismo data.frame.

if (requireNamespace("readxl", quietly = TRUE) && file.exists(RUTA_XLSX)) {
  base <- as.data.frame(readxl::read_excel(RUTA_XLSX, sheet = "Anexar1"))
  cat("Origen: archivo .xlsx original mediante readxl.\n")
} else {
  base <- read.csv(RUTA_CSV, encoding = "UTF-8")
  cat("Origen: exportacion CSV UTF-8 del .xlsx original.\n")
}
names(base) <- trimws(names(base))   # el encabezado "Precio " trae un espacio
base$Fecha  <- as.Date(base$Fecha)

cat("Dimensiones:", nrow(base), "filas x", ncol(base), "columnas\n\n")
cat("Nombres de las variables:\n"); print(names(base))
cat("\nEstructura (str):\n");        str(base)
cat("\nPrimeras 6 filas (head):\n"); print(head(base, 6))
cat("\nUltimas 6 filas (tail):\n");  print(tail(base, 6))
cat("\nResumen automatico (summary):\n"); print(summary(base))


# =============================================================================
titulo("2. CONTROL DE CALIDAD DE LOS DATOS")
# =============================================================================
# Se verifica antes de calcular cualquier estadistico. Los diagnosticos se
# REGISTRAN como informacion; no se usan como aserciones que aborten el script.

n_na   <- sum(is.na(base))
n_dup  <- sum(duplicated(base[, c("Fecha", "Producto", "Fuente")]))
n_neg  <- sum(base$Precio <= 0)
meses  <- sort(unique(base$Fecha))
huecos <- length(seq(min(meses), max(meses), by = "month")) - length(meses)

cat("Valores faltantes (NA) en toda la base .......", n_na, "\n")
cat("Duplicados exactos (Fecha,Producto,Fuente) ...", n_dup, "\n")
cat("Precios menores o iguales a cero .............", n_neg, "\n")
cat("Meses observados .............................", length(meses),
    "(", format(min(meses), "%Y-%m"), "a", format(max(meses), "%Y-%m"), ")\n")
cat("Meses faltantes en la secuencia ..............", huecos, "\n")

# Inconsistencia de tildes detectada en el campo Fuente: el mismo municipio
# aparece escrito de dos formas. Se unifica para no partir la misma plaza en dos.
antes <- length(unique(base$Fuente))
base$Fuente[base$Fuente == "Ancuy\u00e1 (Nari\u00f1o)"] <- "Ancuya (Nari\u00f1o)"
cat("Fuentes antes de unificar tildes .............", antes, "\n")
cat("Fuentes despues de unificar tildes ...........", length(unique(base$Fuente)),
    "(se unifico Ancuya / Ancuya, con y sin tilde)\n")

cat("\nEstado de completitud:",
    if (n_na == 0 && n_dup == 0 && n_neg == 0) "BASE COMPLETA Y CONSISTENTE"
    else "REVISAR", "\n")


# =============================================================================
titulo("3. VARIABLES CUALITATIVAS DERIVADAS: departamento, region, tipo de mercado")
# =============================================================================
# El campo Fuente usa dos convenciones del SIPSA:
#   "Ciudad, Plaza"            -> ciudad capital o principal  (central mayorista)
#   "Municipio (Departamento)" -> municipio no capital        (mercado municipal)
# De ahi se derivan el departamento, la region natural y el tipo de mercado.

CAPITAL_A_DEPTO <- c(
  "Armenia" = "Quind\u00edo", "Barranquilla" = "Atl\u00e1ntico",
  "Bogot\u00e1, D.C." = "Bogot\u00e1 D.C.", "Bucaramanga" = "Santander",
  "Cali" = "Valle del Cauca", "Cartagena" = "Bol\u00edvar",
  "C\u00facuta" = "Norte de Santander", "Ibagu\u00e9" = "Tolima",
  "Manizales" = "Caldas", "Medell\u00edn" = "Antioquia", "Monter\u00eda" = "C\u00f3rdoba",
  "Neiva" = "Huila", "Pasto" = "Nari\u00f1o", "Pereira" = "Risaralda",
  "Popay\u00e1n" = "Cauca", "San Marcos" = "Sucre", "Sincelejo" = "Sucre",
  "Tunja" = "Boyac\u00e1", "Valledupar" = "Cesar", "Villavicencio" = "Meta")

DEPTO_A_REGION <- c(
  "Atl\u00e1ntico" = "Caribe", "Bol\u00edvar" = "Caribe", "Cesar" = "Caribe",
  "C\u00f3rdoba" = "Caribe", "Magdalena" = "Caribe", "Sucre" = "Caribe",
  "Antioquia" = "Andina", "Boyac\u00e1" = "Andina", "Caldas" = "Andina",
  "Cundinamarca" = "Andina", "Bogot\u00e1 D.C." = "Andina", "Huila" = "Andina",
  "Norte de Santander" = "Andina", "Quind\u00edo" = "Andina", "Risaralda" = "Andina",
  "Santander" = "Andina", "Tolima" = "Andina",
  "Cauca" = "Pac\u00edfica", "Nari\u00f1o" = "Pac\u00edfica", "Valle del Cauca" = "Pac\u00edfica",
  "Choc\u00f3" = "Pac\u00edfica",
  "Arauca" = "Orinoqu\u00eda-Amazon\u00eda", "Casanare" = "Orinoqu\u00eda-Amazon\u00eda",
  "Meta" = "Orinoqu\u00eda-Amazon\u00eda", "Caquet\u00e1" = "Orinoqu\u00eda-Amazon\u00eda")

extraer_depto <- function(fuente) {
  entre_parentesis <- sub(".*\\(([^)]+)\\).*", "\\1", fuente)
  tiene_parentesis <- grepl("\\(.*\\)", fuente)
  ciudad <- trimws(sub(",.*$", "", fuente))
  # "Bogota, D.C., Corabastos": el nombre de la ciudad incluye la coma de D.C.
  ciudad[grepl("^Bogot\u00e1", fuente)] <- "Bogot\u00e1, D.C."
  ifelse(tiene_parentesis, entre_parentesis, unname(CAPITAL_A_DEPTO[ciudad]))
}

fuentes <- unique(base$Fuente)
mapa <- data.frame(
  Fuente       = fuentes,
  departamento = extraer_depto(fuentes),
  tipo_mercado = ifelse(grepl("\\(.*\\)", fuentes),
                        "Mercado municipal / acopio", "Central mayorista urbana"))
mapa$region <- unname(DEPTO_A_REGION[mapa$departamento])

cat("Fuentes totales ...............", nrow(mapa), "\n")
cat("Sin departamento asignado .....", sum(is.na(mapa$departamento)), "\n")
cat("Sin region asignada ...........", sum(is.na(mapa$region)), "\n")
stopifnot(!any(is.na(mapa$departamento)), !any(is.na(mapa$region)))
cat("\nFuentes por tipo de mercado:\n"); print(table(mapa$tipo_mercado))
cat("\nFuentes por region:\n");          print(table(mapa$region))

base <- merge(base, mapa, by = "Fuente", all.x = TRUE)
guardar_tabla(mapa[order(mapa$region, mapa$departamento), ], "00_diccionario_fuentes.csv")


# =============================================================================
titulo("4. DISENO: DE 281.386 FILAS A 451 UNIDADES DE ANALISIS")
# =============================================================================
# Una fila de la base es un producto x mes x plaza: NO es una observacion
# independiente. La misma serie reaparece 60 veces. Antes de describir hay que
# decidir cual es la unidad de analisis. Aqui la unidad es la SERIE
# PLAZA-PRODUCTO, y el tiempo se colapsa en resumenes de esa serie.

CANASTA <- c(
  "Tomate de \u00e1rbol", "Mora de Castilla",                # frutas
  "Piment\u00f3n", "Habichuela", "Cilantro",                  # verduras y hortalizas
  "Pl\u00e1tano hart\u00f3n verde", "Papa criolla limpia",         # tuberculos
  "Sal yodada", "Harina de trigo",                      # procesados
  "Lenteja importada", "Arroz de primera",              # granos y cereales
  "Carne de res, sobrebarriga", "Pechuga de pollo",     # carnes
  "Queso coste\u00f1o", "Huevo rojo AA",                     # lacteos y huevos
  "Bocachico importado congelado")                      # pescados

sub_base <- base[base$Producto %in% CANASTA, ]
sub_base$serie <- paste(sub_base$Producto, sub_base$Fuente, sep = " @ ")

meses_por_serie  <- table(sub_base$serie)
series_completas <- names(meses_por_serie)[meses_por_serie == 60]
panel <- sub_base[sub_base$serie %in% series_completas, ]

cat("Productos de la canasta .............", length(CANASTA), "\n")
cat("Series producto-plaza candidatas ....", length(meses_por_serie), "\n")
cat("Series con los 60 meses completos ...", length(series_completas), "\n")
cat("Filas del panel balanceado ..........", nrow(panel), "\n")
stopifnot(nrow(panel) == length(series_completas) * 60)
cat("Verificacion de panel balanceado ....  TRUE  (",
    length(series_completas), "series x 60 meses )\n")

# --- Colapso: una fila por serie -------------------------------------------
agregar <- function(df) {
  p <- df$Precio
  anual <- tapply(p, format(df$Fecha, "%Y"), mean)
  data.frame(
    Producto        = df$Producto[1],
    Fuente          = df$Fuente[1],
    Grupo           = df$Grupo[1],
    region          = df$region[1],
    tipo_mercado    = df$tipo_mercado[1],
    departamento    = df$departamento[1],
    precio_promedio = mean(p),
    precio_mediano  = median(p),
    desv_est        = sd(p),
    precio_min      = min(p),
    precio_max      = max(p),
    rango           = max(p) - min(p),
    volatilidad_cv  = 100 * sd(p) / mean(p),
    variacion_13_17 = 100 * (anual[["2017"]] / anual[["2013"]] - 1))
}
unidades <- do.call(rbind, lapply(split(panel, panel$serie), agregar))
rownames(unidades) <- NULL
unidades$Grupo        <- factor(unidades$Grupo)
unidades$region       <- factor(unidades$region)
unidades$tipo_mercado <- factor(unidades$tipo_mercado)

cat("\nUNIDAD DE ANALISIS: serie plaza-producto.  n =", nrow(unidades), "\n\n")
str(unidades)
guardar_tabla(unidades, "01_unidades_analisis.csv")


# =============================================================================
titulo("5. VARIABLES CUANTITATIVAS: LAS OCHO MEDIDAS QUE EXIGE LA GUIA")
# =============================================================================
# La moda puntual no informa en variables continuas (casi ningun valor se
# repite). Se reporta la CLASE MODAL de la tabla de frecuencias agrupada por la
# regla de Sturges: k = techo(log2(n) + 1) intervalos de igual amplitud.

clase_modal <- function(x) {
  k <- ceiling(log2(length(x)) + 1)
  cortes <- seq(min(x), max(x), length.out = k + 1)
  tab <- table(cut(x, breaks = cortes, include.lowest = TRUE, right = TRUE))
  names(tab)[which.max(tab)]
}
coef_asimetria <- function(x) {
  m <- mean(x); m2 <- mean((x - m)^2); m3 <- mean((x - m)^3); m3 / m2^(3 / 2)
}
exceso_curtosis <- function(x) {
  m <- mean(x); m2 <- mean((x - m)^2); m4 <- mean((x - m)^4); m4 / m2^2 - 3
}
n_atipicos <- function(x) {
  q <- quantile(x, c(.25, .75)); i <- q[2] - q[1]
  sum(x < q[1] - 1.5 * i | x > q[2] + 1.5 * i)
}
describir <- function(x, nombre) {
  data.frame(
    variable = nombre, n = length(x),
    media = mean(x), mediana = median(x), clase_modal = clase_modal(x),
    minimo = min(x), maximo = max(x), rango = max(x) - min(x),
    desv_estandar = sd(x), varianza = var(x),
    q1 = unname(quantile(x, .25)), q3 = unname(quantile(x, .75)), IQR = IQR(x),
    asimetria = coef_asimetria(x), exceso_curtosis = exceso_curtosis(x),
    atipicos_1_5_IQR = n_atipicos(x))
}

resumen_cuant <- rbind(
  describir(unidades$volatilidad_cv,  "volatilidad_cv (%)"),
  describir(unidades$variacion_13_17, "variacion_2013_2017 (%)"))
print(t(resumen_cuant), quote = FALSE)
guardar_tabla(resumen_cuant, "02_medidas_cuantitativas.csv")

cat("\nLectura:\n")
cat("- volatilidad_cv: media", round(mean(unidades$volatilidad_cv), 2),
    "y mediana", round(median(unidades$volatilidad_cv), 2),
    "casi coinciden; asimetria", round(coef_asimetria(unidades$volatilidad_cv), 3),
    "-> la media es una medida de centro razonable.\n")
cat("- variacion_2013_2017: media", round(mean(unidades$variacion_13_17), 2),
    "supera ampliamente a la mediana", round(median(unidades$variacion_13_17), 2),
    "; asimetria", round(coef_asimetria(unidades$variacion_13_17), 3),
    "-> muy sesgada a la derecha: se reporta MEDIANA e IQR.\n")

r_pearson  <- cor(unidades$volatilidad_cv, unidades$variacion_13_17)
r_spearman <- cor(unidades$volatilidad_cv, unidades$variacion_13_17, method = "spearman")
cat("\nCorrelacion volatilidad vs variacion 2013-2017:\n")
cat("  Pearson  =", round(r_pearson, 3), "\n")
cat("  Spearman =", round(r_spearman, 3), "\n")


# =============================================================================
titulo("6. VARIABLES CUALITATIVAS: FRECUENCIA ABSOLUTA, RELATIVA Y PORCENTAJE")
# =============================================================================
tabla_frecuencias <- function(x, nombre) {
  f  <- sort(table(x), decreasing = TRUE)
  fr <- as.numeric(f) / sum(f)
  data.frame(variable = nombre, categoria = names(f),
             frecuencia = as.integer(f),
             frecuencia_relativa = round(fr, 4),
             porcentaje = round(100 * fr, 2),
             frecuencia_acumulada = cumsum(as.integer(f)),
             porcentaje_acumulado = round(100 * cumsum(fr), 2))
}
frec_grupo   <- tabla_frecuencias(unidades$Grupo,        "Grupo")
frec_region  <- tabla_frecuencias(unidades$region,       "region")
frec_mercado <- tabla_frecuencias(unidades$tipo_mercado, "tipo_mercado")
for (t in list(frec_grupo, frec_region, frec_mercado)) {
  print(t, row.names = FALSE); cat("\n")
}
guardar_tabla(rbind(frec_grupo, frec_region, frec_mercado),
              "03_frecuencias_cualitativas.csv")

cat("Categoria mas frecuente en Grupo ........", frec_grupo$categoria[1],
    "-", frec_grupo$frecuencia[1], "unidades (", frec_grupo$porcentaje[1], "%)\n")
cat("Categoria mas frecuente en region .......", frec_region$categoria[1],
    "-", frec_region$frecuencia[1], "unidades (", frec_region$porcentaje[1], "%)\n")
cat("Categoria mas frecuente en tipo_mercado .", frec_mercado$categoria[1],
    "-", frec_mercado$frecuencia[1], "unidades (", frec_mercado$porcentaje[1], "%)\n")


# =============================================================================
titulo("7. COMPARACION ENTRE GRUPOS")
# =============================================================================
resumir_por <- function(variable_grupo, nombre) {
  s <- split(unidades$volatilidad_cv, variable_grupo)
  out <- data.frame(
    variable = nombre, categoria = names(s),
    n = sapply(s, length),
    cv_media = round(sapply(s, mean), 2),
    cv_mediana = round(sapply(s, median), 2),
    cv_desv = round(sapply(s, sd), 2),
    cv_min = round(sapply(s, min), 2),
    cv_max = round(sapply(s, max), 2))
  out[order(out$cv_mediana), ]
}
por_grupo   <- resumir_por(unidades$Grupo,        "Grupo")
por_region  <- resumir_por(unidades$region,       "region")
por_mercado <- resumir_por(unidades$tipo_mercado, "tipo_mercado")
cat("Volatilidad del precio (CV %) por grupo de alimento:\n")
print(por_grupo, row.names = FALSE)
cat("\nVolatilidad del precio (CV %) por region:\n")
print(por_region, row.names = FALSE)
cat("\nVolatilidad del precio (CV %) por tipo de mercado:\n")
print(por_mercado, row.names = FALSE)
guardar_tabla(rbind(por_grupo, por_region, por_mercado), "04_volatilidad_por_grupo.csv")

razon <- max(por_grupo$cv_mediana) / min(por_grupo$cv_mediana)
cat("\nEl grupo mas volatil es", por_grupo$categoria[nrow(por_grupo)],
    "con CV mediano", max(por_grupo$cv_mediana), "%\n")
cat("El grupo mas estable es", por_grupo$categoria[1],
    "con CV mediano", min(por_grupo$cv_mediana), "%\n")
cat("Razon entre extremos:", round(razon, 1), "veces\n")

# Precio mediano por tipo de mercado (nivel, no volatilidad)
precio_mercado <- data.frame(
  tipo_mercado = levels(unidades$tipo_mercado),
  n = as.integer(table(unidades$tipo_mercado)),
  precio_mediano = round(tapply(unidades$precio_promedio, unidades$tipo_mercado, median), 0),
  cv_mediano = round(tapply(unidades$volatilidad_cv, unidades$tipo_mercado, median), 2))
cat("\nNivel y volatilidad segun tipo de mercado:\n")
print(precio_mercado, row.names = FALSE)
guardar_tabla(precio_mercado, "05_nivel_y_volatilidad_por_mercado.csv")


# =============================================================================
titulo("8. FIGURAS")
# =============================================================================

# --- Figura 1: BARRAS - frecuencia de unidades por grupo -------------------
f <- "01_barras_grupo.png"; abrir_fig(f, 1500, 950)
par(mar = c(5, 14, 4, 2))
o <- order(frec_grupo$frecuencia)
bp <- barplot(frec_grupo$frecuencia[o], horiz = TRUE, las = 1,
              names.arg = ETIQUETA_GRUPO[frec_grupo$categoria[o]],
              col = COL_GRUPO[frec_grupo$categoria[o]], border = NA,
              xlim = c(0, max(frec_grupo$frecuencia) * 1.18),
              xlab = "Numero de series plaza-producto",
              main = "Composicion de la muestra por grupo de alimento")
text(frec_grupo$frecuencia[o], bp,
     labels = paste0(frec_grupo$frecuencia[o], " (", frec_grupo$porcentaje[o], "%)"),
     pos = 4, cex = 0.8)
mtext("Frecuencia absoluta y relativa; n = 451 unidades", side = 3, line = 0.2, cex = 0.85)
cerrar_fig(f)

# --- Figura 2: SECTORES - composicion por tipo de mercado ------------------
f <- "02_sectores_tipo_mercado.png"; abrir_fig(f, 1200, 950)
par(mar = c(3, 2, 4, 2))
etiquetas <- paste0(frec_mercado$categoria, "\n", frec_mercado$frecuencia,
                    " (", frec_mercado$porcentaje, "%)")
pie(frec_mercado$frecuencia, labels = etiquetas,
    col = COL_MERCADO[frec_mercado$categoria], border = "white", cex = 0.95,
    main = "Composicion de la muestra por tipo de mercado")
mtext("El total del circulo es el 100% de las 451 unidades", side = 1, line = 0.5, cex = 0.85)
cerrar_fig(f)

# --- Figura 3: HISTOGRAMA + densidad - volatilidad -------------------------
f <- "03_histograma_volatilidad.png"; abrir_fig(f)
par(mar = c(5, 5, 4, 2))
k <- ceiling(log2(nrow(unidades)) + 1)      # regla de Sturges
h <- hist(unidades$volatilidad_cv, breaks = k, freq = FALSE, col = "#9ECAE1",
          border = "white", xlab = "Coeficiente de variacion del precio (%)",
          ylab = "Densidad", main = "Distribucion de la volatilidad del precio")
lines(density(unidades$volatilidad_cv), col = "#D81B60", lwd = 2.5)
abline(v = mean(unidades$volatilidad_cv),   col = "#F57C00", lwd = 2, lty = 2)
abline(v = median(unidades$volatilidad_cv), col = "#5E35B1", lwd = 2, lty = 3)
legend("topright", bty = "n", cex = 0.85,
       legend = c(paste0("Media = ", round(mean(unidades$volatilidad_cv), 1), "%"),
                  paste0("Mediana = ", round(median(unidades$volatilidad_cv), 1), "%"),
                  "Densidad suavizada"),
       col = c("#F57C00", "#5E35B1", "#D81B60"), lty = c(2, 3, 1), lwd = 2)
mtext(paste0("Asimetria = ", round(coef_asimetria(unidades$volatilidad_cv), 2),
             " | ", k, " clases por la regla de Sturges"),
      side = 3, line = 0.2, cex = 0.85)
cerrar_fig(f)

# --- Figura 4: CAJA - volatilidad por grupo (figura central) ---------------
f <- "04_caja_volatilidad_por_grupo.png"; abrir_fig(f, 1600, 1000)
par(mar = c(5, 14, 4, 2))
orden <- por_grupo$categoria
lista <- split(unidades$volatilidad_cv, factor(unidades$Grupo, levels = orden))
names(lista) <- ETIQUETA_GRUPO[orden]
boxplot(lista, horizontal = TRUE, las = 1, col = COL_GRUPO[orden], border = "gray25",
        outpch = 19, outcol = "#6A1B9A", outcex = 0.8,
        xlab = "Coeficiente de variacion del precio mensual (%)",
        main = "Volatilidad del precio por grupo de alimento, 2013-2017")
medias <- sapply(lista, mean)
points(medias, seq_along(medias), pch = 23, bg = "white", col = "black", cex = 1.3)
mtext("Linea de la caja: mediana | Rombo blanco: media | n = 451 unidades",
      side = 3, line = 0.2, cex = 0.85)
cerrar_fig(f)

# --- Figura 5: DISPERSION - volatilidad vs variacion acumulada -------------
f <- "05_dispersion_volatilidad_variacion.png"; abrir_fig(f, 1600, 1000)
par(mar = c(5, 5, 4, 2))
plot(unidades$volatilidad_cv, unidades$variacion_13_17,
     pch = 19, cex = 0.9, col = adjustcolor(COL_GRUPO[as.character(unidades$Grupo)], 0.75),
     xlab = "Volatilidad del precio (CV %)",
     ylab = "Variacion acumulada 2013-2017 (%)",
     main = "Los alimentos mas volatiles fueron los que mas se encarecieron")
abline(lm(variacion_13_17 ~ volatilidad_cv, data = unidades), col = "#263238", lwd = 2.5)
abline(h = 0, col = "gray70", lty = 3)
legend("topleft", legend = ETIQUETA_GRUPO[names(COL_GRUPO)], col = COL_GRUPO, pch = 19,
       bty = "n", cex = 0.72)
mtext(paste0("Pearson r = ", round(r_pearson, 3),
             " | Spearman = ", round(r_spearman, 3),
             " | cada punto es una serie plaza-producto"),
      side = 3, line = 0.2, cex = 0.85)
cerrar_fig(f)


# =============================================================================
titulo("9. PRODUCTO TESTIGO: TOMATE DE ARBOL")
# =============================================================================
# El precio en COP no es comparable entre productos de la canasta porque las
# unidades difieren (la mayoria en COP/kg, el huevo por unidad). Por eso el
# analisis del NIVEL de precio se hace dentro de un unico producto.

testigo <- unidades[unidades$Producto == "Tomate de \u00e1rbol", ]
p <- testigo$precio_promedio

cat("Plazas con serie completa:", nrow(testigo), "\n\n")
resumen_testigo <- describir(p, "precio_promedio tomate de arbol (COP)")
print(t(resumen_testigo), quote = FALSE)
guardar_tabla(resumen_testigo, "06_medidas_tomate_de_arbol.csv")

# Tabla de frecuencias agrupada por Sturges
k <- ceiling(log2(length(p)) + 1)
cortes <- seq(min(p), max(p), length.out = k + 1)
clases <- cut(p, breaks = cortes, include.lowest = TRUE, right = TRUE)
tab_agrupada <- data.frame(
  clase = levels(clases),
  frecuencia = as.integer(table(clases)),
  frecuencia_relativa = round(as.numeric(table(clases)) / length(p), 4),
  porcentaje = round(100 * as.numeric(table(clases)) / length(p), 2),
  frecuencia_acumulada = cumsum(as.integer(table(clases))),
  porcentaje_acumulado = round(100 * cumsum(as.numeric(table(clases))) / length(p), 2))
cat("\nTabla de frecuencias agrupada (regla de Sturges, k =", k, "):\n")
print(tab_agrupada, row.names = FALSE)
cat("Clase modal:", clase_modal(p), "\n")
guardar_tabla(tab_agrupada, "07_frecuencias_agrupadas_tomate.csv")

cat("\nCinco plazas mas baratas:\n")
print(testigo[order(p), c("Fuente", "departamento", "precio_promedio", "volatilidad_cv")][1:5, ],
      row.names = FALSE)
cat("\nCinco plazas mas caras:\n")
print(testigo[order(-p), c("Fuente", "departamento", "precio_promedio", "volatilidad_cv")][1:5, ],
      row.names = FALSE)
cat("\nBrecha entre la plaza mas cara y la mas barata:",
    round(max(p) / min(p), 2), "veces\n")
cat("Precio de referencia sugerido - mediana:", round(median(p), 0), "COP\n")
cat("Franja intercuartilica: de", round(quantile(p, .25), 0),
    "a", round(quantile(p, .75), 0), "COP\n")

# --- Figura 6: caja + puntos, precio del testigo por tipo de mercado -------
f <- "06_tomate_por_tipo_mercado.png"; abrir_fig(f, 1500, 950)
par(mar = c(5, 5, 4, 2))
lt <- split(p, testigo$tipo_mercado)
boxplot(lt, col = COL_MERCADO[names(lt)], border = "gray25", outline = FALSE,
        ylab = "Precio promedio 2013-2017 (COP/kg)", xlab = "",
        main = "Tomate de arbol: el precio depende de la posicion de la plaza")
for (i in seq_along(lt)) {
  points(jitter(rep(i, length(lt[[i]])), amount = 0.10), lt[[i]],
         pch = 19, col = adjustcolor("#37474F", 0.6), cex = 1.0)
}
points(seq_along(lt), sapply(lt, mean), pch = 23, bg = "white", col = "black", cex = 1.5)
abline(h = median(p), col = "#D81B60", lwd = 2, lty = 2)
legend("topright", bty = "n", cex = 0.8,
       legend = c("Cada punto: una plaza", "Rombo blanco: media del grupo",
                  paste0("Mediana nacional = ", round(median(p), 0), " COP")),
       pch = c(19, 23, NA), lty = c(NA, NA, 2), col = c("#37474F", "black", "#D81B60"))
cerrar_fig(f)


# =============================================================================
titulo("10. RESPUESTA DESCRIPTIVA A LA PREGUNTA DE INVESTIGACION")
# =============================================================================
cat(
"No existe un precio justo nacional unico.\n\n",
"1) Para el tomate de arbol, el precio promedio 2013-2017 va de ",
round(min(p), 0), " a ", round(max(p), 0), " COP segun la plaza: una brecha de ",
round(max(p) / min(p), 2), " veces. Las plazas mas baratas estan en la zona\n",
"   productora y son tambien las mas volatiles; las mas caras son mercados de\n",
"   destino y son mas estables. Un precio de referencia razonable es la mediana\n",
"   (", round(median(p), 0), " COP), no la media (", round(mean(p), 0),
"), porque la distribucion es asimetrica\n   a la izquierda (asimetria ",
round(coef_asimetria(p), 2), ").\n\n",
"2) A nivel de canasta, lo que mas separa a los alimentos no es el nivel sino la\n",
"   estabilidad: el CV mediano va de ", min(por_grupo$cv_mediana), "% en ",
por_grupo$categoria[1], " a ", max(por_grupo$cv_mediana), "% en\n   ",
por_grupo$categoria[nrow(por_grupo)], " (", round(razon, 1), " veces).\n\n",
"3) Volatilidad y encarecimiento van juntos: r de Pearson = ", round(r_pearson, 3), ".\n\n",
"ALCANCE: todos estos resultados son descriptivos y de asociacion. No se ha\n",
"realizado ninguna prueba de hipotesis ni se afirma relacion causal alguna.\n",
sep = "")

titulo("FIN DEL ANALISIS")
cat("Figuras en:", DIR_FIG, "\n")
cat("Tablas  en:", DIR_TAB, "\n")
