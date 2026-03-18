# ============================================================================
# Nebraska Football Box Scores (1962–2024)
# ============================================================================
library(dplyr)
library(readxl)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "huskers")

if (file.exists(file.path(source_dir, "huskers-football.xlsx"))) {
  huskers_raw <- read_excel(file.path(source_dir, "huskers-football.xlsx"), sheet = "huskers")

  huskers <- huskers_raw |>
    mutate(
      result = recode_values(
        result,
        from = c("W", "L", "T"),
        to   = c("Win", "Loss", "Tie")
      ),
      site = recode_values(
        site,
        from = c("home", "away", "neutral-home", "neutral-away"),
        to   = c("Home", "Away", "Neutral (home)", "Neutral (away)")
      ),
      conference = if_else(conference, "Conference", "Non-conference")
    ) |>
    tibble::as_tibble()

  usethis::use_data(huskers, overwrite = TRUE)
  cat("Created: huskers\n")
} else {
  warning("huskers-football.xlsx not found in ", source_dir, " - skipping huskers dataset")
}
