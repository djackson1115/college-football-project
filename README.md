# college football project

## Motivation
These files contain college football data, analysis, and visualizations.

## Installation
Necessary data sets and shapefiles are included in the Github repository.

Install R 4.1 or later (optionally, install RStudio as an IDE) and load the following packages.
```
install.packages(c("tidyverse", "cfbplotR", "cfbfastR". "tictoc", "gt", "gtExtras", "RColorBrewer"))
```

## Scripts
- ```middle_8.r``` Testing a hypothesis about the performance of teams during the "middle 8" (last 4 minutes of 2Q and first 4 minutes of 3Q).
- ```point_differential.r``` Computing point differentials for the 2021 CFB season with tables and visualizations.

# Data
## `2021_fbs_teams.csv`

Source: College Football Data

Column | Description
-------|------------
`id` | Unique identifier for each game
`season` | Season that the game was played
`week` | Week that the game was played
`season_type` | Whether the game was played during the regular or postseason
 `start_date` | Date on which the game was played (yyyy-mm-dd hh:mm:ss) 
 `neutral_site` | 'TRUE' or 'FALSE' depending on if the game was played at a neutral site
 `conference_game` | 'TRUE' or 'FALSE' depending on if the game was in-conference or out-of-conference (OOC)
 `attendance` | Attendance for the game
 `venue_id` | Unique identifier for the venue
 `venue` | The venue where the game was played
 `home_id` | Unique identifier for the home team
 `home_team` | Home team for the game
 `home_conference` | Conference of the home team
 `home_division` | Division of the home team (FBS or FCS)
 `home_points` | Number of points scored by the home team
 `away_id` | Unique identifier for the away team
 `away_team` | Away team for the game
 `away_conference` | Conference of the away team
 `away_division` | Division of the away team (FBS or FCS)
 `away_points` | Number of points scored by the away team
