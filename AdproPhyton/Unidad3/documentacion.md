### Conceptos clave de estadística descriptiva

* **Media:** Promedio aritmético que se obtiene al sumar todos los datos y dividir el resultado entre el número total de elementos. Representa el centro de gravedad de la distribución.
* **Mediana:** Valor central que divide los datos ordenados exactamente a la mitad, dejando el 50% por encima y el 50% por debajo. Se utiliza cuando existen valores atípicos o extremos que distorsionan el promedio.
* **Desviación estándar:** Medida que indica qué tan dispersos o separados están los datos respecto a la media. Evalúa la variabilidad y la consistencia del conjunto de datos.

La desviación estándar de una muestra de **5 entregas de reparto** con tiempos de 12, 15, 10, 18 y 15 minutos es de **3.08 minutos**. Esto significa que los tiempos de entrega varían, en promedio, unos 3.08 minutos respecto al tiempo medio de 14 minutos.

Imagina que eres dueño de un restaurante y mides el tiempo en minutos que tarda un repartidor en entregar los últimos 5 pedidos (una muestra). Los datos son: 12, 15, 10, 18, 15.

### 1. Calcular la media
Suma todos los tiempos y divídelos entre el número total de entregas ($n = 5$):

$$\mu = \frac{12 + 15 + 10 + 18 + 15}{5} = \frac{70}{5} = 14\text{ minutos}$$

### 2. Restar la media a cada dato y elevar al cuadrado
Calcula la diferencia de cada tiempo respecto a la media de 14 minutos y eleva el resultado al cuadrado para eliminar los signos negativos:

* $(12 - 14)^2 = (-2)^2 = 4$
* $(15 - 14)^2 = (1)^2 = 1$
* $(10 - 14)^2 = (-4)^2 = 16$
* $(18 - 14)^2 = (4)^2 = 16$
* $(15 - 14)^2 = (1)^2 = 1$

### 3. Sumar los resultados anteriores
Suma todos los valores obtenidos en el paso anterior:

$$\text{Suma} = 4 + 1 + 16 + 16 + 1 = 38$$

### 4. Calcular la varianza
Al tratarse de una muestra representativa (y no de todas las entregas de la historia del restaurante), dividimos la suma entre $n - 1$ (es decir, $5 - 1 = 4$):

$$\text{Varianza } (s^2) = \frac{38}{4} = 9.5$$

### 5. Calcular la raíz cuadrada
Aplica la raíz cuadrada a la varianza para regresar a las unidades originales (minutos):

$$s = \sqrt{9.5} \approx 3.08\text{ minutos}$$

### ✅ Desviación estándar calculada
El resultado final para este conjunto de datos muestrales es de **3.08 minutos**. Esto te indica que tu servicio es relativamente estable, ya que la mayoría de los pedidos se entregan en un rango de $14 \pm 3.08$ minutos (entre 10.92 y 17.08 minutos).



# Pruebas de Hipótesis en Estadística


Tema en estadistica  con el que se puede determinar si alguna condicion o alguna suposicion sobre una base de datos des verdadera  o no, o si puedo asumir que esa condicion se satisface o no.

-Ejemplo se tiene un grupo de estudiantes , queremos ver si una actividad fisica tiene algun efecto sobre los estudiantes,entonces se cogen dos grupos, grupo A y B , al grupo A no se le hace nada pero al grupo B si se interviene durante un tiempo, luego se quiere evaluar si esa actividad tuvo algun efecto , se toma el peso de los dos grupos , se obtien la distribucion, ¿esas distribuciones son iguales o diferentes? Si son iguales se concluye que  la intervencion fallo por si lo hacen o no lo hacen da lo mismo, pero si son diferentes entonces de alguna manera la intervencion que se hizo tiene un efecto, entonces para resolver la pregunta esas dos distribuciones son iguales o no se hacen prueba de hipotesis en esa prueba de hipotesis se arranca suponiendo que esas dos distribuciones son iguales y a eso se le llama hipotesis nula, lo que se evalua que tan problable es observar los datos asumiendo que esa hipotesis nula es verdadera

## 1. Definición y Propósito

La **prueba de hipótesis** es un método de inferencia estadística utilizado para evaluar si existe suficiente evidencia empírica en una muestra de datos para sustentar o rechazar una afirmación o supuesto previo sobre una población.

Permite determinar, con un nivel de significancia prefijado, si una condición asumida se satisface o si las diferencias observadas en los datos se deben al azar o a un efecto real.

---

## 2. Marco Conceptual y Componentes Principales

Para llevar a cabo una prueba de hipótesis, se plantean dos proposiciones mutuamente excluyentes:

* **Hipótesis Nula ($H_0$):** Es la premisa de partida que asume la **ausencia de efecto, diferencia o cambio** (el *status quo*). Representa la igualdad entre parámetros o distribuciones.
* **Hipótesis Alternativa ($H_1$ o $H_a$):** Es la afirmación opuesta a $H_0$. Propone que **existe un efecto, una diferencia significativa o un cambio** producto de una intervención o variable.

