# NOT RUN {
if (interactive()) {
  library("shiny")
  library("shinyWidgets")
  
  ui <- fluidPage(
    br(),
    sliderTextInput(
      inputId = "mySlider",
      label = "Pick a month :",
      choices = month.abb,
      selected = "Jan"
    ),
    verbatimTextOutput(outputId = "res"),
    radioButtons(
      inputId = "up",
      label = "Update choices:",
      choices = c("Abbreviations", "Full names")
    )
  )
  
  server <- function(input, output, session) {
    output$res <- renderPrint(str(input$mySlider))
    
    observeEvent(input$up, {
      choices <- switch(
        input$up,
        "Abbreviations" = month.abb,
        "Full names" = month.name
      )
      updateSliderTextInput(
        session = session,
        inputId = "mySlider",
        choices = choices
      )
    }, ignoreInit = TRUE)
  }
  
  shinyApp(ui = ui, server = server)
}

