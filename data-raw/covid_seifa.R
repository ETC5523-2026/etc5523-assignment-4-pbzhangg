## code to prepare `covid_seifa` dataset goes here
library(tidyverse)

seifa_raw <- read.csv(
  "data-raw/Deaths due to COVID-19_ socio-economic status (SEIFA).csv", 
  skip = 1, header = TRUE, check.names = FALSE, nrows = 5
)

seifa <- seifa_raw |>
  drop_na() |>
  mutate(
    `2020` = as.numeric(gsub(",", "", `2020`)),
    `2021` = as.numeric(gsub(",", "", `2021`)),
    `2022` = as.numeric(gsub(",", "", `2022`)),
    `2023` = as.numeric(gsub(",", "", `2023`)),
    `2024` = as.numeric(gsub(",", "", `2024`))) |>
  select(-Total)

covid_seifa <- seifa |>
   pivot_longer(
    cols = `2020`:`2024`,
    names_to = "year",
    values_to = "deaths"
  ) |>
  mutate(year = as.integer(year),
        `SEIFA Quintile` = factor(
          `SEIFA Quintile`,
          levels = c("1 (most disadvantaged)", "2", "3", "4", "5 (least disadvantaged)")
        ))

usethis::use_data(covid_seifa, overwrite = TRUE)
