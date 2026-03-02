
# psych350data <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->

<!-- badges: end -->

psych350data provides cleaned, documented datasets for PSYC 350 lab
exercises. All datasets are available as ready-to-use R tibbles and can
be exported as fully labeled SPSS (.sav) files with variable labels,
value labels, and defined missing values.

## Installation

### Install from GitHub (recommended)

To install you need to first set up GitHub authentication first.

#### Step 1: Configure GitHub credentials (one-time setup)

``` r
# Install required packages if needed
install.packages(c("gitcreds", "usethis"))

# Check if credentials are already configured
gitcreds::gitcreds_get()

# If not configured, create a Personal Access Token:
usethis::create_github_token()  
# This opens GitHub with the correct scopes pre-selected.
# Generate the token, copy it, then run:

gitcreds::gitcreds_set()
# Paste your token when prompted
```

#### Step 2: Install the package

``` r
# install.packages("pak")
pak::pak("emmarshall/psych350data")
```

### Install from a local source

If you have a local copy of the package (e.g., a `.tar.gz` file or a
cloned repo), you can install it with:

``` r
# From a .tar.gz file
pak::pak("local::path/to/psych350data_0.1.0.tar.gz")

# From a local directory
pak::pak("local::path/to/psych350data")
```

### Troubleshooting authentication

If you encounter authentication errors:

``` r
# Check your current GitHub configuration
usethis::git_sitrep()

# Reset and reconfigure credentials
gitcreds::gitcreds_set()
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
library(psych350data)

# See all available datasets
list_datasets()
#>  [1] "superman"              "superman_smes"         "superman_movies"      
#>  [4] "superman_combined"     "hot_ones"              "tip_jokes"            
#>  [7] "mcu"                   "mock_jury"             "candy"                
#> [10] "candy_simple"          "football"              "huskers"              
#> [13] "interpersonal_data"    "self_descriptive_data"

# Use a dataset directly in R
head(superman)
#> # A tibble: 6 × 24
#>   type    media             year clark_actor clark_height lois_actor lois_height
#>   <chr>   <chr>            <dbl> <chr>              <dbl> <chr>            <dbl>
#> 1 Film    Superman          2025 David Core…         1.93 Rachel Br…        1.6 
#> 2 Film    Superman: The M…  1978 Christophe…         1.93 Margot Ki…        1.72
#> 3 TV Show Smallville        2001 Tom Welling         1.9  Erica Dur…        1.71
#> 4 Film    Superman Returns  2006 Brandon Ro…         1.89 Kate Bosw…        1.65
#> 5 Film    Superman & the …  1951 George Ree…         1.86 Phyllis C…        1.63
#> 6 Film    Man of Steel      2013 Henry Cavi…         1.85 Amy Adams         1.63
#> # ℹ 17 more variables: rt_critics_score <dbl>, rt_audience_score <dbl>,
#> #   ldb_likes <dbl>, ldb_scores <dbl>, num <int>, clark_age <dbl>,
#> #   lois_age <dbl>, age_diff <dbl>, age_grp <dbl>, clark_height_in <dbl>,
#> #   lois_height_in <dbl>, height_diff <dbl>, height_gap <dbl>, clark_grp <dbl>,
#> #   tomatometer <dbl>, rt_avg <dbl>, popular <dbl>

# Quick summary
str(football)
#> tibble [75 × 3] (S3: tbl_df/tbl/data.frame)
#>  $ group : num [1:75] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ years : num [1:75] 0 0 0 0 0 0 0 0 0 0 ...
#>  $ volume: num [1:75] 6.17 6.22 6.36 6.46 6.54 ...
```

## Exporting to SPSS

Every dataset can be exported as a .sav file with full SPSS metadata.
Each dataset has its own export function:

``` r
# Dataset-specific export functions
export_superman_sav("superman_data.sav")
export_superman_smes_sav("superman_smes_data.sav")
export_hot_ones_sav("hot_ones_data.sav")
export_tip_jokes_sav("tip_jokes_data.sav")
export_mcu_sav("mcu_data.sav")
export_mock_jury_sav("mock_jury_data.sav")
export_candy_sav("candy_data.sav")
export_candy_simple_sav("candy_simple_data.sav")
export_affairs_sav("affairs_data.sav")
export_football_sav("football_data.sav")
```

Or use the generic function with any dataset name:

``` r
# Export by name
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
# Browse the package website
# https://emmarshall.github.io/psych350data/

# Package vignettes
vignette("getting-started", package = "psych350data")
vignette("exporting-spss", package = "psych350data")
vignette("dataset-guide", package = "psych350data")

# View documentation for any dataset
?superman
?hot_ones
?mock_jury
```
