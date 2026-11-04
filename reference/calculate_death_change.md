# Calculate Changes in COVID-19 deaths in Australia Between Two Years

Calculates the absolute and percentage changes in the number of
registered COVID-19 deaths between two specified years grouped by state
or SEIFA quintile. The percentage change is calculated relative to the
number of deaths in the starting year.

## Usage

``` r
calculate_death_change(data = covid_state, year_from, year_to)
```

## Arguments

- data:

  A data frame containing a grouping variable, `year`, and `deaths`. Can
  be either `covid_state` or `covid_seifa`.

- year_from:

  An integer specifying the starting year of the comparison.

- year_to:

  An integer specifying the ending year of the comparison.

## Value

A data frame containing the group, number of deaths in each specified
year, absolute change in deaths, and percentage change in deaths.
Results are arranged in descending order of absolute change. Percentage
change is returned as `NA` when the starting number of deaths is zero.

## Examples

``` r
# Compare COVID-19 deaths between 2020 and 2022 across states
calculate_death_change(data = covid_state, year_from = 2020, year_to = 2022)
#> # A tibble: 8 × 6
#>   group deaths_from deaths_to absolute_change percent_change group_type
#>   <chr>       <dbl>     <dbl>           <dbl>          <dbl> <chr>     
#> 1 NSW            63      3733            3670          5825. state     
#> 2 Vic           805      2986            2181           271. state     
#> 3 Qld             4      1691            1687         42175  state     
#> 4 SA              4       845             841         21025  state     
#> 5 WA             11       639             628          5709. state     
#> 6 Tas            17       200             183          1076. state     
#> 7 ACT             2       155             153          7650  state     
#> 8 NT              0        52              52            NA  state     

# Compare COVID-19 deaths between 2020 and 2022 across SEIFA quintiles
calculate_death_change(data = covid_seifa, year_from = 2020, year_to = 2022)
#> # A tibble: 5 × 6
#>   group          deaths_from deaths_to absolute_change percent_change group_type
#>   <fct>                <dbl>     <dbl>           <dbl>          <dbl> <chr>     
#> 1 1 (most disad…         289      3156            2867           992. SEIFA Qui…
#> 2 2                      239      2431            2192           917. SEIFA Qui…
#> 3 3                      128      1911            1783          1393. SEIFA Qui…
#> 4 4                      106      1602            1496          1411. SEIFA Qui…
#> 5 5 (least disa…         140      1146            1006           719. SEIFA Qui…
```
