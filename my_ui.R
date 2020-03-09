library(shiny)

ui_base_directory <- paste0(getwd(), "/uis")


# TODO: source your ui .R file here, make sure to put it in the /uis directory.
source(paste0(ui_base_directory, "/page5_ui.R"))
source(paste0(ui_base_directory, "/page1_ui.R"))

home_page <- fluidPage(
  "This is a place holder for the home page"
)

home <- tabPanel(
  "Home",
  home_page
)

# TODO: For your question, change page# to the title of your question which will be put in the
# tab bar. Then:
# substitute home_page with your own layout in your own file. Remember to name it differently
# from others. eg. page1_ui
page1 <- tabPanel(
  "page1",
  page1
)

page2 <- tabPanel(
  "page2",
  home_page
)

page3 <- tabPanel(
  "page3",
  home_page
)

page4 <- tabPanel(
  "page4",
  home_page
)

page5 <- tabPanel(
  "page5",
  page5_ui
)

myui <- navbarPage(
  "COVID-19 and The Economy",
  home,
  page1,
  page2,
  page3,
  page4,
  page5
)