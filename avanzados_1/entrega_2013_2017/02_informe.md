# ¿Cuál es el precio justo?

**Nivel, volatilidad y variación de los precios mayoristas de alimentos en Colombia, 2013–2017**

Actividad evaluable 1 — *Métodos estadísticos avanzados 1*, Unidad 2: Estadística descriptiva.
Tema 2: "¿Cuál es el precio justo? Análisis de precios en el mercado local".

Todos los resultados de este documento los produce `01_analisis_precios.R` y quedan
registrados en `salida_consola.txt`, `salidas/tablas/` y `salidas/figuras/`.

---

## 1. Pregunta de investigación

**Principal**

> Entre 2013 y 2017, ¿qué tan distintas son la **volatilidad** y la **variación acumulada**
> del precio mayorista de los alimentos en Colombia según el **grupo de alimento**, la
> **región** y el **tipo de mercado** donde se comercializan?

**Derivada**

> Para el tomate de árbol, ¿existe un único "precio justo" nacional, o el precio promedio
> depende sistemáticamente de la plaza donde se compre?

La pregunta cumple los tres criterios de la guía: exige recolección y análisis de datos (no
se resuelve con un sí/no), involucra explícitamente variabilidad —es precisamente su
objeto— y es operacionalizable en unidades medibles (COP y %).

## 2. Objetivos

1. **Comparar** la volatilidad y la variación acumulada del precio mayorista entre grupos de
   alimentos, regiones y tipos de mercado en Colombia durante 2013–2017.
2. **Determinar**, para el tomate de árbol, la magnitud de la dispersión geográfica del
   precio promedio y su relación con el tipo de mercado.

## 3. Justificación del estudio

**¿Por qué es interesante este fenómeno?** El debate público sobre el precio de los
alimentos se concentra casi siempre en el nivel —si algo está caro o barato— y casi nunca en
la **estabilidad**. Para un hogar que compra semanalmente, un alimento cuyo precio oscila un
36 % a lo largo del año plantea un problema de planeación distinto al de uno que oscila un
7 %, aunque ambos cuesten lo mismo en promedio.

**¿A quién podría beneficiar?** A los hogares, que pueden anticipar en qué grupos conviene
prever holgura presupuestal; a los comerciantes, para dimensionar inventario y exposición al
riesgo de precio; y a las entidades públicas de abastecimiento, para focalizar dónde la
fragmentación del mercado es mayor.

**¿Qué se aprende?** Que "precio justo" no es un número nacional. Es una franja que depende
del grupo del alimento y de la posición de la plaza dentro de la cadena de comercialización.

**¿Qué decisiones habilita?** Identificar qué grupos de alimentos concentran el riesgo de
precio, y en qué tipo de plaza conviene abastecerse según se priorice costo o previsibilidad.

## 4. Datos

**Fuente.** DANE — Sistema de Información de Precios y Abastecimiento del Sector
Agropecuario (SIPSA), componente de precios mayoristas. Archivo `Mensual_2013_2017.xlsx`,
hoja `Anexar1`, exportado a `datos/mensual_2013_2017.csv` en UTF-8.

**Contenido.** 281 386 registros × 5 columnas. Cada registro es la cotización mensual de un
producto en una plaza mayorista.

| Campo | Tipo | Contenido |
|---|---|---|
| `Fecha` | fecha | 60 meses continuos, 2013-01 a 2017-12 |
| `Grupo` | categórica | 8 grupos alimentarios |
| `Producto` | categórica | 376 productos |
| `Fuente` | categórica | 97 plazas en 67 municipios |
| `Precio` | cuantitativa | COP (la mayoría por kg) |

## 5. Control de calidad de los datos

Verificado antes de calcular cualquier estadístico (sección 2 del script):

| Chequeo | Resultado |
|---|---|
| Valores faltantes (NA) en las 1 406 930 celdas | **0** |
| Duplicados exactos (Fecha, Producto, Fuente) | **0** |
| Precios menores o iguales a cero | **0** |
| Meses faltantes en la secuencia 2013-01 → 2017-12 | **0** |
| Inconsistencia de codificación en `Fuente` | **1 detectada y corregida** |
| Fuentes sin departamento o región asignada | **0 de 96** |

