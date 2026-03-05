# =============================================================================
# prep_data.R - Prepare psych350data datasets for analysis
# =============================================================================
# These functions convert character categorical variables to numeric codes
# matching the SPSS value labels in psych350data. Use before running any
# analyses to ensure results match SPSS output.
#
# Usage:
#   data(superman)
#   superman <- prep_data(superman, "superman")              # numeric only
#   superman <- prep_data(superman, "superman", keep_labels = TRUE)  # + labels
#
# Or call dataset-specific functions directly:
#   superman <- prep_superman(superman)
#   superman <- prep_superman(superman, keep_labels = TRUE)
# =============================================================================


# -----------------------------------------------------------------------------
# Internal helper: save character columns as _label before conversion
# -----------------------------------------------------------------------------

.save_labels <- function(data, vars, keep_labels) {
  if (keep_labels) {
    for (v in vars) {
      if (v %in% names(data)) {
        data[[paste0(v, "_label")]] <- data[[v]]
      }
    }
  }
  data
}


# -----------------------------------------------------------------------------
# Generic dispatcher
# -----------------------------------------------------------------------------

#' Prepare a psych350data dataset for analysis
#'
#' Converts character categorical variables to numeric codes matching
#' the SPSS value labels in psych350data. Optionally retains the original
#' character columns as `_label` suffixed columns for use in plotting.
#'
#' @param data A dataset from psych350data.
#' @param dataset_name Character. Name of the dataset, e.g. `"superman"`,
#'   `"hot_ones"`, `"mock_jury"`.
#' @param keep_labels Logical. If `TRUE`, retains original character columns
#'   as `_label` suffixed columns for plotting. Default `FALSE`.
#' @return A tibble with categorical variables as numeric codes, and
#'   optionally `_label` columns for plotting.
#' @export
prep_data <- function(data, dataset_name, keep_labels = FALSE) {
  switch(dataset_name,
         "superman"              = prep_superman(data,              keep_labels),
         "superman_smes"         = prep_superman_smes(data,         keep_labels),
         "superman_movies"       = prep_superman_movies(data,       keep_labels),
         "hot_ones"              = prep_hot_ones(data,              keep_labels),
         "hot_ones_sauces"       = prep_hot_ones_sauces(data,       keep_labels),
         "hot_ones_episodes"     = prep_hot_ones_episodes(data,     keep_labels),
         "mcu"                   = prep_mcu(data,                   keep_labels),
         "mock_jury"             = prep_mock_jury(data,             keep_labels),
         "tip_jokes"             = prep_tip_jokes(data,             keep_labels),
         "candy"                 = prep_candy(data,                 keep_labels),
         "candy_simple"          = prep_candy_simple(data,          keep_labels),
         "football"              = prep_football(data,              keep_labels),
         "huskers"               = prep_huskers(data,               keep_labels),
         "interpersonal_data"    = prep_interpersonal(data,         keep_labels),
         "self_descriptive_data" = prep_self_descriptive(data,      keep_labels),
         stop("No prep function for dataset: ", dataset_name, call. = FALSE)
  )
}


# -----------------------------------------------------------------------------
# Superman datasets
# -----------------------------------------------------------------------------

#' @rdname prep_data
#' @export
prep_superman <- function(data, keep_labels = FALSE) {
  cat_vars <- c("type", "clark_grp", "height_gap",
                "age_grp", "tomatometer", "popular")
  data <- .save_labels(data, cat_vars, keep_labels)
  data |>
    dplyr::mutate(
      type = dplyr::case_match(.data[["type"]],
                               "Film"      ~ 1,
                               "TV Series" ~ 2,
                               "TV Show"   ~ 2,
                               "Serial"    ~ 3,
                               .default = NA_real_),
      clark_grp = dplyr::case_match(.data[["clark_grp"]],
                                    "Under 6ft"     ~ 1,
                                    "6ft or taller" ~ 2,
                                    .default = NA_real_),
      height_gap = dplyr::case_match(.data[["height_gap"]],
                                     "Minimal" ~ 1,
                                     "Average" ~ 2,
                                     "Big"     ~ 3,
                                     .default = NA_real_),
      age_grp = dplyr::case_match(.data[["age_grp"]],
                                  "Minimal" ~ 1,
                                  "Average" ~ 2,
                                  "Big"     ~ 3,
                                  .default = NA_real_),
      tomatometer = dplyr::case_match(.data[["tomatometer"]],
                                      "Rotten" ~ 1,
                                      "Fresh"  ~ 2,
                                      .default = NA_real_),
      popular = dplyr::case_match(.data[["popular"]],
                                  "Low"  ~ 1,
                                  "Mid"  ~ 2,
                                  "High" ~ 3,
                                  .default = NA_real_)
    )
}


