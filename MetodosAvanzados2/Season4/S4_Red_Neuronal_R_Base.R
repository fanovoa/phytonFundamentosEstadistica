# ================================================================
# SESIÓN 4 · Métodos de regresión e inteligencia artificial
# Código R extraído del cuaderno: S4_Red_Neuronal_R_Base.Rmd
# Ejecutar desde la carpeta S4_IA_Regresion de forma secuencial.
# Cada bloque está explicado con detalle en el archivo R Markdown.
# ================================================================

# ---- BLOQUE: setup ----

knitr::opts_chunk$set(echo=TRUE, warning=FALSE, message=FALSE,
                      fig.width=10, fig.height=5.4, fig.align="center",dev="svg")
for (p in c("ggplot2","knitr","quantreg","MASS")) {
  if (!requireNamespace(p,quietly=TRUE))
    stop("Instale el paquete de R: ",p)
}
set.seed(20261116)
color_ls <- "#2185EB"
color_lad <- "#EA4C91"
color_huber <- "#11B99A"
tema <- function() ggplot2::theme_minimal(base_size=14) +
  ggplot2::theme(plot.title=ggplot2::element_text(face="bold",colour="#18314A"),
                 panel.grid.minor=ggplot2::element_blank(),
                 legend.position="bottom")

# ---- BLOQUE: cargar-datos ----

# PASO 1. Compilar ANTES S4_Laboratorio_STS.Rmd.
# Ese cuaderno crea un RDS de características derivadas de la base STS oficial.
archivo <- "datos/STS_features_app.rds"
if (!file.exists(archivo))
  stop("Ejecute primero S4_Laboratorio_STS.Rmd para generar ",archivo)

# PASO 2. Leer las particiones originales sin rediseñarlas.
d <- readRDS(archivo)
stopifnot(all(c("train","valid","test","predictores") %in% names(d)))
rasgos <- d$predictores
Xtrain <- as.matrix(d$train[rasgos])
Xvalid <- as.matrix(d$valid[rasgos])
Xtest  <- as.matrix(d$test[rasgos])
ytrain <- as.numeric(d$train$score)
yvalid <- as.numeric(d$valid$score)
ytest  <- as.numeric(d$test$score)

stopifnot(ncol(Xtrain)==3L, all(is.finite(Xtrain)),
          all(is.finite(Xvalid)),all(is.finite(Xtest)),
          all(ytrain>=0 & ytrain<=1))
# PASO 3. Mostrar cuántas filas y columnas tiene cada partición.
print(data.frame(
  Particion=c("Entrenamiento","Validación","Prueba"),
  Pares=c(nrow(Xtrain),nrow(Xvalid),nrow(Xtest)),
  Variables=c(ncol(Xtrain),ncol(Xvalid),ncol(Xtest))))
# PASO 4. Observar TRES pares ya convertidos en números.
print(round(Xtrain[1:3, , drop=FALSE],3))

# ---- BLOQUE: dibujar-perdidas ----

# PASO 1. Crear una rejilla de errores hipotéticos SOLO para dibujar funciones.
e <- seq(-1,1,length.out=301)
delta <- 0.15
curvas <- rbind(
  data.frame(Error=e,Perdida=e^2,Metodo="MSE"),
  data.frame(Error=e,Perdida=abs(e),Metodo="MAE"),
  data.frame(Error=e,Perdida=ifelse(abs(e)<=delta,.5*e^2,
                          delta*(abs(e)-.5*delta)),Metodo="Huber"))
ggplot2::ggplot(curvas,ggplot2::aes(x=Error,y=Perdida,colour=Metodo)) +
  ggplot2::geom_line(linewidth=1.3) +
  ggplot2::scale_colour_manual(values=c(Huber=color_huber,MAE=color_lad,MSE=color_ls)) +
  ggplot2::labs(title="¿Qué error resulta caro para cada método?",
                subtitle="Curvas matemáticas ilustrativas; no son datos observados",
                x="Predicción menos etiqueta",y="Pérdida por observación") + tema()

# ---- BLOQUE: ensayo-matrices ----

