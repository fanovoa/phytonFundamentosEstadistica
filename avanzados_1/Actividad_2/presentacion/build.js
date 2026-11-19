// Genera las láminas (Actividad2_Laminas.pptx) y el guion del video (../Guion_Video.md)
// desde una única fuente: el arreglo `laminas`. Así el texto narrado, las notas del
// orador y el conteo de palabras nunca se desincronizan.
const pptxgen = require("pptxgenjs");
const fs = require("fs");
const path = require("path");

const FIG = (n) => path.join(__dirname, "..", "figuras", n);
const RITMO = 2.5; // palabras por segundo (lectura normal)

// ---- Guion: una entrada por lámina -------------------------------------------------
const laminas = [
  {
    id: 1, titulo: "Pregunta", seg: 16, recortable: false,
    figura: "—", cifra: "1 000 estudiantes · 12 variables",
    texto: "¿Influye nuestro estilo de vida en el rendimiento académico? Analicé cómo se relacionan las horas de estudio y de sueño con el CGPA de mil estudiantes, y cómo cambia esa relación según la carrera y el nivel de estrés.",
  },
  {
    id: 2, titulo: "Base y variables", seg: 14, recortable: false,
    figura: "—", cifra: "9 cuantitativas · 3 + 2 cualitativas · 0 faltantes",
    texto: "Cada fila es un estudiante. Nueve variables cuantitativas, tres cualitativas reales y dos derivadas: nivel de estrés en terciles y perfil estudio por sueño según las medianas. No hay faltantes, aunque la base muestra señales de simulación.",
  },
  {
    id: 3, titulo: "CGPA: hallazgo univariado", seg: 8, recortable: true,
    figura: "Histograma nativo (11 clases de Sturges)", cifra: "Media 7.32 · DE 0.95 · 13 extremos",
    texto: "El CGPA promedia 7.32 con desviación 0.95, distribución simétrica y solo trece valores extremos, que conservo porque son promedios plausibles.",
  },
  {
    id: 4, titulo: "Relaciones bivariadas", seg: 14, recortable: false,
    figura: "10_matriz_correlacion.png", cifra: "Sueño–CGPA 0.62 · Estudio–CGPA 0.51 · Estrés–CGPA −0.17",
    texto: "El sueño se asocia con el CGPA con 0.62 y el estudio con 0.51. El estrés sube con el estudio y baja con el sueño. Edad, pantalla y gimnasio no se asocian con ninguna otra variable.",
  },
  {
    id: 5, titulo: "Comparación de grupos", seg: 15, recortable: false,
    figura: "Barras nativas: mediana de CGPA por perfil", cifra: "Carreras: rango 0.49 · Perfiles: 6.60 → 8.17",
    texto: "Entre carreras, residencias y dietas la mediana del CGPA cambia menos de medio punto y las cajas se solapan. Entre perfiles va de 6.6 en quienes estudian y duermen poco a 8.2 en quienes hacen ambas cosas.",
  },
  {
    id: 6, titulo: "ACP", seg: 13, recortable: true,
    figura: "11_scree.png", cifra: "CP1 49.4 % · CP2 37.3 % · plano 86.6 %",
    texto: "Con seis variables correlacionadas el ACP retiene dos componentes que conservan el 86.6 por ciento: dedicación y desempeño, y tensión frente a descanso. Kaiser, el 80 por ciento y el codo coinciden.",
  },
  {
    id: 7, titulo: "Biplot A: nivel de estrés", seg: 15, recortable: true,
    figura: "13_biplot_nivel_estres.png", cifra: "Centroides Bajo (−0.42, −1.55) · Alto (0.46, 1.52)",
    texto: "En el Biplot, los terciles de estrés se separan a lo largo del segundo eje. El grupo de estrés alto estudia más, pero su CGPA mediano es menor: el estrés acompaña las horas de estudio, no la nota.",
  },
  {
    id: 8, titulo: "Biplot B: perfil estudio × sueño", seg: 15, recortable: false,
    figura: "13_biplot_perfil_habitos.png", cifra: "Separación máxima entre centroides 3.44",
    texto: "Los cuatro perfiles ocupan los cuatro cuadrantes. Estudiar y dormir por encima de la mediana se ubica hacia CGPA alto y estrés bajo. Las elipses se solapan: la diferencia es de promedios, y es esperable por construcción.",
  },
  {
    id: 9, titulo: "Respuesta y alcance", seg: 12, recortable: false,
    figura: "—", cifra: "r = 0.62 y 0.51 · carrera: rango 0.49",
    texto: "En esta base, dormir y estudiar más acompañan un CGPA mayor; la carrera no. Es una descripción de asociaciones, no una causa, y no se generaliza a otros estudiantes.",
  },
];

