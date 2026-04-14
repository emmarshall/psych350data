# ============================================================================
# Nebraska Football Box Scores (1962–2024)
# ============================================================================
library(dplyr)
library(readxl)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "huskers")

if (file.exists(file.path(source_dir, "huskers-football.xlsx"))) {
  huskers_raw <- read_excel(
    file.path(source_dir, "huskers-football.xlsx"),
    sheet = "huskers",
    na = c("", "-")
  )

  huskers <- huskers_raw |>
    mutate(
      # Force numeric: source xlsx contains a few "-" entries (now read as NA)
      # which coerced ne_pen_yards to character on import.
      ne_pen_yards = as.numeric(ne_pen_yards),
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
      conference = if_else(conference, "Conference", "Non-conference"),
      # Derived dichotomous variables for regression analyses
      # SPSS: RECODE result (1=1)(2=0)(3=0) INTO win.
      win = dplyr::case_when(
        result == "Win"  ~ "Yes",
        result == "Loss" ~ "No",
        result == "Tie"  ~ "No",
        .default = NA_character_
      ),
      # SPSS: RECODE site (1=1)(2=0)(3=1)(4=0) INTO home.
      home = dplyr::case_when(
        site == "Home"            ~ "Yes",
        site == "Away"            ~ "No",
        site == "Neutral (home)"  ~ "Yes",
        site == "Neutral (away)"  ~ "No",
        .default = NA_character_
      )
    ) |>
    tibble::as_tibble()

  usethis::use_data(huskers, overwrite = TRUE)
  cat("Created: huskers\n")
} else {
  warning("huskers-football.xlsx not found in ", source_dir, " - skipping huskers dataset")
}
