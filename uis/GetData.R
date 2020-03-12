library(httr)
library(tidyr)
library(dplyr)
library(jsonlite)


# Usage: f: from date "yyyy-mm-dd", t: to date "yyyy-mm-dd", country_code:
# country code of country ("US", "CN")
getStock <- function(f, t, country_code) {
  # use of api deprecated
  df <- read.csv(paste0(getwd(),"/data/stock.csv"), stringsAsFactors = FALSE)
  return(df)
}

getVirus <- function() {
  path <- paste0(getwd(), "/data/cov_data/covid_19_data.csv")
  c <- read.csv(path, stringsAsFactors = FALSE)
  c <- c[-1]
  names <- colnames(c)
  names[1] <- "Date"
  colnames(c) <- names
  return(c)
}







