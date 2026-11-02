#' Calculate Changes in COVID-19 deaths in Australia Between Two Years
#' 
#' Calculates the absolute and percentage changes in the number of 
#' registered COVID-19 deaths between two specified years grouped 
#' by state or SEIFA quintile. The percentage change is calculated 
#' relative to the number of deaths in the starting year.
#' 
#' @param data A data frame containing a grouping variable, `year`, and `deaths`.
#' Can be either `covid_state` or `covid_seifa`.
#' @param year_from An integer specifying the starting year of the comparison.
#' @param year_to An integer specifying the ending year of the comparison.
#' @return A data frame containing the group, number of deaths 
#' in each specified year, absolute change in deaths, and percentage change in 
#' deaths. Results are arranged in descending order of absolute change. Percentage 
#' change is returned as `NA` when the starting number of deaths is zero.
#' 
#' @examples
#' # Compare COVID-19 deaths between 2020 and 2022 across states
#' calculate_death_change(data = covid_state, year_from = 2020, year_to = 2022)
#' 
#' # Compare COVID-19 deaths between 2020 and 2022 across SEIFA quintiles
#' calculate_death_change(data = covid_seifa, year_from = 2020, year_to = 2022)
#' 
#' @importFrom dplyr filter arrange desc select rename left_join mutate if_else
#' @export

calculate_death_change <- function(data = covid_state, year_from, year_to) {
  # Input Validation
  ## Check required columns exist
  required_columns <- c("year", "deaths")
  if (!all(required_columns %in% names(data))) {
    stop(
      "`data` must contain `year` and `deaths` columns.",
      call. = FALSE
    )
  }

  ## Check each year has been inputted as a single numeric value
  if (!is.numeric(year_from) || length(year_from) != 1 ||
    is.na(year_from) || !is.finite(year_from) || 
    year_from != floor(year_from)) {
    stop(
      "year_from must be a single valid integer.", 
      call. = FALSE)
  }

  if (!is.numeric(year_to) || length(year_to) != 1 ||
    is.na(year_to) || !is.finite(year_to) || 
    year_to != floor(year_to)) {
    stop(
      "year_to must be a single valid integer.", 
      call. = FALSE)
  }

  ## Check that specified starting year precedes specified ending year
  if (year_from >= year_to) {
    stop(
      "year_from must be earlier than year_to.",
      call. = FALSE
    )
  }

  ## Check that both years exist in the dataset
  if (!(year_from %in% unique(data$year))) {
    stop(
      "year_from is not available in the dataset.", 
      call. = FALSE)
  }

  if (!(year_to %in% unique(data$year))) {
    stop(
      "year_to is not available in the dataset.", 
      call. = FALSE)
  }

  # Identify the grouping variable
  group_vars <- intersect(
    c("state", "SEIFA Quintile"),
    names(data)
  )

  if (length(group_vars) != 1) {
    stop(
      "`data` must contain exactly one grouping variable: ",
      "'state' or 'SEIFA Quintile'.",
      call. = FALSE
    )
  }
  group_var <- group_vars[1]

  # Function Calculation
  ## Extract deaths for specified starting year
  deaths_from <- data |>
    filter(year == year_from) |>
    select(group = all_of(group_var), deaths_from = deaths)

  ## Extract deaths for specified starting year
  deaths_to <- data |>
    filter(year == year_to) |>
    select(group = all_of(group_var), deaths_to = deaths)

  ## Calculate and return absolute and percentage changes
  deaths_from |>
    left_join(deaths_to, by = "group") |>
    mutate(
      absolute_change = deaths_to - deaths_from,
      percent_change = if_else(
        deaths_from == 0, 
        NA_real_, 
        (absolute_change / deaths_from) * 100
      ),
      group_type = group_var
    ) |>
      arrange(desc(absolute_change))
}