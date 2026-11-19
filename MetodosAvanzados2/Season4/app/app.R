# PRÁCTICA 4 · Panel interactivo de robustez para NLP
# ==========================================================
# Para ejecutar desde RStudio:
#   1. Compile primero S4_Laboratorio_STS.Rmd: genera los datos reales de STS.
#   2. install.packages(c("shiny","ggplot2","quantreg","MASS","bslib"))
#   3. shiny::runApp("app")
#
# Este panel utiliza exclusivamente R y los rasgos construidos con GloVe
# por el cuaderno principal. No fabrica puntuaciones ni pares de oraciones.

library(shiny)
library(ggplot2)

# PASO 1. Localizar la base procesada en la práctica principal.
archivo <- file.path("..", "datos", "STS_features_app.rds")
if (!file.exists(archivo)) {
  stop(paste0(
    "No se encontró ", archivo,
    ". Compile antes S4_Laboratorio_STS.Rmd para descargar STS y crear embeddings."
  ))
}

# PASO 2. Cargar las particiones, que conservaron sus etiquetas reales.
datos <- readRDS(archivo)
stopifnot(is.list(datos), all(c("train","valid","test","predictores") %in% names(datos)))
preds <- datos$predictores
formula_modelo <- stats::as.formula(paste("score ~", paste(preds,collapse=" + ")))
paleta <- c(LS="#399CFF", LAD="#FF639D", Huber="#26D7A2")

# PASO 3. Una función de evaluación, independiente del método de estimación.
calcular <- function(verdad, pronostico, etiqueta) {
  data.frame(
    Modelo=etiqueta,
    MAE=mean(abs(verdad-pronostico)),
    RMSE=sqrt(mean((verdad-pronostico)^2)),
    Spearman=unname(stats::cor(verdad,pronostico,method="spearman"))
  )
}

