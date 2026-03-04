# ============================================================================
# Candy Rankings Data
# Source: FiveThirtyEight candy power rankings
# ============================================================================
library(dplyr)
library(readxl)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "candy")

if (file.exists(file.path(source_dir, "candy_data.xlsx"))) {

  candy_raw <- read_excel(file.path(source_dir, "candy_data.xlsx"), sheet = "data")

  candy <- candy_raw |>
    select(-starts_with("...")) |>
    select(-any_of("rownames")) |>
    select(where(\(x) !all(is.na(x)))) |>
    mutate(
      # Convert binary variables to Yes/No strings
      chocolate = if_else(chocolate == 1, "Yes", "No"),
      fruity = if_else(fruity == 1, "Yes", "No"),
      caramel = if_else(caramel == 1, "Yes", "No"),
      peanutyalmondy = if_else(peanutyalmondy == 1, "Yes", "No"),
      nougat = if_else(nougat == 1, "Yes", "No"),
      crispedricewafer = if_else(crispedricewafer == 1, "Yes", "No"),
      hard = if_else(hard == 1, "Yes", "No"),
      bar = if_else(bar == 1, "Yes", "No"),
      pluribus = if_else(pluribus == 1, "Yes", "No")
    ) |>
    tibble::as_tibble()

  usethis::use_data(candy, overwrite = TRUE)
  cat("Created: candy\n")

  # ============================================================================
  # CANDY SIMPLE
  # ============================================================================

  candy_simple <- candy |>
    select(competitorname, chocolate, sugarpercent, pricepercent, winpercent)

  usethis::use_data(candy_simple, overwrite = TRUE)
  cat("Created: candy_simple\n")

} else {
  warning("candy_data.xlsx not found in ", source_dir, " - skipping candy datasets")
}

# ============================================================================
# To export as SPSS:
#   library(psych350data)
#   export_candy_sav("candy_data.sav")
#   export_candy_simple_sav("candy_simple_data.sav")
# ============================================================================
