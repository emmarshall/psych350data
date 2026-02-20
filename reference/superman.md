# Superman Actor Data

Physical characteristics and ratings data for actors who have played
Superman across various films and TV shows.

## Usage

``` r
superman
```

## Format

A tibble with 11 rows and variables:

- num:

  Participant id number

- type:

  Media type (Film, TV Show, Serial)

- title:

  Title of the production

- year:

  Release year

- clark_actor:

  Actor playing Clark Kent/Superman

- clark_height:

  Clark Kent/Superman actor's height in meters

- clark_age:

  Clark Kent/Superman actor's age at debut \#'(years)

- lois_actor:

  Actor playing Lois Lane

- lois_height:

  Lois Lane actor's height in meters

- lois_age:

  Lois Lane actor's age at debut (years)

- clark_height_in:

  Clark Kent/Superman actor's height in inches

- lois_height_in:

  Lois Lane actor's height in inches

- clark_grp:

  Clark Height group: 1 = under 72 inches, 2 = 72+ inches

- height_diff:

  Height difference between Lois and Clark in inches (Clark - Lois)

- age_diff:

  Age difference between Lois and Clark in years

- age_gap:

  Height gap category: 1 = \<6in, 2 = 6-8in, 3 = \>8in

- rt_critics_score:

  Rotten Tomatoes critics score

- rt_audience_score:

  Rotten Tomatoes audience score

- tomatometer:

  Critics rating: 1 = Rotten (\<60), 2 = Fresh (60+)

- rt_avg:

  Average of critics and audience scores

- ldb_likes:

  Letterboxd likes

- ldb_scores:

  Letterboxd score

- popular:

  Popularity category based on Letterboxd likes

## Source

Compiled from the internet including Rotten Tomatoes, Letterboxd, and
IMDb.
