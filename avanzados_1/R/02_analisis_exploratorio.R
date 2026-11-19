# =============================================================================
# 02_analisis_exploratorio.R
#
# Analisis exploratorio de datos (AED) sobre las dos bases construidas en
# 01_carga_y_enriquecimiento.R.
#
# Estructura:
#   A. Estructura y calidad de los datos
#   B. Analisis univariado  : precio (Y1) y coeficiente de variacion (Y2)
#   C. Analisis bivariado   : cuantitativa vs. cualitativa
#   D. Analisis bivariado   : cuantitativa vs. cuantitativa (nivel vs dispersion)
#   E. Analisis temporal
#   F. Sintesis y anticipo de la fase inferencial
# =============================================================================

source(file.path("R", "00_utilidades.R"))
crear_carpetas()

reg <- readRDS(file.path(RUTA_DATOS, "precios_registro.rds"))
pm  <- readRDS(file.path(RUTA_DATOS, "precios_producto_mes.rds"))
pmv <- pm[pm$cv_valido, ]          # producto-mes con al menos 5 mercados

linea <- function(txt) cat("\n", strrep("=", 74), "\n", txt, "\n",
                           strrep("=", 74), "\n", sep = "")

# =============================================================================
# A. ESTRUCTURA Y CALIDAD DE LOS DATOS
# =============================================================================
linea("A. ESTRUCTURA Y CALIDAD DE LOS DATOS")

estructura <- data.frame(
  variable = c("fecha", "grupo", "producto", "cpc", "mercado", "ciudad",
               "departamento", "region", "tipo_plaza", "es_capital",
               "precio_kg", "brecha_pct", "n_mercados_producto"),
  tipo = c("Fecha (mensual)", "Cualitativa nominal", "Cualitativa nominal",
           "Identificador", "Cualitativa nominal", "Cualitativa nominal",
           "Cualitativa nominal", "Cualitativa nominal", "Cualitativa ordinal-nominal",
           "Cualitativa binaria", "Cuantitativa continua",
           "Cuantitativa continua (derivada)", "Cuantitativa discreta (derivada)"),
  stringsAsFactors = FALSE
)
estructura$n_categorias <- vapply(estructura$variable, function(v) {
  x <- reg[[v]]
  if (is.numeric(x) && !v %in% c("n_mercados_producto")) NA_integer_
  else length(unique(x))
}, integer(1))
estructura$faltantes <- vapply(estructura$variable,
                               function(v) sum(is.na(reg[[v]])), integer(1))
print(estructura, row.names = FALSE)
tabla("01_estructura_variables", estructura)

cat("\nRegistros totales        :", nrow(reg), "\n")
cat("Registros duplicados     :",
    sum(duplicated(reg[, c("fecha", "producto", "mercado")])), "\n")
cat("Valores faltantes totales:", sum(is.na(reg$precio_kg)), "\n")
cat("Periodo cubierto         :", as.character(reg$mes[which.min(reg$mes_num)]),
    "a", as.character(reg$mes[which.max(reg$mes_num)]), "de 2024\n")

# Cobertura: no todos los productos se cotizan en todos los mercados.
cob_prod <- tapply(reg$mercado, reg$producto, function(x) length(unique(x)))
cob_mer  <- tapply(reg$producto, reg$mercado, function(x) length(unique(x)))
cat("\nMercados por producto  -> mediana:", median(cob_prod),
    "| minimo:", min(cob_prod), "| maximo:", max(cob_prod), "\n")
cat("Productos por mercado  -> mediana:", median(cob_mer),
    "| minimo:", min(cob_mer), "| maximo:", max(cob_mer), "\n")
cat("Panel completo teorico :", 349 * 80 * 12, "celdas; observadas:", nrow(reg),
    sprintf("(%.1f%%)\n", 100 * nrow(reg) / (349 * 80 * 12)))

tabla("02_cobertura_por_mercado",
      data.frame(mercado = names(cob_mer), n_productos = as.integer(cob_mer),
                 n_registros = as.integer(table(reg$mercado)[names(cob_mer)]),
                 row.names = NULL))

