library("shiny")
library("ggplot2")
library("dplyr")
library("wbstats")
library("maps")

myui <- fluidPage(
  titlePanel("Question 5 Title Placeholder"),
  
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
                              c("Total Confirmed",
                                "Total Death"), 
                              selected = "Total Confirmed"),
               ),
               mainPanel(
                 p("Please wait for the map to generate."),
                 plotOutput(outputId = "graph_t2")),
               ),
    ),
    tabPanel("Global Recover Rate Map",
             mainPanel(
               h3("Recovery rate of Cononavirus among all countries/regions"),
               p("Here, you can compare recover rate in different country to see how different country dealing with this issue by now.(data until 2020-3-8)"),
               p("Please wait for the map to generate."),
               plotOutput(outputId = "graph_t1"))
    )
  ),
)

myserver <- function(input, output) {
  map_gg <- map_data("world") %>% mutate(iso3c = iso.alpha(map_gg$region, n = 3))
  #page4
  output$graph_t1 <- renderPlot({
    recover_rate <- read.csv(paste0(getwd(), "/recovery_data.csv"), stringsAsFactors = FALSE)
    recover_rate[recover_rate$Country.Region == "Mainland China", "Country.Region"] = "China"
    recover_rate[recover_rate$Country.Region == "Hong Kong", "Country.Region"] = "China"
    recover_rate[recover_rate$Country.Region == "Macau", "Country.Region"] = "China"
    recover_rate[recover_rate$Country.Region == "Taiwan", "Country.Region"] = "China"
    recover_rate[recover_rate$Country.Region == "US", "Country.Region"] = "United States"
    recover_rate <- recover_rate %>%
      group_by(Country.Region) %>%
      summarize(sum_confirm = sum(confirmed),
                sum_recover = sum(recovered),
                rate = 100 * sum_recover/sum_confirm)%>%
      select(Country.Region, rate)
    recover_rate <- mutate(recover_rate, iso3c = iso.alpha(recover_rate$Country.Region, n = 3))
    
    comparision <- left_join(map_gg, recover_rate, by = "iso3c")
    rate_plot <- ggplot(data = comparision) +
      geom_polygon(aes(x = long, y = lat, group = group, fill = rate)) +
      coord_quickmap() +
      theme_void()
    rate_plot
  })
  output$graph_t2 <- renderPlot({
    confirmed <- read.csv(paste0(getwd(), "/confirmed_2_20_20.csv"), stringsAsFactors = FALSE)
    death <- read.csv(paste0(getwd(), "/death_2_20_20.csv"), stringsAsFactors = FALSE)

    for(i in 1:30){
      colnames(confirmed)[i+1] = substring(colnames(confirmed)[i+1], 2)
      colnames(death)[i+1] = substring(colnames(death)[i+1], 2)
    }
    

    confirmed <- mutate(confirmed, iso3c = iso.alpha(confirmed$Country.Region, n = 3))
    death <- mutate(death, iso3c = iso.alpha(death$Country.Region, n = 3))
    conbine_confirmed <- left_join(map_gg, confirmed, by = "iso3c")
    conbine_death <- left_join(map_gg, death, by = "iso3c")
    case_date <-  gsub("-",".",as.character(input$case_date))
    
    if(input$status == "Total Death"){
      specific <- conbine_death %>%
        mutate(cut_value = cut(case_date, breaks=c(100,200,1000,2000,Inf)), labels = c("less than 100", "100-200", "200-1000", "1000-2000", "more than 2000"))%>%
        select(long, lat, group, order, region, subregion, iso3c, Country.Region, case_date, cut_value)
      colnames(specific)[9] = "values"
      case_plot <- ggplot(data = specific) +
        geom_polygon(aes(x = long, y = lat, group = group, fill = cut_value)) + 
        scale_color_brewer(palette = "Greys", n = 5) +
        labs(title = "Total Death by Coronavirus-19 worldwide") +
        coord_quickmap() +
        theme_void()
    }else {
      specific <- conbine_confirmed %>%
        mutate(cut_value = cut(case_date, breaks=c(100,200,1000,2000,Inf)), labels = c("less than 100", "100-200", "200-1000", "1000-2000", "more than 2000"))%>%
        select(long, lat, group, order, region, subregion, iso3c, Country.Region, case_date, cut_value)
      colnames(specific)[9] = "values"
      case_plot <- ggplot(data = specific) +
        geom_polygon(aes(x = long, y = lat, group = group, fill = cut_value)) +
        scale_color_brewer(palette = "Reds", n = 5) +
        labs(title = "Total Death by Coronavirus-19 worldwide") +
        coord_quickmap() +
        theme_void()
    }
    case_plot 
  })
  
}

shinyApp(myui, myserver)
