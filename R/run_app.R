#' Start the HyperGUI web app
#'
#' @examples
#' run_app()
#' @export

run_app <- function() {
  shiny::runApp(paste(path.package('hyperGUI'),'/shiny',sep = ''))
}
