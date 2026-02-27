# Exporting Datasets to SPSS

## Overview

All psyc350data datasets can be exported as SPSS `.sav` files with full
metadata — variable labels, value labels, and user-defined missing
values. This is useful when you need to work in SPSS for lab
assignments.

## Setup

``` r
library(psyc350data)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

## Exporting with Dataset-Specific Functions

Each dataset has its own export function. Just call it with a file path:

``` r
# Each dataset has a dedicated export function
export_superman_sav("superman_data.sav")
export_superman_smes_sav("superman_smes_data.sav")
export_hot_ones_sav("hot_ones_data.sav")
export_tip_jokes_sav("tip_jokes_data.sav")
export_mcu_sav("mcu_data.sav")
export_mock_jury_sav("mock_jury_data.sav")
export_candy_sav("candy_data.sav")
export_candy_simple_sav("candy_simple_data.sav")
export_football_sav("football_data.sav")
export_huskers_sav("huskers_data.sav")
export_interpersonal_sav("interpersonal_data.sav")
export_selfdescriptive_sav("selfdescriptive_data.sav")

# Save to a specific location
export_superman_sav("~/Desktop/superman_data.sav")
export_football_sav("~/Desktop/football_data.sav")
```

If you don’t provide a path, the file is saved to your current working
directory with a default name.

## Exporting with the Generic Function

You can also use
[`export_sav()`](https://emmarshall.github.io/psych350data/reference/export_sav.md)
with any dataset name:

``` r
# Save to your desktop
export_sav("superman", path = "~/Desktop/superman_data.sav")

# Save to the current working directory (default)
export_sav("mock_jury")
# Creates: mock_jury_data.sav
```

## Exporting a Subset of Variables

Sometimes you only need a few variables from a dataset. You can use
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html)
to choose specific columns, then pass the result to
[`export_sav()`](https://emmarshall.github.io/psych350data/reference/export_sav.md):

``` r
# Export only selected variables from the superman dataset
superman |>
  select(num, media, year, type, clark_height, rt_critics_score) |>
  export_sav(path = "superman_subset.sav")

# Export demographic and scale variables from interpersonal data
interpersonal_data |>
  select(age, gender, race, gcb, risc, lsas) |>
  export_sav(path = "interpersonal_subset.sav")

# Use tidyselect helpers for flexible selection
huskers |>
  select(date, season, opp, result, starts_with("ne_score"), starts_with("ne_rush")) |>
  export_sav(path = "huskers_nebraska_only.sav")

# Select by column position or range
mock_jury |>
  select(attr, crime, years, phyattr:happy) |>
  export_sav(path = "mock_jury_subset.sav")
```

The exported `.sav` file will contain only the selected variables, with
all their labels and metadata preserved.

## Exporting All Datasets

Use
[`export_all_sav()`](https://emmarshall.github.io/psych350data/reference/export_all_sav.md)
to export every dataset at once:

``` r
# Create a folder with all .sav files
export_all_sav(dir = "~/Desktop/PSYC350_SPSS/")
```

This creates one `.sav` file per dataset:

    PSYC350_SPSS/
    ├── superman_data.sav
    ├── superman_smes_data.sav
    ├── hot_ones_data.sav
    ├── tip_jokes_data.sav
    ├── mcu_data.sav
    ├── mock_jury_data.sav
    ├── candy_data.sav
    ├── candy_simple_data.sav
    ├── football_data.sav
    ├── huskers_data.sav
    ├── interpersonal_data.sav
    └── selfdescriptive_data.sav

## What’s in the .sav Files?

The exported files include SPSS metadata that you won’t see in the R
tibbles:

### Variable Labels

Every variable gets a descriptive label visible in SPSS Variable View.
For example, in the superman dataset:

| Variable           | Label                                                                      |
|--------------------|----------------------------------------------------------------------------|
| `clark_height`     | Height of Clark Kent/Superman actor in meters                              |
| `rt_critics_score` | Rotten Tomatoes critics score (0-100 scale)                                |
| `tomatometer`      | whether the media was liked by more than 60% of critics on Rotten Tomatoes |

### Value Labels

Categorical variables include labeled values. For example:

| Variable      | Code | Label     |
|---------------|------|-----------|
| `type`        | 1    | Film      |
| `type`        | 2    | TV Series |
| `type`        | 3    | Serial    |
| `tomatometer` | 1    | rotten    |
| `tomatometer` | 2    | fresh     |

### Missing Values

In the R objects, missing data is represented as `NA`. In the `.sav`
files, missing values are coded as `-99` and registered as user-defined
missing values so SPSS excludes them from analyses automatically.

Not all datasets use missing values. For example, the `tip_jokes`,
`mock_jury`, and `football` datasets are complete — their .sav files
have labels but no sentinel missing values.

## Controlling Missing Value Behavior

By default,
[`export_sav()`](https://emmarshall.github.io/psych350data/reference/export_sav.md)
converts `NA` to `-99` and sets the SPSS missing value attribute. To
write standard SPSS system-missing values instead:

``` r
export_sav("superman", path = "superman_sysmis.sav", use_sentinel = FALSE)