# EJEMPLO 1. Dos observaciones, cada una con tres características.
mini_X <- matrix(c(1,2,3,4,5,6),nrow=2,byrow=TRUE)
# EJEMPLO 2. Tres entradas conectadas con dos neuronas de ejemplo.
mini_W <- matrix(c(.1,.2,.3,.4,.5,.6),nrow=3,byrow=TRUE)
# EJEMPLO 3. Multiplicar: el resultado tiene 2 filas y 2 columnas.
print(mini_X)
print(mini_W)
print(round(mini_X %*% mini_W,2))

# ---- BLOQUE: funciones-red ----

# PASO 1. Inicializar todos los pesos con la misma semilla para una
# comparación justa entre pérdidas: tres entradas, ocho neuronas ocultas.
inicializar <- function(p=3L,h=8L,semilla=41L) {
  set.seed(semilla)
  list(W1=matrix(rnorm(p*h,sd=0.15),nrow=p,ncol=h),
       b1=rep(0,h),
       W2=rnorm(h,sd=0.15),
       b2=0)
}

# PASO 2. Propagación hacia delante (forward pass).
propagar <- function(red,X) {
  # Cada fila se combina con los 24 pesos de la primera capa.
  Z1 <- sweep(X %*% red$W1,2,red$b1,"+")
  # tanh() representa la activación no lineal de las 8 neuronas.
  H <- tanh(Z1)
  # Cada fila de H produce UNA salida antes de la sigmoide.
  z2 <- as.numeric(H %*% red$W2)+red$b2
  # plogis() equivale a 1/(1+exp(-z2)), con mayor estabilidad numérica.
  pred <- plogis(z2)
  list(H=H,pred=pred)
}

# PASO 3. Pérdidas: promedio en todas las observaciones.
perdida <- function(y,pred,metodo,delta=0.15) {
  # El signo es "predicción menos observación"; MAE usa su valor absoluto.
  e <- pred-y
  if (metodo=="MSE") return(mean(e^2))
  if (metodo=="MAE") return(mean(abs(e)))
  if (metodo=="Huber")
    return(mean(ifelse(abs(e)<=delta,0.5*e^2,
                       delta*(abs(e)-0.5*delta))))
  stop("Pérdida no reconocida")
}

# PASO 4. Regla de la cadena: gradientes de TODOS los parámetros.
# (a) derivar la pérdida con respecto a la predicción;
# (b) derivar la sigmoide: p(1-p);
# (c) derivar tanh: 1-H^2;
# (d) usar productos matriciales para sumar sobre el lote completo.
gradientes <- function(red,X,y,metodo,delta=0.15) {
  # Guardamos las activaciones H: las necesitaremos al calcular derivadas.
  A <- propagar(red,X)
  e <- A$pred-y
  dl_dp <- switch(metodo,
    MSE=2*e,
    MAE=sign(e),
    Huber=ifelse(abs(e)<=delta,e,delta*sign(e)))
  if (is.null(dl_dp)) stop("Método desconocido")

  # Dividimos por n porque la pérdida definida es un PROMEDIO.
  dz2 <- dl_dp * A$pred*(1-A$pred)/nrow(X)
  # crossprod(H,dz2) = t(H) %*% dz2: 8 derivadas de pesos.
  gW2 <- as.numeric(crossprod(A$H,dz2))
  gb2 <- sum(dz2)

  # Repartir gradiente de salida a las ocho neuronas ocultas.
  dz1 <- tcrossprod(dz2,red$W2)*(1-A$H^2)
  # crossprod(X,dz1) = t(X) %*% dz1: matriz 3 por 8.
  gW1 <- crossprod(X,dz1)
  gb1 <- colSums(dz1)
  list(W1=gW1,b1=gb1,W2=gW2,b2=gb2)
}

# PASO 5. Verificar magnitudes antes de comenzar a entrenar.
red_inicial <- inicializar()
g0 <- gradientes(red_inicial,Xtrain,ytrain,"MSE")
print(data.frame(
  Parametro=c("W1","b1","W2","b2"),
  Cantidad=c(length(g0$W1),length(g0$b1),length(g0$W2),length(g0$b2))))

# ---- BLOQUE: auditar-gradiente ----

