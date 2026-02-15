# ============================================================================
# Candy Rankings Data (Full and Simplified)
# Source: FiveThirtyEight candy power rankings
# ============================================================================

library(readxl)
library(dplyr)
library(usethis)
library(here)

source_file <- here::here("data-raw", "candy", "candy_data.xlsx")

candy_raw <- read_excel(source_file, sheet = "data")

candy <- candy_raw |>
  select(-starts_with("...")) |>
  select(-any_of("rownames")) |>
  select(where(~!all(is.na(.)))) |>
  tibble::as_tibble()

usethis::use_data(candy, overwrite = TRUE)

candy_simple <- candy |>
  select(competitorname, chocolate, sugarpercent, pricepercent, winpercent)

usethis::use_data(candy_simple, overwrite = TRUE)

# ============================================================================
# To export as SPSS:
#   library(psyc350data)
#   export_candy_sav("candy_data.sav")
#   export_candy_simple_sav("candy_simple_data.sav")
# ============================================================================
