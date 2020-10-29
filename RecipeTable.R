library(shiny)
library(tidyverse)

ui <- fluidPage(

  selectInput(inputId = "choice",
              label = "Select drink",
              choices = names(cocktails$drink),
              selected = c("'57 Chevy with a White License Plate")),

  tableOutput(outputId = "recipe")
)

server <- function(input, output) {
  recipe <- reactive({
    req(input$choice)
    cocktails %>% group_by(!! sym(input$choice)) %>% select(drink, ingredient, measure) %>% summarise(recipe = n())
  })

  # Headcount
  output$fund <- renderTable({
    recipe()
  })
}

shinyApp(ui = ui, server = server)

