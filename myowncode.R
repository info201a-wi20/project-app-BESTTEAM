library("shiny")
library("haven")
library("dplyr")

virus_spreading <- read_dta("confirmed.dta")
path1 <- paste0(getwd(), "/confirmed.dta")
confirmed1 <- read_dta(path1)
confirmed <- rename(confirmed1, 
                    "1/22/20" = "v6",
                    "1/23/20" = "v7",
                    "1/24/20" = "v8",
                    "1/25/20" = "v9",
                    "1/26/20" = "v10",
                    "1/27/20" = "v11",
                    "1/28/20" = "v12",
                    "1/29/20" = "v13",
                    "1/30/20" = "v14",
                    "1/31/20" = "v15",
                    "2/1/20" = "v16",
                    "2/2/20" = "v17",
                    "2/3/20" = "v18",
                    "2/4/20" = "v19",
                    "2/5/20" = "v20",
                    "2/6/20" = "v21",
                    "2/7/20" = "v22",
                    "2/8/20" = "v23",
                    "2/9/20" = "v24",
                    "2/10/20" = "v25",
                    "2/11/20" = "v26",
                    "2/12/20" = "v27",
                    "2/13/20" = "v28",
                    "2/14/20" = "v29",
                    "2/15/20" = "v30",
                    "2/16/20" = "v31",
                    "2/17/20" = "v32",
                    "2/18/20" = "v33",
                    "2/19/20" = "v34",
                    "2/20/20" = "v35")
region_choices <- c(confirmed$regions)
region_input <- selectInput(
  label = "Region",
  choices = region_choices,
  inputId = "Region",
  selected = "Hubei"
)
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
View(confirmed2)

confirmed2 <- data.frame(t(confirmed[-1]))
colnames(confirmed2) <- confirmed$regions
print(colnames(confirmed2))

Q1 <- tabPanel(
  title = "COVID 19&Price of Natural Gas",
  titlePanel("Based on the data set, 
             does the number of coronovirus pneumonia cases confirmed 
             have no effect on the price of natural gas?"),
  p("Since the outbreak of coronavirus has raised concerns of suppliers of natural gas, 
    it is meaningful to explore the relationship between natural gas prices and 
    confirmed cases number."),
  p("Under the simple regression model, 
  we can get a graph of the number of confirmed cases 
  and the price of natural gas."),
  img(src = "ngreg.png"),
  p(a("(WHO)", href = 'https://www.kaggle.com/sudalairajkumar/novel-corona-virus-2019-dataset')),
  p(a("(DataHub)"), href = 'https://datahub.io/core/natural-gas'),
  region_input,
  plotOutput("plot")
)

