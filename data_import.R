library(tidyverse)
library(httr)

api_url = "https://api.github.com/repos/JeffSackmann/tennis_atp/git/trees/master?recursive=1"
req <- GET(api_url)
stop_for_status(req)
file_list <- unlist(lapply(content(req)$tree, "[", "path"), use.names = F)

base_url <- "https://raw.githubusercontent.com/JeffSackmann/tennis_atp/master/"

dir.create("datasets")

for (file_name in file_list){
  pattern ="atp_matches_\\d{4}.csv" 
  if(grepl(pattern, file_name)){
    csv_url <- paste(base_url, file_name, sep = "")
    raw_file  <- read_csv(url(csv_url))
    write_csv(raw_file, 
              paste(
                "datasets/",
                substr(file_name, start = 1, stop = nchar(file_name) - 4), 
                "_imported", 
                substr(file_name, start = nchar(file_name) - 3, stop = nchar(file_name)),
                sep=""))
  }
}