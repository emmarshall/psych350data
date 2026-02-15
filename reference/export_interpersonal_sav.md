# Export Interpersonal Relationships data as SPSS .sav file

Export Interpersonal Relationships data as SPSS .sav file

## Usage

``` r
export_interpersonal_sav(path = "interpersonal_data.sav", use_sentinel = TRUE)
```

## Arguments

- path:

  File path. Defaults to "superman_data.sav".

- use_sentinel:

  If TRUE (default), NA becomes -99 with SPSS missing codes.

## Value

Invisibly returns the labelled data frame.
