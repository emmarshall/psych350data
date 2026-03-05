#' @importFrom dplyr mutate across where case_when if_else select rename
#'   left_join filter pull
NULL

#' @importFrom rlang .data
NULL

#' Internal: Replace NA with a sentinel value
#' @param x A vector
#' @param sentinel The sentinel value to use (default: -99)
#' @return Vector with NAs replaced by sentinel
#' @noRd
replace_na_sentinel <- function(x, sentinel = -99) {
  if (is.numeric(x)) {
    ifelse(is.na(x), sentinel, x)
  } else if (is.character(x)) {
    ifelse(is.na(x) | x == "", as.character(sentinel), x)
  } else {
    x
  }
}

#' Internal: Replace sentinel value with NA
#' @param x A vector
#' @param sentinel The sentinel value to replace (default: -99)
#' @return Vector with sentinel replaced by NA
#' @noRd
replace_sentinel_na <- function(x, sentinel = -99) {
  if (is.numeric(x)) {
    ifelse(x == sentinel, NA_real_, x)
  } else if (is.character(x)) {
    ifelse(x == as.character(sentinel), NA_character_, x)
  } else {
    x
  }
}

#' psych350data: Datasets for UNL PSYC 350 Labs
#'
#' Provides cleaned and labeled datasets used in PSYC 350 lab exercises.
#' Datasets are available as R tibbles with human-readable categorical values
#' and can be exported as SPSS (.sav) files with full variable labels,
#' value labels, and defined missing values.
#'
#' @section Using Datasets in R:
#' All datasets are immediately available after loading the package:
#' ```
#' library(psych350data)
#' superman
#' ```
#'
#' Categorical variables use human-readable character values in R
#' (e.g., "Minimal", "Average", "Big" for height_gap).
#' Missing values are represented as `NA`.
#'
#' @section Exporting to SPSS:
#' Use `export_sav()` or dataset-specific functions like `export_superman_sav()`.
#' Exports include:
#' \itemize{
#'   \item Variable labels for all columns
#'   \item Value labels for categorical variables (converted to numeric codes)
#'   \item Missing values coded as -99 with SPSS missing value definitions
#' }
#'
#' @section Available Datasets:
#' Use `list_datasets()` to see all available datasets.
#'
#' @keywords internal
"_PACKAGE"
