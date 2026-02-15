# ============================================================================
# Mock Jury Data
# Source: Plaster, M. E. (1989). East Carolina University.
# ============================================================================

library(readxl)
library(dplyr)
library(usethis)
library(here)

source_file <- here::here("data-raw", "mock_jury", "mock_jury.xlsx")

mockjury_raw <- read_excel(source_file, sheet = "data")

mockjury_raw <- mockjury_raw |>
  select(-starts_with("...")) |>
  select(-any_of("rownames")) |>
  select(where(~!all(is.na(.))))

mock_jury <- mockjury_raw |>
  mutate(
    attr = case_when(
      attr == "Beautiful" ~ 1, attr == "Average" ~ 2,
      attr == "Unattractive" ~ 3, TRUE ~ NA_real_
    ),
    crime = case_when(
      crime == "Burglary" ~ 1, crime == "Swindle" ~ 2, TRUE ~ NA_real_
    )
  ) |>
  tibble::as_tibble()

usethis::use_data(mock_jury, overwrite = TRUE)

# ============================================================================
# To export as SPSS:
#   library(psyc350data)
#   export_mock_jury_sav("mock_jury_data.sav")
# ============================================================================
