# ============================================================================
# Superman Actor Data
# ============================================================================

library(dplyr)
library(readxl)
library(lubridate)
library(usethis)

# Read the Excel file
superman <- read_excel("data-raw/superman/superman_raw.xlsx") |>
  mutate(
    # Participant number
    num = row_number(),

    # Parse dates
    release_date = ymd(release_date),
    clark_birth = ymd(clark_birth),
    lois_birth = ymd(lois_birth),

    # Calculate ages at release
    clark_age = round(time_length(interval(clark_birth, release_date), "years"), 2),
    lois_age = round(time_length(interval(lois_birth, release_date), "years"), 2),


    # Age difference calculations
    age_diff = abs(clark_age - lois_age),

    # Create age groups
    age_grp = case_when(
      is.na(age_diff) ~ NA_real_,
      age_diff < -2 ~ 1,
      age_diff <= 5 ~ 2,
      age_diff > 5 ~ 3
    ),

    # Height conversions
    clark_height_in = clark_height * 39.37,
    lois_height_in = lois_height * 39.37,

    # Height difference calculations
    height_diff = clark_height_in - lois_height_in,
    height_gap = case_when(
      is.na(height_diff) ~ NA_real_,
      height_diff < 6 ~ 1,
      height_diff >= 6 & height_diff <= 8 ~ 2,
      height_diff > 8 ~ 3
    ),

    # Clark height group
    clark_grp = case_when(
      is.na(clark_height_in) ~ NA_real_,
      clark_height_in < 72 ~ 1,
      clark_height_in >= 72 ~ 2
    ),

    # Rotten Tomatoes metrics
    tomatometer = case_when(
      is.na(rt_critics_score) ~ NA_real_,
      rt_critics_score < 60 ~ 1,
      rt_critics_score >= 60 ~ 2
    ),
    rt_avg = (rt_critics_score + rt_audience_score) / 2,

    # Popularity category
    popular = case_when(
      is.na(ldb_likes) ~ NA_real_,
      ldb_likes < 1000 ~ 1,
      ldb_likes >= 1000 & ldb_likes <= 100000 ~ 2,
      ldb_likes > 100000 ~ 3
    )
  ) |>
  select(-release_date, -clark_birth, -lois_birth)

usethis::use_data(superman, overwrite = TRUE)

# ============================================================================
# To export as SPSS after installing the package:
#   library(psyc350data)
#   export_superman_sav("superman_data.sav")
#   # or: export_sav("superman", path = "superman_data.sav")
# ============================================================================
