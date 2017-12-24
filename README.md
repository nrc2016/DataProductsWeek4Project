# DataProductsWeek4Project

## Shiny App

This project develops a shiny application and deploys it to the shinyapp.io server.

This App integrates geographical locations with collision data recorded by the State of Maryland. The slider on the right side selects a specific month to display the collision data on the map or an animated sequence can be seen on the map by clicking on the 'play' button. The size of the circle represent the number of collisions that occured in that city. Clicking on a City in Maryland will bring up that city's monthly collisions for 2012.

The App can be accessed at the following location: <a href="https://nrc2016.shinyapps.io/DataProductsWeek4Project/">https://nrc2016.shinyapps.io/DataProductsWeek4Project/</a>

Note: It may take a little time to load.

The App has the following features:

- inputs
    - input$sliderInput
    - input$collisionMap_shape_click
- reactive output
    - collisionMap
    - collisionPlot
    - injuryPlot
    - propDamagePlot
- Documentation included below the App

The data used by the App can be found at <a href= "https://catalog.data.gov/dataset/2012-vehicle-collisions-investigated-by-state-police-4fcd0">"https://catalog.data.gov/dataset/2012-vehicle-collisions-investigated-by-state-police-4fcd0."</a>

## Reproducible Pitch Presentation

The presentation can be seen at the following location:
<a href="https://nrc2016.github.io/DataProductsWeek4Project.html">https://nrc2016.github.io/DataProductsWeek4Project.html</a>

It satisfies the following features:

- 5 pages in length
- markdown conversion to html presentation uses ioslides
- embedded R code for aggregations on Introduction page.

Thank you for your time and I hope you enjoy my submission.
