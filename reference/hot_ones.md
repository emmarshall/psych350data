# Hot Ones Guest Data

Data on guests from the YouTube show Hot Ones, including demographic
information, Scoville ratings for each sauce, and YouTube engagement
metrics. Categorical variables (gender, result, occupation) are stored
as numeric codes. Views are in millions.

## Usage

``` r
hot_ones
```

## Format

A tibble with variables including:

- subn:

  Unique guest/participant number

- name:

  Guest full name

- gender:

  Guest gender: Male (1), Female (2)

- age:

  Guest age at time of appearance

- occupation:

  Guest primary occupation (1-14, see value labels)

- SHU_1 through SHU_10:

  Scoville Heat Units for sauces 1-10

- result:

  Succeeded (1) or Failed (2)

- appearances:

  Number of appearances on the show

- season:

  Season number

- order:

  Episode number within season

- views:

  YouTube views (in millions)

- likes:

  YouTube likes

- comments:

  YouTube comments

## Source

Hot Ones / First We Feast (YouTube)
