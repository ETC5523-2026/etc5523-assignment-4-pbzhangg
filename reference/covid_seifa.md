# COVID-19 Deaths by Socioeconomic Disadvantage

Registered COVID-19 death counts by socioeconomic disadvantage quintile
in Australia from 2020 to 2024.

## Usage

``` r
data(covid_seifa)
```

## Format

A data fram with 25 rows and 3 variables:

- SEIFA Quintile:

  Socioeconomic disadvantage quintile, from most to least disadvantaged.

- year:

  Year of death registration.

- deaths:

  Number of registered COVID-19 deaths.

## Source

Australia Bureau of Statistics (ABS).

## Examples

``` r
data(covid_seifa)
head(covid_seifa)
#> # A tibble: 6 × 3
#>   `SEIFA Quintile`        year deaths
#>   <fct>                  <int>  <dbl>
#> 1 1 (most disadvantaged)  2020    289
#> 2 1 (most disadvantaged)  2021    580
#> 3 1 (most disadvantaged)  2022   3156
#> 4 1 (most disadvantaged)  2023   1272
#> 5 1 (most disadvantaged)  2024     64
#> 6 2                       2020    239
```
