# =============================================================================
# 01_carga_y_enriquecimiento.R
#
# Lee el archivo original de precios mayoristas mensuales (SIPSA-DANE, 2024),
# lo depura y lo enriquece con variables geograficas e institucionales.
#
# Produce dos bases de trabajo:
#   datos/precios_registro.rds     -> unidad de analisis: producto x mercado x mes
#   datos/precios_producto_mes.rds -> unidad de analisis: producto x mes (agregado)
# =============================================================================

source(file.path("R", "00_utilidades.R"))
crear_carpetas()

# -----------------------------------------------------------------------------
# 1. Lectura del archivo original
# -----------------------------------------------------------------------------
# El archivo viene delimitado por ';', con BOM UTF-8, finales de linea de
# Windows y los precios escritos con punto como separador de miles (" 1.387 "),
# por lo que se leen como texto y se convierten manualmente.
# Ademas, un mercado trae comillas dobles dentro del propio campo
# ('Medellin, Plaza Minorista "Jose Maria Villa"'), escapadas segun el estandar
# CSV; se leen con el entrecomillado por defecto para que R las resuelva.
# Nota: la lectura requiere una configuracion regional UTF-8; en caso contrario
# el archivo se trunca silenciosamente (ver verificacion de filas mas abajo).

ARCHIVO <- file.path(RUTA_DATOS, "mensual_24.csv")
stopifnot(file.exists(ARCHIVO))

crudo <- read.csv2(ARCHIVO, stringsAsFactors = FALSE, colClasses = "character",
                   fileEncoding = "UTF-8-BOM", check.names = FALSE)

# Control de integridad de la lectura.
n_lineas <- length(readLines(ARCHIVO, warn = FALSE)) - 1L
if (nrow(crudo) < n_lineas) {
  stop("Lectura incompleta: ", nrow(crudo), " de ", n_lineas, " registros. ",
       "Verifique que la sesion de R use codificacion UTF-8.")
}

names(crudo) <- c("fecha_txt", "grupo", "producto", "cpc", "mercado", "precio_txt")

cat("Registros leidos:", nrow(crudo), "| Columnas:", ncol(crudo), "\n")

# -----------------------------------------------------------------------------
# 2. Conversion de la variable de precio
# -----------------------------------------------------------------------------
a_numero <- function(x) {
  x <- trimws(x)
  x <- gsub("\\.", "", x)    # elimina separador de miles
  x <- gsub(",", ".", x)     # coma decimal -> punto decimal
  suppressWarnings(as.numeric(x))
}

crudo$precio_kg <- a_numero(crudo$precio_txt)

cat("Precios no convertibles:", sum(is.na(crudo$precio_kg)), "\n")
cat("Precios <= 0          :", sum(crudo$precio_kg <= 0, na.rm = TRUE), "\n")

# -----------------------------------------------------------------------------
# 3. Variable temporal
# -----------------------------------------------------------------------------
MESES_ABR <- c("ene", "feb", "mar", "abr", "may", "jun",
               "jul", "ago", "sep", "oct", "nov", "dic")
MESES_NOM <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
               "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")

crudo$mes_num <- match(tolower(substr(crudo$fecha_txt, 1, 3)), MESES_ABR)
crudo$fecha    <- as.Date(sprintf("2024-%02d-01", crudo$mes_num))
crudo$mes      <- factor(MESES_NOM[crudo$mes_num], levels = MESES_NOM)
crudo$trimestre <- factor(paste0("T", ((crudo$mes_num - 1) %/% 3) + 1))

# -----------------------------------------------------------------------------
# 4. Descomposicion del campo 'mercado'
# -----------------------------------------------------------------------------
# El campo mezcla tres formatos:
#   "Bogota, D.C., Corabastos"        -> capital con plaza
#   "Armenia, Mercar"                 -> capital con plaza
#   "El Santuario (Antioquia)"        -> municipio sin plaza nombrada
#   "Duitama (Boyaca), Mercaplaza"    -> municipio con plaza

separar_mercado <- function(m) {
  m <- trimws(m)
  if (grepl("\\(", m)) {
    ciudad <- trimws(sub("\\s*\\(.*$", "", m))
    depto  <- sub("^[^(]*\\(([^)]*)\\).*$", "\\1", m)
    resto  <- sub("^[^)]*\\)", "", m)
    plaza  <- trimws(sub("^\\s*,\\s*", "", resto))
  } else if (startsWith(m, "Bogotá, D.C.")) {
    ciudad <- "Bogotá, D.C."
    depto  <- "Bogotá, D.C."
    plaza  <- trimws(sub("^Bogotá, D\\.C\\.\\s*,?\\s*", "", m))
  } else if (grepl(",", m)) {
    ciudad <- trimws(sub(",.*$", "", m))
    depto  <- NA_character_
    plaza  <- trimws(sub("^[^,]*,\\s*", "", m))
  } else {
    ciudad <- m; depto <- NA_character_; plaza <- ""
  }
  c(ciudad = ciudad, depto = depto, plaza = plaza)
}

