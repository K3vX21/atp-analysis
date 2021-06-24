library(tidyverse)
library(lubridate)
library(ggthemes)

raw_data <- read_rds("aggregate_data.rds")

avg_age_winners <- raw_data %>% 
  select(tourney_date, tourney_level, round, winner_age) %>% 
  filter(round == "F") %>%
  mutate(year = year(tourney_date)) %>%
  group_by(year) %>% 
  summarize(avg_age_winners = mean(winner_age, na.rm = TRUE))

avg_age_all <- raw_data %>% 
  select(tourney_date, tourney_level, winner_age, loser_age) %>% 
  filter(tourney_level == "G") %>% 
  mutate(year = year(tourney_date)) %>%
  group_by(year) %>% 
  mutate(avg_age_match = rowMeans(data.frame(winner_age, loser_age), na.rm = TRUE)) %>% 
  summarize(avg_age = mean(avg_age_match, na.rm = TRUE))

avg_age_combined <- left_join(avg_age_all, avg_age_winners, by = "year") %>% 
  pivot_longer(names_to = "series", values_to = "avg_age", cols = -year)

plot_avg_age_combined <- avg_age_combined %>% 
  ggplot(aes(x = year, y = avg_age, group = series, color = series)) +
  geom_line() +
  theme_clean() +
  scale_color_discrete(name = "Series",
                       labels = c("Average Age", "Average Age\nof Tournament Winners")) + 
  labs(title = "Average Age of Grand Slam Competitors and Winners",
       x = "Year",
       y = "Age")

write_rds(plot_avg_age_combined, "plot_avg_age_combined.rds")




