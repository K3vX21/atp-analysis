---
title: "testing grounds"
author: "Kevin Xu"
date: "6/22/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(janitor)
library(ggthemes)
library(lubridate)
```
```{r}
raw_data <- read_rds("aggregate_data.rds")
```
```{r}
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
 
```
```{r}
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
```
```{r}
ace_total_and_surface <- full_join(ace_total, ace_by_surface, by = c("year", "avg_ace_per_game", "surface")) %>% 
  arrange(year)
```
```{r}
ace_total_and_surface %>% 
#  filter(year > 1991 & year <= 2021) %>% 
  ggplot(aes(x = year, y = avg_ace_per_game, group = surface, color = surface)) +
    geom_line() +
   # scale_x_continuous(breaks = c(1991:2019)) +
    theme_clean() + 
   # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(title = "Annual Mean Aces per Game in the ATP Tour",
         x = "Year",
         y = "Mean Aces per Game in Year")
```



