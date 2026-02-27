# Getting Started with psych350data

## Overview

The psych350data package provides all the datasets you need for PSYC 350
labs. Each dataset is pre-cleaned and ready to use — no downloading
files, no import headaches. You can also export any dataset as a fully
labeled SPSS (.sav) file with a single function call.

## Loading the Package

``` r
library(psych350data)
```

## Browsing Available Datasets

To see every dataset in the package:

``` r
list_datasets()
#>  [1] "superman"              "superman_smes"         "superman_movies"      
#>  [4] "hot_ones"              "tip_jokes"             "mcu"                  
#>  [7] "mock_jury"             "candy"                 "candy_simple"         
#> [10] "football"              "huskers"               "interpersonal_data"   
#> [13] "self_descriptive_data"
```

For detailed documentation on any dataset, use the help system:

``` r
?superman
?hot_ones
?mock_jury
```

## Using Datasets in R

Every dataset is a tibble that’s immediately available after loading the
package:

``` r
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
```

``` r
str(superman_smes)
#> tibble [47 × 5] (S3: tbl_df/tbl/data.frame)
#>  $ num                 : int [1:47] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ height_gap          : num [1:47] 2 2 3 3 3 3 3 1 3 2 ...
#>  $ emotional_impact    : num [1:47] 16 9 15 15 11 10 14 10 19 16 ...
#>  $ aesthetic_appeal    : num [1:47] 8 8 10 10 13 9 11 9 11 10 ...
#>  $ cognitive_engagement: num [1:47] 4.8 3.9 5 3.2 3.6 4.2 3.6 4.3 3 5.4 ...
```

``` r
summary(football)
#>      group       years            volume     
#>  Min.   :1   Min.   : 0.000   Min.   :4.490  
#>  1st Qu.:1   1st Qu.: 0.000   1st Qu.:5.750  
#>  Median :2   Median : 9.000   Median :6.435  
#>  Mean   :2   Mean   : 7.693   Mean   :6.599  
#>  3rd Qu.:3   3rd Qu.:13.000   3rd Qu.:7.235  
#>  Max.   :3   Max.   :18.000   Max.   :9.710
```

### Working with Categorical Variables

Categorical variables are stored as numeric codes in R. The codes map to
labels that you can see in the documentation. For example, in the
`superman` dataset:

- `type`: 1 = Film, 2 = TV Series, 3 = Serial
- `tomatometer`: 1 = Rotten, 2 = Fresh
- `popular`: 1 = Low, 2 = Mid, 3 = High

You can convert these to factors for analysis or plotting:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

superman |>
  mutate(
    type_label = factor(type, 
                        levels = c(1, 2, 3), 
                        labels = c("Film", "TV Series", "Serial"))
  ) |>
  select(media, year, type, type_label)
#> # A tibble: 11 × 4
#>    media                                         year type    type_label
#>    <chr>                                        <dbl> <chr>   <fct>     
#>  1 Superman                                      2025 Film    NA        
#>  2 Superman: The Movie                           1978 Film    NA        
#>  3 Smallville                                    2001 TV Show NA        
#>  4 Superman Returns                              2006 Film    NA        
#>  5 Superman & the Mole Men                       1951 Film    NA        
#>  6 Man of Steel                                  2013 Film    NA        
#>  7 Superman                                      1948 Serial  NA        
#>  8 Superman & Lois                               2021 TV Show NA        
#>  9 Lois & Clark: The New Adventures of Superman  1993 TV Show NA        
#> 10 The Adventures of Superboy                    1988 TV Show NA        
#> 11 The Adventures of Superboy                    1989 TV Show NA
```

### Missing Values

In R, missing values are represented as `NA`:

``` r
# See which Superman entries have missing Letterboxd scores
superman |>
  select(num, media, ldb_likes, ldb_scores) |>
  filter(is.na(ldb_scores))
