#' COVID-19 Deaths by Socioeconomic Disadvantage
#' 
#' Registered COVID-19 death counts by socioeconomic disadvantage 
#' quintile in Australia from 2020 to 2024.
#' 
#' @format A data fram with 25 rows and 3 variables:
#' \describe{
#' \item{SEIFA Quintile}{Socioeconomic disadvantage quintile, from most to least disadvantaged.}
#' \item{year}{Year of death registration.}
#' \item{deaths}{Number of registered COVID-19 deaths.}
#' }
#' 
#' @source Australia Bureau of Statistics (ABS).
#' @usage data(covid_seifa)
#' 
#' @examples
#' data(covid_seifa)
#' head(covid_seifa)
"covid_seifa"