# =============================================================================
# B. ANALISIS UNIVARIADO
# =============================================================================
linea("B.1 VARIABLE CUANTITATIVA 1: PRECIO POR KILOGRAMO (COP/kg)")

res_precio <- resumen_num(reg$precio_kg)
print(res_precio, row.names = FALSE)
tabla("03_resumen_precio_global", res_precio)

lim <- limites_tukey(reg$precio_kg)
cat("\nLimites de Tukey:", fmt_cop(lim[1]), "a", fmt_cop(lim[2]), "\n")
cat("Atipicos por Tukey:", sum(reg$precio_kg > lim[2] | reg$precio_kg < lim[1]),
    sprintf("(%.1f%% de los registros)\n",
            100 * mean(reg$precio_kg > lim[2] | reg$precio_kg < lim[1])))
cat("La asimetria positiva (", round(asimetria(reg$precio_kg), 2),
    ") y la curtosis (", round(curtosis_exceso(reg$precio_kg), 2),
    ") muestran una distribucion fuertemente sesgada a la derecha.\n", sep = "")
cat("Tras transformar a log10 la asimetria baja a ",
    round(asimetria(reg$log_precio), 2), ".\n", sep = "")

fig("01_distribucion_precio", {
  par(mfrow = c(1, 2), mar = c(4.4, 4.4, 3.4, 1.2))
  hist(reg$precio_kg / 1000, breaks = 80, col = COL_PRIM, border = "white",
       main = "Escala original", xlab = "Precio (miles de COP/kg)",
       ylab = "Frecuencia")
  abline(v = median(reg$precio_kg) / 1000, col = COL_SEC, lwd = 2, lty = 2)
  legend("topright", "Mediana", col = COL_SEC, lwd = 2, lty = 2, bty = "n")

  hist(reg$log_precio, breaks = 60, col = COL_PRIM, border = "white",
       main = expression("Escala " * log[10]), xlab = expression(log[10]*"(COP/kg)"),
       ylab = "Frecuencia")
  curve(dnorm(x, mean(reg$log_precio), sd(reg$log_precio)) *
          nrow(reg) * diff(range(reg$log_precio)) / 60,
        add = TRUE, col = COL_SEC, lwd = 2)
  legend("topright", "Normal de referencia", col = COL_SEC, lwd = 2, bty = "n")
  mtext("Distribucion del precio mayorista por kilogramo, Colombia 2024",
        outer = TRUE, line = -1.4, cex = 1.05)
})

fig("02_qqplot_precio", {
  par(mfrow = c(1, 2))
  qqnorm(reg$precio_kg, main = "Precio en escala original", pch = 16,
         cex = 0.3, col = adjustcolor(COL_PRIM, 0.35),
         ylab = "Cuantiles muestrales (COP/kg)")
  qqline(reg$precio_kg, col = COL_SEC, lwd = 2)
  qqnorm(reg$log_precio, main = expression("Precio en escala " * log[10]),
         pch = 16, cex = 0.3, col = adjustcolor(COL_PRIM, 0.35),
         ylab = expression("Cuantiles muestrales " * log[10]))
  qqline(reg$log_precio, col = COL_SEC, lwd = 2)
})

linea("B.2 VARIABLE CUANTITATIVA 2: COEFICIENTE DE VARIACION INTERMERCADO (%)")

cat("Unidad de analisis: producto x mes con >= 5 mercados cotizantes.\n")
cat("Pares producto-mes analizados:", nrow(pmv), "de", nrow(pm), "\n\n")
res_cv <- resumen_num(pmv$cv_pct)
print(res_cv, row.names = FALSE)
tabla("04_resumen_cv_global", res_cv)

cat("\nInterpretacion: en el par producto-mes tipico el precio mayorista varia",
    sprintf("%.1f%%", median(pmv$cv_pct)), "\n")
cat("alrededor de su media nacional segun el mercado donde se cotice.\n")
cat("Razon maximo/minimo mediana:", round(median(pmv$precio_max / pmv$precio_min), 2), "\n")

