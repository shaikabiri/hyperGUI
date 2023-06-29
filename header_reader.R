####This function takes the header text file and parse it
header_reader <- function(header.txt){
  #list of the header attributes parsed
  hdr.parsed <- list(header.txt)
  #take the width of the image
  
  hdr.parsed$width <- as.numeric(gsub("\\D", "", header.txt[stringr::str_detect(header.txt,"sample")]))
  #take the height of the image
  hdr.parsed$height <- as.numeric(gsub("\\D", "", header.txt[stringr::str_detect(header.txt,"lines")]))
  #take the wavelengths in the image
  header.txt <- paste(header.txt, collapse =  " ")
  hdr.parsed$wavelength <- as.numeric(unlist(str_extract_all(str_extract(header.txt,"avelength\\s*(.*?)\\s*\\}"),"\\d+\\.?\\d*")))

  hdr.parsed
}