const palabras = (t) => t.trim().split(/\s+/).length;
laminas.forEach((l) => { l.palabras = palabras(l.texto); l.segCalc = l.palabras / RITMO; });
const totalSeg = laminas.reduce((a, l) => a + l.seg, 0);
const totalPal = laminas.reduce((a, l) => a + l.palabras, 0);
const cortas = laminas.filter((l) => !l.recortable);
const totalSeg90 = cortas.reduce((a, l) => a + l.seg, 0);
const totalPal90 = cortas.reduce((a, l) => a + l.palabras, 0);

// ---- Guion en Markdown ---------------------------------------------------------------
const md = [];
md.push("# Guion del video · ¿Influye nuestro estilo de vida en el rendimiento académico?", "");
md.push("- **Formato:** video en YouTube, máximo 2 min 10 s (130 s), expositor visible en la esquina inferior derecha durante toda la grabación (las láminas dejan esa esquina libre).");
md.push(`- **Ritmo declarado:** ${RITMO} palabras por segundo (lectura normal). Palabras reales contadas sobre el texto narrado.`);
md.push(`- **Versión completa:** ${laminas.length} láminas, ${totalPal} palabras, ${totalSeg} s asignados (${(totalPal / RITMO).toFixed(0)} s al ritmo declarado).`);
md.push(`- **Versión recortable (≤ 90 s):** ${cortas.length} láminas, ${totalPal90} palabras, ${totalSeg90} s asignados (${(totalPal90 / RITMO).toFixed(0)} s al ritmo declarado). Conserva pregunta, variables, grupos, relación y alcance; se omiten las láminas marcadas como recortables.`);
md.push("- **Fuente de las cifras:** `Actividad2_Estilo_de_Vida_y_CGPA.html`.", "");
md.push("| # | Lámina | Tiempo (s) | Palabras | Texto narrado | Figura | Cifra clave | Recortable |");
md.push("|---|---|---|---|---|---|---|---|");
laminas.forEach((l) => md.push(`| ${l.id} | ${l.titulo} | ${l.seg} | ${l.palabras} | ${l.texto} | ${l.figura} | ${l.cifra} | ${l.recortable ? "Sí" : "No"} |`));
md.push("", `**Totales:** ${totalSeg} s · ${totalPal} palabras · ${(totalPal / totalSeg).toFixed(2)} palabras/s reales.`, "");
md.push("## Indicaciones de grabación", "");
md.push("1. Cámara en la esquina inferior derecha (≈ 2.4 × 1.7 pulgadas del lienzo 16:9); ninguna lámina coloca contenido ahí.");
md.push("2. Definir cada categoría derivada la primera vez que aparece (lámina 2) y no volver a explicarla.");
md.push("3. Lenguaje no causal: \"se asocia\", \"acompaña\", \"en esta base\". Nunca \"causa\" ni \"demuestra\".");
md.push("4. Si el tiempo real supera 130 s, grabar la versión recortable: láminas " + cortas.map((l) => l.id).join(", ") + ".");
fs.writeFileSync(path.join(__dirname, "..", "Guion_Video.md"), md.join("\n") + "\n", "utf8");

