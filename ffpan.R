
####menu for false pseudo color panel
fppan <- wellPanel(id="dispoptfp",
                   tags$h6("Wavelength: ",),
                   actionButton("up", label = "↑",class="wave"),
                   textOutput("current", ),
                   actionButton("down", label = "↓",class="wave"),
                   sliderTextInput(
                     inputId = "slider", label = '', 
                     choices = "Load a file", 
                     grid = TRUE
                   )
                   # sliderInput(
                   #   "slider",
                   #   'Spectra',
                   #   min = 1,
                   #   max = 100,
                   #   value = 50
                   # ))
)