#' @importFrom dplyr mutate across where case_when if_else select rename
#'   left_join filter pull
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
