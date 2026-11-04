# Summarise COVID-19 deaths by state or territory in Australia

Calculates the total number of registered COVID-19 deaths for each
Australian state and territory across one or more specified years. If no
years are provided, deaths are summarised across the entire available
period (2020-2024).

## Usage

``` r
summarise_state_deaths(data = covid_state, years = NULL)
```

## Arguments

- data:

  A data frame containing `state`, `year`, and `deaths`. Defaults to the
  included `covid_state` dataset.

- years:

  An integer vector specifying the years to include in the summary.
  Defaults to `NULL`, which includes all available years.

## Value

A data frame containing each state or territory and its corresponding
total number of COVID-19 deaths for the specified years, arranged in
descending order of deaths.

## Examples

``` r
# Summarise deaths in 2020
summarise_state_deaths(years = 2020)
#> # A tibble: 8 × 2
#>   state deaths
#>   <chr>  <dbl>
#> 1 Vic      805
#> 2 NSW       63
#> 3 Tas       17
#> 4 WA        11
#> 5 Qld        4
#> 6 SA         4
#> 7 ACT        2
#> 8 NT         0

# Summarise deaths across 2020 and 2021
summarise_state_deaths(years = c(2020, 2021))
#> # A tibble: 8 × 2
#>   state deaths
#>   <chr>  <dbl>
#> 1 Vic     1511
#> 2 NSW      693
#> 3 Tas       17
#> 4 ACT       14
#> 5 WA        11
#> 6 Qld        7
#> 7 SA         7
#> 8 NT         1

# Summarise deaths across all available years
summarise_state_deaths()
#> # A tibble: 8 × 2
#>   state deaths
#>   <chr>  <dbl>
#> 1 NSW     6069
#> 2 Vic     5735
#> 3 Qld     2488
#> 4 SA      1232
#> 5 WA      1110
#> 6 Tas      340
#> 7 ACT      233
#> 8 NT        69
```
