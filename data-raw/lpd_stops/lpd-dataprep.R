# ============================================================================
# Lincoln Police Department Traffic Stops Data
# Source: Lincoln Open Data Portal
#   https://opendata.lincoln.ne.gov/datasets/lpd-traffic-stops-2023/about
# Excel file with one sheet per year — stacked into a single data frame
# ============================================================================

library(dplyr)
library(readxl)
library(lubridate)
library(stringr)
library(purrr)
library(usethis)
library(here)

# ── Read all sheets and stack ─────────────────────────────────────────────────
path <- here("data-raw", "lpd_stops", "lpd-stops.xlsx")

lpd_raw <- path |>
  excel_sheets() |>
  set_names() |>
  map(\(sheet) read_excel(path, sheet = sheet)) |>
  list_rbind(names_to = "year")

# ── Standardise column names to snake_case ────────────────────────────────────
lpd_data <- lpd_raw |>
  rename_with(str_to_lower) |>
  rename_with(\(x) str_replace_all(x, " ", "_"))

# ── Parse dates, times, and coerce categoricals to integer ───────────────────
lpd_data <- lpd_data |>
  mutate(
    year        = as.integer(year),
    date        = as.Date(date),
    month       = as.integer(month(date)),
    time_of_day = case_when(
      hour(time) >= 5  & hour(time) < 12 ~ 1L,  # Morning
      hour(time) >= 12 & hour(time) < 17 ~ 2L,  # Afternoon
      hour(time) >= 17 & hour(time) < 21 ~ 3L,  # Evening
      .default                           ~ 4L   # Night
    ),
    time    = format(time, "%H:%M"),
    race    = as.integer(race),
    sex     = as.integer(sex),
    reason  = as.integer(reason),
    outcome = as.integer(outcome),
    search  = as.integer(search),
    fid     = as.integer(fid)
  )

# ── Save ──────────────────────────────────────────────────────────────────────
usethis::use_data(lpd_data, overwrite = TRUE)

cat("Done!\n")
cat("Rows:", nrow(lpd_data), "\n")
cat("Years:", paste(sort(unique(lpd_data$year)), collapse = ", "), "\n")
cat("Columns:", paste(names(lpd_data), collapse = ", "), "\n")
