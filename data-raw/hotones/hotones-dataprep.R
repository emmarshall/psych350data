# ============================================================================
# Hot Ones Data - Three Datasets
# ============================================================================
library(dplyr)
library(tidyr)
library(readxl)
library(lubridate)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "hotones")

if (file.exists(file.path(source_dir, "hotones.xlsx"))) {

  # Read all sheets
  sauces_df <- read_excel(file.path(source_dir, "hotones.xlsx"), sheet = "sauces")
  guests_df <- read_excel(file.path(source_dir, "hotones.xlsx"), sheet = "guests")
  episodes_df <- read_excel(file.path(source_dir, "hotones.xlsx"), sheet = "episodes")

  # ============================================================================
  # Dataset 1: hotones_SAUCES - Sauce data by season and position
  # ============================================================================

  hotones_sauces <- sauces_df |>
    rename(
      sauce_name = sauce,
      SHU = scoville
    ) |>
    select(season, order, sauce_name, SHU) |>
    arrange(season, order)

  usethis::use_data(hotones_sauces, overwrite = TRUE)
  cat("Created: hotones_sauces (Sauce data by season/position)\n")

  # ============================================================================
  # Dataset 2: hotones_EPISODES - Episode-level data with YouTube metrics
  # ============================================================================

  hotones_episodes <- episodes_df |>
    select(
      season,
      order,
      guest,
      episode_title = title,
      publish_date = published_date,
      views = view_count,
      likes = like_count,
      comments = comment_count,
      short_description,
      img,
      video_id
    ) |>
    mutate(
      views = views / 1000000
    ) |>
    arrange(season, order)

  usethis::use_data(hotones_episodes, overwrite = TRUE)
  cat("Created: hotones_episodes (Episode data with YouTube metrics)\n")

  # ============================================================================
  # Dataset 3: hotones - Guest-level data (main dataset)
  # ============================================================================

  # Calculate age
  guests_df <- guests_df |>
    mutate(
      age = time_length(interval(birthday, last_episode), "years")
    )

  # Pivot sauces wide for guest dataset
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
      SHU_9 = scoville_order9, SHU_10 = scoville_order10
    )

  # Add episode data
  episodes_full <- episodes_df |>
    select(season, order, view_count, like_count, comment_count)

  hotones <- guests_dat |>
    left_join(episodes_full, by = join_by(season, order)) |>
    rename(
      views = view_count,
      likes = like_count,
      comments = comment_count
    ) |>
    mutate(views = views / 1000000) |>
    select(subn, name, gender, age, occupation,
           wing_total, alt_food, helpers,
           SHU_1, SHU_2, SHU_3, SHU_4, SHU_5, SHU_6, SHU_7, SHU_8, SHU_9, SHU_10,
           result, appearances, season, order,
           views, likes, comments)

  usethis::use_data(hotones, overwrite = TRUE)
  cat("Created: hotones (Guest-level data)\n")

} else {
  warning("hotones.xlsx not found in ", source_dir, " - skipping hotones datasets")
}
