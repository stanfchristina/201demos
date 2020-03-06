library(dplyr)
library(leaflet)

# Returns a leaflet map given a dataframe, variable of interest in the dataframe,
# neighborhood to display, and a specified color for the map markers.
build_map <- function(data, variable, neighborhood, marker_color) {
  annotated_data <- data %>%
    filter(neighbourhood == neighborhood) %>%
    mutate(on_click = paste0(
      "Listing: ", name, "<br>",
      "Host: ", host_name
    ))
  
  map <- leaflet(annotated_data) %>%
    addTiles() %>%
    addCircleMarkers(
      radius = ~(log2(annotated_data[[variable]])), # log2 to prevent the markers from being too large
      lat = ~latitude, # Specify where to place the marker
      lng = ~longitude,
      stroke = FALSE,
      fillOpacity = 0.5,
      color = ~marker_color,
      popup = ~on_click # Show the listing & host info when we click on the circle
    )
  
  return(map)
}
  