fig("03_distribucion_cv", {
  par(mfrow = c(1, 2), mar = c(4.4, 4.4, 3.4, 1.2))
  hist(pmv$cv_pct, breaks = 50, col = COL_PRIM, border = "white",
       main = "Dispersion geografica del precio",
       xlab = "Coeficiente de variacion intermercado (%)", ylab = "Frecuencia")
  abline(v = median(pmv$cv_pct), col = COL_SEC, lwd = 2, lty = 2)
  legend("topright", paste0("Mediana = ", fmt_pct(median(pmv$cv_pct))),
         col = COL_SEC, lwd = 2, lty = 2, bty = "n")
  boxplot(pmv$cv_pct, col = adjustcolor(COL_PRIM, 0.6), border = "gray30",
          main = "Diagrama de caja", ylab = "CV intermercado (%)",
          outpch = 16, outcex = 0.4, outcol = adjustcolor(COL_GRIS, 0.5))
})

# =============================================================================
# C. BIVARIADO: CUANTITATIVAS vs. CUALITATIVAS
# =============================================================================
linea("C.1 PRECIO Y DISPERSION POR GRUPO ALIMENTARIO")

resumen_por <- function(df, x, g, digitos = 1) {
  s <- do.call(rbind, lapply(split(df[[x]], df[[g]]),
                             function(v) resumen_num(v, digitos)))
  out <- data.frame(categoria = rownames(s), s, row.names = NULL,
                    stringsAsFactors = FALSE)
  names(out)[1] <- g
  out
}

t_grupo_precio <- resumen_por(reg, "precio_kg", "grupo")
t_grupo_precio <- t_grupo_precio[order(-t_grupo_precio$mediana), ]
print(t_grupo_precio[, c("grupo", "n", "media", "mediana", "desv_est",
                         "cv_pct", "q1", "q3")], row.names = FALSE)
tabla("05_precio_por_grupo", t_grupo_precio)

t_grupo_cv <- resumen_por(pmv, "cv_pct", "grupo")
t_grupo_cv <- t_grupo_cv[order(-t_grupo_cv$mediana), ]
ic <- t(vapply(split(pmv$cv_pct, pmv$grupo), function(v) ic_media(v), numeric(4)))
t_grupo_cv$ic95_inf <- round(ic[t_grupo_cv$grupo, "inferior"], 2)
t_grupo_cv$ic95_sup <- round(ic[t_grupo_cv$grupo, "superior"], 2)
cat("\n")
print(t_grupo_cv[, c("grupo", "n", "media", "ic95_inf", "ic95_sup",
                     "mediana", "q1", "q3")], row.names = FALSE)
tabla("06_cv_por_grupo", t_grupo_cv)

ord_p <- names(sort(tapply(reg$precio_kg, reg$grupo, median)))
fig("04_precio_por_grupo", {
  par(mar = c(4.4, 13.5, 3.4, 1.4))
  cortes <- c(300, 1000, 3000, 10000, 30000, 100000)
  boxplot(reg$precio_kg ~ factor(reg$grupo, levels = ord_p), horizontal = TRUE,
          log = "x", las = 1, col = paleta_n(8), border = "gray30", xaxt = "n",
          xlab = "Precio por kilogramo (COP, escala logaritmica)", ylab = "",
          main = "Nivel de precio segun grupo alimentario, 2024",
          names = acortar(ord_p, 30), cex.axis = 0.8,
          outpch = 16, outcex = 0.3, outcol = adjustcolor(COL_GRIS, 0.4))
  axis(1, at = cortes, labels = formatC(cortes, format = "d", big.mark = ".",
                                        decimal.mark = ","),
       cex.axis = 0.85)
  abline(v = median(reg$precio_kg), col = COL_SEC, lty = 2, lwd = 1.6)
  legend("bottomright", paste0("Mediana general = ", fmt_cop(median(reg$precio_kg))),
         col = COL_SEC, lty = 2, lwd = 1.6, bty = "n", cex = 0.75)
})

ord_cv <- names(sort(tapply(pmv$cv_pct, pmv$grupo, median)))
fig("05_cv_por_grupo", {
  par(mar = c(4.4, 13.5, 3.4, 1.4))
  boxplot(pmv$cv_pct ~ factor(pmv$grupo, levels = ord_cv), horizontal = TRUE,
          las = 1, col = paleta_n(8), border = "gray30",
          xlab = "Coeficiente de variacion intermercado (%)", ylab = "",
          main = "Dispersion geografica del precio segun grupo alimentario",
          names = acortar(ord_cv, 30), cex.axis = 0.8,
          outpch = 16, outcex = 0.3, outcol = adjustcolor(COL_GRIS, 0.4))
  abline(v = median(pmv$cv_pct), col = COL_SEC, lty = 2, lwd = 1.6)
})

