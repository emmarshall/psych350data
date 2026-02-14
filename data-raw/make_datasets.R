# ============================================================================
# Master build script: create all .rda files for psyc350data
#
# Run from the package root directory:
#   source("data-raw/make_datasets.R")
#
# Requires Excel source files in data-raw/source_data/
# Superman and Superman SMES are self-contained (no external files needed).
# ============================================================================

library(dplyr)
library(tidyr)
library(readxl)
library(lubridate)
library(purrr)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "source_data")


# ============================================================================
# 1. SUPERMAN
# ============================================================================

superman <- tibble::tibble(
  num = 1:11,
  media = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10),
  year = c(2025, 1978, 2001, 2006, 1951, 2013, 1948, 2021, 1993, 1988, 1989),
  type = c(1, 1, 2, 1, 3, 1, 3, 2, 2, 2, 2),
  clark_height = c(1.93, 1.93, 1.90, 1.89, 1.86, 1.85, 1.85, 1.82, 1.81, 1.83, 1.83),
  lois_height = c(1.60, 1.72, 1.71, 1.65, 1.63, 1.63, 1.62, 1.68, 1.68, NA, NA),
  rt_critics_score = c(83, 88, 78, 72, NA, 57, 83, 88, 86, NA, NA),
  rt_critic_count = c(484, 121, 111, 290, NA, 340, 484, 55, 20, NA, NA),
  rt_audience_score = c(90, 86, 72, 60, 79, 75, 90, 84, 86, NA, NA),
  rt_audience_count = c(25000, 250000, 2500, 250000, 250, 250000, 25000, 1000, 100, NA, NA),
  ldb_likes = c(1105511, 99115, NA, 26076, 744, 204463, NA, NA, NA, NA, NA),
  ldb_scores = c(3.9, 3.7, NA, 2.7, 2.6, 3.0, NA, NA, NA, NA, NA)
) |>
  mutate(
    clark_height_in = clark_height * 39.37,
    lois_height_in = lois_height * 39.37,
    clark_grp = case_when(
      is.na(clark_height_in) ~ NA_real_,
      clark_height_in < 72 ~ 1,
      clark_height_in >= 72 ~ 2
    ),
    height_diff = clark_height_in - lois_height_in,
    height_gap = case_when(
      is.na(height_diff) ~ NA_real_,
      height_diff < 6 ~ 1,
      height_diff >= 6 & height_diff <= 8 ~ 2,
      height_diff > 8 ~ 3
    ),
    tomatometer = case_when(
      is.na(rt_critics_score) ~ NA_real_,
      rt_critics_score < 60 ~ 1,
      rt_critics_score >= 60 ~ 2
    ),
    rt_avg = (rt_critics_score + rt_audience_score) / 2,
    rt_diff = (rt_critics_score * rt_critic_count - rt_audience_score * rt_audience_count) /
      (rt_critic_count + rt_audience_count),
    popular = case_when(
      is.na(ldb_likes) ~ NA_real_,
      ldb_likes < 1000 ~ 1,
      ldb_likes >= 1000 & ldb_likes <= 100000 ~ 2,
      ldb_likes > 100000 ~ 3
    )
  )

usethis::use_data(superman, overwrite = TRUE)
cat("Created: superman\n")


# ============================================================================
# 2. SUPERMAN SMES
# ============================================================================

set.seed(123)
base_gaps <- superman |> filter(!is.na(height_gap)) |> pull(height_gap)
target_n <- 47
height_gap_sample <- sample(base_gaps, target_n, replace = TRUE)

superman_smes <- tibble::tibble(
  num = 1:target_n,
  height_gap = height_gap_sample,
  emotional_impact = sapply(height_gap_sample, function(gap) {
    mu <- c(11, 12, 14)[gap]
    pmin(pmax(round(rnorm(1, mu, 3)), 4), 20)
  }),
  aesthetic_appeal = sapply(height_gap_sample, function(gap) {
    mu <- c(9, 9.5, 10)[gap]
    pmin(pmax(round(rnorm(1, mu, 2.5)), 3), 15)
  }),
  cognitive_engagement = sapply(height_gap_sample, function(gap) {
    mu <- c(3.8, 4.0, 4.5)[gap]
    pmin(pmax(round(rnorm(1, mu, 1.2), 1), 0), 7)
  })
)

