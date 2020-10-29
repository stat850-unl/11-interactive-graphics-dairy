server <- function(input, output) {recipes <- reactive({
  cocktails %>%
    group_by(drink) %>%
    select(drink, ingredient, measure) %>%
    summarise("Midnight Cowboy")
})
output$table1 <- renderTable({recipes()
})
}