linea("C.2 BRECHA DE PRECIO POR TIPO DE PLAZA Y POR REGION")

t_plaza <- resumen_por(reg, "brecha_pct", "tipo_plaza")
print(t_plaza[, c("tipo_plaza", "n", "media", "mediana", "desv_est", "q1", "q3")],
      row.names = FALSE)
tabla("07_brecha_por_tipo_plaza", t_plaza)

t_region <- resumen_por(reg, "brecha_pct", "region")
cat("\n")
print(t_region[, c("region", "n", "media", "mediana", "desv_est", "q1", "q3")],
      row.names = FALSE)
tabla("08_brecha_por_region", t_region)

fig("06_brecha_plaza_region", alto = 1350, {
  par(mfrow = c(2, 1), mar = c(4.8, 15.5, 2.8, 1.4))
  bp <- factor(reg$tipo_plaza,
               levels = names(sort(tapply(reg$brecha_pct, reg$tipo_plaza, median))))
  boxplot(reg$brecha_pct ~ bp, horizontal = TRUE, las = 1, ylim = c(-45, 45),
          col = paleta_n(4), border = "gray30", cex.axis = 0.85,
          names = acortar(levels(bp), 32), outline = FALSE,
          xlab = "Brecha porcentual frente a la mediana nacional (%)", ylab = "",
          main = "Brecha de precio segun tipo de plaza")
  abline(v = 0, col = COL_SEC, lwd = 1.8)

  br <- factor(reg$region,
               levels = names(sort(tapply(reg$brecha_pct, reg$region, median))))
  boxplot(reg$brecha_pct ~ br, horizontal = TRUE, las = 1, ylim = c(-45, 45),
          col = paleta_n(5), border = "gray30", cex.axis = 0.85,
          outline = FALSE, xlab = "Brecha porcentual frente a la mediana nacional (%)",
          ylab = "", main = "Brecha de precio segun region del pais")
  abline(v = 0, col = COL_SEC, lwd = 1.8)
})

# =============================================================================
# D. BIVARIADO: NIVEL vs. DISPERSION (las dos cuantitativas principales)
# =============================================================================
linea("D. RELACION ENTRE NIVEL DE PRECIO Y DISPERSION GEOGRAFICA")

r_p <- cor(pmv$log_precio, pmv$cv_pct, method = "pearson")
r_s <- cor(pmv$precio_mediano, pmv$cv_pct, method = "spearman")
pt  <- cor.test(pmv$log_precio, pmv$cv_pct)
cat("Correlacion de Pearson  log10(precio) vs CV :", round(r_p, 3),
    sprintf(" (IC95%%: %.3f a %.3f; p = %.3g)\n",
            pt$conf.int[1], pt$conf.int[2], pt$p.value))
cat("Correlacion de Spearman precio     vs CV :", round(r_s, 3), "\n\n")

cor_grupo <- do.call(rbind, lapply(split(pmv, pmv$grupo), function(d) {
  data.frame(grupo = as.character(d$grupo[1]), n = nrow(d),
             pearson_log = round(cor(d$log_precio, d$cv_pct), 3),
             spearman    = round(cor(d$precio_mediano, d$cv_pct,
                                     method = "spearman"), 3),
             stringsAsFactors = FALSE)
}))
cor_grupo <- cor_grupo[order(cor_grupo$spearman), ]
print(cor_grupo, row.names = FALSE)
tabla("09_correlaciones_nivel_dispersion", cor_grupo)

