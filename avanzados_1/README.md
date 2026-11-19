# ¿Cuál es el precio justo?

**Nivel y dispersión geográfica de los precios mayoristas de alimentos en Colombia, 2024**

Proyecto de estadística — Maestría en Inteligencia Artificial, Universidad de La Sabana.
Fase 1: análisis exploratorio, formulación de la pregunta de investigación y diseño del estudio.

---

## Pregunta de investigación

> ¿En qué medida el nivel de precio de un alimento explica la dispersión geográfica
> de su precio entre los mercados mayoristas de Colombia durante 2024, y cómo se
> modifica esa relación según el grupo alimentario y el tipo de plaza en que se transa?

## Datos

`datos/mensual_24.csv` — SIPSA (DANE), precios mayoristas mensuales de 2024.
54.042 registros, 349 productos, 80 mercados, 24 departamentos, 8 grupos alimentarios.

## Variables del estudio

**Cuantitativas**

| Variable | Descripción | Unidad |
|---|---|---|
| `precio_kg` | Precio promedio mensual por kilogramo | COP/kg |
| `cv_pct` | Coeficiente de variación del precio entre mercados (derivada) | % |
| `brecha_pct` | Desviación frente a la mediana nacional del producto-mes (derivada) | % |
| `n_mercados` | Mercados que cotizan el producto en el mes (derivada) | conteo |

**Cualitativas**

| Variable | Categorías |
|---|---|
| `grupo` | 8 grupos alimentarios (original) |
| `tipo_plaza` | 4: central de abastos, plaza urbana, municipio productor, frigorífico (derivada) |
| `region` | 5 regiones naturales (derivada) |
| `mes` | 12 meses de 2024 (original) |

## Cómo ejecutarlo

Desde la raíz del proyecto, en la consola de R:

```r
source("ejecutar_todo.R")
```

El análisis usa **solo R base**: no requiere instalar paquetes.
El paso final genera el informe HTML y necesita `rmarkdown`; si no está instalado,
ese paso se omite con un aviso y el resto del pipeline se completa igual
(el informe ya renderizado se incluye en `informe/informe_fase1.html`).

Para ejecutar los scripts por separado:

```r
source("R/01_carga_y_enriquecimiento.R")   # depuración y variables derivadas
source("R/02_analisis_exploratorio.R")     # figuras, tablas y contrastes
```

> **Nota sobre codificación:** el archivo CSV está en UTF-8 con BOM. La sesión de R
> debe usar UTF-8 (en Windows con R ≥ 4.2 es el valor por defecto). El script de
> carga verifica que se hayan leído las 54.042 filas y se detiene con un mensaje
> explícito si no es así.

## Estructura

```
.
├── datos/
│   ├── mensual_24.csv                 fuente original
│   ├── precios_registro.rds           base a nivel producto x mercado x mes
│   └── precios_producto_mes.rds       base agregada producto x mes
├── R/
│   ├── 00_utilidades.R                funciones auxiliares y estilo gráfico
│   ├── 01_carga_y_enriquecimiento.R   lectura, depuración, variables derivadas
│   └── 02_analisis_exploratorio.R     análisis exploratorio completo
├── salidas/
│   ├── figuras/                       9 figuras PNG
│   ├── tablas/                        12 tablas CSV
│   └── log_aed.txt                    salida de consola del análisis
├── informe/
│   ├── informe_fase1.Rmd              informe reproducible
│   └── informe_fase1.html             informe renderizado
├── ejecutar_todo.R
└── README.md
```

## Principales hallazgos del exploratorio

- El precio mayorista mediano nacional es de **4.945 COP/kg**, con una distribución
  fuertemente asimétrica (asimetría 4,61) que se normaliza al transformar a log₁₀.
- El precio de un mismo producto varía en mediana **16,3%** entre mercados en un
  mismo mes: la plaza más cara cobra 1,75 veces lo de la más barata.
- La dispersión **cae al subir el nivel de precio** (Spearman −0,379): el cuartil
  de alimentos más baratos casi duplica la dispersión del cuartil más caro.
- Esa relación **se invierte en lácteos y huevos** (Spearman +0,53), lo que indica
  un efecto de interacción entre nivel de precio y grupo alimentario.
- Los mercados de municipio productor cotizan por debajo de la referencia nacional
  y las plazas urbanas por encima; **Amazonía y Orinoquía pagan los mayores
  sobreprecios** del país.
- La dispersión es **estable a lo largo del año**, lo que sugiere fragmentación
  estructural y no estacional.

## Fuente

DANE — Sistema de Información de Precios y Abastecimiento del Sector Agropecuario
(SIPSA), componente de precios mayoristas.
<https://microdatos.dane.gov.co/index.php/catalog/776>