mercados <- sort(unique(crudo$mercado))
partes   <- t(vapply(mercados, separar_mercado, character(3)))
dic_mer  <- data.frame(mercado = mercados, ciudad = partes[, "ciudad"],
                       departamento = partes[, "depto"], plaza = partes[, "plaza"],
                       stringsAsFactors = FALSE)
dic_mer$plaza[dic_mer$plaza == ""] <- NA_character_

# Departamento de las ciudades capitales que no traen el dato entre parentesis.
CAPITALES <- c(
  "Armenia" = "Quindío", "Barranquilla" = "Atlántico",
  "Bogotá, D.C." = "Bogotá, D.C.", "Bucaramanga" = "Santander",
  "Cali" = "Valle del Cauca", "Cartagena" = "Bolívar",
  "Cúcuta" = "Norte de Santander", "Ibagué" = "Tolima",
  "Manizales" = "Caldas", "Medellín" = "Antioquia",
  "Montería" = "Córdoba", "Neiva" = "Huila",
  "Pasto" = "Nariño", "Pereira" = "Risaralda",
  "Popayán" = "Cauca", "Sincelejo" = "Sucre",
  "Tunja" = "Boyacá", "Valledupar" = "Cesar",
  "Villavicencio" = "Meta", "Arauca" = "Arauca",
  "Florencia" = "Caquetá", "Santa Marta" = "Magdalena",
  "Yopal" = "Casanare"
)

falta <- is.na(dic_mer$departamento)
dic_mer$departamento[falta] <- unname(CAPITALES[dic_mer$ciudad[falta]])
stopifnot(!any(is.na(dic_mer$departamento)))

# La ciudad es capital departamental (nodo de consumo) o no (nodo de produccion).
dic_mer$es_capital <- dic_mer$ciudad %in% names(CAPITALES)

# -----------------------------------------------------------------------------
# 5. Region natural (agrupacion oficial DANE por departamento)
# -----------------------------------------------------------------------------
REGIONES <- list(
  "Andina"    = c("Antioquia", "Boyacá", "Caldas", "Cundinamarca",
                  "Bogotá, D.C.", "Huila", "Norte de Santander",
                  "Quindío", "Risaralda", "Santander", "Tolima"),
  "Caribe"    = c("Atlántico", "Bolívar", "Cesar", "Córdoba",
                  "La Guajira", "Magdalena", "Sucre"),
  "Pacífica" = c("Cauca", "Chocó", "Nariño", "Valle del Cauca"),
  "Orinoquía" = c("Arauca", "Casanare", "Meta", "Vichada"),
  "Amazonía"  = c("Amazonas", "Caquetá", "Guainía", "Guaviare",
                       "Putumayo", "Vaupés")
)

region_de <- function(d) {
  for (r in names(REGIONES)) if (d %in% REGIONES[[r]]) return(r)
  NA_character_
}
dic_mer$region <- vapply(dic_mer$departamento, region_de, character(1))
stopifnot(!any(is.na(dic_mer$region)))
dic_mer$region <- factor(dic_mer$region,
                         levels = c("Andina", "Caribe", "Pacífica",
                                    "Orinoquía", "Amazonía"))

# -----------------------------------------------------------------------------
# 6. Tipo de plaza (variable institucional)
# -----------------------------------------------------------------------------
# Criterio de clasificacion, en este orden de prioridad:
#   1. Frigorifico o plaza especializada en carnes  -> nombre alude a carnes/frigorifico
#   2. Central de abastos                           -> nodo mayorista de primer orden
#   3. Plaza de mercado urbana                      -> plaza en ciudad capital
#   4. Mercado de municipio productor               -> plaza en municipio no capital

PAT_CARNES <- "[Ff]rigor|[Cc]arnes"
PAT_ABASTO <- paste(
  "abasto", "Abasto", "Mercar\\b", "Cavasa", "Mercasa", "Central Mayorista",
  "Corabastos", "Centroabastos", "Cenabastos", "Granabastos", "Surabastos",
  "Mercabastos", "Mercaplaza", "Barranquillita", "Bazurto", "Santa Elena", "acopio",
  "Coomproriente", "Complejo de Servicios", "Mercado del Sur", "Nuevo Mercado",
  "Mercado Nuevo", "Plaza La 21", "^CAV$", "El Potrerillo",
  sep = "|")

