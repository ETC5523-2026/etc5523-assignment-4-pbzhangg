## code to prepare `state_geom` dataset goes here
library(sf)
library(tidyverse)

state_geom <- st_read("data-raw/STE_2021_AUST_SHP_GDA2020/STE_2021_AUST_GDA2020.shp") |>
  filter(STE_NAME21 != "Outside Australia") |>
  select(STE_CODE21, STE_NAME21, AREASQKM21, geometry)

usethis::use_data(state_geom, overwrite = TRUE)
