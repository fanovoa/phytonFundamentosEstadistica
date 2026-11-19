# Actividad 2 · ¿Influye nuestro estilo de vida en el rendimiento académico?

Análisis descriptivo, ACP y Biplot de `student_lifestyle_performance_dataset.csv` (1 000 estudiantes, 12 variables) para la Actividad evaluable 1 de MEA1, siguiendo los 15 pasos de `Guia_Reutilizable_Actividad_Descriptiva.md`.

## Archivos

| Archivo | Contenido |
|---|---|
| `Actividad2_Estilo_de_Vida_y_CGPA.Rmd` | Análisis completo: presentación, preparación, cualitativas, cuantitativas, forma, grupos, correlaciones, ACP, dos Biplots, interpretación en capas hasta los centroides, respuesta y apéndice. Cada bloque de código va seguido de "Análisis del resultado" con cifras calculadas en el documento. |
| `Actividad2_Estilo_de_Vida_y_CGPA.html` | Informe compilado (fuente de verdad de todas las cifras). |
| `figuras/*.png` | Figuras exportadas a 300 dpi, numeradas por paso (`13_biplot_nivel_estres.png`, `13_biplot_perfil_habitos.png`, …). |
| `student_lifestyle_performance_dataset.csv` | Base original. |
| `Informe_Breve.md` | Resumen: pregunta, base, justificación, objetivos, variables, stack, advertencias, hallazgos con cifras, respuesta y rúbrica. |
| `Guion_Video.md` | Una fila por lámina con tiempo, palabras, texto narrado, figura y cifra; versión completa (122 s) y recortable (86 s). Se genera desde `presentacion/build.js`. |
| `presentacion/Actividad2_Laminas.pptx` | 9 láminas 16:9 con notas del orador (texto y duración) y la esquina inferior derecha libre para la cámara. Regenerar con `node build.js` dentro de `presentacion/`. |

## Cómo compilar (sin RStudio)

Requisitos: R ≥ 4.6 y conexión a internet la primera vez.

1. Paquetes de R (el bloque `setup` del Rmd instala automáticamente los que falten): `dplyr`, `tidyr`, `purrr`, `ggplot2`, `scales`, `ggrepel`, `patchwork`, `Hmisc`, `janitor`, `knitr`, `rmarkdown`.
2. Pandoc: se obtiene desde CRAN con el paquete `pandoc`, sin permisos de administrador.

```powershell
& "C:\Program Files\R\R-4.6.1\bin\Rscript.exe" --vanilla -e "install.packages(c('pandoc','gh','rmarkdown'), repos='https://cloud.r-project.org'); pandoc::pandoc_install()"
```

3. Compilar desde la carpeta `Actividad_2`:

```powershell
& "C:\Program Files\R\R-4.6.1\bin\Rscript.exe" --vanilla -e "setwd('C:/UniSabana/avanzados_1/Actividad_2'); pandoc::pandoc_activate(); rmarkdown::render('Actividad2_Estilo_de_Vida_y_CGPA.Rmd')"
```

Si se dispone de RStudio, basta abrir el Rmd y pulsar **Knit**; el resultado es el mismo.

### Aviso sobre `renv`

La carpeta raíz `C:\UniSabana\avanzados_1` tiene un `.Rprofile` que activa un proyecto `renv` sin estos paquetes. Compilar con el directorio de trabajo en `Actividad_2` (como en el comando anterior) evita que se cargue; `--vanilla` lo garantiza.

## Verificación rápida

```powershell
& "C:\Program Files\R\R-4.6.1\bin\Rscript.exe" --vanilla -e "setwd('C:/UniSabana/avanzados_1/Actividad_2'); knitr::purl('Actividad2_Estilo_de_Vida_y_CGPA.Rmd', output='verificacion.R', documentation=1); options(warn=1); source('verificacion.R', encoding='UTF-8')"
```

Debe correr sin errores ni warnings y regenerar las 9 figuras en `figuras/`.

## Decisiones principales

- **Tema 3**, unidad de análisis = estudiante, respuesta = CGPA.
- **Categóricas derivadas** (declaradas, cortes descriptivos): nivel de estrés en terciles y perfil estudio × sueño por medianas.
- **ACP con 6 variables activas** (estudio, sueño, asistencia, estrés, notas internas, CGPA); edad, pantalla y gimnasio se excluyen por no covariar con ninguna otra (|r| < 0.10). Plano CP1–CP2: 86.6 %.
- **Dos Biplots** con el mismo ACP y el mismo factor visual: A coloreado por nivel de estrés, B por perfil de hábitos. Ambos advierten que el grupo deriva de variables activas.
- Lenguaje descriptivo ("se asocia", "en esta base"); sin causalidad ni inferencia.

## Fuera de alcance

Conglomerados, extensiones §8–§10 de la sesión 3 e intervalos de confianza.
