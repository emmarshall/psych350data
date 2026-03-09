#' Cheese Characteristics Data
#'
#' Cleaned subset of the cheese.com dataset originally featured in
#' TidyTuesday (June 2024). Contains cheeses with known calcium content,
#' with fat content and milk source cleaned and recoded for teaching
#' data entry and transformation in SPSS and JAMOVI.
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{id}{Unique cheese identifier}
#'   \item{cheese}{Cheese name}
#'   \item{url}{URL to the cheese page on cheese.com}
#'   \item{milk}{Raw milk source text as listed on cheese.com}
#'   \item{milk_source}{Milk source category: Cow (1), Goat (2), Sheep (3),
#'     Buffalo (4), Multiple (5), Other (6)}
#'   \item{country}{Country of origin}
#'   \item{family}{Cheese family}
#'   \item{type}{Cheese type (texture and style)}
#'   \item{vegetarian}{Vegetarian-suitable: No (0), Yes (1)}
#'   \item{color}{Cheese color}
#'   \item{fat_content}{Fat content as a percentage per serving}
#'   \item{calcium_content}{Calcium content in mg per 100g}
#' }
#'
#' @source cheese.com via TidyTuesday 2024-06-04.
#'   Raw data extracted and saved locally via \code{data-raw/extract_cheese_raw.R}.
"cheese_data"


# ---- Cheese -----------------------------------------------------------------

#' @noRd
label_cheese <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(
        dplyr::where(is.numeric),
        \(x) ifelse(is.na(x), -99, x)
      ))
  }

  # Step 2: Apply value labels
  df <- safe_labelled(df, "milk_source", c(
    "Cow"      = 1,
    "Goat"     = 2,
    "Sheep"    = 3,
    "Buffalo"  = 4,
    "Multiple" = 5,
    "Other"    = 6
  ))

  df <- safe_labelled(df, "vegetarian", c(
    "No"  = 0,
    "Yes" = 1
  ))

  # Step 3: Apply variable labels
  df <- safe_var_labels(df, list(
    id              = "Unique cheese identifier",
    cheese          = "Cheese name",
    url             = "URL to cheese page on cheese.com",
    milk            = "Raw milk source text from cheese.com",
    milk_source     = "Milk source category (1=Cow, 2=Goat, 3=Sheep, 4=Buffalo, 5=Multiple, 6=Other)",
    country         = "Country of origin",
    family          = "Cheese family",
    type            = "Cheese type (texture/style)",
    vegetarian      = "Suitable for vegetarians (0=No, 1=Yes)",
    color           = "Cheese color",
    fat_content     = "Fat content (% per serving)",
    calcium_content = "Calcium content (mg per 100g)"
  ))

  # Step 4: Set SPSS formats
  format_map <- list(
    id              = "F4.0",
    milk_source     = "F1.0",
    vegetarian      = "F1.0",
    fat_content     = "F6.2",
    calcium_content = "F7.2"
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