La inconsistencia detectada es real y habría sesgado el conteo: el mismo municipio aparecía
como `Ancuyá (Nariño)` y `Ancuya (Nariño)`, lo que partía una sola plaza en dos. Al
unificarlo, el número de fuentes pasa de **97 a 96**.

Los diagnósticos se **registran como información**, no como aserciones que aborten la
ejecución: un chequeo de calidad debe informar, no impedir que el documento se compile.

## 6. Diseño: por qué 281 386 filas no son 281 386 observaciones

Este es el punto metodológico central del trabajo. **Una fila no es una observación
independiente**: es un `producto × mes × plaza`. La misma serie —por ejemplo, tomate de
árbol en Corabastos— reaparece 60 veces. Calcular estadísticos sobre las filas crudas
contaría cada plaza sesenta veces.

Antes de describir hay que decidir la unidad de análisis. Aquí la unidad es la **serie
plaza-producto**, y el tiempo se colapsa en resúmenes de esa serie:

```
281 386 filas crudas         376 productos × 60 meses × 97 plazas (desbalanceado)
        │
        ├─ canasta de 16 productos (2 por grupo, los de mayor cobertura)
        │
        ├─ solo series con los 60 meses completos
        │
        ├─ 27 060 filas = 451 series × 60 meses      ← PANEL BALANCEADO
        │
        └─ colapso a una fila por serie
                 n = 451 unidades plaza-producto      ← UNIDAD DE ANÁLISIS
```

**Sobre el panel desbalanceado.** La base no tiene valores faltantes, pero eso no significa
que todas las series tengan las 60 mediciones: muchas combinaciones producto-plaza solo se
cotizan algunos meses. La respuesta no fue imputar ni borrar en silencio, sino **seleccionar
las series completas y documentar cuántas quedan**. El script lo verifica con
`stopifnot(nrow(panel) == length(series_completas) * 60)`, que devuelve `TRUE`.

**Canasta (16 productos, 2 por grupo).** Tomate de árbol y mora de Castilla (frutas);
pimentón, habichuela y cilantro (verduras); plátano hartón verde y papa criolla (tubérculos);
sal yodada y harina de trigo (procesados); lenteja importada y arroz de primera (granos);
sobrebarriga y pechuga de pollo (carnes); queso costeño y huevo rojo AA (lácteos); bocachico
importado congelado (pescados).

## 7. Definición de las variables

### Cuantitativas

| Variable | Definición | Unidad |
|---|---|---|
| `volatilidad_cv` | Coeficiente de variación del precio mensual en los 60 meses | % |
| `variacion_13_17` | Cambio del precio promedio anual entre 2013 y 2017 | % |
| `precio_promedio` | Precio mayorista medio del periodo | COP |
| `rango` | Precio máximo menos mínimo | COP |

> **Decisión metodológica.** Las dos variables principales son las porcentuales porque son
> **adimensionales y por tanto comparables entre productos**. `precio_promedio` no lo es: el
> SIPSA cotiza la mayoría de productos por kilogramo pero el huevo por unidad, de modo que la
> mediana va de 240 COP (huevo rojo AA) a 10 535 COP (sobrebarriga). Comparar esos números
> entre sí no significaría nada. Por eso **el análisis del nivel de precio se hace dentro de
> un solo producto**, el tomate de árbol, donde todas las plazas cotizan la misma unidad.

### Cualitativas

| Variable | Niveles | Origen |
|---|---|---|
| `Grupo` | 8 | Original |
| `tipo_mercado` | 2: central mayorista urbana / mercado municipal-acopio | **Derivada** |
| `region` | 4: Andina, Pacífica, Caribe, Orinoquía-Amazonía | **Derivada** |
| `Producto` | 16 | Original |