#' @rdname prep_data
#' @export
prep_superman_smes <- function(data, keep_labels = FALSE) {
  cat_vars <- c("height_gap")
  data <- .save_labels(data, cat_vars, keep_labels)
  data |>
    dplyr::mutate(
      height_gap = dplyr::case_match(.data[["height_gap"]],
                                     "Minimal" ~ 1,
                                     "Average" ~ 2,
                                     "Big"     ~ 3,
                                     .default = NA_real_)
    )
}


#' @rdname prep_data
#' @export
prep_superman_movies <- function(data, keep_labels = FALSE) {
  cat_vars <- c("mpaa", "budget_cat", "box_office_cat")
  data <- .save_labels(data, cat_vars, keep_labels)
  data |>
    dplyr::mutate(
      mpaa = dplyr::case_match(.data[["mpaa"]],
                               "G"     ~ 1,
                               "PG"    ~ 2,
                               "PG-13" ~ 3,
                               "R"     ~ 4,
                               .default = NA_real_),
      budget_cat = dplyr::case_match(.data[["budget_cat"]],
                                     "Low"    ~ 1,
                                     "Medium" ~ 2,
                                     "High"   ~ 3,
                                     .default = NA_real_),
      box_office_cat = dplyr::case_match(.data[["box_office_cat"]],
                                         "Low"    ~ 1,
                                         "Medium" ~ 2,
                                         "High"   ~ 3,
                                         .default = NA_real_)
    )
}


# -----------------------------------------------------------------------------
# Hot Ones datasets
# -----------------------------------------------------------------------------

#' @rdname prep_data
#' @export
prep_hot_ones <- function(data, keep_labels = FALSE) {
  cat_vars <- c("gender", "result", "occupation")
  data <- .save_labels(data, cat_vars, keep_labels)
  data |>
    dplyr::mutate(
      gender = dplyr::case_match(trimws(.data[["gender"]]),
                                 "Male"   ~ 1,
                                 "Female" ~ 2,
                                 .default = NA_real_),
      result = dplyr::case_match(trimws(.data[["result"]]),
                                 "Succeeded"  ~ 1,
                                 "Failed"     ~ 2,
                                 "Incomplete" ~ 3,
                                 .default = NA_real_),
      occupation = dplyr::case_match(trimws(.data[["occupation"]]),
                                     "Rapper"         ~  1,
                                     "Athlete"        ~  2,
                                     "Actor"          ~  3,
                                     "Actor-Comedian" ~  4,
                                     "Comedian"       ~  5,
                                     "Chef"           ~  6,
                                     "Actor-Musician" ~  7,
                                     "Musician"       ~  8,
                                     "DJ"             ~  9,
                                     "YouTuber"       ~ 10,
                                     "Model"          ~ 11,
                                     "Wrestler"       ~ 12,
                                     "Magician"       ~ 13,
                                     "Other"          ~ 14,
                                     .default = NA_real_)
    )
}


#' @rdname prep_data
#' @export
prep_hot_ones_sauces <- function(data, keep_labels = FALSE) {
  # No character categoricals — return as-is
  data
}


#' @rdname prep_data
#' @export
prep_hot_ones_episodes <- function(data, keep_labels = FALSE) {
  # No character categoricals — return as-is
  data
}


# -----------------------------------------------------------------------------
# MCU
# -----------------------------------------------------------------------------

#' @rdname prep_data
#' @export
prep_mcu <- function(data, keep_labels = FALSE) {
  cat_vars <- c("phase", "favor")
  data <- .save_labels(data, cat_vars, keep_labels)
  data |>
    dplyr::mutate(
      phase = dplyr::case_match(.data[["phase"]],
                                "Phase 1" ~ 1,
                                "Phase 2" ~ 2,
                                "Phase 3" ~ 3,
                                .default = NA_real_),
      favor = dplyr::case_match(.data[["favor"]],
                                "Critics"  ~ 1,
                                "Audience" ~ 2,
                                .default = NA_real_)
    )
}


# -----------------------------------------------------------------------------
# Mock Jury
# -----------------------------------------------------------------------------

