library(tidyverse)
library(janitor)
library(ggthemes)
library(lubridate)

raw_data <- read_rds("aggregate_data.rds")

ace_surface <- raw_data %>% 
  select(tourney_date, surface, w_ace, l_ace) %>%
  drop_na(w_ace, l_ace, surface) %>%
  mutate(year = year(tourney_date)) %>%
  mutate(total_ace = w_ace + l_ace) %>% 
  select(year, surface, total_ace) %>% 
  group_by(year, surface) %>%
  summarize(avg_ace_per_game = mean(total_ace), 
            .groups = "drop") %>% 
  filter(year != 2016 & surface != "carpet")

ace_total <- raw_data %>% 
  select(tourney_date, surface, w_ace, l_ace) %>%
  drop_na(w_ace, l_ace, surface) %>%
  mutate(year = year(tourney_date)) %>%
  mutate(total_ace = w_ace + l_ace) %>% 
  select(year, surface, total_ace) %>% 
  group_by(year) %>%
  summarize(avg_ace_per_game = mean(total_ace), 
            # sum_aces_by_surface_per_year = sum(total_ace),
            # total_games_by_surface_per_year = n(),
            .groups = "drop") %>% 
  mutate(surface = "Total")

ace_total_and_surface <- full_join(ace_total, ace_surface, by = c("year", "avg_ace_per_game", "surface")) %>% 
  arrange(year)

plot_ace_total_and_surface <- ace_total_and_surface %>% 
  filter(year > 1991 & year < 2020) %>% 
  ggplot(aes(x = year, y = avg_ace_per_game, group = surface, color = surface)) +
  geom_line() +
  theme_clean() + 
  scale_color_discrete(name = "Surface",
                       labels = c("Carpet", "Clay", "Grass","Hard","All Surfaces")) + 
  labs(title = "Annual Mean Aces per Game in the ATP Tour",
       x = "Year",
       y = "Mean Aces per Game in Year")
write_rds(plot_ace_total_and_surface, "plot_ace_total_and_surface.rds")