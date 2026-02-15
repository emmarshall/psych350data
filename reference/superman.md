# Superman Actor Data

Data on 11 actors who have portrayed Clark Kent/Superman across various
media, including height measurements, Rotten Tomatoes scores, and
Letterboxd ratings.

## Usage

``` r
superman
```

## Format

A tibble with 11 rows and 21 variables:

- num:

  Unique number for each actor

- media:

  Title of media (1-10, see value labels)

- year:

  Year of release

- type:

  Type of media: Film (1), TV Series (2), Serial (3)

- clark_height:

  Height of Superman actor in meters

- lois_height:

  Height of Lois Lane actor in meters (NA if unknown)

- rt_critics_score:

  Rotten Tomatoes critics score (0-100)

- rt_critic_count:

  Number of critic reviews

- rt_audience_score:

  Rotten Tomatoes audience score (0-100)

- rt_audience_count:

  Number of audience ratings

- ldb_likes:

  Letterboxd user likes

- ldb_scores:

  Letterboxd average rating (1-5 stars)

- clark_height_in:

  Height of Superman actor in inches

- lois_height_in:

  Height of Lois Lane actor in inches

- clark_grp:

  Whether Superman actor is over 6ft: under (1), over (2)

- height_diff:

  Height difference in inches

- height_gap:

  Height gap category: minimal (1), average (2), big (3)

- tomatometer:

  Fresh (2) or Rotten (1) on Rotten Tomatoes

- rt_avg:

  Average of critics and audience scores

- rt_diff:

  Weighted difference between critics and audience

- popular:

  Popularity: low (1), mid (2), high (3)

## Source

Rotten Tomatoes, Letterboxd, IMDB
