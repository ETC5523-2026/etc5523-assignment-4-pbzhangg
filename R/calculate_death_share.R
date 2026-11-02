
#' Calculate the Distribution of COVID-19 Deaths
#'
#' Calculates the percentage share of COVID-19 deaths for each
#' state or SEIFA quintile in a selected year. The percentage 
#' share is calculated by dividing each group's death count 
#' by the total across all groups in the selected year.
#'
#' @param data A data frame containing a grouping variable, year and deaths.
#'   Can be either `covid_state` or `covid_seifa`.
#' @param selected_year The year for which death shares are calculated.
#' @return A data frame containing the group, number of deaths,
#'   total deaths and percentage share.
#'
#' @examples
#' # Calculate death shares across states for 2022
#' calculate_death_share(data = covid_state, selected_year = 2022)
#'
#' # Calculate death shares across SEIFA quintiles for 2022
#' calculate_death_share(data = covid_seifa, selected_year = 2022)
#'
#' @importFrom dplyr filter mutate if_else select arrange desc
#' @export
calculate_death_share <- function(data = covid_state, selected_year) {

  # Check that data is a data frame
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame.", call. = FALSE)
  }

  # Check required columns
  required_cols <- c("year", "deaths")

  if (!all(required_cols %in% names(data))) {
    stop(
      "`data` must contain 'year' and 'deaths' columns.",
      call. = FALSE
    )
  }

  # Identify the grouping variable
  group_vars <- intersect(c("state", "SEIFA Quintile"), names(data))

  if (length(group_vars) != 1) {
    stop(
      "`data` must contain exactly one grouping variable: 'state' or 'SEIFA Quintile'.",
      call. = FALSE
    )
  }

  group_var <- group_vars[1]

  # Validate selected year
  if (!is.numeric(selected_year) || length(selected_year) != 1 ||
    is.na(selected_year) || !is.finite(selected_year) ||
    selected_year != as.integer(selected_year)
  ) {
    stop("`selected_year` must be a single valid year.", call. = FALSE)
  }

  # Filter selected year
  year_data <- data |>
    filter(year == selected_year)

  if (nrow(year_data) == 0) {
    stop("The selected year is not present in `data`.", call. = FALSE)
  }

  # Calculate percentage shares
  year_data |>
    mutate(
      group = .data[[group_var]],
      total_deaths = sum(deaths, na.rm = TRUE),
      death_share = if_else(total_deaths == 0, NA_real_, (deaths / total_deaths) * 100),
      group_type = group_var
    ) |>
    select(group, deaths, total_deaths, death_share, group_type) |>
    arrange(desc(death_share))
}