# By Luna Lan
library("haven")
library("dplyr")
library("shiny")
library("ggplot2")

natural_gas <- read.csv("page1_data/natural_gas.csv", stringsAsFactors = FALSE, header = TRUE)
confirmed_cases <- read.csv("page1_data/confirmed_cases.csv", stringsAsFactors = FALSE, header = TRUE)
dates <- c("2020-01-22", 
           "2020-01-23", 
           "2020-01-24",
           "2020-01-25", 
           "2020-01-26",
           "2020-01-27", 
           "2020-01-28",
           "2020-01-29",
           "2020-01-30",
           "2020-01-31",
           "2020-02-01",
           "2020-02-02",
           "2020-02-03",
           "2020-02-04",
           "2020-02-05",
           "2020-02-06",
           "2020-02-07",
           "2020-02-08",
           "2020-02-09",
           "2020-02-10",
           "2020-02-11",
           "2020-02-12",
           "2020-02-13",
           "2020-02-14",
           "2020-02-15",
           "2020-02-16",
           "2020-02-17",
           "2020-02-18",
           "2020-02-19",
           "2020-02-20")

region_choices <- colnames(confirmed_cases)[-1]
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