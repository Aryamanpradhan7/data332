library(dplyr)
library(tidyverse)
library(readxl)
library(lubridate)
library(ggplot2)

rm(list=ls())

# set working directory to your Uber data folder
setwd("~/Documents/aryamanpradhan21/documents/r_projects/uberdata")

April_1     <- read.csv("uber-raw-data-apr14.csv")
May_1       <- read.csv("uber-raw-data-may14.csv")
June_1      <- read.csv("uber-raw-data-jun14.csv")
July_1      <- read.csv("uber-raw-data-jul14.csv")
August_1    <- read.csv("uber-raw-data-aug14.csv")
September_1 <- read.csv("uber-raw-data-sep14.csv")

combined_Data <- bind_rows(April_1, May_1, June_1, July_1, August_1, September_1)

# separate the datetime column into date and time components
combined_Data <- separate(combined_Data, Date.Time, into = c("Date", "Time"), sep = "\\s+(?=[^\\s]+$)")

# Convert the Date column to Date format
combined_Data$Date <- as.Date(combined_Data$Date, format = "%m/%d/%y")

# Add columns for month and day
combined_Data <- combined_Data %>%
  mutate(
    Month = month(Date, label = TRUE),
    Day   = day(Date),
    day   = wday(Date, label = TRUE)
  ) %>%
  separate(Time, into = c("hour", "minute", "seconds"), sep = ":")

#------------------------PIVOT-----------------------------------------

everyday_counts <- combined_Data %>%
  group_by(Month, Day) %>%
  summarise(n = n(), .groups = "drop")

rides_per_month <- combined_Data %>%
  group_by(Month) %>%
  summarise(num_rides = n(), .groups = "drop")

write.csv(rides_per_month, "rides_per_month.csv", row.names = FALSE)

trips_per_hour <- combined_Data %>%
  group_by(hour, Month) %>%
  summarise(num_rides = n(), .groups = "drop") %>%
  arrange(hour)

write.csv(trips_per_hour, "trips_per_hour.csv", row.names = FALSE)

Month_day <- combined_Data %>%
  group_by(Month, day) %>%
  summarise(Trips = n(), .groups = "drop")

write.csv(Month_day, "Month_day.csv", row.names = FALSE)

Base_Count <- combined_Data %>%
  group_by(Base, Month) %>%
  summarise(n = n(), .groups = "drop")

write.csv(Base_Count, "Base_Count.csv", row.names = FALSE)

Base_week <- combined_Data %>%
  group_by(Base, day) %>%
  summarise(num_trips = n(), .groups = "drop")

write.csv(Base_week, "Base_week.csv", row.names = FALSE)

#--------------------------Graphs----------------------------------------------------

ggplot(rides_per_month, aes(x = Month, y = num_rides, fill = Month)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Uber Rides per Month", x = "Month", y = "Number of Rides") +
  theme_classic()

ggplot(trips_per_hour, aes(x = reorder(hour, -num_rides), y = num_rides, fill = Month)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Uber Rides Per Hour", x = "Time of Day", y = "Number of Rides") +
  theme_classic()

ggplot(trips_per_hour, aes(x = reorder(hour, -num_rides), y = num_rides, fill = hour)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Uber Rides Per Hour", x = "Time of Day", y = "Number of Rides") +
  theme_classic()

ggplot(Month_day, aes(x = Month, y = Trips, fill = day)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Trips per Month by Day of Week", x = "Month", y = "Number of Rides") +
  theme_minimal()

ggplot(Base_Count, aes(x = Month, y = n, fill = Base)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Trips by Base and Month", x = "Month", y = "Number of Rides") +
  theme_minimal()

#--------------------------Heat Maps--------------------------------------------

Hour_Day_Count <- combined_Data %>%
  group_by(hour, day) %>%
  summarise(n = n(), .groups = "drop")

write.csv(Hour_Day_Count, "Hour_Day_Count.csv", row.names = FALSE)

ggplot(Hour_Day_Count, aes(x = hour, y = day, fill = n)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Uber Rides by Hour and Day", x = "Hour of the Day", y = "Day of the Week")

ggplot(Month_day, aes(x = Month, y = day, fill = Trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Uber Rides by Month and Day", x = "Month", y = "Day of the Week")

ggplot(Base_week, aes(x = Base, y = day, fill = num_trips)) +
  geom_tile() +
  scale_fill_gradient(low = "light yellow", high = "deep pink") +
  labs(title = "Base and Day of the Week", x = "Base", y = "Day of the Week")

#----------------------Prediction Model------------------------------------------

prediction_model <- combined_Data %>%
  group_by(hour, Month, day, Day) %>%
  summarise(Total_Trips = n(), .groups = "drop")

write.csv(prediction_model, "prediction_model.csv", row.names = FALSE)

ggplot(prediction_model, aes(x = Month, y = Total_Trips, color = factor(day == "Sat"))) +
  geom_point(size = 3) +
  scale_color_manual(values = c("lightgreen", "deep pink"), guide = "none") +
  labs(color = "Is Saturday?")
