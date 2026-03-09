#' Nebraska Football Box Scores (1962–2024)
#'
#' Game-level team statistics for all Nebraska Cornhuskers football games
#' from September 1962 through the 2024 season. Includes scoring, rushing,
#' passing, turnovers, penalties, point spreads, and weather data.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{date}{Date the game was played.}
#'   \item{time}{Kickoff time (Central Time).}
#'   \item{season}{Season (year) the game was played.}
#'   \item{opp}{Nebraska's opponent.}
#'   \item{site}{Game location: "home", "away", "neutral-home", or "neutral-away".}
#'   \item{conference}{Whether the opponent was a conference opponent (TRUE/FALSE).}
#'   \item{opp_rank}{Opponent's ranking entering the game (CFP when available, otherwise AP).}
#'   \item{ne_rank}{Nebraska's ranking entering the game (CFP when available, otherwise AP).}
#'   \item{result}{Game result: W (Win), L (Loss), or T (Tie).}
#'   \item{opp_score}{Opponent's total score.}
#'   \item{ne_score}{Nebraska's total score.}
#'   \item{opp_score_q1}{Opponent's first quarter points.}
#'   \item{opp_score_q2}{Opponent's second quarter points.}
#'   \item{opp_score_q3}{Opponent's third quarter points.}
#'   \item{opp_score_q4}{Opponent's fourth quarter points.}
#'   \item{opp_score_ot}{Opponent's overtime points.}
#'   \item{ne_score_q1}{Nebraska's first quarter points.}
#'   \item{ne_score_q2}{Nebraska's second quarter points.}
#'   \item{ne_score_q3}{Nebraska's third quarter points.}
#'   \item{ne_score_q4}{Nebraska's fourth quarter points.}
#'   \item{ne_score_ot}{Nebraska's overtime points.}
#'   \item{opp_rush_att}{Opponent's rushing attempts.}
#'   \item{opp_rush_yards}{Opponent's rushing yards.}
#'   \item{ne_rush_att}{Nebraska's rushing attempts.}
#'   \item{ne_rush_yards}{Nebraska's rushing yards.}
#'   \item{opp_pass_comp}{Opponent's passing completions.}
#'   \item{opp_pass_att}{Opponent's passing attempts.}
#'   \item{opp_pass_yards}{Opponent's passing yards.}
#'   \item{ne_pass_comp}{Nebraska's passing completions.}
#'   \item{ne_pass_att}{Nebraska's passing attempts.}
#'   \item{ne_pass_yards}{Nebraska's passing yards.}
#'   \item{opp_first_downs}{Opponent's first downs.}
#'   \item{ne_first_downs}{Nebraska's first downs.}
#'   \item{opp_third_down_comp}{Opponent's successful third down conversions.}
#'   \item{opp_third_down_att}{Opponent's third down attempts.}
#'   \item{ne_third_down_comp}{Nebraska's successful third down conversions.}
#'   \item{ne_third_down_att}{Nebraska's third down attempts.}
#'   \item{opp_fourth_down_comp}{Opponent's successful fourth down conversions.}
#'   \item{opp_fourth_down_att}{Opponent's fourth down attempts.}
#'   \item{ne_fourth_down_comp}{Nebraska's successful fourth down conversions.}
#'   \item{ne_fourth_down_att}{Nebraska's fourth down attempts.}
#'   \item{opp_int}{Interceptions thrown by the opponent.}
#'   \item{opp_fum}{Fumbles lost by the opponent.}
#'   \item{ne_int}{Interceptions thrown by Nebraska.}
#'   \item{ne_fum}{Fumbles lost by Nebraska.}
#'   \item{opp_pen_num}{Opponent's number of penalties.}
#'   \item{opp_pen_yards}{Opponent's penalty yards.}
#'   \item{ne_pen_num}{Nebraska's number of penalties.}
#'   \item{ne_pen_yards}{Nebraska's penalty yards.}
#'   \item{opp_possession}{Opponent's time of possession (MM:SS).}
#'   \item{ne_possession}{Nebraska's time of possession (MM:SS).}
#'   \item{spread}{Point spread. Negative means Nebraska was favored.}
#'   \item{total}{Betting total (Over/Under).}
#'   \item{temp}{Temperature at kickoff (Fahrenheit).}
#'   \item{humidity}{Relative humidity at kickoff (0.0 to 1.0).}
#'   \item{wind_speed}{Wind speed at kickoff (mph).}
#'   \item{wind_bearing}{Wind direction at kickoff in degrees (0 = North, clockwise).}
#' }
#'
#' @details
#' Data completeness notes:
#' \itemize{
#'   \item Scoring by quarter, first down, third/fourth down, and opponent penalty
#'     data begins in the 2004 season.
#'   \item Nebraska penalty data is incomplete before 1972-09-16 (Texas A&M).
#'   \item Time of possession data begins in 2012, complete from 2013 onward.
#'   \item Point spread data is mostly absent before 1978; available for most
#'     games from 1978 onward.
#'   \item Betting total data is available for most games from 2006 onward.
#'   \item Weather data sourced from the DarkSky API and Weather Underground.
#'     Temperature and humidity are fairly reliable; wind data less so.
#' }
#'
#' @source Compiled from historical Nebraska football records.
"huskers"