// ---- Láminas ------------------------------------------------------------------------
const C = { navy: "08306B", mid: "4292C6", light: "9ECAE1", ice: "EAF2FA", accent: "D55E00", ink: "1F2933", grey: "6B7280", white: "FFFFFF", green: "009E73" };
const F = "Calibri";
const pres = new pptxgen();
pres.layout = "LAYOUT_16x9"; // 10 x 5.625 in
pres.author = "Víctor Fabián Novoa Rojas";
pres.title = "¿Influye nuestro estilo de vida en el rendimiento académico?";
// Zona reservada para la cámara: x ≥ 7.5, y ≥ 3.85 (esquina inferior derecha). Nada se dibuja allí.
const CAM = { x: 7.5, y: 3.85 };

const nota = (l) => `Lámina ${l.id} · ${l.titulo} · ${l.seg} s · ${l.palabras} palabras\n\n${l.texto}\n\nCifra clave: ${l.cifra}. Esquina inferior derecha libre para la cámara.`;

function titulo(slide, texto, color = C.ink) {
  slide.addText(texto, { x: 0.5, y: 0.35, w: 9, h: 0.7, fontFace: F, fontSize: 26, bold: true, color, isTextBox: true, margin: 0 });
}
function stat(slide, x, y, w, numero, etiqueta, colorNum = C.navy, tam = 40) {
  slide.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y, w, h: 1.35, fill: { color: C.ice }, line: { color: C.ice }, rectRadius: 0.08 });
  slide.addText(numero, { x: x + 0.15, y: y + 0.1, w: w - 0.3, h: 0.75, fontFace: F, fontSize: tam, bold: true, color: colorNum, isTextBox: true, margin: 0, valign: "middle" });
  slide.addText(etiqueta, { x: x + 0.15, y: y + 0.85, w: w - 0.3, h: 0.4, fontFace: F, fontSize: 12, color: C.grey, isTextBox: true, margin: 0 });
}
function pie(slide, texto) {
  slide.addText(texto, { x: 0.5, y: 5.15, w: 6.8, h: 0.35, fontFace: F, fontSize: 10, color: C.grey, isTextBox: true, margin: 0 });
}

