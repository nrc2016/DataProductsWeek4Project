library(shiny)
library(leaflet)
library(plotly)

source("lib/ColVizLib.R")

# load data sets
load("data/cities.gps.RObject")
load("data/collision.final.RObject")

# preprocessing for months
months.string <- c("January", "February", "March", "April", "May", "June",
                   "July", "September", "October", "November", "December")

collision.final$month.string  = "January"
collision.final[collision.final$month==2, "month.string"] = "February"
collision.final[collision.final$month==3, "month.string"] = "March"
collision.final[collision.final$month==4, "month.string"] = "April"
collision.final[collision.final$month==5, "month.string"] = "May"
collision.final[collision.final$month==6, "month.string"] = "June"
collision.final[collision.final$month==7, "month.string"] = "July"
collision.final[collision.final$month==8, "month.string"] = "August"
collision.final[collision.final$month==9, "month.string"] = "September"
collision.final[collision.final$month==10, "month.string"] = "October"
collision.final[collision.final$month==11, "month.string"] = "November"
collision.final[collision.final$month==12, "month.string"] = "December"

collision.final$month.string = factor(collision.final$month.string, 
                                      levels=c("January", "February", "March", "April",
                                               "May", "June", "July", "August", "September",
                                               "October", "November", "December"))

# server functionality
server <- function (input, output) {
  # initialize reactive values
  rv <- reactiveValues(city="Aberdeen")
  
  # render static map
  output$collisionMap <- renderLeaflet({
    leaflet(cities.gps) %>%
      addProviderTiles(providers$OpenStreetMap) %>%
      fitBounds(~min(lng), ~min(lat), ~max(lng), ~max(lat))
  })
  
  # determine city that was clicked
  observeEvent(input$collisionMap_shape_click, {
    rv$city=findCityFromClick(input$collisionMap_shape_click)
  })
  
  # overlay selected city marker and circles for determining the number of collisions
  observe({
    proxy <- leafletProxy("collisionMap", data=cities.gps)
    
    proxy %>%
      clearShapes() %>%
      clearMarkers() %>%
      addCircles(lng=~lng,
                 lat=~lat,
                 radius=2000 * calculateRadius(input$month),
                 color=calculateColor(input$month),
                 fillColor=calculateColor(input$month),
                 label=~name) %>%
      addMarkers(lng=cities.gps[cities.gps$name==rv$city,"lng"],
                 lat=cities.gps[cities.gps$name==rv$city,"lat"])
  })
  
  # change the text to the selected city
  output$City <- renderText({
    paste("City:", rv$city)
  }) 
  
  # create plot for the number of city collisions per month
  output$collisionPlot <- renderPlotly({
    p <- createCollisionPlot(input, rv$city)
    p$elementId <- NULL
    
    p
  })
  
  # create plot for the percentage of collisions with injuries per month in the city
  output$injuryPlot <- renderPlotly({
    p <- createInjuryPlot(input, rv$city)
    p$elementId <- NULL
    
    p
  })
  
  # create plot for the percentage of collisions with property damage per
  # month in the city
  output$propDamagePlot <- renderPlotly({
    p <- createPropertyDamagePlot (input, rv$city)
    p$elementId <- NULL
    
    p
  })
}