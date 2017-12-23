library(shiny)
library(leaflet)
library(plotly)

source("lib/ColVizLib.R")

# server functionality
server <- function (input, output) {
  # initialize reactive values
  rv <- reactiveValues(city="Aberdeen",
                       cities.gps=NULL,
                       collition.final=NULL,
                       months.string=NULL)

  rv$cities.gps <- read.csv("data/cities.gps.csv")
  rv$collision.final <- read.csv("data/collision.final.csv")
  rv$months.string <- c("January", "February", "March", "April", "May", "June",
      "July", "September", "October", "November", "December") 
  
  # render static map
  output$collisionMap <- renderLeaflet({
    leaflet(rv$cities.gps) %>%
      addProviderTiles(providers$OpenStreetMap) %>%
      fitBounds(~min(lng), ~min(lat), ~max(lng), ~max(lat))
  })
  
  # determine city that was clicked
  observeEvent(input$collisionMap_shape_click, {
    rv$city=findCityFromClick(input$collisionMap_shape_click,
                              rv$cities.gps)
  })

  # overlay selected city marker and circles for determining the number of collisions
  observe({
    proxy <- leafletProxy("collisionMap", data=rv$cities.gps)

    proxy %>%
      clearShapes() %>%
      clearMarkers() %>%
      addCircles(lng=~lng,
                 lat=~lat,
                 radius=2000 * calculateRadius(input$month, rv$collision.final),
                 color=calculateColor(input$month, rv$collision.final),
                 fillColor=calculateColor(input$month, rv$collision.final),
                 label=~name) %>%
      addMarkers(lng=rv$cities.gps[rv$cities.gps$name==rv$city,"lng"],
                 lat=rv$cities.gps[rv$cities.gps$name==rv$city,"lat"])
  })

  # change the text to the selected city
  output$City <- renderText({
    paste("City:", rv$city)
  })

  # create plot for the number of city collisions per month
  output$collisionPlot <- renderPlotly({
    rv$collision.final$month.string <- factor(rv$collision.final$month.string,
                                                        levels=c("January", "February", "March", "April",
                                                                 "May", "June", "July", "August", "September",
                                                                 "October", "November", "December"))
    
    p <- createCollisionPlot(input, rv$city, rv$collision.final)
    p$elementId <- NULL

    p
  })

  # create plot for the percentage of collisions with injuries per month in the city
  output$injuryPlot <- renderPlotly({
    p <- createInjuryPlot(input, rv$city, rv$collision.final)
    p$elementId <- NULL

    p
  })

  # create plot for the percentage of collisions with property damage per
  # month in the city
  output$propDamagePlot <- renderPlotly({
    p <- createPropertyDamagePlot (input, rv$city, rv$collision.final)
    p$elementId <- NULL

    p
  })
}