// 1. Portada (fondo oscuro)
{
  const l = laminas[0]; const s = pres.addSlide(); s.background = { color: C.navy };
  s.addText("¿Influye nuestro estilo de vida en el rendimiento académico?", { x: 0.6, y: 0.7, w: 8.8, h: 1.6, fontFace: F, fontSize: 36, bold: true, color: C.white, isTextBox: true, margin: 0 });
  s.addText("Cómo se relacionan las horas de estudio y de sueño con el CGPA, y cómo varía según la carrera y el nivel de estrés", { x: 0.6, y: 2.4, w: 6.6, h: 0.9, fontFace: F, fontSize: 16, color: C.light, isTextBox: true, margin: 0 });
  s.addText("1 000 estudiantes · 12 variables · análisis descriptivo en R", { x: 0.6, y: 3.45, w: 6.6, h: 0.4, fontFace: F, fontSize: 14, bold: true, color: C.white, isTextBox: true, margin: 0 });
  s.addText("Víctor Fabián Novoa Rojas · MEA1 · Maestría en Inteligencia Artificial, Universidad de La Sabana", { x: 0.6, y: 4.9, w: 6.6, h: 0.4, fontFace: F, fontSize: 11, color: C.light, isTextBox: true, margin: 0 });
  s.addNotes(nota(l));
}
// 2. Base y variables
{
  const l = laminas[1]; const s = pres.addSlide(); s.background = { color: C.white };
  titulo(s, "Una fila = un estudiante");
  stat(s, 0.5, 1.25, 2.1, "1 000", "estudiantes · 0 faltantes");
  stat(s, 2.8, 1.25, 2.1, "9", "variables cuantitativas");
  stat(s, 5.1, 1.25, 2.1, "3 + 2", "cualitativas reales + derivadas", C.accent);
  s.addText([
    { text: "Cuantitativas: ", options: { bold: true } },
    { text: "estudio, sueño, pantalla, gimnasio, asistencia, estrés, notas internas, edad y CGPA (respuesta).", options: { breakLine: true } },
    { text: "A priori: ", options: { bold: true } },
    { text: "carrera (6), residencia (2), dieta (2).", options: { breakLine: true } },
    { text: "Derivadas: ", options: { bold: true, color: C.accent } },
    { text: "nivel de estrés en terciles (Bajo/Medio/Alto) y perfil estudio × sueño por medianas (4.09 h y 6.51 h).", options: {} },
  ], { x: 0.5, y: 2.85, w: 6.8, h: 1.7, fontFace: F, fontSize: 14, color: C.ink, isTextBox: true, margin: 0, paraSpaceAfter: 6, valign: "top" });
  pie(s, "Advertencia: edad plana, recortes en los bordes y estrés continuo sugieren una base simulada. Los resultados describen esta base.");
  s.addNotes(nota(l));
}
// 3. CGPA univariado: histograma nativo + cifras
{
  const l = laminas[2]; const s = pres.addSlide(); s.background = { color: C.white };
  titulo(s, "El CGPA es simétrico y concentrado");
  const clases = ["4.0", "4.5", "5.0", "5.5", "6.0", "6.5", "7.0", "7.5", "8.0", "8.5", "9.0", "9.5"];
  const conteos = [6, 3, 13, 55, 110, 185, 217, 167, 143, 61, 29, 11];
  s.addChart(pres.charts.BAR, [{ name: "Estudiantes", labels: clases, values: conteos }], {
    x: 0.4, y: 1.15, w: 5.0, h: 3.9, barDir: "col", barGapWidthPct: 8,
    chartColors: [C.mid], showLegend: false, showTitle: true, title: "Estudiantes por clase de CGPA (Sturges, 11 clases)", titleFontSize: 11, titleColor: C.grey,
    showValue: true, dataLabelPosition: "outEnd", dataLabelFontSize: 8, dataLabelColor: C.grey,
    catAxisLabelFontSize: 9, catAxisLabelColor: C.grey, catAxisTitle: "Límite inferior de la clase", showCatAxisTitle: true, catAxisTitleFontSize: 9, catAxisTitleColor: C.grey,
    valAxisLabelFontSize: 9, valAxisLabelColor: C.grey, valGridLine: { color: "E5E7EB", size: 0.5 }, catGridLine: { style: "none" },
  });
  stat(s, 5.7, 1.15, 1.7, "7.32", "media (mediana 7.30)");
  stat(s, 5.7, 2.65, 1.7, "0.95", "desviación estándar");
  s.addText([{ text: "13", options: { bold: true, fontSize: 22, color: C.accent } }, { text: "  extremos por 1.5·IQR, conservados", options: { fontSize: 11, color: C.grey } }], { x: 5.7, y: 4.15, w: 1.8, h: 0.5, fontFace: F, isTextBox: true, margin: 0, valign: "middle" });
  s.addNotes(nota(l));
}
// 4. Correlaciones: matriz + cifras
{
  const l = laminas[3]; const s = pres.addSlide(); s.background = { color: C.white };
  titulo(s, "Sueño y estudio acompañan al CGPA");
  s.addImage({ path: FIG("10_matriz_correlacion.png"), x: 0.4, y: 1.1, w: 5.6, h: 4.04 });
  stat(s, 6.3, 1.15, 1.9, "0.62", "sueño – CGPA");
  stat(s, 6.3, 2.6, 1.9, "0.51", "estudio – CGPA");
  s.addText([{ text: "−0.17", options: { bold: true, fontSize: 22, color: C.accent } }, { text: "  estrés – CGPA", options: { fontSize: 11, color: C.grey } }], { x: 6.3, y: 4.1, w: 2.4, h: 0.5, fontFace: F, isTextBox: true, margin: 0, valign: "middle" });
  s.addNotes(nota(l));
}
// 5. Grupos: barras nativas de mediana por perfil + rango por agrupación
{
  const l = laminas[4]; const s = pres.addSlide(); s.background = { color: C.white };
  titulo(s, "La carrera no separa el CGPA; los hábitos sí");
  s.addChart(pres.charts.BAR, [{ name: "Mediana de CGPA", labels: ["Estudia- Duerme-", "Estudia- Duerme+", "Estudia+ Duerme-", "Estudia+ Duerme+"], values: [6.6, 7.36, 7.13, 8.17] }], {
    x: 0.4, y: 1.15, w: 4.6, h: 3.9, barDir: "bar", barGapWidthPct: 35,
    chartColors: ["D55E00", "E69F00", "56B4E9", "009E73"], showLegend: false, showTitle: true, title: "Mediana de CGPA por perfil estudio × sueño", titleFontSize: 11, titleColor: C.grey,
    showValue: true, dataLabelPosition: "outEnd", dataLabelFontSize: 11, dataLabelColor: C.ink, dataLabelFormatCode: "0.00",
    catAxisLabelFontSize: 10, catAxisLabelColor: C.ink, valAxisHidden: true, valAxisMinVal: 0, valAxisMaxVal: 10, valGridLine: { style: "none" }, catGridLine: { style: "none" },
  });
  s.addText("Rango de la mediana de CGPA", { x: 5.4, y: 1.15, w: 3.6, h: 0.35, fontFace: F, fontSize: 12, bold: true, color: C.grey, isTextBox: true, margin: 0 });
  const filas = [["Perfil estudio × sueño", "1.58", C.green], ["Nivel de estrés", "0.35", C.mid], ["Carrera", "0.49", C.grey], ["Dieta", "0.04", C.grey], ["Residencia", "0.01", C.grey]];
  filas.forEach(([n, v, col], i) => {
    const y = 1.55 + i * 0.45;
    s.addText(n, { x: 5.4, y, w: 2.5, h: 0.4, fontFace: F, fontSize: 13, color: C.ink, isTextBox: true, margin: 0, valign: "middle" });
    s.addText(v, { x: 7.9, y, w: 0.9, h: 0.4, fontFace: F, fontSize: 16, bold: true, color: col, isTextBox: true, margin: 0, valign: "middle", align: "right" });
  });
  s.addText("Las cajas de carreras, residencias y dietas se solapan casi por completo.", { x: 5.4, y: 3.85, w: 2.0, h: 0.9, fontFace: F, fontSize: 11, color: C.grey, isTextBox: true, margin: 0 });
  s.addNotes(nota(l));
}
// 6. ACP: scree + cifras
{
  const l = laminas[5]; const s = pres.addSlide(); s.background = { color: C.white };
  titulo(s, "Dos componentes conservan el 86.6 % de seis variables");
  s.addImage({ path: FIG("11_scree.png"), x: 0.4, y: 1.15, w: 5.8, h: 2.9 });
  s.addText([
    { text: "CP1 · dedicación y desempeño (49.4 %)", options: { bold: true, color: C.navy, breakLine: true } },
    { text: "CGPA 0.87 · notas 0.84 · estudio 0.82 · asistencia 0.76", options: { color: C.grey, fontSize: 11, breakLine: true } },
    { text: " ", options: { fontSize: 6, breakLine: true } },
    { text: "CP2 · tensión frente a descanso (37.3 %)", options: { bold: true, color: C.accent, breakLine: true } },
    { text: "estrés 0.93 · sueño −0.77 · estudio 0.51", options: { color: C.grey, fontSize: 11 } },
  ], { x: 0.5, y: 4.15, w: 6.8, h: 1.2, fontFace: F, fontSize: 14, isTextBox: true, margin: 0, valign: "top" });
  stat(s, 6.5, 1.15, 1.7, "2", "componentes: Kaiser, 80 % y codo coinciden");
  stat(s, 6.5, 2.6, 1.7, "86.6 %", "varianza en el plano", C.navy, 28);
  s.addNotes(nota(l));
}
// 7 y 8. Biplots
function laminaBiplot(l, archivo, tituloTexto, callouts, pieTexto) {
  const s = pres.addSlide(); s.background = { color: C.white };
  titulo(s, tituloTexto);
  s.addImage({ path: FIG(archivo), x: 0.3, y: 1.05, w: 5.2, h: 4.62 });
  callouts.forEach((c, i) => stat(s, 5.8, 1.15 + i * 1.5, 1.6, c[0], c[1], c[2] || C.navy, c[3] || 30));
  s.addText(pieTexto, { x: 5.8, y: 4.2, w: 1.6, h: 1.2, fontFace: F, fontSize: 10, color: C.grey, isTextBox: true, margin: 0 });
  s.addNotes(nota(l));
}
laminaBiplot(laminas[6], "13_biplot_nivel_estres.png", "Biplot A · el estrés se separa en el eje tensión–descanso",
  [["−1.55", "CP2 del grupo Bajo"], ["1.52", "CP2 del grupo Alto", C.accent]],
  "Estrés alto: estudia más (5.1 h) pero CGPA mediano menor (7.13 vs 7.48). Elipses 95 % descriptivas; separación esperable por construcción.");
