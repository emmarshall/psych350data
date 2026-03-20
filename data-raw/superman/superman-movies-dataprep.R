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

      # Budget category (tercile-based for even groups)
      budget_cat = factor(
        c("Low", "Medium", "High")[ntile(budget, 3)],
        levels = c("Low", "Medium", "High")
      ),

      # Box office success category (tercile-based for even groups)
      box_office_cat = factor(
        c("Low", "Medium", "High")[ntile(worldwide_gross, 3)],
        levels = c("Low", "Medium", "High")
      )
    )

  usethis::use_data(superman_movies, overwrite = TRUE)
  cat("Created: superman_movies\n")

} else {
  warning("superman_movies.csv not found in ", source_dir, " - skipping superman_movies dataset")
}
