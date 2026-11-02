library(shiny)
library(plotly)
library(ggplot2)
library(dplyr)
library(covidmortality)

data("covid_monthly")

ui <- navbarPage(
  title = "COVID-19 Mortality in Australia",

  tabPanel(
    "Overview",
    h3("COVID-19 Mortality Trends in Australia"),
    p("Explore monthly COVID-19 deaths in Australia from 2020 to 2024."),
    p("Note: Monthy data are based on month of death occurrence. Only January is available for 2024."),

    shinyWidgets::sliderTextInput(
      inputId = "month_range",
      label = "Select date range:",
      choices = format(covid_monthly$date, "%b %Y"),
      selected = c("Jan 2020", "Jan 2024"),
      grid = TRUE,
      force_edges = TRUE,
      width = "100%"
    ),

    h4(textOutput("total_deaths")),

    plotlyOutput("national_plot")
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

  # Filter COVID-19 deaths based on selected years
  monthly_data <- reactive({

  selected_positions <- match(
    input$month_range,
    format(covid_monthly$date, "%b %Y")
  )
    covid_monthly |>
      slice(
        selected_positions[1]:selected_positions[2]
      )
  })

  # Display total deaths over selected period
  output$total_deaths <- renderText({
    total <- sum(monthly_data()$deaths, na.rm = TRUE)

    paste(
      "Total deaths in selected period:",
      format(total, big.mark = ",")
    )
  })

  # Plot national deaths
  output$national_plot <- renderPlotly({

    p <- ggplot(
          monthly_data(), 
          aes(
            x = date, 
            y = deaths, 
            group = 1,
            text = paste0(
              "Month: ", format(date, "%B %Y"),
              "<br>Deaths: ", format(deaths, big.mark = ",")
            )
          )
        ) +
      geom_line(linewidth = 1) +
      geom_point(size = 2) +
      scale_x_date(
        date_labels = "%b %Y", 
        date_breaks = "3 months"
      ) +
      scale_y_continuous(labels = scales::comma) +
      labs(
        title = "Monthly COVID-19 Deaths in Australia",
        x = "Month",
        y = "Number of deaths"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
    ggplotly(p, tooltip = "text")
  })
}

shinyApp(ui, server)