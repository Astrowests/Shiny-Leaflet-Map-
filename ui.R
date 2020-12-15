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

library(DBI)
library(RPostgres)
library(glue)

database <- dbConnect(drv = Postgres(),user='asehbulwsrcsmr',password='42c67e62a08d87402c1218a7451b1a0216f6018c5a1e2d87eb0ec884b1d24add',host='ec2-52-22-238-188.compute-1.amazonaws.com',port=5432,dbname='d25mhv2io94ahk')


dataframe <- dbGetQuery(database,"select namagedunggereja,lokasigedunggereja,namakating,nowa,namajeniskegiatan,jadwalgerejawi,latitudegedunggereja,longitudegedunggereja from gerejawi inner join kating on kating.idkating = gerejawi.idkating inner join gedunggereja
on gedunggereja.idgedunggereja=gerejawi.idgedunggereja inner join jeniskegiatan on jeniskegiatan.idjeniskegiatan = gerejawi.idjeniskegiatan
")

for (a in unique(dataframe$namagedunggereja)) {
    temp <- dataframe[dataframe$namagedunggereja==a,]
    popup <- glue("<b>{temp$namagedunggereja}</b><br>
                <a>wa.me/{temp$nowa[1]}</a>
                {temp$namajeniskegiatan[1]} : {temp$jadwalgerejawi[1]} ,<br>
                {temp$namajeniskegiatan[2]} : {temp$jadwalgerejawi[2]} ,<br>
               {temp$namajeniskegiatan[3]} : {temp$jadwalgerejawi[3]} ,<br>
               {temp$namajeniskegiatan[4]} : {temp$jadwalgerejawi[4]} ,<br>
               {temp$namajeniskegiatan[5]} : {temp$jadwalgerejawi[5]}")
    m <- leaflet()%>%
        addTiles() %>% 
        setView(lng = unique(temp$longitudegedunggereja),lat = unique(temp$latitudegedunggereja), zoom = 12) %>% 
        addMarkers(popup = unique(popup),clusterOptions = markerClusterOptions(),group ="markers",label =  unique(temp$namagedunggereja),icon =makeIcon("~/UKK UTY/Map Project/mapsku/mapsku/salib.png",iconWidth = 40,iconHeight = 40),lng = unique(temp$longitudegedunggereja),lat = unique(temp$latitudegedunggereja)) %>% 
        addPopups(popup = "Click mee twice",lng = unique(temp$longitudegedunggereja),lat = unique(temp$latitudegedunggereja)) %>% 
        inlmisc::AddSearchButton(group = "markers",textPlaceholder = "Nama Gereja") 
    
}
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
            textOutput("min_max"),
            
        )
    )
    
))
