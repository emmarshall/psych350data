# Export a dataset as an SPSS .sav file

Converts a psyc350data dataset to a labelled SPSS file with variable
labels, value labels, and defined missing values (-99).

## Usage

``` r
export_sav(dataset, path = NULL, use_sentinel = TRUE)
```

## Arguments

- dataset:

  Character string naming the dataset, or the dataset object itself.
  Valid names: "superman", "superman_smes", "hot_ones", "tip_jokes",
  "mcu", "mock_jury", "candy", "candy_simple", "affairs", "football"

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
# Export by name
export_sav("superman", path = "superman_data.sav")

# Export to a specific directory
export_sav("hot_ones", path = "~/Desktop/hot_ones_data.sav")

# Export all datasets at once
export_all_sav(dir = "~/Desktop/spss_files/")
} # }
```
