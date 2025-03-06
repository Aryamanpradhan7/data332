# Load necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(janitor)

# Define file paths
student_file <- "~/Documents/aryamanpradhan21/documents/r_projects/Student Data/Student.xlsx"
registration_file <- "~/Documents/aryamanpradhan21/documents/r_projects/Student Data/Registration (1).xlsx"
course_file <- "~/Documents/aryamanpradhan21/documents/r_projects/Student Data/Course.xlsx"

# Read Excel files
student_data <- read_excel(student_file) %>% clean_names()
registration_data <- read_excel(registration_file) %>% clean_names()
course_data <- read_excel(course_file) %>% clean_names()

# Convert 'student_id' to character type for consistency
student_data <- student_data %>%
  mutate(student_id = as.character(student_id))

registration_data <- registration_data %>%
  mutate(student_id = as.character(student_id))

# Remove NA values in 'student_id'
student_data <- student_data %>% filter(!is.na(student_id))
registration_data <- registration_data %>% filter(!is.na(student_id))

# Perform left joins
merged_data <- student_data %>%
  left_join(registration_data, by = "student_id") %>%
  left_join(course_data, by = "instance_id")

# Ensure 'birth_date' is properly formatted
if ("birth_date" %in% colnames(merged_data)) {
  merged_data$birth_year <- format(as.Date(merged_data$birth_date, format = "%Y-%m-%d"), "%Y")
}

# Chart 1: Number of students per course (Rainbow Bar Chart)
if ("title" %in% colnames(merged_data)) {
  student_count_per_course <- merged_data %>%
    group_by(title) %>%
    summarise(student_count = n(), .groups = "drop")
  
  ggplot(student_count_per_course, aes(x = reorder(title, -student_count), y = student_count, fill = title)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = rainbow(nrow(student_count_per_course))) +
    theme_minimal() +
    labs(title = "Number of Students per Course", x = "Course Title", y = "Student Count") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Chart 2: Number of students by birth year (Rainbow Bar Chart)
if ("birth_year" %in% colnames(merged_data)) {
  student_count_by_birth_year <- merged_data %>%
    group_by(birth_year) %>%
    summarise(student_count = n(), .groups = "drop")
  
  ggplot(student_count_by_birth_year, aes(x = birth_year, y = student_count, fill = birth_year)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = rainbow(nrow(student_count_by_birth_year))) +
    theme_minimal() +
    labs(title = "Number of Students by Birth Year", x = "Birth Year", y = "Student Count")
}

# Chart 3: Total cost per course title, segmented by payment plan (Rainbow Bar Chart)
if (all(c("title", "payment_plan", "total_cost") %in% colnames(merged_data))) {
  total_cost <- merged_data %>%
    group_by(title, payment_plan) %>%
    summarise(total_cost = sum(total_cost, na.rm = TRUE), .groups = "drop")
  
  ggplot(total_cost, aes(x = reorder(title, -total_cost), y = total_cost, fill = payment_plan)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = rainbow(length(unique(total_cost$payment_plan)))) +
    theme_minimal() +
    labs(title = "Total Cost per Course Title (Segmented by Payment Plan)", x = "Course Title", y = "Total Cost") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Chart 4: Total balance due per course title, segmented by payment plan (Rainbow Bar Chart)
if (all(c("title", "payment_plan", "balance_due") %in% colnames(merged_data))) {
  total_balance <- merged_data %>%
    group_by(title, payment_plan) %>%
    summarise(total_balance_due = sum(balance_due, na.rm = TRUE), .groups = "drop")
  
  ggplot(total_balance, aes(x = reorder(title, -total_balance_due), y = total_balance_due, fill = payment_plan)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = rainbow(length(unique(total_balance$payment_plan)))) +
    theme_minimal() +
    labs(title = "Total Balance Due per Course Title (Segmented by Payment Plan)", x = "Course Title", y = "Total Balance Due") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}