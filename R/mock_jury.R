#' Mock Jury Data
#'
#' Data from Plaster (1989) examining effects of physical attractiveness
#' on mock jury sentencing decisions.
#'
#' @format A data frame with variables:
#' \describe{
#'   \item{attr}{Attractiveness: Beautiful (1), Average (2), Unattractive (3)}
#'   \item{crime}{Crime type: Burglary (1), Swindle (2)}
#'   \item{years}{Sentence length in years}
#'   \item{serious}{Seriousness rating}
#'   \item{exciting}{Rating of the photo for 'exciting'}
#'   \item{calm}{Rating of the photo for 'calm'}
#'   \item{independent}{Rating of the photo for 'independent'}
#'   \item{sincere}{Rating of the photo for 'sincere'}
#'   \item{warm}{Rating of the photo for 'warm'}
#'   \item{phyattr}{Rating of the photo for 'physical attractiveness'}
#'   \item{sociable}{Rating of the photo for 'sociable'}
#'   \item{kind}{Rating of the photo for 'kind'}
#'   \item{intelligent}{Rating of the photo for 'intelligent'}
#'   \item{strong}{Rating of the photo for 'strong'}
#'   \item{sophisticated}{Rating of the photo for 'sophisticated'}
#'   \item{happy}{Rating of the photo for 'happy'}
#'   \item{ownPA}{Self-rating of physical attractiveness}
#' }
#'
#' @source Plaster, M. E. (1989). East Carolina University.
"mock_jury"



# ---- Mock Jury --------------------------------------------------------------

#' @noRd
label_mock_jury <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("attr" %in% names(df) && is.character(df$attr)) {
    df$attr <- dplyr::case_match(
      df$attr,
      "Beautiful" ~ 1,
      "Average" ~ 2,
      "Unattractive" ~ 3,
      .default = NA_real_
    )
  }

  if ("crime" %in% names(df) && is.character(df$crime)) {
    df$crime <- dplyr::case_match(
      df$crime,
      "Burglary" ~ 1,
      "Swindle" ~ 2,
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
  df <- safe_labelled(df, "attr", c("Beautiful" = 1, "Average" = 2, "Unattractive" = 3))
  df <- safe_labelled(df, "crime", c(
    "Burglary (theft of items from victim's room)" = 1,
    "Swindle (conned a male victim)" = 2
  ))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    attr = "Attractiveness of the photo",
    crime = "Type of crime",
    years = "Length of sentence given the defendant by the mock juror subject (in years)",
    serious = "A rating of how serious the subject thought the defendant's crime was",
    exciting = "Rating of the photo for 'exciting'",
    calm = "Rating of the photo for 'calm'",
    independent = "Rating of the photo for 'independent'",
    sincere = "Rating of the photo for 'sincere'",
    warm = "Rating of the photo for 'warm'",
    phyattr = "Rating of the photo for 'physical attractiveness'",
    sociable = "Rating of the photo for 'sociable'",
    kind = "Rating of the photo for 'kind'",
    intelligent = "Rating of the photo for 'intelligent'",
    strong = "Rating of the photo for 'strong'",
    sophisticated = "Rating of the photo for 'sophisticated'",
    happy = "Rating of the photo for 'happy'",
    ownPA = "Self-rating of the subject for 'physical attractiveness'"
  ))

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}
