library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)
library(here)

patient <- read_excel("~/Documents/aryamanpradhan21/documents/r_projects/Patient Billing/Patient.xlsx")
visit <- read_excel("~/Documents/aryamanpradhan21/documents/r_projects/Patient Billing/Visit.xlsx")
billing <- read_excel("~/Documents/aryamanpradhan21/documents/r_projects/Patient Billing/Billing.xlsx")

visit_billing <- visit %>%
  inner_join(billing, by = "VisitID") %>%
  inner_join(patient, by = "PatientID")

visit_billing <- visit_billing %>%
  mutate(VisitMonth = month(VisitDate, label = TRUE))

# 1. Reason for visit by month
ggplot(visit_billing, aes(x = VisitMonth, fill = Reason)) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = rainbow(length(unique(visit_billing$Reason)))) +
  labs(title = "Reasons for Visit by Month", x = "Month", y = "Count") +
  theme_minimal()

# 2. Reason for visit based on walk-ins
ggplot(visit_billing, aes(x = WalkIn, fill = Reason)) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = rainbow(length(unique(visit_billing$Reason)))) +
  labs(title = "Reasons for Visit by Walk-In Status", x = "Walk-In", y = "Count") +
  theme_minimal()

# 3. Reason for visit based on City/State
ggplot(visit_billing, aes(x = City, fill = Reason)) +
  geom_bar(position = "stack") +
  coord_flip() +
  scale_fill_manual(values = rainbow(length(unique(visit_billing$Reason)))) +
  labs(title = "Reasons for Visit by City", x = "City", y = "Count") +
  theme_minimal()

# 4. Total invoice amount by reason, segmented by payment status
ggplot(visit_billing, aes(x = Reason, y = InvoiceAmt, fill = InvoicePaid)) +
  geom_col(position = "stack") +
  coord_flip() +
  scale_fill_manual(values = rainbow(length(unique(visit_billing$InvoicePaid)))) +
  labs(title = "Total Invoice Amount by Reason", x = "Reason for Visit", y = "Total Invoice Amount") +
  theme_minimal()

# 5. Additional insight: Average invoice amount by city
ggplot(visit_billing, aes(x = City, y = InvoiceAmt, fill = City)) +
  stat_summary(fun = mean, geom = "bar") +
  coord_flip() +
  scale_fill_manual(values = rainbow(length(unique(visit_billing$City)))) +
  labs(title = "Average Invoice Amount by City", x = "City", y = "Average Invoice Amount") +
  theme_minimal()