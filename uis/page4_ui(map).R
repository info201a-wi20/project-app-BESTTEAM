library("shiny")
library("ggplot2")
library("dplyr")
library("wbstats")
library("maps")



page4_ui <- fluidPage(
  titlePanel("Coronavirus Global Cases & Recover Rate Map"),
  
  tabsetPanel(
    tabPanel("Coronavirus Global Cases Map",
             sidebarLayout(
               sidebarPanel(
                 h3("Options"),
                 p("Here, you can see confirmed/recovered/death cases in different country/region."),
                 p("(data until 2020-2-20)"),
                 sliderInput("case_date", 
                             "Dates:",
                             min = as.Date("2020-01-22","%Y-%m-%d"),
                             max = as.Date("2020-02-20","%Y-%m-%d"),
                             value=as.Date("2020-02-20"),
                             timeFormat="%Y-%m-%d"),
                 radioButtons("status",
                              "status selection: ",
                              c("total_confirmed",
                                "total_death"), 
                              selected = "total_confirmed"),
               ),
               mainPanel(
                 p("Please wait for the map to generate."),
                 plotOutput(outputId = "graph_t2"),
                 p("According to graph, we can clearly see that since China was the first country that have confirmed case diagnosed with Covid-19, it has the highest number of both confirmed cases and death cases."),
                 p("And starting from Asia, the spread of Covid-19 starting to cross the continent to Europe and also America.")),
             ),
    ),
    tabPanel("Global Recover Rate Map",
             mainPanel(
               h3("Recovery rate of Cononavirus among all countries/regions"),
               p("Here, you can compare recover rate in different country to see how different country dealing with this issue by now.(data until 2020-3-8)"),
               p("Please wait for the map to generate."),
               plotOutput(outputId = "graph_t1"),
               p("We can see that even though China have the largest number of confirmed cases & death cases, its recovery rate is increasing rapidly. This might because its tough policies and quick actions towards COVID-19. Some other countries and regions like the South Korea, the United States and Europe that lately had a outbreak of COVID-19 should pay more attention of the treatment care to increase the recovery rate.")),
    )
  ),
)