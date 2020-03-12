library(shiny)

page3_ui <- fluidPage(
  titlePanel("Plot of Closing Amount"),
  sidebarLayout(
    sidebarPanel(
      h3("The outbreak of coronavirus raised people's concerns and It is meaningful to explore the 
     relationship between closing amount of stock and confirmed cases number, so it would show 
     how coronovirus has affect our economy."),
      dateRangeInput('dateRange_volume',
                     label = 'Select the date range that you want to the to cover',
                     start = date_choices[1], 
                     end = date_choices[length(date_choices)],
                     min = date_choices[1],
                     max = date_choices[length(date_choices)]),
      radioButtons("q3_volume",
                   "Graph Selection: ",
                   c(
                     "Confirmed cases ",
                     "Closing Stock Amount"
                   ), selected = "Confirmed cases ")
    ),
    mainPanel(
      h3("Graph: "),
      plotOutput(outputId = "graph_q3")
    )
  ),
  textOutput("analysis_q3")
)




  
  
  
  
  
  
  
