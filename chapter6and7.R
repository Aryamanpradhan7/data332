# chapter 6
# writing deal function
deal <- function(cards) {
  cards[1, ]
}

deal(deck)

# environment
install.packages("devtools")
install.packages("parenvs")
library(devtools)
library(parenvs)

parenvs(all = TRUE)

# working with environments
as.environment("package:stats")

# three environment comes with their own accessor functions
globalenv()
baseenv()
emptyenv()

# looking up environment's parent
parent.env(globalenv())
parent.env(emptyenv())
ls(emptyenv())
ls(globalenv())

# using R’s $ syntax to access an object in a specific environmen
head(globalenv()$deck, 3)

# using assign function to save an object into a particular function
assign("new", "Hello Global", envir = globalenv())
globalenv()$new

# assignment
new
new <- "Hello Active"
new

# creates a quandry for R whenever R runs a function
roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  sum(dice)
}

# evaluation
show_env <- function(){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}

# result will tell the name of the runtime environment
show_env()

environment(show_env)
environment(parenvs)

show_env <- function(){
  a <- 1
  b <- 2
  c <- 3
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}

# this time when we run show_env, R stores a, b, and c in the runtime environment:
show_env()

# R will also put a second type of object in a runtime environment. if a function has arguments, R will copy over each argument to the runtime environment.
foo <- "take me to your runtime"
show_env <- function(x = foo){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}
show_env()

# warmup questions
deal <- function() {
  deck[1, ]
}

# exercise
environment(deal)

# when deal calls deck, R will need to look up the deck object
deal()

# removing the top card
DECK <- deck
deck <- deck[-1, ]
head(deck, 3)

# adding code to deal
deal <- function() {
  card <- deck[1, ]
  deck <- deck[-1, ]
  card
}

# exercise: rewrite the deck <- deck[-1, ] line of deal to assign deck[-1, ] to an object named
# deck in the global environment.

deal <- function() {
  card <- deck[1, ]
  assign("deck", deck[-1, ], envir = globalenv())
  card
}

# now deal will finally clean up the global copy of deck
deal()

shuffle <- function(cards) {
  random <- sample(1:52, size = 52)
  cards[random, ]
}

head(deck, 3)

a <- shuffle(deck)
head(deck, 3)
head(a, 3)

#exercise: rewrite shuffle so that it replaces the copy of deck that lives in the global environment with a shuffled version of DECK, the intact copy of deck that also lives in the global environment.

shuffle <- function(){
  random <- sample(1:52, size = 52)
  assign("deck", DECK[random, ], envir = globalenv())
}

# closures
shuffle()
deal()

# creating a function that takes deck as an argument and saves a copy of deck as DECK
setup <- function(deck) {
  DECK <- deck
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = globalenv())
    card
  }
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = globalenv())
  }
}

# returning DEAL and SHUFFLE
setup <- function(deck) {
  DECK <- deck
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = globalenv())
    card
  }
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = globalenv())
  }
  list(deal = DEAL, shuffle = SHUFFLE)
}

deal <- cards$deal
shuffle <- cards$shuffle

deal
shuffle

environment(deal)
environment(shuffle)

# instead of having each function reference the global environment to update deck, we can have them reference their parent environment at runtime

setup <- function(deck) {
  DECK <- deck
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = parent.env(environment()))
    card
  }
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = parent.env(environment()))
  }
  list(deal = DEAL, shuffle = SHUFFLE)
}
cards <- setup(deck)
deal <- cards$deal
shuffle <- cards$shuffle

# final game
rm(deck)
shuffle()
deal()

# chapter 7
# randomly generate three symbols
get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE,
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

# generating symbols used in slot machine
get_symbols()

# sequential steps

play <- function() {
  # step 1: generate symbols
  symbols <- get_symbols()
  # step 2: display the symbols
  print(symbols)
  # step 3: score the symbols
  score(symbols)
}

# if statements
# example
num <- -1
if (num < 0) {
  print("num is negative.")
  print("Don't worry, I'll fix it.")
  num <- num * -1
  print("Now num is positive.")
}

# else statements
a <- 1
b <- 1
if (a > b) {
  print("A wins!")
} else if (a < b) {
  print("B wins!")
} else {
  print("Tie.")
}


score <- function(symbols) {
  # calculate a prize
  prize
}
symbols <- c("7", "7", "7")

