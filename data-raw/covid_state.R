## code to prepare `covid_state` dataset goes here
library(tidyverse)

states_raw <- read.csv(
  "data-raw/COVID-19 deaths by state of registration, 2020-24.csv", 
  skip = 1, header = TRUE, check.names = FALSE, nrows = 10
)

names(states_raw)[1] <- "state"
states <- states_raw |>
  drop_na() |>
  mutate(
    `2020` = as.numeric(gsub(",", "", `2020`)),
    `2021` = as.numeric(gsub(",", "", `2021`)),
    `2022` = as.numeric(gsub(",", "", `2022`)),
    `2023` = as.numeric(gsub(",", "", `2023`)),
    `2024` = as.numeric(gsub(",", "", `2024`))) |>
  select(-Total)

covid_state <- states |>
   pivot_longer(
    cols = `2020`:`2024`,
    names_to = "year",
    values_to = "deaths"
  ) |>
  mutate(year = as.integer(year))

usethis::use_data(covid_state, overwrite = TRUE)