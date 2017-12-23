library(shiny)
library(leaflet)

# creaet the Shiny UI
ui <- fluidPage (
  
  # title
  headerPanel("Collisons in Maryland 2012"),
  
  # map panel
  mainPanel(width=8,  
    leafletOutput("collisionMap", height=600)),
  
  # time line and supplimental data (# of collisions, % injury, and % property damage)
  sidebarPanel(width=4,
               sliderInput("month", label="Month",
                             min=as.Date("2012-01-01"),
                             max=as.Date("2012-12-01"),
                             value=as.Date("2012-01-01"), 
                             timeFormat="%b %Y",
                             step=31,
                           animate = TRUE),
               textOutput("City"),
               plotlyOutput("collisionPlot", height=150),
               plotlyOutput("injuryPlot", height=150),
               plotlyOutput("propDamagePlot", height=150)  ),
  
  # app description 
  p("This App integrates geographical locations with collision data 
    recorded by the State of Maryland. The slider on the right side
    selects a specific month to display the collision data on the map
    or an animated sequence can be seen on the map by clicking on the
    'play' button. The size of the circle represent the number of 
    collisions that occured in that city. Clicking on a City in 
    Maryland will bring up that city's monthly collisions for 2012."),
  
  p("The data used by the App can be found at",
  a(href="https://catalog.data.gov/dataset/2012-vehicle-collisions-investigated-by-state-police-4fcd0",
            "https://catalog.data.gov/dataset/2012-vehicle-collisions-investigated-by-state-police-4fcd0."))

)
