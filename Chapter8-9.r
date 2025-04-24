# 1. Function to get random symbols
get_symbols <- function() {
  symbols <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  probabilities <- c(0.03, 0.03, 0.06, 0.1, 0.25, 0.25, 0.28)
  sample(symbols, size = 3, replace = TRUE, prob = probabilities)
}

# 2. Function to score the symbols
score <- function(symbols) {
  same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
  bars <- symbols %in% c("B", "BB", "BBB")
  
  if (same) {
    payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25, 
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[symbols[1]])
  } else if (all(bars)) {
    prize <- 5
  } else {
    cherries <- sum(symbols == "C")
    prize <- c(0, 2, 5)[cherries + 1]  # cherries + 1 to index
  }
  
  diamonds <- sum(symbols == "DD")
  final_prize <- prize * 2 ^ diamonds
  return(final_prize)
}

# 3. Function to play one round
play <- function() {
  symbols <- get_symbols()
  print(symbols)
  prize <- score(symbols)
  cat("You won", prize, "points!\n")
  return(prize)
}

# Optional: set seed for consistent output
set.seed(123)

# Play a few rounds!
play()
play()
play()
