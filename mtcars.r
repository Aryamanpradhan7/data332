# Load required libraries
library(shiny)
library(ggplot2)

### 1. Basic Histogram in Shiny
ui <- fluidPage(
  titlePanel("Basic Histogram in Shiny (Base R)"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      plotOutput("histPlotBase")
    )
  )
)

server <- function(input, output) {
  output$histPlotBase <- renderPlot({
    hist(mtcars$mpg,
         col = rainbow(10),   # Rainbow color applied
         border = "black",
         main = "Histogram of MPG (Base R)",
         xlab = "MPG")
  })
}

shinyApp(ui = ui, server = server)


### 2. Histogram with ggplot2
ui <- fluidPage(
  titlePanel("Histogram with ggplot2 (Rainbow)"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      plotOutput("histPlotGgplot")
    )
  )
)

server <- function(input, output) {
  output$histPlotGgplot <- renderPlot({
    ggplot(mtcars, aes(x = mpg, fill = ..count..)) +
      geom_histogram(color = "black", bins = 10) +
      scale_fill_gradientn(colors = rainbow(7)) +
      labs(title = "Histogram of MPG with Rainbow Fill", x = "MPG", y = "Count") +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)


### 3. Interactive Histogram with Dropdown and Rainbow Colors
ui <- fluidPage(
  titlePanel("Interactive Histogram with ggplot2 & Rainbow"),
  sidebarLayout(
    sidebarPanel(
      selectInput("var", "Choose a Variable:",
                  choices = c("MPG" = "mpg", "Horsepower" = "