`tipo_mercado` se deriva de la convención de escritura del SIPSA en el campo `Fuente`:
`"Ciudad, Plaza"` identifica una ciudad capital o principal (46 fuentes), mientras que
`"Municipio (Departamento)"` identifica un municipio no capital (50 fuentes). `region` se
obtiene del departamento, extraído del paréntesis o de un mapa capital→departamento para las
20 ciudades principales. Las 96 fuentes quedan clasificadas sin excepción.

## 8. Resultados: variables cuantitativas

Las ocho medidas que exige la guía, más las de forma:

| Medida | `volatilidad_cv` (%) | `variacion_13_17` (%) |
|---|---|---|
| n | 451 | 451 |
| **Media** | 23.27 | 29.44 |
| **Mediana** | 22.17 | 20.51 |
| **Moda** (clase modal) | (19.2 , 25.0] | (−3.53 , 18.1] |
| **Mínimo** | 1.73 | −25.18 |
| **Máximo** | 59.94 | 191.32 |
| **Rango** | 58.21 | 216.51 |
| **Desviación estándar** | 12.46 | 32.65 |
| **Varianza** | 155.19 | 1 066.27 |
| Q1 — Q3 | 13.64 — 30.74 | 12.38 — 33.87 |
| IQR | 17.10 | 21.49 |
| Asimetría | +0.480 | **+2.265** |
| Exceso de curtosis | −0.402 | **+5.555** |
| Atípicos (regla 1.5·IQR) | 2 | **42** |

**Sobre la moda.** Ambas variables son continuas: casi ningún valor se repite, de modo que la
moda puntual no informa nada. Se reporta la **clase modal** de la tabla de frecuencias
agrupada por la regla de Sturges (k = ⌈log₂n + 1⌉ = 10 intervalos de igual amplitud). Es la
lectura correcta de "moda" para una variable continua.

**Elección de la medida de centro — justificación.** No es la misma para las dos variables:

- En `volatilidad_cv`, media (23.27) y mediana (22.17) casi coinciden y la asimetría es leve
  (+0.48). La **media es una medida de centro razonable**.
- En `variacion_13_17`, la media (29.44) supera en 43 % a la mediana (20.51), la asimetría es
  fuerte (+2.27), el exceso de curtosis es alto (+5.56) y hay 42 atípicos. Aquí la media está
  arrastrada por la cola derecha: se reporta **mediana e IQR**.

Este contraste es el argumento central del criterio "justifica sus decisiones": la medida no
se escoge por costumbre sino por la forma observada de cada distribución.

## 9. Resultados: variables cualitativas

Frecuencia absoluta, relativa y porcentaje (n = 451):

| `Grupo` | f | fᵣ | % |
|---|---|---|---|
| **Verduras y hortalizas** | **109** | 0.2417 | **24.17** |
| Frutas | 73 | 0.1619 | 16.19 |
| Tubérculos, raíces y plátanos | 64 | 0.1419 | 14.19 |
| Procesados | 58 | 0.1286 | 12.86 |
| Granos y cereales | 56 | 0.1242 | 12.42 |
| Carnes | 44 | 0.0976 | 9.76 |
| Lácteos y huevos | 37 | 0.0820 | 8.20 |
| Pescados | 10 | 0.0222 | 2.22 |

| `region` | f | % | | `tipo_mercado` | f | % |
|---|---|---|---|---|---|---|
| **Andina** | **246** | **54.55** | | **Central mayorista urbana** | **327** | **72.51** |
| Pacífica | 99 | 21.95 | | Mercado municipal / acopio | 124 | 27.49 |
| Caribe | 91 | 20.18 | | | | |
| Orinoquía-Amazonía | 15 | 3.33 | | | | |

**Categoría más frecuente:** verduras y hortalizas (24.17 %), región Andina (54.55 %) y
central mayorista urbana (72.51 %).

**Advertencia de interpretación.** Estas frecuencias describen la **cobertura del SIPSA**,
no el consumo ni la producción del país. Que la región Andina concentre el 54.55 % de las
series significa que allí hay más plazas monitoreadas con series completas, no que allí se
consuma más. Confundir distribución de la muestra con distribución de la población sería un
error de lectura.

## 10. Interpretación de las figuras

