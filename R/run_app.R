#' Launch the covidmortality Shiny application
#'
#' @return Launches the Shiny application.
#' @export
run_app <- function() {
  app_dir <- system.file("app", package = "covidmortality")
  shiny::runApp(app_dir)
}