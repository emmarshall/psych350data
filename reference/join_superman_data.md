# Join Superman Movies with Actor Data

Combines the superman_movies dataset with physical characteristics and
ratings data from the superman dataset, matched by actor name.

## Usage

``` r
join_superman_data(
  movies = NULL,
  actors = NULL,
  suffix = c("_movie", "_actor")
)
```

## Arguments

- movies:

  A data frame of Superman movies (default: superman_movies)

- actors:

  A data frame of Superman actor data (default: superman)

- suffix:

  Suffixes for disambiguating duplicate column names. Default
  c("\_movie", "\_actor").

## Value

A tibble with movie data joined to actor data.

## Examples

``` r
if (FALSE) { # \dontrun{
combined <- join_superman_data()
combined |> export_sav(path = "superman_combined.sav")
} # }
```
