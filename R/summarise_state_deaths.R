#' Summarise COVID-19 deaths by state or territory in Australia
#' 
#' Calculates the total number of registered COVID-19 deaths 
#' for each Australian state and territory across one or more 
#' specified years. If no years are provided, deaths are summarised 
#' across the entire available period (2020-2024).
#' 
#' @param data A data frame containing `state`, `year`, and `deaths`.
#' Defaults to the included `covid_state` dataset.
#' @param years An integer vector specifiying the years to include in 
#' the summary. Defaults to `NULL`, which includes all available years.
#' @return A data frame containing each state or territory and its 
#' corresponding total number of COVID-19 deaths for the specified 
#' years, arranged in descending order of deaths. 
#' 
#' @examples
#' # Summarise deaths in 2020
#' summarise_state_deaths(years = 2020)
#' 
#' # Summarise deaths across 2020 and 2021
#' summarise_state_deaths(years = c(2020, 2021))
#' 
#' # Summarise deaths across all available years
#' summarise_state_deaths()
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