#' Summarise COVID-19 deaths by SEIFA for selected year(s)
#' 
#' @param data A data frame containing `SEIFA Quintile`, `year`, and `deaths`.
#' @param years Years to include, where NULL includes all years.
#' @return A data frame of all deaths by SEIFA quintile for the included year(s).
#' @importFrom dplyr filter group_by summarise arrange
#' @export
summarise_seifa_deaths <- function(data = covid_seifa, years = NULL) {
  if (!is.null(years)) {
    data <- data |>
      filter(.data$year %in% years)
  }
  data |>
    group_by(.data$`SEIFA Quintile`) |>
    summarise(
      deaths = sum(.data$deaths, na.rm = TRUE),
      .groups = "drop"
    ) |>
    arrange(desc(.data$deaths))
}