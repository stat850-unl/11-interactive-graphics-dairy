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
cocktails$url <- paste0("<img src='",cocktails$drink_thumb,"'height=100>",cocktails$drink_thumb,"</img>")

# Define UI for application 
ui <- fluidPage(

     # Application title
    titlePanel("Choose Your Drink!"),

    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs 
        sidebarPanel(
            
            # Inputs ----
            #Checkboxes for category
            checkboxGroupInput("checkGroup",
                               h3("Category of Cocktail"),
                               choices = categoryops
            ),
            
            # br() element to introduce extra vertical spacing 
            br(),
            
            #Search by Ingredient
            h3("Choose your ingredients of interest"),
            # Sidebar with a slider input for number of bins
            selectizeInput(
                'Ingredients', label = "Scroll or Type Entry", choices = ingredients,
                options = list(create = TRUE)
            )
            
        ),
        
        # Main panel for displaying outputs 
        mainPanel(
            
            # Output: Tabset w/ plot, summary, and table 
            tabsetPanel(type = "tabs",
                        tabPanel("Photos", DT::dataTableOutput('mytable')),
                        tabPanel("Custom Recipe Book", tableOutput("tbl"))
            )
            
        )
    )
)


# Define server logic
server = function(input, output) {
    # Make reactive dataset because renderDataTable got mad without it in a reactive statement but I need it to render html
    dat <-  reactive({cocktails %>% 
            dplyr::filter(category %in% input$checkGroup & ingredient %in%input$Ingredients) %>% 
            select(drink,url) %>% distinct(drink,url)
    })
    
    #Make table for photos
    output$mytable <- DT::renderDataTable({
        
        DT::datatable(dat(), escape = FALSE)
    })
    
    #Make table for recipes
    output$tbl <- renderTable({
        cocktails %>% 
            filter(category %in% (input$checkGroup)) %>% 
            select(drink, ingredient, measure)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
