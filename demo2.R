install.packages("plotly")
library(plotly)

dat1 <- data.frame(
  sex = factor(c("Female","Female","Male","Male")),
  time = factor(c("Lunch","Dinner","Lunch","Dinner"), levels=c("Lunch","Dinner")),
  total_bill = c(13.53, 16.81, 16.24, 17.42)
)

# Bar graph, time on x-axis, color fill grouped by sex -- use position_dodge()
p <- ggplot(data=dat1, aes(x=time, y=total_bill, fill=sex)) +
  geom_bar(stat="identity", position=position_dodge())

fig <- ggplotly(p)

fig
View(dat1)


base_dir <- paste0(getwd(), "/uis")
stock_df <- getStock("2020-01-22", "2020-02-20", "CN")

virus_df <- read.csv("data/cov_data/time_series_covid_19_confirmed.csv", 
                     stringsAsFactors = FALSE)
stock_df <- stock_df %>% select(Date, volume)
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

p <- ggplot(data=new_date_frame, aes(x=Date, y=volume, fill = )) +
  geom_bar(stat="identity", position=position_dodge()) + 
  labs(x = "Date",
       y = "Volume of stock") +
  ggtitle("Stock volume changing trend for ")





