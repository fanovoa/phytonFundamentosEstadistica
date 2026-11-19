# Guía reutilizable: análisis descriptivo en R y RStudio para la Actividad evaluable 1

- **Curso:** MEA1 – Métodos Estadísticos Avanzados 1 · Estadística descriptiva.
- **Propósito:** aplicar el mismo procedimiento a **cualquier base de datos y a cualquiera de los tres temas** de la guía de actividades, sin repetir el análisis de las sesiones. Reúne los requisitos de la guía, la regla de alcance, el orden de ejecución de 15 pasos, un plan de trabajo parametrizado y el análisis completo de las sesiones 2 y 3.
- **Origen:** consolidación del trabajo realizado el 15/09/2026 sobre la base de estudiantes (`Actividad1/`, versiones 1 a 3). Las marcas **S2**, **S3** y **S2 + S3** indican de qué sesión procede cada concepto.
- **Cómo usar esta guía en cuatro pasos:** (1) escoger el tema y comprobar que la base lo permite (Parte A); (2) confirmar el alcance y el orden de ejecución (Parte B); (3) seguir el plan parametrizado con la base nueva (Parte C); (4) consultar la tabla de conceptos, los errores a evitar y la correspondencia con la rúbrica (Parte D).

---

# Parte A. Requisitos de la guía de actividades y elección del tema

Fuente: `Sesion2/GuiaAprendizaje.pdf` (Actividad evaluable 1, "Primera entrega del proyecto: video en YouTube", 10 horas, individual).

## A.1 Qué exige la guía

| Elemento | Exigencia |
|---|---|
| Tema | Elegir uno de los tres temas propuestos (A.2). |
| Base de datos | Al menos una base confiable relacionada con el tema. |
| Variables | Identificar **al menos dos cualitativas y al menos dos cuantitativas** dentro de la base. |
| **Validación previa de la base (regla de este proyecto)** | Antes de aceptar una base, comprobar que tenga **mínimo 3 variables cualitativas y 3 cuantitativas** utilizables (excluidos identificadores y variables de tiempo; las derivadas cuentan solo si se declaran como tales). Es más exigente que el mínimo de la guía para dejar margen a la pregunta (≥ 2 cuantitativas + 1 categórica), a la comparación por grupos y al ACP. Si no se cumple, derivar variables o cambiar de base. |
| Pregunta de investigación | Clara, relevante, cuantificable; involucra **al menos dos cuantitativas y una categórica**; no es cerrada (sí/no); requiere datos y variabilidad; cumple claridad, viabilidad y medición cuantitativa. Se recomienda una búsqueda exploratoria previa (estado del arte). |
| Justificación | Responder: ¿por qué es interesante el fenómeno?, ¿a quién beneficia?, ¿qué se aprende?, ¿qué decisiones permite? |
| Objetivos | Uno o dos, iniciando con **analizar, estimar, comparar, describir, determinar o identificar**. |
| Análisis exploratorio | Cuantitativas: **media, mediana, moda, mínimo, máximo, rango, desviación estándar y varianza**. Cualitativas: **tabla de frecuencias, frecuencia relativa, proporciones o porcentajes**. |
| Visualización | Barras, sectores, histogramas, cajas, dispersión según el tipo de variable; **interpretar** (categoría más frecuente, simetría o asimetría, valores atípicos). |
| Herramienta | El análisis debe realizarse **completamente en RStudio**. |
| Respuesta | Formular una respuesta descriptiva a la pregunta. |
| Entrega | Video de **máximo 2 min 10 s** en YouTube, con presentación en PowerPoint o Canva y el expositor visible en una esquina durante toda la grabación. |

**Rúbrica (5 puntos):**

| Criterio | Excelente | Qué exige para el máximo |
|---|---|---|
| Claridad y coherencia de la pregunta | 1.0 | Clara, relevante, cuantificable, coherente con el contexto y bien formulada. |
| Organización y presentación de los datos | 1.0 | Datos completos, organizados, sin errores evidentes, listos para el análisis. |
| Aplicación de técnicas estadísticas descriptivas | 1.5 | Aplica correctamente las técnicas requeridas **y justifica sus decisiones con claridad**. |
| Interpretación de resultados y conclusiones | 1.5 | Precisas, pertinentes, bien argumentadas y **contextualizadas**. |

## A.2 Los tres temas y sus preguntas orientadoras

| Tema | Preguntas orientadoras de la guía |
|---|---|
| **Tema 1. ¿Cuánto tiempo pasamos en redes sociales?** | ¿Qué información se necesita para estimar el tiempo promedio en redes? ¿Qué características de la población interesan (edad, género, tipo de red, ocupación)? ¿Qué decisiones estadísticas se tomarán para describir los datos y estimar un intervalo de confianza para el tiempo promedio diario? ¿Qué utilidad práctica tienen los resultados para el entorno educativo, familiar o social? ¿Cómo comunicar los hallazgos de manera clara? |
| **Tema 2. ¿Cuál es el precio justo? Análisis de precios en el mercado local** | ¿Qué producto se analizará y con qué criterios consistentes (marca, tamaño, presentación, lugar de compra)? ¿Qué establecimientos se incluirán (supermercados, tiendas de barrio, plazas)? ¿Cómo garantizar cobertura de la diversidad del mercado? ¿Qué medidas identifican el "precio justo"? ¿Qué utilidad tiene un intervalo de confianza para el precio promedio? ¿Cómo varían los precios según ubicación o tipo de tienda? ¿Qué variables adicionales explorar? |
| **Tema 3. ¿Influye nuestro estilo de vida en el rendimiento académico?** | ¿Qué aspectos del estilo de vida (actividad física, sueño, alimentación, estrés) se analizarán y por qué? ¿Qué variables miden cuantitativamente el estilo de vida y el rendimiento? ¿Cómo se transformarán en datos numéricos? ¿Qué hipótesis inicial se plantea? ¿Qué tipo de análisis la contrastaría? ¿Qué beneficios obtienen estudiantes, docentes o instituciones? |

Nota: los intervalos de confianza que menciona la guía pertenecen a fases posteriores del proyecto; en esta primera entrega el análisis es descriptivo.

## A.3 Cómo escoger el tema según la base disponible

Antes de decidir, inspeccionar la base (paso 2 a 5 del orden de ejecución) y responder la tabla. El tema viable es aquel en que todas las casillas quedan cubiertas con variables **reales** de la base o derivables de ella.

| Requisito | Tema 1 (redes sociales) | Tema 2 (precios) | Tema 3 (estilo de vida) |
|---|---|---|---|
| Variable respuesta cuantitativa | Horas diarias en redes sociales (o por plataforma) | Precio del producto | Medida de rendimiento o desempeño (nota, promedio, puntaje, índice) |
| Al menos otra cuantitativa | Edad, horas de sueño, horas de estudio, número de plataformas | Tamaño o presentación, distancia, cantidad | Horas de sueño, de estudio, de ejercicio, uso del teléfono, nivel de estrés |
| Cualitativas (mínimo dos) | Género, ocupación, tipo de red, rango de edad | Tipo de establecimiento, marca, barrio o zona, presentación | Género, nivel de estrés categorizado, perfil de hábitos, programa |
| Unidad de análisis | Persona | Observación de precio (producto en un establecimiento) | Estudiante |
| Pregunta modelo | ¿Cómo varía el tiempo diario en redes sociales según la edad y la ocupación, y difiere entre géneros? | ¿Cómo varía el precio de X según el tipo de establecimiento y la zona, y qué tan dispersos son los precios? | ¿Cómo se relacionan las horas de estudio y de sueño con el desempeño, y cómo varía según el género y el nivel de estrés? |
| Riesgos típicos | Tiempo autorreportado con colas largas: mediana e IQR antes que media | Precios en unidades distintas: normalizar por tamaño antes de comparar | La variable de "rendimiento" puede no asociarse con nada (ocurrió con `final_grade`): elegir la medida con estructura y declararlo |

**Validación previa obligatoria:** contar las variables utilizables de la base; debe haber **al menos 3 cualitativas y 3 cuantitativas** (sin contar identificadores ni tiempo). Si el conteo no llega, primero derivar variables declaradas (escala ordinal en niveles, perfil por medianas, rangos de edad) y, si aun así no alcanza, descartar la base para ese tema.

**Regla práctica de decisión:** si la base no tiene dos cualitativas, derivar una a partir de una escala ordinal (por ejemplo, estrés 1–10 en Bajo/Medio/Alto) o combinando dos cuantitativas respecto a sus medianas (perfil), y declarar que el corte es descriptivo. Si la variable respuesta natural no muestra asociación con ninguna otra, buscar otra medida de desempeño en la base y justificar el cambio.

## A.4 Plantilla de pregunta, justificación y objetivos

- **Pregunta:** «¿Cómo se relacionan [cuantitativa 1] y [cuantitativa 2] con [variable respuesta] en [unidad de análisis], y cómo varía esa relación según [categórica 1] y [categórica 2]?» Opcional: «…qué [grupos o perfiles] se diferencian en [respuesta]».
- **Justificación:** un párrafo por cada una de las cuatro preguntas de la guía, cerrando con el alcance descriptivo del estudio.
- **Objetivo general:** «Describir la relación entre … en una base de N [unidades]». **Específicos:** «Comparar la distribución de [respuesta] entre [categorías]»; «Identificar cuáles variables presentan mayor asociación lineal con [respuesta] y determinar si cambia según el grupo».

---

# Parte B. Regla de alcance, regla de inclusión y orden de ejecución

Estas reglas fueron fijadas con el material del curso y no dependen de la base ni del tema.

### Regla de alcance, regla de inclusión y orden de ejecución

#### Regla de alcance

**El alcance evaluable termina en los centroides** (S3, §7.5 "Interpretación de los grupos"). Todo lo que las prácticas incluyen después de ese punto se conserva en este documento solo como referencia y no se tiene en cuenta para la actividad ni para el cruce con la rúbrica.

| Origen | Cobertura | Estado |
|---|---|---|
| S2 | Bloques 1 a 30 completos: encuesta simulada, `USairpollution`, `respiratory`, contraste, producto de cierre y recomendaciones. | Dentro del alcance |
| S3 | §1.1 a §7.5: preparación, descriptiva de `Cars93`, correlación, ACP, construcción del Biplot e interpretación en capas hasta los centroides. | Dentro del alcance |
| S3 | §8 Función reutilizable `crear_biplot_correlacion()`. | ⛔ Fuera de alcance |
| S3 | §9 Extensión A: ACP y Biplot con `iris`. | ⛔ Fuera de alcance |
| S3 | §10 Extensión B: ACP y Biplot con `USArrests` y regiones. | ⛔ Fuera de alcance |
| S3 | §11 Errores evitados y §12 Reto integrador. | No son contenido temático nuevo; se conservan como referencia de evaluación. La pregunta 8 del reto (comparar Cars93, iris y USArrests) depende de §9–10 y queda fuera de alcance. |

**Conceptos afectados en la tabla de la sección 3:**

| # | Concepto | Motivo | Tratamiento |
|---|---|---|---|
| 106 | Información suplementaria | Se apoya en §6.4 (tipo de automóvil en el Biplot) y en §10 (región en USArrests). | Solo la parte de §6.4 está en alcance. |
| 109 | Comparación de bases en el plano | Requiere iris y USArrests (§9, 10) y la pregunta 8 del reto. | ⛔ Fuera de alcance |
| 110 | Función reutilizable | Corresponde a §8. | ⛔ Fuera de alcance |
| 115 | Reto integrador y perfil exploratorio | Es el entregable de S3, no un tema; su pregunta 8 depende de §9–10. | Referencia; pregunta 8 fuera de alcance. |
| 126 | Emparejar identificadores externos | Corresponde a §10. | ⛔ Fuera de alcance |