### La Lógica de Evaluación ($p$-valor)
El proceso no busca "probar" directamente $H_1$, sino evaluar **qué tan probable es observar los datos recolectados bajo el supuesto de que $H_0$ es verdadera**:

1. Se asume provisionalmente que $H_0$ es cierta.
2. Se calcula un valor de probabilidad (**$p$-valor**) basado en los datos muestrales.
3. Si el $p$-valor es excesivamente bajo (menor al umbral $ lpha$, típicamente $0.05$), se concluye que la evidencia en contra de $H_0$ es tan fuerte que resulta inverosímil mantenerla, por lo que **se rechaza $H_0$ en favor de $H_1$**.
4. Si el $p$-valor es alto, **no se rechaza $H_0$**, pues los datos son consistentes con la hipótesis de no diferencia.

---

## 3. Ejemplo Práctico: Evaluación de un Programa de Actividad Física

### Planteamiento del Problema
Un equipo de investigadores desea determinar si un programa de actividad física de 12 semanas influye en el peso corporal de los estudiantes de una institución educativa.

### Diseño del Experimento
Se seleccionan dos grupos homogéneos de estudiantes:
* **Grupo A (Grupo de Control):** Mantiene sus rutinas habituales sin ninguna intervención.
* **Grupo B (Grupo Experimental):** Participa activamente en el programa de ejercicio durante el período establecido.

Al finalizar el periodo, se registra el peso de los estudiantes de ambos grupos para analizar y comparar sus respectivas distribuciones de datos.

```
                    ┌─────────────────────────┐
                    │ Estudiantes de la prueba│
                    └────────────┬────────────┘
                                 │
                 ┌───────────────┴───────────────┐
                 ▼                               ▼
       ┌──────────────────┐            ┌──────────────────┐
       │ Grupo A (Control)│            │Grupo B (Interven)│
       │ Sin intervención │            │  Programa físico │
       └─────────┬────────┘            └─────────┬────────┘
                 │                               │
                 └───────────────┬───────────────┘
                                 ▼
                     ┌──────────────────────┐
                     │ Medición de pesos y  │
                     │  comparación de      │
                     │    distribuciones    │
                     └──────────────────────┘
```

### Formulación de Hipótesis

* **Hipótesis Nula ($H_0$):** $\mu_A = \mu_B$
  * *Las distribuciones de peso de ambos grupos son iguales.*
  * **Conclusión práctica si se acepta $H_0$:** La intervención **no tuvo un efecto significativo**; el resultado es equivalente a no haber realizado ninguna actividad.
* **Hipótesis Alternativa ($H_a$):** $\mu_A 
eq \mu_B$ (o $\mu_B < \mu_A$)
  * *Las distribuciones de peso de ambos grupos son estadísticamente diferentes.*
  * **Conclusión práctica si se rechaza $H_0$:** El programa de actividad física **generó un efecto real** sobre los estudiantes.

---

## 4. Estructura General del Proceso

```
[1. Formular H₀ y Hₐ] ──► [2. Definir Nivel α] ──► [3. Recolectar Datos] ──► [4. Calcular Estadístico y p-valor] ──► [5. Tomar Decisión]
```

1. **Formular las hipótesis ($H_0$ y $H_a$):** Definir claramente las afirmaciones a contrastar.
2. **Establecer el nivel de significancia ($ lpha$):** Definir el margen de error permitido (comúnmente $ lpha = 0.05$ o $5\%$).
3. **Calcular el estadístico de prueba:** Aplicar el test correspondiente (ej. *t de Student*, *Mann-Whitney*, *ANOVA*) según el tipo de datos y distribución.
4. **Obtener el $p$-valor:** Cuantificar la probabilidad de obtener los resultados observados bajo $H_0$.
5. **Tomar una decisión:**
   * Si $p	ext{-valor} <  lpha \implies$ **Se rechaza $H_0$** (Existe efecto/diferencia significativa).
   * Si $p	ext{-valor} \ge  lpha \implies$ **No se rechaza $H_0$** (No hay evidencia suficiente de efecto/diferencia).

# La Prueba T de Student (t-test)

La **prueba t de Student** (o *t-test*) es un método estadístico que se utiliza para **comparar las medias de dos grupos** y determinar si existen diferencias estadísticamente significativas entre ellas, o si la diferencia observada es simplemente producto del azar.

---

## 1. ¿Cuándo se utiliza la prueba T?

Se utiliza principalmente cuando:
* La variable que mides es **continua** (peso, estatura, tiempo, temperatura, salario).
* Quieres comparar **máximo dos grupos** (si tienes 3 o más grupos, se usa ANOVA).
* Las muestras son relativamente pequeñas ($n < 30$) o no conoces la desviación estándar real de la población (si la muestra fuera gigante y conocieras la desviación estándar poblacional, usarías la prueba $Z$).

---

## 2. Los 3 tipos de Prueba T

Dependiendo de cómo provengan tus datos, elegirás uno de estos tres tipos:

