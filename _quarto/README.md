

# psych350data <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/emmarshall/psych350data/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/emmarshall/psych350data/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Datasets for UNL PSYC 350 Labs. All datasets are ready to use in R with
human-readable categorical values, and can be exported as fully labeled
SPSS (.sav) files with a single function call.

## Installation

Install from GitHub:

``` r
# install.packages("pak")
pak::pak("emmarshall/psych350data")
```

## Quick Start

``` r
library(psych350data)

# See all available datasets
list_datasets()
```

     [1] "superman"              "superman_smes"         "superman_movies"      
     [4] "superman_combined"     "hotones"               "hotones_sauces"       
     [7] "hotones_episodes"      "tip_jokes"             "mcu"                  
    [10] "mock_jury"             "candy"                 "candy_simple"         
    [13] "football"              "huskers"               "interpersonal_data"   
    [16] "self_descriptive_data" "parent_child_data"     "hindsight_mg_data"    
    [19] "hindsight_wg_data"     "cheese_data"           "lpd_data"             

``` r
# Use a dataset directly in R
head(superman)
```

    # A tibble: 6 × 27
      type    media             year clark_actor clark_height lois_actor lois_height
      <chr>   <chr>            <dbl> <chr>              <dbl> <chr>            <dbl>
    1 Film    Superman          2025 David Core…         1.93 Rachel Br…        1.6 
    2 Film    Superman: The M…  1978 Christophe…         1.93 Margot Ki…        1.72
    3 TV Show Smallville        2001 Tom Welling         1.9  Erica Dur…        1.71
    4 Film    Superman Returns  2006 Brandon Ro…         1.89 Kate Bosw…        1.65
    5 Film    Superman & the …  1951 George Ree…         1.86 Phyllis C…        1.63
    6 Film    Man of Steel      2013 Henry Cavi…         1.85 Amy Adams         1.63
    # ℹ 20 more variables: rt_critics_score <dbl>, rt_critics_count <dbl>,
    #   rt_audience_score <dbl>, rt_audience_count <dbl>, ldb_likes <dbl>,
    #   ldb_scores <dbl>, num <int>, clark_age <dbl>, lois_age <dbl>,
    #   age_diff <dbl>, age_grp <chr>, clark_height_in <dbl>, lois_height_in <dbl>,
    #   height_diff <dbl>, height_gap <chr>, clark_grp <chr>, tomatometer <chr>,
    #   rt_avg <dbl>, rt_diff <dbl>, popular <chr>

``` r
# Export to SPSS
export_superman_sav("superman_data.sav")
export_football_sav("~/Desktop/football_data.sav")

# Export all datasets at once
export_all_sav(dir = "~/Desktop/PSYC350_SPSS/")
```

## Three Ways to Use the Data

Each dataset supports three workflows depending on what you need:

**1. Raw data in R** — categorical variables are human-readable
character strings, ideal for exploration and plotting with ggplot2:

``` r
superman |> count(type)         # "Film", "TV Series", "Serial"
football |> count(group)        # "Control", "Football no concussion", ...
```

**2. Prep for numeric R analysis** — `prep_*()` converts character
categories to the same numeric codes used in SPSS, so your R output
matches SPSS output exactly:

``` r
superman_num <- prep_superman(superman)
superman_num |> count(type)     # 1, 2, 3
```

**3. Export to SPSS** — `export_*_sav()` produces a fully labeled `.sav`
file with numeric codes, value labels, variable labels, and `-99` for
missing values:

``` r
export_superman_sav("superman_data.sav")
```

See `vignette("getting-started")` for a full walkthrough of all three
workflows.

## Available Datasets

