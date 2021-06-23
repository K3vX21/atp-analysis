library(tidyverse)

all_years = list()

for(file_name in list.files(path = "datasets")){
  raw_file <- read_csv(paste("datasets/", file_name, sep = ""),
                       col_types = cols(
                         tourney_id = col_character(),
                         tourney_name = col_character(),
                         surface = col_factor(),
                         draw_size = col_integer(),
                         tourney_level = col_factor(),
                         tourney_date = col_date(),
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
                         loser_rank_points = col_integer()
                       ),
                       na = c("", "NA"))
  raw_file_tagged <- raw_file %>% 
    mutate(source = as.factor(file_name))
    
    
  all_years <- bind_rows(all_years, raw_file_tagged)
}

# write_csv(all_years, "aggregate_data.csv")
write_rds(all_years, "aggregate_data.rds")