usethis::use_data(superman_smes, overwrite = TRUE)
cat("Created: superman_smes\n")


# ============================================================================
# 3. HOT ONES
# ============================================================================

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
    left_join(scoville_wide, by = c("sauce_season" = "scoville_season"))

  final_df <- guests_df |>
    left_join(sauces_complete, by = c("season" = "sauce_season"))

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

  hot_ones_raw <- guests_dat |>
    left_join(episodes_full, by = c("season", "order")) |>
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
    )

  # Remove columns not needed for the R object, convert categoricals to numeric
  hot_ones <- hot_ones_raw |>
    select(-helpers, -alt_food, -wing_total, -date, -title, -description,
           -img, -starts_with("sauce_")) |>
    mutate(
      gender = case_when(
        gender == "Man" ~ 1,
        gender == "Woman" ~ 2,
        TRUE ~ NA_real_
      ),
      result = case_when(
        result == "Succeeded" ~ 1,
        result == "Failed" ~ 2,
        TRUE ~ NA_real_
      ),
      occupation = case_when(
        occupation == "Rapper" ~ 1,
        occupation == "Athlete" ~ 2,
        occupation == "Actor" ~ 3,
        occupation == "Actor-Comedian" ~ 4,
        occupation == "Comedian" ~ 5,
        occupation == "Chef" ~ 6,
        occupation == "Actor-Musician" ~ 7,
        occupation == "Musician" ~ 8,
        occupation == "DJ" ~ 9,
        occupation == "YouTuber" ~ 10,
        occupation == "Model" ~ 11,
        occupation == "Wrestler" ~ 12,
        occupation == "Magician" ~ 13,
        occupation == "Other" ~ 14,
        TRUE ~ NA_real_
      ),
      views = views / 1000000
    )

  usethis::use_data(hot_ones, overwrite = TRUE)
  cat("Created: hot_ones\n")

} else {
  warning("hot_ones.xlsx not found in ", source_dir, " - skipping hot_ones dataset")
}


# ============================================================================
# 4. TIP JOKES
# ============================================================================

if (file.exists(file.path(source_dir, "tip-jokes.xlsx"))) {

  tips_raw <- read_excel(file.path(source_dir, "tip-jokes.xlsx"), sheet = "data")

  tips_raw <- tips_raw |>
    select(-starts_with("...")) |>
    select(-any_of("rownames")) |>
    select(where(~!all(is.na(.))))

  # Convert card to numeric
  tip_jokes <- tips_raw |>
    mutate(
      card = case_when(
        card == "Ad" ~ 1,
        card == "Joke" ~ 2,
        card == "None" ~ 3,
        TRUE ~ NA_real_
      ),
      tip = as.numeric(tip),
      ad = as.numeric(ad),
      joke = as.numeric(joke),
      none = as.numeric(none)
    ) |>
    tibble::as_tibble()

  usethis::use_data(tip_jokes, overwrite = TRUE)
  cat("Created: tip_jokes\n")

} else {
  warning("tip-jokes.xlsx not found in ", source_dir, " - skipping tip_jokes dataset")
}


# ============================================================================
# 5. MCU
# ============================================================================

if (file.exists(file.path(source_dir, "mcu-films.xlsx"))) {

  mcu_raw <- read_excel(file.path(source_dir, "mcu-films.xlsx"), sheet = "data")

  mcu_raw <- mcu_raw |>
    select(-starts_with("...")) |>
    select(-any_of("rownames")) |>
    select(where(~!all(is.na(.))))

  mcu <- mcu_raw |>
    mutate(
      length_hrs = as.numeric(length_hrs),
      length_min = as.numeric(length_min),
      opening_weekend_us = as.numeric(opening_weekend_us),
      gross_us = as.numeric(gross_us),
      gross_world = as.numeric(gross_world),
      phase = as.numeric(phase),
      critics = as.numeric(critics),
      audience = as.numeric(audience),
      favor = as.numeric(favor)
    ) |>
    tibble::as_tibble()

  usethis::use_data(mcu, overwrite = TRUE)
  cat("Created: mcu\n")

} else {
  warning("mcu-films.xlsx not found in ", source_dir, " - skipping mcu dataset")
}


# ============================================================================
# 6. MOCK JURY
# ============================================================================

