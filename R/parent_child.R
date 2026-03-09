#' Parent-Child Observation Data
#'
#' Simulated parent-child observational data from a study examining
#' the effects of a remediation treatment on parenting behaviours.
#' Maternal and child demographics are included alongside coded
#' behavioural counts from structured observations.
#'
#' @format A tibble with 100 rows and 11 variables:
#' \describe{
#'   \item{casenum}{Unique case number}
#'   \item{mage}{Mother's age in years}
#'   \item{magegroup}{Mother's age group: 18-27 (1), 28-35 (2)}
#'   \item{cage}{Child's age in years}
#'   \item{cagegroup}{Child's age group: 2-3 years (1), 4-5 years (2)}
#'   \item{famtype}{Family type: 2-parent (1), mother-only (2)}
#'   \item{CLINREM}{Clinical remediation status: suggested (0), not suggested (1)}
#'   \item{tx}{Treatment condition: control (0), remediation (1)}
#'   \item{praise}{Count of praise behaviours observed}
#'   \item{direct}{Count of directive behaviours observed}
#'   \item{negat}{Count of negative behaviours observed}
#' }
#'
#' @source Simulated data generated to resemble a plausible
#'   parent-child observational study sample.
"parent_child_data"

# ---- Parent Child Observation -----------------------------------------------

#' @noRd
label_parent_child <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(
        dplyr::where(is.numeric),
        \(x) ifelse(is.na(x), -99, x)
      ))
  }

  # Step 2: Apply value labels
  df <- safe_labelled(df, "magegroup", c(
    "18-27" = 1,
    "28-35" = 2
  ))

  df <- safe_labelled(df, "cagegroup", c(
    "2-3 years" = 1,
    "4-5 years" = 2
  ))

  df <- safe_labelled(df, "famtype", c(
    "2-parent family"   = 1,
    "mother-only family" = 2
  ))

  df <- safe_labelled(df, "CLINREM", c(
    "suggested remediation"     = 0,
    "no remediation suggested"  = 1
  ))

  df <- safe_labelled(df, "tx", c(
    "no remediation (control)"  = 0,
    "remediation (treatment)"   = 1
  ))

  # Step 3: Apply variable labels
  df <- safe_var_labels(df, list(
    casenum   = "Unique case number",
    mage      = "Mother's age in years",
    magegroup = "Mother's age group (1 = 18-27, 2 = 28-35)",
    cage      = "Child's age in years",
    cagegroup = "Child's age group (1 = 2-3 years, 2 = 4-5 years)",
    famtype   = "Family type (1 = 2-parent, 2 = mother-only)",
    CLINREM   = "Clinical remediation status (0 = suggested, 1 = not suggested)",
    tx        = "Treatment condition (0 = control, 1 = remediation)",
    praise    = "Count of praise behaviors observed",
    direct    = "Count of directive behaviors observed",
    negat     = "Count of negative behaviors observed"
  ))

  # Step 4: Set SPSS formats
  format_map <- list(
    casenum   = "F3.0",
    mage      = "F4.1",
    magegroup = "F1.0",
    cage      = "F4.2",
    cagegroup = "F1.0",
    famtype   = "F1.0",
    CLINREM   = "F1.0",
    tx        = "F1.0",
    praise    = "F3.0",
    direct    = "F3.0",
    negat     = "F3.0"
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
