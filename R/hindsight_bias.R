#' Hindsight Bias Data - Between-Groups Format
#'
#' Simulated data from a hindsight bias study in which participants
#' viewed celebrity faces and estimated recognition time at baseline
#' and again after receiving an outcome cue. The between-groups factor
#' is whether participants saw old or new faces in the hindsight phase.
#' Each row represents one participant-face trial.
#'
#' @format A tibble with 600 rows (60 participants x 10 faces) and 7 variables:
#' \describe{
#'   \item{participant_id}{Unique participant identifier}
#'   \item{face_id}{Face stimulus identifier (1-10)}
#'   \item{condition}{Between-groups experimental condition: Old (1), New (2)}
#'   \item{fame_level}{Celebrity fame level: Extremely Famous (1), Moderately Famous (2)}
#'   \item{score_1}{Time to identify celebrity at baseline (seconds)}
#'   \item{score_2}{Time to identify celebrity in hindsight phase (seconds)}
#'   \item{correct}{Correct identification at baseline: Incorrect (0), Correct (1)}
#' }
#'
#' @source Simulated data generated to illustrate hindsight bias
#'   in a between-groups design.
"hindsight_mg_data"


#' Hindsight Bias Data - Within-Groups Format
#'
#' Participant-level summary of the hindsight bias study, averaged
#' across faces within each fame level. Each row is one participant
#' with separate columns for extremely and moderately famous faces
#' at baseline and hindsight phases. Suitable for a 2x2 repeated-
#' measures or mixed ANOVA.
#'
#' @format A tibble with 60 rows and 6 variables:
#' \describe{
#'   \item{participant_id}{Unique participant identifier}
#'   \item{condition}{Experimental condition: Old (1), New (2)}
#'   \item{EXTREMEavg_1}{Average baseline score - extremely famous faces (seconds)}
#'   \item{MODERATEavg_1}{Average baseline score - moderately famous faces (seconds)}
#'   \item{EXTREMEavg_2}{Average hindsight score - extremely famous faces (seconds)}
#'   \item{MODERATEavg_2}{Average hindsight score - moderately famous faces (seconds)}
#' }
#'
#' @source Simulated data generated to illustrate hindsight bias
#'   in a within-groups design.
"hindsight_wg_data"

# ---- Label functions
# ---- Hindsight MG (Between-Groups) ------------------------------------------

#' @noRd
label_hindsight_mg <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(
        dplyr::where(is.numeric),
        \(x) ifelse(is.na(x), -99, x)
      ))
  }

  # Step 2: Apply value labels
  df <- safe_labelled(df, "condition", c(
    "Old" = 1,
    "New" = 2
  ))

  df <- safe_labelled(df, "fame_level", c(
    "Extremely Famous"  = 1,
    "Moderately Famous" = 2
  ))

  df <- safe_labelled(df, "correct", c(
    "Incorrect" = 0,
    "Correct"   = 1
  ))

  # Step 3: Apply variable labels
  df <- safe_var_labels(df, list(
    participant_id = "Participant ID",
    face_id        = "Face ID",
    condition      = "Experimental condition (1 = Old, 2 = New)",
    fame_level     = "Celebrity fame level (1 = Extremely Famous, 2 = Moderately Famous)",
    score_1        = "Time to identify celebrity at baseline (seconds)",
    score_2        = "Time to identify celebrity in hindsight phase (seconds)",
    correct        = "Correct identification at baseline (0 = Incorrect, 1 = Correct)"
  ))

  # Step 4: Set SPSS formats
  format_map <- list(
    participant_id = "F3.0",
    face_id        = "F2.0",
    condition      = "F1.0",
    fame_level     = "F1.0",
    score_1        = "F6.2",
    score_2        = "F6.2",
    correct        = "F1.0"
  )

  for (var in names(format_map)) {
    if (var %in% names(df)) {
      attr(df[[var]], "format.spss") <- format_map[[var]]
    }
  }

  # Step 5: Set -99 as SPSS missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Hindsight WG (Within-Groups) -------------------------------------------

#' @noRd
label_hindsight_wg <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(
        dplyr::where(is.numeric),
        \(x) ifelse(is.na(x), -99, x)
      ))
  }

  # Step 2: Apply value labels (condition only - no other categoricals in wide format)
  df <- safe_labelled(df, "condition", c(
    "Old" = 1,
    "New" = 2
  ))

  # Step 3: Apply variable labels
  df <- safe_var_labels(df, list(
    participant_id = "Participant ID",
    condition      = "Experimental condition (1 = Old, 2 = New)",
    EXTREMEavg_1  = "Average baseline score - extremely famous faces (seconds)",
    MODERATEavg_1 = "Average baseline score - moderately famous faces (seconds)",
    EXTREMEavg_2  = "Average hindsight score - extremely famous faces (seconds)",
    MODERATEavg_2 = "Average hindsight score - moderately famous faces (seconds)"
  ))

  # Step 4: Set SPSS formats
  format_map <- list(
    participant_id = "F3.0",
    condition      = "F1.0",
    EXTREMEavg_1  = "F6.2",
    MODERATEavg_1 = "F6.2",
    EXTREMEavg_2  = "F6.2",
    MODERATEavg_2 = "F6.2"
  )

  for (var in names(format_map)) {
    if (var %in% names(df)) {
      attr(df[[var]], "format.spss") <- format_map[[var]]
    }
  }

  # Step 5: Set -99 as SPSS missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}
