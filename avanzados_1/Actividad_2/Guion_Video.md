# Guion del video · ¿Influye nuestro estilo de vida en el rendimiento académico?

- **Formato:** video en YouTube, máximo 2 min 10 s (130 s), expositor visible en la esquina inferior derecha durante toda la grabación (las láminas dejan esa esquina libre).
- **Ritmo declarado:** 2.5 palabras por segundo (lectura normal). Palabras reales contadas sobre el texto narrado.
- **Versión completa:** 9 láminas, 305 palabras, 122 s asignados (122 s al ritmo declarado).
- **Versión recortable (≤ 90 s):** 6 láminas, 215 palabras, 86 s asignados (86 s al ritmo declarado). Conserva pregunta, variables, grupos, relación y alcance; se omiten las láminas marcadas como recortables.
- **Fuente de las cifras:** `Actividad2_Estilo_de_Vida_y_CGPA.html`.

| # | Lámina | Tiempo (s) | Palabras | Texto narrado | Figura | Cifra clave | Recortable |
|---|---|---|---|---|---|---|---|
| 1 | Pregunta | 16 | 39 | ¿Influye nuestro estilo de vida en el rendimiento académico? Analicé cómo se relacionan las horas de estudio y de sueño con el CGPA de mil estudiantes, y cómo cambia esa relación según la carrera y el nivel de estrés. | — | 1 000 estudiantes · 12 variables | No |
| 2 | Base y variables | 14 | 37 | Cada fila es un estudiante. Nueve variables cuantitativas, tres cualitativas reales y dos derivadas: nivel de estrés en terciles y perfil estudio por sueño según las medianas. No hay faltantes, aunque la base muestra señales de simulación. | — | 9 cuantitativas · 3 + 2 cualitativas · 0 faltantes | No |
| 3 | CGPA: hallazgo univariado | 8 | 20 | El CGPA promedia 7.32 con desviación 0.95, distribución simétrica y solo trece valores extremos, que conservo porque son promedios plausibles. | Histograma nativo (11 clases de Sturges) | Media 7.32 · DE 0.95 · 13 extremos | Sí |
| 4 | Relaciones bivariadas | 14 | 36 | El sueño se asocia con el CGPA con 0.62 y el estudio con 0.51. El estrés sube con el estudio y baja con el sueño. Edad, pantalla y gimnasio no se asocian con ninguna otra variable. | 10_matriz_correlacion.png | Sueño–CGPA 0.62 · Estudio–CGPA 0.51 · Estrés–CGPA −0.17 | No |
| 5 | Comparación de grupos | 15 | 37 | Entre carreras, residencias y dietas la mediana del CGPA cambia menos de medio punto y las cajas se solapan. Entre perfiles va de 6.6 en quienes estudian y duermen poco a 8.2 en quienes hacen ambas cosas. | Barras nativas: mediana de CGPA por perfil | Carreras: rango 0.49 · Perfiles: 6.60 → 8.17 | No |
| 6 | ACP | 13 | 32 | Con seis variables correlacionadas el ACP retiene dos componentes que conservan el 86.6 por ciento: dedicación y desempeño, y tensión frente a descanso. Kaiser, el 80 por ciento y el codo coinciden. | 11_scree.png | CP1 49.4 % · CP2 37.3 % · plano 86.6 % | Sí |
| 7 | Biplot A: nivel de estrés | 15 | 38 | En el Biplot, los terciles de estrés se separan a lo largo del segundo eje. El grupo de estrés alto estudia más, pero su CGPA mediano es menor: el estrés acompaña las horas de estudio, no la nota. | 13_biplot_nivel_estres.png | Centroides Bajo (−0.42, −1.55) · Alto (0.46, 1.52) | Sí |
| 8 | Biplot B: perfil estudio × sueño | 15 | 37 | Los cuatro perfiles ocupan los cuatro cuadrantes. Estudiar y dormir por encima de la mediana se ubica hacia CGPA alto y estrés bajo. Las elipses se solapan: la diferencia es de promedios, y es esperable por construcción. | 13_biplot_perfil_habitos.png | Separación máxima entre centroides 3.44 | No |
| 9 | Respuesta y alcance | 12 | 29 | En esta base, dormir y estudiar más acompañan un CGPA mayor; la carrera no. Es una descripción de asociaciones, no una causa, y no se generaliza a otros estudiantes. | — | r = 0.62 y 0.51 · carrera: rango 0.49 | No |

**Totales:** 122 s · 305 palabras · 2.50 palabras/s reales.

## Indicaciones de grabación

1. Cámara en la esquina inferior derecha (≈ 2.4 × 1.7 pulgadas del lienzo 16:9); ninguna lámina coloca contenido ahí.
2. Definir cada categoría derivada la primera vez que aparece (lámina 2) y no volver a explicarla.
3. Lenguaje no causal: "se asocia", "acompaña", "en esta base". Nunca "causa" ni "demuestra".
4. Si el tiempo real supera 130 s, grabar la versión recortable: láminas 1, 2, 4, 5, 8, 9.