Resultado: de los 126 conceptos, **123 están dentro del alcance** (106 de forma parcial) y 3 quedan fuera (109, 110, 126).

#### Regla de inclusión de un concepto como "trabajado"

Un concepto se considera trabajado en el curso y entra en la tabla de la sección 3 si cumple las tres condiciones:

1. **Aparece dentro del alcance:** en S2 (bloques 1–30) o en S3 (§1.1–§7.5).
2. **Se ejecuta y se interpreta:** la práctica lo define o lo aplica con código y lo comenta en un bloque de "Análisis del resultado" (S2) o "Análisis guiado" (S3). Un término mencionado de paso sin código ni interpretación no cuenta.
3. **No depende exclusivamente de una sección excluida.** Si lo hace, se marca fuera de alcance aunque figure en la práctica.

Marca de origen: **S2** o **S3** si solo una sesión lo trabaja; **S2 + S3** si ambas lo ejecutan, y la descripción indica qué añade cada una.

#### Orden de ejecución

Secuencia única que integra el hilo conductor de S2 (unidad → tipos → estructura → resumen → gráfico → grupos → relaciones → interpretación) con la secuencia de S3 (descripción → correlación → ACP → Biplot). Cada paso indica su origen y los conceptos de la sección 3 que aplica.

| Paso | Qué se hace | Origen | Conceptos |
|---|---|---|---|
| 1 | Preparar el entorno: paquetes declarados, semilla fija, sin instalación dentro del documento. | S2 + S3 | 12, 15 |
| 2 | Cargar la base y fijar la **unidad de análisis**: qué representa una fila; separar identificadores y tiempo. | S2 + S3 | 1, 4, 13 |
| 3 | Inspeccionar estructura y tipos; tipificar las categóricas como factores; limpiar nombres y etiquetas. | S2 + S3 | 2, 3, 5, 16 |
| 4 | Verificar completitud; construir y reportar la muestra analítica única. | S2 + S3 | 6, 7, 8 |
| 5 | Formular la pregunta descriptiva antes de calcular o graficar; delimitar el alcance de la base. | S2 + S3 | 9, 10, 11 |
| 6 | Describir las **categóricas**: frecuencias absoluta y relativa, dominantes y minoritarias, barras. | S2 + S3 | 34, 35, 37, 38, 46, 47 |
| 7 | Describir las **cuantitativas**: media, mediana, moda, DE, cuartiles, IQR, mínimo y máximo; comparar media y mediana; elegir medidas justificadas. | S2 + S3 | 17–27 |
| 8 | Estudiar la **forma**: frecuencias agrupadas con Sturges, histograma y densidad, asimetría y curtosis, boxplot y valores extremos, siguiendo la secuencia histograma → media/mediana → boxplot. | S2 + S3 | 28–33, 36, 39–45, 53 |
| 9 | **Comparar grupos**: resúmenes por grupo, boxplots, solapamiento; lectura descriptiva sin salto causal. Si hay medidas repetidas, decidir el nivel (fila, sujeto) antes de resumir. | S2 + S3 (repetidas: S2) | 58–63, 75–79 |
| 10 | Explorar **relaciones bivariadas**: dispersión, Pearson y Spearman, matriz, ranking por magnitud, limitaciones; correlacionar siempre sobre la misma unidad. | S2 + S3 | 48–50, 64–74 |
| 11 | **ACP**: estandarizar, verificar varianza, ajustar `prcomp`, leer valores propios y varianza acumulada, comparar Kaiser, 80 % y scree plot. | S3 | 80–90 |
| 12 | **Interpretar componentes**: rotaciones, correlaciones variable–componente, contribuciones, nombrar CP1 y CP2 desde las cargas, signo arbitrario. | S3 | 91–95 |
| 13 | **Construir el Biplot**: scores, observaciones extremas, flechas con factor visual común, elipses descriptivas. | S3 | 96–100 |
| 14 | **Interpretar el Biplot en capas**: calidad del plano → calidad de representación → ángulos → posición de las observaciones → **centroides**. Aquí termina el alcance. | S3 | 101–105, 107, 108 (106 solo §6.4) |
| 15 | **Comunicar**: afirmaciones verificables, integración de número y gráfico, alcance delimitado, entregable correspondiente. | S2 + S3 | 111–115 |

Los pasos 1 a 10 se aplican a cualquier base (incluida la de estudiantes de la carpeta `Sesion2/database`); los pasos 11 a 14 solo cuando hay varias cuantitativas correlacionadas que justifiquen el ACP.

---



---

# Parte C. Plan de trabajo parametrizado para una base nueva

Basado en la ejecución de la Actividad 1 (base de estudiantes, versiones 1 a 3) y en la validación independiente de sus entregables. Sustituir los corchetes por los valores de la base y el tema elegidos.

## C.1 Stack tecnológico y comprobaciones del entorno

| Componente | Comprobación | Acción si falta |
|---|---|---|
| R (≥ 4.x) | `Rscript --version` (en Windows suele no estar en PATH: usar la ruta completa `C:\Program Files\R\R-x.y.z\bin\Rscript.exe`) | Instalar desde CRAN. |
| RStudio Desktop | Exigido por la guía; incluye pandoc, necesario para compilar el HTML con **Knit** | Instalar; sin él, verificar con `knitr::knit()` a Markdown. |
| `dplyr`, `ggplot2`, `knitr`, `rmarkdown` | `requireNamespace()` | El bloque `setup` del Rmd instala solo lo que falte (política de la sesión 2). |
| Generador de láminas (opcional) | Node + `pptxgenjs`, o PowerPoint/Canva a mano | `npm install pptxgenjs` en la carpeta de la presentación. |
| Control visual de láminas | PowerPoint (COM `SaveAs` tipo 18 exporta PNG) o LibreOffice | Revisar cada lámina exportada. |

Verificación sin pandoc (desde PowerShell, ajustar rutas):

```powershell
& "C:\Program Files\R\R-4.6.1\bin\Rscript.exe" -e "setwd('[carpeta]'); knitr::purl('[archivo].Rmd', output = 'verificacion.R', documentation = 1); options(warn = 1); source('verificacion.R', echo = FALSE, print.eval = TRUE, encoding = 'UTF-8')"
& "C:\Program Files\R\R-4.6.1\bin\Rscript.exe" -e "setwd('[carpeta]'); knitr::knit('[archivo].Rmd', output = '[archivo].md', encoding = 'UTF-8')"
```

## C.2 Inspección inicial de la base (antes de fijar la pregunta)

Lista de comprobación, con las funciones del curso:

1. **Dimensiones, nombres y tipos** (`dim`, `names`, `str`, `glimpse`, `head`): ¿qué representa una fila? ¿hay identificador único (`n_distinct(id) == nrow`)?
2. **Completitud** (`sum(is.na())`, `colSums(is.na())`, `complete.cases`): reportar n original, n final y criterio; usar una sola muestra analítica en todo el análisis.
3. **Tipos reales**: enteros que son escalas ordinales (Likert), códigos categóricos almacenados como números, identificadores, tiempo.
4. **Forma de las marginales** (histogramas, asimetría, exceso de curtosis): distribuciones planas, recortes en los bordes y cuartiles equiespaciados delatan bases simuladas; declararlo en un bloque de **advertencias sobre la base**.
5. **Consistencia interna**: sumas imposibles (más de 24 h por día), totales que no cuadran con sus partes, variables construidas como combinación lineal exacta de otras (`summary(lm(...))$r.squared ≈ 1`).
6. **Matriz de correlaciones exploratoria** (`cor()`): qué variables tienen estructura; si la respuesta natural no se asocia con nada, elegir otra medida y justificar.
7. **Conteo mínimo de variables**: la base debe tener **al menos 3 cualitativas y 3 cuantitativas** utilizables (identificadores y tiempo no cuentan; las derivadas cuentan si se declaran). Registrar el conteo en la tabla de variables del Rmd.
8. **Cualitativas disponibles**: si hay menos de tres, derivar una (escala ordinal en niveles, perfil por medianas) con corte declarado como descriptivo; conservar categorías minoritarias y documentarlas.

## C.3 Decisiones que hay que tomar y cómo justificarlas

| Decisión | Criterio | Cómo se justifica en el informe |
|---|---|---|
| Variable respuesta | La medida de desempeño o resultado **con estructura** (asociaciones observables) | Ranking de correlaciones y panel de asociaciones; si se descarta la variable "natural", mostrar su asociación nula. |
| Categóricas derivadas | Escala ordinal en 3 niveles equilibrados o perfil 2 × 2 por medianas | Tabla de correspondencia y de frecuencias; corte descriptivo, no clínico. |
| Media/DE o mediana/IQR | Simetría (media ≈ mediana, asimetría ≈ 0) → media/DE con mediana/IQR de respaldo; asimetría o extremos → mediana/IQR | Tabla de forma (asimetría, curtosis, separación media–mediana en DE). |
| Moda en continuas | Reportar la **clase modal** de Sturges; moda exacta solo en discretas | Explicar por qué la moda del valor exacto carece de sentido con muchos valores distintos. |
| Valores extremos | Regla 1.5·IQR; **no eliminar**; contextualizar | Tabla de conteo por variable y lectura como candidatos válidos. |
| Gráficos | Color siempre con significado; barras antes que sectores; leyenda solo si añade información; submuestra con semilla para nubes de más de ~5 000 puntos, estadísticas con todos | Subtítulos que expliquen cómo leer y qué datos usa cada capa. |
| ACP y Biplot (pasos 11–14) | Solo si hay varias cuantitativas correlacionadas; estandarizar; **la variable que define los grupos no debe ser activa**; nombrar solo componentes con valor propio claramente > 1 | Scree, tabla rotación/correlación/contribución, gráfico de cargas, cos², centroides, comparación de separación entre agrupaciones. |
| Conglomerados | No forman parte del alcance; si se comprueban con k-means, solo en un apéndice marcado fuera del alcance (silueta, curva sin codo) | Declarar que los grupos diferenciados son los definidos a priori y que la separación puede ser esperable por construcción. |
| Lenguaje | "acompaña", "se asocia", "en esta base"; nunca "causa" ni generalizaciones poblacionales | Tabla de afirmaciones respaldadas frente a excesivas. |

## C.4 Entregables y su estructura

