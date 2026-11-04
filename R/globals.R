# Column names used through dplyr's datat-masking interface.
utils::globalVariables(c(
  "covid_state", "year", "all_of", "deaths", 
  "absolute_change", "total_deaths", "group", "death_share",
  "group_type", "covid_seifa", "SEIFA Quintile", "state", ".data")
)