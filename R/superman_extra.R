#' Join Superman Movies with Actor Data
#'
#' Combines the superman_movies dataset with physical characteristics and
#' ratings data from the superman dataset, matched by actor name.
#'
#' @param movies A data frame of Superman movies (default: superman_movies)
#' @param actors A data frame of Superman actor data (default: superman)
#' @param suffix Suffixes for disambiguating duplicate column names.
#'   Default c("_movie", "_actor").
#'
#' @return A tibble with movie data joined to actor data.
#' @export
#'
#' @examples
#' \dontrun{
#' combined <- join_superman_data()
#' combined |> export_sav(path = "superman_combined.sav")
#' }
join_superman_data <- function(movies = NULL, actors = NULL,
                               suffix = c("_movie", "_actor")) {

  if (is.null(movies)) {
    e <- new.env()
    data("superman_movies", package = "psych350data", envir = e)
    movies <- e$superman_movies
  }
  if (is.null(actors)) {
    e <- new.env()
    data("superman", package = "psych350data", envir = e)
    actors <- e$superman
  }

  # Select relevant columns from actor data to avoid too much duplication
  actors_slim <- actors |>
    dplyr::select(
      clark_actor,
      clark_height, clark_height_in, clark_age, clark_grp,
      lois_actor, lois_height, lois_height_in, lois_age,
      height_diff, height_gap, age_diff, age_grp,
      rt_critics_score, rt_audience_score, rt_avg, tomatometer,
      ldb_likes, ldb_scores, popular
    )

  # Join on clark_actor
  combined <- movies |>
    dplyr::left_join(actors_slim, by = dplyr::join_by(clark_actor), suffix = suffix)

  combined
}


#' Label Combined Superman Data for SPSS Export
#'
#' Applies SPSS labels to the combined superman movies + actor dataset.
#' This is called automatically when exporting via export_sav().
#'
#' @param df The combined data frame from join_superman_data()
#' @param use_sentinel If TRUE, replace NA with -99 and set as SPSS missing.
#'
#' @return A labelled data frame ready for haven::write_sav()
#' @noRd
label_superman_combined <- function(df, use_sentinel = TRUE) {
  # Apply movie labels first
  df <- label_superman_movies(df, use_sentinel = FALSE)

  # Then apply actor-specific labels for any columns from superman dataset
  actor_vars <- c("clark_height", "clark_height_in", "clark_age", "clark_grp",
                  "lois_height", "lois_height_in", "lois_age",
                  "height_diff", "height_gap", "age_diff", "age_grp",
                  "rt_critics_score", "rt_audience_score", "rt_avg", "tomatometer",
                  "ldb_likes", "ldb_scores", "popular")

  # Convert categorical actor variables to numeric
  if ("clark_grp" %in% names(df)) {
    df <- df |>
      dplyr::mutate(
        clark_grp = dplyr::case_match(
          clark_grp,
          "Under 6ft" ~ 1,
          "6ft or taller" ~ 2,
          .default = NA_real_
        ),
        height_gap = dplyr::case_match(
          height_gap,
          "Minimal" ~ 1,
          "Average" ~ 2,
          "Big" ~ 3,
          .default = NA_real_
        ),
        age_grp = dplyr::case_match(
          age_grp,
          "Minimal" ~ 1,
          "Average" ~ 2,
          "Big" ~ 3,
          .default = NA_real_
        ),
        tomatometer = dplyr::case_match(
          tomatometer,
          "Rotten" ~ 1,
          "Fresh" ~ 2,
          .default = NA_real_
        ),
        popular = dplyr::case_match(
          popular,
          "Low" ~ 1,
          "Mid" ~ 2,
          "High" ~ 3,
          .default = NA_real_
        )
      )

    # Apply value labels
    df$clark_grp <- labelled::labelled(df$clark_grp,
                                       labels = c("Under 6ft (<72 inches)" = 1, "6ft or taller (>=72 inches)" = 2))
    df$height_gap <- labelled::labelled(df$height_gap,
                                        labels = c("Minimal (<6 inches)" = 1, "Average (6-8 inches)" = 2, "Big (>8 inches)" = 3))
    df$age_grp <- labelled::labelled(df$age_grp,
                                     labels = c("Minimal (<2 years)" = 1, "Average (2-5 years)" = 2, "Big (>5 years)" = 3))
    df$tomatometer <- labelled::labelled(df$tomatometer,
                                         labels = c("Rotten" = 1, "Fresh" = 2))
    df$popular <- labelled::labelled(df$popular,
                                     labels = c("Low (<1,000 likes)" = 1, "Mid (1,000-100,000 likes)" = 2, "High (>100,000 likes)" = 3))
  }

  # Add actor variable labels
  actor_labels <- list(
    clark_height = "Height of Clark Kent/Superman actor (meters)",
    clark_height_in = "Height of Clark Kent/Superman actor (inches)",
    clark_age = "Age of Clark Kent/Superman actor at debut (years)",
    clark_grp = "Clark height category",
    lois_actor = "Actor playing Lois Lane",
    lois_height = "Height of Lois Lane actor (meters)",
    lois_height_in = "Height of Lois Lane actor (inches)",
    lois_age = "Age of Lois Lane actor at debut (years)",
    height_diff = "Height difference Clark minus Lois (inches)",
    height_gap = "Height gap category",
    age_diff = "Age difference between actors (years)",
    age_grp = "Age difference category",
    rt_critics_score = "Rotten Tomatoes critics score (0-100)",
    rt_audience_score = "Rotten Tomatoes audience score (0-100)",
    rt_avg = "Average of critics and audience RT scores",
    tomatometer = "Rotten Tomatoes classification",
    ldb_likes = "Letterboxd likes",
    ldb_scores = "Letterboxd average rating (1-5 stars)",
    popular = "Popularity category based on Letterboxd likes"
  )

  # Apply only labels for columns that exist
  existing_labels <- actor_labels[names(actor_labels) %in% names(df)]
  current_labels <- labelled::var_label(df)
  labelled::var_label(df) <- c(current_labels, existing_labels)

  # Replace NA with -99 and set missing values
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric),
                      \(x) dplyr::if_else(is.na(x), -99, x)),
        dplyr::across(dplyr::where(is.character),
                      \(x) dplyr::if_else(is.na(x) | x == "", "-99", x))
      )

    numeric_vars <- names(df)[sapply(df, is.numeric)]
    for (var in numeric_vars) {
      df <- labelled::set_na_values(df, !!rlang::sym(var) := -99)
    }
  }

  df
}
