library(shiny)


app_base_dir <- getwd()

source(paste0(app_base_dir, "/my_ui.R"))
source(paste0(app_base_dir, "/my_server.R"))


shinyApp(myui, myserver)