# PASO 4. Declarar la interfaz visual. Cada control corresponde a una
# decisión estadística; los resultados cambian solo al pulsar 'Actualizar'.
ui <- fluidPage(
  tags$head(tags$style(HTML("
    body { background:radial-gradient(circle at 90% 5%,#13395f 0%,#091931 34%,#070f25 100%);
           font-family:system-ui, sans-serif; color:#e7f6ff; }
    .container-fluid { max-width:1490px; padding:22px 38px 50px; }
    .brand { background:linear-gradient(112deg,#173559 0%,#0a5a77 70%,#198e86 100%);
             border:1px solid rgba(74,237,222,.28);border-radius:23px;
             padding:24px 32px; margin-bottom:26px; box-shadow:0 15px 40px #00132466; }
    .brand h1 { color:white;margin:0 0 7px;font-weight:800;font-size:35px;letter-spacing:-1.2px; }
    .brand p { color:#c4f4f5;font-size:17px;margin:0; }
    .kicker { color:#ccff8f;font-size:11px;font-weight:800;letter-spacing:2px; }
    .pane { background:#112743; border:1px solid #2c496c;border-radius:20px;
            padding:24px;margin-bottom:18px;box-shadow:0 7px 30px #0006; }
    .pane h3 {color:#6cddff;margin-top:0;font-size:22px;}
    .helptext { color:#a7c6d8;line-height:1.55; }
    .well {background:#142a48;border:none;}
    label {color:#ecf8ff;font-size:14px;font-weight:600;}
    .irs-bar,.irs-single {background:#28d9b5 !important;border-color:#28d9b5 !important;}
    .btn-primary {background:#36c4ad;border:none;color:#0c1930;font-weight:800;
                  border-radius:13px;padding:12px 25px;}
    .btn-primary:hover {background:#b5ff7a;color:#11243a;}
    .nav-tabs {border-bottom:1px solid #2c4d70;}
    .nav-tabs>li>a {color:#b1dcf2;border:none;}
    .nav-tabs>li.active>a,.nav-tabs>li.active>a:hover {color:#09213c;
      background:#91eeff;border:0;border-radius:8px 8px 0 0;}
    table {color:#e8f9ff !important;font-size:15px;}
    table>tbody>tr>td, table>thead>tr>th {border-color:#264c72 !important;}
    .shiny-text-output,.shiny-html-output {color:#e4f7ff;}
    pre {background:#0b1b31;color:#d3ffec;border:1px solid #234567;border-radius:12px;
         font-size:14px;white-space:pre-wrap;}
    .selectize-input {background:#f5fcff;}
    strong {color:#c1ff88;}
    @media(max-width:990px) {.container-fluid{padding:14px}.brand h1{font-size:27px}}
  "))),
  div(class="brand",
      span(class="kicker","R · REGRESIÓN ROBUSTA · EMBEDDINGS · STS BENCHMARK"),
      h1("Laboratorio de pérdidas y lenguaje"),
      p("Observe cómo cambian LS, LAD y Huber cuando las etiquetas de entrenamiento reciben ruido simulado.")),

  fluidRow(
    column(3,
      div(class="pane",
        h3("Controles"),
        sliderInput("contaminacion","Etiquetas modificadas (%)",
                    min=0,max=25,value=10,step=1,post="%"),
        sliderInput("muestra","Pares para entrenar",
                    min=350,max=min(2500,nrow(datos$train)),value=900,step=50),
        sliderInput("semilla","Semilla pseudoaleatoria",
                    min=1,max=100,value=12,step=1),
        actionButton("actualizar","Actualizar modelos",class="btn-primary"),
        br(),br(),
        p(class="helptext",
          "Los datos proceden de STS Benchmark. Solo se alteran algunas etiquetas en una copia local de entrenamiento. Validación permanece intacta."),
        p(class="helptext",
          "Objetivo: observar consecuencias de la función de pérdida, no declarar que haya errores reales en STS.")
      ),
      div(class="pane",
          h3("Qué permanece fijo"),
          p(class="helptext","Los embeddings y las tres características numéricas son idénticos para cada método."),
          p(class="helptext","Se respeta la misma partición oficial de validación."),
          p(class="helptext","La métrica de comparación es común: MAE, RMSE y Spearman.")
      )
    ),
    column(9,
      div(class="pane",
        tabsetPanel(
          tabPanel("Comparación",
            br(),
            h3("Error fuera del conjunto de entrenamiento"),
            tableOutput("tabla"),
            plotOutput("barras",height="360px"),
            verbatimTextOutput("lectura")
          ),
          tabPanel("Predicciones",
            br(),
            h3("Predicción frente a similitud humana"),
            selectInput("modelo_plot","Método",choices=c("LS","LAD","Huber")),
            plotOutput("dispersion",height="450px"),
            p(class="helptext","Cada punto representa un par oficial. La diagonal indica predicción perfecta.")
          ),
          tabPanel("Casos reales",
            br(),
            h3("Inspección semántica"),
            numericInput("indice","Fila oficial de validación",value=1,min=1,
                         max=nrow(datos$valid),step=1),
            uiOutput("par"),
            tableOutput("pred_par"),
            p(class="helptext","Lea las oraciones antes de interpretar el error. No confunda discrepancia del modelo con error humano.")
          ),
          tabPanel("Interpretación",
            br(),h3("Coeficientes y pesos"),
            tableOutput("coeficientes"),
            verbatimTextOutput("interpretacion"),
            plotOutput("pesos",height="340px")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  # PASO 5. Reajustar únicamente cuando el estudiante pulsa el botón.
  experimento <- eventReactive(input$actualizar, {
    set.seed(input$semilla)
    idx <- sample.int(nrow(datos$train),size=min(input$muestra,nrow(datos$train)))
    subset <- datos$train[idx,,drop=FALSE]
    n_ruido <- round(nrow(subset)*input$contaminacion/100)
    filas <- if (n_ruido>0) sample.int(nrow(subset),size=n_ruido) else integer()

    # Invertir artificialmente puntajes de 0 a 1, solo en train.
    subset$score[filas] <- ifelse(subset$score[filas] >= 0.5,0,1)

    # PASO 6. Tres ajustes con fórmula común, igual que en el R Markdown.
    mods <- list(
      LS=lm(formula_modelo,data=subset),
      LAD=quantreg::rq(formula_modelo,tau=0.5,data=subset),
      Huber=MASS::rlm(formula_modelo,data=subset,
                       method="M",psi=MASS::psi.huber,maxit=200)
    )
    pp <- lapply(mods, function(mod) as.numeric(predict(mod,newdata=datos$valid)))
    tab <- do.call(rbind, lapply(names(pp),function(nm)
      calcular(datos$valid$score,pp[[nm]],nm)))
    list(mods=mods,preds=pp,tab=tab,contaminadas=length(filas),
         n=nrow(subset), ruido=subset)
  }, ignoreNULL=FALSE, ignoreInit=FALSE)

  # PASO 7. Tabla explícita, con números redondeados solo para presentación.
  output$tabla <- renderTable({
    z <- experimento()$tab
    z[,2:4] <- round(z[,2:4],4)
    z
  },rownames=FALSE)

  output$barras <- renderPlot({
    z <- experimento()$tab
    ggplot(z,aes(x=Modelo,y=MAE,fill=Modelo))+
      geom_col(width=.56,alpha=.93)+
      geom_text(aes(label=sprintf("%.3f",MAE)),vjust=-.5,
                colour="white",fontface="bold",size=5)+
      scale_fill_manual(values=paleta)+
      expand_limits(y=max(z$MAE)*1.18)+
      labs(x=NULL,y="MAE de validación",title="La misma tarea, tres funciones de pérdida")+
      theme_minimal(base_size=15)+
      theme(plot.background=element_rect(fill="#112743",colour=NA),
            panel.background=element_rect(fill="#112743",colour=NA),
            panel.grid=element_blank(),text=element_text(colour="#e7f7ff"),
            axis.text=element_text(colour="#ccefff"),
            legend.position="none")
  })

  output$lectura <- renderText({
    e <- experimento()
    z <- e$tab
    pos <- which.min(z$MAE)
    paste0(
      "Se ajustaron ",e$n," pares de entrenamiento; ",
      e$contaminadas," etiquetas fueron invertidas artificialmente.\n",
      "El menor MAE de validación es ",sprintf("%.4f",z$MAE[pos]),
      " y corresponde a ",z$Modelo[pos],".\n",
      "Eso representa ",sprintf("%.2f",5*z$MAE[pos]),
      " puntos de error absoluto promedio en la escala STS original [0,5].\n",
      "Este resultado describe la semilla y contaminación elegidas. Cambie los controles para comprobar su estabilidad."
    )
  })

  output$dispersion <- renderPlot({
    e <- experimento()
    df <- data.frame(real=datos$valid$score,
                     pred=e$preds[[input$modelo_plot]])
    ggplot(df,aes(real,pred))+
      geom_point(colour=paleta[[input$modelo_plot]],alpha=.28,size=1.7)+
      geom_abline(slope=1,intercept=0,linetype="dashed",
                  linewidth=1,colour="#ffcd75")+
      labs(title=paste("Validación:",input$modelo_plot),
           x="Similitud humana",y="Predicción del modelo")+
      theme_minimal(base_size=15)+
      theme(plot.background=element_rect(fill="#112743",colour=NA),
            panel.background=element_rect(fill="#112743",colour=NA),
            text=element_text(colour="#e7f7ff"),
            axis.text=element_text(colour="#ccefff"),
            panel.grid=element_line(colour="#254463"))
  })

  output$par <- renderUI({
    i <- min(max(1,as.integer(input$indice)),nrow(datos$valid))
    x <- datos$valid[i,]
    tagList(
      tags$p(tags$strong("Frase A: "),x$sentence1),
      tags$p(tags$strong("Frase B: "),x$sentence2),
      tags$p(tags$strong("Similitud humana: "),sprintf("%.3f",x$score))
    )
  })

  output$pred_par <- renderTable({
    i <- min(max(1,as.integer(input$indice)),nrow(datos$valid))
    e <- experimento()
    data.frame(
      Modelo=names(e$preds),
      Prediccion=vapply(e$preds,function(p) round(p[i],3),numeric(1)),
      Error_absoluto=vapply(e$preds,
        function(p) round(abs(p[i]-datos$valid$score[i]),3),numeric(1))
    )
  },rownames=FALSE)

  output$coeficientes <- renderTable({
    e <- experimento()
    cc <- lapply(e$mods,coef)
    z <- data.frame(Variable=names(cc[[1]]),
                    LS=cc$LS,LAD=cc$LAD,Huber=cc$Huber,
                    row.names=NULL)
    z[-1] <- lapply(z[-1],round,3)
    z
  },rownames=FALSE)

  output$interpretacion <- renderText({
    e <- experimento()
    b <- coef(e$mods$Huber)
    paste0(
      "Coeficiente Huber de coseno estandarizado: ",
      sprintf("%+.4f",b[["cos_glove_z"]]),".\n",
      "Interpretación: una desviación estándar adicional del coseno del embedding,\n",
      "manteniendo constantes Jaccard y diferencia de longitud, cambia el ajuste\n",
      "robusto de similitud en esa cantidad de puntos. No indica causalidad.\n",
      "Peso robusto menor que 0.8 en ",
      sprintf("%.1f",100*mean(e$mods$Huber$w<0.8)),
      "% de los casos usados para ajustar."
    )
  })

  output$pesos <- renderPlot({
    e <- experimento()
    d <- data.frame(residuo=abs(resid(e$mods$Huber)),
                    peso=e$mods$Huber$w)
    ggplot(d,aes(residuo,peso))+
      geom_point(colour="#25D8AC",alpha=.48)+
      coord_cartesian(ylim=c(0,1.03))+
      labs(title="Huber asigna menos peso a residuos grandes",
           x="|Residuo| de entrenamiento",y="Peso")+
      theme_minimal(base_size=15)+
      theme(plot.background=element_rect(fill="#112743",colour=NA),
            panel.background=element_rect(fill="#112743",colour=NA),
            text=element_text(colour="#e7f7ff"),
            axis.text=element_text(colour="#ccefff"),
            panel.grid=element_line(colour="#254463"))
  })
}

shinyApp(ui=ui,server=server)
