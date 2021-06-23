library(tidyverse)
library(janitor)
library(ggthemes)
library(lubridate)

raw_data <- read_rds("aggregate_data.rds")

# tidy data for surface
ace_data <- raw_data %>% 
  select(tourney_date, surface, w_ace, l_ace) %>%
  mutate(year = year(tourney_date)) %>% 
  mutate(total_ace = w_ace + l_ace, na.rm = TRUE) %>% 
  group_by(year, surface) %>% 
  summarize(count = sum(total_ace, na.rm = TRUE), .groups = "drop") %>% 
  pivot_wider(names_from = surface, values_from = count) %>% 
  clean_names()

ace_data <- ace_data %>%
  mutate(total_aces = rowSums(ace_data[,2:6], na.rm = TRUE)) %>%
  mutate(perc_grass = grass/total_aces) %>%
  mutate(perc_clay = clay/total_aces) %>%
  mutate(perc_carpet = carpet/total_aces) %>%
  mutate(perc_hard = hard/total_aces) %>%
  select(year, total_aces, perc_grass:perc_hard) %>%
  filter(total_aces != 0)

ace_data$perc_carpet[ace_data$perc_carpet == 0] <- NA 
 
ace_data_longer <- ace_data %>%
  select(-total_aces) %>%
  pivot_longer(names_to = "surface", values_to = "percent", cols = -year) %>%
  mutate(year = as.integer(year))

# create surface plot
surface_ace_plot <- ace_data_longer %>%
  filter(year > 1990 & year < 2020) %>%
  ggplot(aes(x = year, y = percent, group = surface, color = surface)) +
  geom_line() +
  scale_x_continuous(breaks = c(1991:2019)) +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_clean() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Percentage of Aces on Each Court Surface\nover Time on ATP Tour",
       y = "Percentage of Total Aces for each Season",
       x = "Year") +
  scale_color_discrete(name = "Surface Type",
                       labels = c("Carpet", "Clay", "Grass", "Hard"))

surface_ace_plot
# write plot to local directory
# write_rds(surface_ace_plot, "ace_plot_surface.rds")