1. **R Markdown** (`html_document`, toc flotante, secciones numeradas), secciones en el orden de los 15 pasos: presentación (pregunta, justificación, objetivos, tabla de variables con tipo y rol, unidad de análisis) → preparación (entorno, carga, estructura, completitud, advertencias) → cualitativas → cuantitativas → forma → grupos → relaciones → análisis complementario (ACP hasta centroides) → respuesta descriptiva (≤ 200 palabras: hallazgo univariado, comparación de grupos, relación bivariada, advertencia de alcance), afirmaciones respaldadas y excesivas, tabla de decisiones metodológicas → apéndice con correspondencia con la rúbrica y `sessionInfo()`. Cada línea de código con comentario en español y cada bloque seguido de "Análisis del resultado". Exportar figuras a 300 dpi con `ggsave()` para las láminas.
2. **Informe breve en Markdown**: pregunta, base, justificación, objetivos, variables, stack, advertencias, hallazgos con cifras, respuesta, correspondencia con la rúbrica.
3. **Guion del video**: una fila por lámina con tiempo, texto narrado, figura y cifra; contar palabras reales y declarar el ritmo (≈ 2.5 palabras por segundo para lectura normal); marcar láminas recortables de modo que la versión de 90 s conserve pregunta, variables, grupos, relación y alcance.
4. **Presentación**: una lámina por bloque del guion, casi sin texto, con notas del orador (texto y duración); cifras grandes; figuras a 300 dpi con paleta coherente con el Rmd; esquina inferior derecha libre para la cámara; sin texto ilegible en video (evitar gráficos con más de ~8 etiquetas pequeñas).
5. **README** con instrucciones de compilación en RStudio.

## C.5 Lista de verificación final (antes de grabar)

- [ ] El código extraído del Rmd corre sin errores ni warnings y el Markdown compilado no contiene `## Error`.
- [ ] Cada cifra de las láminas, el guion y el informe coincide con el análisis compilado (fuente de verdad).
- [ ] La base cumple la validación previa: **≥ 3 cualitativas y ≥ 3 cuantitativas** utilizables (derivadas declaradas incluidas), por encima del mínimo de la guía (2 y 2).
- [ ] La pregunta incluye ≥ 2 cuantitativas y ≥ 1 categórica; la tabla de variables identifica ≥ 2 cualitativas y ≥ 2 cuantitativas.
- [ ] Cada lámina habla de lo mismo en título, gráfico, cifras y nota; toda comparación narrada tiene soporte visual en esa lámina.
- [ ] Las categorías o perfiles derivados se definen en pantalla la primera vez que aparecen.
- [ ] Lenguaje no causal; los términos técnicos (eje de desempeño, variable suplementaria, niveles) se usan igual en todos los documentos.
- [ ] Duraciones sumadas ≤ 90 s (o versión recortable que lo cumpla); ritmo real de palabras declarado.
- [ ] Ningún texto cortado, solapado o ilegible en las láminas exportadas; esquina de la cámara libre.
- [ ] Todas las conclusiones dicen "en esta base" y el cierre declara el alcance descriptivo.
- [ ] Nombre del autor en el Rmd y en la portada; RStudio instalado para el Knit final.

---

# Parte D. Análisis de las sesiones 2 y 3 (referencia completa)

Extraído del consolidado `Analisis_Sesiones_2_y_3_Conceptos.md`. La numeración de conceptos (1–126) es la que se cita en la Parte B.

### 1. Contexto general

#### 1.1 Ubicación de las sesiones en el curso

| Sesión | Archivo | Enfoque |
|---|---|---|
| 1 | `Sesion1/MEA1_RStudio_Manejo_Bases_Datos_sesion_1.html` | Manejo elemental de bases con dplyr: `select`, `filter`, `mutate`, `arrange`, `count`, operador pipe. Bases `iris`, `attenu`, `morley`. No se analiza aquí. |
| **2 (S2)** | `Sesion2/Practica_Descriptiva_R_100min_V5_COMPILABLE_SIN_FALTANTES.html` | Estadística descriptiva y análisis exploratorio: resúmenes numéricos, forma, gráficos, comparación de grupos, correlación de Pearson y unidad de análisis. |
| **3 (S3)** | `Sesion3/Practica_Analisis_Descriptivo_PCA_Biplot_MEA1_V2_Guia_Interpretada.html` | Repaso descriptivo, correlación de Pearson y Spearman, Análisis de Componentes Principales (ACP) y Biplot. |

La sesión 2 asume los verbos de dplyr de la sesión 1. La sesión 3 retoma la descriptiva de la sesión 2 y usa la matriz de correlaciones como puente hacia el ACP.

#### 1.2 Sesión 2 (S2): práctica de estadística descriptiva

**Pregunta rectora:** ¿Cómo cambia nuestra descripción estadística cuando pasamos de una base simulada, cuyo mecanismo de generación conocemos, a bases reales completas cuya estructura y contexto debemos comprender antes de analizar?

**Hilo conductor:** comprender la unidad de análisis → reconocer los tipos de variables → verificar la estructura → resumir numéricamente → representar gráficamente → comparar grupos → explorar relaciones → integrar la evidencia en una interpretación estadística.

**Resultados de aprendizaje declarados:** identificar variables cuantitativas y categóricas; construir resúmenes globales y por grupos; seleccionar medidas de centro y dispersión coherentes con la forma; elegir visualizaciones pertinentes; explorar asociaciones entre cuantitativas; comunicar conclusiones sustentadas en evidencia numérica y gráfica.

**Política de paquetes:** `dplyr` (única librería de manipulación), `ggplot2` (única de visualización), `HSAUR3` solo como contenedor de datos cargado con `data(..., package = "HSAUR3")`, y R base para todos los estadísticos. No se estudian datos faltantes; las bases se verifican completas con `sum(is.na(base))`.

**Estructura (100 minutos):**

| Parte | Bloques | Base | Unidad de análisis | Tamaño |
|---|---|---|---|---|
| I. Práctica guiada | 1–12 | Encuesta simulada: `ciudad` (6 niveles), `edad`, `estatura`, `peso`, `genero` (2 niveles); semilla 2402; relación deliberada estatura → peso y estatura por género | Persona simulada | 80 × 5 |
| II. Reto A | 13–19 | `USairpollution`: `SO2`, `temp`, `manu`, `popul`, `wind`, `precip`, `predays` | Ciudad | 41 × 8 |
| II. Reto B | 20–27 | `respiratory`: `centre`, `treatment`, `gender`, `age`, `status`, `month`, `subject` | Registro paciente-momento; paciente al resumir | 555 registros, 111 pacientes, meses 0–4 |
| Cierre | 28–31 | Contraste de bases, producto de cierre, exit ticket, recomendaciones, referencias | — | — |

**Dataset en la carpeta de la sesión:** `Sesion2/database/student_productivity_distraction_dataset_20000.csv` (20 000 filas, 18 columnas) **no es usado por la práctica**; es la base probable de la actividad de aprendizaje. Identificador `student_id`; categórica `gender`; cuantitativas continuas `study_hours_per_day`, `sleep_hours`, `phone_usage_hours`, `social_media_hours`, `youtube_hours`, `gaming_hours`, `attendance_percentage`, `final_grade`, `productivity_score`; conteos o escalas discretas `age`, `breaks_per_day`, `coffee_intake_mg`, `exercise_minutes`, `assignments_completed`, `stress_level`, `focus_score`. Un estudiante por fila, sin medidas repetidas.

#### 1.3 Sesión 3 (S3): práctica de correlación, ACP y Biplot

**Secuencia declarada:** datos → descripción univariada → relaciones bivariadas → correlación → ACP → Biplot. El objetivo es interpretar qué información conserva cada procedimiento, qué decisiones intervienen y qué conclusiones son razonables.

**Bases:**

| Base | Paquete | Unidad de análisis | Uso |
|---|---|---|---|
| `Cars93` | `MASS` | Automóvil (93 modelos de 1993 en EE. UU.) | Principal. De 27 variables se seleccionan 5 categóricas (`type`, `drive_train`, `air_bags`, `origin`, `man_trans_avail`), 6 numéricas (`price`, `mpg_city`, `mpg_highway`, `engine_size`, `horsepower`, `weight`) y los identificadores `manufacturer`, `model`. |
| `iris` | R base | Flor (150) | Extensión A: ACP y Biplot con `Species` como grupo. |
| `USArrests` | R base | Estado (50) | Extensión B: ACP y Biplot con `state.region` como información suplementaria. |

**Política de paquetes:** no se instala nada automáticamente; si falta un paquete la compilación se detiene. Se usan `MASS`, `janitor`, `dplyr`, `tidyr`, `purrr`, `scales`, `knitr`, `ggplot2`, `patchwork`, `ggrepel`, `Hmisc` y `stats`, siempre con prefijo `paquete::función`. La semilla se fija aunque el ACP sea determinista: primero se controla el entorno, luego se analizan los datos.

**Estructura:**

| Sección | Contenido | Resultado clave |
|---|---|---|
| §2.1 Carga y selección | `complete.cases`, muestra analítica única, `str()` | 93 → 93 automóviles, 0 excluidos, 0 faltantes |
| §2.2 Categóricas | Frecuencias absoluta, relativa y porcentaje; dominantes y minoritarias; barras facetadas | Front 72.0 %, Midsize 23.7 %, Van 9.7 % |
| §2.3 Numéricas | Función de resumen; media, DE, mediana, IQR, min, max; tablas Sturges | Mayor separación media–mediana relativa: tamaño del motor |
| §2.4 Histogramas, densidades y cajas | Formato largo + facetas; regla 1.5·IQR; `patchwork` | Media > mediana en las seis variables |
| §2.5 Comparación por tipo | Medianas por `type`; boxplots facetados | Van más pesado, Large más potente, Small más eficiente |
| §3.1 Pearson y Spearman | `Hmisc::rcorr`; dos matrices comparadas | mpg_city–mpg_highway 0.944 |
| §3.2 Asociaciones dominantes | Pares únicos por valor absoluto; diferencia Pearson–Spearman | Mayor discrepancia price–mpg_city (0.192) |
| §4.1–4.2 ACP | Motivación, estandarización, SVD, verificación, `prcomp(scale. = TRUE)` | CP1 76.5 %, CP2 11.0 % |
| §4.3–4.4 Varianza y scree plot | Valores propios, acumulado, Kaiser, 80 %, codo | Kaiser 1; 80 % → 2; plano 87.5 % |
| §5 Rotaciones, correlaciones, contribuciones | Tres conceptos distintos | CP1: peso 0.936, mpg_city −0.913 |
| §6 Construcción del Biplot | Scores, coordenadas, factor visual, elipses, `ggrepel` | Factor visual 3.969 |
| §7 Interpretación en cinco capas | Plano, flechas, ángulos, puntos, grupos | Mejor representada mpg_city (0.947); peor engine_size (0.747) |
| §8 Función reutilizable ⛔ FUERA DE ALCANCE | `crear_biplot_correlacion()` | Entender antes de automatizar |
| §9–10 Extensiones ⛔ FUERA DE ALCANCE | iris y USArrests | 95.8 % y 86.8 % en CP1–CP2 |
| §11 Errores evitados | 15 malas prácticas | — |
| §12 Reto integrador | 10 preguntas para entregar | Perfil ≤ 200 palabras |

#### 1.4 Relación entre las dos sesiones

**Qué añade S3 sobre S2:** coeficiente de Spearman y la comparación Pearson–Spearman como diagnóstico; formato largo y facetas para muchas variables en una figura; tratamiento de faltantes con filas completas y reporte de la pérdida; ACP (estandarización, varianza explicada, criterios de retención, rotaciones, correlaciones variable–componente, contribuciones); Biplot de correlación e interpretación en cinco capas; elipses, centroides y calidad de representación. También incluye encapsular el procedimiento en una función y dos extensiones (iris, USArrests), pero quedan fuera del alcance evaluable.

**Qué conserva S3 de S2:** todos los conceptos marcados **S2 + S3** en la sección 3. Los más reiterados son unidad de análisis, tipos de variable como factores, media vs mediana, DE vs IQR, Sturges, histograma y boxplot, barras antes que sectores, outlier no es error, solapamiento de grupos, correlación de Pearson, descripción no es causalidad y afirmaciones verificables.

