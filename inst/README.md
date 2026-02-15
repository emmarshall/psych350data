
# psyc350data

<!-- badges: start -->

<!-- badges: end -->

psyc350data provides cleaned, documented datasets for PSYC 350 lab
exercises. All datasets are available as ready-to-use R tibbles and can
be exported as fully labeled SPSS (.sav) files with variable labels,
value labels, and defined missing values.

## Installation

Install from GitHub using [pak](https://pak.r-lib.org/):

``` r
# install.packages("pak")
pak::pak("yourusername/psyc350data")
```

Or with devtools:

``` r
# install.packages("devtools")
devtools::install_github("yourusername/psyc350data")
```

## Available Datasets

| Dataset | Description | N | Source |
|----|----|----|----|
| `superman` | Superman actors across media — heights, RT scores, Letterboxd | 11 | RT, Letterboxd, IMDB |
| `superman_smes` | Simulated SMES ratings by height gap group | 47 | Simulated |
| `hot_ones` | Hot Ones guests — demographics, Scoville ratings, YouTube stats | varies | Hot Ones / YouTube |
| `tip_jokes` | Joke/ad card effect on tipping | varies | Gueguen (2002) |
| `mcu` | MCU Infinity Saga films — box office, RT scores | varies | IMDB |
| `mock_jury` | Attractiveness effects on mock jury sentencing | varies | Plaster (1989) |
| `candy` | Candy rankings with ingredient flags and win % (full) | 85 | FiveThirtyEight |
| `candy_simple` | Candy rankings (simplified — 5 variables) | 85 | FiveThirtyEight |
| `affairs` | Extramarital affairs survey (1969) | varies | Fair (1978) |
| `football` | Football concussions and hippocampus volume | varies | Singh et al. (2014) |

## Quick Start

``` r
library(psyc350data)

# See all available datasets
list_datasets()
#>  [1] "superman"      "superman_smes" "hot_ones"      "tip_jokes"    
#>  [5] "mcu"           "mock_jury"     "candy"         "candy_simple" 
#>  [9] "affairs"       "football"

# Use a dataset directly in R
head(superman)
#>   num media year type clark_height lois_height rt_critics_score rt_critic_count
#> 1   1     1 2025    1         1.93        1.60               83             484
#> 2   2     2 1978    1         1.93        1.72               88             121
#> 3   3     3 2001    2         1.90        1.71               78             111
#> 4   4     4 2006    1         1.89        1.65               72             290
#> 5   5     5 1951    3         1.86        1.63               NA              NA
#> 6   6     6 2013    1         1.85        1.63               57             340
#>   rt_audience_score rt_audience_count ldb_likes ldb_scores clark_height_in
#> 1                90             25000   1105511        3.9         75.9841
#> 2                86            250000     99115        3.7         75.9841
#> 3                72              2500        NA         NA         74.8030
#> 4                60            250000     26076        2.7         74.4093
#> 5                79               250       744        2.6         73.2282
#> 6                75            250000    204463        3.0         72.8345
#>   lois_height_in clark_grp height_diff height_gap tomatometer rt_avg   rt_diff
#> 1        62.9920         2     12.9921          3           2   86.5 -86.71433
#> 2        67.7164         2      8.2677          3           2   87.0 -85.91582
#> 3        67.3227         2      7.4803          2           2   75.0 -65.62313
#> 4        64.9605         2      9.4488          3           2   66.0 -59.84706
#> 5        64.1731         2      9.0551          3          NA     NA        NA
#> 6        64.1731         2      8.6614          3           1   66.0 -74.82072
#>   popular
#> 1       3
#> 2       2
#> 3      NA
#> 4       2
#> 5       1
#> 6       3

# Quick summary
str(football)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    75 obs. of  3 variables:
#>  $ group : num  1 1 1 1 1 1 1 1 1 1 ...
#>  $ years : num  0 0 0 0 0 0 0 0 0 0 ...
#>  $ volume: num  6.17 6.22 6.36 6.46 6.54 ...
```

## Exporting to SPSS

All datasets can be exported as .sav files with full SPSS metadata:

``` r
# Export a single dataset
export_sav("superman", path = "superman_data.sav")

# Export all datasets to a folder
export_all_sav(dir = "~/Desktop/PSYC350_SPSS/")
```

The exported .sav files include:

- **Variable labels** describing each variable
- **Value labels** for categorical variables (e.g., 1 = “Film”, 2 = “TV
  Series”)
- **User-defined missing values** (-99) recognized by SPSS

## Learning More

``` r
# Browse the package vignettes
vignette("getting-started", package = "psyc350data")
vignette("exporting-spss", package = "psyc350data")

# View documentation for any dataset
?superman
?hot_ones
?mock_jury
```
