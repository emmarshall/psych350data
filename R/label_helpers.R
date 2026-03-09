# ============================================================================
# Unique SPSS labeling functions exist for each dataset
# Each takes a clean R data frame (with NAs) and returns a labelled version
# matching the original SPSS data prep scripts, ready for haven::write_sav()
#
# When use_sentinel = TRUE:
#   1. All NA values in numeric columns are replaced with -99
#   2. The na_values attribute is set so SPSS treats -99 as user-missing
# ============================================================================



# ---- Helper function --------------------------------------------------------

#' Apply value labels safely (only if column exists)
#' @noRd
safe_labelled <- function(df, var, labels) {
  if (var %in% names(df)) {
    df[[var]] <- labelled::labelled(df[[var]], labels = labels)
  }
  df
}

#' Apply variable labels safely (only for existing columns)
#' @noRd
safe_var_labels <- function(df, all_labels) {
  existing_labels <- all_labels[names(all_labels) %in% names(df)]
  labelled::var_label(df) <- existing_labels
  df
}

#' Set -99 as missing for all numeric columns
#' @noRd
safe_set_na_values <- function(df) {
  target_vars <- names(df)[sapply(df, \(x) is.numeric(x) || inherits(x, "haven_labelled"))]
  for (var in target_vars) {
    na_arg <- list(-99)
    names(na_arg) <- var
    df <- do.call(labelled::set_na_values, c(list(df), na_arg))
    # Convert to haven_labelled_spss so haven::write_sav() preserves na_values bc otherwise it freaks out and is annoying
    x <- df[[var]]
    df[[var]] <- haven::labelled_spss(
      x          = as.double(labelled::remove_labels(x)),
      labels     = labelled::val_labels(x),
      na_values  = -99,
      label      = attr(x, "label")
    )
  }
  df
}

#' Apply SPSS metadata based on dataset name
#' @noRd
apply_spss_metadata <- function(df, dataset_name, use_sentinel = TRUE) {
  switch(dataset_name,
         "superman"                   = label_superman(df, use_sentinel),
         "superman_smes"              = label_superman_smes(df, use_sentinel),
         "superman_movies"            = label_superman_movies(df, use_sentinel),
         "superman_combined"          = label_superman_combined(df, use_sentinel),
         "hotones"                   = label_hotones(df, use_sentinel),
         "hotones_sauces"            = label_hotones_sauces(df, use_sentinel),
         "hotones_episodes"          = label_hotones_episodes(df, use_sentinel),
         "tip_jokes"                  = label_tip_jokes(df, use_sentinel),
         "mcu"                        = label_mcu(df, use_sentinel),
         "mock_jury"                  = label_mock_jury(df, use_sentinel),
         "candy"                      = label_candy(df, use_sentinel),
         "candy_simple"               = label_candy_simple(df, use_sentinel),
         "football"                   = label_football(df, use_sentinel),
         "huskers"                    = label_huskers(df, use_sentinel),
         "interpersonal_data"         = label_interpersonal(df, use_sentinel),
         "self_descriptive_data"      = label_self_descriptive(df, use_sentinel),
         "parent_child_data"          = label_parent_child(df, use_sentinel),
         "hindsight_mg_data"          = label_hindsight_mg(df, use_sentinel),
         "hindsight_wg_data"          = label_hindsight_wg(df, use_sentinel),
         "cheese_data"                = label_cheese(df, use_sentinel),
         "lpd_data"                   = label_lpd(df, use_sentinel),
         stop("No labelling function for dataset: ", dataset_name, call. = FALSE)
  )
}









