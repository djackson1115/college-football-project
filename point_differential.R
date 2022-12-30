# install and load required packages

# install.packages(c("tidyverse","gt", "gtExtras", "cfbplotR", "RColorBrewer"))
library(tidyverse)
library(gt)
library(gtExtras)
library(cfbplotR)
library(RColorBrewer)

#setwd("C:/Users/drewj/Downloads/College Football Project/Data/")

# read in data
fbs_2021 <- read_csv("2021_fbs_teams.csv")

fbs_2021 <- fbs_2021 %>%
  mutate(game.diff = home_points - away_points) # compute point differential for each game

# separate data into home and away teams
home <- fbs_2021 %>% 
  group_by(home_team) %>%
  mutate(point.diff = sum(game.diff)) %>%  # sum each games point differential to get total
  rename(team = home_team,
         conference = home_conference) %>%
  distinct(team, conference, point.diff) %>% # we only want these columns
  arrange(desc(point.diff)) 
  
away <- fbs_2021 %>%
  group_by(away_team) %>%
  mutate(point.diff = -1*sum(game.diff)) %>% # change sign to account for away team
  rename(team = away_team,
         conference = away_conference) %>%
  distinct(team, conference, point.diff) %>%
  arrange(desc(point.diff))

# join home and away teams into one table
tab <- inner_join(home, away, by = "team")

tab <- tab %>% 
  mutate(point.diff = point.diff.x + point.diff.y, 
         conference = conference.x) %>%
  select(-c(point.diff.x, point.diff.y, conference.x, conference.y)) %>% # drop unnecessary columns
  arrange(desc(point.diff)) %>% 
  mutate(logo = team) %>% # create duplicate team column for table (team logo)
  as_tibble() %>% # fix table formatting to work with gt
  mutate(rank = row_number()) # add variable to record point differential rank for each team

# generate tables

# top 25 teams 
tab %>%
  select(rank, logo, team, conference, point.diff)  %>%
  head(25) %>%
  gt() %>%
  cols_label(rank = "RANK",
             logo = "TEAM", 
             team = "",
             conference = "CONF",
             point.diff = "DIFF") %>%
  tab_header(title = "Point Differential - FBS",
             subtitle = "2021-22 Season (thru Week 14)") %>%
  gt_fmt_cfb_logo(c(logo, conference)) %>%
  gt_color_rows(point.diff,
                palette = "OrRd") %>%
  gt_highlight_rows(rows = c(1,2,4,5), # CFP teams highlighted
                    columns = c(logo, team, conference),
                    fill = "azure2") %>%
  gt_theme_538()

# SEC
sec <- tab %>%
  filter(conference == "SEC")

sec %>%
  select(rank, logo, team, conference, point.diff) %>%
  gt() %>%
  cols_label(rank = "RANK",
             logo = "TEAM", 
             team = "",
             conference = "CONF",
             point.diff = "DIFF") %>%
  tab_header(title = "Point Differential - SEC",
             subtitle = "2021 Season (thru Week 14)") %>%
  gt_fmt_cfb_logo(c(logo, conference)) %>%
  gt_color_rows(point.diff, 
                palette = "OrRd") %>%
  gt_highlight_rows(rows = 2, # conference champ = Alabama
                    columns = c(logo, team, conference),
                    fill = "azure2") %>%
  gt_theme_538()

# Big10
big10 <- tab %>%
  filter(conference == "Big Ten")

big10 %>%
  select(rank, logo, team, conference, point.diff) %>%
  gt() %>%
  cols_label(rank = "RANK",
             logo = "TEAM", 
             team = "",
             conference = "CONF",
             point.diff = "DIFF") %>%
  tab_header(title = "Point Differential - Big Ten",
             subtitle = "2021 Season (thru Week 14)") %>%
  gt_fmt_cfb_logo(c(logo, conference)) %>%
  gt_color_rows(point.diff, 
                palette = "OrRd") %>%
  gt_highlight_rows(rows = 2, # conference champ = Michigan
                    columns = c(logo, team, conference),
                    fill = "azure2") %>%
  gt_theme_538()

# Pac12
pac12 <- tab %>%
  filter(conference == "Pac-12")

pac12 %>%
  select(rank, logo, team, conference, point.diff) %>%
  gt() %>%
  cols_label(rank = "RANK",
             logo = "TEAM", 
             team = "",
             conference = "CONF",
             point.diff = "DIFF") %>%
  tab_header(title = "Point Differential - PAC-12",
             subtitle = "2021 Season (thru Week 14)") %>%
  gt_fmt_cfb_logo(c(logo, conference)) %>%
  gt_color_rows(point.diff, 
                palette = "OrRd") %>%
  gt_highlight_rows(rows = 1, # conference champ = Utah
                    columns = c(logo, team, conference),
                    fill = "azure2") %>%
  gt_theme_538()

# ACC
acc <- tab %>%
  filter(conference == "ACC")

acc %>%
  select(rank, logo, team, conference, point.diff) %>%
  gt() %>%
  cols_label(rank = "RANK",
             logo = "TEAM", 
             team = "",
             conference = "CONF",
             point.diff = "DIFF") %>%
  tab_header(title = "Point Differential - ACC",
             subtitle = "2021 Season (thru Week 14)") %>%
  gt_fmt_cfb_logo(c(logo, conference)) %>%
  gt_color_rows(point.diff, 
                palette = "OrRd") %>%
  gt_highlight_rows(rows = 1, # conference champ = Pitt
                    columns = c(logo, team, conference),
                    fill = "azure2") %>%
  gt_theme_538()

# Big 12
big12 <- tab %>%
  filter(conference == "Big 12")

big12 %>%
  select(rank, logo, team, conference, point.diff) %>%
  gt() %>%
  cols_label(rank = "RANK",
             logo = "TEAM", 
             team = "",
             conference = "CONF",
             point.diff = "DIFF") %>%
  tab_header(title = "Point Differential - Big 12",
             subtitle = "2021 Season (thru Week 14)") %>%
  gt_fmt_cfb_logo(c(logo, conference)) %>%
  gt_color_rows(point.diff, 
                palette = "OrRd") %>%
  gt_highlight_rows(rows = 2, # conference champ = Baylor
                    columns = c(logo, team, conference),
                    fill = "azure2") %>%
  gt_theme_538()