### Figura 1 — Barras: composición por grupo
`salidas/figuras/01_barras_grupo.png`

La categoría más frecuente es **verduras y hortalizas, con 109 series (24.17 %)**, seguida de
frutas (16.19 %). Pescados es marginal (2.22 %, 10 series), lo que obliga a leer con cautela
cualquier estadístico de ese grupo. Se usan barras y no sectores porque comparar longitudes
sobre un eje común es más preciso que comparar ángulos cuando hay ocho categorías.

### Figura 2 — Sectores: composición por tipo de mercado
`salidas/figuras/02_sectores_tipo_mercado.png`

**72.51 % de las series provienen de centrales mayoristas urbanas** y 27.49 % de mercados
municipales. El gráfico de sectores es apropiado aquí, y solo aquí, porque hay exactamente
dos categorías mutuamente excluyentes que suman el 100 %. La muestra pondera el eslabón
urbano de la cadena, lo que debe tenerse presente al leer los promedios nacionales.

### Figura 3 — Histograma y densidad: volatilidad
`salidas/figuras/03_histograma_volatilidad.png`

La distribución es **unimodal y levemente asimétrica a la derecha** (asimetría +0.48). Las
líneas de media (23.3 %) y mediana (22.2 %) aparecen casi superpuestas, lo que confirma
gráficamente lo que dice el coeficiente. El exceso de curtosis negativo (−0.40) indica una
distribución algo más aplanada que la referencia normal: la volatilidad no se concentra en un
valor típico sino que se reparte ampliamente entre 10 % y 35 %. **No hay una volatilidad
"normal" de los alimentos**; hay regímenes distintos, y la figura 4 muestra cuáles.

### Figura 4 — Diagrama de caja: volatilidad por grupo ★
`salidas/figuras/04_caja_volatilidad_por_grupo.png`

**El hallazgo central.** El CV mediano ordena los grupos en una escalera nítida:

| Grupo | n | CV mediano | CV medio |
|---|---|---|---|
| Procesados | 58 | **6.71 %** | 7.26 |
| Carnes | 44 | 10.84 % | 12.19 |
| Pescados | 10 | 13.20 % | 13.75 |
| Lácteos y huevos | 37 | 13.65 % | 13.83 |
| Frutas | 73 | 23.05 % | 23.48 |
| Verduras y hortalizas | 109 | 30.14 % | 30.54 |
| Granos y cereales | 56 | 30.89 % | 27.89 |
| **Tubérculos, raíces y plátanos** | 64 | **36.24 %** | 35.66 |

Los tubérculos son **5.4 veces más volátiles** que los procesados. La lectura contextualizada:
los alimentos procesados tienen transformación industrial, almacenamiento prolongado y
contratos de suministro, mecanismos que amortiguan el precio; los perecederos agrícolas
dependen del ciclo de cosecha y del clima, y no se pueden almacenar para arbitrar entre meses.

Dos matices que el boxplot hace visibles y una tabla de medias ocultaría:

- **Granos y cereales** es el único grupo donde la media (27.89) queda *por debajo* de la
  mediana (30.89) y la dispersión interna es la mayor (sd 12.89). El grupo no es homogéneo:
  contiene arroz de primera (CV 14.5 %) y lenteja importada (CV 40.2 %) en el mismo cajón.
- **Verduras y hortalizas** concentra los valores extremos superiores (hasta 59.94 %).

**Advertencia.** Es una asociación descriptiva entre grupo y volatilidad, no una relación
causal demostrada. El grupo alimentario no *causa* la volatilidad; ambos comparten el hecho
subyacente de la perecibilidad y la estructura de la cadena.

### Figura 5 — Dispersión: volatilidad frente a variación acumulada
`salidas/figuras/05_dispersion_volatilidad_variacion.png`

La asociación entre las dos variables cuantitativas es **positiva y moderada**:
**Pearson r = 0.443**, Spearman = 0.404. Los alimentos cuyo precio osciló más entre meses
fueron también los que más se encarecieron en el quinquenio. Que ambos coeficientes sean
similares indica que la relación no está sostenida por unos pocos puntos extremos.