| Tipo de prueba T | ¿Cuándo se usa? | Ejemplo práctico |
| :--- | :--- | :--- |
| **Prueba T de una muestra** (*One-sample t-test*) | Comparas la media de **un solo grupo** contra un valor de referencia o promedio conocido. | Evaluar si el promedio de calificaciones de un curso es diferente de $7.0$. |
| **Prueba T de muestras independientes** (*Two-sample t-test*) | Comparas las medias de **dos grupos completamente distintos y no relacionados**. | Comparar el peso medio del **Grupo A (control)** vs. **Grupo B (ejercicio)**. |
| **Prueba T pareada** (*Paired t-test*) | Comparas **el mismo grupo en dos momentos diferentes** (antes y después). | Medir la presión arterial de los mismos pacientes **antes y después** de tomar un medicamento. |

---

## 3. Lógica y Explicación del Estadístico $t$

Para dos muestras independientes (específicamente la **prueba T de Welch**, que no asume que las varianzas de ambos grupos sean iguales), la expresión matemática del estadístico $t$ es:

$$t = \frac{\bar{x}_2 - \bar{x}_1}{\sqrt{\frac{\sigma_1^2}{n_1} + \frac{\sigma_2^2}{n_2}}}$$

Esta fórmula representa exactamente la relación entre la **diferencia de los promedios** y la **variabilidad (error estándar)** de los grupos:

$$\text{Estadístico } t = \frac{\text{Diferencia observada entre medias (Señal)}}{\text{Incertidumbre o ruido en la medición (Ruido)}}$$

### Desglose de cada elemento de la fórmula

#### 1. El Numerador: La señal (Diferencia entre grupos)
$$\bar{x}_2 - \bar{x}_1$$

* **$\bar{x}_1$ y $\bar{x}_2$:** Son las **medias (promedios) muestrales** del Grupo 1 y del Grupo 2.
* **Qué mide:** Qué tan alejados están los promedios entre sí (el **efecto de la intervención**). Si el Grupo B bajó de peso respecto al Grupo A, la resta cuantifica esa diferencia física.

#### 2. El Denominador: El ruido (Error estándar conjunto)
$$\sqrt{\frac{\sigma_1^2}{n_1} + \frac{\sigma_2^2}{n_2}}$$

*(Nota técnica: en la práctica muestral, la letra $\sigma^2$ suele representar la varianza muestral $s^2$).*

* **$\sigma_1^2$ y $\sigma_2^2$ ($s_1^2, s_2^2$):** Son las **varianzas** de cada grupo (qué tan dispersos están los datos dentro de cada muestra).
* **$n_1$ y $n_2$:** Es el **tamaño de la muestra** (número de estudiantes o sujetos en cada grupo).
* **Qué mide:** La incertidumbre o **variabilidad esperada por el azar**. Al dividir la varianza entre $n$, se corrige por el tamaño del grupo (a mayor tamaño de muestra $n$, menor es la incertidumbre).

### Interpretación del resultado de $t$

* **Si $t$ es un número grande (positivo o negativo):** La diferencia entre los promedios es mucho mayor que el "ruido" de los datos. Esto genera un **$p$-valor pequeño** $\implies$ **Rechazas $H_0$** (hay un efecto real).
* **Si $t$ está cercano a $0$:** La diferencia entre promedios es insignificante comparada con la variabilidad de los datos. Esto genera un **$p$-valor grande** $\implies$ **No rechazas $H_0$** (la diferencia se debe al azar).

---

## 4. Supuestos que deben cumplir tus datos

Para que la prueba T sea válida, los datos deben cumplir con ciertas condiciones:

1. **Escala continua:** La variable de interés se mide en un intervalo o razón (numérica).
2. **Independencia:** Las observaciones deben ser independientes entre sí (excepto en la prueba pareada).
3. **Normalidad:** Los datos dentro de cada grupo deben seguir (o aproximarse a) una distribución normal.
4. **Homocedasticidad (Homogeneidad de varianzas):** En pruebas independientes estándar, la variabilidad de ambos grupos debería ser similar. *(Si las varianzas son muy diferentes, se utiliza la prueba de Welch explícitamente).*

---

## 5. Pasos para ejecutar e interpretar una Prueba T

1. **Hipótesis:**
   * **$H_0$ (Nula):** $\mu_1 = \mu_2$ *(No hay diferencia entre las medias)*.
   * **$H_a$ (Alternativa):** $\mu_1 \neq \mu_2$ *(Sí hay diferencia entre las medias)*.
2. **Cálculo:** Obtienes el valor $t$ y su respectivo **$p$-valor** usando software estadístico (Python, R, Excel, SPSS).
3. **Decisión:** 
   * Si **$p\text{-valor} < 0.05$** $\implies$ **Rechazas $H_0$**. La diferencia es estadísticamente significativa.
   * Si **$p\text{-valor} \ge 0.05$** $\implies$ **No rechazas $H_0$**. No hay evidencia suficiente para afirmar que son distintos.


# Prueba t (t-test) explicada para dummies

La **prueba t (t-test)** sirve para responder una pregunta muy simple:

> **¿Dos grupos tienen realmente medias diferentes o la diferencia puede deberse al azar?**

Es una de las pruebas estadísticas más utilizadas.

---

# La idea en una frase

