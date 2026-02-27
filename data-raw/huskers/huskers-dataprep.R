# ============================================================================
# Nebraska Football Box Scores (1962–2024)
# ============================================================================

library(dplyr)
library(readxl)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "source_data")

if (file.exists(file.path(source_dir, "huskers.xlsx"))) {

  huskers_raw <- read_excel(file.path(source_dir, "huskers.xlsx"), sheet = "data")

  huskers <- huskers_raw |>
    mutate(
      # Keep result as string
      result = case_match(
        result,
        "W" ~ "Win",
        "L" ~ "Loss",
        "T" ~ "Tie",
        .default = result
      ),
      # Keep site as string
      site = case_match(
        site,
        "home" ~ "Home",
        "away" ~ "Away",
        "neutral-home" ~ "Neutral (home)",
        "neutral-away" ~ "Neutral (away)",
        .default = site
      ),
      # Keep conference as string
      conference = if_else(conference, "Conference", "Non-conference")
    ) |>
    tibble::as_tibble()

  usethis::use_data(huskers, overwrite = TRUE)
  cat("Created: huskers\n")

} else {
  warning("huskers.xlsx not found in ", source_dir, " - skipping huskers dataset")
}
