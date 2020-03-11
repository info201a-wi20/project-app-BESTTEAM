library("shiny")
library("ggplot2")
library("dplyr")

# Sourcing
server_base_directory <- paste0(getwd(), "/uis")
source(paste0(server_base_directory, "/page1_ui.R"))
source(paste0(getwd(), "/GetData.R"))
# Page 1
myserver <- function(input, output) {
  output$plotL1 <- renderPlot({
    shiny::validate(
      need(input$dateRange[2] > input$dateRange[1], "end date is earlier than start date"
      )
    )
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
    cases_plot <- ggplot(confirmed2, 
                         aes(x = dates, 
                             y = confirmed2[[input$Region_choice]]))+
      geom_point(color = "purple", size = 3)+
      geom_line(group = 1, color = "orange")+
      theme(axis.text.x = element_text(angle=90))+
      labs(x = "Date", 
           y = "Confirmed Cases")
    cases_plot
  })
  
  #page4
  map_gg <- map_data("world")
  map_gg <- mutate(map_gg, iso3c = iso.alpha(map_gg$region, n = 3))
  
  output$graph_t1 <- renderPlot({
    
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
  output$graph_q5 <- renderPlot({
    virus <- getVirus()
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


