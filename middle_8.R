# install and load required packages

# install.packages(c("tidyverse","cfbplotR", "cfbfastR", "tictoc"))
library(tidyverse)
library(cfbplotR)
library(cfbfastR)
library(tictoc)

# get API key for free at collegefootballdata.com
CFBD_API_KEY <- Sys.setenv(CFBD_API_KEY = "XXXX API-KEY-HERE XXXX")

# initialize table
pbp.22 <- tibble()

# load 2022 play-by-play data
tic()
pbp.22 <- load_cfb_pbp(2022)
toc()

# filter by Oregon

oregon.pbp.22 <- pbp.22 %>%
  filter(home == "Oregon" | away == "Oregon") %>% # select relevant columns
  select(week, home, away,game_play_number, half_play_number, drive_play_number, pos_team, def_pos_team, pos_team_score, def_pos_team_score,
         half, period, clock.minutes, clock.seconds, play_type, play_text, down, distance, yards_to_goal, yards_gained, EPA, penalty_detail, 
         yds_penalty, new_series, middle_8, change_of_pos_team, home_EPA, away_EPA, yard_line, id_play, game_id) 

# Middle 8 (M8): the last 4 minutes of play during the 1st half and the first 4 minutes of play during the 2nd half
# does Oregon perform better on offense/defense during the "middle 8"?

# on offense
o.offense.NotM8 <- oregon.pbp.22 %>% # plays NOT during the middle 8
  filter(pos_team == "Oregon" & middle_8 == FALSE) %>% 
  pull(EPA)

o.offense.M8 <- oregon.pbp.22 %>% # plays during the middle 8
  filter(pos_team == "Oregon" & middle_8 == TRUE) %>% 
  pull(EPA)                                                                                 

# check to see if EPA is apx. normally distributed

# compute mean and sd for EPA
EPA.param <- oregon.pbp.22 %>% 
  filter(!is.na(EPA)) %>% 
  summarise(mean.EPA = mean(EPA), 
            sd.EPA = sd(EPA))

# create plot
oregon.pbp.22 %>% 
  filter(!is.na(EPA)) %>% # remove NA values 
  ggplot(aes(x = EPA)) + # plot histogram
  geom_histogram(aes(y = after_stat(density)), 
                 binwidth = 0.1,
                 colour = "black",
                 fill = "white") +
  xlim(-8,8) + # plot density curve
  stat_function(fun = dnorm, args = list(mean = EPA.param$mean.EPA, 
                                         sd = EPA.param$sd.EPA)) # looks good!

# run F-test to check variance 
var.test(o.offense.NotM8, o.offense.M8, alternative = "two.sided") # not equal

# run two-sample t-test with unequal variances

t.test(o.offense.NotM8, o.offense.M8, # mu_0: M8 = M8, mu_a: NotM8 < M8
       var.equal = FALSE, 
       alternative = "less")

# p < 0.05, reject mu_0, there is statistically significant evidence to support our claim

# on defense
o.defense.NotM8 <- oregon.pbp.22 %>% # plays NOT during the middle 8
  filter(def_pos_team == "Oregon" & middle_8 == FALSE) %>% 
  pull(EPA)

o.defense.M8 <- oregon.pbp.22 %>% # plays during the middle 8
  filter(def_pos_team == "Oregon" & middle_8 == TRUE) %>% 
  pull(EPA)      

var.test(o.defense.NotM8, o.defense.M8, alternative = "two.sided") # not equal

t.test(o.defense.NotM8, o.defense.M8, # mu_0: M8 = M8, mu_a: NotM8 < M8
       var.equal = FALSE, 
       alternative = "less")

# p > 0.05, FAIL to reject mu_0, there is NOT statistically significant evidence to support our claim