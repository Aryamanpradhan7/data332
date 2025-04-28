# ------------------------------------------
# Speed Optimization: Vectorized vs Loops
# ------------------------------------------

# Function using a loop to take absolute values
abs_loop <- function(vec) {
  for (i in 1:length(vec)) {
    if (vec[i] < 0) {
      vec[i] <- -vec[i]
    }
  }
  vec
}

# Function using vectorization
abs_sets <- function(vec) {
  negs <- vec < 0
  vec[negs] <- vec[negs] * -1
  vec
}

# Test performance
long <- rep(c(-1, 1), 5000000)
system.time(abs_loop(long))
system.time(abs_sets(long))
system.time(abs(long))  # Built-in

# ------------------------------------------
# Logical Testing
# ------------------------------------------

vec <- c(1, -2, 3, -4, 5, -6, 7, -8, 9, -10)

vec < 0
vec[vec < 0]
vec[vec < 0] * -1

# ------------------------------------------
# Symbol Replacement: Slow Loop vs Fast Vectorization
# ------------------------------------------

change_symbols <- function(vec) {
  for (i in 1:length(vec)) {
    if (vec[i] == "DD") {
      vec[i] <- "joker"
    } else if (vec[i] == "C") {
      vec[i] <- "ace"
    } else if (vec[i] == "7") {
      vec[i] <- "king"
    } else if (vec[i] == "B") {
      vec[i] <- "queen"
    } else if (vec[i] == "BB") {
      vec[i] <- "jack"
    } else if (vec[i] == "BBB") {
      vec[i] <- "ten"
    } else {
      vec[i] <- "nine"
    }
  }
  vec
}

# Example
vec <- c("DD", "C", "7", "B", "BB", "BBB", "0")
change_symbols(vec)

many <- rep(vec, 1000000)
system.time(change_symbols(many))

# Vectorized replacement
change_vec <- function(vec) {
  vec[vec == "DD"]  <- "joker"
  vec[vec == "C"]   <- "ace"
  vec[vec == "7"]   <- "king"
  vec[vec == "B"]   <- "queen"
  vec[vec == "BB"]  <- "jack"
  vec[vec == "BBB"] <- "ten"
  vec[vec == "0"]   <- "nine"
  vec
}

system.time(change_vec(many))

# Using lookup table
change_vec2 <- function(vec) {
  lookup <- c("DD" = "joker", "C" = "ace", "7" = "king",
              "B" = "queen", "BB" = "jack", "BBB" = "ten", "0" = "nine")
  unname(lookup[vec])
}

system.time(change_vec2(many))

# ------------------------------------------
# Fast vs Slow Loops
# ------------------------------------------

# Good practice: Preallocate memory
system.time({
  output <- rep(NA, 1000000)
  for (i in 1:1000000) {
    output[i] <- i + 1
  }
})

# Bad practice: No preallocation
system.time({
  output <- NA
  for (i in 1:1000000) {
    output[i] <- i + 1
  }
})

# ------------------------------------------
# Slot Machine Simulation
# ------------------------------------------

# Random symbols for slot machine
get_many_symbols <- function(n) {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  vec <- sample(wheel, size = 3 * n, replace = TRUE,
                prob = c(0.03, 0.03, 0.06, 0.10, 0.25, 0.01, 0.52))
  matrix(vec, ncol = 3)
}

# Scoring function
score_many <- function(symbols) {
  cherries <- rowSums(symbols == "C")
  diamonds <- rowSums(symbols == "DD")
  
  prize <- c(0, 2, 5)[cherries + diamonds + 1]
  prize[!cherries] <- 0
  
  same <- symbols[, 1] == symbols[, 2] & symbols[, 2] == symbols[, 3]
  payoffs <- c("DD" = 100, "7" = 80, "BBB" = 40,
               "BB" = 25, "B" = 10, "C" = 10, "0" = 0)
  prize[same] <- payoffs[symbols[same, 1]]
  
  bars <- symbols %in% c("B", "BB", "BBB")
  all_bars <- bars[, 1] & bars[, 2] & bars[, 3] & !same
  prize[all_bars] <- 5
  
  two_wilds <- diamonds == 2
  one <- two_wilds & symbols[, 1] != symbols[, 2] & symbols[, 2] == symbols[, 3]
  two <- two_wilds & symbols[, 1] != symbols[, 2] & symbols[, 1] == symbols[, 3]
  three <- two_wilds & symbols[, 1] == symbols[, 2] & symbols[, 2] != symbols[, 3]
  
  prize[one] <- payoffs[symbols[one, 1]]
  prize[two] <- payoffs[symbols[two, 2]]
  prize[three] <- payoffs[symbols[three, 3]]
  
  one_wild <- diamonds == 1
  wild_bars <- one_wild & (rowSums(bars) == 2)
  prize[wild_bars] <- 5
  
  one <- one_wild & symbols[, 1] == symbols[, 2]
  two <- one_wild & symbols[, 2] == symbols[, 3]
  three <- one_wild & symbols[, 3] == symbols[, 1]
  
  prize[one] <- payoffs[symbols[one, 1]]
  prize[two] <- payoffs[symbols[two, 2]]
  prize[three] <- payoffs[symbols[three, 3]]
  
  unname(prize * 2^diamonds)
}

# Define a single play
play <- function() {
  symbols <- get_many_symbols(1)
  score_many(symbols)
}

# Play many times
play_many <- function(n) {
  symb_mat <- get_many_symbols(n)
  data.frame(w1 = symb_mat[, 1],
             w2 = symb_mat[, 2],
             w3 = symb_mat[, 3],
             prize = score_many(symb_mat))
}

# ------------------------------------------
# Run Simulation
# ------------------------------------------

# Example symbols
symbols <- matrix(c("DD", "DD", "DD",
                    "C", "DD", "0",
                    "B", "B", "B",
                    "B", "BB", "BBB",
                    "C", "C", "0",
                    "7", "DD", "DD"), nrow = 6, byrow = TRUE)

symbols

# Run a simulation: 10 million plays
system.time(play_many(10000000))

# Simulate winnings manually
winnings <- vector(length = 1000000)
system.time(
  for (i in 1:1000000) {
    winnings[i] <- play()
  }
)

mean(winnings)
