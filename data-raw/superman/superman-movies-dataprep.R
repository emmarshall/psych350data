# ============================================================================
# Superman Movies Data
# ============================================================================
library(dplyr)
library(stringr)
library(readr)
library(usethis)
library(here)

source_dir <- here::here("data-raw", "superman")

if (file.exists(file.path(source_dir, "superman_movies.csv"))) {
  movies_raw <- read_csv(file.path(source_dir, "superman_movies.csv"))

  superman_movies <- movies_raw |>
    transmute(
      # Core identifiers
      imdb_id = id,
      title = title,
      year = as.integer(year),
      description = description,

      # Box office data (already in raw numbers, convert to millions)
      domestic_gross = domestic / 1e6,
      domestic_pct = percent,
      international_gross = (boxoffice - domestic) / 1e6,
      international_pct = 100 - percent,
      worldwide_gross = boxoffice / 1e6,

      # Production info
      distributor = distributor,
      opening_weekend = opening / 1e6,
      budget = budget / 1e6,

      # Release info
      release_date = release,
      mpaa = mpaa,

      # Runtime in minutes
      runtime_min = as.integer(runtime),

      # Genres
      genres = genres |>
        str_replace_all("\\s{2,}", " ") |>
        str_trim(),

      # Poster URL
      poster_url = poster_url_clean,

      # Actor name for joining with superman actor data
      clark_actor = clark_actor
    ) |>
    # Calculate derived variables
    mutate(
      # ROI (return on investment)
      roi = (worldwide_gross - budget) / budget,

      # Budget category
      budget_cat = case_when(
        is.na(budget) ~ NA_character_,
        budget < 50 ~ "Low",
        budget < 150 ~ "Medium",
        budget >= 150 ~ "High"
      ),

      # Box office success category
      box_office_cat = case_when(
        is.na(worldwide_gross) ~ NA_character_,
        worldwide_gross < 100 ~ "Low",
        worldwide_gross < 500 ~ "Medium",
        worldwide_gross >= 500 ~ "High"
      )
    )

  usethis::use_data(superman_movies, overwrite = TRUE)
  cat("Created: superman_movies\n")

} else {
  warning("superman_movies.csv not found in ", source_dir, " - skipping superman_movies dataset")
}
