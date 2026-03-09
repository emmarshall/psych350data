#' MCU Films Data
#'
#' Data on Marvel Cinematic Universe films through the Infinity Saga,
#' including box office performance and Rotten Tomatoes scores.
#' Source is openintro package
#'
#' @format A data frame with variables:
#' \describe{
#'   \item{movie}{Title of the movie}
#'   \item{length_hrs}{Movie length: hours portion}
#'   \item{length_min}{Movie length: minutes portion}
#'   \item{release_date}{US release date}
#'   \item{opening_weekend_us}{Opening weekend US box office (unadjusted)}
#'   \item{gross_us}{Total US box office (unadjusted)}
#'   \item{gross_world}{Total worldwide box office (unadjusted)}
#'   \item{phase}{MCU Phase: 1, 2, or 3}
#'   \item{critics}{RT critics score (0-100)}
#'   \item{audience}{RT audience score (0-100)}
#'   \item{favor}{Whether critics (1) or audience (2) score is higher}
#' }
#'
#' @source Internet Movie Database
"mcu"


# ---- MCU --------------------------------------------------------------------

#' @noRd
label_mcu <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("phase" %in% names(df) && is.character(df$phase)) {
    df$phase <- dplyr::case_match(
      df$phase,
      "Phase 1" ~ 1,
      "Phase 2" ~ 2,
      "Phase 3" ~ 3,
      .default = NA_real_
    )
  }

  if ("favor" %in% names(df) && is.character(df$favor)) {
    df$favor <- dplyr::case_match(
      df$favor,
      "Critics" ~ 1,
      "Audience" ~ 2,
      .default = NA_real_
    )
  }

  # Step 2: Ensure numeric columns are numeric
  numeric_cols <- c("length_hrs", "length_min", "opening_weekend_us", "gross_us",
                    "gross_world", "critics", "audience")
  for (col in numeric_cols) {
    if (col %in% names(df)) {
      df[[col]] <- as.numeric(df[[col]])
    }
  }

  # Step 3: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 4: Apply value labels
  df <- safe_labelled(df, "phase", c("Phase 1" = 1, "Phase 2" = 2, "Phase 3" = 3))
  df <- safe_labelled(df, "favor", c("Critics" = 1, "Audience" = 2))

  # Step 5: Apply variable labels
  df <- safe_var_labels(df, list(
    movie = "Title of the movie",
    length_hrs = "Length of the movie: hours portion",
    length_min = "Length of the movie: minutes portion",
    release_date = "Date the movie was released in the US",
    opening_weekend_us = "Box office totals for opening weekend in the US (not adjusted for inflation)",
    gross_us = "All box office totals in US (not adjusted for inflation)",
    gross_world = "All box office totals world wide (not adjusted for inflation)",
    phase = "Designated phase of the Marvel Cinematic Universe",
    critics = "Rotten Tomatoes critics score (0-100 scale)",
    audience = "Rotten Tomatoes audience score (0-100 scale)",
    favor = "Whether critics or audience score is higher on Rotten Tomatoes"
  ))

  # Step 6: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}
