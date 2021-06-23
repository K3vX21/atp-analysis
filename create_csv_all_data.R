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
    raw_file  <- read_csv(url(csv_url),
                          col_types = cols(
                            tourney_id = col_character(),
                            tourney_name = col_character(),
                            surface = col_factor(),
                            draw_size = col_integer(),
                            tourney_level = col_factor(),
                            tourney_date = col_date(format = "%Y%m%d"),
                            match_num = col_integer(),
                            winner_id = col_character(),
                            winner_seed = col_factor(),
                            winner_entry = col_character(),
                            winner_name = col_character(),
                            winner_hand = col_factor(),
                            winner_ht = col_double(),
                            winner_ioc = col_factor(),
                            winner_age = col_double(),
                            loser_id = col_character(),
                            loser_seed = col_factor(),
                            loser_entry = col_character(),
                            loser_name = col_character(),
                            loser_hand = col_factor(),
                            loser_ht = col_double(),
                            loser_ioc = col_factor(),
                            loser_age = col_double(),
                            score = col_character(),
                            best_of = col_integer(),
                            round = col_factor(),
                            minutes = col_integer(),
                            w_ace = col_integer(), 
                            w_df = col_integer(),
                            w_svpt = col_integer(),
                            w_1stIn = col_integer(),
                            w_1stWon = col_integer(),
                            w_2ndWon = col_integer(),
                            w_SvGms = col_integer(),
                            w_bpSaved = col_integer(),
                            w_bpFaced = col_integer(),
                            l_ace = col_integer(),
                            l_df = col_integer(),
                            l_svpt = col_integer(),
                            l_1stIn = col_integer(),
                            l_1stWon = col_integer(),
                            l_2ndWon = col_integer(),
                            l_SvGms = col_integer(),
                            l_bpSaved = col_integer(),
                            l_bpFaced = col_integer(),
                            winner_rank = col_integer(),
                            winner_rank_points = col_integer(),
                            loser_rank = col_integer(),
                            loser_rank_points = col_integer()))
    write_csv(raw_file, 
              paste(
                "datasets/",
                substr(file_name, start = 1, stop = nchar(file_name) - 4), 
                "_imported", 
                substr(file_name, start = nchar(file_name) - 3, stop = nchar(file_name)),
                sep=""))
  }
}