La nube revela además una estructura que el coeficiente por sí solo no muestra: un **clúster
separado, arriba a la derecha, compuesto exclusivamente por lenteja importada** — 27 series
con variación mediana de **+130.6 %** y CV mediano de 40.2 %. Ese clúster explica por sí solo
casi dos tercios de los 42 atípicos de `variacion_13_17`. Es coherente con el contexto
macroeconómico del periodo: el peso colombiano se devaluó de forma pronunciada entre 2014 y
2016, y la lenteja es un producto importado cuyo precio interno sigue al tipo de cambio.

Este es un ejemplo de por qué **un coeficiente de correlación se lee siempre junto a su
diagrama de dispersión**: r = 0.443 resume la tendencia, pero no habría revelado que una
fracción del efecto proviene de un grupo identificable y con explicación propia.

### Figura 6 — Caja y puntos: tomate de árbol por tipo de mercado
`salidas/figuras/06_tomate_por_tipo_mercado.png`

Ver la sección siguiente.

## 11. Producto testigo: tomate de árbol

39 plazas con serie completa. Al ser un solo producto, todas cotizan la misma unidad y el
nivel de precio sí es comparable.

| Medida | Valor (COP) |
|---|---|
| n | 39 plazas |
| **Media** | 1 639.39 |
| **Mediana** | 1 702.23 |
| **Moda** (clase modal) | (1 664 , 1 794] con f = 12 (30.77 %) |
| **Mínimo** | 1 144.13 |
| **Máximo** | 2 054.60 |
| **Rango** | 910.47 |
| **Desviación estándar** | 233.13 |
| **Varianza** | 54 351.81 |
| Q1 — Q3 | 1 458.11 — 1 820.92 |
| IQR | 362.81 |
| Asimetría | **−0.440** |
| Exceso de curtosis | −0.743 |
| Atípicos (1.5·IQR) | **0** |

Tabla de frecuencias agrupada (Sturges, k = 7):

| Clase (COP) | f | fᵣ | % | F acum. | % acum. |
|---|---|---|---|---|---|
| [1 144 , 1 274] | 2 | 0.0513 | 5.13 | 2 | 5.13 |
| (1 274 , 1 404] | 6 | 0.1538 | 15.38 | 8 | 20.51 |
| (1 404 , 1 534] | 4 | 0.1026 | 10.26 | 12 | 30.77 |
| (1 534 , 1 664] | 4 | 0.1026 | 10.26 | 16 | 41.03 |
| **(1 664 , 1 794]** | **12** | 0.3077 | **30.77** | 28 | 71.79 |
| (1 794 , 1 925] | 8 | 0.2051 | 20.51 | 36 | 92.31 |
| (1 925 , 2 055] | 3 | 0.0769 | 7.69 | 39 | 100.00 |

**Asimetría negativa: la media queda por debajo de la mediana.** Es el caso inverso al
habitual en precios, y tiene una explicación concreta. Las cinco plazas más baratas están
todas en el **Oriente antioqueño**, que es justamente la zona productora de tomate de árbol:

| Plaza más barata | Depto. | Precio | CV | | Plaza más cara | Depto. | Precio | CV |
|---|---|---|---|---|---|---|---|---|
| Sonsón | Antioquia | 1 144 | 30.1 % | | Chiquinquirá | Boyacá | 2 055 | 19.2 % |
| El Santuario | Antioquia | 1 186 | 28.5 % | | Villavicencio | Meta | 1 986 | 17.4 % |
| San Vicente | Antioquia | 1 276 | 27.0 % | | Buenaventura | Valle | 1 938 | 21.5 % |
| Marinilla | Antioquia | 1 280 | 26.4 % | | San Gil | Santander | 1 904 | 19.6 % |
| Peñol | Antioquia | 1 287 | 26.7 % | | Socorro | Santander | 1 899 | 19.7 % |

