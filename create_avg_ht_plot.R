library(tidyverse)
library(lubridate)
library(ggthemes)

raw_data <- read_rds("aggregate_data.rds")

avg_ht <- raw_data %>% 
  select(tourney_date, tourney_level, winner_ht, loser_ht) %>% 
  filter(tourney_level == "G") %>% 
  mutate(year = year(tourney_date)) %>% 
  pivot_longer(values_to = "height", cols = c(winner_ht, loser_ht)) %>% 
  select(year, height) %>% 
  group_by(year) %>% 
  summarize(avg_ht = mean(height, na.rm = TRUE)) %>% 
  mutate(avg_ht = avg_ht/30.48)

plot_avg_ht <- avg_ht %>% 
  ggplot(aes(x = year, y = avg_ht)) + 
  geom_line() +
  theme_clean() +
  labs(title = "Average Height of Grand Slam Competitors",
       x = "Year",
       y = "Height (ft)")

write_rds(plot_avg_ht, "plot_avg_ht.rds")