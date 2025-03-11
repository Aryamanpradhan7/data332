# README: Student Data Analysis in R

## Project Overview

This project analyzes student registration data using R. The script processes Excel files containing student information, course registration details, and course metadata. It merges and cleans the data, then generates visualizations to analyze student enrollment trends, birth years, total course costs, and outstanding balances.

## Requirements

### Ensure you have R and RStudio installed. The following R packages are required:

##### readxl – for reading Excel files

##### dplyr – for data manipulation

##### ggplot2 – for creating visualizations

##### janitor – for cleaning column names

### Install missing packages using:

install.packages(c("readxl", "dplyr", "ggplot2", "janitor"))

## File Structure

Student.xlsx – Contains student details

Registration (1).xlsx – Contains student registration records

Course.xlsx – Contains course details

script.R – Main script for data processing and visualization

## Data Processing Steps

Load required libraries.

Read Excel files into R.

Clean column names for consistency.

Convert student_id to character type.

Remove NA values from student_id columns.

Perform left joins to merge datasets.

Ensure birth_date is correctly formatted.

## Generate visualizations:

Number of students per course
![insight1](https://github.com/user-attachments/assets/59036e42-a072-45d4-b1e0-3fa9f0ccde09)

Number of students by birth year
![insight2](https://github.com/user-attachments/assets/ce7ec6aa-f63e-4ee1-9034-bdf16e3a92c5)

Total cost per course title, segmented by payment plan
![insight3](https://github.com/user-attachments/assets/058a5f49-83ee-441a-8971-f9893b47ea80)

Total balance due per course title, segmented by payment plan
![insight4](https://github.com/user-attachments/assets/a71ccf0f-76f1-499a-9229-69cca2ead605)

## Running the Script

Open script.R in RStudio and run the entire script by clicking Run or using:

source("script.R")

Ensure all data files are placed in the correct directory:

~/Documents/aryamanpradhan21/documents/r_projects/Student Data/

## Output

Merged dataset for further analysis

Visualizations saved as plots in RStudio

## Notes

Modify file paths as needed for your system.

Ensure Excel files contain the expected column names.

If new data is added, rerun the script for updated insights.

License

This project is for educational and analytical purposes. Use and modify freely.

Author: Aryaman Pradhan

