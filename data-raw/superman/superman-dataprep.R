# ============================================================================
# Superman Actor Dataset
# ============================================================================

library(dplyr)
library(stringr)
library(readxl)
library(lubridate)
library(usethis)

superman <- read_excel("data-raw/superman/superman_raw.xlsx") |>

  mutate(
    # Participant number
    num = row_number(),

    # Standardize type values (trim whitespace, consistent naming)
    type = str_trim(type),

    # Parse dates
    release_date = ymd(release_date),
    clark_birth = ymd(clark_birth),
    lois_birth = ymd(lois_birth),

    # Calculate ages at release
    clark_age = round(time_length(interval(clark_birth, release_date), "years"), 2),
    lois_age = round(time_length(interval(lois_birth, release_date), "years"), 2),

    # Age difference calculations
    age_diff = abs(clark_age - lois_age),

    # Create age groups (as strings for R users)
    age_grp = case_when(
      is.na(age_diff) ~ NA_character_,
      age_diff < 2 ~ "Minimal",
      age_diff <= 5 ~ "Average",
      age_diff > 5 ~ "Big"
    ),

    # Height conversions
    clark_height_in = clark_height * 39.37,
    lois_height_in = lois_height * 39.37,

    # Height difference calculations
    height_diff = clark_height_in - lois_height_in,

    # Height gap category (as string)
    height_gap = case_when(
      is.na(height_diff) ~ NA_character_,
      height_diff < 6 ~ "Minimal",
      height_diff >= 6 & height_diff <= 8 ~ "Average",
      height_diff > 8 ~ "Big"
    ),

    # Clark height group (as string)
    clark_grp = case_when(
      is.na(clark_height_in) ~ NA_character_,
      clark_height_in < 72 ~ "Under 6ft",
      clark_height_in >= 72 ~ "6ft or taller"
    ),

    # Tomatometer category (as string)
    tomatometer = case_when(
      is.na(rt_critics_score) ~ NA_character_,
      rt_critics_score < 60 ~ "Rotten",
      rt_critics_score >= 60 ~ "Fresh"
    ),

    # Rotten Tomatoes average
    rt_avg = (rt_critics_score + rt_audience_score) / 2,

    # Popularity category (as string)
    popular = case_when(
      is.na(ldb_likes) ~ NA_character_,
      ldb_likes < 1000 ~ "Low",
      ldb_likes >= 1000 & ldb_likes <= 100000 ~ "Mid",
      ldb_likes > 100000 ~ "High"
    )
  ) |>
  # Remove date columns (keep ages)
  select(-release_date, -clark_birth, -lois_birth)

usethis::use_data(superman, overwrite = TRUE)
cat("Created: superman\n")