**Diferencias de enfoque:**

| Aspecto | S2 | S3 |
|---|---|---|
| Datos faltantes | Se evitan: bases completas por diseño | Se tratan con `complete.cases` y se reporta la pérdida |
| Paquetes | Solo dplyr + ggplot2 + R base | Varios paquetes con prefijo `paquete::` |
| Instalación | Automática de los faltantes | Manual, una sola vez; el documento se detiene si falta alguno |
| Correlación | Pearson con `cor()` | Pearson y Spearman con `Hmisc::rcorr()` (r, n, p) |
| Nivel de análisis | Univariado, bivariado y por grupos | Añade el multivariado (ACP, Biplot) |
| Entregable | Bloque R Markdown con 6 componentes + exit ticket | Reto integrador con 10 preguntas + preguntas por bloque |
| Extensión del texto | ≤ 180 palabras | ≤ 200 palabras |

#### 1.5 Entregables definidos por cada práctica (base probable de la rúbrica)

**S2 – Producto de cierre (bloque 29).** Cada equipo elige una base real y entrega un bloque breve de R Markdown con:

| # | Componente | Exigencia literal |
|---|---|---|
| 1 | Unidad de análisis y variables | Explicar qué representa una fila; identificar una categórica y dos cuantitativas. |
| 2 | Completitud | Confirmar con una instrucción de R que no hay datos faltantes. |
| 3 | Resumen | Centro y dispersión de una cuantitativa, **justificando** media/DE o mediana/IQR. |
| 4 | Visualización | Dos gráficos que respondan preguntas diferentes; el color representa información, no decora. |
| 5 | Relación | Asociación entre dos cuantitativas mediante dispersión y correlación. |
| 6 | Interpretación | Máximo 180 palabras: hallazgo univariado, comparación entre grupos, relación bivariada y advertencia sobre el alcance descriptivo. |

**S2 – Exit ticket:** (1) qué decisión sobre el tipo o significado de una variable fue esencial; (2) en qué caso la mediana fue más informativa que la media y por qué; (3) qué gráfico comunicaría mejor el hallazgo principal y qué evidencia concreta contiene.

**S3 – Reto integrador (§12).** Diez preguntas con resultados numéricos y evidencia gráfica:

| # | Pregunta | Exigencia literal |
|---|---|---|
| 1 | Perfil exploratorio de Cars93 | ≤ 200 palabras: composición categórica, dos características de distribuciones numéricas, dos asociaciones. |
| 2 | Correlaciones fuertes y geometría | Un par positivo y uno negativo fuertes; ¿el Biplot los reproduce y por qué? |
| 3 | Nombres de CP1 y CP2 | Citar al menos tres **correlaciones variable–componente**, no solo `rotation`. |
| 4 | Criterios de retención | Comparar Kaiser, 80 % y scree plot; cuántas componentes para descripción y cuántas para visualización. |
| 5 | Automóviles extremos | Dos casos explicados desde las flechas; no usar "atípico" sin justificar. |
| 6 | Tipos con centroides alejados | ¿Las cajas por tipo cuentan la misma historia que el Biplot? |
| 7 | Variable peor representada | Por qué su flecha exige prudencia y qué análisis adicional se haría. |
| 8 | Cars93 vs iris vs USArrests | Dónde convence más la representación bidimensional; fundamentar con varianza explicada y estructura visual. |
| 9 | Afirmaciones respaldadas vs excesivas | Tres de cada. |
| 10 | Nueva pregunta de investigación | Formularla e indicar la salida de R con la que se empezaría. |

En S3 cada bloque cierra con "Preguntas para resolver" y varios incluyen "Qué debería escribir un estudiante en su informe": pistas directas de la rúbrica.

---

### 2. Mapa de temas por bloque o sección

| Origen | Bloque / sección | Tema | Funciones y capas de R | Idea estadística central |
|---|---|---|---|---|
| S2 | b.1 | Construcción de la base simulada | `set.seed`, `sample`, `rnorm`, `pmin`/`pmax`, `data.frame`, `factor`, `sum(is.na())` | Unidad estadística; mecanismo generador conocido; datos completos |
| S2 | b.2 | Reconocimiento inicial | `names`, `dim`, `str`, `glimpse`, `head`, `tail`, `summary` | Verificar tipos antes de calcular; `summary()` no es un análisis terminado |
| S2 | b.3 | Centro, dispersión y posición (edad) | `summarise`, `mean`, `median`, `sd`, `quantile`, `IQR`, `min`, `max` | Media vs mediana como señal de forma; DE vs IQR |
| S2 | b.4 | Moda de variable discreta | `count(sort = TRUE)`, `slice_max(with_ties = TRUE)` | La moda se lee con su frecuencia; los empates son información |
| S2 | b.5 | Tabla de frecuencias agrupadas | `hist(breaks = "Sturges", plot = FALSE)$breaks`, `cut`, `cumsum` | Sturges como punto de partida; frecuencias absoluta, relativa, porcentual y acumulada |
| S2 | b.6 | Asimetría y exceso de curtosis | Funciones propias con momentos m2, m3, m4 | Signo de la asimetría; curtosis frente a la normal; leer junto al histograma |
| S2 | b.7 | Histograma y densidad | `geom_histogram(after_stat(density))`, `geom_density`, `geom_vline` | Forma: concentración, colas, huecos |
| S2 | b.8 | Edad por género | `geom_boxplot`, `stat_summary(fun = mean)` | Comparar mediana, IQR, bigotes, extremos; diferencia descriptiva no es poblacional |
| S2 | b.9 | Estatura y peso | `geom_point`, `geom_smooth(lm)`, `cor()` | Pearson 0.72; subgrupos dentro de una relación global |
| S2 | b.10 | Resumen conjunto de cuantitativas | `summarise(across(..., list(...)))` | Protocolo común; no comparar DE entre unidades distintas |
| S2 | b.11 | Categóricas por ciudad | `count`, `geom_col`, `geom_text`, `coord_flip`, `reorder` | Frecuencia y porcentaje; barras antes que sectores; muestra vs población |
| S2 | b.12 | Estatura por ciudad | `group_by`, `summarise(.groups = "drop")`, boxplot | Solapamiento; la ciudad no generó la estatura |
| S2 | b.13 | Carga de `USairpollution` | `data(package =)`, `mutate(ciudad = rownames())` | Unidad = ciudad; datos ecológicos |
| S2 | b.14 | Resumen del SO2 | `summarise` | Razón media/mediana 1.16 sugiere cola derecha |
| S2 | b.15 | Distribución del SO2 | Histograma + densidad + líneas de referencia | ¿La media representa a una ciudad típica? |
| S2 | b.16 | Manufactura y SO2 por grupos | `median`, `if_else`, boxplot | Dicotomización por la mediana: artificial y didáctica |
| S2 | b.17 | Relación manufactura–SO2 | `geom_point(color, size)`, `geom_smooth(group = 1)` | Cuatro dimensiones; asociación bivariada dentro de una estructura multivariable |
| S2 | b.18 | Correlaciones del SO2 | `cor`, `colnames`, `stopifnot`, `arrange(desc(abs()))` | Ranking por magnitud; `manu` 0.645; `names()` vs `colnames()` |
| S2 | b.19 | Ciudades con mayor SO2 | `arrange(desc())`, `slice_head`, `geom_col(fill)` | Un valor alto no es un error; contextualizar |
| S2 | b.20 | Carga de `respiratory` | `n_distinct`, `nrow`, `as.numeric(as.character())` | 555 filas no son 555 pacientes |
| S2 | b.21 | Tabla basal | `filter(month == "0")`, `n_distinct == nrow`, `mean(gender == "female")` | Una fila por paciente; verificación de unicidad |
| S2 | b.22 | Edad basal por tratamiento | `geom_violin` + `geom_boxplot` + `stat_summary` | Tres capas: forma, cuartiles, media |
| S2 | b.23 | Evolución del estado respiratorio | `count` → porcentaje por grupo y mes, `geom_line` + `geom_point`, `scale_shape_manual` | Denominador explícito; visitas no independientes |
| S2 | b.24 | Resumen a nivel de paciente | `group_by(subject)`, `first()`, `sum(status == "good")`, `geom_jitter` | Variable discreta 0–5 por paciente |
| S2 | b.25 | Edad y visitas buenas | `geom_jitter`, `geom_smooth`, `cor` global y por grupo | r = −0.09; misma unidad estadística |
| S2 | b.26 | Composición género × tratamiento | `count`, porcentaje por brazo, `geom_col` apilado | Conteos vs composición porcentual; leyenda justificada |
| S2 | b.27 | Síntesis del reto clínico | — | Unidad → basal → cambio temporal → resumen por paciente → asociación |
| S2 | b.28 | Contraste entre bases | Tabla comparativa | El código se reutiliza; la interpretación no se copia |
| S2 | b.29 | Producto de cierre | R Markdown | Seis componentes + exit ticket |
| S2 | b.30 | Recomendaciones metodológicas | — | Afirmaciones verificables; descripción / asociación / causalidad |
| S3 | §1.1 | Preparación del entorno | `library()`, `set.seed()` | Sin instalación automática; controlar el entorno antes de analizar |
| S3 | §2.1 | Carga, selección y depuración de `Cars93` | `janitor::clean_names`, `select(all_of())`, `across(as.factor)`, `colSums(is.na())`, `complete.cases`, `str` | Muestra analítica única; reportar filas excluidas |
| S3 | §2.2 | Distribuciones categóricas | `count`, `scales::percent`, `slice_max`/`slice_min`, `pivot_longer`, `geom_bar` + `facet_wrap` | Composición, no causalidad; categorías pequeñas se documentan, no se eliminan |
| S3 | §2.3 | Resumen numérico | Función `resumen_variable` con `vapply`, `knitr::kable` | Media–mediana en unidades de DE; tres señales de la tabla |
| S3 | §2.3.1 | Frecuencias agrupadas con Sturges | `hist(..., plot = FALSE)`, `purrr::imap_dfr` | k ≈ 1 + log2(n); regla de construcción, no propiedad de los datos |
| S3 | §2.4 | Histogramas, densidades y cajas | `pivot_longer`, `facet_wrap(scales = "free")`, `patchwork` `/` | Histograma = forma; boxplot = centro robusto y extremos (1.5·IQR) |
| S3 | §2.5 | Comparación por tipo de automóvil | `group_by(type) + summarise(median)`, boxplots facetados | Transición univariado → multivariado; cajas solapadas |
| S3 | §3.1 | Pearson y Spearman | `Hmisc::rcorr(type =)` | Lineal vs monótona; comparar ambas matrices |
| S3 | §3.2 | Asociaciones más intensas | `upper.tri`, `order(-abs())`, `merge` | Ranking por valor absoluto; discrepancia Pearson–Spearman; redundancia motiva el ACP |
| S3 | §4.1–4.2 | Fundamento y ajuste del ACP | `prcomp(center = TRUE, scale. = TRUE)`, `summary(pca)` | Combinaciones lineales estandarizadas; SVD; varianza cero verificada |
| S3 | §4.3 | Valores propios y varianza explicada | `sdev^2`, `cumsum`, Kaiser, 80 % | CP1 76.5 %, CP2 11.0 %; Kaiser 1; 80 % → 2 |
| S3 | §4.4 | Scree plot | `geom_line` + `geom_point` + `geom_hline(1)` | Codo; comparar criterios |
| S3 | §5 | Rotaciones, correlaciones y contribuciones | `pca$rotation`, `sweep(rotation, 2, sdev, "*")`, `100 * rotation^2` | Tres conceptos distintos; signo arbitrario; nombrar desde las cargas |
| S3 | §6 | Construcción del Biplot | `pca$x`, distancia al origen, factor visual, `stat_ellipse`, `geom_segment`, `ggrepel`, `coord_equal` | Biplot de correlación; factor común; elipses descriptivas |
| S3 | §7 | Interpretación en cinco capas | `rowSums(cor_var_pc^2)`, centroides por grupo | Plano → longitud → ángulos → posición → grupos |
| S3 | §8 | ⛔ FUERA DE ALCANCE · Función reutilizable | `crear_biplot_correlacion()` | Comprender antes de automatizar |
| S3 | §9–10 | ⛔ FUERA DE ALCANCE · Extensiones iris y USArrests | `prcomp`, `state.region[match()]` | 95.8 % y 86.8 %; grupo como información suplementaria |
| S3 | §11 | Errores y malas prácticas evitadas | — | 15 puntos |
| S3 | §12 | Reto integrador | — | 10 preguntas para entregar |

