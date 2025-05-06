# --- Load Required Libraries ---
library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(janitor)
library(tidyr)
library(DT)
library(leaflet)
library(leaflet.extras)
library(caret)
library(reshape2)
library(randomForest)
library(scales)

# --- Load & Preprocess Uber Data ---
load_uber_data <- function() {
  months <- c("apr14", "may14", "jun14", "jul14", "aug14", "sep14")
  base_url <- "https://raw.githubusercontent.com/Aryamanpradhan7/data332/8ba08c83ff92a5bc0b6cccda39f778598b0c9de0/newdata/"
  tmp_dir <- tempdir()
  all_data <- list()
  
  for (month in months) {
    zip_file <- paste0("uber-raw-data-", month, ".zip")
    zip_path <- file.path(tmp_dir, zip_file)
    download.file(paste0(base_url, zip_file), zip_path, mode = "wb")
    
    unzip(zip_path, exdir = tmp_dir)
    csv_file <- list.files(tmp_dir, pattern = paste0(month, ".*\\.csv$"), full.names = TRUE)
    
    if (length(csv_file) == 1) {
      df <- read_csv(csv_file, show_col_types = FALSE) %>% clean_names()
      if (all(c("lat", "lon", "date_time") %in% names(df))) {
        df <- df %>%
          mutate(
            lat = as.numeric(lat),
            lon = as.numeric(lon),
            date_time = mdy_hms(date_time),
            hour = hour(date_time),
            day = day(date_time),
            wday = wday(date_time, label = TRUE),
            month = month(date_time, label = TRUE),
            week = week(date_time)
          ) %>%
          drop_na(lat, lon, date_time)
        all_data[[length(all_data) + 1]] <- df
      }
    }
  }
  bind_rows(all_data)
}

uber_data <- load_uber_data()
available_months <- sort(unique(uber_data$month))

# --- UI ---
ui <- fluidPage(
  titlePanel("Uber NYC Dashboard (Apr–Sep 2014)"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_month", "Select a Month:", choices = as.character(available_months)),
      selectInput("pivot_month", "Pivot Table Month:", choices = c("All", as.character(available_months)))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Hourly Trips", plotOutput("hour_plot")),
        tabPanel("Base-wise Trips", plotOutput("base_plot")),
        tabPanel("Heatmap (Hour vs Day)", plotOutput("heatmap_plot")),
        tabPanel("Pickup Map", leafletOutput("map_plot", height = 600)),
        tabPanel("Pivot Table", DTOutput("pivot_table")),
        tabPanel("Prediction", 
                 plotOutput("rf_plot"), 
                 verbatimTextOutput("rf_summary"))
      )
    )
  )
)

# --- Server ---
server <- function(input, output, session) {
  
  filtered_data <- reactive({
    uber_data %>% filter(month == input$selected_month)
  })
  
  output$hour_plot <- renderPlot({
    df <- filtered_data() %>% count(hour)
    ggplot(df, aes(hour, n)) +
      geom_col(fill = "#4a90e2") +
      labs(title = "Trips by Hour", x = "Hour", y = "Trips") +
      theme_minimal()
  })
  
  output$base_plot <- renderPlot({
    df <- filtered_data() %>% count(base)
    ggplot(df, aes(x = reorder(base, -n), y = n)) +
      geom_col(fill = "#f76c6c") +
      labs(title = "Trips by Base", x = "Base", y = "Trips") +
      theme_minimal()
  })
  
  output$heatmap_plot <- renderPlot({
    sampled_df <- uber_data %>%
      drop_na(hour, day) %>%
      group_by(month) %>%
      slice_sample(n = 3000) %>%
      ungroup() %>%
      mutate(month = factor(month, levels = month.name[4:9]))
    
    ggplot(sampled_df, aes(x = hour, y = day)) +
      geom_bin2d(binwidth = c(1, 1)) +
      scale_fill_viridis_c() +
      facet_wrap(~ month, ncol = 2) +
      labs(
        title = "Hourly vs Daily Trip Density (Sampled)",
        x = "Hour", y = "Day", fill = "Trips"
      ) +
      theme_minimal()
  })
  
  output$map_plot <- renderLeaflet({
    df <- filtered_data() %>%
      drop_na(lat, lon) %>%
      slice_sample(n = min(2000, nrow(.)))
    
    leaflet(df) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~lon, lat = ~lat,
        radius = 2, fillOpacity = 0.3,
        stroke = FALSE, clusterOptions = markerClusterOptions()
      )
  })
  
  output$pivot_table <- renderDT({
    df <- if (input$pivot_month == "All") uber_data else uber_data %>% filter(month == input$pivot_month)
    df %>%
      count(month, hour) %>%
      pivot_wider(names_from = hour, values_from = n, values_fill = 0) %>%
      datatable(rownames = FALSE, options = list(pageLength = 6))
  })
  
  output$rf_summary <- renderPrint({
    df <- filtered_data() %>%
      count(hour, wday) %>%
      mutate(
        wday = as.numeric(wday),
        peak = as.factor(n > quantile(n, 0.75))
      )
    
    rf_model <- randomForest(peak ~ hour + wday, data = df, ntree = 100)
    print(rf_model)
  })
  
  output$rf_plot <- renderPlot({
    df <- filtered_data() %>%
      count(hour, wday) %>%
      mutate(
        wday = as.numeric(wday),
        peak = as.factor(n > quantile(n, 0.75))
      )
    
    rf_model <- randomForest(peak ~ hour + wday, data = df, ntree = 100)
    varImpPlot(rf_model, main = "Random Forest: Feature Importance")
  })
}

# --- Run App ---
shinyApp(ui, server)
