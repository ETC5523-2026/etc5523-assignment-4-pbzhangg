library(shiny)

ui <- navbarPage(
  title = "COVID-19 Mortality in Australia",

  tabPanel(
    "Overview",
    h3("COVID-19 Mortality Trends in Australia"),
    p("Explore registered COVID-19 deaths in Australia from 2020 to 2024.")
  ),

  tabPanel(
    "State & Territory",
    h3("COVID-19 Deaths by State and Territory"),
    p("Compare registered COVID-19 deaths across Australian states and territories.")
  ),

  tabPanel(
    "SEIFA",
    h3("COVID-19 Deaths by Socioeconomic Disadvantage"),
    p("Explore differences in registered COVID-19 deaths across SEIFA quintiles.")
  )
)

server <- function(input, output, session) {
}

shinyApp(ui, server)