---

### 3. Tabla consolidada de conceptos y descripciones

Numeración temática única. **Origen** indica de qué sesión procede el concepto. **Ubicación**: "b." = bloque de S2; "§" = sección de S3.

#### A. Fundamentos del análisis y preparación de los datos

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 1 | Unidad de análisis (unidad estadística) | Lo que representa una fila. Es la primera decisión antes de calcular cualquier estadístico y cambia la interpretación: persona, ciudad, registro paciente-momento o paciente (S2); automóvil, flor o estado (S3). S3 lo formula como "¿qué datos estoy analizando realmente?" antes de preguntarse qué gráfico hacer. | S2 + S3 | b.1, 13, 20, 28 · §2.1 | `nrow`, `n_distinct` |
| 2 | Variable cuantitativa | Mide cantidades (edad, estatura, peso, SO2; precio, potencia, peso). Admite media, mediana, DE, IQR, histograma, boxplot, correlación y, en S3, entra al ACP. | S2 + S3 | b.1–2 · §2.1 | `num`, `dbl`, `int` en `str()` |
| 3 | Variable categórica (cualitativa) | Representa categorías (ciudad, género, tratamiento, estado; tipo, tracción, origen). Se resume con frecuencias y porcentajes; la media no tiene sentido. Debe tipificarse explícitamente como factor para que no entre indebidamente en medias, correlaciones o ACP (S3). | S2 + S3 | b.1, 11, 20 · §2.1–2.2 | `factor()`, `across(all_of(), as.factor)` |
| 4 | Identificadores y tiempo discreto | `subject` identifica al paciente y `month` es tiempo de seguimiento (factor ordenado); aunque se almacenen como números no son cuantitativas (S2). En S3 `manufacturer` y `model` se conservan como identificadores y se excluyen del ACP. | S2 + S3 | b.20 · §2.1 | `as.numeric(as.character())` |
| 5 | Inspección de estructura y tipos | Filas = observaciones, columnas = variables. Se verifican nombres, dimensiones y tipos antes de resumir; `summary()` da una panorámica pero no es un análisis terminado (S2). `str()` confirma que las categóricas son factores y las numéricas siguen numéricas (S3). | S2 + S3 | b.2, 13, 20 · §2.1 | `names`, `dim`, `str`, `glimpse`, `head`, `tail`, `summary` |
| 6 | Verificación de completitud | S2 comprueba que no hay NA y lo registra como diagnóstico, no como aserción fatal; el tratamiento de faltantes no es objetivo todavía. S3 cuenta faltantes por variable antes de decidir cómo tratarlos. | S2 + S3 | b.1, 13, 20 · §2.1 | `sum(is.na(base))`, `colSums(is.na())` |
| 7 | Muestra analítica única | Se conservan solo las filas completas respecto a las variables usadas y la misma muestra se emplea en descriptiva, correlación y ACP. Calcular el ACP con una muestra distinta de la usada en las correlaciones sería un error. | S3 | §2.1 | `complete.cases()`, `datos[filas, , drop = FALSE]` |
| 8 | Reporte de la depuración | El informe indica tamaño original, tamaño final, criterio de exclusión y si la pérdida cuestiona la representatividad. | S3 | §2.1 | `n_original`, `n_final`, `n_eliminadas` |
| 9 | Protocolo para una base real | Identificar qué representa una fila → revisar nombres, dimensiones y tipos → comprobar completitud → distinguir cuantitativas, categóricas e identificadores → formular una pregunta descriptiva antes del gráfico → integrar número y gráfico. | S2 | §5.1 de S2 | — |
| 10 | Pregunta descriptiva antes del gráfico | Cada bloque responde una pregunta; el gráfico se elige según la pregunta, no al revés (S2). "La primera pregunta no es qué gráfico hago" (S3). | S2 + S3 | b.30 · §2.1 | — |
| 11 | Mecanismo generador conocido vs desconocido | En la simulación se sabe qué asociaciones fueron introducidas (estatura → peso, estatura por género) y cuáles no (ciudad y género vs edad). En datos reales se interpreta sin conocer el mecanismo. | S2 | b.1, 8, 12 | `set.seed`, `rnorm`, `sample` |
| 12 | Reproducibilidad | Semilla fija para obtener la misma muestra en cada compilación (S2). S3 la declara aunque el ACP sea determinista: primero se controla el entorno. | S2 + S3 | b.1 · §1.1 | `set.seed()` |
| 13 | Alcance de la base: muestra vs población | Las frecuencias de la muestra simulada no representan tamaños poblacionales (S2). Cars93 describe el mercado representado en 1993, no todos los automóviles de cualquier época (S3). | S2 + S3 | b.8, 11 · §2.2 | — |
| 14 | Descripción, asociación e inferencia causal | Las prácticas cubren descripción y asociación. Explicar por qué existe una asociación requiere diseño de estudio, teoría sustantiva y métodos inferenciales (S2). "Composición, no causalidad"; "una flecha no causa otra" (S3). | S2 + S3 | b.16, 19, 30 · §2.2, 6.4, 10 | — |
| 15 | Entorno y política de paquetes | S2: minimalista, dplyr + ggplot2 + R base, HSAUR3 sin `library()`, instalación automática de faltantes. S3: varios paquetes con prefijo `paquete::`, sin instalación automática; el documento se detiene si falta alguno y no carga paquetes que no usa. | S2 + S3 | §2 de S2 · §1.1 | `requireNamespace()`, `data(..., package =)`, `library()` |
| 16 | Nombres limpios, etiquetas legibles y selección explícita | Columnas en snake_case, vectores nombrados de etiquetas en español para tablas y gráficos, y selección de pocas variables con sentido sustantivo para evitar gráficos redundantes. | S3 | §2.1 | `janitor::clean_names()`, `select(all_of())` |

#### B. Medidas de centro

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 17 | Media aritmética | Equilibra magnitudes; usa todas las observaciones; sensible a extremos (S2). Fórmula explícita: suma de los valores dividida por n (S3). | S2 + S3 | b.3 · §2.3 | `mean()` |
| 18 | Mediana | Posición central de los datos ordenados; robusta ante extremos. Complemento indispensable cuando hay asimetría. | S2 + S3 | b.3 · §2.3 | `median()` |
| 19 | Moda | Valor observado con mayor frecuencia. Se lee con su frecuencia; si hay empate, todas las modas se reportan porque el empate es información. S3 solo menciona la "categoría modal" en los gráficos de barras. | S2 | b.4 | `count(sort = TRUE)` + `slice_max(with_ties = TRUE)` |
| 20 | Comparación media–mediana | Distancia pequeña es compatible con simetría pero no la prueba; media por encima de la mediana sugiere cola derecha. S2 usa la diferencia absoluta (0.6 años en edad) y la razón (1.16 en SO2). S3 mide la diferencia en unidades de la DE de cada variable para compararlas entre sí, y exige confirmación visual: en Cars93 la media supera a la mediana en las seis variables. | S2 + S3 | b.3, 14, 15 · §2.3–2.4 | — |
| 21 | Elección justificada de medidas | Media/DE cuando la forma es equilibrada; mediana/IQR cuando hay asimetría o extremos. No hay una medida "correcta" única: se justifica cuál comunica mejor el aspecto de interés. | S2 + S3 | b.14, 15, 29 · §2.3 | — |

#### C. Medidas de dispersión y posición

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 22 | Desviación estándar muestral | Usa todas las observaciones; sensible a extremos; se interpreta en las unidades de la variable (S2). Fórmula con divisor n − 1 (S3). | S2 + S3 | b.3 · §2.3 | `sd()` |
| 23 | Cuartiles (Q1, Q3) | Límites del 50 % central de la distribución. | S2 | b.3 | `quantile(x, 0.25)`, `quantile(x, 0.75)` |
| 24 | Rango intercuartílico (IQR) | Q3 − Q1. Dispersión de la mitad central; más robusto que la DE. | S2 + S3 | b.3 · §2.3 | `IQR()` |
| 25 | Mínimo y máximo | Extremos observados. Muestran extensión pero no deben usarse solos para juzgar dispersión porque dependen de observaciones extremas (S3). | S2 + S3 | b.3, 14 · §2.3 | `min()`, `max()` |
| 26 | Tres señales de la tabla descriptiva | (1) media y mediana separadas, (2) IQR grande respecto a la escala habitual de la variable, (3) máximos muy alejados del centro. | S3 | §2.3 | — |
| 27 | Dispersión entre variables con unidades distintas | Una DE mayor no implica más variabilidad relativa; cada medida se interpreta en su escala (S2). S3 resuelve la incompatibilidad de escalas estandarizando antes del ACP. | S2 + S3 | b.10 · §4.1 | `across()`, `scale. = TRUE` |

#### D. Forma de la distribución

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 28 | Momentos centrales | Promedios de las desviaciones respecto a la media elevadas a la potencia 2, 3 o 4. Base de asimetría y curtosis. | S2 | b.6 | `mean((x - mean(x))^k)` |
| 29 | Coeficiente de asimetría | m3 / m2^(3/2). Positivo indica cola derecha; negativo, cola izquierda. Se interpreta con el histograma y la distancia media–mediana, no con un umbral rígido. Edad simulada: 0.25. | S2 | b.6 | Función propia `coef_asimetria` |
| 30 | Exceso de curtosis | m4 / m2² − 3. Cercano a cero indica concentración y colas comparables a la normal; en muestras pequeñas varía apreciablemente. Edad simulada: −0.23. | S2 | b.6 | Función propia `exceso_curtosis` |
| 31 | Forma global de la distribución | Concentración, número de zonas de alta frecuencia, colas y huecos: preguntas que una media no responde (S2). Los histogramas responden principalmente a forma; los boxplots a centro robusto y extremos (S3). | S2 + S3 | b.7, 15 · §2.4 | Histograma |

