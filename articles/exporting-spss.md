# Exporting Datasets to SPSS

## Overview

All psyc350data datasets can be exported as SPSS `.sav` files with full
metadata — variable labels, value labels, and user-defined missing
values. This is useful when you need to work in SPSS for lab
assignments.

## Setup

``` r
library(psyc350data)
```

## Exporting a Single Dataset

Use
[`export_sav()`](https://emmarshall.github.io/psych350data/reference/export_sav.md)
to save any dataset as a `.sav` file:

``` r
# Save to your desktop
export_sav("superman", path = "~/Desktop/superman_data.sav")

# Save to the current working directory (default)
export_sav("mock_jury")
# Creates: mock_jury_data.sav
```

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
    ├── affairs_data.sav
    └── football_data.sav

## What’s in the .sav Files?

The exported files include SPSS metadata that you won’t see in the R
tibbles:

### Variable Labels

Every variable gets a descriptive label visible in SPSS Variable View.
For example, in the superman dataset:

| Variable           | Label                                                   |
|--------------------|---------------------------------------------------------|
| `clark_height`     | Height of Clark Kent/Superman actor in meters           |
| `rt_critics_score` | Rotten Tomatoes critics score (0-100 scale)             |
| `tomatometer`      | Whether the media was liked by more than 60% of critics |

### Value Labels

Categorical variables include labeled values. For example:

| Variable | Code | Label     |
|----------|------|-----------|
| `type`   | 1    | Film      |
| `type`   | 2    | TV Series |
| `type`   | 3    | Serial    |

### Missing Values

In the R objects, missing data is represented as `NA`. In the `.sav`
files, missing values are coded as `-99` and registered as user-defined
missing values so SPSS excludes them from analyses automatically.

## Controlling Missing Value Behavior

By default,
[`export_sav()`](https://emmarshall.github.io/psych350data/reference/export_sav.md)
converts `NA` to `-99` and sets the SPSS missing value attribute. To
write standard SPSS system-missing values instead:

``` r
export_sav("superman", path = "superman_sysmis.sav", use_sentinel = FALSE)
```

## Available Datasets

To see all datasets you can export:

``` r
list_datasets()
#>  [1] "superman"      "superman_smes" "hot_ones"      "tip_jokes"    
#>  [5] "mcu"           "mock_jury"     "candy"         "candy_simple" 
#>  [9] "affairs"       "football"
```

## Tips for SPSS Users

1.  **After opening in SPSS**, check Variable View to see all labels
2.  **Missing values** are already defined — no need to set them
    manually
3.  **Categorical variables** will show value labels in Data View if you
    toggle “Value Labels” in the toolbar
4.  If you need to re-export after updating the package, just run
    [`export_sav()`](https://emmarshall.github.io/psych350data/reference/export_sav.md)
    again

&nbsp;

    ---

    ## Update `DESCRIPTION` for Vignettes

    Add `knitr` and `rmarkdown` to Suggests:

Suggests: dplyr, readxl, tidyr, purrr, lubridate, knitr, rmarkdown,
testthat (\>= 3.0.0) VignetteBuilder: knitr