fig("07_nivel_vs_dispersion", {
  par(mar = c(4.6, 4.6, 3.4, 9.6), xpd = FALSE)
  g <- factor(pmv$grupo)
  plot(pmv$log_precio, pmv$cv_pct, pch = 16, cex = 0.55,
       col = adjustcolor(paleta_n(nlevels(g))[as.integer(g)], 0.55),
       xlab = expression(log[10] * "(precio mediano, COP/kg)"),
       ylab = "Coeficiente de variacion intermercado (%)",
       main = "Nivel de precio frente a dispersion geografica (producto-mes, 2024)")
  grid(col = "gray88", lty = 1)
  lo <- lowess(pmv$log_precio, pmv$cv_pct, f = 0.4)
  lines(lo, col = "black", lwd = 2.6)
  abline(h = median(pmv$cv_pct), col = COL_SEC, lty = 2, lwd = 1.4)
  par(xpd = TRUE)
  legend(par("usr")[2] + 0.05, par("usr")[4], legend = acortar(levels(g), 20),
         col = paleta_n(nlevels(g)), pch = 16, bty = "n", cex = 0.72, pt.cex = 1.1)
})

# Comparacion por cuartiles de precio (lectura sin supuestos de linealidad).
q_precio <- cut(pmv$precio_mediano,
                breaks = quantile(pmv$precio_mediano, seq(0, 1, 0.25)),
                include.lowest = TRUE,
                labels = c("Q1 (mas barato)", "Q2", "Q3", "Q4 (mas caro)"))
t_cuartil <- resumen_por(data.frame(cv_pct = pmv$cv_pct, cuartil = q_precio),
                         "cv_pct", "cuartil")
cat("\nCV intermercado por cuartil de precio:\n")
print(t_cuartil[, c("cuartil", "n", "media", "mediana", "desv_est")],
      row.names = FALSE)
tabla("10_cv_por_cuartil_precio", t_cuartil)

linea("D.2 PRODUCTOS CON MAYOR Y MENOR DISPERSION GEOGRAFICA")

cv_prod <- do.call(rbind, lapply(split(pmv, pmv$producto), function(d) {
  if (nrow(d) < 6) return(NULL)
  data.frame(producto = d$producto[1], grupo = as.character(d$grupo[1]),
             meses = nrow(d), precio_mediano = round(median(d$precio_mediano)),
             cv_mediano = round(median(d$cv_pct), 1), stringsAsFactors = FALSE)
}))
cv_prod <- cv_prod[order(-cv_prod$cv_mediano), ]
cat("Productos con mayor dispersion:\n"); print(head(cv_prod, 12), row.names = FALSE)
cat("\nProductos con menor dispersion:\n"); print(tail(cv_prod, 12), row.names = FALSE)
tabla("11_dispersion_por_producto", cv_prod)

fig("08_productos_extremos", {
  par(mfrow = c(1, 2), mar = c(4.4, 11.5, 3.2, 1.2))
  top <- head(cv_prod, 12)[12:1, ]
  barplot(top$cv_mediano, horiz = TRUE, names.arg = acortar(top$producto, 24),
          las = 1, col = COL_SEC, border = NA, cex.names = 0.75,
          xlab = "CV mediano (%)", main = "Mayor dispersion geografica")
  bot <- tail(cv_prod, 12)[12:1, ]
  barplot(bot$cv_mediano, horiz = TRUE, names.arg = acortar(bot$producto, 24),
          las = 1, col = COL_PRIM, border = NA, cex.names = 0.75,
          xlab = "CV mediano (%)", main = "Menor dispersion geografica")
})

# =============================================================================
# E. ANALISIS TEMPORAL
# =============================================================================
linea("E. EVOLUCION MENSUAL")

serie <- do.call(rbind, lapply(split(pmv, list(pmv$grupo, pmv$mes_num), drop = TRUE),
  function(d) data.frame(grupo = as.character(d$grupo[1]), mes_num = d$mes_num[1],
                         precio_mediano = median(d$precio_mediano),
                         cv_mediano = median(d$cv_pct), n = nrow(d),
                         stringsAsFactors = FALSE)))
serie <- serie[order(serie$grupo, serie$mes_num), ]
serie$indice <- unlist(lapply(split(serie$precio_mediano, serie$grupo),
                              function(v) round(100 * v / v[1], 1)))
tabla("12_serie_mensual_por_grupo", serie)

