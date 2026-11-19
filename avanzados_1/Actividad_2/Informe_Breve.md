# Informe breve · ¿Influye nuestro estilo de vida en el rendimiento académico?

- **Curso:** MEA1 – Métodos Estadísticos Avanzados 1 · Actividad evaluable 1 (primera entrega, análisis descriptivo).
- **Autor:** Víctor Fabián Novoa Rojas — Maestría en Inteligencia Artificial, Universidad de La Sabana.
- **Fuente de verdad de las cifras:** `Actividad2_Estilo_de_Vida_y_CGPA.html` (compilado desde el Rmd del mismo nombre).

## 1. Pregunta de investigación

> ¿Cómo se relacionan las horas de estudio y las horas de sueño con el CGPA de los estudiantes, y cómo varía esa relación según la carrera y el nivel de estrés?

Dos cuantitativas explicativas (estudio, sueño), una respuesta cuantitativa (CGPA) y dos categóricas (carrera, nivel de estrés). Tema 3 de la guía.

## 2. Base de datos

`student_lifestyle_performance_dataset.csv`: 1 000 estudiantes × 12 columnas. Unidad de análisis: **un estudiante por fila**, sin identificador, sin tiempo, sin medidas repetidas. 0 faltantes, 0 duplicados; muestra analítica = 1 000.

## 3. Justificación

- **Interés:** el rendimiento se atribuye a la dedicación, pero descanso y tensión también forman parte del día del estudiante; describirlos en conjunto da una mirada que una nota aislada no da.
- **Beneficiarios:** estudiantes (ubican su perfil), docentes y bienestar universitario (qué patrones acompañan promedios altos y bajos).
- **Aprendizaje:** qué hábitos se asocian linealmente con el CGPA, cuáles no, y cómo se resume la estructura en dos ejes.
- **Decisiones:** qué hábitos medir y seguir en acompañamiento. Alcance **descriptivo**: sin causas ni generalización.

## 4. Objetivos

- **General:** describir la relación entre horas de estudio, horas de sueño y CGPA en 1 000 estudiantes, y cómo varía según carrera y nivel de estrés.
- **Específicos:** (1) comparar la distribución del CGPA entre carreras, niveles de estrés y perfiles de hábitos; (2) identificar las variables con mayor asociación lineal con el CGPA y resumir la estructura conjunta con ACP y Biplot.

## 5. Variables

| Tipo | Variables | Rol |
|---|---|---|
| Cuantitativas (9) | Edad; horas de estudio/día; horas de sueño/día; horas de pantalla/día; horas de gimnasio/semana; asistencia (%); estrés (1–10, continua); notas internas (0–100); CGPA (0–10) | CGPA = respuesta. Activas en ACP: estudio, sueño, asistencia, estrés, notas internas, CGPA. Edad, pantalla y gimnasio: descriptivas, no activas |
| Cualitativas reales (3) | Carrera (6), tipo de dieta (2), residencia (2) | Grupos a priori |
| Cualitativas derivadas (2) | Nivel de estrés (terciles: Bajo ≤ 3.65, Medio, Alto > 5.46); perfil estudio × sueño (medianas 4.09 h y 6.51 h) | Grupos suplementarios de los Biplots; corte descriptivo declarado |

Conteo: 9 cuantitativas, 3 + 2 cualitativas. Supera el mínimo de la guía (2 y 2) y el de este proyecto (3 y 3).

## 6. Stack

R 4.6.1 · `dplyr`, `tidyr`, `purrr`, `ggplot2`, `scales`, `ggrepel`, `patchwork`, `Hmisc`, `janitor`, `knitr`, `rmarkdown` · pandoc 3.11 (paquete CRAN `pandoc`) · compilación con `rmarkdown::render()` desde `Actividad_2/` (equivalente al Knit de RStudio). Figuras exportadas a 300 dpi en `figuras/`.

## 7. Advertencias sobre la base

- Señales de **base simulada o recortada**: edad plana (curtosis −1.23; 136 estudiantes en 17 años y 102 en 25), 90 con exactamente 0 h de gimnasio, 52 con estrés exactamente 1, estrés "1 a 10" con decimales (520 valores distintos).
- El estrés se explica casi linealmente por estudio y sueño (R² = 0.77); el CGPA por todas las demás (R² = 0.85): patrón típico de un generador lineal.
- No hay sumas imposibles (0 estudiantes con más de 24 h entre estudio, sueño y pantalla).
- Consecuencia: los resultados describen **esta base**, no estudiantes reales.

## 8. Hallazgos con cifras

**Cualitativas.** Carreras equilibradas (Civil 17.7 % la mayor, Electrical 16.0 % la menor); Veg 59.3 %; Hosteller 50.3 %. Derivadas equilibradas por construcción (terciles ≈ 33 %; perfiles 23–27 %).

**CGPA.** Media 7.32, mediana 7.30, DE 0.95, Q1–Q3 = 6.69–7.99. Asimetría −0.06, curtosis 0.25; 13 extremos por 1.5·IQR en ambas colas, conservados. Decisión: media/DE con mediana/IQR de respaldo (todas las variables con |asimetría| ≤ 0.44).

