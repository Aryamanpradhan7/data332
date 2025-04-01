# Chapter 5

deck2 <- deck

vec <- c(0, 0, 0, 0, 0, 0)
vec

vec[1]

# Updating the first element
vec[1] <- 1000
vec

# Modifying multiple positions at once
vec[c(1, 3, 5)] <- c(1, 1, 1)
vec

vec[4:6] <- vec[4:6] + 1
vec

# Expanding the vector with a new element
vec[7] <- 0
vec

# Adding a sequential column to the dataset
deck2$new <- 1:52
head(deck2)

# Removing the added column
deck2$new <- NULL
head(deck2)

# Adjusting the value of Aces in the dataset
deck2[c(13, 26, 39, 52), ]

# Extracting only the value of Aces
deck2[c(13, 26, 39, 52), 3]
# Alternative way
deck2$value[c(13, 26, 39, 52)]

# Updating Aces to have a value of 14
deck2$value[c(13, 26, 39, 52)] <- 14

head(deck2, 13)

deck3 <- shuffle(deck)
head(deck3)

# Logical selection

vec
vec[c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE)]

# Identifying which cards are Aces
deck2$face

deck2$face == "ace"
sum(deck2$face == "ace")
deck3$value[deck3$face == "ace"]
deck3$value[deck3$face == "ace"] <- 14
head(deck3)

# Hearts Game - only hearts have a value

deck4 <- deck
deck4$value <- 0 
head(deck4, 13)

# Assigning a specific value to all heart cards
deck4$suit == "hearts"

deck4$value[deck4$suit == "hearts"] <- 1

deck4$value[deck4$suit == "hearts"]

# Special rule: Queen of Spades gets 13 points
deck4[deck4$face == "queen", ]
deck4[deck4$suit == "spades", ]

# Boolean expression to identify Queen of Spades
deck4$face == "queen" & deck4$suit == "spades"

queenOfSpades <- deck4$face == "queen" & deck4$suit == "spades"
deck4[queenOfSpades, ]

deck4$value[queenOfSpades]
deck4$value[queenOfSpades] <- 13
deck4[queenOfSpades, ]
# Game deck is now ready

# Logical tests
w <- c(-1, 0, 1)
x <- c(5, 15)
y <- "February"
z <- c("Monday", "Tuesday", "Friday")

# Running conditions
w > 0
10 < x & x < 20
y == "February"
all(z %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
             "Saturday", "Sunday"))

# Black Jack Game Setup
deck5 <- deck
head(deck5, 13)

# Updating face card values
facecard <- deck5$face %in% c("king", "queen", "jack")
deck5[facecard, ]
deck5$value[facecard] <- 10
head(deck5, 13)

# Handling Missing Data
NA == 1
c(NA, 1:50)
mean(c(NA, 1:50))

# Ignoring NA values when calculating mean
mean(c(NA, 1:50), na.rm = TRUE)

# Checking for missing values
NA == NA
c(1, 2, 3, NA) == NA
is.na(NA)

vec <- c(1, 2, 3, NA)
is.na(vec)
deck5$value[deck5$face == "ace"] <- NA
head(deck5, 13)