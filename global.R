######PACKAGES##################################################################
source("packages.R")
library("ggplot2")
library("shiny")
library("shinyFiles")
library("shinyjs")
library("raster")
library("stringr")
library("readr")
library("abind")
library("shinyWidgets")
library("hyperSpec")
library("shinybusy")
library("imager")
library("reticulate")
library("terra")
library("caTools")
library("reticulate")

################################################################################
######SHINY_CONFIG##############################################################
#Change the maximum size to upload files
options(shiny.maxRequestSize = 30000 * 1024 ^ 2)


######FUNCTIONS#################################################################
source("parsed_path.R",)
source("header_reader.R")
################################################################################
################################################################################

######SHINY_OBJECTS#############################################################
source("ffpan.R",local = TRUE)
source("rgbpan.R",local = TRUE)
source("sidebar.R",local = TRUE)
####

######UI########################################################################

source("ui.R",local = TRUE)

################################################################################


#######SERVER###################################################################
source("server.R")

# 

################################################################################
