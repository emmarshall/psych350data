# Superman Movies Box Office Data

Box office and production data for Superman theatrical films, including
budget, domestic and international grosses, and MPAA ratings.

## Usage

``` r
superman_movies
```

## Format

A tibble with variables:

- imdb_id:

  IMDb title ID (e.g., "tt0078346")

- title:

  Movie title

- year:

  Release year

- description:

  Movie description/tagline

- domestic_gross:

  Domestic box office gross (millions USD)

- domestic_pct:

  Domestic percentage of worldwide gross

- international_gross:

  International box office gross (millions USD)

- international_pct:

  International percentage of worldwide gross

- worldwide_gross:

  Worldwide box office gross (millions USD)

- distributor:

  Domestic distributor

- opening_weekend:

  Domestic opening weekend gross (millions USD)

- budget:

  Production budget (millions USD)

- release_date:

  Earliest release date

- mpaa:

  MPAA rating (G, PG, PG-13, R)

- runtime_min:

  Runtime in minutes

- genres:

  Genres (space-separated)

- poster_url:

  Movie poster URL (low resolution)

- poster_url_hires:

  Movie poster URL (high resolution)

- clark_actor:

  Actor playing Clark Kent/Superman (for joining with superman dataset)

- roi:

  Return on investment ((worldwide - budget) / budget)

- budget_cat:

  Budget category: Low (\<\$50M), Medium (\$50-150M), High (\>\$150M)

- box_office_cat:

  Box office category: Low (\<\$100M), Medium (\$100-500M), High
  (\>\$500M)

## Source

IMDb Box Office Mojo

## Examples

``` r
if (FALSE) { # \dontrun{
superman_movies
combined <- join_superman_data()
combined |> export_sav(path = "superman_combined.sav")
} # }
```