if (file.exists(file.path(source_dir, "mock-jury.xlsx"))) {

  mockjury_raw <- read_excel(file.path(source_dir, "mock-jury.xlsx"), sheet = "data")

  mockjury_raw <- mockjury_raw |>
    select(-starts_with("...")) |>
    select(-any_of("rownames")) |>
    select(where(~!all(is.na(.))))

  mock_jury <- mockjury_raw |>
    mutate(
      attr = case_when(
        attr == "Beautiful" ~ 1,
        attr == "Average" ~ 2,
        attr == "Unattractive" ~ 3,
        TRUE ~ NA_real_
      ),
      crime = case_when(
        crime == "Burglary" ~ 1,
        crime == "Swindle" ~ 2,
        TRUE ~ NA_real_
      )
    ) |>
    tibble::as_tibble()

  usethis::use_data(mock_jury, overwrite = TRUE)
  cat("Created: mock_jury\n")

} else {
  warning("mock-jury.xlsx not found in ", source_dir, " - skipping mock_jury dataset")
}


# ============================================================================
# 7. CANDY (FULL)
# ============================================================================

if (file.exists(file.path(source_dir, "candy-data.xlsx"))) {

  candy_raw <- read_excel(file.path(source_dir, "candy-data.xlsx"), sheet = "data")

  candy <- candy_raw |>
    select(-starts_with("...")) |>
    select(-any_of("rownames")) |>
    select(where(~!all(is.na(.)))) |>
    tibble::as_tibble()

  usethis::use_data(candy, overwrite = TRUE)
  cat("Created: candy\n")

  # ============================================================================
  # 8. CANDY (SIMPLE)
  # ============================================================================

  candy_simple <- candy |>
    select(competitorname, chocolate, sugarpercent, pricepercent, winpercent)

  usethis::use_data(candy_simple, overwrite = TRUE)
  cat("Created: candy_simple\n")

} else {
  warning("candy-data.xlsx not found in ", source_dir, " - skipping candy datasets")
}


# ============================================================================
# 9. AFFAIRS
# ============================================================================

if (file.exists(file.path(source_dir, "affairs.xlsx"))) {

  affairs_raw <- read_excel(file.path(source_dir, "affairs.xlsx"), sheet = "affairs")

  affairs_raw <- affairs_raw |>
    select(-any_of("rownames"))

  affairs <- affairs_raw |>
    mutate(
      gender = case_when(
        gender == "female" ~ 1,
        gender == "male" ~ 2,
        TRUE ~ NA_real_
      ),
      yearsmarried = case_when(
        yearsmarried < 7 ~ 1,
        yearsmarried < 14 ~ 2,
        TRUE ~ 3
      ),
      children = case_when(
        children == "no" ~ 1,
        children == "yes" ~ 2,
        TRUE ~ NA_real_
      ),
      religiousness = as.numeric(religiousness),
      education = as.numeric(education),
      occupation = as.numeric(occupation),
      rating = as.numeric(rating)
    )  |>
    tibble::as_tibble()

  usethis::use_data(affairs, overwrite = TRUE)
  cat("Created: affairs\n")

} else {
  warning("affairs.xlsx not found in ", source_dir, " - skipping affairs dataset")
}


# ============================================================================
# 10. FOOTBALL
# ============================================================================

if (file.exists(file.path(source_dir, "football-concussions.xlsx"))) {

  football_raw <- read_excel(file.path(source_dir, "football-concussions.xlsx"), sheet = "football")

  football_raw <- football_raw |>
    select(-any_of("rownames"))

  football <- football_raw |>
    mutate(
      group = case_when(
        group == "control" ~ 1,
        group == "fb_no_concuss" ~ 2,
        group == "fb_concuss" ~ 3,
        TRUE ~ NA_real_
      )
    ) |>
    tibble::as_tibble()

  usethis::use_data(football, overwrite = TRUE)
  cat("Created: football\n")

} else {
  warning("football-concussions.xlsx not found in ", source_dir, " - skipping football dataset")
}


  # ============================================================================
  # DONE
  # ============================================================================

  cat("\n====================================\n")
  cat("Dataset build complete!\n")
  cat("====================================\n")
  cat("Available datasets:\n")
  cat(paste(" -", list.files(here::here("data"), pattern = "\\.rda$")), sep = "\n")