laminaBiplot(laminas[7], "13_biplot_perfil_habitos.png", "Biplot B · cuatro perfiles, cuatro cuadrantes",
  [["8.17", "CGPA mediano Estudia+ Duerme+", C.green], ["6.60", "CGPA mediano Estudia- Duerme-", C.accent]],
  "Separación máxima entre centroides 3.44. Elipses solapadas: la diferencia es de promedios, no individual.");
// 9. Cierre (fondo oscuro)
{
  const l = laminas[8]; const s = pres.addSlide(); s.background = { color: C.navy };
  s.addText("En esta base…", { x: 0.6, y: 0.45, w: 8.8, h: 0.6, fontFace: F, fontSize: 26, bold: true, color: C.light, isTextBox: true, margin: 0 });
  const puntos = [
    ["Dormir y estudiar más acompañan un CGPA mayor", "r = 0.62 y 0.51; perfiles de 6.60 a 8.17"],
    ["La carrera, la residencia y la dieta no", "rango de medianas ≤ 0.49; centroides en el origen"],
    ["Dos ejes resumen el 86.6 %", "dedicación y desempeño · tensión frente a descanso"],
    ["Descripción, no causa", "base probablemente simulada; sin generalización"],
  ];
  puntos.forEach(([t, d], i) => {
    const y = 1.25 + i * 0.85;
    s.addShape(pres.shapes.OVAL, { x: 0.6, y: y + 0.08, w: 0.32, h: 0.32, fill: { color: i === 3 ? C.accent : C.mid }, line: { color: i === 3 ? C.accent : C.mid } });
    s.addText(String(i + 1), { x: 0.6, y: y + 0.08, w: 0.32, h: 0.32, fontFace: F, fontSize: 12, bold: true, color: C.white, align: "center", valign: "middle", isTextBox: true, margin: 0 });
    s.addText(t, { x: 1.1, y, w: 6.2, h: 0.4, fontFace: F, fontSize: 18, bold: true, color: C.white, isTextBox: true, margin: 0, valign: "middle" });
    s.addText(d, { x: 1.1, y: y + 0.4, w: 6.2, h: 0.35, fontFace: F, fontSize: 12, color: C.light, isTextBox: true, margin: 0 });
  });
  s.addText("Análisis completo: Actividad2_Estilo_de_Vida_y_CGPA.html", { x: 0.6, y: 5.0, w: 6.6, h: 0.35, fontFace: F, fontSize: 10, color: C.light, isTextBox: true, margin: 0 });
  s.addNotes(nota(l));
}

pres.writeFile({ fileName: path.join(__dirname, "Actividad2_Laminas.pptx") }).then((f) => {
  console.log("pptx:", f);
  console.log(`guion: ${laminas.length} láminas, ${totalPal} palabras, ${totalSeg} s (versión corta ${totalPal90} palabras, ${totalSeg90} s)`);
  laminas.forEach((l) => console.log(`  L${l.id} ${l.seg}s ${l.palabras}p -> ${l.segCalc.toFixed(1)}s al ritmo ${RITMO}`));
});
