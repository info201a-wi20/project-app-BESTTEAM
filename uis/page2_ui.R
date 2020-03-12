library(shiny)
source(paste0(getwd(), "/GetData.R"))

# select date range + radioButtons + filter dataset
base_dir <- paste0(getwd(), "/uis")
source(paste0(getwd(), "/GetData.R"))
stock_df <- getStock("2020-01-22", "2020-02-20", "CN")
stock_df <- stock_df %>% select(Date, volume)

virus_df <- read.csv("data/cov_data/time_series_covid_19_confirmed.csv", 
                     stringsAsFactors = FALSE)
virus_df <- virus_df %>% filter(Country.Region == "Mainland China")
drops <- c("Province.State", "Country.Region", "Lat", "Long")
virus_df <- virus_df[ , !(names(virus_df) %in% drops)]
mean <- virus_df %>% 
  summarise_all("mean")

virus_df_new <-data.frame(c(mean)) %>% 
  gather(key = Date, value = Confirmed_cases) %>% select(Confirmed_cases)
date_insert <- c(stock_df %>% pull(Date)) #  length 21

virus_df_new <- virus_df_new[-c(4, 5, 6, 11, 12, 18, 19, 22, 23), ]

new_date_frame <- data.frame(stock_df, virus_df_new)

page2_ui <- fluidPage(
  titlePanel("Confirmed cases & volume of stock"),
  sidebarLayout(
    sidebarPanel(
      h3("Choose the date and/or the specific relationship graph"),
      dateRangeInput('dateRange_volume_q2',
                     label = 'Select the date range that you want to the to cover',
                     start = date_choices[1], 
                     end = date_choices[length(date_choices)],
                     min = date_choices[1],
                     max = date_choices[length(date_choices)]),
      radioButtons("q2_volume",
                   "Graph selection: ",
                   c(
                     "Confirmed cases ",
                     "Volume of stock ",
                     "Confirmed cases & Volume of stock"
                   ), selected = "Confirmed cases ")
    ),
    mainPanel(
      h3("Graph: "),
      plotOutput(outputId = "graph_q2")
    )
  ),
  textOutput(outputId = "result"),
  
  textOutput("analysis_q2")
)