#> # A tibble: 6 × 4
#>     num media                                        ldb_likes ldb_scores
#>   <int> <chr>                                            <dbl>      <dbl>
#> 1     3 Smallville                                          NA         NA
#> 2     7 Superman                                            NA         NA
#> 3     8 Superman & Lois                                     NA         NA
#> 4     9 Lois & Clark: The New Adventures of Superman        NA         NA
#> 5    10 The Adventures of Superboy                          NA         NA
#> 6    11 The Adventures of Superboy                          NA         NA
```

When exported to SPSS, these `NA` values are converted to `-99` and
marked as user-defined missing values.

## Exporting to SPSS

Every dataset has a dedicated export function that creates a fully
labeled .sav file:

``` r
# Dataset-specific export functions
export_superman_sav("superman_data.sav")
export_football_sav("~/Desktop/football_data.sav")
export_mock_jury_sav("mock_jury_data.sav")
export_hot_ones_sav("hot_ones_data.sav")
export_tip_jokes_sav("tip_jokes_data.sav")
export_mcu_sav("mcu_data.sav")
export_candy_sav("candy_data.sav")
export_candy_simple_sav("candy_simple_data.sav")
export_affairs_sav("affairs_data.sav")
export_superman_smes_sav("superman_smes_data.sav")

# Or use the generic function with any dataset name
export_sav("superman", path = "superman_data.sav")

# Or export everything at once
export_all_sav(dir = "~/Desktop/PSYC350_SPSS/")
```

See
[`vignette("exporting-spss")`](https://emmarshall.github.io/psych350data/articles/exporting-spss.md)
for full details on what the .sav files contain.

## Example Analyses

### T-test with Mock Jury Data

``` r
# Compare sentence length by crime type
# crime: 1 = Burglary, 2 = Swindle
t.test(years ~ crime, data = mock_jury)
#> 
#>  Welch Two Sample t-test
#> 
#> data:  years by crime
#> t = -0.29967, df = 101.52, p-value = 0.765
#> alternative hypothesis: true difference in means between group 1 and group 2 is not equal to 0
#> 95 percent confidence interval:
#>  -1.575524  1.161965
#> sample estimates:
#> mean in group 1 mean in group 2 
#>         4.59322         4.80000
```

### ANOVA with Football Data

``` r
# Compare hippocampus volume across groups
# group: 1 = Control, 2 = Football no concussion, 3 = Football with concussion
model <- aov(volume ~ factor(group), data = football)
summary(model)
#>               Df Sum Sq Mean Sq F value   Pr(>F)    
#> factor(group)  2  44.35  22.174   31.47 1.51e-10 ***
#> Residuals     72  50.73   0.705                     
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Correlation with Candy Data

``` r
# Relationship between sugar content and win percentage
cor.test(candy_simple$sugarpercent, candy_simple$winpercent)
#> 
#>  Pearson's product-moment correlation
#> 
#> data:  candy_simple$sugarpercent and candy_simple$winpercent
#> t = 2.1447, df = 83, p-value = 0.0349
#> alternative hypothesis: true correlation is not equal to 0
#> 95 percent confidence interval:
#>  0.01684946 0.42168089
#> sample estimates:
#>       cor 
#> 0.2291507
```

### Chi-Square with Tip Jokes Data

``` r
# Is tipping independent of card type?
table(tip_jokes$card, tip_jokes$tip) |>
  chisq.test()
#> 
#>  Pearson's Chi-squared test
#> 
#> data:  table(tip_jokes$card, tip_jokes$tip)
#> X-squared = 9.9533, df = 2, p-value = 0.006897
```

## Next Steps

- See
  [`vignette("exporting-spss")`](https://emmarshall.github.io/psych350data/articles/exporting-spss.md)
  to learn how to create SPSS files
- See
  [`vignette("dataset-guide")`](https://emmarshall.github.io/psych350data/articles/dataset-guide.md)
  for a complete reference of all datasets and their coding schemes
- Use `?dataset_name` to view full documentation for any dataset
- All datasets work with standard R functions:
  [`t.test()`](https://rdrr.io/r/stats/t.test.html),
  [`aov()`](https://rdrr.io/r/stats/aov.html),
  [`lm()`](https://rdrr.io/r/stats/lm.html),
  [`cor.test()`](https://rdrr.io/r/stats/cor.test.html),
  [`chisq.test()`](https://rdrr.io/r/stats/chisq.test.html), etc.
