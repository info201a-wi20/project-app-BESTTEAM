library(shiny)

page3_ui <- fluidPage(
  titlePanel("COVID 19&Closing Amount of Stock"),
  h3("The outbreak of coronavirus raised people's concerns and It is meaningful to explore the 
     relationship between closing amount of stock and confirmed cases number, so it would show 
     how coronovirus has affect our economy."),
  
  tabsetPanel(
    type = "tabs",
    tabPanel("Plot of Closing Amount",
             h4("This tab shows the trend of 
                closing amount during different time periods 
                (Any time between 01/22/2020 and 02/20/2020 is Ok"),
             dateRangeInput("dateRange", "Date range input:",
                            start = "2020-01-22",
                            end = "2020-02-20",
                            ),
             plotOutput("plotL1"),
             p("We can conclude that stock closing amount is correlated with the 
               number of confirmed cases. As the number of confirmed cases grow, 
               our economy does get affected.")),
    
     tabPanel("Plot of Confirmed Cases",
             h4("This tab shows the trend of 
                confirmed cases during different time periods 
                (Any time between 01/22/2020 and 02/20/2020 is Ok"),
             dateRangeInput("dateRange", "Date range input:",
                            start = "2020-01-22",
                            end = "2020-02-20",
                            ),
             plotOutput("plotL2"),
             p("Confirmed cases gradually increase as time goes on."))
  )
)


  
  
  
  
  
  
  
