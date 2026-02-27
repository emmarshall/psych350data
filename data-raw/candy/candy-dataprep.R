# ============================================================================
# Football Concussion Brain Data
# ============================================================================

library(dplyr)
library(readxl)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "source_data")

if (file.exists(file.path(source_dir, "football-concussions.xlsx"))) {

  football_raw <- read_excel(file.path(source_dir, "football-concussions.xlsx"), sheet = "football")

  football_raw <- football_raw |>
    select(-any_of("rownames"))

  football <- football_raw |>
    mutate(
      # Keep group as string
      group = case_match(
        group,
        "control" ~ "Control",
        "fb_no_concuss" ~ "Football no concussion",
        "fb_concuss" ~ "Football with concussion",
        1 ~ "Control",
        2 ~ "Football no concussion",
        3 ~ "Football with concussion",
        .default = NA_character_
      )
    ) |>
    tibble::as_tibble()

  usethis::use_data(football, overwrite = TRUE)
  cat("Created: football\n")

} else {
  warning("football-concussions.xlsx not found in ", source_dir, " - skipping football dataset")
}