# exercise

symbols
symbols[1] == symbols[2] & symbols[2] == symbols[3]
symbols[1] == symbols[2] & symbols[1] == symbols[3]
all(symbols == symbols[1])

# adding to slot-machine script
same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
if (same) {
  prize <- # look up the prize
} else if ( # Case 2: all bars ) {
  prize <- # assign $5
  } else {
    # count cherries
    prize <- # calculate a prize
  }

# exercise
symbols <- c("B", "BBB", "BB")
symbols[1] == "B" | symbols[1] == "BB" | symbols[1] == "BBB" &
  symbols[2] == "B" | symbols[2] == "BB" | symbols[2] == "BBB" &
  symbols[3] == "B" | symbols[3] == "BB" | symbols[3] == "BBB"

all(symbols %in% c("B", "BB", "BBB"))

# adding this code to our script
same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
bars <- symbols %in% c("B", "BB", "BBB")
if (same) {
  prize <- 
} else if (all(bars)) {
  prize <- 
} else {
  prize <-}

symbols <- c("B", "B", "B")
all(symbols %in% c("B", "BB", "BBB"))

# assigning prize with the following code:
if (same) {
  symbol <- symbols[1]
  if (symbol == "DD") {
    prize <- 800
  } else if (symbol == "7") {
    prize <- 80
  } else if (symbol == "BBB") {
    prize <- 40
  } else if (symbol == "BB") {
    prize <- 5
  } else if (symbol == "B") {
    prize <- 10
  } else if (symbol == "C") {
    prize <- 10
  } else if (symbol == "0") {
    prize <- 0
  }
}

# looking up tables
payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
             "B" = 10, "C" = 10, "0" = 0)
payouts

payouts["DD"]
payouts["B"]


symbols <- c("7", "7", "7")
symbols[1]

payouts[symbols[1]]

symbols <- c("C", "C", "C")
payouts[symbols[1]]

same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
bars <- symbols %in% c("B", "BB", "BBB")
if (same) {
  payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
               "B" = 10, "C" = 10, "0" = 0)
  prize <- unname(payouts[symbols[1]])
} else if (all(bars)) {
  prize <- 
} else {
  prize <- 
}

# case 2
same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
bars <- symbols %in% c("B", "BB", "BBB")
if (same) {
  payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
               "B" = 10, "C" = 10, "0" = 0)
  prize <- unname(payouts[symbols[1]])
} else if (all(bars)) {
  prize <- 5
} else {
  # count cherries
  prize <- # calculate a prize
}

# exercise
# real example
symbols <- c("C", "DD", "C")
symbols == "C"
sum(symbols == "C")
sum(symbols == "DD")


# adding both subtasks to the program skeleton
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
  prize <- # calculate a prize
}
diamonds <- sum(symbols == "DD")
# double the prize if necessary

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
  prize <- c(0, 2, 5)[cherries + 1]
}
diamonds <- sum(symbols == "DD")

# exercise

# writing a method for adjusting prize based on diamonds. 

prize * 2 ^ diamonds
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
  prize <- c(0, 2, 5)[cherries + 1]
}

diamonds <- sum(symbols == "DD")
prize * 2 ^ diamonds

# code comments
# identify case
same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
bars <- symbols %in% c("B", "BB", "BBB")
# get prize
if (same) {
  payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
               "B" = 10, "C" = 10, "0" = 0)
  prize <- unname(payouts[symbols[1]])
} else if (all(bars)) {
  prize <- 5
} else {
  cherries <- sum(symbols == "C")
  prize <- c(0, 2, 5)[cherries + 1]
}
# adjust for diamonds
diamonds <- sum(symbols == "DD")
prize * 2 ^ diamonds

score <- function (symbols) {
  # identify case
  same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
  bars <- symbols %in% c("B", "BB", "BBB")
  # get prize
  if (same) {
    payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[symbols[1]])
  } else if (all(bars)) {
    prize <- 5
  } else {
    cherries <- sum(symbols == "C")
    prize <- c(0, 2, 5)[cherries + 1]
  }
  # adjust for diamonds
  diamonds <- sum(symbols == "DD")
  prize * 2 ^ diamonds
}

play <- function() {
  symbols <- get_symbols()
  print(symbols)
  score(symbols)
}

play()
