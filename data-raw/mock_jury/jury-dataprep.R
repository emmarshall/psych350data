# ============================================================================
# Mock Jury Data
# ============================================================================

library(dplyr)
library(readxl)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "source_data")

if (file.exists(file.path(source_dir, "mock-jury.xlsx"))) {

  mockjury_raw <- read_excel(file.path(source_dir, "mock-jury.xlsx"), sheet = "data")

  mockjury_raw <- mockjury_raw |>
    select(-starts_with("...")) |>
    select(-any_of("rownames")) |>
    select(where(\(x) !all(is.na(x))))

  mock_jury <- mockjury_raw |>
    mutate(
      # Keep attr as string
      attr = case_match(
        attr,
        "Beautiful" ~ "Beautiful",
        "Average" ~ "Average",
        "Unattractive" ~ "Unattractive",
        1 ~ "Beautiful",
        2 ~ "Average",
        3 ~ "Unattractive",
        .default = NA_character_
      ),
      # Keep crime as string
      crime = case_match(
        crime,
        "Burglary" ~ "Burglary",
        "Swindle" ~ "Swindle",
        1 ~ "Burglary",
        2 ~ "Swindle",
        .default = NA_character_
      )
    ) |>
    tibble::as_tibble()

  usethis::use_data(mock_jury, overwrite = TRUE)
  cat("Created: mock_jury\n")

} else {
  warning("mock-jury.xlsx not found in ", source_dir, " - skipping mock_jury dataset")
}
