# ============================================================================
# Cheese Data (from cheese.com via TidyTuesday 2024-06-04)
# Cleaned for teaching data entry and transformation in SPSS / JAMOVI
# Source file: data-raw/cheese_raw.csv (extracted via extract_cheese_raw.R)
# ============================================================================

library(dplyr)
library(stringr)
library(readr)
library(usethis)
library(here)

# ── Load raw data from local CSV ──────────────────────────────────────────────

cheeses_raw <- read_csv(here("data-raw", "cheese", "cheese_raw.csv"), show_col_types = FALSE)

# ── Filter: keep only rows with fat_content OR calcium_content ────────────────

cheese_filtered <- cheeses_raw |>
  filter(!is.na(fat_content) | !is.na(calcium_content)) |>
  select(cheese, url, milk, country, family, type, vegetarian, color,
         fat_content, calcium_content)

# ── Clean fat_content ─────────────────────────────────────────────────────────
# Values may contain "%", ranges like "20-25", or plain numbers

cheese_data <- cheese_filtered |>
  mutate(
    fat_content = case_when(
      is.na(fat_content)                    ~ NA_real_,
      str_detect(fat_content, "%")          ~ as.numeric(str_remove(fat_content, "%")),
      str_detect(fat_content, "-")          ~ as.numeric(str_extract(fat_content, "^[0-9.]+")),
      TRUE                                  ~ as.numeric(fat_content)
    )
  )

# ── Clean calcium_content ─────────────────────────────────────────────────────
# Values may contain " mg/100g" unit suffix; keep only rows with calcium data

cheese_data <- cheese_data |>
  filter(!is.na(calcium_content)) |>
  mutate(
    calcium_content = case_when(
      is.na(calcium_content)                          ~ NA_real_,
      str_detect(calcium_content, "mg/100g")          ~ as.numeric(
        str_remove(calcium_content, " mg/100g")
      ),
      TRUE                                            ~ as.numeric(calcium_content)
    )
  )

# ── Create milk_source variable ───────────────────────────────────────────────
# Collapses multi-animal milks into "multiple"

cheese_data <- cheese_data |>
  mutate(
    id = as.integer(row_number()),
    milk_source = case_when(
      str_detect(milk, ",") ~ "multiple",
      TRUE                  ~ str_trim(milk)
    )
  )

# ── Convert categoricals to integer codes ─────────────────────────────────────
# milk_source: cow = 1, goat = 2, sheep = 3, buffalo = 4, multiple = 5, other = 6
# vegetarian:  TRUE = 1, FALSE = 0

milk_levels <- c("cow", "goat", "sheep", "buffalo", "multiple")

cheese_data <- cheese_data |>
  mutate(
    milk_source = case_when(
      milk_source == "cow"      ~ 1L,
      milk_source == "goat"     ~ 2L,
      milk_source == "sheep"    ~ 3L,
      milk_source == "buffalo"  ~ 4L,
      milk_source == "multiple" ~ 5L,
      !is.na(milk_source)       ~ 6L,
      TRUE                      ~ NA_integer_
    ),
    vegetarian = case_when(
      vegetarian == TRUE  ~ 1L,
      vegetarian == FALSE ~ 0L,
      TRUE                ~ NA_integer_
    )
  ) |>
  select(id, cheese, url, milk, milk_source, country, family, type,
         vegetarian, color, fat_content, calcium_content)

# ── Save ──────────────────────────────────────────────────────────────────────

usethis::use_data(cheese_data, overwrite = TRUE)
cat("Created: cheese_data\n")
cat("Rows:", nrow(cheese_data), "\n")