# PASO 6. Comprobación numérica independiente de UN gradiente.
# Una derivada analítica equivocada puede producir un entrenamiento que parece
# avanzar y sin embargo está conceptualmente mal.
h <- 1e-5
r_mas <- red_inicial; r_menos <- red_inicial
r_mas$W1[1,1] <- r_mas$W1[1,1]+h
r_menos$W1[1,1] <- r_menos$W1[1,1]-h
f_mas <- perdida(ytrain,propagar(r_mas,Xtrain)$pred,"MSE")
f_menos <- perdida(ytrain,propagar(r_menos,Xtrain)$pred,"MSE")
grad_numerico <- (f_mas-f_menos)/(2*h)
grad_analitico <- g0$W1[1,1]
error_gradiente <- abs(grad_numerico-grad_analitico)
print(data.frame(Gradiente_analitico=grad_analitico,
                 Gradiente_numerico=grad_numerico,
                 Diferencia=error_gradiente))
stopifnot(is.finite(error_gradiente),error_gradiente<1e-5)

# ---- BLOQUE: entrenamiento ----

# PASO 1. Esta función hace una época completa de gradiente y Adam.
# Se conservan los pesos con menor MAE de VALIDACIÓN (early stopping).
entrenar_red <- function(metodo,epocas=300L,tasa=0.035,
                         delta=0.15,paciencia=55L) {
  # Todas las pérdidas empiezan con los mismos pesos iniciales.
  red <- inicializar(semilla=41L)
  # m y v tienen la misma forma que la red, pero sus valores son cero.
  m <- lapply(red,function(z) z*0)
  v <- lapply(red,function(z) z*0)
  # Guardar la mejor red observada en validación (no en prueba).
  mejor <- red
  mejor_mae <- Inf
  epoca_mejor <- 0L
  historia <- data.frame(Epoca=integer(),
                         Perdida_train=numeric(),MAE_valid=numeric())

  for (t in seq_len(epocas)) {
    # Gradiente de entrenamiento de la pérdida elegida.
    g <- gradientes(red,Xtrain,ytrain,metodo,delta)

    # PASO 2. Adam con corrección de sesgo en cada parámetro.
    for (nom in names(red)) {
      # names(red) recorre W1, b1, W2, b2 uno por uno.
      m[[nom]] <- 0.9*m[[nom]]+0.1*g[[nom]]
      v[[nom]] <- 0.999*v[[nom]]+0.001*g[[nom]]^2
      m_corr <- m[[nom]]/(1-0.9^t)
      v_corr <- v[[nom]]/(1-0.999^t)
      red[[nom]] <- red[[nom]]-tasa*m_corr/(sqrt(v_corr)+1e-8)
    }

    p_train <- propagar(red,Xtrain)$pred
    # No se actualizan parámetros usando el vector de validación.
    p_valid <- propagar(red,Xvalid)$pred
    l_train <- perdida(ytrain,p_train,metodo,delta)
    mae_val <- mean(abs(yvalid-p_valid))
    historia <- rbind(historia,data.frame(
      Epoca=t,Perdida_train=l_train,MAE_valid=mae_val))

    # PASO 3. Guardar los mejores parámetros SIN mirar test.
    if (mae_val < mejor_mae-1e-7) {
      mejor <- red
      mejor_mae <- mae_val
      epoca_mejor <- t
    }
    if (t-epoca_mejor >= paciencia) break
  }
  list(red=mejor,metodo=metodo,mejor_mae=mejor_mae,
       epoca_mejor=epoca_mejor,historia=historia)
}

# PASO 4. Ajustar tres modelos con exactamente la misma entrada.
metodos <- c("MSE","MAE","Huber")
redes <- setNames(lapply(metodos,entrenar_red),metodos)
resumen_epocas <- data.frame(
  Perdida=metodos,
  Epocas_realizadas=vapply(redes,function(x)nrow(x$historia),integer(1)),
  Mejor_epoca=vapply(redes,function(x)x$epoca_mejor,integer(1)),
  MAE_validacion=vapply(redes,function(x)x$mejor_mae,numeric(1)))
print(resumen_epocas,row.names=FALSE)

# ---- BLOQUE: curvas-aprendizaje ----

curvas <- do.call(rbind,lapply(names(redes),function(nm)
  transform(redes[[nm]]$historia,Metodo=nm)))