**El t-test compara los promedios (medias) de dos grupos para decidir si la diferencia entre ellos es estadísticamente significativa.**

---

# Ejemplo para dummies 🍎

Supongamos que un profesor quiere saber si un nuevo método de enseñanza funciona.

Tiene dos grupos de estudiantes.

## Grupo A (Método tradicional)

| Estudiante | Nota |
|------------|------|
|1|70|
|2|75|
|3|72|
|4|68|
|5|74|

Media:

\[
\frac{70+75+72+68+74}{5}=71.8
\]

---

## Grupo B (Nuevo método)

| Estudiante | Nota |
|------------|------|
|1|80|
|2|82|
|3|85|
|4|78|
|5|81|

Media:

\[
\frac{80+82+85+78+81}{5}=81.2
\]

---

A simple vista parece que el nuevo método es mejor.

Pero...

> ¿La diferencia de **71.8** contra **81.2** es real?

o

> ¿Simplemente tuve suerte al escoger esos estudiantes?

Aquí entra el **t-test**.

---

# ¿Qué hace el t-test?

Compara dos cosas:

- La diferencia entre las medias.
- La variabilidad de los datos.

Si la diferencia es muy grande comparada con la variabilidad, concluye que probablemente existe una diferencia real.

---

# La fórmula

La fórmula del t-test para dos muestras independientes es:

\[
t=\frac{\bar{x}_1-\bar{x}_2}
{\sqrt{\frac{s_1^2}{n_1}+\frac{s_2^2}{n_2}}}
\]

Donde:

- \(\bar{x}_1\) = media del grupo 1
- \(\bar{x}_2\) = media del grupo 2
- \(s_1\) = desviación estándar del grupo 1
- \(s_2\) = desviación estándar del grupo 2
- \(n_1\) = tamaño del grupo 1
- \(n_2\) = tamaño del grupo 2

No es necesario memorizar la fórmula.

Lo importante es entender la idea:

> **Diferencia entre medias ÷ Variación de los datos**

---

# Ejemplo sencillo

Dos cafeterías quieren saber cuál sirve el café más rápido.

## Cafetería A

```text
4
5
6
5
4
```

Media = **4.8 minutos**

---

## Cafetería B

```text
7
8
6
9
7
```

Media = **7.4 minutos**

La diferencia es:

```
7.4 - 4.8 = 2.6 minutos
```

El t-test pregunta:

> ¿Esos 2.6 minutos son suficientes para decir que una cafetería es realmente más rápida?

---

# Resultado del t-test

Después del cálculo obtienes un **p-valor**.

---

## Si p < 0.05

✅ Existe evidencia de que las medias son diferentes.

Ejemplo:

```
p = 0.01
```

Conclusión:

> El nuevo método de enseñanza sí parece mejorar las notas.

---

## Si p > 0.05

❌ No existe evidencia suficiente para afirmar que las medias sean diferentes.

Ejemplo:

```
p = 0.42
```

Conclusión:

> La diferencia observada podría deberse al azar.

---

# ¿Cuándo se usa?

El t-test se usa cuando quieres comparar promedios.

Ejemplos:

- ¿Los hombres ganan más que las mujeres?
- ¿Una medicina reduce más la presión arterial?
- ¿Un algoritmo es más rápido que otro?
- ¿Dos modelos de IA tienen diferente precisión?
- ¿Dos cursos producen diferentes calificaciones?

---

# Tipos de t-test

## 1. One Sample t-test

Compara una media con un valor conocido.

Ejemplo:

Una fábrica dice que una botella contiene **500 ml**.

Mides varias botellas.

Pregunta:

> ¿La media realmente es 500 ml?

---

## 2. Independent t-test (el más común)

Compara dos grupos independientes.

Ejemplo:

- Grupo control
- Grupo experimental

o

- Hombres
- Mujeres

o

- Método viejo
- Método nuevo

---

## 3. Paired t-test

Compara el mismo grupo antes y después.

Ejemplo:

Pesas a una persona.

Le das una dieta.

La vuelves a pesar.

Pregunta:

> ¿La dieta produjo un cambio?

---

# Analogía

Imagina dos equipos de fútbol.

Equipo A marca en promedio:

```
2 goles por partido
```

Equipo B marca:

```
2.2 goles por partido
```

¿Podemos decir que el Equipo B es mejor?

Tal vez no.

La diferencia es pequeña.

Ahora imagina:

Equipo A:

```
2 goles
```

Equipo B:

```
8 goles
```

Ahora sí parece existir una diferencia importante.

El t-test mide exactamente eso.

# Bootstrapping y Prueba de Chi-Cuadrado ($\chi^2$)

---

## 1. Métodos de Resuestreo: Bootstrapping

### ¿Qué es?
El **Bootstrapping** (o *resustitución*) es un método estadístico no paramétrico basado en **simulación e inferencia por ordenador**. Permite estimar la distribución muestral de casi cualquier estadístico (media, mediana, varianza, coeficientes de correlación, etc.) **sin necesidad de asumir que los datos siguen una distribución normal o teórica específica**.

Su principio fundamental es: *«La muestra observada es la mejor aproximación disponible de la población real»*.

---

