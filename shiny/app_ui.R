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
  br(),
  h4("Introduction"),
  p("Select your favorite Seattle neighborhood to see where Airbnbs are being rented."),
  br(),
  h4("Insights"),
  p("Some insights...")
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
  # Notice this is a plotOutput() not a plotlyOutput() because we used ggplot.
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

introduction_panel <- tabPanel(
  "Introduction",
  mainPanel(
    h2("Demo Introduction"),
    p("I made this because when I was learning Shiny there were way too many examples
      I found that didn't make a lot of sense and differed greatly from each other in how
      they setup the UI, organized layout elements, linked stylesheets, etc. I tried to make
      this demo super clean and as easy to follow along with as possible. Hope it helps!"),
    br(),
    # How to include an image on a page.
    # The image must be in the www/ directory for Shiny to find it.
    img(description = "UW symbol",
        src = "uw.png",
        align = "left",
        width = "256px",
        height = "164px")
  )
)

# Put each tab panel together on a common navbar.
# Provide the theme parameter with the name of our stylesheet
# to apply custom styles throughout the application.

ui <- navbarPage(
  theme = "styles.css",
  "Section Demo",
  introduction_panel,
  map_tab_panel,
  bar_tab_panel,
  scatter_tab_panel
)
