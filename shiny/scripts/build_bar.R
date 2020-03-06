library(dplyr)
library(plotly)
library(stringr)

# Returns a plotly barchart given a dataframe, variable of interest to plot
# against a neighborhood, and specified color for the bars.

# !!rlang::sym(variable) is a dumb hack to get around R not properly
# passing in input$bar_variable as a String/character to this function.
# Not quite sure why this occurs with Shiny apps, but if you run into
# problems using dplyr with your function parameters it's worth a try.
# (same thing with using as.character() to get the color)
build_bar <- function(data, variable, color) {
  color <- as.character(color)

  bar_chart <- data %>%
    group_by(neighbourhood_group) %>%
    summarise(avg = mean(!!rlang::sym(variable))) %>%
    plot_ly(
      type = "bar",
      x = ~neighbourhood_group,
      y = ~avg,
      color = I(color)
    ) %>%
    layout(
      xaxis = list(
        title = "Neighborhood"
      ),
      yaxis = list(
        title = paste("Average", str_to_title(variable))
      )
    )
  
  return(bar_chart)
}
