# Export a dataset as an SPSS .sav file

Converts a psych350data dataset to a labelled SPSS file with variable
labels, value labels, and defined missing values (-99).

## Usage

``` r
export_sav(dataset, path = NULL, use_sentinel = TRUE)
```

## Arguments

- dataset:

  Character string naming the dataset, or the dataset object itself.
  Valid names: "superman", "superman_smes", "hot_ones", "tip_jokes",
  "mcu", "mock_jury", "candy", "candy_simple", "football", "huskers",
  "interpersonal_data", "self_descriptive_data"

- path:

  File path for the output .sav file. If NULL, saves to the working
  directory with a default name.

- use_sentinel:

  Logical. If TRUE (default), NA values are replaced with -99 and marked
  as SPSS user-defined missing. If FALSE, NAs are written as
  system-missing.

## Value

Invisibly returns the labelled data frame that was written.

## Examples

``` r
if (FALSE) { # \dontrun{
export_sav("superman", path = "superman_data.sav")
export_sav("hot_ones", path = "~/Desktop/hot_ones_data.sav")

# Export a subset of variables
library(dplyr)
superman |>
  select(1:8) |>
  export_sav(path = "superman_subset.sav")
} # }
```
