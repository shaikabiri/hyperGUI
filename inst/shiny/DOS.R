DOS <- function(data){
  darkMat <- apply(data,3,min)
  corrected.Data <- sweep(data , 3, darkMat)
  corrected.Data
}
