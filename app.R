library(shiny)

base_dir <- getwd()

source(paste0(base_dir, "/my_ui.R"))
source(paste0(base_dir, "/my_server.R"))


shinyApp(myui, myserver)