cv_mes <- tapply(pmv$cv_pct, pmv$mes_num, median)
cat("CV intermercado mediano por mes (%):\n")
print(round(cv_mes, 2))
cat("\nVariacion del indice de precio por grupo (dic-24 base ene-24 = 100):\n")
idx_dic <- serie[serie$mes_num == 12, c("grupo", "indice")]
print(idx_dic[order(-idx_dic$indice), ], row.names = FALSE)

fig("09_evolucion_mensual", {
  par(mfrow = c(1, 2), mar = c(4.2, 4.4, 3.2, 1.0))
  gs <- sort(unique(serie$grupo)); cols <- paleta_n(length(gs))
  plot(NA, xlim = c(1, 12), ylim = range(serie$indice), xaxt = "n",
       xlab = "Mes de 2024", ylab = "Indice (enero = 100)",
       main = "Evolucion del precio mediano por grupo")
  axis(1, 1:12, substr(MESES <- c("Ene","Feb","Mar","Abr","May","Jun",
                                  "Jul","Ago","Sep","Oct","Nov","Dic"), 1, 3),
       cex.axis = 0.8)
  grid(col = "gray90", lty = 1)
  abline(h = 100, col = "gray45", lty = 2)
  for (i in seq_along(gs)) {
    d <- serie[serie$grupo == gs[i], ]
    lines(d$mes_num, d$indice, col = cols[i], lwd = 2.2)
  }
  legend("topleft", acortar(gs, 18), col = cols, lwd = 2.2, bty = "n", cex = 0.62)

  # Se grafica la mediana junto con el rango intercuartilico para no exagerar
  # visualmente una variacion mensual que en realidad es muy pequena.
  q1m <- tapply(pmv$cv_pct, pmv$mes_num, quantile, 0.25)
  q3m <- tapply(pmv$cv_pct, pmv$mes_num, quantile, 0.75)
  plot(NA, xlim = c(1, 12), ylim = c(0, max(q3m) * 1.15), xaxt = "n",
       xlab = "Mes de 2024", ylab = "CV intermercado (%)",
       main = "Dispersion geografica mes a mes")
  axis(1, 1:12, substr(MESES, 1, 3), cex.axis = 0.8)
  grid(col = "gray90", lty = 1)
  polygon(c(1:12, 12:1), c(q1m, rev(q3m)), col = adjustcolor(COL_PRIM, 0.18),
          border = NA)
  lines(1:12, as.numeric(cv_mes), type = "o", pch = 16, lwd = 2.4, col = COL_PRIM)
  legend("bottomright", c("Mediana", "Rango intercuartilico"),
         col = c(COL_PRIM, adjustcolor(COL_PRIM, 0.35)),
         lwd = c(2.4, 8), bty = "n", cex = 0.75)
})

# =============================================================================
# F. SINTESIS Y ANTICIPO DE LA FASE INFERENCIAL
# =============================================================================
linea("F. SINTESIS: CONTRASTES PRELIMINARES")

# Diferencias de dispersion entre grupos (no parametrico: no hay normalidad).
kw <- kruskal.test(cv_pct ~ grupo, data = pmv)
cat("Kruskal-Wallis  CV ~ grupo alimentario: H =", round(kw$statistic, 1),
    "| gl =", kw$parameter, "| p =", format.pval(kw$p.value, digits = 3), "\n")

av <- summary(aov(cv_pct ~ grupo, data = pmv))[[1]]
cat("ANOVA de un factor CV ~ grupo         : F =", round(av[1, 4], 1),
    "| p =", format.pval(av[1, 5], digits = 3),
    "| eta2 =", round(av[1, 2] / sum(av[, 2]), 3), "\n")

kw2 <- kruskal.test(brecha_pct ~ tipo_plaza, data = reg)
cat("Kruskal-Wallis  brecha ~ tipo de plaza: H =", round(kw2$statistic, 1),
    "| gl =", kw2$parameter, "| p =", format.pval(kw2$p.value, digits = 3), "\n")

cat("\nIC 95% para el CV intermercado medio (todos los productos-mes):\n")
print(round(ic_media(pmv$cv_pct), 3))

cat("\nAED finalizado. Figuras en", RUTA_FIGURAS, "y tablas en", RUTA_TABLAS, "\n")
