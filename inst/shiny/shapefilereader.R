shapefilereader <- function(shapefile,rasterfile){
  rastermap <- rast(rasterfile)
  shapefilemap<-vect(shapefile)
  ext<-extract(rastermap, shapefilemap)
  ext
}