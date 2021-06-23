library(tidyverse)
library(janitor)
library(ggthemes)
library(lubridate)

raw_data <- read_rds("aggregate_data.rds")

# tidy data
ace_data_per_game <- raw_data %>% 
  select(tourney_date, w_ace, l_ace) %>% 
  mutate(year = year(tourney_date)) %>%
  drop_na(w_ace, l_ace) %>%
  mutate(total_ace = w_ace + l_ace) %>% 
  group_by(year) %>% 
  summarize(avg_ace_per_game = mean(total_ace))

ace_plot_per_game <- ace_data_per_game %>% 
  filter(year < 2020) %>% 
  ggplot(aes(x = year, y = avg_ace_per_game)) +
    geom_line() +
    scale_x_continuous(breaks = c(1991:2019)) +
    theme_clean() + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(title = "Annual Average Number of Aces per Game in the ATP Tour",
         x = "Year",
         y = "Mean Aces per Game in Year")

# write rds file
write_rds(ace_plot_per_game, "ace_plot_per_game.rds")