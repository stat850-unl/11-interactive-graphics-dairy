

library(shiny)
library(DT)
library(dplyr)

#Put data in
cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
ingredients<-unique(cocktails$ingredient)
categoryops<-unique(cocktails$category)
cocktails$url <- paste0("<img src='",cocktails$drink_thumb,"'height=100>",cocktails$drink_thumb,"</img>")
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
      DT::dataTableOutput('mytable')
    )
  ))

dat <-cocktails %>% 
  filter(category %in% (input$checkGroup)) %>% select(drink,url)


server <- function(input, output){
  output$mytable <- DT::renderDataTable({

    DT::datatable(dat, escape = FALSE) # HERE
  })

}

shinyApp(ui = ui, server = server)