# ---- Huskers ----------------------------------------------------------------

#' @noRd
label_huskers <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("site" %in% names(df) && is.character(df$site)) {
    df$site <- dplyr::case_match(
      df$site,
      "Home" ~ 1,
      "Away" ~ 2,
      "Neutral (home)" ~ 3,
      "Neutral (away)" ~ 4,
      .default = NA_real_
    )
  }

  if ("result" %in% names(df) && is.character(df$result)) {
    df$result <- dplyr::case_match(
      df$result,
      "Win" ~ 1,
      "Loss" ~ 2,
      "Tie" ~ 3,
      .default = NA_real_
    )
  }

  # needed to change this to match the case_when(is.logical(...)) logic already in prep_huskers()
  if ("conference" %in% names(df)) {
    if (is.logical(df$conference)) {
      df$conference <- as.numeric(df$conference)
    } else if (is.character(df$conference)) {
      df$conference <- dplyr::case_match(
        df$conference,
        "Non-conference" ~ 0,
        "Conference"     ~ 1,
        .default = NA_real_
      )
    }
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.character),
                                  ~ifelse(is.na(.x) | .x == "", "-99", .x)))
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "result", c("Win" = 1, "Loss" = 2, "Tie" = 3))
  df <- safe_labelled(df, "site", c("Home" = 1, "Away" = 2, "Neutral (home)" = 3, "Neutral (away)" = 4))
  df <- safe_labelled(df, "conference", c("Non-conference" = 0, "Conference game" = 1))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    date = "Date the game was played",
    time = "Kickoff time (Central Time)",
    season = "Season (year)",
    opp = "Opponent",
    site = "Game location",
    conference = "Conference game",
    opp_rank = "Opponent ranking entering the game",
    ne_rank = "Nebraska ranking entering the game",
    result = "Game result",
    opp_score = "Opponent total score",
    ne_score = "Nebraska total score",
    opp_score_q1 = "Opponent 1st quarter points",
    opp_score_q2 = "Opponent 2nd quarter points",
    opp_score_q3 = "Opponent 3rd quarter points",
    opp_score_q4 = "Opponent 4th quarter points",
    opp_score_ot = "Opponent overtime points",
    ne_score_q1 = "Nebraska 1st quarter points",
    ne_score_q2 = "Nebraska 2nd quarter points",
    ne_score_q3 = "Nebraska 3rd quarter points",
    ne_score_q4 = "Nebraska 4th quarter points",
    ne_score_ot = "Nebraska overtime points",
    opp_rush_att = "Opponent rushing attempts",
    opp_rush_yards = "Opponent rushing yards",
    ne_rush_att = "Nebraska rushing attempts",
    ne_rush_yards = "Nebraska rushing yards",
    opp_pass_comp = "Opponent passing completions",
    opp_pass_att = "Opponent passing attempts",
    opp_pass_yards = "Opponent passing yards",
    ne_pass_comp = "Nebraska passing completions",
    ne_pass_att = "Nebraska passing attempts",
    ne_pass_yards = "Nebraska passing yards",
    opp_first_downs = "Opponent first downs",
    ne_first_downs = "Nebraska first downs",
    opp_third_down_comp = "Opponent third down conversions",
    opp_third_down_att = "Opponent third down attempts",
    ne_third_down_comp = "Nebraska third down conversions",
    ne_third_down_att = "Nebraska third down attempts",
    opp_fourth_down_comp = "Opponent fourth down conversions",
    opp_fourth_down_att = "Opponent fourth down attempts",
    ne_fourth_down_comp = "Nebraska fourth down conversions",
    ne_fourth_down_att = "Nebraska fourth down attempts",
    opp_int = "Opponent interceptions thrown",
    opp_fum = "Opponent fumbles lost",
    ne_int = "Nebraska interceptions thrown",
    ne_fum = "Nebraska fumbles lost",
    opp_pen_num = "Opponent number of penalties",
    opp_pen_yards = "Opponent penalty yards",
    ne_pen_num = "Nebraska number of penalties",
    ne_pen_yards = "Nebraska penalty yards",
    opp_possession = "Opponent time of possession (MM:SS)",
    ne_possession = "Nebraska time of possession (MM:SS)",
    spread = "Point spread (negative = Nebraska favored)",
    total = "Betting total (Over/Under)",
    temp = "Temperature at kickoff (Fahrenheit)",
    humidity = "Relative humidity at kickoff (0-1)",
    wind_speed = "Wind speed at kickoff (mph)",
    wind_bearing = "Wind direction at kickoff (degrees, 0=North)"
  ))

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}
