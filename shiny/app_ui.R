library(leaflet)
library(ggplot2)
library(plotly)

# Setup map UI elements.

map_sidebar_panel <- sidebarPanel(
  selectInput(
    # "map_neighborhood" exactly corresponds to "input$map_neighborhood" in app_server.R
    inputId = "map_neighborhood",
    label = "Seattle Neighborhood",
    choices = unique(airbnb_data$neighbourhood)
  ),
  radioButtons(
    inputId = "map_variable",
    label = "Marker Indicator",
    # "price" and "number_of_reviews" exactly correspond to columns found in airbnb_data
    choices = list("Price" = "price", "Number of Reviews" = "number_of_reviews")
  ),
  radioButtons(
    inputId = "map_color",
    label = "Marker Color",
    # "red", "blue", "green" are accepted leaflet color values
    choices = list("Red" = "red", "Blue" = "blue", "Green" = "green")
  )
)

map_main_panel <- mainPanel(
  # "seattle_map" exactly corresponds to "output$seattle_map" in app_server.R
  leafletOutput("seattle_map"),
  # One way to add analysis text underneath your visualizations.
  HTML("<p>Select your favorite Seattle neighborhood and see where Airbnbs are being rented.</p>
        <br>
        <p>Some insights...</p>"
  )
)

map_tab_panel <- tabPanel(
  "Mapping Airbnbs", # Set the label on the tab
  titlePanel("Airbnbs in Seattle Neighborhoods"), # Set the title for this page
  sidebarLayout( # Put the two panels together in a common layout
    map_sidebar_panel,
    map_main_panel
  )
)

# Setup barchart UI elements.

bar_sidebar_panel <- sidebarPanel(
  selectInput(
    inputId = "bar_variable",
    label = "Y-Axis Statistic",
    choices = list("Average Price" = "price", "Average Number of Reviews" = "number_of_reviews")
  ),
  selectInput(
    inputId = "bar_color",
    label = "Bar Color",
    choices = list("Blue" = "blue", "Green" = "green", "Orange" = "orange")
  )
)

bar_main_panel <- mainPanel(
  plotlyOutput("neighborhood_bar")
)

bar_tab_panel <- tabPanel(
  "Neighborhood Stats",
  titlePanel("AirBnb Stats by Seattle Neighborhood"),
  sidebarLayout(
    bar_sidebar_panel,
    bar_main_panel
  )
)

# Setup scatterplot UI elements.

scatter_sidebar_panel <- sidebarPanel(
  selectInput(
    inputId = "scatter_variable",
    label = "Y-Statistic to Display",
    choices = list("Number of Reviews" = "number_of_reviews", "Availability" = "availability_365")
  ),
  selectInput(
    inputId = "scatter_point_shape",
    label = "Point Shape",
    choices = list("Circle Outline" = 1,
                   "Triangle Outline" = 2,
                   "Solid Diamond" = 18,
                   "Solid Circle" = 16)
  )
)

scatter_main_panel <- mainPanel(
  plotOutput("price_scatter")
)

scatter_tab_panel <- tabPanel(
  "Price Effects",
  titlePanel("How Price Affects Airbnbs"),
  sidebarLayout(
    scatter_sidebar_panel,
    scatter_main_panel
  )
)

# Put each tab panel together on a common navbar.
# Wrap navbarPage in a tagList() so we can apply custom
# styles we defined in styles.css to the entire application.
# If you don't need styling, omit and just set ui <- navbarPage(...)

ui <- tagList(
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")),
  navbarPage(
    "Section Demo",
    map_tab_panel,
    bar_tab_panel,
    scatter_tab_panel
  )
)
