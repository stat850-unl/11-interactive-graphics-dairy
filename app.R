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
library(ggplot2)

#Put data in
cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
ingredients<-unique(cocktails$ingredient)
categoryops<-unique(cocktails$category)
cocktails$url <- paste0("<img src='",cocktails$drink_thumb,"'height=100>",cocktails$name,"</img>")

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
                               choices = categoryops),

            # br() element to introduce extra vertical spacing
            br(),

            #Search by Ingredient
            h3("Choose your ingredients of interest"),
            # Sidebar with a slider input for number of bins
            selectInput(
                "Ingredients", label = "Scroll or Type Entry", choices = ingredients,
                #options = list(create = TRUE),
                multiple = T
            )

        ),

        # Main panel for displaying outputs
        mainPanel(

            # Output: Tabset w/ plot, summary, and table
            tabsetPanel(type = "tabs",
                        tabPanel("Freqency of Ingredients", plotOutput("plot")),
                        tabPanel("Recipes", DT::dataTableOutput('mytable'), "Custom Recipe Book", DT::dataTableOutput("tbl"))
            )

        )
    )
)


# Define server logic
server = function(input, output, session) {
     observe({
         x <- input$checkGroup

# Adding session to server function removed ingredient options

         # Can use character(0) to remove all choices
         if (is.null(x))
             x <- character(0)


         # Can also set the label and select items
         updateSelectInput(session, "inSelect",
                           label = paste("Select input label", length(x)),
                           choices = x,
                           selected = tail(x, 1)
         )
     })

    # Make reactive dataset because renderDataTable got mad without it in a reactive statement but I need it to render html
    dat <-
        reactive({cocktails %>%
                dplyr::filter(category %in% input$checkGroup & ingredient %in%input$Ingredients) %>%
                select(drink,url) %>% distinct(drink,url)
        })

    dat2 <-  reactive({
        # This outputs instructions when conditions aren't met
        validate(need(length(input$checkGroup) > 0, "Select a cocktail type"))

        cocktails %>%
            dplyr::filter(category %in% input$checkGroup) %>%
            select(drink,ingredient,ingredient_number) %>%
            count(ingredient) %>%
            # mutate(freq = n/sum(n)) %>%
            arrange(desc(n)) %>%
            mutate(ingredient = factor(ingredient, levels = rev(ingredient))) %>%
            filter(row_number() <= 15)
    })
    # #Make graph for ingredient frequency
    output$plot <- renderPlot({
        ggplot(dat2(),aes(x=ingredient,y=n)) +
            ylab("Number of Recipes") +
            xlab("") +
            geom_col() +
            coord_flip() +
            theme(axis.text.x = element_text(vjust = 0.5, hjust=1)) +
            ggtitle("Most Common Ingredients")
    })


    #Make table for photos
    output$mytable <- DT::renderDataTable({

        DT::datatable(dat(), escape = FALSE)
    })

    #Make table for recipes
    output$tbl <- DT::renderDataTable({
        s = input$mytable_rows_selected
        s2 <- dat()$drink[s]
        cocktails %>%
            dplyr::filter(drink %in% s2) %>%
            select(drink, ingredient, measure)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
