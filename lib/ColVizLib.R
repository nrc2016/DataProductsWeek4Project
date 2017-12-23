# calculate the radius for the city given a specific month
calculateRadius <- function(month) {
  df <- collision.final[collision.final$month==as.numeric(format(month, "%m")),]

  return(df[,"Collisions"])
}

# calculate the colour of the circles given a specific month
calculateColor <- function(month) {
  df <- collision.final[collision.final$month==as.numeric(format(month, "%m")),]
  df$color <- "blue"
  df[df$Collisions==1, "color"] = "green"
  df[df$Collisions==2, "color"] = "orange"
  df[df$Collisions>=3, "color"] = "red"
  
  return(df[,"color"])
}

# create the city collision plot
createCollisionPlot <- function (input, city) {
  df <- collision.final[collision.final$CITY_NAME==city,]
  return(df %>%
    plot_ly(x=~month.string) %>%
    add_lines(y=~Collisions) %>%
    add_markers(x=~month.string[as.numeric(format(input$month, "%m"))], 
                y=~Collisions[as.numeric(format(input$month, "%m"))],
                marker=list(size=10, color="red")) %>%
    layout(xaxis=list(title="Month", dtick=5),
           yaxis=list(title="Collisions"),
           showlegend=F))
}

# create the city percentage of collisions with injury plot
createInjuryPlot <- function (input, city) {
  return(    collision.final[collision.final$CITY_NAME==city,] %>%
               plot_ly(x=~month.string) %>%
               add_lines(y=~Injury.Percent) %>%
               add_markers(x=~month.string[as.numeric(format(input$month, "%m"))], 
                           y=~Injury.Percent[as.numeric(format(input$month, "%m"))],
                           marker=list(size=10, color="red")) %>%
               layout(xaxis=list(title="Month", dtick=5),
                      yaxis=list(title="Injury (%)", tickformat="%"),
                      showlegend=F)
  )
}

# create the city percentage of collisions with property damage plot
createPropertyDamagePlot <- function (input, city) {
  return(    collision.final[collision.final$CITY_NAME==city,] %>%
               plot_ly(x=~month.string) %>%
               add_lines(y=~Property.Damage.Percent) %>%
               add_markers(x=~month.string[as.numeric(format(input$month, "%m"))], 
                           y=~Property.Damage.Percent[as.numeric(format(input$month, "%m"))],
                           marker=list(size=10, color="red")) %>%
               layout(xaxis=list(title="Month", dtick=5),
                      yaxis=list(title="Property Damage (%)", tickformat="%"),
                      showlegend=F)
  )
}

# locate the closest city to the mouse click on the map
findCityFromClick <- function(input) {
  # initialize the closest city and distance
  closest = 9999999
  closest.city = NULL
  
  # for each city compare to the mouse click location
  for(i in 1:nrow(cities.gps)) {
    # calculate the euclidean distance
    df <- rbind(cities.gps[i,2:3],
                c(input$lng, input$lat))
    d <- dist(df)
    
    # if the distance is closer then save distance and city name
    if(d < closest) {
      closest = d
      closest.city=as.character(cities.gps[i, "name"])
    }
  }

  # return the closest city
  return(closest.city)
}