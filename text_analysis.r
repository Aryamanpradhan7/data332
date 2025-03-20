
# Load necessary libraries
library(tidyverse)
library(tidytext)
library(wordcloud)
library(RColorBrewer)
library(syuzhet)
library(ggplot2)
library(lubridate)

# Install and load textdata package for NRC lexicon
if(!require(textdata)) {
  install.packages("textdata")
  library(textdata)
}
get_sentiments("nrc")

# Set working directory
setwd("~/Documents/aryamanpradhan21/documents/r_projects/textanalysis/Consumer_Complaints1.csv")

# Load data
complaints <- read.csv("Consumer_Complaints.csv", stringsAsFactors = FALSE)

# Filter out rows with non-empty complaint narratives
complaints_clean <- complaints %>%
  filter(!is.na(Consumer.complaint.narrative))

# Remove rows where the complaint narrative contains the word 'xxxx'
complaints_clean <- complaints_clean %>%
  filter(!str_detect(tolower(Consumer.complaint.narrative), "\bxxxx\b"))

# Data Cleanup:
# Convert text to lowercase, remove punctuation, numbers, stopwords, and exclude specific word 'xxxx'
cleaned_narratives <- complaints_clean %>%
  select(Complaint.ID, Product, Issue, Date.received, Consumer.complaint.narrative) %>%
  unnest_tokens(word, Consumer.complaint.narrative) %>%
  anti_join(stop_words) %>%
  filter(!str_detect(word, "^[0-9]+$")) %>%
  filter(word != "xxxx")

# Create Images folder if not exists
if(!dir.exists("Images")){
  dir.create("Images")
}

# WORD CLOUD
word_freq <- cleaned_narratives %>%
  count(word, sort = TRUE)

png("Images/wordcloud.png", width = 900, height = 700)
wordcloud(words = word_freq$word, freq = word_freq$n, min.freq = 50, 
          max.words = 200, colors = brewer.pal(8, "Set2"), random.order = FALSE, 
          rot.per = 0.35, scale = c(4, 0.5))
dev.off()

# SENTIMENT ANALYSIS - BING (Pie Chart)
bing_sentiment <- cleaned_narratives %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment) %>%
  mutate(percent = n / sum(n) * 100,
         label = paste0(sentiment, " (", round(percent, 1), "%)"))

png("Images/sentiment_bing.png", width = 800, height = 600)
ggplot(bing_sentiment, aes(x = "", y = n, fill = sentiment)) +
  geom_col(width = 1, color = "white") +
  coord_polar("y") +
  geom_text(aes(label = label), position = position_stack(vjust = 0.5)) +
  labs(title = "Sentiment Distribution (Bing Lexicon)") +
  theme_void() +
  theme(legend.position = "bottom")
dev.off()

# SENTIMENT ANALYSIS - NRC (Lollipop Chart)
nrc_sentiment <- cleaned_narratives %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment) %>%
  mutate(percent = n / sum(n) * 100)

png("Images/sentiment_nrc.png", width = 1000, height = 600)
ggplot(nrc_sentiment, aes(x = reorder(sentiment, n), y = n)) +
  geom_segment(aes(xend = sentiment, y = 0, yend = n), color = "skyblue", size = 1.2) +
  geom_point(size = 4, color = "darkblue") +
  coord_flip() +
  labs(title = "NRC Sentiment Analysis - Lollipop Chart", x = "Emotion", y = "Word Count") +
  theme_minimal()
dev.off()

# TOP 10 COMPLAINT PRODUCTS (Horizontal Bar Chart with Gradient)
product_complaints <- complaints_clean %>%
  count(Product, sort = TRUE) %>%
  top_n(10)

png("Images/top_products.png", width = 800, height = 600)
ggplot(product_complaints, aes(x = reorder(Product, n), y = n, fill = n)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  coord_flip() +
  labs(title = "Top 10 Complaint Products", y = "Number of Complaints", x = "Product") +
  theme_minimal()
dev.off()

# TOP 10 ISSUES (Dot Plot)
issue_complaints <- complaints_clean %>%
  count(Issue, sort = TRUE) %>%
  top_n(10)

png("Images/top_issues.png", width = 900, height = 600)
ggplot(issue_complaints, aes(x = n, y = reorder(Issue, n))) +
  geom_point(color = "purple", size = 4) +
  geom_segment(aes(x = 0, xend = n, yend = Issue), color = "gray") +
  labs(title = "Top 10 Complaint Issues", y = "Issue", x = "Number of Complaints") +
  theme_minimal()
dev.off()

# TREND OVER TIME - AREA CHART
complaints_clean$Date.received <- mdy(complaints_clean$Date.received)
time_trend <- complaints_clean %>%
  mutate(year = year(Date.received)) %>%
  count(year)

png("Images/complaints_over_time.png", width = 900, height = 600)
ggplot(time_trend, aes(x = year, y = n)) +
  geom_area(fill = "lightgreen", alpha = 0.7) +
  geom_line(color = "darkgreen", size = 1.2) +
  geom_point(color = "black", size = 2) +
  labs(title = "Trend of Complaints Over Time", y = "Number of Complaints", x = "Year") +
  theme_minimal()
dev.off()

# Save cleaned narrative data
write.csv(new_data, "new_data.csv", row.names = FALSE)
