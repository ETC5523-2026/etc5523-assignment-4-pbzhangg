## code to prepare `covid_monthly` dataset goes here
monthly_raw <- read.csv(
  "data-raw/Deaths due to COVID-19 by year and month of occurrence.csv", 
  header = TRUE, 
  check.names = FALSE, 
  skip = 1, 
  nrow = 5
)

months <- month.abb

monthly_data <- monthly_raw |>
  dplyr::mutate(
    Jan = as.numeric(Jan),
    Feb = as.numeric(Feb),
    Mar = as.numeric(Mar),
    Apr = as.numeric(Apr),
    May = as.numeric(May),
    Jun = as.numeric(Jun),
    Jul = as.numeric(Jul),
    Aug = as.numeric(Aug),
    Sep = as.numeric(Sep),
    Oct = as.numeric(Oct),
    Nov = as.numeric(Nov),
    Dec = as.numeric(Dec)
  )


covid_monthly <- monthly_data |>
  dplyr::select(`Year of death`, all_of(months)) |>
  tidyr::pivot_longer(
    cols = all_of(months),
    names_to = "month",
    values_to = "deaths"
  ) |>
  dplyr::rename(year = `Year of death`) |>
  dplyr::filter(!is.na(deaths)) |>
  dplyr::mutate(
    month_number = match(month, month.abb),
    date = as.Date(sprintf("%d-%02d-01", year, month_number))
  ) |>
  dplyr::select(date, year, month, deaths) |>
  dplyr::arrange(date)

usethis::use_data(covid_monthly, overwrite = TRUE)
