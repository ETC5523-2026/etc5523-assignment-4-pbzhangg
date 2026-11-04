# Monthly COVID-19 Deaths in Australia

Monthly counts of deaths due to COVID-19 in Australia from January 2020
to January 2024, based on month of death occurrence.

## Usage

``` r
covid_monthly
```

## Format

A data frame with 49 observations and 4 variables:

- date:

  Date representing the first day of each month.

- year:

  Year of death occurrence.

- month:

  Three-letter abbreviation of the month.

- deaths:

  Number of deaths due to COVID-19.

## Source

Australian Bureau of Statistics (ABS)

## Examples

``` r
head(covid_monthly)
#> # A tibble: 6 × 4
#>   date        year month deaths
#>   <date>     <int> <chr>  <dbl>
#> 1 2020-01-01  2020 Jan        0
#> 2 2020-02-01  2020 Feb        0
#> 3 2020-03-01  2020 Mar       23
#> 4 2020-04-01  2020 Apr       79
#> 5 2020-05-01  2020 May       12
#> 6 2020-06-01  2020 Jun        3
```
