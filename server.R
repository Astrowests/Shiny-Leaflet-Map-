#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$selected_var <- renderText({ 
        paste("You have selected", input$var)
    })
    
    output$min_max <- renderText({ 
        paste("You have chosen a range that goes from",
              input$range[1], "to", input$range[2])
    })
    
})
