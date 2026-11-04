# Calculate the Distribution of COVID-19 Deaths

Calculates the percentage share of COVID-19 deaths for each state or
SEIFA quintile in a selected year. The percentage share is calculated by
dividing each group's death count by the total across all groups in the
selected year.

## Usage

``` r
calculate_death_share(data = covid_state, selected_year)
```

## Arguments

- data:

  A data frame containing a grouping variable, year and deaths. Can be
  either `covid_state` or `covid_seifa`.

- selected_year:

  The year for which death shares are calculated.

## Value

A data frame containing the group, number of deaths, total deaths and
percentage share.

## Examples

``` r
# Calculate death shares across states for 2022
calculate_death_share(data = covid_state, selected_year = 2022)
#> # A tibble: 8 × 5
#>   group deaths total_deaths death_share group_type
#>   <chr>  <dbl>        <dbl>       <dbl> <chr>     
#> 1 NSW     3733        10301      36.2   state     
#> 2 Vic     2986        10301      29.0   state     
#> 3 Qld     1691        10301      16.4   state     
#> 4 SA       845        10301       8.20  state     
#> 5 WA       639        10301       6.20  state     
#> 6 Tas      200        10301       1.94  state     
#> 7 ACT      155        10301       1.50  state     
#> 8 NT        52        10301       0.505 state     

# Calculate death shares across SEIFA quintiles for 2022
calculate_death_share(data = covid_seifa, selected_year = 2022)
#> # A tibble: 5 × 5
#>   group                   deaths total_deaths death_share group_type    
#>   <fct>                    <dbl>        <dbl>       <dbl> <chr>         
#> 1 1 (most disadvantaged)    3156        10246        30.8 SEIFA Quintile
#> 2 2                         2431        10246        23.7 SEIFA Quintile
#> 3 3                         1911        10246        18.7 SEIFA Quintile
#> 4 4                         1602        10246        15.6 SEIFA Quintile
#> 5 5 (least disadvantaged)   1146        10246        11.2 SEIFA Quintile
```
