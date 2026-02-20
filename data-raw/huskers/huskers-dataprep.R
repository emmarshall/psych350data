## code to prepare `huskers` dataset
library(readxl)
library(dplyr)
huskers_raw <- read_excel("data-raw/huskers/huskers-football.xlsx")
huskers <- huskers_raw |>
  mutate(
    date = as.Date(date),
    season = as.integer(season),
    site = as.character(site),
    conference = as.logical(conference),
    opp_rank = as.integer(suppressWarnings(as.numeric(opp_rank))),
    ne_rank = as.integer(suppressWarnings(as.numeric(ne_rank))),
    result = as.character(result),
    across(c(opp_score, ne_score,
             opp_score_q1, opp_score_q2, opp_score_q3, opp_score_q4, opp_score_ot,
             ne_score_q1, ne_score_q2, ne_score_q3, ne_score_q4, ne_score_ot,
             opp_rush_att, opp_rush_yards, ne_rush_att, ne_rush_yards,
             opp_pass_comp, opp_pass_att, opp_pass_yards,
             ne_pass_comp, ne_pass_att, ne_pass_yards,
             opp_first_downs, ne_first_downs,
             opp_third_down_comp, opp_third_down_att,
             ne_third_down_comp, ne_third_down_att,
             opp_fourth_down_comp, opp_fourth_down_att,
             ne_fourth_down_comp, ne_fourth_down_att,
             opp_int, opp_fum, ne_int, ne_fum,
             opp_pen_num, opp_pen_yards, ne_pen_num, ne_pen_yards),
           ~as.integer(suppressWarnings(as.numeric(.x)))),
    across(c(spread, total, temp, humidity, wind_speed, wind_bearing),
           ~suppressWarnings(as.numeric(.x)))
  ) |>
  rename(time = time_ct)
usethis::use_data(huskers, overwrite = TRUE)
