#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(dplyr)

#Put data in
cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
ingredients<-unique(cocktails$ingredient)
categoryops<-unique(cocktails$category)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Choose Your Drink!"),

fluidRow(
    column(
        width = 3,
        checkboxGroupInput("checkGroup",
                           h3("Category of Cocktail"),
                           choices = categoryops
        ),
        
        h3("Choose your ingredients of interest"),
        # Sidebar with a slider input for number of bins
        selectizeInput(
            'Ingredients', label = "Ingredients", choices = ingredients,
            options = list(create = TRUE)
        )
    ),
    column(
        width =9,
        tableOutput('tbl')
    )
))


# Define server logic
server = function(input, output) {

    # Headcount
    output$tbl <- renderTable({
            cocktails %>% 
            filter(category %in% (input$checkGroup)) %>% 
            select(drink, ingredient, measure)
        #%>% 
            # summarise(recipe = n())
    })
    
}


# Run the application
shinyApp(ui = ui, server = server)
