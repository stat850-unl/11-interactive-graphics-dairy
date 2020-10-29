#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

#Put data in
cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
ingredients<-unique(cocktails$ingredient)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Choose Your Drink!"),


    checkboxGroupInput("checkGroup",
                       h3("Category of Cocktail"),
                       choices = list("Cocktail" = 1,
                                      "Shot" = 2,
                                      "Beer" = 3,
                                      "Milk / Float / Shake" = 4,
                                      "Ordinary Drink" = 5,
                                      "Homemade Liqueur" = 6,
                                      "Punch / Party Drink" = 7,
                                      "Coffee / Tea" = 8,
                                      "Soft Drink / Soda" = 9,
                                      "Cocoa" = 10,
                                      "Other/Unknown" = 11)
    ),

    h3("Choose your ingredients of interest"),
    # Sidebar with a slider input for number of bins
    selectizeInput(
        'Ingredients', label = "Ingredients", choices = ingredients,
        options = list(create = TRUE)
    )
)



# Define server logic
server <- function(input, output, session) {

        
    }



# Run the application
shinyApp(ui = ui, server = server)
