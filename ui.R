

ui <-
  fluidPage(
    useShinyjs(),
    titlePanel("HyperGUI"),
    #a sidebar lay out,
    
    tags$style(
      type = "text/css",
      ".shiny-output-error { visibility: hidden; }",
      ".shiny-output-error:before { visibility: hidden; }"
    ),
    sidebarLayout(
      sidebar,
      #this is where the image is plotted
      mainPanel(
        radioGroupButtons(
          inputId = "clickerMode",
          label = "Select an area on  the image to:",
          choices = c("Crop", "Plot Signal"),
          status = "primary"
        ),
        actionButton("clearplots", "Clear"),
        
        plotOutput(outputId = "hyperPlot", brush ="plot_click"),
        plotOutput("specPlot")

      )
    )
  )