library(dplyr)
library(ggplot2)

# Returns a ggplot scatterplot given a dataframe, variable of interest to plot against price,
# and a specified shape for the points.
build_scatter <- function(data, variable, point_shape) {
  # Need to cast to character, then back to number since the point_shape parameter gets its
  # type "corrupted" somehow by Shiny from its original input$scatter_point_shape type.
  point_shape_num <- as.numeric(as.character(point_shape))
  
  scatter <- data %>%
    ggplot(aes(x = price, y = data[[variable]])) +
    geom_point(shape = point_shape_num) + 
    labs(x = "Price",
         y = variable)
             
  return(scatter)
}