# Works with dataset-specific functions too
export_superman_sav("superman_sysmis.sav", use_sentinel = FALSE)
```

## Available Datasets

To see all datasets you can export:

``` r
list_datasets()
#>  [1] "superman"              "superman_smes"         "superman_movies"      
#>  [4] "hot_ones"              "tip_jokes"             "mcu"                  
#>  [7] "mock_jury"             "candy"                 "candy_simple"         
#> [10] "football"              "huskers"               "interpersonal_data"   
#> [13] "self_descriptive_data"
```

## Quick Reference: All Export Functions

| Function                                                                                                            | Default filename           |
|---------------------------------------------------------------------------------------------------------------------|----------------------------|
| [`export_superman_sav()`](https://emmarshall.github.io/psych350data/reference/export_superman_sav.md)               | `superman_data.sav`        |
| [`export_superman_smes_sav()`](https://emmarshall.github.io/psych350data/reference/export_superman_smes_sav.md)     | `superman_smes_data.sav`   |
| [`export_hot_ones_sav()`](https://emmarshall.github.io/psych350data/reference/export_hot_ones_sav.md)               | `hot_ones_data.sav`        |
| [`export_tip_jokes_sav()`](https://emmarshall.github.io/psych350data/reference/export_tip_jokes_sav.md)             | `tip_jokes_data.sav`       |
| [`export_mcu_sav()`](https://emmarshall.github.io/psych350data/reference/export_mcu_sav.md)                         | `mcu_data.sav`             |
| [`export_mock_jury_sav()`](https://emmarshall.github.io/psych350data/reference/export_mock_jury_sav.md)             | `mock_jury_data.sav`       |
| [`export_candy_sav()`](https://emmarshall.github.io/psych350data/reference/export_candy_sav.md)                     | `candy_data.sav`           |
| [`export_candy_simple_sav()`](https://emmarshall.github.io/psych350data/reference/export_candy_simple_sav.md)       | `candy_simple_data.sav`    |
| [`export_football_sav()`](https://emmarshall.github.io/psych350data/reference/export_football_sav.md)               | `football_data.sav`        |
| [`export_huskers_sav()`](https://emmarshall.github.io/psych350data/reference/export_huskers_sav.md)                 | `huskers_data.sav`         |
| [`export_interpersonal_sav()`](https://emmarshall.github.io/psych350data/reference/export_interpersonal_sav.md)     | `interpersonal_data.sav`   |
| [`export_selfdescriptive_sav()`](https://emmarshall.github.io/psych350data/reference/export_selfdescriptive_sav.md) | `selfdescriptive_data.sav` |
| `export_sav("name")`                                                                                                | `name_data.sav`            |
| `export_all_sav(dir)`                                                                                               | All of the above           |

## Tips for SPSS Users

1.  **After opening in SPSS**, check Variable View to see all labels
2.  **Missing values** are already defined — no need to set them
    manually
3.  **Categorical variables** will show value labels in Data View if you
    toggle “Value Labels” in the toolbar
4.  If you need to re-export after updating the package, just run the
    export function again
5.  The dataset-specific functions (e.g.,
    [`export_superman_sav()`](https://emmarshall.github.io/psych350data/reference/export_superman_sav.md))
    and the generic
    [`export_sav()`](https://emmarshall.github.io/psych350data/reference/export_sav.md)
    produce identical output
6.  **To export a subset of variables**, pipe through
    [`select()`](https://dplyr.tidyverse.org/reference/select.html)
    before calling
    [`export_sav()`](https://emmarshall.github.io/psych350data/reference/export_sav.md)
