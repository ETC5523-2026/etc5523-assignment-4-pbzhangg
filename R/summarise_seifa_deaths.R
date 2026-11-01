#' Summarise COVID-19 deaths by SEIFA Quintile in Australia
#' 
#' Calculates the total number of registered COVID-19 deaths 
#' for each SEIFA Quintile across one or more specified years. 
#' If no years are provided, deaths are summarised across the 
#' entire available period (2020-2024).
#' 
#' @param data A data frame containing `SEIFA Quintile`, `year`, and `deaths`.
#' Defaults to the included `covid_seifa` dataset.
#' @param years An integer vector specifying the years to include in 
#' the summary. Defaults to `NULL`, which includes all available years.
#' @return A data frame containing each SEIFA Quintile and its 
#' corresponding total number of COVID-19 deaths for the specified 
#' years, arranged in descending order of deaths. 
#' 
#' @examples
#' # Summarise deaths in 2020
#' summarise_seifa_deaths(years = 2020)
#' 
#' # Summarise deaths across 2020 and 2021
#' summarise_seifa_deaths(years = c(2020, 2021))
#' 
#' # Summarise deaths across all available years
#' summarise_seifa_deaths()
#' 
#' @importFrom dplyr filter group_by summarise arrange desc
#' @export

summarise_seifa_deaths <- function(data = covid_seifa, years = NULL) {
  # Input Validation
  ## Check required columns exist
  required_columns <- c("SEIFA Quintile", "year", "deaths")
  if (!all(required_columns %in% names(data))) {
    stop("Data must contain `SEIFA Quintile`, `year` and `deaths` columns.", call. = FALSE)
  }

  ## Check that inputted year(s) are integer(s)
  if (!is.null(years) || anyNA(years) ||
    any(!is.finite(years)) || any(years != floor(years))) {
    stop("years must be a vector of valid integer(s).", call. = FALSE)
  }

  ## Check that inputted years exist in the dataset
  if (!all(years %in% data$year)) {
    stop("One or more requested years are not available in the dataset.", call. = FALSE)
  }

  # Summarise Function
  ## If years is not null, filter data for the specified years
  if (!is.null(years)) {
    data <- data |>
      filter(.data$year %in% years)
  }
  ## Summarise and return the sum death counts for the specified years for each SEIFA quintile
  data |>
    group_by(.data$`SEIFA Quintile`) |>
    summarise(
      deaths = sum(.data$deaths, na.rm = TRUE),
      .groups = "drop"
    ) |>
    arrange(desc(.data$deaths))
}