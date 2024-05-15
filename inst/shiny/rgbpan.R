####menu for pseudo rgb panel
rgbpan <- wellPanel(
  id = "dispoptrgb",
  tags$h6("Spectra to use for pseudo-RGB: ", ),
  sliderTextInput(
    inputId = "chan1",
    label = 'Red',
    choices = "Load a file",
    grid = TRUE
  ),
  
  sliderTextInput(
    inputId = "chan2",
    label = 'Blue',
    choices = "Load a file",
    grid = TRUE
  ),
  
  sliderTextInput(
    inputId = "chan3",
    label = 'Green',
    choices = "Load a file",
    grid = TRUE
  )
  
)
