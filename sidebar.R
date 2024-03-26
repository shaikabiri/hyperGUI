####sidebar object in the main tab####
sidebar <- sidebarPanel(
  selectInput("hypeType", "Select type of hyperspectral image:", c("Labratory" = "lab", "Aerial" = "aer"), selected = "lab", multiple = FALSE, selectize = TRUE),

  fileInput(
    "file1",
    "Select the hyperspectral image files:",
    multiple = TRUE,

  ),
  fileInput(
    "shapeRefFile",
    "Select shapefiles for ground reference:",
    multiple = TRUE
  ),
  fileInput(
    "hyperRefFile",
    "Select hyperspctral images for ground reference:",
    multiple = TRUE,

  ),
  fileInput(
    "file2",
    "Select the dark current image files:",
    multiple = TRUE,

  ),
  fileInput(
    "file3",
    "Select the white current image files:",
    multiple = TRUE,

  ),
  tags$hr(),
  actionButton("LC",label = "Perform linear calibration"),
  actionButton("DWC",label = "Perform dark/white current calibration"),
  tags$hr(),
  tags$hr(),
  actionButton("DOS",label = "Perform dark pixel subtraction"),
  tags$hr(),
  actionButton("Scale1",label = "Perform scaling in each hyperplane"),
  tags$hr(),
  actionButton("Scale2",label = "Perform scaling along hyperplanes"),
  tags$hr(),
  selectInput(inputId = "saveformat",
              label = "Choose a format to save dataset:",
              choices = c("Matlab" = "mat", "R" = "r", "Python Numpy" = "numpy"),selected = "mat"),
  downloadButton(outputId = "save", "Save"),
  tags$br(),
  tags$br(),
  tags$b("Save the wavelengths as CSV table:"),
  tags$br(),
  downloadButton(outputId = "savewave", "Save"),  
  tags$hr(),
  selectInput("displaysel","Display Type:",choices = c("Monochromatic" = "fp", "Pseudo-RGB for select wavelenghts" = "rgb", "Pseudo-RGB for first three PCA components" = "pca")),
  sliderTextInput(
    inputId = "pcaslider", label = 'Wavelength range for PCA:', 
    choices = c("","Load a file",""), 
    selected = c("",""),
    grid = TRUE
  ),
 
  actionButton("calcPCA",label = "Calculate PCA"),
  actionButton("PCAplot", "Plot PCA variance explaination by component"),
  tags$br(),
  tags$br(),
  textInput("varPCA", "Enter the %Var explainable by reduced PCA data to save it as CSV: ", value = "0.95"),
  downloadButton(outputId = "pcasave", "Save"),
  textOutput("pcainfo"),
  tags$hr(),
  textOutput("info"),
  fppan,
  rgbpan,
  actionButton("renderBtn","Render"),
  tags$hr(),
  tags$h5('Hint: To start processing, load a raw hyperspectral image alongside its header file in .hdr format. 
          Dark current and white current images in case of benchtop image, and ground reference ROI shapefiles and spectral image and headers
          can be loaded to calibrate for surface reflectance.')
  
)
