# ============================================================================
# MCU Films Data
# Source: Internet Movie Database
# ============================================================================
library(readxl)
library(dplyr)
library(usethis)
library(here)

source_file <- here::here("data-raw", "mcu", "mcu_films.xlsx")

mcu_raw <- read_excel(source_file, sheet = "data")

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
    critics = as.numeric(critics),
    audience = as.numeric(audience),

    # Keep phase as string for R use
    phase = case_match(
      as.numeric(phase),
      1 ~ "Phase 1",
      2 ~ "Phase 2",
      3 ~ "Phase 3",
      .default = NA_character_
    ),

    # Keep favor as string for R use
    favor = case_match(
      as.numeric(favor),
      1 ~ "Critics",
      2 ~ "Audience",
      .default = NA_character_
    )
  ) |>
  tibble::as_tibble()

usethis::use_data(mcu, overwrite = TRUE)
cat("Created: mcu\n")

# ============================================================================
# To export as SPSS:
#   library(psych350data)
#   export_mcu_sav("mcu_data.sav")
# ============================================================================