ggplot2::ggplot(curvas,ggplot2::aes(Epoca,MAE_valid,colour=Metodo)) +
  ggplot2::geom_line(linewidth=1.1) +
  ggplot2::scale_colour_manual(values=c(MSE=color_ls,MAE=color_lad,Huber=color_huber)) +
  ggplot2::labs(title="Aprendizaje de cada red sobre validación",
    subtitle="Misma arquitectura; cambia la función de pérdida que se minimiza",
    x="Época",y="MAE de validación") + tema()

# ---- BLOQUE: comparacion-red-lineal ----

# PASO 1. Ajustar cabezas lineales desde el mismo archivo de características.
f <- stats::as.formula(paste("score ~",paste(rasgos,collapse=" + ")))
base_train <- d$train
ls <- stats::lm(f,data=base_train)
lad <- quantreg::rq(f,tau=.5,data=base_train)
huber <- MASS::rlm(f,data=base_train,method="M",
                   psi=MASS::psi.huber,maxit=200)

# PASO 2. Una única función de evaluación para TODO modelo.
medir <- function(y,pred,nombre) data.frame(
  Modelo=nombre,
  MAE=mean(abs(y-pred)),
  RMSE=sqrt(mean((y-pred)^2)),
  Spearman=unname(cor(y,pred,method="spearman")))

comparar <- function(particion, X,y) {
  clasicos <- list(LS=ls,LAD=lad,Huber_lineal=huber)
  tabla_1 <- do.call(rbind,lapply(names(clasicos),function(nm)
    medir(y,as.numeric(predict(clasicos[[nm]],newdata=particion)),nm)))
  tabla_2 <- do.call(rbind,lapply(names(redes),function(nm)
    medir(y,propagar(redes[[nm]]$red,X)$pred,paste0("Red_",nm))))
  rbind(tabla_1,tabla_2)
}

# PASO 3. Validación: esta tabla sirve para seleccionar la familia/cabeza.
tabla_valid <- comparar(d$valid,Xvalid,yvalid)
tabla_valid <- tabla_valid[order(tabla_valid$MAE),]
print(transform(tabla_valid,MAE=round(MAE,4),RMSE=round(RMSE,4),
                Spearman=round(Spearman,4)),row.names=FALSE)

# PASO 4. Elección congelada antes de mirar prueba.
seleccionado <- tabla_valid$Modelo[1]
cat("Modelo seleccionado por MAE de validación:",seleccionado,"\n")

# PASO 5. Recién ahora calcular la tabla en PRUEBA.
tabla_test <- comparar(d$test,Xtest,ytest)
tabla_test <- tabla_test[order(tabla_test$MAE),]
print(transform(tabla_test,MAE=round(MAE,4),RMSE=round(RMSE,4),
                Spearman=round(Spearman,4)),row.names=FALSE)

# ---- BLOQUE: examinar-frases ----

# PASO 1. Recuperar la predicción del modelo seleccionado en prueba.
# Verificar que el nombre seleccionado corresponde a uno de los seis modelos.
stopifnot(seleccionado %in%
            c("LS","LAD","Huber_lineal",paste0("Red_",names(redes))))
# Si el nombre empieza por "Red_", se trata de una red neuronal.
if (startsWith(seleccionado,"Red_")) {
  # Quitar el prefijo, por ejemplo "Red_MSE" se convierte en "MSE".
  id <- sub("^Red_","",seleccionado)
  # Predecir con la red que se guardó en su mejor época de validación.
  p_test <- propagar(redes[[id]]$red,Xtest)$pred
} else {
  # Elegir el objeto lineal ya ajustado: LS, LAD o Huber.
  objeto <- switch(seleccionado,LS=ls,LAD=lad,Huber_lineal=huber)
  p_test <- as.numeric(predict(objeto,newdata=d$test))
}

# PASO 2. Seleccionar los cinco errores absolutos más grandes.
# order(...,decreasing=TRUE) devuelve primero los índices de errores mayores.
peores <- order(abs(ytest-p_test),decreasing=TRUE)[1:5]
casos <- data.frame(
  Etiqueta_humana=round(ytest[peores],3),
  Prediccion=round(p_test[peores],3),
  Error_absoluto=round(abs(ytest[peores]-p_test[peores]),3),
  Frase_A=substr(d$test$sentence1[peores],1,100),
  Frase_B=substr(d$test$sentence2[peores],1,100))
print(casos,row.names=FALSE)

