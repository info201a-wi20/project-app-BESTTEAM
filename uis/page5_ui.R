library(shiny)

page5_ui <- fluidPage(
  titlePanel("Question 5 Title Placeholder"),
  sidebarLayout(
    sidebarPanel(
      h3("Options"),
      selectInput("region_q5", "By Region :", c(
        "All" = "all",
        "China" = "Mainland China",
        "South Korea" = "South Korea",
        "Singapore" = "Singapore",
        "Japan" = "Japan",
        "Hong Kong" = "Hong Kong",
        "Thailand" = "Thailand",
        "Taiwan" = "Taiwan",
        "Malaysia" = "Malaysia",
        "US" = "US",
        "Australia" = "Australia"
      ), selected = "All"),
      radioButtons("rate_q5",
                   "Rate Selection: ",
                   c(
        "Recover Rate and Death Rate",
        "Recover Rate",
        "Death Rate"
      ), selected = "Recover Rate and Death Rate")
    ),
    mainPanel(
      h3("Graph: "),
      plotOutput(outputId = "graph_q5")
    )
  ),
  textOutput("analysis_q5")
)
