#' Internal: Replace NA with a sentinel value
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

#' Internal: Apply SPSS missing value metadata to labelled columns
#' @noRd
set_spss_missing <- function(df, vars, sentinel = -99) {
  args <- stats::setNames(rep(sentinel, length(vars)), vars)
  do.call(labelled::set_na_values, c(list(.data = df), args))
}
