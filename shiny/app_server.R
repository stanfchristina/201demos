# Load our scripts that contain functions to build our visualizations.
# Do this first!
source("./scripts/build_map.R")
source("./scripts/build_bar.R")
source("./scripts/build_scatter.R")

# Create our relevant dataframes, which we'll pass into our visualization-building functions.
# By doing it here, we only have to read them in once which will speed up our application 
# (versus loading the data in each script).
airbnb_data <- read.csv("./data/listings.csv", stringsAsFactors = FALSE)

server <- function(input, output) { 
  
  # Render a leaflet map.
  output$seattle_map <- renderLeaflet({ 
    return(build_map(airbnb_data, input$map_variable, input$map_neighborhood, input$map_color))
  }) 
  
  # Render a bar chart.
  output$neighborhood_bar <- renderPlotly({
    return(build_bar(airbnb_data, input$bar_variable, input$bar_color))
  })
  
  # Render a scatterplot.
  output$price_scatter <- renderPlot({
    return(build_scatter(airbnb_data, input$scatter_variable, input$scatter_point_shape))
  })
}