#### E. Distribuciones de frecuencia

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 32 | Tabla de frecuencias agrupadas | Agrupar valores en clases reduce detalle pero muestra la arquitectura global (S2). Todos los valores de un intervalo quedan tratados como una misma clase; se lee junto con histograma, densidad y medidas (S3). | S2 + S3 | b.5 · §2.3.1 | `cut()`, `count()`, `hist()$counts` |
| 33 | Regla de Sturges | Propuesta del número de clases, k ≈ 1 + log2(n). Punto de partida, no regla obligatoria (S2); regla de construcción, no propiedad natural de los datos: cambiar los cortes cambia la apariencia (S3). Cars93: entre 5 y 12 clases según la variable. | S2 + S3 | b.5, 7 · §2.3.1 | `hist(x, breaks = "Sturges", plot = FALSE)$breaks` |
| 34 | Frecuencia absoluta | Conteo por clase o categoría: n_j = número de observaciones con X = j. | S2 + S3 | b.5, 11 · §2.2 | `count()` |
| 35 | Frecuencia relativa y porcentaje | f_j = n_j / n. Permite comparar muestras de tamaños distintos. | S2 + S3 | b.5, 11 · §2.2 | `n / sum(n)`, `scales::percent()` |
| 36 | Frecuencia acumulada | Suma progresiva de conteos o proporciones; responde "¿cuántos no superan el límite de esta clase?". | S2 | b.5 | `cumsum()` |
| 37 | Conteos absolutos vs composición porcentual | Con grupos de distinto tamaño se comparan porcentajes dentro de cada grupo; el denominador debe ser explícito (grupo y mes; brazo de tratamiento). | S2 | b.23, 26 | `group_by()` + `mutate(100 * n / sum(n))` |
| 38 | Categoría dominante y minoritaria | Se identifican dentro de cada variable categórica. Una categoría pequeña no se elimina: se documenta su tamaño y se modera la fuerza de las conclusiones, porque cualquier mediana, caja o elipse calculada para ella tiene mayor incertidumbre. | S3 | §2.2 | `group_by() + slice_max()` / `slice_min()` |

#### F. Visualización con ggplot2

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 39 | Histograma en escala de densidad | Distribución completa de una cuantitativa; número de barras tomado de Sturges (S2) o fijo con facetas por variable (S3). | S2 + S3 | b.7, 15 · §2.4 | `geom_histogram(aes(y = after_stat(density)))` |
| 40 | Curva de densidad suavizada | Facilita reconocer la forma global. Depende del suavizado y no debe confundirse con una densidad teórica. | S2 + S3 | b.7, 15 · §2.4 | `geom_density()` |
| 41 | Líneas de referencia de media y mediana | Confrontan forma con centro; una separación visible es señal gráfica de asimetría. | S2 | b.7, 15 | `geom_vline()` |
| 42 | Boxplot (diagrama de caja) | Mediana, IQR, bigotes y posibles extremos; permite comparar grupos y ver solapamiento (S2). Los puntos fuera de los bigotes se definen por la regla de 1.5·IQR (S3). | S2 + S3 | b.8, 12, 16, 22, 24 · §2.4–2.5 | `geom_boxplot()` |
| 43 | Valores extremos (outliers) | Puntos fuera de los bigotes. No son automáticamente errores: un valor alto de SO2 o un automóvil caro, pesado o potente puede ser real e informativo. Se contextualizan y no se eliminan solo por aparecer en el boxplot. | S2 + S3 | b.8, 19 · §2.4 | `outlier.color`, `outlier.shape = NA` |
| 44 | Media superpuesta al boxplot | Rombo blanco que ubica la media para compararla con la mediana del grupo. | S2 | b.8, 12, 16, 22, 24 | `stat_summary(fun = mean, geom = "point", shape = 23)` |
| 45 | Gráfico de violín | Forma aproximada de la distribución dentro de cada grupo; con caja y media forma tres capas. | S2 | b.22 | `geom_violin()` |
| 46 | Gráfico de barras | Compara frecuencias categóricas sobre una misma escala; se prefiere al de sectores. S2 lo ordena por frecuencia con ejes invertidos; S3 lo faceta por variable con el conteo sobre cada barra. La altura representa número de casos, no importancia. | S2 + S3 | b.11, 19 · §2.2 | `geom_col()`, `geom_bar()`, `reorder()`, `coord_flip()`, `facet_wrap()` |
| 47 | Barras apiladas al 100 % | Composición porcentual dentro de cada grupo con etiquetas por segmento. | S2 | b.26 | `geom_col()` + `position_stack()` |
| 48 | Diagrama de dispersión | Relación entre dos cuantitativas; cada punto es una unidad de análisis (S2). S3 lo indica como diagnóstico obligado cuando Pearson y Spearman discrepan. | S2 + S3 | b.9, 17, 25 · §3.1 | `geom_point()` |
| 49 | Recta de tendencia descriptiva | Resume la dirección lineal global o por grupo; referencia descriptiva, no modelo causal. | S2 | b.9, 17, 25 | `geom_smooth(method = "lm")` |
| 50 | Jitter | Desplazamiento leve para ver puntos superpuestos en variables discretas. | S2 | b.24, 25 | `geom_jitter()` |
| 51 | Gráfico de líneas temporal | Trayectoria de un porcentaje por grupo a lo largo de los meses; los puntos marcan los momentos observados. | S2 | b.23 | `geom_line()` + `geom_point()` |
| 52 | Formato largo y facetas | Convertir varias variables a una tabla larga permite graficarlas en un solo objeto con un panel por variable y escalas independientes cuando las unidades difieren. | S3 | §2.2, 2.4, 2.5 | `tidyr::pivot_longer()`, `facet_wrap(scales = "free")` |
| 53 | Secuencia de lectura univariada | Primero modalidad y colas del histograma; luego media vs mediana; finalmente el boxplot para localizar extremos y valorar si explican la separación. Histograma y cajas se apilan en una sola figura. | S3 | §2.4 | `patchwork` operador `/` |
| 54 | Codificación visual (color, tamaño, forma) | Cada estética añade una variable: viento por color, población por tamaño, tratamiento por forma (S2); tipo de automóvil por color y forma en el Biplot (S3). El color representa información, no decora. | S2 + S3 | b.9, 17, 23, 24 · §6.4 | `aes(color, size, shape)`, `scale_*_manual()` |
| 55 | Leyenda redundante vs informativa | Si el color repite exactamente el eje se omite la leyenda; si añade una dimensión se conserva. | S2 + S3 | §2 de S2, b.11, 26 · §2.2, 2.4 | `show.legend = FALSE` |
| 56 | Paletas coherentes y semánticas | Declaradas una vez; colores contrastantes; codificación con significado (rojo = poor, verde = good). | S2 | §2 de S2 | Vectores nombrados de colores |
| 57 | Títulos, subtítulos, etiquetas y unidades | Explican cómo leer el gráfico, el denominador y las unidades (µg/m³). En el Biplot los ejes llevan el porcentaje de varianza explicada (S3). | S2 + S3 | Todos · §6.4 | `labs()`, `expression()` |

#### G. Comparación entre grupos

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 58 | Resumen por grupos | Mismo conjunto de medidas dentro de cada categoría (S2). Tabla de medianas por tipo como apoyo numérico de los boxplots (S3). | S2 + S3 | b.12, 16, 21, 24 · §2.5 | `group_by()` + `summarise(.groups = "drop")` |
| 59 | Solapamiento de distribuciones | Dos grupos pueden tener medias distintas y compartir gran parte de sus valores; el boxplot lo hace visible (S2). Cajas solapadas indican que una sola variable no distingue bien los grupos (S3). | S2 + S3 | b.12, 16, 22, 24 · §2.5 | — |
| 60 | Dicotomización por la mediana | Convertir una cuantitativa en dos grupos con corte descriptivo; artificial y solo didáctica; en un estudio formal se conserva la escala. | S2 | b.16, 17 | `if_else(x >= median(x), ...)` |
| 61 | Diferencia descriptiva ≠ diferencia poblacional ≠ causa | La lectura correcta es "en esta muestra la media de X fue mayor" (S2). Separación visual no es evidencia formal de grupos distintos (S3). | S2 + S3 | b.8, 12, 16 · §6.3, 7.5 | — |
| 62 | Tabla basal y comparabilidad inicial | Perfiles iniciales de los brazos de un ensayo (edad, % mujeres, % estado bueno) sin probar equivalencia ni eficacia. | S2 | b.21 | `filter(month == "0")` |
| 63 | Transición univariado → multivariado | Si un tipo aparece a la vez con mayor peso, potencia y precio y menor eficiencia, esas diferencias no son independientes; el ACP resume patrones conjuntos que una variable sola no muestra. | S3 | §2.5 | — |

#### H. Correlación y relaciones bivariadas

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 64 | Correlación de Pearson | Dirección (signo) y magnitud de la asociación lineal; el signo debe ser coherente con la nube de puntos (S2). Fórmula: covarianza estandarizada sobre los valores originales (S3). | S2 + S3 | b.9, 18, 25 · §3.1 | `cor()`, `Hmisc::rcorr(type = "pearson")` |
| 65 | Correlación de Spearman | Pearson aplicado a los rangos; resume asociación monótona; menos sensible a extremos y a no linealidad monótona. | S3 | §3.1 | `Hmisc::rcorr(type = "spearman")` |
| 66 | Comparación Pearson–Spearman | Se leen juntas. Parecidas: relación compatible con un patrón monótono aproximadamente lineal. Diferentes: revisar el diagrama de dispersión por curvatura, extremos o monotonía no lineal. Cars93: mayor discrepancia en price–mpg_city (0.192). | S3 | §3.1–3.2 | `merge()`, diferencia absoluta |
| 67 | Matriz de correlaciones | Correlaciones entre todas las cuantitativas; etiquetas por `rownames`/`colnames` (S2). `rcorr` devuelve además tamaños muestrales y valores p; la diagonal vale 1 y no aporta información (S3). | S2 + S3 | b.9, 18 · §3.1 | `cor(select(...))`, `resultado$r`, `resultado$P` |
| 68 | Ranking de asociaciones por magnitud absoluta | Ordenar el valor absoluto de r para identificar las asociaciones dominantes como mapa exploratorio. S2 lo hace para las correlaciones de una variable (SO2); S3 extrae los pares únicos del triángulo superior de la matriz. | S2 + S3 | b.18 · §3.2 | `arrange(desc(abs(r)))`, `which(upper.tri(m), arr.ind = TRUE)` |
| 69 | Limitaciones de la correlación | No captura relaciones no lineales, valores influyentes ni confusión; orienta qué dispersiones estudiar (S2). Una correlación cercana a cero solo descarta asociación lineal fuerte, no toda dependencia; una grande no implica causalidad (S3). | S2 + S3 | b.18 · §3.1 | — |
| 70 | Valores p y multiplicidad | Con muchas correlaciones simultáneas hay multiplicidad; el interés es descriptivo y estructural, no una batería de decisiones basadas en p < 0.05. | S3 | §3.2 | — |
| 71 | Estructura multivariable | Una asociación bivariada puede estar inmersa en otras variables (viento, población); subgrupos con centros distintos pueden componer la relación global. | S2 | b.9, 17 | `aes(color, size)` |
| 72 | Asociación ecológica | Una correlación entre ciudades describe diferencias entre ciudades, no variación individual ni día a día. | S2 | b.13, 28 | — |
| 73 | Misma unidad de análisis al correlacionar | Las variables deben definirse sobre la misma unidad estadística (paciente) antes de calcular r. | S2 | b.25 | Tabla `salud_sujeto` |
| 74 | Redundancia como motivación del ACP | Cuando varias variables están fuertemente correlacionadas, parte de su información es redundante y puede resumirse en pocas direcciones principales. Es el puente conceptual descriptiva → ACP. | S3 | §3.2, 4.1 | — |

