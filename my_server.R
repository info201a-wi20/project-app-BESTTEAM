library("shiny")
library("ggplot2")
library("dplyr")

# Sourcing
base_directory <- paste0(getwd(), "/uis")
source(paste0(base_directory, "/page1_ui.R"))
source(paste0(getwd(), "/GetData.R"))

myserver <- function(input, output) {
  output$plotL1 <- renderPlot({
    validate(
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


