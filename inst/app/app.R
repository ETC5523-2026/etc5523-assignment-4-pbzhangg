library(shiny)
library(plotly)
library(leaflet)
library(ggplot2)
library(dplyr)
library(covidmortality)

data("covid_monthly")
data("covid_state")
data("state_geom")
data("covid_seifa")

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
      may partly reflect population size."),
    
    hr(),

    fluidRow(
      column(
        12, 
        tags$details(
          tags$summary(h4("Additional Analysis (Click to Expand)")),
          br(),
          p(
            "Choose an analysis to explore changes in death counts between two years or 
            the distribution of deaths across states and territories."
          ),
          selectInput(
            "state_analysis",
            "Select analysis:",
            choices = c(
              "Change in deaths between two years" = "change",
              "Distribution of deaths across states and territories" = "share"
            ),
            selected = "change"
          ),

          conditionalPanel(
            condition = "input.state_analysis == 'change'",
            p("Select a starting year and an ending year to compare changes in death counts."),
            fluidRow(
              column(
                6,
                selectInput(
                  "state_year_from",
                  "From year:",
                  choices = 2020:2024,
                  selected = 2020
                )
              ),
              column(
                6,
                selectInput(
                  "state_year_to",
                  "To year:",
                  choices = 2020:2024,
                  selected = 2022
                )
              )
            ),
            div(
              style = "height: 450px; display: flex; align-items: center; justify-content: center;",
              uiOutput("state_change_validation")
            ),
            p(
              strong("How to interpret:"),
              "Positive values indicate an increase in registered deaths between the 
              selected years, while negative values indicate a decrease. The percentage 
              change shows the relative size of the change compared with the starting year."
            )
          ),

          conditionalPanel(
            condition = "input.state_analysis == 'share'",
            p(
              "Select a year to examine each state's or territory's percentage 
              contribution to total registered deaths."),

            selectInput(
              "state_share_year",
              "Select year:",
              choices = 2020:2024,
              selected = 2022
            ),

            plotlyOutput("state_share_plot", height = "450px"),
            p(
              strong("How to interpret:"),
              "Each bar represents the percentage of total registered deaths attributed 
              to a particular state or territory in the selected year. The shares across 
              all states and territories sum to 100%."
            )
          )
        )
      )
    )
  ),

  tabPanel(
    "SEIFA",
    h3("COVID-19 Deaths by Socioeconomic Disadvantage"),
    p("Explore differences in registered COVID-19 deaths across SEIFA quintiles."),
    p(
    "Select a year to compare registered COVID-19 deaths across five different socioeconomic 
    disadvantage (SEIFA) quintiles. Quintile 1 represents the most disadvantaged areas, while 
    Quintile 5 represents the least disadvantaged areas. Hover over the bars to view the death counts."
    ),

    selectInput(
      inputId = "seifa_year",
      label = "Select year:",
      choices = 2020:2024,
      selected = 2022
    ),

    h4(textOutput("seifa_total")),
    plotlyOutput("seifa_plot", height = "450px"),
    p(
      strong("How to interpret: "),
      "The chart compares registered COVID-19 death counts across five socioeconomic disadvantage (SEIFA) 
      quintiles. It shows how recorded deaths were distributed across areas with different levels of 
      socioeconomic disadvantage. Higher counts do not necessarily indicate higher individual mortality risk."
    ),
    p(
      strong("Note: "),
      "These are death counts, not population-adjusted mortality rates. Differences 
      may partly reflect population size across SEIFA quintiles."
    )
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

  state_change_data <- reactive({

    calculate_death_change(
      data = covid_state,
      year_from = as.integer(input$state_year_from),
      year_to = as.integer(input$state_year_to)
    )
  })

  output$state_change_validation <- renderUI({
    if (as.integer(input$state_year_to) < as.integer(input$state_year_from)) {
      div(
        align = "center", 
        h3("Please select an ending year later than the starting year.")
      )
    } else if (as.integer(input$state_year_to) == as.integer(input$state_year_from)) {
      div(
        align = "center", 
        h3("The starting year and ending year cannot be the same for this comparison. 
           Please select 2 different years.")
      )
    } else {
      plotlyOutput("state_change_plot", height = "450px")
    }
  })
  
  output$state_change_plot <- renderPlotly({
    plot_data <- state_change_data()

    p <- ggplot(plot_data,
      aes(x = reorder(group, absolute_change), y = absolute_change,
        text = paste0(
          "State/Territory: ", group, 
          "<br>Absolute change: ", format(absolute_change, big.mark = ","),
          "<br>Percentage change: ", round(percent_change, 1), "%"
        )
      )
    ) +
      geom_col(fill = "#FC4E2AFF") +
      coord_flip() +
      scale_y_continuous(labels = scales::comma) +
      labs(
        title = paste("Change in COVID-19 Deaths:", input$state_year_from, "to", input$state_year_to),
        x = "State or Territory",
        y = "Change in registered deaths"
      ) +
      theme_minimal()

    ggplotly(p, tooltip = "text")
  })
  
  state_share_data <- reactive({
    calculate_death_share(data = covid_state, selected_year = as.integer(input$state_share_year))
  })
  
  output$state_share_plot <- renderPlotly({
    plot_data <- state_share_data()

    p <- ggplot(plot_data,
      aes(x = reorder(group, death_share), y = death_share,
          text = paste0(
            "State/Territory: ", group,
            "<br>Deaths: ", format(deaths, big.mark = ","),
            "<br>Share: ", round(death_share, 1), "%"
          )
      )
    ) +
      geom_col(fill = "#FC4E2AFF") +
      coord_flip() +
      scale_y_continuous(labels = scales::label_percent(scale = 1)) +
      labs(
        title = paste("Share of COVID-19 Deaths by State/Territory in", input$state_share_year),
        x = "State or Territory",
        y = "Percentage of registered deaths"
      ) +
      theme_minimal()

    ggplotly(p, tooltip = "text")
  })

  # Filter SEIFA data based on selected year
  seifa_data <- reactive({summarise_seifa_deaths(years = as.integer(input$seifa_year))})

  # Display total deaths across SEIFA quintiles
  output$seifa_total <- renderText({

    total <- sum(seifa_data()$deaths, na.rm = TRUE)

    paste(
      "Total registered deaths across SEIFA quintiles:",
      format(total, big.mark = ",")
    )
  })
  
  # Plot deaths by SEIFA quintile
  output$seifa_plot <- renderPlotly({

    plot_data <- seifa_data()

    p <- ggplot(
      plot_data,
      aes(x = `SEIFA Quintile`, y = deaths,
        text = paste0(
          "SEIFA Quintile: ", `SEIFA Quintile`,
          "<br>Deaths: ", format(deaths, big.mark = ",")
        )
      )
    ) +
      geom_col(fill = "#FC4E2AFF") +
      scale_y_continuous(labels = scales::comma) +
      labs(title = paste("COVID-19 Deaths by SEIFA Quintile in", input$seifa_year),
          x = "SEIFA Quintile",
          y = "Number of registered deaths"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold"),
        axis.text.x = element_text(angle = 20, hjust = 1)
      )
    
    ggplotly(p, tooltip = "text")
  })
}

shinyApp(ui, server)