#' Candy Rankings Data (Full)
#'
#' Data on 85 candy types with ingredient indicators, sugar/price
#' percentiles, and win percentages from 269,000 matchups.
#'
#' @format A data frame with 85 rows and 13 variables:
#' \describe{
#'   \item{competitorname}{The name of the candy}
#'   \item{chocolate}{Contains chocolate? (0=No, 1=Yes)}
#'   \item{fruity}{Fruit flavored? (0=No, 1=Yes)}
#'   \item{caramel}{Contains caramel? (0=No, 1=Yes)}
#'   \item{peanutyalmondy}{Contains peanuts/almonds? (0=No, 1=Yes)}
#'   \item{nougat}{Contains nougat? (0=No, 1=Yes)}
#'   \item{crispedricewafer}{Contains crisped rice/wafers? (0=No, 1=Yes)}
#'   \item{hard}{Hard candy? (0=No, 1=Yes)}
#'   \item{bar}{Candy bar? (0=No, 1=Yes)}
#'   \item{pluribus}{One of many in bag/box? (0=No, 1=Yes)}
#'   \item{sugarpercent}{Sugar percentile within dataset}
#'   \item{pricepercent}{Unit price percentile}
#'   \item{winpercent}{Win percentage from 269,000 matchups}
#' }
#'
#' @source FiveThirtyEight candy power rankings
"candy"

#' Candy Rankings Data
#'
#' Simplified version with only candy name, chocolate indicator,
#' sugar percentile, price percentile, and win percentage.
#'
#' @format A data frame with 85 rows and 5 variables:
#' \describe{
#'   \item{competitorname}{The name of the candy}
#'   \item{chocolate}{Contains chocolate? (0=No, 1=Yes)}
#'   \item{sugarpercent}{Sugar percentile within dataset}
#'   \item{pricepercent}{Unit price percentile}
#'   \item{winpercent}{Win percentage from 269,000 matchups}
#' }
#'
#' @source FiveThirtyEight candy power rankings
"candy_simple"


# ---- Candy (full) -----------------------------------------------------------

#' @noRd
label_candy <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert Yes/No strings to numeric codes
  binary_vars <- c("chocolate", "fruity", "caramel", "peanutyalmondy",
                   "nougat", "crispedricewafer", "hard", "bar", "pluribus")

  for (var in binary_vars) {
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
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 3: Apply value labels
  for (var in binary_vars) {
    df <- safe_labelled(df, var, c("No" = 0, "Yes" = 1))
  }

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    competitorname = "The name of the candy",
    chocolate = "Does it contain chocolate?",
    fruity = "Is it fruit flavored?",
    caramel = "Is there caramel in the candy?",
    peanutyalmondy = "Does it contain peanuts, peanut butter or almonds?",
    nougat = "Does it contain nougat?",
    crispedricewafer = "Does it contain crisped rice, wafers, or a cookie component?",
    hard = "Is it a hard candy?",
    bar = "Is it a candy bar?",
    pluribus = "Is it one of many candies in a bag or box?",
    sugarpercent = "The percentile of sugar it falls under within the data set",
    pricepercent = "The unit price percentile compared to the rest of the set",
    winpercent = "The overall win percentage according to 269,000 matchups"
  ))

  # Set SPSS formats
  for (v in binary_vars) {
    if (v %in% names(df)) {
      attr(df[[v]], "format.spss") <- "F1.0"
      attr(df[[v]], "spss_measure") <- "nominal"
    }
  }
  for (v in c("sugarpercent", "pricepercent", "winpercent")) {
    if (v %in% names(df)) {
      attr(df[[v]], "format.spss") <- "F8.6"
      attr(df[[v]], "spss_measure") <- "scale"
    }
  }

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Candy (simple) ---------------------------------------------------------

#' @noRd
label_candy_simple <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert Yes/No to numeric
  if ("chocolate" %in% names(df) && is.character(df$chocolate)) {
    df$chocolate <- dplyr::case_match(
      df$chocolate,
      "Yes" ~ 1,
      "No" ~ 0,
      .default = NA_real_
    )
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "chocolate", c("No" = 0, "Yes" = 1))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    competitorname = "The name of the candy",
    chocolate = "Does it contain chocolate?",
    sugarpercent = "The percentile of sugar it falls under within the data set",
    pricepercent = "The unit price percentile compared to the rest of the set",
    winpercent = "The overall win percentage according to 269,000 matchups"
  ))

  # Set SPSS formats
  if ("chocolate" %in% names(df)) {
    attr(df$chocolate, "format.spss") <- "F1.0"
    attr(df$chocolate, "spss_measure") <- "nominal"
  }
  for (v in c("sugarpercent", "pricepercent", "winpercent")) {
    if (v %in% names(df)) {
      attr(df[[v]], "format.spss") <- "F8.6"
      attr(df[[v]], "spss_measure") <- "scale"
    }
  }

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}


# ---- Football ---------------------------------------------------------------

#' @noRd
label_football <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("group" %in% names(df) && is.character(df$group)) {
    df$group <- dplyr::case_match(
      df$group,
      "Control" ~ 1,
      "Football no concussion" ~ 2,
      "Football with concussion" ~ 3,
      .default = NA_real_
    )
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "group", c(
    "Control (no football)" = 1,
    "Football player, no concussions" = 2,
    "Football player with concussion history" = 3
  ))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    group = "Group classification",
    years = "Number of years a person played football",
    volume = "Total hippocampus volume, in cubic centimeters"
  ))

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}