### ¿Cómo funciona? (El algoritmo)

Imagina que tienes una muestra original de datos de tamaño $N$:

1. **Muestreo con reemplazo:** Tomas una submuestra de tamaño $N$ eligiendo datos al azar de tu muestra original, permitiendo que un mismo dato pueda ser seleccionado más de una vez (o ninguna).
2. **Cálculo del estadístico:** Calculas la métrica de interés (por ejemplo, la media) para esa nueva submuestra.
3. **Repetición masiva:** Repites los pasos 1 y 2 miles de veces (ej. $10,000$ iteraciones).
4. **Construcción de la distribución:** Al finalizar, tendrás $10,000$ medias calculadas. La distribución de esos valores te permite calcular directamente **intervalos de confianza** o **errores estándar**.
---

### ¿Cuándo usarlo?
* Cuando el **tamaño de la muestra es pequeño** y no puedes asumir normalidad.
* Cuando trabajas con estadísticos complejos para los cuales no existe una fórmula matemática sencilla para el error estándar (ej. la mediana o el percentil 95).
* Cuando quieres validar modelos de Machine Learning (evaluación de estabilidad de parámetros).

---

## 2. Prueba de Chi-Cuadrado ($\chi^2$)

### ¿Qué es?
La prueba de **Chi-Cuadrado** es una prueba de hipótesis estadística utilizada principalmente para **analizar variables categóricas** (cualitativas, como *género*, *tipo de cliente*, *estado civil*, *nivel de satisfacción*).

A diferencia de la prueba $t$ (que compara promedios numéricos), Chi-Cuadrado compara las **frecuencias observadas** (conteo real de datos) contra las **frecuencias esperadas** si no existiera relación alguna.

---

### Los 2 tipos principales de Prueba Chi-Cuadrado

#### A. Prueba de Bondad de Ajuste (*Goodness of Fit*)
Evalúa si la distribución observada de una **sola variable categórica** se ajusta a una distribución teórica esperada.
* **Ejemplo:** Lanzar un dado $60$ veces para comprobar si el dado está cargado (esperarías que cada cara salga aproximadamente $10$ veces).

#### B. Prueba de Independencia (*Test of Independence*)
Evalúa si existe una **asociación o relación significativa entre dos variables categóricas**.
* **Ejemplo:** Evaluar si la preferencia por un sistema operativo (Windows, macOS, Linux) es **independiente** del área profesional (Ingeniería, Diseño, Administración).

---

### La Fórmula y su Lógica

$$\chi^2 = \sum \frac{(O - E)^2}{E}$$

Donde:
* $O$: Frecuencia **Observada** (los datos reales de tu tabla de contingencia).
* $E$: Frecuencia **Esperada** (lo que debería ocurrir bajo la hipótesis nula de independencia).

#### Interpretación
* **Si la diferencia entre lo observado y lo esperado es grande:** El valor de $\chi^2$ será elevado, lo que genera un **$p$-valor pequeño** ($< 0.05$). $\implies$ **Rechazas la hipótesis nula ($H_0$)** y concluyes que **sí existe una relación entre las variables**.
* **Si las frecuencias observadas son muy similares a las esperadas:** $\chi^2$ estará cerca de $0$, con un **$p$-valor grande** ($\ge 0.05$). $\implies$ **No rechazas $H_0$**; las variables son independientes.

---

## 3. Resumen comparativo

| Característica | Bootstrapping | Chi-Cuadrado ($\chi^2$) |
| :--- | :--- | :--- |
| **Tipo de datos** | Numéricos (continuos o discretos) o Categóricos. | **Categóricos** (frecuencias/conteos). |
| **Propósito** | Estimar distribuciones, errores estándar e intervalos de confianza mediante simulación. | Evaluar independencia entre variables cualitativas o ajuste de distribuciones. |
| **Supuestos** | No paramétrico (no asume distribuciones teóricas). | Las frecuencias esperadas en cada celda deben ser generalmente $\ge 5$. |
| **Enfoque** | Basado en remuestreo e iteración computacional. | Basado en tablas de contingencia y la distribución teórica $\chi^2$. |



 # Bootstrap (Bootstrapping) y Chi-cuadrado explicados para dummies

¡Vamos a explicarlo de la forma más sencilla posible!

Imagina que tienes una bolsa con canicas y quieres aprender cosas sobre ella sin tener que comprar más canicas. Ahí entran **Bootstrap** y **Chi-cuadrado**.

---

# 1. Bootstrap (Bootstrapping)

## La idea en una frase

**Bootstrap consiste en reutilizar los mismos datos muchas veces para estimar qué tan confiable es un resultado.**

Piensa que solo tienes **10 personas** encuestadas, pero quisieras saber cómo se comportaría una muestra mucho más grande.

---

## Ejemplo para dummies 🍎

Supongamos que preguntaste la edad a 5 personas.

| Persona | Edad |
|---------|------|
| 1 | 20 |
| 2 | 22 |
| 3 | 25 |
| 4 | 30 |
| 5 | 35 |

La media es:

\[
\frac{20+22+25+30+35}{5}=26.4
\]

Pero...

