# Load the deck
deck <- read.csv("~/Documents/aryamanpradhan21/documents/r_projects/deck.csv")

# Check if it's loaded correctly
head(deck)

# Selecting Values
deck[ , ]

# Positive Integers
head(deck)
deck[1, 1]

deck[1, c(1, 2, 3)]

new <- deck[1, c(1, 2, 3)]
new

# Repeating
deck[c(1, 1), c(1, 2, 3)]

# Vectors in R
vec <- c(6, 1, 3, 6, 10, 5)
vec[1:3]

# Learning to use drop = FALSE
deck[1:2, 1:2]
deck[1:2, 1]
deck[1:2, 1, drop = FALSE]

# Negative Integers
deck[-(2:52), (1:3)]
deck[0, 0]

# Blank Spaces
deck[1, ]

# Logical Values
deck[1, c(TRUE, TRUE, FALSE)]

rows <- c(TRUE, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F,
          F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F,
          F, F, F, F, F, F, F, F, F, F, F, F, F, F)
deck[rows, ]

# Names for the deck
deck[1, c("face", "suit", "value")]
deck[ , "value"]

# Exercise-1
deal <- function(cards) {
  cards[1, ]
}

deal(deck)

# Shuffle the deck

# Call the deck first
deck2 <- deck[1:52, ]
head(deck2)

# Extract the deck in different order
deck3 <- deck[c(2, 1, 3:52), ]
head(deck3)

# Generating random for shuffling the order of the cards in a deck
random <- sample(1:52, size = 52)
random

deck4 <- deck[random, ]
head(deck4)

# Exercise-2

# Shuffle should take a data frame and return a shuffled copy of the data frame
shuffle <- function(cards) {
  random <- sample(1:52, size = 52)
  cards[random, ]
}

# Shuffling cards between each deal
deal(deck)
deck2 <- shuffle(deck)
deal(deck2)

# Dollar Sign and Double Brackets
deck$value

mean(deck$value)
median(deck$value)

# Create a list
lst <- list(numbers = c(1, 2), logical = TRUE, strings = c("a", "b", "c"))
lst

# Subset
lst[1]

# Correct way to sum the numbers in the list
sum(lst[[1]])  # This works because lst[[1]] returns the vector c(1, 2)
sum(lst$numbers)  # This also works because lst$numbers returns the vector c(1, 2)

# Two brackets if elements in the list don't have a name
lst[[1]]

# Single brackets and double brackets
lst["numbers"]

lst[["numbers"]]