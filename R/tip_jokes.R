#' Tip-Jokes Experiment Data
#'
#' Data from Gueguen (2002) examining whether a waiter leaving a joke
#' or an advertisement on a card affects tipping behavior.
#'
#' @format A data frame with variables:
#' \describe{
#'   \item{card}{Type of card: Advertisement (1), Joke (2), None (3)}
#'   \item{tip}{Whether customer left a tip: No (0), Yes (1)}
#'   \item{ad}{Indicator for ad card: 0/1}
#'   \item{joke}{Indicator for joke card: 0/1}
#'   \item{none}{Indicator for no card: 0/1}
#' }
#'
#' @source Gueguen, N. (2002). Journal of Applied Social Psychology.
"tip_jokes"


# ---- Tip Jokes --------------------------------------------------------------

#' @noRd
label_tip_jokes <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("card" %in% names(df) && is.character(df$card)) {
    df$card <- dplyr::case_match(
      df$card,
      "Advertisement" ~ 1,
      "Joke" ~ 2,
      "None" ~ 3,
      .default = NA_real_
    )
  }

  # Convert Yes/No variables to 0/1
  yes_no_vars <- c("tip", "ad", "joke", "none")
  for (var in yes_no_vars) {
    if (var %in% names(df) && is.character(df[[var]])) {
      df[[var]] <- dplyr::case_match(
        df[[var]],
        "Yes" ~ 1,
        "No" ~ 0,
        .default = NA_real_
      )
    }
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "card", c(
    "Advertisement card" = 1,
    "Joke card" = 2,
    "No card" = 3
  ))
  df <- safe_labelled(df, "tip", c("No" = 0, "Yes" = 1))
  df <- safe_labelled(df, "ad", c("No" = 0, "Yes" = 1))
  df <- safe_labelled(df, "joke", c("No" = 0, "Yes" = 1))
  df <- safe_labelled(df, "none", c("No" = 0, "Yes" = 1))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    card = "Type of card left by waiter",
    tip = "Whether customer left a tip",
    ad = "Indicator for advertisement card",
    joke = "Indicator for joke card",
    none = "Indicator for no card"
  ))

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}
