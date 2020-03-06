library(shiny)

# Use source() to run the `app_ui.R` and `app_server.R` files.
source("app_server.R")
source("app_ui.R")

# Create the Shiny application.
shinyApp(ui = ui, server = server)
