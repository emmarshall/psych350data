# Export Superman Movies data as SPSS .sav file

Export Superman Movies data as SPSS .sav file

## Usage

``` r
export_superman_movies_sav(
  path = "superman_movies_data.sav",
  use_sentinel = TRUE
)
```

## Arguments

- path:

  File path. Defaults to "superman_data.sav".

- use_sentinel:

  If TRUE (default), NA becomes -99 with SPSS missing codes.

## Value

Invisibly returns the labelled data frame.
