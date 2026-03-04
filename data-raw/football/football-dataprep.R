# ============================================================================
# Football Concussion Brain Data
# Source: Singh R, Meier T, et al., JAMA, 311(18), 2014.
# ============================================================================
library(readxl)
library(dplyr)
library(usethis)
library(here)

source_file <- here::here("data-raw", "football", "football_concussions.xlsx")

football_raw <- read_excel(source_file, sheet = "football")

football_raw <- football_raw |>
  select(-any_of("rownames"))

football <- football_raw |>
  mutate(
    # Keep group as string for R use
    group = case_match(
      group,
      "control" ~ "Control",
      "fb_no_concuss" ~ "Football no concussion",
      "fb_concuss" ~ "Football with concussion",
      .default = NA_character_
    )
  ) |>
  tibble::as_tibble()

usethis::use_data(football, overwrite = TRUE)
cat("Created: football\n")

# ============================================================================
# To export as SPSS:
#   library(psych350data)
#   export_football_sav("football_data.sav")
# ============================================================================
