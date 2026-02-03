Sys.setenv(LANG = "en")

library(lubridate)
library(stringi)
library(httr)
library(jsonlite)
library(yaml)

url_api <- "https://api.github.com/repos/jatorresmunguia/disease_outbreak_news/contents/Last%20update"
last_file <- fromJSON(content(GET(url_api), as = "text"))$name[grepl(fromJSON(content(GET(url_api), as = "text"))$name, pattern = paste0("^outbreaks"))]

rdata_file <- last_file[grepl(".csv$", last_file)]
file_name <- basename(rdata_file)
date_string <- sub(".*_(\\d{2})(\\d{2})(\\d{4}).*", "\\1-\\2-\\3", file_name)
date_obj <- dmy(date_string)

formatted_date <- format(date_obj, "%d/%m/%Y")  
formatted_month <- format(date_obj, "%m/%Y")     

last_version <- read.csv(paste0("https://raw.githubusercontent.com/jatorresmunguia/disease_outbreak_news/refs/heads/main/Last%20update", "/", rdata_file),
                         header = TRUE)

num_countries <- nlevels(factor(last_version$Country))
num_diseases <- nlevels(factor(last_version$icd104n))

content_yaml <- paste0("NEWS - ", "The dataset was lastly updated on ", formatted_date, 
" and contains information on ", nrow(last_version), " outbreaks associated with ",
 num_diseases, " infectious diseases that occurred from 01/01/1996 to ", 
 formatted_date, " in ", num_countries, " countries and territories worldwide.")

write_yaml(file = "_variables.yml", 
           list(announcement = list(content = content_yaml))
           )

