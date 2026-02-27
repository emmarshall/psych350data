# ============================================================================
# Tip-Jokes Experiment Data
# ============================================================================

library(dplyr)
library(readxl)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "source_data")

if (file.exists(file.path(source_dir, "tip-jokes.xlsx"))) {

  tips_raw <- read_excel(file.path(source_dir, "tip-jokes.xlsx"), sheet = "data")

  tips_raw <- tips_raw |>
    select(-starts_with("...")) |>
    select(-any_of("rownames")) |>
    select(where(\(x) !all(is.na(x))))

  tip_jokes <- tips_raw |>
    mutate(
      # Keep card as string
      card = case_match(
        card,
        "Ad" ~ "Advertisement",
        "Joke" ~ "Joke",
        "None" ~ "None",
        .default = card
      ),
      # Keep tip as string
      tip = if_else(tip == 1, "Yes", "No"),
      # Keep indicator variables as strings
      ad = if_else(ad == 1, "Yes", "No"),
      joke = if_else(joke == 1, "Yes", "No"),
      none = if_else(none == 1, "Yes", "No")
    ) |>
    tibble::as_tibble()

  usethis::use_data(tip_jokes, overwrite = TRUE)
  cat("Created: tip_jokes\n")

} else {
  warning("tip-jokes.xlsx not found in ", source_dir, " - skipping tip_jokes dataset")
}
