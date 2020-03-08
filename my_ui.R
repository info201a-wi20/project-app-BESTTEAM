library(shiny)

base_dir <- paste0(getwd(), "/uis")
pathL <- paste0(getwd(), "/daily_csv.csv")
ng <- read.csv(pathL, stringsAsFactors = FALSE)
natural_gas <- ng[5794:5813,]

# TODO: source your ui .R file here, make sure to put it in the /uis directory.
source(paste0(base_dir, "/page5_ui.R"))

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
source("myowncode.R")
region_choices <- colnames(confirmed3)
region_input <- selectInput(
  label = "Region",
  choices = region_choices,
  inputId = "Region_choice",
  selected = "Hubei"
)
date_choices <- as.Date(natural_gas$Date)

page1 <- tabPanel(
  "COVID 19 & Price of Natural Gas",
  titlePanel("COVID 19 & Price of Natural Gas"),
  h3("Since the outbreak of coronavirus has raised concerns 
      of suppliers of natural gas, 
    it is meaningful to explore the relationship between 
    natural gas prices and confirmed cases number."),
  tabsetPanel(
    type = "tabs",
    tabPanel("Plot of Natural Gas",
             h4("In this tab, you can choose to show the trend of 
                price changes during different time periods (Any
                time between 01/22/2020 and 02/18/2020 is Ok"),
             dateRangeInput('dateRange',
                            label = 'Date range input: yyyy-mm-dd',
                            start = date_choices[1], 
                            end = date_choices[length(date_choices)],
                            min = date_choices[1],
                            max = date_choices[length(date_choices)]),
             plotOutput("plotL1"),
             p("Restricted by the short time period since the outbreak
                of coronavirus, we could not get a firm conclusion that
                natural gas prices are correlated with the number of confirmed cases.")),
    tabPanel("Plot of Confirmed Cases",
             h4("In this graph, 
                you can choose to show the trend of confirmed cases 
                in different regions(countries or cities)"),
             region_input,
             plotOutput("plotL2"),
             p("Even though different regions may have different
                situations, generally confirmed cases gradually increase
                as time goes on."))
  )
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