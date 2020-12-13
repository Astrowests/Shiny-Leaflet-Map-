#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

m <- leaflet(options = leafletOptions())%>%
    setView(lat = -7.78818672144489, lng = 110.36432939487459,zoom = 9) %>% 
    addTiles() %>% 
    addMarkers(lat = -7.78818672144489,lng = 110.36432939487459 )


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel("Data Kegiatan Gereja beserta penyebaran UKK di"),
    sidebarLayout(
        sidebarPanel(width = '100%',m),
        mainPanel = mainPanel()
    ),
    
    sidebarLayout(
        position = "right", 
        sidebarPanel(width = 4,
            helpText("Create demographic maps with 
               information from the 2010 US Census."),
            
            selectInput("var", 
                        label = "Choose a variable to display",
                        choices = c("Percent White", 
                                    "Percent Black",
                                    "Percent Hispanic", 
                                    "Percent Asian"),
                        selected = "Percent White"),
            
            sliderInput("range", 
                        label = "Range of interest:",
                        min = 0, max = 100, value = c(0, 100))
        ),

        
        mainPanel(
            textOutput("selected_var"),
            textOutput("min_max")
        )
    )
    
))