#' @rdname prep_data
#' @export
prep_mock_jury <- function(data, keep_labels = FALSE) {
  cat_vars <- c("attr", "crime")
  data <- .save_labels(data, cat_vars, keep_labels)
  data |>
    dplyr::mutate(
      attr = dplyr::case_match(.data[["attr"]],
                               "Beautiful"    ~ 1,
                               "Average"      ~ 2,
                               "Unattractive" ~ 3,
                               .default = NA_real_),
      crime = dplyr::case_match(.data[["crime"]],
                                "Burglary" ~ 1,
                                "Swindle"  ~ 2,
                                .default = NA_real_)
    )
}


# -----------------------------------------------------------------------------
# Tip Jokes
# -----------------------------------------------------------------------------

#' @rdname prep_data
#' @export
prep_tip_jokes <- function(data, keep_labels = FALSE) {
  cat_vars <- c("card", "tip", "ad", "joke", "none")
  data <- .save_labels(data, cat_vars, keep_labels)
  data |>
    dplyr::mutate(
      card = dplyr::case_match(.data[["card"]],
                               "Advertisement" ~ 1,
                               "Joke"          ~ 2,
                               "None"          ~ 3,
                               .default = NA_real_),
      dplyr::across(
        dplyr::any_of(c("tip", "ad", "joke", "none")),
        \(x) dplyr::case_match(x,
                               "Yes" ~ 1,
                               "No"  ~ 0,
                               .default = NA_real_)
      )
    )
}


# -----------------------------------------------------------------------------
# Candy
# -----------------------------------------------------------------------------

#' @rdname prep_data
#' @export
prep_candy <- function(data, keep_labels = FALSE) {
  binary_vars <- c("chocolate", "fruity", "caramel", "peanutyalmondy",
                   "nougat", "crispedricewafer", "hard", "bar", "pluribus")
  data <- .save_labels(data, binary_vars, keep_labels)
  data |>
    dplyr::mutate(
      dplyr::across(
        dplyr::any_of(binary_vars),
        \(x) dplyr::case_match(x,
                               "Yes" ~ 1,
                               "No"  ~ 0,
                               .default = NA_real_)
      )
    )
}


#' @rdname prep_data
#' @export
prep_candy_simple <- function(data, keep_labels = FALSE) {
  data <- .save_labels(data, "chocolate", keep_labels)
  data |>
    dplyr::mutate(
      chocolate = dplyr::case_match(.data[["chocolate"]],
                                    "Yes" ~ 1,
                                    "No"  ~ 0,
                                    .default = NA_real_)
    )
}


# -----------------------------------------------------------------------------
# Football
# -----------------------------------------------------------------------------

#' @rdname prep_data
#' @export
prep_football <- function(data, keep_labels = FALSE) {
  cat_vars <- c("group")
  data <- .save_labels(data, cat_vars, keep_labels)
  data |>
    dplyr::mutate(
      group = dplyr::case_match(.data[["group"]],
                                "Control"                  ~ 1,
                                "Football no concussion"   ~ 2,
                                "Football with concussion" ~ 3,
                                .default = NA_real_)
    )
}


# -----------------------------------------------------------------------------
# Huskers
# -----------------------------------------------------------------------------

#' @rdname prep_data
#' @export
prep_huskers <- function(data, keep_labels = FALSE) {
  cat_vars <- c("site", "result", "conference")
  data <- .save_labels(data, cat_vars, keep_labels)
  data |>
    dplyr::mutate(
      site = dplyr::case_match(.data[["site"]],
                               "Home"           ~ 1,
                               "Away"           ~ 2,
                               "Neutral (home)" ~ 3,
                               "Neutral (away)" ~ 4,
                               .default = NA_real_),
      result = dplyr::case_match(.data[["result"]],
                                 "Win"  ~ 1,
                                 "Loss" ~ 2,
                                 "Tie"  ~ 3,
                                 .default = NA_real_),
      # conference may be logical or character depending on source
      conference = dplyr::case_when(
        is.logical(.data[["conference"]]) ~ as.numeric(.data[["conference"]]),
        .data[["conference"]] == "Conference"     ~ 1,
        .data[["conference"]] == "Non-conference" ~ 0,
        .default = NA_real_)
    )
}


# -----------------------------------------------------------------------------
# Survey datasets - already numeric, pass-through with consistent interface
# -----------------------------------------------------------------------------

#' @rdname prep_data
#' @export
prep_interpersonal <- function(data, keep_labels = FALSE) {
  # All categoricals already stored as numeric — no conversion needed
  data
}


#' @rdname prep_data
#' @export
prep_self_descriptive <- function(data, keep_labels = FALSE) {
  # All categoricals already stored as numeric — no conversion needed
  data
}
