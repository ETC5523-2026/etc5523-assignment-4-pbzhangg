#' COVID-19 Deaths by Australian State and Territory
#' 
#' Registered COVID-19 death counts by Australian state and 
#' territory from 2020 to 2024, including the national total.
#' 
#' @format A data fram with 45 rows and 3 variables:
#' \describe{
#' \item{state}{Australian state or territory abbreviation, or Aus for the national total.}
#' \item{year}{Year of death registration.}
#' \item{deaths}{Number of registered COVID-19 deaths.}
#' }
#' 
#' @source Australia Bureau of Statistics (ABS).
#' @usage data(covid_state)
#' 
#' @examples
#' data(covid_state)
#' head(covid_state)
"covid_state"