> ¿Qué tan confiable es esa media?

Solo tienes 5 personas.

Bootstrap dice:

> "No puedo conseguir más personas, así que voy a crear muchas muestras nuevas usando las mismas."

---

## ¿Cómo?

Se eligen personas **al azar CON reemplazo**.

Eso significa que una persona puede salir varias veces.

Ejemplo de nuevas muestras:

### Muestra 1

```text
20
22
22
35
30
```

Media = **25.8**

---

### Muestra 2

```text
35
35
20
25
30
```

Media = **29**

---

### Muestra 3

```text
22
20
20
25
35
```

Media = **24.4**

---

Y haces esto...

- 100 veces
- 1000 veces
- 10000 veces

Obtendrás miles de medias.

Algo como:

```text
26.1
27.3
24.9
28.2
26.7
25.5
...
```

Entonces puedes decir:

> "La media normalmente cae entre 25 y 28."

Eso es mucho más útil que tener solo un número.

---

## ¿Por qué funciona?

Porque estás simulando qué pasaría si tomaras muchas muestras del mismo tipo.

No es magia.

Es una aproximación usando los datos que ya tienes.

---

## ¿Cuándo se usa?

- Intervalos de confianza
- Error estándar
- Machine Learning
- Validar modelos
- Cuando no conoces la distribución de los datos

---

## Analogía

Imagínate que solo tienes una foto de un bosque.

Bootstrap dice:

> "Voy a recortar esa foto miles de veces de distintas maneras para imaginar cómo sería el bosque completo."

---

# 2. Chi-cuadrado (Chi-Square)

Ahora cambiemos completamente de tema.

Bootstrap trabaja con números.

Chi-cuadrado trabaja con **categorías**.

Ejemplo:

- Hombre
- Mujer

o

- Sí
- No

o

- Rojo
- Azul
- Verde

---

## La idea

Quiere responder:

> **¿Lo que estoy viendo ocurrió por casualidad o existe una relación?**

---

## Ejemplo sencillo

Supón que lanzas un dado 60 veces.

Esperas:

| Número | Esperado |
|---------|-----------|
| 1 | 10 |
| 2 | 10 |
| 3 | 10 |
| 4 | 10 |
| 5 | 10 |
| 6 | 10 |

Pero obtienes:

| Número | Observado |
|---------|------------|
| 1 | 8 |
| 2 | 11 |
| 3 | 9 |
| 4 | 12 |
| 5 | 10 |
| 6 | 10 |

La pregunta es:

> ¿Estas diferencias son normales?

o

> ¿El dado está cargado?

Para responder usa Chi-cuadrado.

---

## La fórmula

\[
\chi^2=\sum \frac{(O-E)^2}{E}
\]

Donde:

- **O** = Observado
- **E** = Esperado

---

## Hagámoslo

Para el número 1:

Observado = 8

Esperado = 10

Entonces:

\[
\frac{(8-10)^2}{10}
=
\frac{4}{10}
=
0.4
\]

Para el número 2:

\[
\frac{(11-10)^2}{10}
=
0.1
\]

Y así con todos.

Al final sumas todos los valores.

Obtienes un número.

Ese número se compara con una tabla (o se calcula un **p-valor**).

---

Si el resultado es pequeño:

✅ Las diferencias pueden ser casualidad.

Si es grande:

❌ Probablemente hay algo raro.

---

## Otro ejemplo (más intuitivo)

Una empresa quiere saber:

> ¿Los hombres y mujeres prefieren el mismo celular?

Encuesta:

| | iPhone | Android |
|---|---:|---:|
| Hombres | 40 | 60 |
| Mujeres | 70 | 30 |

A simple vista parece que sí hay diferencia.

Pero...

¿Será casualidad?

Chi-cuadrado responde:

> "Voy a medir si esa diferencia es suficientemente grande."

Si el **p-valor** es menor a **0.05**:

Conclusión:

> Existe evidencia de que el sexo y la preferencia del celular están relacionados.

Si el **p-valor** es mayor a **0.05**:

> No hay evidencia suficiente para afirmar que exista una relación.

---

# Diferencia entre Bootstrap y Chi-cuadrado

| Bootstrap | Chi-cuadrado |
|------------|--------------|
| Reutiliza datos | Compara frecuencias |
| Hace miles de muestras | Hace un solo cálculo |
| Estima incertidumbre | Evalúa si hay diferencias o asociaciones |
| Trabaja con medias, medianas y estadísticas | Trabaja con categorías |
| Muy usado en Machine Learning | Muy usado en pruebas de hipótesis |

---

# Analogía final 🎲

Imagina una bolsa con bolas de colores.

## Bootstrap

Metes la mano, sacas bolas, las vuelves a meter y repites miles de veces.

Quieres saber:

> "¿Qué tan estable es mi estimación del color predominante?"

---

## Chi-cuadrado

Miras la bolsa y preguntas:

> "Esperaba 50 rojas y 50 azules, pero encontré 80 rojas y 20 azules."

Entonces preguntas:

> **¿Eso puede pasar por suerte o realmente la bolsa tiene más bolas rojas?**

Chi-cuadrado responde esa pregunta.

