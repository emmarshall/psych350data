#' Lincoln Police Department Traffic Stops Data
#'
#' Traffic stop records from the Lincoln Police Department Open Data Portal,
#' compiled from a multi-sheet Excel file with one sheet per year and stacked
#' into a single data frame. Date and time variables have been parsed and
#' a time-of-day category added. All categorical variables are stored as
#' integers with SPSS-style value labels.
#'
#' @format A tibble with the following variables:
#' \describe{
#'   \item{year}{Year of the traffic stop (from Excel sheet name)}
#'   \item{fid}{Feature ID — unique stop identifier}
#'   \item{date}{Date of the traffic stop}
#'   \item{month}{Month of the traffic stop (1–12)}
#'   \item{time}{Time of the traffic stop (HH:MM, 24-hour format)}
#'   \item{time_of_day}{Time of day: Morning 5am–noon (1), Afternoon noon–5pm (2), Evening 5pm–9pm (3), Night 9pm–5am (4)}
#'   \item{race}{Driver race/ethnicity: White (1), Black (2), Hispanic (3), Asian (4), American Indian (5), Other (6)}
#'   \item{sex}{Driver sex: Male (1), Female (2)}
#'   \item{reason}{Reason for stop: Traffic probable cause (1), Criminal probable cause (2), Other (3)}
#'   \item{outcome}{Stop outcome: Traffic warning (1), Traffic official (2), Criminal cite and release (3), Lodged in jail (4), None (5)}
#'   \item{search}{Search conducted: None (1), Incident to arrest (2), Inventory (3), Consent (4), Probable cause (5)}
#' }
#'
#' @note Column names and categorical values reflect the LPD data dictionary.
#'   Check \code{data-raw/lpd_stops_data.R} if the portal changes its export
#'   format.
#'
#' @source Lincoln Police Department Open Data Portal.
#'   \url{https://opendata.lincoln.ne.gov/datasets/lpd-traffic-stops-2023/about}
"lpd_data"


# ---- LPD Traffic Stops ------------------------------------------------------
#' @noRd
label_lpd <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(
        dplyr::where(is.numeric),
        \(x) ifelse(is.na(x), -99, x)
      ))
  }

  # Step 2: Apply value labels
  df <- safe_labelled(df, "time_of_day", c(
    "Morning (5am-noon)"   = 1,
    "Afternoon (noon-5pm)" = 2,
    "Evening (5pm-9pm)"    = 3,
    "Night (9pm-5am)"      = 4
  ))

  df <- safe_labelled(df, "race", c(
    "White"            = 1,
    "Black"            = 2,
    "Hispanic"         = 3,
    "Asian"            = 4,
    "American Indian"  = 5,
    "Other"            = 6
  ))

  df <- safe_labelled(df, "sex", c(
    "Male"   = 1,
    "Female" = 2
  ))

  df <- safe_labelled(df, "reason", c(
    "Traffic probable cause"  = 1,
    "Criminal probable cause" = 2,
    "Other"                   = 3
  ))

  df <- safe_labelled(df, "outcome", c(
    "Traffic warning"          = 1,
    "Traffic official"         = 2,
    "Criminal cite & release"  = 3,
    "Lodged in jail"           = 4,
    "None"                     = 5
  ))

  df <- safe_labelled(df, "search", c(
    "None"               = 1,
    "Incident to arrest" = 2,
    "Inventory"          = 3,
    "Consent"            = 4,
    "Probable cause"     = 5
  ))

  # Step 3: Apply variable labels
  df <- safe_var_labels(df, list(
    year        = "Year of traffic stop",
    fid         = "Feature ID (unique stop identifier)",
    date        = "Date of traffic stop",
    month       = "Month of traffic stop (1-12)",
    time        = "Time of traffic stop (HH:MM, 24-hour)",
    time_of_day = "Time of day (1=Morning, 2=Afternoon, 3=Evening, 4=Night)",
    race        = "Driver race/ethnicity",
    sex         = "Driver sex (1=Male, 2=Female)",
    reason      = "Reason for stop (1=Traffic, 2=Criminal, 3=Other)",
    outcome     = "Stop outcome (1=Warning, 2=Official, 3=Cite, 4=Arrest, 5=None)",
    search      = "Search conducted (1=None, 2=Arrest, 3=Inventory, 4=Consent, 5=Probable cause)"
  ))

  # Step 4: Set SPSS formats
  format_map <- list(
    year        = "F4.0",
    month       = "F2.0",
    time_of_day = "F1.0",
    race        = "F1.0",
    sex         = "F1.0",
    reason      = "F1.0",
    outcome     = "F1.0",
    search      = "F1.0"
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
