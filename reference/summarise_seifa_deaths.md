# Summarise COVID-19 deaths by SEIFA Quintile in Australia

Calculates the total number of registered COVID-19 deaths for each SEIFA
Quintile across one or more specified years. If no years are provided,
deaths are summarised across the entire available period (2020-2024).

## Usage

``` r
summarise_seifa_deaths(data = covid_seifa, years = NULL)
```

## Arguments

- data:

  A data frame containing `SEIFA Quintile`, `year`, and `deaths`.
  Defaults to the included `covid_seifa` dataset.

- years:

  An integer vector specifying the years to include in the summary.
  Defaults to `NULL`, which includes all available years.

## Value

A data frame containing each SEIFA Quintile and its corresponding total
number of COVID-19 deaths for the specified years, arranged in
descending order of deaths.

## Examples

``` r
# Summarise deaths in 2020
summarise_seifa_deaths(years = 2020)
#> # A tibble: 5 × 2
#>   `SEIFA Quintile`        deaths
#>   <fct>                    <dbl>
#> 1 1 (most disadvantaged)     289
#> 2 2                          239
#> 3 5 (least disadvantaged)    140
#> 4 3                          128
#> 5 4                          106

# Summarise deaths across 2020 and 2021
summarise_seifa_deaths(years = c(2020, 2021))
#> # A tibble: 5 × 2
#>   `SEIFA Quintile`        deaths
#>   <fct>                    <dbl>
#> 1 1 (most disadvantaged)     869
#> 2 2                          546
#> 3 3                          336
#> 4 4                          266
#> 5 5 (least disadvantaged)    236

# Summarise deaths across all available years
summarise_seifa_deaths()
#> # A tibble: 5 × 2
#>   `SEIFA Quintile`        deaths
#>   <fct>                    <dbl>
#> 1 1 (most disadvantaged)    5361
#> 2 2                         4131
#> 3 3                         3145
#> 4 4                         2569
#> 5 5 (least disadvantaged)   1921
```