---

Imagina dos grupos lanzando dardos.

## Bootstrap

Preguntas:

> "¿Qué tan confiable es la puntería promedio?"

Repites el experimento miles de veces con los mismos datos.

---

## Chi-cuadrado

Preguntas:

> "Esperaba que cada color del blanco recibiera la misma cantidad de dardos."

¿La distribución observada es diferente de la esperada?

---

## t-test

Preguntas:

> "¿El Equipo A realmente lanza más cerca del centro que el Equipo B?"

Compara los promedios de ambos equipos.

---

# Resumen para memorizar

## Bootstrap

**Pregunta que responde:**

> ¿Qué tan confiable es mi estimación?

**Cómo lo hace:**

- Reutiliza los mismos datos.
- Crea miles de muestras con reemplazo.
- Calcula la estadística (media, mediana, etc.) miles de veces.
- Observa cómo varía.

---

## Chi-cuadrado

**Pregunta que responde:**

> ¿La diferencia observada es real o puede explicarse por el azar?

**Cómo lo hace:**

- Compara los valores observados con los esperados.
- Calcula una medida de diferencia.
- Obtiene un p-valor.
- Decide si existe evidencia estadística de una diferencia o asociación.

---

# Regla fácil para recordar

✅ **Bootstrap = Confianza**

> "¿Qué tan seguro estoy de mi resultado?"

Piensa en:

> **Repetir muchas veces para ganar confianza.**

---

✅ **Chi-cuadrado = Comparación**

> "¿Lo que veo es diferente de lo esperado?"

Piensa en:

> **Comparar lo observado contra lo esperado.**

## t-test

**Pregunta:**

> ¿Dos grupos tienen medias diferentes?

**Palabra clave:**

✅ Medias

---

# Truco para memorizar antes de un examen

| Método | Pregunta clave | Palabra que debes recordar |
|---------|----------------|----------------------------|
| Bootstrap | ¿Qué tan confiable es mi estimación? | **Re-muestrear** |
| Chi-cuadrado | ¿Existe una diferencia o relación? | **Comparar frecuencias** |
| t-test | Medias | Comparas promedios |

En una sola frase:

- **Bootstrap** = *"Repito mis datos muchas veces para medir la incertidumbre."*
- **Chi-cuadrado** = *"Comparo lo observado con lo esperado para saber si la diferencia es significativa."*
- **t-test** = *"¿Los promedios de dos grupos son realmente diferentes?"*

# Bootstrap (Bootstrapping) y Chi-cuadrado explicados para dummies

¡Vamos a explicarlo de la forma más sencilla posible!

Imagina que tienes una bolsa con canicas y quieres aprender cosas sobre ella sin tener que comprar más canicas. Ahí entran **Bootstrap** y **Chi-cuadrado**.

---

# 1. Bootstrap (Bootstrapping)

## La idea en una frase

**Bootstrap consiste en reutilizar los mismos datos muchas veces para estimar qué tan confiable es un resultado.**

Piensa que solo tienes **10 personas** encuestadas, pero quisieras saber cómo se comportaría una muestra mucho más grande.

---

## Ejemplo para dummies 🍎

Supongamos que preguntaste la edad a 5 personas.

| Persona | Edad |
|---------|------|
| 1 | 20 |
| 2 | 22 |
| 3 | 25 |
| 4 | 30 |
| 5 | 35 |

La media es:

\[
\frac{20+22+25+30+35}{5}=26.4
\]

Pero...

> ¿Qué tan confiable es esa media?

Solo tienes 5 personas.

Bootstrap dice:

> "No puedo conseguir más personas, así que voy a crear muchas muestras nuevas usando las mismas."

---

## ¿Cómo?

Se eligen personas **al azar CON reemplazo**.

Eso significa que una persona puede salir varias veces.

Ejemplo de nuevas muestras:

### Muestra 1

```text
20
22
22
35
30
```

Media = **25.8**

---

### Muestra 2

```text
35
35
20
25
30
```

Media = **29**

---

### Muestra 3

```text
22
20
20
25
35
```

Media = **24.4**

---

Y haces esto...

- 100 veces
- 1000 veces
- 10000 veces

Obtendrás miles de medias.

Algo como:

```text
26.1
27.3
24.9
28.2
26.7
25.5
...
```

Entonces puedes decir:

> "La media normalmente cae entre 25 y 28."

Eso es mucho más útil que tener solo un número.

---

## ¿Por qué funciona?

Porque estás simulando qué pasaría si tomaras muchas muestras del mismo tipo.

No es magia.

Es una aproximación usando los datos que ya tienes.

---

## ¿Cuándo se usa?

- Intervalos de confianza
- Error estándar
- Machine Learning
- Validar modelos
- Cuando no conoces la distribución de los datos

---

## Analogía

Imagínate que solo tienes una foto de un bosque.

Bootstrap dice:

> "Voy a recortar esa foto miles de veces de distintas maneras para imaginar cómo sería el bosque completo."

---

# 2. Chi-cuadrado (Chi-Square)

Ahora cambiemos completamente de tema.

Bootstrap trabaja con números.