| Dataset | Description | Rows | Export Function |
|----|----|----|----|
| `superman` | Superman actor data with ratings | 11 | `export_superman_sav()` |
| `superman_smes` | SMES ratings by height gap | 47 | `export_superman_smes_sav()` |
| `superman_movies` | Superman film box office data | 10 | `export_superman_movies_sav()` |
| `hotones` | Hot Ones guest data | 300+ | `export_hotones_sav()` |
| `hotones_sauces` | Hot sauce data by season and position | 250+ | `export_hotones_sauces_sav()` |
| `hotones_episodes` | Episode-level YouTube engagement metrics | 300+ | `export_hotones_episodes_sav()` |
| `tip_jokes` | Tipping experiment (Gueguen, 2002) | 211 | `export_tip_jokes_sav()` |
| `mcu` | MCU films box office and ratings | 23 | `export_mcu_sav()` |
| `mock_jury` | Mock jury sentencing (Plaster, 1989) | 114 | `export_mock_jury_sav()` |
| `candy` | Candy power rankings — full | 85 | `export_candy_sav()` |
| `candy_simple` | Candy power rankings — simplified | 85 | `export_candy_simple_sav()` |
| `football` | Football concussion brain measurements | 75 | `export_football_sav()` |
| `huskers` | Nebraska football box scores (1962–2024) | 700+ | `export_huskers_sav()` |
| `cheese_data` | Cheese characteristics and nutrition (TidyTuesday 2024) | — | `export_cheese_sav()` |
| `lpd_data` | Lincoln Police Department traffic stops | — | `export_lpd_sav()` |
| `parent_child_data` | Parent-child observational study | 100 | `export_parent_child_sav()` |
| `hindsight_mg_data` | Hindsight bias — between-groups long format | 600 | `export_hindsight_mg_sav()` |
| `hindsight_wg_data` | Hindsight bias — within-groups wide format | 60 | `export_hindsight_wg_sav()` |
| `interpersonal_data` | Interpersonal relationships survey scales | 574 | `export_interpersonal_sav()` |
| `self_descriptive_data` | Personality survey scales | 547 | `export_selfdescriptive_sav()` |

## R vs SPSS: What’s Different?

| Aspect | Raw R data | After `prep_*()` | SPSS `.sav` export |
|----|----|----|----|
| Categorical values | Character strings (`"Film"`, `"Control"`) | Numeric codes (1, 2, 3) | Numeric codes with value labels |
| Missing values | `NA` | `NA` | `-99` with user-defined missing |
| Variable descriptions | Help files (`?superman`) | Help files | Variable labels in Variable View |

### Example: All Three Workflows

``` r
library(dplyr)

# Workflow 1: Raw data — human-readable, great for plots
football |>
  count(group)
```

    # A tibble: 3 × 2
      group                        n
      <chr>                    <int>
    1 Control                     25
    2 Football no concussion      25
    3 Football with concussion    25

``` r
# Workflow 2: Prep for numeric analysis matching SPSS
football_num <- prep_football(football)
football_num |>
  count(group)   # 1, 2, 3
```

    # A tibble: 3 × 2
      group     n
      <dbl> <int>
    1     1    25
    2     2    25
    3     3    25

``` r
# Run ANOVA with numeric codes
model <- aov(volume ~ factor(group), data = football_num)
summary(model)
```

                  Df Sum Sq Mean Sq F value   Pr(>F)    
    factor(group)  2  44.35  22.174   31.47 1.51e-10 ***
    Residuals     72  50.73   0.705                     
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
# Workflow 3: Export to SPSS with full labels and -99 for missing
export_football_sav("football_data.sav")

# Export a subset of variables
superman |>
  select(num, media, type, clark_height, rt_critics_score) |>
  export_sav(path = "superman_subset.sav")
```

## What’s Included in SPSS Exports?

- **Variable labels** describing each column
- **Value labels** for categorical variables (e.g., 1 = “Control”, 2 =
  “Football no concussion”)
- **Missing values** coded as `-99` with SPSS missing value definitions
- **Proper SPSS formats** for all variable types

### Auditing an Export

``` r
export_huskers_sav("huskers_data.sav")
check_sav_export("huskers_data.sav")

# Show all variables, not just issues
check_sav_export("huskers_data.sav", show_all = TRUE)

# Read back for analysis
huskers_clean <- get_spss_data("huskers_data.sav")
```

## Documentation

- `vignette("getting-started")` — Introduction and all three workflows
- `vignette("exporting-spss")` — Detailed SPSS export guide
- `vignette("dataset-guide")` — Complete reference for all datasets
- `?dataset_name` — Help for any specific dataset

## License

MIT
