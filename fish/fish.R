install.packages("here")
install.packages("kableExtra")

#Loading necessary libraries
library(ggplot2)
library(dplyr)
library(tidyverse)
library(readxl)
library(here)
library(kableExtra)

#Reset RStudio environment by clearing all objects from memory
rm(list = ls())

#Set working directory
setwd('~/Documents/aryamanpradhan21/documents/r_projects/fish')

#Read data from CSV and Excel files
fish <- read_csv("fish.csv")
kelp_abur <- read_excel(("kelp_fronds.xlsx"), sheet = "abur")

###Filtering Data###

#Filter fish dataset to only include rows where common_name is "garibaldi"
fish_garibaldi <- fish %>%
  filter(common_name == "garibaldi")

#Filter dataset to include only fish recorded at the "mohk" site
fish_mohk <- fish %>% 
  filter(site == "mohk")

#Filter dataset to only include fish with total count >= 50
fish_over50 <- fish %>% 
  filter(total_count >= 50)

fish_3sp <- fish %>%
  filter(common_name == "garibaldi" |
           common_name == "blacksmith" |
           common_name == "black surfperch")

#Filter dataset to include fish of specific species (garibaldi, blacksmith, black surfperch)
fish_3sp <- fish %>% 
  filter(common_name %in% c("garibaldi", "blacksmith", "black surfperch"))

#Filter dataset to include fish from year 2016 OR species "garibaldi"
fish_gar_2016 <- fish %>% 
  filter(year == 2016 | common_name == "garibaldi")

#Filter dataset where both conditions are met: year == 2018 AND site == "aque"
aque_2018 <- fish %>% 
  filter(year == 2018, site == "aque")
aque_2018

#Equivalent filter using & (logical AND)
aque_2018 <- fish %>% 
  filter(year == 2018 & site == "aque")

#Equivalent filter using multiple sequential filters
aque_2018 <- fish %>% 
  filter(year == 2018) %>% 
  filter(site == "aque")

#Filter fish dataset to include only "garibaldi" or "rock wrasse" with total count <= 10
low_gb_wr <- fish %>% 
  filter(common_name %in% c("garibaldi", "rock wrasse"), 
         total_count <= 10)

#Filter fish dataset to find species with "black" in their name (e.g., "blacksmith", "black surfperch")
fish_bl <- fish %>% 
  filter(str_detect(common_name, pattern = "black"))

#Filter fish dataset to find species containing "it" in their name (e.g., "blacksmITh", "senorITa")
fish_it <- fish %>% 
  filter(str_detect(common_name, pattern = "it"))

###Joining Data###

#Perform a full join (merge all records from both datasets, filling missing values with NA)
abur_kelp_fish <- kelp_abur %>% 
  full_join(fish, by = c("year", "site")) 

#Perform a left join (keep all records from kelp_abur and match with fish data where possible)
kelp_fish_left <- kelp_abur %>% 
  left_join(fish, by = c("year","site"))

#Perform an inner join (only keep records that exist in both datasets)
kelp_fish_injoin <- kelp_abur %>% 
  inner_join(fish, by = c("year", "site"))

###Filtering and Joining in a Wrangling Sequence###

#Step 1: Filter fish dataset for year 2017 and site "abur"
#Step 2: Left join with kelp data
#Step 3: Create a new column (fish_per_frond) by dividing total fish count by total fronds
my_fish_join <- fish %>% 
  filter(year == 2017, site == "abur") %>% 
  left_join(kelp_abur, by = c("year", "site")) %>% 
  mutate(fish_per_frond = total_count / total_fronds)

###Creating an HTML Table###

#Display the merged dataset as a formatted table
kable(my_fish_join)

#Apply additional styling to the table for better readability
my_fish_join %>% 
  kable() %>% 
  kable_styling(bootstrap_options = "striped", 
                full_width = FALSE)