clasificar_plaza <- function(plaza, es_capital) {
  p <- ifelse(is.na(plaza), "", plaza)
  out <- ifelse(
    grepl(PAT_CARNES, p), "Frigorífico o plaza de carnes",
    ifelse(grepl(PAT_ABASTO, p), "Central de abastos",
           ifelse(es_capital, "Plaza de mercado urbana",
                  "Mercado de municipio productor")))
  factor(out, levels = c("Central de abastos", "Plaza de mercado urbana",
                         "Mercado de municipio productor",
                         "Frigorífico o plaza de carnes"))
}

dic_mer$tipo_plaza <- clasificar_plaza(dic_mer$plaza, dic_mer$es_capital)

# -----------------------------------------------------------------------------
# 7. Base a nivel de registro (producto x mercado x mes)
# -----------------------------------------------------------------------------
reg <- merge(crudo[, c("fecha", "mes", "mes_num", "trimestre", "grupo",
                       "producto", "cpc", "mercado", "precio_kg")],
             dic_mer, by = "mercado", all.x = TRUE)

reg$grupo <- factor(reg$grupo)
reg <- reg[order(reg$fecha, reg$grupo, reg$producto, reg$mercado), ]
rownames(reg) <- NULL

# Precio de referencia nacional del producto en cada mes (mediana entre mercados)
# y brecha relativa de cada plaza frente a esa referencia.
clave <- paste(reg$producto, reg$mes_num, sep = "|")
ref_mediana <- tapply(reg$precio_kg, clave, median)
ref_n       <- tapply(reg$precio_kg, clave, length)

reg$precio_ref_nacional <- as.numeric(ref_mediana[clave])
reg$n_mercados_producto <- as.integer(ref_n[clave])
reg$brecha_pct <- 100 * (reg$precio_kg - reg$precio_ref_nacional) /
                        reg$precio_ref_nacional
reg$log_precio <- log10(reg$precio_kg)

# -----------------------------------------------------------------------------
# 8. Base agregada (producto x mes): nivel y dispersion geografica
# -----------------------------------------------------------------------------
agg <- function(f) as.numeric(tapply(reg$precio_kg, clave, f))
llaves <- names(ref_mediana)

pm <- data.frame(
  clave            = llaves,
  producto         = sub("\\|.*$", "", llaves),
  mes_num          = as.integer(sub("^.*\\|", "", llaves)),
  n_mercados       = as.integer(ref_n),
  precio_medio     = agg(mean),
  precio_mediano   = agg(median),
  precio_min       = agg(min),
  precio_max       = agg(max),
  desv_est         = agg(sd),
  stringsAsFactors = FALSE
)

pm$cv_pct        <- 100 * pm$desv_est / pm$precio_medio   # dispersion relativa
pm$rango_rel_pct <- 100 * (pm$precio_max - pm$precio_min) / pm$precio_mediano
pm$log_precio    <- log10(pm$precio_mediano)

# Grupo alimentario de cada producto (constante dentro del producto).
dic_prod <- unique(reg[, c("producto", "grupo", "cpc")])
dic_prod <- dic_prod[!duplicated(dic_prod$producto), ]
pm <- merge(pm, dic_prod, by = "producto", all.x = TRUE)

pm$mes <- factor(MESES_NOM[pm$mes_num], levels = MESES_NOM)
pm$fecha <- as.Date(sprintf("2024-%02d-01", pm$mes_num))
pm <- pm[order(pm$fecha, pm$grupo, pm$producto), ]
rownames(pm) <- NULL

# Para que el coeficiente de variacion sea informativo se exige un minimo de
# mercados por producto-mes. Se conserva la marca y no se eliminan filas.
MIN_MERCADOS <- 5
pm$cv_valido <- pm$n_mercados >= MIN_MERCADOS

# -----------------------------------------------------------------------------
# 9. Guardado
# -----------------------------------------------------------------------------
saveRDS(reg, file.path(RUTA_DATOS, "precios_registro.rds"))
saveRDS(pm,  file.path(RUTA_DATOS, "precios_producto_mes.rds"))
tabla("00_diccionario_mercados", dic_mer[, c("mercado", "ciudad", "departamento",
                                             "region", "plaza", "tipo_plaza",
                                             "es_capital")])

cat("\n--- Bases construidas -------------------------------------------\n")
cat("Nivel registro      :", nrow(reg), "filas x", ncol(reg), "columnas\n")
cat("Nivel producto-mes  :", nrow(pm),  "filas x", ncol(pm),  "columnas\n")
cat("Productos           :", length(unique(reg$producto)), "\n")
cat("Mercados            :", length(unique(reg$mercado)), "\n")
cat("Grupos              :", nlevels(reg$grupo), "\n")
cat("Producto-mes con n >=", MIN_MERCADOS, ":", sum(pm$cv_valido),
    sprintf("(%.1f%% de los pares)\n", 100 * mean(pm$cv_valido)))
