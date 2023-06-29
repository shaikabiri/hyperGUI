####sidebar object in the main tab####
sidebar <- sidebarPanel(
  fileInput(
    "file1",
    "Select the hyperspectral image file:",
    multiple = TRUE,
    accept = c(".sif", ".hdr", "..hdr",".dat")
  ),
  tags$hr(),
  selectInput(inputId = "saveformat",
              label = "Choose a format to save dataset:",
              choices = c("Matlab" = "mat", "R" = "r"),selected = "mat"),
  downloadButton(outputId = "save", "Save As"),
  
  tags$hr(),
  selectInput("displaysel","Display Type:",choices = c("False Pseudocolor" = "fp", "False RGB for select wavelenghts" = "rgb", "False RGB for first three PCA components" = "pca")),
  tags$hr(),
  textOutput("info"),
  fppan,
  rgbpan,
  tags$hr(),
  tags$h5('Hint: To start processing, load a raw hyperspectral image alongside its header file in .hdr format')
  
)
