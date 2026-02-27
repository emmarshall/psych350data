# ============================================================================
# Hot Ones Guest Data
# ============================================================================

library(dplyr)
library(tidyr)
library(readxl)
library(lubridate)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "source_data")

if (file.exists(file.path(source_dir, "hot_ones.xlsx"))) {

  sauces_df <- read_excel(file.path(source_dir, "hot_ones.xlsx"), sheet = "sauces")
  guests_df <- read_excel(file.path(source_dir, "hot_ones.xlsx"), sheet = "guests")
  episodes_df <- read_excel(file.path(source_dir, "hot_ones.xlsx"), sheet = "episodes")

  # Calculate age
  guests_df <- guests_df |>
    mutate(
      age = time_length(interval(birthday, last_episode), "years")
    ) |>
    select(-views_millions, -birthday, -last_episode)

  # Pivot sauces wide
  sauces_wide <- sauces_df |>
    pivot_wider(
      id_cols = season,
      names_from = order,
      values_from = sauce,
      names_prefix = "sauce_order"
    ) |>
    rename(sauce_season = season)

  scoville_wide <- sauces_df |>
    pivot_wider(
      id_cols = season,
      names_from = order,
      values_from = scoville,
      names_prefix = "scoville_order"
    ) |>
    rename(scoville_season = season)

  sauces_complete <- sauces_wide |>
    left_join(scoville_wide, by = join_by(sauce_season == scoville_season))

  final_df <- guests_df |>
    left_join(sauces_complete, by = join_by(season == sauce_season))

  # Rename columns
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

  # Add episodes
  episodes_full <- episodes_df |>
    select(-guest, -published_date, -video_id, -description)

  hot_ones <- guests_dat |>
    left_join(episodes_full, by = join_by(season, order)) |>
    select(subn, name, gender, age, occupation, helpers, alt_food, wing_total,
           SHU_1, SHU_2, SHU_3, SHU_4, SHU_5, SHU_6, SHU_7, SHU_8, SHU_9, SHU_10,
           sauce_1, sauce_2, sauce_3, sauce_4, sauce_5, sauce_6, sauce_7, sauce_8,
           sauce_9, sauce_10, result, appearances, date, season, order, title,
           short_description, img, view_count, like_count, comment_count) |>
    rename(
      description = short_description,
      views = view_count,
      likes = like_count,
      comments = comment_count
    ) |>
    # Remove columns not needed, keep strings for categorical variables
    select(-helpers, -alt_food, -wing_total, -date, -title, -description,
           -img, -starts_with("sauce_")) |>
    mutate(
      # Keep gender, result, occupation as strings
      # Convert views to millions
      views = views / 1000000
    )

  usethis::use_data(hot_ones, overwrite = TRUE)
  cat("Created: hot_ones\n")

} else {
  warning("hot_ones.xlsx not found in ", source_dir, " - skipping hot_ones dataset")
}
