# Export Candy data (full) as SPSS .sav file

Export Candy data (full) as SPSS .sav file

## Usage

``` r
export_candy_sav(path = "candy_data.sav", use_sentinel = TRUE)
```

## Arguments

- path:

  File path. Defaults to "superman_data.sav".

- use_sentinel:

  If TRUE (default), NA becomes -99 with SPSS missing codes.

## Value

Invisibly returns the labelled data frame.
