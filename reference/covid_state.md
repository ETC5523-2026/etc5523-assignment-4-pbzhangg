# COVID-19 Deaths by Australian State and Territory

Registered COVID-19 death counts by Australian state and territory from
2020 to 2024, including the national total.

## Usage

``` r
data(covid_state)
```

## Format

A data fram with 45 rows and 3 variables:

- state:

  Australian state or territory abbreviation, or Aus for the national
  total.

- year:

  Year of death registration.

- deaths:

  Number of registered COVID-19 deaths.

## Source

Australia Bureau of Statistics (ABS).

## Examples

``` r
data(covid_state)
head(covid_state)
#> # A tibble: 6 × 3
#>   state  year deaths
#>   <chr> <int>  <dbl>
#> 1 NSW    2020     63
#> 2 NSW    2021    630
#> 3 NSW    2022   3733
#> 4 NSW    2023   1567
#> 5 NSW    2024     76
#> 6 Vic    2020    805
```
