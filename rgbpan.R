####menu for pseudo rgb panel
rgbpan <- wellPanel(
  id = "dispoptrgb",
  tags$h6("Spectra to use for pseudo-RGB: ", ),
  sliderTextInput(
    inputId = "chan1",
    label = 'Spectra',
    choices = "Load a file",
    grid = TRUE
  ),
  
  sliderTextInput(
    inputId = "chan2",
    label = 'Spectra',
    choices = "Load a file",
    grid = TRUE
  ),
  
  sliderTextInput(
    inputId = "chan3",
    label = 'Spectra',
    choices = "Load a file",
    grid = TRUE
  )
  
)