Ese racimo de plazas productoras baratas arrastra la media hacia abajo y genera la cola
izquierda. Y el patrón es simétrico en el otro sentido: **las plazas más baratas son las más
volátiles** (CV 26–30 %) y **las más caras, las más estables** (CV 17–22 %). Cerca del origen
el precio es bajo pero sigue el pulso de la cosecha; en el mercado de destino la cadena de
distribución absorbe parte de la oscilación y cobra por ello.

**Brecha entre la plaza más cara y la más barata: 1.80 veces**, para el mismo producto, en el
mismo país y en el mismo periodo.

**Matiz honesto sobre `tipo_mercado`.** En el conjunto de la canasta las centrales
mayoristas son más caras (precio mediano 2 001 vs 1 639 COP) y más estables (CV 20.29 % vs
26.96 %). Pero **para el tomate de árbol en particular las medianas son casi idénticas**
(1 700 vs 1 725 COP): lo que distingue a los mercados municipales no es el nivel sino la
**dispersión entre plazas** (sd 307 vs 158). Es decir, los mercados municipales no son
uniformemente baratos; incluyen tanto las plazas productoras muy baratas como plazas remotas
caras. La conclusión correcta no es "el mercado municipal es más barato", sino **"el tipo de
mercado predice mejor la variabilidad del precio que su nivel"**.

## 12. Respuesta descriptiva a la pregunta de investigación

**No existe un "precio justo" nacional único.**

**1.** Para el tomate de árbol, el precio promedio 2013–2017 va de **1 144 a 2 055 COP** según
la plaza: una **brecha de 1.80 veces**. Esa diferencia no es ruido aleatorio, sino que sigue
la posición de la plaza en la cadena: las plazas productoras del Oriente antioqueño son las
más baratas y las más volátiles; los mercados de destino son más caros y más estables. Un
precio de referencia razonable es la **mediana, 1 702 COP, con franja intercuartílica de
1 458 a 1 821 COP** — la mediana y no la media (1 639), porque la distribución es asimétrica
a la izquierda (−0.44).

**2.** A nivel de canasta, lo que más separa a los alimentos **no es el nivel sino la
estabilidad**: el CV mediano va de **6.71 % en procesados a 36.24 % en tubérculos**, una
razón de 5.4 veces entre extremos.

**3.** Volatilidad y encarecimiento **van juntos**: r de Pearson = 0.443 (Spearman 0.404).
Los alimentos que más oscilaron mes a mes fueron también los que más subieron en el
quinquenio, con la lenteja importada (+130.6 %) como caso extremo atribuible a la
devaluación del peso entre 2014 y 2016.

## 13. Alcance y limitaciones

- **Todos los resultados son descriptivos y de asociación.** No se realizó ninguna prueba de
  hipótesis ni se estimó ningún intervalo de confianza; no se afirma relación causal alguna.
  La inferencia corresponde a la siguiente fase del proyecto.
- **La muestra no es probabilística.** Las 451 series son las que tienen cobertura completa
  en el SIPSA, no una muestra aleatoria de las plazas del país. Los porcentajes describen la
  muestra, no la población de mercados colombianos.
- **Los precios son mayoristas**, no de venta al consumidor final.
- **No se modela la estructura temporal** (estacionalidad, tendencia): el tiempo se colapsa
  deliberadamente en resúmenes por serie, coherente con el nivel descriptivo de esta entrega.
- **Las 60 observaciones de una misma serie no son independientes entre sí**, razón por la
  cual se colapsan a una fila antes de calcular cualquier estadístico o correlación.

## 14. Reproducción

```r
# Desde la carpeta entrega_2013_2017, en la consola de R:
source("01_analisis_precios.R")
```

Requiere **solo R base**. Si `readxl` está instalado y el `.xlsx` original está disponible, el
script lo lee directamente; en caso contrario usa el CSV incluido en `datos/`. Ambas rutas
producen el mismo resultado. La ejecución genera las 6 figuras, las 8 tablas y
`salida_consola.txt`.

## 15. Fuente

DANE — Sistema de Información de Precios y Abastecimiento del Sector Agropecuario (SIPSA),
componente de precios mayoristas. <https://microdatos.dane.gov.co/index.php/catalog/776>