Chi-cuadrado trabaja con **categorías**.

Ejemplo:

- Hombre
- Mujer

o

- Sí
- No

o

- Rojo
- Azul
- Verde

---

## La idea

Quiere responder:

> **¿Lo que estoy viendo ocurrió por casualidad o existe una relación?**

---

## Ejemplo sencillo

Supón que lanzas un dado 60 veces.

Esperas:

| Número | Esperado |
|---------|-----------|
| 1 | 10 |
| 2 | 10 |
| 3 | 10 |
| 4 | 10 |
| 5 | 10 |
| 6 | 10 |

Pero obtienes:

| Número | Observado |
|---------|------------|
| 1 | 8 |
| 2 | 11 |
| 3 | 9 |
| 4 | 12 |
| 5 | 10 |
| 6 | 10 |

La pregunta es:

> ¿Estas diferencias son normales?

o

> ¿El dado está cargado?

Para responder usa Chi-cuadrado.

---

## La fórmula

\[
\chi^2=\sum \frac{(O-E)^2}{E}
\]

Donde:

- **O** = Observado
- **E** = Esperado

---

## Hagámoslo

Para el número 1:

Observado = 8

Esperado = 10

Entonces:

\[
\frac{(8-10)^2}{10}
=
\frac{4}{10}
=
0.4
\]

Para el número 2:

\[
\frac{(11-10)^2}{10}
=
0.1
\]

Y así con todos.

Al final sumas todos los valores.

Obtienes un número.

Ese número se compara con una tabla (o se calcula un **p-valor**).

---

Si el resultado es pequeño:

✅ Las diferencias pueden ser casualidad.

Si es grande:

❌ Probablemente hay algo raro.

---

## Otro ejemplo (más intuitivo)

Una empresa quiere saber:

> ¿Los hombres y mujeres prefieren el mismo celular?

Encuesta:

| | iPhone | Android |
|---|---:|---:|
| Hombres | 40 | 60 |
| Mujeres | 70 | 30 |

A simple vista parece que sí hay diferencia.

Pero...

¿Será casualidad?

Chi-cuadrado responde:

> "Voy a medir si esa diferencia es suficientemente grande."

Si el **p-valor** es menor a **0.05**:

Conclusión:

> Existe evidencia de que el sexo y la preferencia del celular están relacionados.

Si el **p-valor** es mayor a **0.05**:

> No hay evidencia suficiente para afirmar que exista una relación.

---

# Diferencia entre Bootstrap y Chi-cuadrado

| Bootstrap | Chi-cuadrado |
|------------|--------------|
| Reutiliza datos | Compara frecuencias |
| Hace miles de muestras | Hace un solo cálculo |
| Estima incertidumbre | Evalúa si hay diferencias o asociaciones |
| Trabaja con medias, medianas y estadísticas | Trabaja con categorías |
| Muy usado en Machine Learning | Muy usado en pruebas de hipótesis |

---

# Analogía final 🎲

Imagina una bolsa con bolas de colores.

## Bootstrap

Metes la mano, sacas bolas, las vuelves a meter y repites miles de veces.

Quieres saber:

> "¿Qué tan estable es mi estimación del color predominante?"

---

## Chi-cuadrado

Miras la bolsa y preguntas:

> "Esperaba 50 rojas y 50 azules, pero encontré 80 rojas y 20 azules."

Entonces preguntas:

> **¿Eso puede pasar por suerte o realmente la bolsa tiene más bolas rojas?**

Chi-cuadrado responde esa pregunta.

---

# Resumen para memorizar

## Bootstrap

**Pregunta que responde:**

> ¿Qué tan confiable es mi estimación?

**Cómo lo hace:**

- Reutiliza los mismos datos.
- Crea miles de muestras con reemplazo.
- Calcula la estadística (media, mediana, etc.) miles de veces.
- Observa cómo varía.

---

## Chi-cuadrado

**Pregunta que responde:**

> ¿La diferencia observada es real o puede explicarse por el azar?

**Cómo lo hace:**

- Compara los valores observados con los esperados.
- Calcula una medida de diferencia.
- Obtiene un p-valor.
- Decide si existe evidencia estadística de una diferencia o asociación.

---

# Regla fácil para recordar

✅ **Bootstrap = Confianza**

> "¿Qué tan seguro estoy de mi resultado?"

Piensa en:

> **Repetir muchas veces para ganar confianza.**

---

✅ **Chi-cuadrado = Comparación**

> "¿Lo que veo es diferente de lo esperado?"

Piensa en:

> **Comparar lo observado contra lo esperado.**

---

# Truco para memorizar antes de un examen

| Método | Pregunta clave | Palabra que debes recordar |
|---------|----------------|----------------------------|
| Bootstrap | ¿Qué tan confiable es mi estimación? | **Re-muestrear** |
| Chi-cuadrado | ¿Existe una diferencia o relación? | **Comparar frecuencias** |

En una sola frase:

- **Bootstrap** = *"Repito mis datos muchas veces para medir la incertidumbre."*
- **Chi-cuadrado** = *"Comparo lo observado con lo esperado para saber si la diferencia es significativa."*