#### I. Datos longitudinales y medidas repetidas

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 75 | Fila vs paciente vs medición repetida | 555 filas = 111 pacientes × 5 meses. La unidad de análisis depende de la pregunta: nivel paciente o nivel visita. | S2 | b.20 | `n_distinct(subject)`, `nrow()` |
| 76 | Tabla basal (una fila por paciente) | Se filtra el mes 0 y se verifica que pacientes distintos = filas. | S2 | b.21 | `filter()`, `n_distinct() == nrow()` |
| 77 | Resumen por sujeto | Colapsar las visitas a una fila por paciente con variables constantes y un conteo de visitas buenas (0 a 5). | S2 | b.24 | `group_by(subject)` + `summarise(first(), sum())` |
| 78 | No independencia de observaciones repetidas | Las cinco visitas de un paciente no son independientes; la evaluación formal requiere métodos longitudinales. | S2 | b.23, 28 | — |
| 79 | Evolución temporal descriptiva | Porcentaje de estado bueno por grupo y mes; compara trayectorias sin prueba de hipótesis ni modelo. | S2 | b.23 | — |

#### J. Análisis de Componentes Principales (ACP)

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 80 | Componente principal | Nueva variable incorrelacionada construida como combinación lineal de las variables estandarizadas: PC_k = a_1k·Z_1 + … + a_pk·Z_p, con a_jk coeficientes del vector propio k. | S3 | §4.1 | `prcomp()` |
| 81 | Estandarización | Z_ij = (X_ij − media_j) / s_j. Necesaria porque dólares, millas por galón, litros, caballos y libras son escalas incompatibles; sin ella la variable con mayor varianza numérica dominaría el resultado. | S3 | §4.1–4.2 | `prcomp(center = TRUE, scale. = TRUE)` |
| 82 | ACP sobre la matriz de correlaciones | Con `scale. = TRUE` el ACP equivale conceptualmente a trabajar con la matriz de correlaciones. | S3 | §4.1 | — |
| 83 | Descomposición en valores singulares (SVD) | `prcomp` no diagonaliza la matriz de correlaciones: usa Z = U·D·Vᵀ, numéricamente estable. Las columnas de V son las direcciones principales. | S3 | §4.1 | — |
| 84 | Verificación previa de varianza | Ninguna variable puede tener DE cero o no disponible; de lo contrario no se puede estandarizar y el análisis se detiene. | S3 | §4.2 | `vapply(datos, sd, numeric(1))`, `stop()` |
| 85 | Ortogonalidad de las componentes | Las componentes son incorrelacionadas entre sí porque los vectores propios son ortogonales. | S3 | §4.1–4.2 | — |
| 86 | Valor propio | λ_k = sdev_k². Es la varianza de la componente k. | S3 | §4.3 | `pca$sdev^2` |
| 87 | Proporción de varianza explicada y acumulada | P_k = λ_k / Σλ. La acumulada indica cuánta información conservan las primeras k componentes. Cars93: CP1 76.5 %, CP2 11.0 %, acumulado 87.5 %. | S3 | §4.3 | `cumsum()`, `summary(pca)` |
| 88 | Criterio de Kaiser | Retener componentes con λ > 1, es decir, con más varianza que una variable estandarizada. Cars93: 1 componente. | S3 | §4.3–4.4 | `sum(valores_propios > 1)` |
| 89 | Criterio del 80 % acumulado | Mínimo número de componentes para alcanzar al menos 80 % de varianza. Cars93: 2. | S3 | §4.3 | `which(acumulada >= 0.80)[1]` |
| 90 | Scree plot y codo | Gráfico de valores propios por componente; se busca el punto desde el cual añadir componentes aporta poco. La línea en λ = 1 es solo referencia de Kaiser. Si los criterios discrepan se justifica cuál responde al objetivo (descripción numérica o visualización). | S3 | §4.4 | `geom_line() + geom_point() + geom_hline(yintercept = 1)` |
| 91 | Rotaciones (`rotation`) | Coeficientes de los vectores propios. No son porcentajes de contribución ni correlaciones. | S3 | §5 | `pca$rotation` |
| 92 | Correlación variable–componente | Cor(Z_j, PC_k) = a_jk · sdev_k. Medida recomendada para interpretar y nombrar componentes y para dibujar las flechas del Biplot. | S3 | §5 | `sweep(rotation, 2, sdev, "*")` |
| 93 | Contribución de una variable | 100 · a_jk². Suma 100 % dentro de cada componente. Responde "qué proporción de la dirección CP_k procede de esta variable", distinto de "qué tan asociada está". | S3 | §5 | `100 * rotation^2` |
| 94 | Nombrar componentes desde las cargas | El nombre sustantivo surge del patrón conjunto de magnitudes y signos (tamaño/desempeño vs eficiencia), citando al menos tres correlaciones variable–componente; no se impone antes de ver las cargas. | S3 | §5 | — |
| 95 | Signo arbitrario de las componentes | El signo de un vector propio es arbitrario: otra instalación puede invertirlo sin cambiar la geometría. Se habla de oposición entre direcciones, no de positivo o negativo absolutos. | S3 | §5 | — |

#### K. Biplot

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 96 | Biplot de Gabriel vs Biplot de correlación | El Biplot estricto reparte los valores singulares entre filas y columnas. La práctica construye un Biplot de correlación: scores para las observaciones y correlaciones variable–componente para las flechas. Se conservan direcciones y ángulos; no se interpretan literalmente productos internos ni distancias punto–flecha. | S3 | §6 | — |
| 97 | Puntuaciones (scores) | Coordenadas de cada observación en el nuevo sistema: T = Z·V. | S3 | §6.1 | `pca$x[, 1:2]` |
| 98 | Observaciones extremas en el plano | Distancia al origen √(CP1² + CP2²). "Extremo" es un perfil estandarizado alejado del centro en CP1–CP2, no un error; una observación central podría ser extrema en CP3. Se etiquetan solo las más alejadas. | S3 | §6.1 | `order(distancia, decreasing = TRUE)[1:8]` |
| 99 | Factor visual común de las flechas | Un único factor lleva las correlaciones (escala −1 a 1) al lienzo de los scores. Conserva direcciones, ángulos y longitudes relativas; un factor distinto por flecha destruiría esa geometría. Cars93: 3.969. | S3 | §6.2 | `0.75 * min(max_score / max_var)` |
| 100 | Elipses descriptivas | Resumen visual de la dispersión de cada grupo bajo aproximación elíptica (normal, 95 %), solo para grupos con al menos 3 observaciones. No son fronteras de clasificación ni demuestran conglomerados. | S3 | §6.3–6.4 | `stat_ellipse(type = "norm", level = 0.95)` |
| 101 | Calidad del plano | Porcentaje de varianza conservado por CP1 + CP2. Toda lectura del Biplot es una aproximación bidimensional; relaciones que dependan de CP3 pueden deformarse. | S3 | §7.1 | `sum(prop[1:2])` |
| 102 | Calidad de representación de una variable (cos²) | cos²_j = Cor(X_j, PC1)² + Cor(X_j, PC2)². Cerca de 1, bien representada en el plano; baja, requiere componentes adicionales y su flecha se interpreta con prudencia. Cars93: mpg_city 0.947 (mejor), engine_size 0.747 (peor). | S3 | §7.2 | `rowSums(cor_var_pc^2)` |
| 103 | Ángulos entre flechas | Ángulo pequeño → asociación positiva; direcciones opuestas → negativa; cerca de 90° → relación lineal débil en la representación retenida. Aproximan las correlaciones originales; más confiables cuanto mayor la varianza explicada y la calidad de representación. | S3 | §7.3 | — |
| 104 | Posición de las observaciones | Puntos cercanos tienen perfiles estandarizados semejantes en las variables que dominan CP1 y CP2; la separación no es una distancia exacta en el espacio original. La proyección sobre una flecha sugiere valores relativamente altos (misma dirección) o bajos (opuesta). | S3 | §7.4 | — |
| 105 | Centroides por grupo | Posición promedio de cada grupo en el plano; se lee junto con la dispersión: centroides distintos con elipses superpuestas indican diferencias promedio con escasa separación individual. Cars93: Small (−2.80) vs Large (2.00) en CP1; Van (−1.17) vs Midsize (0.26) en CP2. | S3 | §7.5 | `group_by(Tipo) + summarise(mean(CP1), mean(CP2))` |
| 106 | Información suplementaria (en alcance solo la parte de §6.4) | Una variable categórica usada para colorear (tipo de automóvil en §6.4; región en §10) no interviene en el cálculo del ACP; cualquier agrupación observada es estructura a posteriori. No se afirma que el ACP "encontró" los grupos. | S3 | §6.4 · §10 ⛔ | `aes(colour = Grupo)` |
| 107 | Qué no debe decirse del Biplot | Que una flecha causa otra, que una elipse demuestra un cluster verdadero, o que dos observaciones cercanas son idénticas en todas las variables originales. | S3 | §6.4 | — |
| 108 | Interpretación en capas | Ejes antes que colores: calidad del plano → longitud de flechas → ángulos → posición de puntos → grupos. | S3 | §6.4, 7 | — |
| 109 | ⛔ FUERA DE ALCANCE · Comparación de bases en el plano | La conveniencia de una representación bidimensional se fundamenta con varianza explicada y estructura visual: iris 95.8 %, Cars93 87.5 %, USArrests 86.8 %. Requiere las extensiones excluidas. | S3 | §9, 10, 12 | `summary(pca)` |
| 110 | ⛔ FUERA DE ALCANCE · Función reutilizable | Encapsular el procedimiento (scores, correlaciones variable–componente, factor común) en una función que recibe un `prcomp`, un grupo opcional y un título. Se automatiza solo después de comprender cada paso. | S3 | §8 | `crear_biplot_correlacion()` |

#### L. Comunicación de resultados y entregables

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 111 | Afirmaciones verificables y traducidas al contexto | Sustituir "la gráfica sube" o "hay mucha diferencia" por "la mediana supera a…", "el 50 % central se ubica entre…" (S2). No basta "esta barra es más alta": señalar qué predomina y advertir el alcance de la base (S3). | S2 + S3 | b.30 · §2.2 | — |
| 112 | Integración de evidencia numérica y gráfica | Toda conclusión se sustenta a la vez en medidas y en elementos observables del gráfico: posición, dispersión, forma, solapamiento, pendiente, proporciones (S2). El reto integrador exige resultados numéricos y evidencia gráfica del documento (S3). | S2 + S3 | §1.1 y 5.1 de S2, b.30 · §12 | — |
| 113 | Alcance delimitado: respaldado vs excesivo | Toda interpretación incluye una advertencia sobre lo que los datos no demuestran (S2). Distinguir explícitamente tres afirmaciones respaldadas por el Biplot y tres excesivas o incorrectas (S3). | S2 + S3 | b.29, 30 · §12 | — |
| 114 | Producto de cierre y exit ticket | Seis componentes (unidad y variables, completitud, resumen justificado, dos gráficos con color informativo, relación, interpretación ≤ 180 palabras con cuatro elementos) y tres preguntas de cierre. | S2 | b.29 | R Markdown |
| 115 | Reto integrador y perfil exploratorio (referencia; pregunta 8 fuera de alcance) | Diez preguntas para entregar; la primera es un perfil exploratorio ≤ 200 palabras con composición categórica, dos rasgos de distribuciones numéricas y dos asociaciones. La pregunta 8 (comparar Cars93, iris y USArrests) depende de §9–10 y no se tiene en cuenta. | S3 | §12 | — |

