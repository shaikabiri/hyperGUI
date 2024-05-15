####This function parses the path list taken by browser
parsed_path <- function(pathlist) {
  #this is the list of ordered paths
  parsed.paths <- list()
  
  #check which path is header and put them in right order
  if (grepl("hdr", pathlist$datapath[2], fixed = TRUE)) {
    parsed.paths[2] <-  pathlist$datapath[2]
    parsed.paths[1] <-  pathlist$datapath[1]
  } else {
    parsed.paths[2] <-  pathlist$datapath[1]
    parsed.paths[1] <-  pathlist$datapath[2]
  }
  
  #return paths
  return(parsed.paths)
}
