# Export all psych350data datasets as SPSS .sav files

Export all psych350data datasets as SPSS .sav files

## Usage

``` r
export_all_sav(dir = ".", use_sentinel = TRUE)
```

## Arguments

- dir:

  Directory to save all files. Created if it doesn't exist.

- use_sentinel:

  Logical. If TRUE, NA -\> -99 with SPSS missing value codes.

## Value

Invisibly returns a named list of file paths created.

## Examples

``` r
if (FALSE) { # \dontrun{
export_all_sav(dir = "~/Desktop/spss_files/")
} # }
```
