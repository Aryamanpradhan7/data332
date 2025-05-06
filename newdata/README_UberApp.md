# Uber NYC Dashboard (Apr–Sep 2014)

This project is a Shiny dashboard application that analyzes Uber pickup data in New York City from April to September 2014. The dashboard offers visual insights into trip patterns over time, location, and bases, and includes an interactive prediction model using a random forest classifier.


##ShinyApp: https://aryamanpradhan.shinyapps.io/Uber_Assignment/

## 📁 File Structure

```
Uber_App/
├── Uber_Assignment_Aryaman.R
├── README_UberApp.md
└── Excel Files
```

## 🌐 Shiny App URL

👉 [Click here to view the live app](https://YOUR_USERNAME.shinyapps.io/YOUR_APP_NAME)  
_Replace with your actual ShinyApps.io deployment URL._

---

## 📦 Load Required Libraries

```r
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
```

## 📥 Data Loading & Preprocessing

```r
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
    csv_file <- list.files(tmp_dir, pattern = paste0(month, ".*\.csv$"), full.names = TRUE)

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
```

## 📊 Hourly Trips Bar Chart

```r
output$hour_plot <- renderPlot({
  df <- filtered_data() %>% count(hour)
  ggplot(df, aes(hour, n)) +
    geom_col(fill = "#4a90e2") +
    labs(title = "Trips by Hour", x = "Hour", y = "Trips") +
    theme_minimal()
})
```

## 🏢 Base-wise Trips

```r
output$base_plot <- renderPlot({
  df <- filtered_data() %>% count(base)
  ggplot(df, aes(x = reorder(base, -n), y = n)) +
    geom_col(fill = "#f76c6c") +
    labs(title = "Trips by Base", x = "Base", y = "Trips") +
    theme_minimal()
})
```

## 🔥 Heatmap (Hour vs Day, Faceted by Month)

```r
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
```

## 🗺️ Pickup Location Map

```r
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
```

## 📈 Pivot Table by Month/Hour

```r
output$pivot_table <- renderDT({
  df <- if (input$pivot_month == "All") uber_data else uber_data %>% filter(month == input$pivot_month)
  df %>%
    count(month, hour) %>%
    pivot_wider(names_from = hour, values_from = n, values_fill = 0) %>%
    datatable(rownames = FALSE, options = list(pageLength = 6))
})
```

## 🤖 Random Forest Prediction Model

```r
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
```

```r
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
```

---
