library("shiny")

reference <- fluidPage(
  titlePanel("References"),
  h2(em("Data of Coronavirus")),
  p("We got the novel coronavirus dataset from", 
    a("Kaggle.", href = "https://www.kaggle.com/sudalairajkumar/novel-corona-virus-2019-dataset"),
    "The data originally comes from Johns Hopkins University"),
  h2(em("Data of Stock Trade")),
  p("We got the stock trade dataset from", 
    a("Yahoo Finance Api", href = "https://rapidapi.com/apidojo/api/yahoo-finance1")),
  h2(em("Data of Natural Gas")),
  p("We got the natural gas dataset from", 
    a("datahub", href = "https://datahub.io/core/natural-gas"))
)