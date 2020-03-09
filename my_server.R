library("shiny")
library("ggplot2")
library("dplyr")
base_directory <- paste0(getwd(), "/uis")
source(paste0(base_directory, "/page1_ui.R"))
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
}


