library(shiny)
library(plotly)
library(leaflet)
library(ggplot2)
library(dplyr)
library(covidmortality)

data("covid_monthly")
data("covid_state")
data("state_geom")

ui <- navbarPage(
  title = "COVID-19 Mortality in Australia",

  tabPanel(
    "Overview",

    h3("COVID-19 Mortality Trends in Australia"),

    h4("About this app"),
    p(
      "This app is designed for public health researchers, policymakers, and the general public
      interested in understanding COVID-19 mortality patterns in Australia."
    ),
    p(
      strong("Research question: "), 
      "How did COVID-19 mortality patterns in Australia change over time, and how did these patterns
      differ across states and territories and socioeconomic disadvantage (SEIFA) quintile groups between 
      2020 and 2024?"
    ),

    hr(),

    h4("Monthly Mortality Trends"),
    p("Explore monthly COVID-19 deaths in Australia from 2020 to 2024."),
    p(
      "Use the date range slider to select the period you'd like to examine. 
      The total death count and line chart will automatically update accordingly"
    ),

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

    plotlyOutput("national_plot"),
    p(
      strong("How to interpret: "),
      "The line chart shows how monthly COVID-19 deaths changed over time. 
      Peaks indicate months with higher numbers of deaths, while decines indicate 
      periods with fewer deaths. This helps identify changes in national mortality 
      patterns in Australia between 2020 and 2024."
    ),
    p(
      strong("Note: "), 
      "Monthly data are based on month of death occurrence. Only January is available for 2024."
    )
  ),

  tabPanel(
    "State & Territory",
    h3("COVID-19 Deaths by State and Territory"),
    p("Compare registered COVID-19 deaths across Australian states and territories from 2020 to 2024."),
    p(
      "Select a year to view the number of registered COVID-19 deaths across the eight states 
      and territories. The bar chart compares death counts, while the map shows their geographical 
      distribution. Hover over the bars or map regions for more information."
    ),

    selectInput(
      inputId = "state_year",
      label = "Select year:",
      choices = 2020:2024,
      selected = 2022
    ),

    h4(textOutput("state_total")),

    fluidRow(
      column(
        width = 6,
        h4("Deaths by state and territory"),
        plotlyOutput("state_plot", height = "450px")
      ),

      column(
        width = 6,
        h4("Geographical distribution"),
        leafletOutput("state_map", height = "450px")
      )
    ),

    p(
      strong("How to interpret: "),
      "The bar chart compares the number of registered COVID-19 deaths across states 
      and territories in Australia, while the map highlights their geographical 
      distribution. Larger bars and darker map regions indicate higher numbers of 
      recorded deaths. These comparisons help identify geographical differences in 
      COVID-19 mortality."
    ),
    p(
      strong("Note: "),
      "These are death counts, not population-adjusted mortality rates. Differences 
      may partly reflect population size.")
  ),

  tabPanel(
    "SEIFA",
    h3("COVID-19 Deaths by Socioeconomic Disadvantage"),
    p("Explore differences in registered COVID-19 deaths across SEIFA quintiles.")
  )
)

server <- function(input, output, session) {

  # Filter monthly data based on selected date range
  monthly_data <- reactive({

    selected_positions <- match(
      input$month_range,
      format(covid_monthly$date, "%b %Y")
    )

    covid_monthly |>
      slice(selected_positions[1]:selected_positions[2])
  })

  # Display total deaths over selected period
  output$total_deaths <- renderText({

    total <- sum(monthly_data()$deaths, na.rm = TRUE)

    paste(
      "Total deaths in selected period:",
      format(total, big.mark = ",")
    )
  })

  # Plot monthly national deaths
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
      scale_y_continuous(
        labels = scales::comma
      ) +
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

  # Filter state data based on selected year
  state_data <- reactive({
    summarise_state_deaths(years = as.integer(input$state_year))
  })

  # Display state deaths
  output$state_total <- renderText({

    total <- sum(state_data()$deaths, na.rm = TRUE)

    paste(
      "Total registered deaths in Australia:",
      format(total, big.mark = ",")
    )

  })

  # Plot deaths by state and territory
  output$state_plot <- renderPlotly({

    plot_data <- state_data() |>
      mutate(
        state = recode(
          state,
          NSW = "New South Wales",
          Vic = "Victoria",
          Qld = "Queensland",
          SA = "South Australia",
          WA = "Western Australia",
          Tas = "Tasmania",
          NT = "Northern Territory",
          ACT = "Australian Capital Territory"
        )
      )

    p <- ggplot(
      plot_data,
      aes(x = reorder(state, deaths), y = deaths,
        text = paste0("State/Territory: ", state,
          "<br>Deaths: ", format(deaths, big.mark = ",")
        )
      )
    ) +
      geom_col(fill = "#FC4E2AFF") +
      coord_flip() +
      scale_y_continuous(
        labels = scales::comma
      ) +
      labs(
        title = paste(
          "COVID-19 Deaths by State and Territory in",
          input$state_year
        ),
        x = NULL,
        y = "Number of registered deaths"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", hjust = 0)
      )
    
    ggplotly(p, tooltip = "text")

  })

  # Join state mortality data to geographical boundaries
  state_map_data <- reactive({

    map_data <- state_geom |>
      mutate(state_code = recode(
        STE_NAME21,
        "New South Wales" = "NSW",
        "Victoria" = "Vic",
        "Queensland" = "Qld",
        "South Australia" = "SA",
        "Western Australia" = "WA",
        "Tasmania" = "Tas",
        "Northern Territory" = "NT",
        "Australian Capital Territory" = "ACT"
      ))
    
    deaths_data <- state_data() |>
      select(state_code = state, deaths)

    map_data$deaths <- deaths_data$deaths[
      match(map_data$state_code, deaths_data$state_code)
    ]

    map_data <- map_data[!is.na(map_data$deaths), ]
    map_data <- sf::st_transform(map_data, 4326)

    map_data
  })

  # Display interactive state mortality map
  output$state_map <- renderLeaflet({
    map_data <- state_map_data()

    pal <- colorNumeric(palette = "YlOrRd", domain = c(0, 3800))

    leaflet(map_data) |>
      addTiles() |>
      addPolygons(
        fillColor = ~ifelse(deaths == 0, "white", pal(deaths)),
        fillOpacity = 0.8,
        color = "black",
        weight = 2,
        label = ~paste0(STE_NAME21, ": ", format(deaths, big.mark = ","), " deaths"),
        highlightOptions = highlightOptions(weight = 3, color = "black", fillOpacity = 0.9, bringToFront = TRUE)
      ) |>
      addLegend(position = "bottomright", pal = pal, values = c(0, 3800), title = "Deaths", opacity = 0.8)
  })

}

shinyApp(ui, server)