# Dataset Reference Guide

This guide provides a quick reference for every dataset in the
psyc350data package, including variable descriptions, categorical coding
schemes, available export functions, and suggested analyses.

------------------------------------------------------------------------

## Superman Actor Data

**Dataset:** `superman` \| **Export:**
[`export_superman_sav()`](https://emmarshall.github.io/psych350data/reference/export_superman_sav.md)
**Rows:** 11 \| **Variables:** 21

Data on actors who have portrayed Clark Kent/Superman across film, TV,
and serial media.

``` r
str(superman)
#> tibble [11 × 21] (S3: tbl_df/tbl/data.frame)
#>  $ num              : int [1:11] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ media            : num [1:11] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ year             : num [1:11] 2025 1978 2001 2006 1951 ...
#>  $ type             : num [1:11] 1 1 2 1 3 1 3 2 2 2 ...
#>  $ clark_height     : num [1:11] 1.93 1.93 1.9 1.89 1.86 1.85 1.85 1.82 1.81 1.83 ...
#>  $ lois_height      : num [1:11] 1.6 1.72 1.71 1.65 1.63 1.63 1.62 1.68 1.68 NA ...
#>  $ rt_critics_score : num [1:11] 83 88 78 72 NA 57 83 88 86 NA ...
#>  $ rt_critic_count  : num [1:11] 484 121 111 290 NA 340 484 55 20 NA ...
#>  $ rt_audience_score: num [1:11] 90 86 72 60 79 75 90 84 86 NA ...
#>  $ rt_audience_count: num [1:11] 25000 250000 2500 250000 250 250000 25000 1000 100 NA ...
#>  $ ldb_likes        : num [1:11] 1105511 99115 NA 26076 744 ...
#>  $ ldb_scores       : num [1:11] 3.9 3.7 NA 2.7 2.6 3 NA NA NA NA ...
#>  $ clark_height_in  : num [1:11] 76 76 74.8 74.4 73.2 ...
#>  $ lois_height_in   : num [1:11] 63 67.7 67.3 65 64.2 ...
#>  $ clark_grp        : num [1:11] 2 2 2 2 2 2 2 1 1 2 ...
#>  $ height_diff      : num [1:11] 12.99 8.27 7.48 9.45 9.06 ...
#>  $ height_gap       : num [1:11] 3 3 2 3 3 3 3 1 1 NA ...
#>  $ tomatometer      : num [1:11] 2 2 2 2 NA 1 2 2 2 NA ...
#>  $ rt_avg           : num [1:11] 86.5 87 75 66 NA 66 86.5 86 86 NA ...
#>  $ rt_diff          : num [1:11] -86.7 -85.9 -65.6 -59.8 NA ...
#>  $ popular          : num [1:11] 3 2 NA 2 1 3 NA NA NA NA ...
```

### Categorical Codings

| Variable      | Code | Label                      |
|---------------|------|----------------------------|
| `media`       | 1    | Superman 2025              |
| `media`       | 2    | Superman: The Movie        |
| `media`       | 3    | Smallville                 |
| `media`       | 4    | Superman Returns           |
| `media`       | 5    | Superman & the Mole Men    |
| `media`       | 6    | Man of Steel               |
| `media`       | 7    | Superman                   |
| `media`       | 8    | Superman & Lois            |
| `media`       | 9    | Lois & Clark               |
| `media`       | 10   | The Adventures of Superboy |
| `type`        | 1    | Film                       |
| `type`        | 2    | TV Series                  |
| `type`        | 3    | Serial                     |
| `clark_grp`   | 1    | Under 6ft (\<72 inches)    |
| `clark_grp`   | 2    | Over 6ft (≥72 inches)      |
| `tomatometer` | 1    | Rotten                     |
| `tomatometer` | 2    | Fresh                      |
| `height_gap`  | 1    | Minimal (\<6 inches)       |
| `height_gap`  | 2    | Average (6-8 inches)       |
| `height_gap`  | 3    | Big (\>8 inches)           |
| `popular`     | 1    | Low (\<1,000 likes)        |
| `popular`     | 2    | Mid (1,000-100,000 likes)  |
| `popular`     | 3    | High (\>100,000 likes)     |

### Export to SPSS

``` r
export_superman_sav("superman_data.sav")
# or: export_sav("superman", path = "superman_data.sav")
```

### Suggested Analyses

- Descriptive statistics for height and rating variables
- Correlation between critic and audience scores
- Group comparisons by media type

------------------------------------------------------------------------

## Superman SMES Data

**Dataset:** `superman_smes` \| **Export:**
[`export_superman_smes_sav()`](https://emmarshall.github.io/psych350data/reference/export_superman_smes_sav.md)
**Rows:** 47 \| **Variables:** 5

Simulated participant ratings on the Subjective Media Experience Scale
(SMES), grouped by the height gap between Superman and Lois Lane actors.

``` r
str(superman_smes)
#> tibble [47 × 5] (S3: tbl_df/tbl/data.frame)
#>  $ num                 : int [1:47] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ height_gap          : num [1:47] 2 2 3 3 3 3 3 1 3 2 ...
#>  $ emotional_impact    : num [1:47] 16 9 15 15 11 10 14 10 19 16 ...
#>  $ aesthetic_appeal    : num [1:47] 8 8 10 10 13 9 11 9 11 10 ...
#>  $ cognitive_engagement: num [1:47] 4.8 3.9 5 3.2 3.6 4.2 3.6 4.3 3 5.4 ...
```

### Categorical Codings

| Variable     | Code | Label                |
|--------------|------|----------------------|
| `height_gap` | 1    | Minimal (\<6 inches) |
| `height_gap` | 2    | Average (6-8 inches) |
| `height_gap` | 3    | Big (\>8 inches)     |

### Scale Information

| Subscale               | Scoring                     | Range |
|------------------------|-----------------------------|-------|
| `emotional_impact`     | Sum of 4 items (1-5 scale)  | 4-20  |
| `aesthetic_appeal`     | Sum of 3 items (1-5 scale)  | 3-15  |
| `cognitive_engagement` | Mean of 4 items (0-7 scale) | 0-7   |

### Export to SPSS

``` r
export_superman_smes_sav("superman_smes_data.sav")
```

### Suggested Analyses

- One-way ANOVA comparing SMES subscales across height gap groups
- Post-hoc pairwise comparisons

------------------------------------------------------------------------

## Hot Ones Guest Data

**Dataset:** `hot_ones` \| **Export:**
[`export_hot_ones_sav()`](https://emmarshall.github.io/psych350data/reference/export_hot_ones_sav.md)
**Variables:** 23

Data on guests from the YouTube show Hot Ones, including Scoville
ratings for each hot sauce and YouTube engagement metrics.

``` r
str(hot_ones)
#> tibble [369 × 22] (S3: tbl_df/tbl/data.frame)
#>  $ subn       : num [1:369] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ name       : chr [1:369] "Tony Yayo" "Anthony Rizzo" "Machine Gun Kelly" "Gunplay" ...
#>  $ gender     : num [1:369] NA NA NA NA NA NA NA NA NA NA ...
#>  $ age        : num [1:369] 36.9 25.8 28 35.9 39.4 ...
#>  $ occupation : num [1:369] 1 2 1 1 1 1 2 9 1 8 ...
#>  $ SHU_1      : num [1:369] 747 747 747 747 747 747 747 747 2200 2200 ...
#>  $ SHU_2      : num [1:369] 3600 3600 3600 3600 3600 3600 3600 3600 3000 3000 ...
#>  $ SHU_3      : num [1:369] 5790 5790 5790 5790 5790 5790 5790 5790 5790 5790 ...
#>  $ SHU_4      : num [1:369] 15000 15000 15000 15000 15000 15000 15000 15000 13000 13000 ...
#>  $ SHU_5      : num [1:369] 13000 13000 13000 13000 13000 13000 13000 13000 15600 15600 ...
#>  $ SHU_6      : num [1:369] 40600 40600 40600 40600 40600 40600 40600 40600 34000 34000 ...
#>  $ SHU_7      : num [1:369] 30000 30000 30000 30000 30000 30000 30000 30000 40600 40600 ...
#>  $ SHU_8      : num [1:369] 57000 57000 57000 57000 57000 ...
#>  $ SHU_9      : num [1:369] 180000 180000 180000 180000 180000 180000 180000 180000 357000 357000 ...
#>  $ SHU_10     : num [1:369] 357000 357000 357000 357000 357000 357000 357000 357000 550000 550000 ...
#>  $ result     : num [1:369] 2 1 1 1 1 1 1 2 1 1 ...
#>  $ appearances: num [1:369] 1 1 2 1 1 1 1 1 1 1 ...
#>  $ season     : num [1:369] 1 1 1 1 1 1 1 1 2 2 ...
#>  $ order      : num [1:369] 1 2 3 4 5 6 7 8 1 2 ...
#>  $ views      : num [1:369] 1.372 0.825 3.164 1.165 1.143 ...
#>  $ likes      : num [1:369] 18108 11301 49026 15473 13761 ...
#>  $ comments   : num [1:369] 1011 1041 3609 1226 1148 ...
```

### Categorical Codings

| Variable     | Code | Label          |
|--------------|------|----------------|
| `gender`     | 1    | Male           |
| `gender`     | 2    | Female         |
| `result`     | 1    | Succeeded      |
| `result`     | 2    | Failed         |
| `occupation` | 1    | Rapper         |
| `occupation` | 2    | Athlete        |
| `occupation` | 3    | Actor          |
| `occupation` | 4    | Actor-Comedian |
| `occupation` | 5    | Comedian       |
| `occupation` | 6    | Chef           |
| `occupation` | 7    | Actor-Musician |
| `occupation` | 8    | Musician       |
| `occupation` | 9    | DJ             |
| `occupation` | 10   | YouTuber       |
| `occupation` | 11   | Model          |
| `occupation` | 12   | Wrestler       |
| `occupation` | 13   | Magician       |
| `occupation` | 14   | Other          |

### Export to SPSS

``` r
export_hot_ones_sav("hot_ones_data.sav")
```

### Suggested Analyses

- Chi-square test of success rate by gender or occupation
- Correlation between YouTube views and season number
- Repeated measures across sauce Scoville levels

------------------------------------------------------------------------

## Tip-Jokes Experiment Data

**Dataset:** `tip_jokes` \| **Export:**
[`export_tip_jokes_sav()`](https://emmarshall.github.io/psych350data/reference/export_tip_jokes_sav.md)

Experimental data from Gueguen (2002) examining whether a waiter leaving
a joke or advertisement on a card affects tipping.

``` r
str(tip_jokes)
#> tibble [211 × 5] (S3: tbl_df/tbl/data.frame)
#>  $ card: num [1:211] 3 2 1 3 3 3 1 1 3 3 ...
#>  $ tip : num [1:211] 1 1 0 0 1 0 0 0 0 0 ...
#>  $ ad  : num [1:211] 0 0 1 0 0 0 1 1 0 0 ...
#>  $ joke: num [1:211] 0 1 0 0 0 0 0 0 0 0 ...
#>  $ none: num [1:211] 1 0 0 1 1 1 0 0 1 1 ...
```

### Categorical Codings

| Variable | Code | Label                |
|----------|------|----------------------|
| `card`   | 1    | Advertisement card   |
| `card`   | 2    | Joke card            |
| `card`   | 3    | No card              |
| `tip`    | 0    | No tip               |
| `tip`    | 1    | Customer left a tip  |
| `ad`     | 0    | No ad card           |
| `ad`     | 1    | Ad card left         |
| `joke`   | 0    | No joke card         |
| `joke`   | 1    | Joke card left       |
| `none`   | 0    | Ad or joke card left |
| `none`   | 1    | No card left         |

### Export to SPSS

``` r
export_tip_jokes_sav("tip_jokes_data.sav")
```

### Suggested Analyses

- Chi-square test of independence (card type × tipping)
- Logistic regression predicting tip from card type

------------------------------------------------------------------------

## MCU Films Data

**Dataset:** `mcu` \| **Export:**
[`export_mcu_sav()`](https://emmarshall.github.io/psych350data/reference/export_mcu_sav.md)

Marvel Cinematic Universe films through the Infinity Saga with box
office and Rotten Tomatoes data.

``` r
str(mcu)
#> tibble [23 × 11] (S3: tbl_df/tbl/data.frame)
#>  $ movie             : chr [1:23] "Iron Man" "The Incredible Hulk" "Iron Man 2" "Thor" ...
#>  $ length_hrs        : num [1:23] 2 1 2 1 2 2 2 1 2 2 ...
#>  $ length_min        : num [1:23] 6 52 4 55 4 23 10 52 16 1 ...
#>  $ release_date      : POSIXct[1:23], format: "2008-05-02" "2008-06-12" ...
#>  $ opening_weekend_us: num [1:23] 9.86e+07 5.54e+07 1.28e+08 6.57e+07 6.51e+07 ...
#>  $ gross_us          : num [1:23] 3.19e+08 1.35e+08 3.12e+08 1.81e+08 1.77e+08 ...
#>  $ gross_world       : num [1:23] 5.86e+08 2.65e+08 6.24e+08 4.49e+08 3.71e+08 ...
#>  $ phase             : num [1:23] 1 1 1 1 1 1 2 2 2 2 ...
#>  $ critics           : num [1:23] 94 68 72 77 80 91 79 67 90 91 ...
#>  $ audience          : num [1:23] 91 69 71 76 75 91 78 74 92 92 ...
#>  $ favor             : num [1:23] 1 2 1 1 1 NA 1 2 2 2 ...
```

### Categorical Codings

| Variable | Code | Label                 |
|----------|------|-----------------------|
| `phase`  | 1    | Phase 1               |
| `phase`  | 2    | Phase 2               |
| `phase`  | 3    | Phase 3               |
| `favor`  | 1    | Critics score higher  |
| `favor`  | 2    | Audience score higher |

### Export to SPSS

``` r
export_mcu_sav("mcu_data.sav")
```

### Suggested Analyses

- One-way ANOVA comparing box office by phase
- Paired comparison of critics vs. audience scores
- Regression predicting worldwide gross

------------------------------------------------------------------------

## Mock Jury Data

**Dataset:** `mock_jury` \| **Export:**
[`export_mock_jury_sav()`](https://emmarshall.github.io/psych350data/reference/export_mock_jury_sav.md)

Data from Plaster (1989) on effects of defendant attractiveness on mock
jury sentencing decisions.

``` r
str(mock_jury)
#> tibble [114 × 17] (S3: tbl_df/tbl/data.frame)
#>  $ attr         : num [1:114] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ crime        : num [1:114] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ years        : num [1:114] 10 3 5 1 7 7 3 7 2 3 ...
#>  $ serious      : num [1:114] 8 8 5 3 9 9 4 4 5 2 ...
#>  $ exciting     : num [1:114] 6 9 3 3 1 1 5 4 4 6 ...
#>  $ calm         : num [1:114] 9 5 4 6 1 5 6 9 8 8 ...
#>  $ independent  : num [1:114] 9 9 6 9 5 7 7 2 8 7 ...
#>  $ sincere      : num [1:114] 8 3 3 8 1 5 6 9 7 5 ...
#>  $ warm         : num [1:114] 5 5 6 8 8 8 7 6 1 7 ...
#>  $ phyattr      : num [1:114] 9 9 7 9 8 8 8 5 9 8 ...
#>  $ sociable     : num [1:114] 9 9 4 9 9 9 7 2 1 9 ...
#>  $ kind         : num [1:114] 9 4 2 9 4 5 5 9 5 7 ...
#>  $ intelligent  : num [1:114] 6 9 4 9 7 8 7 9 9 9 ...
#>  $ strong       : num [1:114] 9 5 5 9 9 9 5 2 7 5 ...
#>  $ sophisticated: num [1:114] 9 5 4 9 9 9 6 2 7 6 ...
#>  $ happy        : num [1:114] 5 5 5 9 8 9 5 2 6 8 ...
#>  $ ownPA        : num [1:114] 9 7 5 9 7 9 6 5 3 6 ...
```

### Categorical Codings

| Variable | Code | Label        |
|----------|------|--------------|
| `attr`   | 1    | Beautiful    |
| `attr`   | 2    | Average      |
| `attr`   | 3    | Unattractive |
| `crime`  | 1    | Burglary     |
| `crime`  | 2    | Swindle      |

### Export to SPSS

``` r
export_mock_jury_sav("mock_jury_data.sav")
```

### Suggested Analyses

- Two-way ANOVA (attractiveness × crime type) on sentence length
- Correlation among photo rating variables
- Multiple regression predicting sentence from photo ratings

------------------------------------------------------------------------

## Candy Rankings Data

**Full dataset:** `candy` (85 rows × 13 variables) \| **Export:**
[`export_candy_sav()`](https://emmarshall.github.io/psych350data/reference/export_candy_sav.md)
**Simplified:** `candy_simple` (85 rows × 5 variables) \| **Export:**
[`export_candy_simple_sav()`](https://emmarshall.github.io/psych350data/reference/export_candy_simple_sav.md)

Candy power rankings based on 269,000 head-to-head matchups.

``` r
str(candy_simple)
#> tibble [85 × 5] (S3: tbl_df/tbl/data.frame)
#>  $ competitorname: chr [1:85] "100 Grand" "3 Musketeers" "One dime" "One quarter" ...
#>  $ chocolate     : num [1:85] 1 1 0 0 0 1 1 0 0 0 ...
#>  $ sugarpercent  : num [1:85] 0.732 0.604 0.011 0.011 0.906 ...
#>  $ pricepercent  : num [1:85] 0.86 0.511 0.116 0.511 0.511 ...
#>  $ winpercent    : num [1:85] 67 67.6 32.3 46.1 52.3 ...
```

### Binary Variable Codings (full dataset)

All ingredient variables: 0 = No, 1 = Yes

Applies to: `chocolate`, `fruity`, `caramel`, `peanutyalmondy`,
`nougat`, `crispedricewafer`, `hard`, `bar`, `pluribus`

### Export to SPSS

``` r
# Full dataset with all ingredient variables
export_candy_sav("candy_data.sav")

# Simplified dataset (5 variables only)
export_candy_simple_sav("candy_simple_data.sav")
```

### Suggested Analyses

- Independent samples t-test (chocolate vs. non-chocolate win %)
- Multiple regression predicting win percentage
- Correlation between sugar, price, and win percentages

------------------------------------------------------------------------

## Football Concussion Data

**Dataset:** `football` \| **Export:**
[`export_football_sav()`](https://emmarshall.github.io/psych350data/reference/export_football_sav.md)

Brain measurements comparing football players to controls, from Singh et
al. (2014).

``` r
str(football)
#> tibble [75 × 3] (S3: tbl_df/tbl/data.frame)
#>  $ group : num [1:75] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ years : num [1:75] 0 0 0 0 0 0 0 0 0 0 ...
#>  $ volume: num [1:75] 6.17 6.22 6.36 6.46 6.54 ...
```

### Categorical Codings

| Variable | Code | Label                            |
|----------|------|----------------------------------|
| `group`  | 1    | Control (no football)            |
| `group`  | 2    | Football, no concussions         |
| `group`  | 3    | Football with concussion history |

### Export to SPSS

``` r
export_football_sav("football_data.sav")
```
