#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DBI)
library(RPostgres)
library(glue)
library(inlmisc)
library(rgdal)
library(rgeos)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$map <- renderLeaflet({
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
    }
    )
    
    output$selected_var <- renderText({ 
        paste("You have selected", input$var)
    })
    
    output$min_max <- renderText({ 
        paste("You have chosen a range that goes from",
              input$range[1], "to", input$range[2])
    })
    
})
