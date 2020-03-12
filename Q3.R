Q3 <- tabPanel(
  title = "COVID 19&Closing Amount of Stock",
  titlePanel("does the number of coronovirus pneumonia cases confirmed 
             have effect on closing amount of stock?"),
  p("It is meaningful to explore the relationship between closing amount of stock and 
    confirmed cases number, because it would show how coronovirus has affect our economy."),
  
  p("Under the simple regression model, 
  we can get a graph of the number of confirmed cases 
  and the price of natural gas."),
  img(src = "ngreg.png"),
  p(a("(WHO)", href = 'https://www.kaggle.com/sudalairajkumar/novel-corona-virus-2019-dataset')),
  p(a("(DataHub)"), href = 'https://datahub.io/core/natural-gas'),
  region_input,
  plotOutput("plot")
)
