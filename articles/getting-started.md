# Getting Started with psyc350data

## Overview

The psyc350data package provides all the datasets you need for PSYC 350
labs. Each dataset is pre-cleaned and ready to use — no downloading
files, no import headaches.

## Loading the Package

``` r
library(psyc350data)
```

## Browsing Available Datasets

To see every dataset in the package:

``` r
list_datasets()
#>  [1] "superman"      "superman_smes" "hot_ones"      "tip_jokes"    
#>  [5] "mcu"           "mock_jury"     "candy"         "candy_simple" 
#>  [9] "affairs"       "football"
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
```

``` r
str(superman_smes)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    47 obs. of  5 variables:
#>  $ num                 : int  1 2 3 4 5 6 7 8 9 10 ...
#>  $ height_gap          : num  2 2 3 3 3 3 3 1 3 2 ...
#>  $ emotional_impact    : num  16 9 15 15 11 10 14 10 19 16 ...
#>  $ aesthetic_appeal    : num  8 8 10 10 13 9 11 9 11 10 ...
#>  $ cognitive_engagement: num  4.8 3.9 5 3.2 3.6 4.2 3.6 4.3 3 5.4 ...
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
#>    media  year  type type_label
#>    <dbl> <dbl> <dbl> <fct>     
#>  1     1  2025     1 Film      
#>  2     2  1978     1 Film      
#>  3     3  2001     2 TV Series 
#>  4     4  2006     1 Film      
#>  5     5  1951     3 Serial    
#>  6     6  2013     1 Film      
#>  7     7  1948     3 Serial    
#>  8     8  2021     2 TV Series 
#>  9     9  1993     2 TV Series 
#> 10    10  1988     2 TV Series 
#> 11    10  1989     2 TV Series
```

### Missing Values

In R, missing values are represented as `NA`:

``` r
# See which Superman entries have missing Letterboxd scores
superman |>
  select(num, media, ldb_likes, ldb_scores) |>
  filter(is.na(ldb_scores))
#> # A tibble: 6 × 4
#>     num media ldb_likes ldb_scores
#>   <int> <dbl>     <dbl>      <dbl>
#> 1     3     3        NA         NA
#> 2     7     7        NA         NA
#> 3     8     8        NA         NA
#> 4     9     9        NA         NA
#> 5    10    10        NA         NA
#> 6    11    10        NA         NA
```

When exported to SPSS, these `NA` values are converted to `-99` and
marked as user-defined missing values.

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
- Use `?dataset_name` to view full documentation for any dataset
- All datasets work with standard R functions:
  [`t.test()`](https://rdrr.io/r/stats/t.test.html),
  [`aov()`](https://rdrr.io/r/stats/aov.html),
  [`lm()`](https://rdrr.io/r/stats/lm.html),
  [`cor.test()`](https://rdrr.io/r/stats/cor.test.html),
  [`chisq.test()`](https://rdrr.io/r/stats/chisq.test.html), etc.
