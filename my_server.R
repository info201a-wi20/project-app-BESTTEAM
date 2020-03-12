library("shiny")
library("ggplot2")
library("dplyr")
# install.packages("gridExtra")
library("gridExtra")

server_base_directory <- paste0(getwd(), "/uis")

# Sourcing
source(paste0(getwd(), "/GetData.R"))
# Page 1
myserver <- function(input, output) {
  output$plotL1 <- renderPlot({
    shiny::validate(
      need(input$dateRange[2] > input$dateRange[1], "end date is earlier than start date"
      )
    )
    natural_gas <- read.csv("uis/page1_data/natural_gas.csv", stringsAsFactors = FALSE, header = TRUE)
    ng_data <- natural_gas %>% 
      filter(Date <= as.Date(input$dateRange[2]) & Date >= as.Date(input$dateRange[1]))
    ng_plot <- ggplot(aes(x = Date, y = Price), data = ng_data) + 
      geom_point(color = "purple", size = 3)+
      geom_line(group = 1, color = "green")+
      theme(axis.text.x = element_text(angle=90))+
      labs(x = "Date",
           y = "Price($USD)")
    ng_plot
  })
  output$plotL2 <- renderPlot({
    confirmed_cases <- read.csv("uis/page1_data/confirmed_cases.csv", stringsAsFactors = FALSE, header = TRUE)
    confirmed_cases$date <- confirmed_cases$X
    cases_plot <- ggplot(confirmed_cases, 
                         aes(x = date, 
                             y = confirmed_cases[[input$Region_choice]]))+
      geom_point(color = "purple", size = 3)+
      geom_line(group = 1, color = "orange")+
      theme(axis.text.x = element_text(angle=90))+
      labs(x = "Date", 
           y = "Confirmed Cases")
    cases_plot
  })
  
  


# page 2
  output$result <- renderText({
    #user_result <- new_date_frame %>% filter(Date == input$date_insert) %>% pull(virus_df_new)
    return(paste("Your selected date is", input$date_insert, ", you can find more information in the given date 
                 on confirmed cases and volume of stock in the above graph."))
  })
  
  output$analysis_q2 <- renderText({
    return("From the graph, we can see that the confirmed cases is increasing throughout time,
    but since we have limited data, this may not perfectly predict future. The volume of stock is generally increasing 
           throughout time, but sometimes the volume is pretty low. So we can see that there's some correlation between
           confirmed cases and the volume of stock, but not much. ")
  })
  
  output$graph_q2 <- renderPlot({
    if (input$q2_volume == "Confirmed cases ") {
      volume_case <- ggplot(data = new_date_frame, mapping = aes(x=Date, y=virus_df_new)) +
        geom_bar(stat="identity", position=position_dodge(), fill = "chocolate3") + 
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(
          title = "Confirmed cases trending throughout time",
          x = "Date",
          y = "Confirmed cases",
          color = "Legend"
        )
    } else if (input$q2_volume == "Volume of stock ") {
      volume_case <- ggplot(data = new_date_frame, mapping = aes(x=Date, y=volume)) +
        geom_bar(stat="identity", position=position_dodge(), fill = "burlywood2") + 
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(
          title = "Volume of stock trending throughout time",
          x = "Date",
          y = "Volume of stock",
          color = "Legend"
        )
    } else {
      case_one <- ggplot(data = new_date_frame, mapping = aes(x=Date, y=virus_df_new)) +
        geom_bar(stat="identity", position=position_dodge(), fill = "chocolate3") + 
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(
          title = "Confirmed cases trending",
          x = "Date",
          y = "Confirmed cases",
          color = "Legend"
        )
      volume_two <- ggplot(data = new_date_frame, mapping = aes(x=Date, y=volume)) +
        geom_bar(stat="identity", position=position_dodge(), fill = "burlywood2") + 
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(
          title = "Volume of stock trending",
          x = "Date",
          y = "Volume of stock",
          color = "Legend"
        )
      volume_case <- grid.arrange(case_one, volume_two, nrow = 1)
    }
    return(volume_case)
  })


# page 3
# select date range + radioButtons + filter dataset
base_dir <- paste0(getwd(), "/uis")
stock_df <- getStock("2020-01-22", "2020-02-20", "CN")
virus_df <- read.csv("data/cov_data/time_series_covid_19_confirmed.csv", 
                     stringsAsFactors = FALSE)
stock_df_close <- stock_df %>% select(Date, close)
virus_df <- virus_df %>% filter(Country.Region == "Mainland China")

drops <- c("Province.State", "Country.Region", "Lat", "Long")
virus_df <- virus_df[ , !(names(virus_df) %in% drops)]
mean <- virus_df %>% 
  summarise_all("mean")

virus_df_new <-data.frame(c(mean)) %>% 
  gather(key = Date, value = Confirmed_cases) %>% select(Confirmed_cases)


virus_df_new <- virus_df_new[-c(4, 5, 6, 11, 12, 18, 19, 22, 23), ]
new_date_frame_close <- data.frame(stock_df_close, virus_df_new)


output$graph_q3 <- renderPlot({
  if (input$q3_volume == "Closing Stock Amount") {
    closing_case <- ggplot(data = new_date_frame_close, mapping = aes(x=Date, y=new_date_frame_close$close)) + 
      geom_point(stat="identity", position=position_dodge(width = 2), fill = "purple")+
      theme(axis.text.x = element_text(angle=90, hjust = 1))+
      labs(x = "Date",
           y = "Stock Closing Amount",
           color = "Legend"
      )
  } else {
    closing_case <- ggplot(data = new_date_frame_close, mapping = aes(x=Date, y=new_date_frame_close$virus_df))+
      geom_point(stat="identity", position=position_dodge(width = 2), fill = "purple")+
      theme(axis.text.x = element_text(angle=90, hjust = 1))+
      labs(x = "Date", 
           y = "Confirmed Cases",
           color = "Legend"
      )
  }
  return(closing_case)
})
  
  #page4
  map_gg <- map_data("world")
  map_gg <- mutate(map_gg, iso3c = iso.alpha(map_gg$region, n = 3))
  
  output$graph_t1 <- renderPlot({
server_base_directory <- paste0(getwd(), "/uis")
    recover_rate <- read.csv(paste0(server_base_directory, "/page4_data/recovery_data.csv"), stringsAsFactors = FALSE)
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
    confirmed <- read.csv(paste0(server_base_directory, "/page4_data/confirmed_2_20_20.csv"), stringsAsFactors = FALSE)
    death <- read.csv(paste0(server_base_directory, "/page4_data/death_2_20_20.csv"), stringsAsFactors = FALSE)
    
    for(i in 1:30){
      colnames(confirmed)[i+1] = substring(colnames(confirmed)[i+1], 2)
      colnames(death)[i+1] = substring(colnames(death)[i+1], 2)
    }
    
    confirmed <- mutate(confirmed, iso3c = iso.alpha(confirmed$Country.Region, n = 3))
    death <- mutate(death, iso3c = iso.alpha(death$Country.Region, n = 3))
    conbine_confirmed <- left_join(map_gg, confirmed, by = "iso3c")
    conbine_death <- left_join(map_gg, death, by = "iso3c")
    case_date <- gsub("-",".",as.character(input$case_date))
    
    tables <- list(total_death = conbine_death, total_confirmed = conbine_confirmed)
    
    draw_graph <- function(string){
      df <- tables[[string]]
      return(df)
    }
    graph_df <- draw_graph(input$status)
    specific <- graph_df %>%
      mutate(cut_value = cut(graph_df[, case_date], breaks=c(-Inf,5,10,30,100,200,1000,2000,Inf),
                             labels = c("less than 5", "5-10", "10-30","30-100", "100-200", "200-1000", "1000-2000", "more than 2000")))%>%
      select(long, lat, group, order, region, subregion, iso3c, Country.Region, case_date, cut_value)
    colnames(specific)[9] = "values"
    case_plot <- ggplot(data = specific) +
      geom_polygon(aes(x = long, y = lat, group = group, fill = cut_value)) + 
      scale_colour_brewer(palette = "Reds") +
      labs(title = paste(input$status, "by Coronavirus-19 worldwide"),
           fill = "Cases")+
      coord_quickmap() +
      theme_void()
    
    case_plot 
  })
  
  # page 5
  virus <- getVirus()
  output$analysis_q5 <- renderText({
    processed_uf <- virus %>% group_by(Date) %>%
      summarise(sum_confirmed = sum(Confirmed),
                sum_death = sum(Deaths),
                sum_recovered = sum(Recovered)) %>%
      mutate(death_rate = sum_death * 100 / sum_confirmed,
             recover_rate = sum_recovered * 100 / sum_confirmed)
    
    temp <- (virus %>% group_by(Country.Region) %>% summarise(sum_confirmed = sum(Confirmed),
                                                              sum_death = sum(Deaths),
                                                              sum_recovered = sum(Recovered)))
    
    return(paste0("Base on the current data, we can see that the death rate of ",
           round((processed_uf %>% arrange(Date) %>% tail(1))$death_rate,2),
    "% and the recover rate of ",
    round((processed_uf %>% arrange(Date) %>% tail(1))$recover_rate, 2),
    "% are approaching to the right estimated value and more and more people are getting recovered from the virus.",
    " The death rate fluctuates becuase the outbreaks in different countries happen at different times. The mean of the",
    " death rate among all countries are ", round(mean(temp$sum_death * 100 / temp$sum_confirmed, na.rm = TRUE),2),
    "%. While there is no medical treatment targetting this virus,",
    " there is no need to worry about it too much if the right actions are made to protect people from getting infected."))
  })
  
  output$graph_q5 <- renderPlot({
    if (input$region_q5 != "all") virus <- virus %>% filter(Country.Region == input$region_q5)
    processed <- virus %>% group_by(Date) %>%
      summarise(sum_confirmed = sum(Confirmed),
                sum_death = sum(Deaths),
                sum_recovered = sum(Recovered)) %>%
      mutate(death_rate = sum_death * 100 / sum_confirmed,
             recover_rate = sum_recovered * 100 / sum_confirmed)
    if (input$rate_q5 == "Recover Rate") {
      death_vs_recover <- ggplot(data = processed) +
        geom_line(mapping = aes(x = Date, y = recover_rate, group = 1, colour = "Recover")) +
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(
          title = "Death vs. Recovered",
          x = "Date",
          y = "Rate",
          color = "Legend"
        ) + scale_color_manual(values = c("Recover" = "green"))
    } else if (input$rate_q5 == "Death Rate") {
      death_vs_recover <- ggplot(data = processed) +
        geom_line(mapping = aes(x = Date, y = death_rate, group = 1, colour = "Death")) +
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(
          title = "Death vs. Recovered",
          x = "Date",
          y = "Rate",
          color = "Legend"
        ) + scale_color_manual(values = c("Death" = "red"))
    } else {
      death_vs_recover <- ggplot(data = processed) +
        geom_line(mapping = aes(x = Date, y = death_rate, group = 1, colour = "Death")) +
        geom_line(mapping = aes(x = Date, y = recover_rate, group = 1, colour = "Recover")) +
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(
          title = "Death vs. Recovered",
          x = "Date",
          y = "Rate",
          color = "Legend"
        ) + scale_color_manual(values = c("Death" = "red", "Recover" = "green"))
    }
    
    return(death_vs_recover)
  })

}


