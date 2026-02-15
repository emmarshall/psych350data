# ============================================================================
# Tip-Jokes Experiment Data
# Source: Gueguen, N. (2002). Journal of Applied Social Psychology.
# ============================================================================

library(readxl)
library(dplyr)
library(usethis)
library(here)

source_file <- here::here("data-raw", "tip_jokes", "tip-jokes.xlsx")

tips_raw <- read_excel(source_file, sheet = "data")

tips_raw <- tips_raw |>
  select(-starts_with("...")) |>
  select(-any_of("rownames")) |>
  select(where(~!all(is.na(.))))

tip_jokes <- tips_raw |>
  mutate(
    card = case_when(
      card == "Ad" ~ 1, card == "Joke" ~ 2, card == "None" ~ 3,
      TRUE ~ NA_real_
    ),
    tip = as.numeric(tip),
    ad = as.numeric(ad),
    joke = as.numeric(joke),
    none = as.numeric(none)
  ) |>
  tibble::as_tibble()

usethis::use_data(tip_jokes, overwrite = TRUE)

# ============================================================================
# To export as SPSS:
#   library(psyc350data)
#   export_tip_jokes_sav("tip_jokes_data.sav")
# ============================================================================
