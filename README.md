

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
     [4] "superman_combined"     "hot_ones"              "hot_ones_sauces"      
     [7] "hot_ones_episodes"     "tip_jokes"             "mcu"                  
    [10] "mock_jury"             "candy"                 "candy_simple"         
    [13] "football"              "huskers"               "interpersonal_data"   
    [16] "self_descriptive_data"

``` r
# Use a dataset directly in R
head(superman)
```

    # A tibble: 6 × 24
      type    media             year clark_actor clark_height lois_actor lois_height
      <chr>   <chr>            <dbl> <chr>              <dbl> <chr>            <dbl>
    1 Film    Superman          2025 David Core…         1.93 Rachel Br…        1.6 
    2 Film    Superman: The M…  1978 Christophe…         1.93 Margot Ki…        1.72
    3 TV Show Smallville        2001 Tom Welling         1.9  Erica Dur…        1.71
    4 Film    Superman Returns  2006 Brandon Ro…         1.89 Kate Bosw…        1.65
    5 Film    Superman & the …  1951 George Ree…         1.86 Phyllis C…        1.63
    6 Film    Man of Steel      2013 Henry Cavi…         1.85 Amy Adams         1.63
    # ℹ 17 more variables: rt_critics_score <dbl>, rt_audience_score <dbl>,
    #   ldb_likes <dbl>, ldb_scores <dbl>, num <int>, clark_age <dbl>,
    #   lois_age <dbl>, age_diff <dbl>, age_grp <dbl>, clark_height_in <dbl>,
    #   lois_height_in <dbl>, height_diff <dbl>, height_gap <dbl>, clark_grp <dbl>,
    #   tomatometer <dbl>, rt_avg <dbl>, popular <dbl>

``` r
# Export to SPSS
export_superman_sav("superman_data.sav")
export_football_sav("~/Desktop/football_data.sav")

# Export all datasets at once
export_all_sav(dir = "~/Desktop/PSYC350_SPSS/")
```

## Available Datasets

| Dataset | Description | Rows | Export Function |
|----|----|----|----|
| `superman` | Superman actor data with ratings | 11 | `export_superman_sav()` |
| `superman_smes` | SMES ratings by height gap | 47 | `export_superman_smes_sav()` |
| `superman_movies` | Superman film box office data | 10 | `export_superman_movies_sav()` |
| `hot_ones` | Hot Ones guest data | 300+ | `export_hot_ones_sav()` |
| `hot_ones_sauces` | Hot sauce data by season | 250+ | `export_hot_ones_sauces_sav()` |
| `hot_ones_episodes` | Episode YouTube metrics | 300+ | `export_hot_ones_episodes_sav()` |
| `tip_jokes` | Tipping experiment (Gueguen, 2002) | 211 | `export_tip_jokes_sav()` |
| `mcu` | MCU films box office & ratings | 23 | `export_mcu_sav()` |
| `mock_jury` | Mock jury sentencing (Plaster, 1989) | 114 | `export_mock_jury_sav()` |
| `candy` | Candy rankings (full) | 85 | `export_candy_sav()` |
| `candy_simple` | Candy rankings (simplified) | 85 | `export_candy_simple_sav()` |
| `football` | Football concussion brain data | 75 | `export_football_sav()` |
| `huskers` | Nebraska football box scores (1962-2024) | 700+ | `export_huskers_sav()` |
| `interpersonal_data` | Interpersonal survey scales | 574 | `export_interpersonal_sav()` |
| `self_descriptive_data` | Personality survey scales | 547 | `export_selfdescriptive_sav()` |

## R vs SPSS: What’s Different?

| Aspect | In R | In SPSS (.sav) |
|----|----|----|
| Categorical values | Character strings (`"Film"`, `"Control"`) | Numeric codes (1, 2, 3) with value labels |
| Missing values | `NA` | `-99` with user-defined missing |
| Variable descriptions | Help files (`?superman`) | Variable labels in Variable View |

### Example: Using Data in R

``` r
library(dplyr)

# Categorical variables are human-readable
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
# Convert to factor for analysis
football_analysis <- football |>
  mutate(group = factor(group))

# Run ANOVA
model <- aov(volume ~ group, data = football_analysis)
summary(model)
```

                Df Sum Sq Mean Sq F value   Pr(>F)    
    group        2  44.35  22.174   31.47 1.51e-10 ***
    Residuals   72  50.73   0.705                     
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Example: Exporting to SPSS

``` r
# Export full dataset
export_football_sav("football_data.sav")

# Export subset of variables
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

## Documentation

- `vignette("getting-started")` — Introduction and basic usage
- `vignette("exporting-spss")` — Detailed SPSS export guide
- `vignette("dataset-guide")` — Complete reference for all datasets
- `?dataset_name` — Help for any specific dataset

## License

MIT