#### M. Herramientas computacionales

| # | Concepto | Descripción según las sesiones | Origen | Ubicación | R |
|---|---|---|---|---|---|
| 116 | Verbos de dplyr | `summarise`, `across`, `count`, `slice_max`, `slice_min`, `slice_head`, `group_by`, `mutate`, `filter`, `arrange`, `select`, `all_of`, `if_else`, `n_distinct`, `first`, `n`, `bind_rows`. | S2 + S3 | Varios | — |
| 117 | `names()` vs `colnames()` en matrices | `names()` aplicado a una matriz devuelve longitud cero; se usan `colnames()`/`rownames()` y se verifica la longitud con `stopifnot()` para que el Knit no falle. | S2 | b.18 | `colnames()`, `stopifnot()` |
| 118 | Conversión de factor ordenado a numérico | Pasar primero por `as.character()` para recuperar la etiqueta y no el código interno del nivel. | S2 | b.20, 23 | `as.numeric(as.character(month))` |
| 119 | Prefijo explícito de paquete | Todas las funciones se llaman como `paquete::función` para dejar claras las dependencias y evitar conflictos de nombres. | S3 | Todas | `dplyr::select`, `ggplot2::ggplot` |
| 120 | Iteración funcional | Aplicar la misma función a varias columnas y unir los resultados en una tabla larga. | S3 | §2.2, 2.3 | `purrr::map2()`, `purrr::imap_dfr()`, `vapply()` |
| 121 | Tablas formateadas en el informe | Presentar data frames como tablas con título y decimales controlados. | S3 | Todas | `knitr::kable(digits, caption)` |
| 122 | Combinación de figuras | Apilar dos objetos ggplot en una sola figura. | S3 | §2.4 | `patchwork`: `grafico_a / grafico_b` |
| 123 | Etiquetas sin solapamiento | Texto que se reposiciona automáticamente. | S3 | §6.4, 8 | `ggrepel::geom_text_repel(max.overlaps = Inf)` |
| 124 | Misma unidad visual en ambos ejes | Indispensable en un Biplot para que ángulos y distancias no se distorsionen. | S3 | §6.4, 8 | `coord_equal()` |
| 125 | Operaciones sobre matrices | Multiplicar columnas por un vector, extraer el triángulo superior, transponer resúmenes. | S3 | §3.2, 5 | `sweep()`, `upper.tri()`, `t()` |
| 126 | ⛔ FUERA DE ALCANCE · Emparejar identificadores externos | Asignar región a cada estado cruzando nombres de fila con vectores incorporados de R. Solo se usa en la extensión USArrests. | S3 | §10 | `state.region[match(rownames(USArrests), state.name)]` |

---

### 4. Lista de verificación frente a la rúbrica

Criterios probables derivados de los entregables (sección 1.5), los resultados de aprendizaje y las recomendaciones de ambas prácticas. Los números remiten a la tabla de la sección 3.

| Criterio probable | Origen | Evidencia esperada en la entrega | Conceptos |
|---|---|---|---|
| Unidad de análisis, variables y muestra analítica | S2 + S3 | Qué representa una fila; una categórica y dos cuantitativas identificadas; identificadores separados; tipos verificados con `str()`; en S3, tamaño original y final con criterio de exclusión. | 1–8, 16 |
| Completitud | S2 + S3 | Instrucción de R que confirma cero NA (S2) o conteo de faltantes por variable y filas completas (S3). | 6–8 |
| Composición categórica | S2 + S3 | Frecuencia absoluta, relativa y porcentaje; categorías dominantes y minoritarias; barras ordenadas o facetadas; advertencia sobre categorías pequeñas. | 34–35, 38, 46, 52 |
| Resumen numérico justificado | S2 + S3 | Centro y dispersión; justificación media/DE vs mediana/IQR según forma; las tres señales de la tabla; Sturges; histograma, densidad y boxplot leídos en secuencia. | 17–33, 39–43, 53 |
| Visualización | S2 + S3 | Dos gráficos que respondan preguntas distintas; color informativo; títulos, ejes y unidades; leyenda no redundante; facetas cuando hay muchas variables. | 39–57 |
| Comparación entre grupos | S2 + S3 | Resúmenes por grupo; boxplots comparados; solapamiento reconocido; lectura descriptiva sin salto causal; en S3, transición a lo multivariado. | 58–63 |
| Relación bivariada y correlación | S2 + S3 | Dispersión + coeficiente con signo coherente; misma unidad de análisis; en S3, matrices de Pearson y Spearman comparadas, pares más intensos, par con mayor discrepancia, sin batería de valores p. | 48–49, 64–74 |
| ACP justificado | S3 | `scale. = TRUE` argumentado; verificación de varianza; tabla de valores propios y acumulados; Kaiser, 80 % y scree plot comparados y defendidos. | 27, 80–90 |
| Interpretación de componentes | S3 | Nombres de CP1 y CP2 citando al menos tres correlaciones variable–componente; distinción rotación / correlación / contribución; signo arbitrario. | 91–95 |
| Biplot interpretado en capas (hasta los centroides) | S3 | Calidad del plano; calidad de representación; ángulos coherentes con la matriz de correlaciones; observaciones extremas explicadas; centroides y elipses leídos como descriptivos. | 96–108 (109 y 110 fuera de alcance) |
| Interpretación escrita | S2 + S3 | S2: ≤ 180 palabras con hallazgo univariado, comparación de grupos, relación bivariada y advertencia de alcance. S3: perfil ≤ 200 palabras; tres afirmaciones respaldadas y tres excesivas; nueva pregunta de investigación con la salida de R. Afirmaciones verificables. La pregunta 8 del reto (comparar bases) queda fuera de alcance. | 111–115 |
| Exit ticket | S2 | Decisión sobre tipo de variable; caso donde la mediana fue más informativa; gráfico principal con evidencia concreta. | 2–4, 20–21, 39–51 |
| Calidad del código | S2 + S3 | Comentado y reproducible; solo los paquetes declarados; sin `install.packages()` en el documento (S3); sin recalcular el ACP con nombres genéricos; una sola definición de Biplot; factor visual declarado. | 12, 15, 116–125 (126 fuera de alcance) |

---

### 5. Errores y malas prácticas que las sesiones advierten explícitamente

| # | Error o mala práctica | Origen |
|---|---|---|
| 1 | Calcular una media sobre códigos de una variable categórica, o dejar que una categórica almacenada como número entre en medias, correlaciones o ACP. | S2 + S3 |
| 2 | Tratar `summary()` como un análisis terminado. | S2 |
| 3 | Eliminar arbitrariamente una moda cuando hay empate. | S2 |
| 4 | Interpretar la regla de Sturges como obligatoria o como propiedad natural de los datos. | S2 + S3 |
| 5 | Interpretar asimetría o curtosis con un umbral rígido aislado, sin el histograma. | S2 |
| 6 | Confundir la densidad suavizada con una densidad teórica conocida. | S2 |
| 7 | Concluir asimetría solo porque la media supera a la mediana, sin confirmación visual. | S3 |
| 8 | Reducir la comparación de grupos a "cuál media es mayor" e ignorar el solapamiento. | S2 + S3 |
| 9 | Comparar desviaciones estándar entre variables con unidades distintas. | S2 |
| 10 | Usar gráfico de sectores donde el de barras compara mejor. | S2 + S3 |
| 11 | Poner leyendas que repiten la información del eje o usar color decorativo. | S2 |
| 12 | Convertir observaciones extremas en "errores" que se eliminan solo por aparecer fuera de los bigotes. | S2 + S3 |
| 13 | Tratar la dicotomización por la mediana como un umbral científico. | S2 |
| 14 | Contar cinco veces al mismo paciente al resumir edad, género o tratamiento. | S2 |
| 15 | Correlacionar variables definidas en unidades de análisis distintas. | S2 |
| 16 | Tratar las visitas repetidas como observaciones independientes. | S2 |
| 17 | Usar `names()` en una matriz de correlaciones (devuelve longitud cero). | S2 |
| 18 | Pasar de asociación descriptiva a conclusión causal o poblacional. | S2 + S3 |
| 19 | Usar expresiones vagas ("los datos están bien", "la gráfica sube", "esta barra es más alta"). | S2 + S3 |
| 20 | Ejecutar `install.packages()` dentro de la práctica o cargar paquetes que no se usan. | S3 |
| 21 | Usar muestras distintas para las correlaciones y para el ACP, o no informar cuántas filas se excluyeron. | S3 |
| 22 | Eliminar una categoría por ser pequeña en lugar de documentar su tamaño y moderar las conclusiones. | S3 |
| 23 | Leer Pearson sin compararlo con Spearman ni revisar la dispersión cuando discrepan. | S3 |
| 24 | Tomar decisiones binarias en batería con p < 0.05 sobre muchas correlaciones simultáneas. | S3 |
| 25 | Omitir la justificación de `scale. = TRUE` o interpretar solo dos componentes sin scree plot ni criterios de retención. | S3 |
| 26 | Confundir los coeficientes de `rotation` con porcentajes de contribución o con correlaciones; nombrar componentes citando rotaciones. | S3 |
| 27 | Interpretar el signo de una componente como si fuera absoluto. | S3 |
| 28 | Recalcular el mismo ACP varias veces con nombres genéricos que sobrescriben objetos. | S3 |
| 29 | Mezclar definiciones de Biplot, no declarar que el factor de las flechas es visual, o escalar cada flecha con un factor distinto. | S3 |
| 30 | Presentar las elipses como fronteras de clasificación o prueba de conglomerados; afirmar que el ACP "encontró" los grupos. | S3 |
| 31 | Interpretar literalmente la distancia entre la punta de una flecha y un punto, o leer el Biplot empezando por los colores. | S3 |
| 32 | Usar la palabra "atípico" sin justificar qué significa en el contexto. | S3 |
| 33 | Dejar etiquetas solapadas o producir decenas de diagramas redundantes para todas las combinaciones. | S3 |

---

### 7. Referencias citadas en las prácticas

| Origen | Referencia |
|---|---|
| S2 | Hothorn, T. y Everitt, B. S. *HSAUR3: A Handbook of Statistical Analyses Using R* (3.ª ed.). CRAN. https://CRAN.R-project.org/package=HSAUR3 |
| S2 | Wickham, H., François, R., Henry, L., Müller, K. y Vaughan, D. *dplyr*. https://dplyr.tidyverse.org/ |
| S2 | Wickham, H. et al. *ggplot2*. https://ggplot2.tidyverse.org/ |
| S2 | R Core Team. *R: A Language and Environment for Statistical Computing*. https://www.R-project.org/ |
| S3 | R stats, documentación de `prcomp`: https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prcomp.html |
| S3 | R stats, documentación de `biplot.prcomp`: https://stat.ethz.ch/R-manual/R-devel/library/stats/help/biplot.prcomp.html |
| S3 | R MASS, documentación de `Cars93`: https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/Cars93.html |
| S3 | Gabriel, K. R. (1971). *The Biplot Graphic Display of Matrices with Application to Principal Component Analysis*. Biometrika, 58(3), 453–467. |
| S3 | Venables, W. N. y Ripley, B. D. (2002). *Modern Applied Statistics with S*. Springer. |