**Comparación de grupos (mediana de CGPA).**

| Agrupación | Mín → Máx | Rango |
|---|---|---|
| Carrera | CSE 7.04 → Civil 7.53 | 0.49 |
| Residencia | 7.29 → 7.30 | 0.01 |
| Dieta | 7.27 → 7.31 | 0.04 |
| Nivel de estrés | Alto 7.13 → Bajo 7.48 | 0.35 |
| Perfil estudio × sueño | Estudia- Duerme- 6.60 → Estudia+ Duerme+ 8.17 | 1.58 |

Las cajas de los grupos a priori se solapan casi por completo; las de perfiles vecinos también se solapan: la diferencia es de promedios.

**Correlaciones (Pearson; Spearman coincide, discrepancia máxima 0.025).** Notas internas–CGPA 0.87; estudio–asistencia 0.82; estudio–estrés 0.65; sueño–CGPA 0.62; sueño–estrés −0.58; estudio–CGPA 0.51; estrés–CGPA −0.17. Edad, pantalla y gimnasio: |r| < 0.10 con todo → excluidas del ACP.

**ACP (6 activas, estandarizadas).** Valores propios 2.96, 2.24, 0.38, 0.22, 0.13, 0.07. CP1 49.4 %, CP2 37.3 %, plano **86.6 %**. Kaiser = 2, 80 % = 2, codo en CP3: coinciden.

- **CP1 = dedicación y desempeño:** correlaciones CGPA 0.87, notas 0.84, estudio 0.82, asistencia 0.76, sueño 0.45; estrés 0.22.
- **CP2 = tensión frente a descanso:** estrés 0.93, sueño −0.77, estudio 0.51, asistencia 0.48; CGPA −0.39, notas −0.36.
- Signo orientado hacia CGPA alto (CP1) y estrés alto (CP2); es arbitrario y se declara.

**Biplot (correlación; factor visual común 3.40).**

- Calidad de representación: todas cos² ≥ 0.80 (estudio 0.93 mejor; sueño 0.80 peor).
- Ángulos coherentes con r: estudio–asistencia 0.3° (0.82); notas–CGPA 1.3° (0.87); estrés–sueño 136° (−0.58); estrés–CGPA 101° (−0.17).
- Extremos: Est. 362 (CP1 −5.47: 0.66 h de estudio, notas 35, CGPA 4.09) y Est. 172 (CP1 5.06: 8.05 h, asistencia 100 %, CGPA 9.94). Perfiles extremos coherentes, no errores.
- **Centroides.** Estrés: Bajo (−0.42, −1.55) vs Alto (0.46, 1.52): se separan en CP2; el grupo alto estudia más pero su CGPA mediano es menor (7.13 vs 7.48). Perfiles: Estudia+ Duerme+ (1.76, −0.32) vs Estudia- Duerme- (−1.63, 0.33), separación máxima 3.44. Carrera, residencia y dieta: centroides a ≤ 0.38 del origen, elipses coincidentes.
- La separación de los grupos derivados es **esperable por construcción**; el ACP no "encontró" grupos.

## 9. Respuesta descriptiva

En esta base de 1 000 estudiantes el CGPA promedia 7.32 (DE 0.95), con distribución simétrica y 13 extremos conservados. El sueño (r = 0.62) y el estudio (r = 0.51) se asocian positivamente con el CGPA; edad, pantalla y gimnasio no se asocian con nada. El estrés sube con el estudio y baja con el sueño, y apenas se relaciona con el CGPA. Entre carreras, residencias y dietas la mediana del CGPA cambia menos de 0.5 puntos y las cajas se solapan; entre perfiles de hábitos va de 6.60 a 8.17. El ACP resume seis variables en dos ejes (86.6 %): dedicación y desempeño, y tensión frente a descanso; en el Biplot los perfiles y los niveles de estrés ocupan regiones distintas con elipses solapadas. Todo describe asociaciones en esta base, probablemente simulada: no demuestra causas ni se extiende a otros estudiantes.

## 10. Correspondencia con la rúbrica

| Criterio | Evidencia |
|---|---|
| Pregunta (1.0) | Sección 1 del Rmd: dos cuantitativas + respuesta + dos categóricas; justificación en cuatro preguntas; objetivos con verbos descriptivos. |
| Organización de datos (1.0) | Tipos verificados, 0 faltantes, muestra única, tabla de variables con rol, advertencias sobre la base. |
| Técnicas descriptivas (1.5) | Frecuencias; media/mediana/moda/DE/varianza/IQR/rango; Sturges; asimetría y curtosis; boxplots; Pearson y Spearman; ACP con tres criterios; Biplot con factor visual declarado; tabla de decisiones justificadas. |
| Interpretación (1.5) | "Análisis del resultado" con cifras calculadas; Biplot en cinco capas hasta los centroides; respuesta ≤ 200 palabras; afirmaciones respaldadas vs excesivas; alcance delimitado. |

## 11. Archivos

`Actividad2_Estilo_de_Vida_y_CGPA.Rmd` / `.html` · `figuras/` (9 PNG, 300 dpi) · `Guion_Video.md` · `presentacion/Actividad2_Laminas.pptx` · `README.md`.
