#' Summarise COVID-19 deaths by state for selected year(s)
#' 
#' @param data A data frame containing `state`, `year`, and `deaths`.
#' @param years Years to include, where NULL includes all years.
#' @return A data frame of all deaths by state for the included year(s).
#' @importFrom dplyr filter group_by summarise arrange
#' @export
summarise_state_deaths <- function(data = covid_state, years = NULL) {
  if (!is.null(years)) {
    data <- data |>
      filter(.data$year %in% years)
  }
  data |>
    group_by(.data$state) |>
    summarise(
      deaths = sum(.data$deaths, na.rm = TRUE),
      .groups = "drop"
    ) |>
    arrange(desc(.data$deaths))
}