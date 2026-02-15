# ============================================================================
# Hot Ones Guest Data
# Source: Hot Ones / First We Feast (YouTube)
# ============================================================================

library(readxl)
library(dplyr)
library(tidyr)
library(lubridate)
library(usethis)
library(here)

source_file <- here::here("data-raw", "hot_ones", "hot_ones.xlsx")

sauces_df <- read_excel(source_file, sheet = "sauces")
guests_df <- read_excel(source_file, sheet = "guests")
episodes_df <- read_excel(source_file, sheet = "episodes")

guests_df <- guests_df |>
  mutate(age = time_length(interval(birthday, last_episode), "years")) |>
  select(-views_millions, -birthday, -last_episode)

sauces_wide <- sauces_df |>
  pivot_wider(id_cols = season, names_from = order,
              values_from = sauce, names_prefix = "sauce_order") |>
  rename(sauce_season = season)

scoville_wide <- sauces_df |>
  pivot_wider(id_cols = season, names_from = order,
              values_from = scoville, names_prefix = "scoville_order") |>
  rename(scoville_season = season)

sauces_complete <- sauces_wide |>
  left_join(scoville_wide, by = c("sauce_season" = "scoville_season"))

final_df <- guests_df |>
  left_join(sauces_complete, by = c("season" = "sauce_season"))

guests_dat <- final_df |>
  rename(
    subn = part_num,
    SHU_1 = scoville_order1, SHU_2 = scoville_order2,
    SHU_3 = scoville_order3, SHU_4 = scoville_order4,
    SHU_5 = scoville_order5, SHU_6 = scoville_order6,
    SHU_7 = scoville_order7, SHU_8 = scoville_order8,
    SHU_9 = scoville_order9, SHU_10 = scoville_order10,
    sauce_1 = sauce_order1, sauce_2 = sauce_order2,
    sauce_3 = sauce_order3, sauce_4 = sauce_order4,
    sauce_5 = sauce_order5, sauce_6 = sauce_order6,
    sauce_7 = sauce_order7, sauce_8 = sauce_order8,
    sauce_9 = sauce_order9, sauce_10 = sauce_order10
  )

episodes_full <- episodes_df |>
  select(-guest, -published_date, -video_id, -description)

hot_ones_raw <- guests_dat |>
  left_join(episodes_full, by = c("season", "order")) |>
  select(subn, name, gender, age, occupation, helpers, alt_food, wing_total,
         SHU_1, SHU_2, SHU_3, SHU_4, SHU_5, SHU_6, SHU_7, SHU_8, SHU_9, SHU_10,
         sauce_1, sauce_2, sauce_3, sauce_4, sauce_5, sauce_6, sauce_7, sauce_8,
         sauce_9, sauce_10, result, appearances, date, season, order, title,
         short_description, img, view_count, like_count, comment_count) |>
  rename(description = short_description, views = view_count,
         likes = like_count, comments = comment_count)

hot_ones <- hot_ones_raw |>
  select(-helpers, -alt_food, -wing_total, -date, -title, -description,
         -img, -starts_with("sauce_")) |>
  mutate(
    gender = case_when(
      gender == "Man" ~ 1, gender == "Woman" ~ 2, TRUE ~ NA_real_
    ),
    result = case_when(
      result == "Succeeded" ~ 1, result == "Failed" ~ 2, TRUE ~ NA_real_
    ),
    occupation = case_when(
      occupation == "Rapper" ~ 1, occupation == "Athlete" ~ 2,
      occupation == "Actor" ~ 3, occupation == "Actor-Comedian" ~ 4,
      occupation == "Comedian" ~ 5, occupation == "Chef" ~ 6,
      occupation == "Actor-Musician" ~ 7, occupation == "Musician" ~ 8,
      occupation == "DJ" ~ 9, occupation == "YouTuber" ~ 10,
      occupation == "Model" ~ 11, occupation == "Wrestler" ~ 12,
      occupation == "Magician" ~ 13, occupation == "Other" ~ 14,
      TRUE ~ NA_real_
    ),
    views = views / 1000000
  ) |>
  tibble::as_tibble()

usethis::use_data(hot_ones, overwrite = TRUE)

# ============================================================================
# To export as SPSS:
#   library(psyc350data)
#   export_hot_ones_sav("hot_ones_data.sav")
# ============================================================================
