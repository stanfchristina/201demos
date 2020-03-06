# Analysis script for Seattle Airbnb data report.

library(dplyr)
library(leaflet)
library(ggplot2)
library(plotly)
library(htmltools)

data <- read.csv("data/listings.csv", stringsAsFactors = FALSE)

# How many Airbnbs are in Seattle?
total_listings <- nrow(data)

# Average price of an Airbnb in Seattle?
avg_price <- data %>%
  summarise(avg = mean(price)) %>%
  pull(avg)

# How many total reviews have been written?
total_reviews <- data %>%
  pull(number_of_reviews) %>%
  sum()

# I'd like to visualize Airbnb prices in the UDistrict, so 
# let's create a map where a point or "marker" corresponds to a
# listing, where the marker's size is determined by its price.

# First whittle down the original dataset to only consider
# Airbnbs in the UDistrict, and add a column "on_click" so
# that I can see the listing name and host name when I
# click a marker on the map.
udub_data <- data %>%
  filter(neighbourhood == "University District") %>%
  mutate(on_click = paste0(
    "Listing name: ", name, "<br>",
    "Host: ", host_name
  ))

price_map <- leaflet(udub_data) %>%
  addTiles() %>%
  addCircleMarkers(
    radius = ~ (price / 10),
    lat = ~latitude,
    lng = ~longitude,
    stroke = FALSE,
    popup = ~on_click
  )

####################
# CREATING A GRAPH #
####################

# Display neighborhoods on x-axis, and average number
# of reviews for that neighborhood on y-axis.
avg_reviews_graph <- data %>%
  group_by(neighbourhood_group) %>%
  summarise(avg_reviews = mean(number_of_reviews)) %>%
  plot_ly(
    type = "bar",
    x = ~neighbourhood_group,
    y = ~avg_reviews
  ) %>%
  layout(
    title = "Average Number of Reviews per Listing by Neighborhood",
    xaxis = list(
      title = "Neighborhood"
    ),
    yaxis = list(
      title = "Average Number of Reviews per Listing"
    )
  )

# Display neighborhoods on the x-axis, and the maximum listing
# price on the y-axis.
max_price_graph <- data %>%
  group_by(neighbourhood_group) %>%
  summarise(max_price = max(price)) %>%
  ggplot(aes(x = neighbourhood_group, y = max_price)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Neighborhood",
       y = "Maximum Listing Price (USD)")

# Table displaying neighborhoods with their average price.
price_table <- data %>%
  select(neighbourhood, price) %>%
  group_by(neighbourhood) %>%
  summarize(avg_price = mean(price)) %>%
  arrange(-avg_price)
