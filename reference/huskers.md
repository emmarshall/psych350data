# Nebraska Football Box Scores (1962–2024)

Game-level team statistics for all Nebraska Cornhuskers football games
from September 1962 through the 2024 season. Includes scoring, rushing,
passing, turnovers, penalties, point spreads, and weather data.

## Usage

``` r
huskers
```

## Format

A data frame with columns:

- date:

  Date the game was played.

- time:

  Kickoff time (Central Time).

- season:

  Season (year) the game was played.

- opp:

  Nebraska's opponent.

- site:

  Game location: "home", "away", "neutral-home", or "neutral-away".

- conference:

  Whether the opponent was a conference opponent (TRUE/FALSE).

- opp_rank:

  Opponent's ranking entering the game (CFP when available, otherwise
  AP).

- ne_rank:

  Nebraska's ranking entering the game (CFP when available, otherwise
  AP).

- result:

  Game result: W (Win), L (Loss), or T (Tie).

- opp_score:

  Opponent's total score.

- ne_score:

  Nebraska's total score.

- opp_score_q1:

  Opponent's first quarter points.

- opp_score_q2:

  Opponent's second quarter points.

- opp_score_q3:

  Opponent's third quarter points.

- opp_score_q4:

  Opponent's fourth quarter points.

- opp_score_ot:

  Opponent's overtime points.

- ne_score_q1:

  Nebraska's first quarter points.

- ne_score_q2:

  Nebraska's second quarter points.

- ne_score_q3:

  Nebraska's third quarter points.

- ne_score_q4:

  Nebraska's fourth quarter points.

- ne_score_ot:

  Nebraska's overtime points.

- opp_rush_att:

  Opponent's rushing attempts.

- opp_rush_yards:

  Opponent's rushing yards.

- ne_rush_att:

  Nebraska's rushing attempts.

- ne_rush_yards:

  Nebraska's rushing yards.

- opp_pass_comp:

  Opponent's passing completions.

- opp_pass_att:

  Opponent's passing attempts.

- opp_pass_yards:

  Opponent's passing yards.

- ne_pass_comp:

  Nebraska's passing completions.

- ne_pass_att:

  Nebraska's passing attempts.

- ne_pass_yards:

  Nebraska's passing yards.

- opp_first_downs:

  Opponent's first downs.

- ne_first_downs:

  Nebraska's first downs.

- opp_third_down_comp:

  Opponent's successful third down conversions.

- opp_third_down_att:

  Opponent's third down attempts.

- ne_third_down_comp:

  Nebraska's successful third down conversions.

- ne_third_down_att:

  Nebraska's third down attempts.

- opp_fourth_down_comp:

  Opponent's successful fourth down conversions.

- opp_fourth_down_att:

  Opponent's fourth down attempts.

- ne_fourth_down_comp:

  Nebraska's successful fourth down conversions.

- ne_fourth_down_att:

  Nebraska's fourth down attempts.

- opp_int:

  Interceptions thrown by the opponent.

- opp_fum:

  Fumbles lost by the opponent.

- ne_int:

  Interceptions thrown by Nebraska.

- ne_fum:

  Fumbles lost by Nebraska.

- opp_pen_num:

  Opponent's number of penalties.

- opp_pen_yards:

  Opponent's penalty yards.

- ne_pen_num:

  Nebraska's number of penalties.

- ne_pen_yards:

  Nebraska's penalty yards.

- opp_possession:

  Opponent's time of possession (MM:SS).

- ne_possession:

  Nebraska's time of possession (MM:SS).

- spread:

  Point spread. Negative means Nebraska was favored.

- total:

  Betting total (Over/Under).

- temp:

  Temperature at kickoff (Fahrenheit).

- humidity:

  Relative humidity at kickoff (0.0 to 1.0).

- wind_speed:

  Wind speed at kickoff (mph).

- wind_bearing:

  Wind direction at kickoff in degrees (0 = North, clockwise).

## Source

Compiled from historical Nebraska football records.

## Details

Data completeness notes:

- Scoring by quarter, first down, third/fourth down, and opponent
  penalty data begins in the 2004 season.

- Nebraska penalty data is incomplete before 1972-09-16 (Texas A&M).

- Time of possession data begins in 2012, complete from 2013 onward.

- Point spread data is mostly absent before 1978; available for most
  games from 1978 onward.

- Betting total data is available for most games from 2006 onward.

- Weather data sourced from the DarkSky API and Weather Underground.
  Temperature and humidity are fairly reliable; wind data less so.
