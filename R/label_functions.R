# ============================================================================
# SPSS labelling functions for each dataset
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
         "superman"            = label_superman(df, use_sentinel),
         "superman_smes"       = label_superman_smes(df, use_sentinel),
         "superman_movies"     = label_superman_movies(df, use_sentinel),
         "superman_combined"   = label_superman_combined(df, use_sentinel),
         "hot_ones"            = label_hot_ones(df, use_sentinel),
         "hot_ones_sauces"     = label_hot_ones_sauces(df, use_sentinel),
         "hot_ones_episodes"   = label_hot_ones_episodes(df, use_sentinel),
         "tip_jokes"           = label_tip_jokes(df, use_sentinel),
         "mcu"                 = label_mcu(df, use_sentinel),
         "mock_jury"           = label_mock_jury(df, use_sentinel),
         "candy"               = label_candy(df, use_sentinel),
         "candy_simple"        = label_candy_simple(df, use_sentinel),
         "football"            = label_football(df, use_sentinel),
         "huskers"             = label_huskers(df, use_sentinel),
         "interpersonal_data"  = label_interpersonal(df, use_sentinel),
         "self_descriptive_data" = label_self_descriptive(df, use_sentinel),
         stop("No labelling function for dataset: ", dataset_name, call. = FALSE)
  )
}

# ---- Superman ---------------------------------------------------------------

#' @noRd
label_superman <- function(df, use_sentinel = TRUE) {


  # Step 1: Convert ALL character categorical variables to numeric codes


  # type: Film = 1, TV Show/TV Series = 2, Serial = 3

  if ("type" %in% names(df) && is.character(df$type)) {
    df$type <- dplyr::case_match(
      df$type,
      "Film" ~ 1,
      "TV Show" ~ 2,
      "TV Series" ~ 2,
      "Serial" ~ 3,
      .default = NA_real_
    )
  }


  # media: map to numeric codes

  if ("media" %in% names(df) && is.character(df$media)) {
    df$media <- dplyr::case_when(
      df$media == "Superman" & df$year == 2025 ~ 1,
      df$media == "Superman" & df$year == 1948 ~ 7,
      df$media == "Superman: The Movie" ~ 2,
      df$media == "Smallville" ~ 3,
      df$media == "Superman Returns" ~ 4,
      df$media == "Superman & the Mole Men" ~ 5,
      df$media == "Man of Steel" ~ 6,
      df$media == "Superman & Lois" ~ 8,
      df$media == "Lois & Clark: The New Adventures of Superman" ~ 9,
      df$media == "The Adventures of Superboy" ~ 10,
      .default = NA_real_
    )
  }


  # clark_grp: Under 6ft = 1, 6ft or taller = 2

  if ("clark_grp" %in% names(df) && is.character(df$clark_grp)) {
    df$clark_grp <- dplyr::case_match(
      df$clark_grp,
      "Under 6ft" ~ 1,
      "6ft or taller" ~ 2,
      .default = NA_real_
    )
  }


  # height_gap: Minimal = 1, Average = 2, Big = 3
  if ("height_gap" %in% names(df) && is.character(df$height_gap)) {
    df$height_gap <- dplyr::case_match(
      df$height_gap,
      "Minimal" ~ 1,
      "Average" ~ 2,
      "Big" ~ 3,
      .default = NA_real_
    )
  }


  # age_grp: Minimal = 1, Average = 2, Big = 3
  if ("age_grp" %in% names(df) && is.character(df$age_grp)) {
    df$age_grp <- dplyr::case_match(
      df$age_grp,
      "Minimal" ~ 1,
      "Average" ~ 2,
      "Big" ~ 3,
      .default = NA_real_
    )
  }


  # tomatometer: Rotten = 1, Fresh = 2
  if ("tomatometer" %in% names(df) && is.character(df$tomatometer)) {
    df$tomatometer <- dplyr::case_match(
      df$tomatometer,
      "Rotten" ~ 1,
      "Fresh" ~ 2,
      .default = NA_real_
    )
  }

  # popular: Low = 1, Mid = 2, High = 3
  if ("popular" %in% names(df) && is.character(df$popular)) {
    df$popular <- dplyr::case_match(
      df$popular,
      "Low" ~ 1,
      "Mid" ~ 2,
      "High" ~ 3,
      .default = NA_real_
    )
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 3: Apply value labels (only for columns that exist)
  df <- safe_labelled(df, "media", c(
    "Superman (2025)" = 1,
    "Superman: The Movie" = 2,
    "Smallville" = 3,
    "Superman Returns" = 4,
    "Superman & the Mole Men" = 5,
    "Man of Steel" = 6,
    "Superman (1948 serial)" = 7,
    "Superman & Lois" = 8,
    "Lois & Clark: The New Adventures of Superman" = 9,
    "The Adventures of Superboy" = 10
  ))

  df <- safe_labelled(df, "type", c("Film" = 1, "TV Show" = 2, "Serial" = 3))

  df <- safe_labelled(df, "clark_grp", c(
    "Under 6ft (<72 inches)" = 1,
    "6ft or taller (>=72 inches)" = 2
  ))

  df <- safe_labelled(df, "height_gap", c(
    "Minimal (<6 inches)" = 1,
    "Average (6-8 inches)" = 2,
    "Big (>8 inches)" = 3
  ))

  df <- safe_labelled(df, "age_grp", c(
    "Minimal (<2 years)" = 1,
    "Average (2-5 years)" = 2,
    "Big (>5 years)" = 3
  ))

  df <- safe_labelled(df, "tomatometer", c("Rotten" = 1, "Fresh" = 2))

  df <- safe_labelled(df, "popular", c(
    "Low (<1,000 likes)" = 1,
    "Mid (1,000-100,000 likes)" = 2,
    "High (>100,000 likes)" = 3
  ))

  # Step 4: Apply variable labels (only for columns that exist)
  df <- safe_var_labels(df, list(
    num = "Unique number for each actor in dataset",
    media = "Title of media where actor made their first appearance as Clark Kent/Superman",
    year = "Year of release",
    type = "Type of media",
    clark_actor = "Actor playing Clark Kent/Superman",
    clark_height = "Height of Clark Kent/Superman actor in meters",
    clark_age = "Age of Clark Kent/Superman actor at debut in years",
    lois_actor = "Actor playing Lois Lane",
    lois_height = "Height of Lois Lane actor in meters",
    lois_age = "Age of Lois Lane actor at debut in years",
    age_diff = "Age difference between Lois and Clark in years",
    age_grp = "Relative age difference between actors (minimal/average/big)",
    clark_height_in = "Height of Clark Kent/Superman actor in inches",
    lois_height_in = "Height of Lois Lane actor in inches",
    clark_grp = "Whether Clark Kent/Superman actor is taller than 6ft",
    height_diff = "Height difference between Clark Kent/Superman and Lois Lane actors in inches",
    height_gap = "Relative size of height gap between actors (minimal/average/big)",
    rt_critics_score = "Rotten Tomatoes critics score (0-100 scale)",
    rt_critic_count = "Number of Rotten Tomatoes critic reviews",
    rt_audience_score = "Rotten Tomatoes audience score (0-100 scale)",
    rt_audience_count = "Number of Rotten Tomatoes audience reviews",
    ldb_likes = "Total number of users that liked the film on Letterboxd",
    ldb_scores = "Letterboxd users average rating (1-5 stars)",
    tomatometer = "Whether the media was liked by more than 60% of critics on Rotten Tomatoes",
    rt_avg = "Average of critics and audience scores on Rotten Tomatoes",
    rt_diff = "Weighted difference between critics and audience scores on Rotten Tomatoes",
    popular = "Popularity based on number of user likes on Letterboxd (low/mid/high)"
  ))

  # Step 5: Set -99 as missing values (only for columns that exist)
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Superman SMES ----------------------------------------------------------

#' @noRd
label_superman_smes <- function(df, use_sentinel = TRUE) {
  # Step 1: Convert character to numeric if needed
  if ("height_gap" %in% names(df) && is.character(df$height_gap)) {
    df$height_gap <- dplyr::case_match(
      df$height_gap,
      "Minimal" ~ 1,
      "Average" ~ 2,
      "Big"     ~ 3,
      .default  = NA_real_
    )
  }

  # Step 2: Apply value labels
  df <- safe_labelled(df, "height_gap", c(
    "Minimal (<6 inches)"  = 1,
    "Average (6-8 inches)" = 2,
    "Big (>8 inches)"      = 3
  ))

  # Step 3: Apply variable labels
  df <- safe_var_labels(df, list(
    num                  = "Unique participant number",
    height_gap           = "Height gap category between Superman and Lois Lane actors",
    emotional_impact     = "Emotional Impact subscale (sum of 4 items, range 4-20)",
    aesthetic_appeal     = "Aesthetic Appeal subscale (sum of 3 items, range 3-15)",
    cognitive_engagement = "Cognitive Engagement subscale (mean of 4 items, range 0-7)"
  ))

  # Step 4: Set SPSS formats
  if ("height_gap" %in% names(df)) {
    attr(df$height_gap, "format.spss") <- "F1.0"
  }

  # Step 5: Replace NA with -99 AFTER labeling so haven_labelled columns are caught
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(
        dplyr::where(\(x) is.numeric(x) || inherits(x, "haven_labelled")),
        \(x) {
          x[is.na(x)] <- -99
          x
        }
      ))
  }

  # Step 6: Set -99 as SPSS missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Superman Movies --------------------------------------------------------

#' @noRd
label_superman_movies <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("mpaa" %in% names(df) && is.character(df$mpaa)) {
    df$mpaa <- dplyr::case_match(
      df$mpaa,
      "G" ~ 1,
      "PG" ~ 2,
      "PG-13" ~ 3,
      "R" ~ 4,
      .default = NA_real_
    )
  }

  if ("budget_cat" %in% names(df) && is.character(df$budget_cat)) {
    df$budget_cat <- dplyr::case_match(
      df$budget_cat,
      "Low" ~ 1,
      "Medium" ~ 2,
      "High" ~ 3,
      .default = NA_real_
    )
  }

  if ("box_office_cat" %in% names(df) && is.character(df$box_office_cat)) {
    df$box_office_cat <- dplyr::case_match(
      df$box_office_cat,
      "Low" ~ 1,
      "Medium" ~ 2,
      "High" ~ 3,
      .default = NA_real_
    )
  }

  # Step 2: Replace NA with -99 in numeric columns
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric),
                      \(x) dplyr::if_else(is.na(x), -99, x)),
        dplyr::across(dplyr::where(is.character),
                      \(x) dplyr::if_else(is.na(x) | x == "", "-99", x))
      )
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "mpaa", c("G" = 1, "PG" = 2, "PG-13" = 3, "R" = 4))
  df <- safe_labelled(df, "budget_cat", c("Low (<$50M)" = 1, "Medium ($50-150M)" = 2, "High (>$150M)" = 3))
  df <- safe_labelled(df, "box_office_cat", c("Low (<$100M)" = 1, "Medium ($100-500M)" = 2, "High (>$500M)" = 3))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    imdb_id = "IMDb title ID",
    title = "Movie title",
    year = "Release year",
    description = "Movie description/tagline",
    domestic_gross = "Domestic box office gross (millions USD)",
    domestic_pct = "Domestic percentage of worldwide gross",
    international_gross = "International box office gross (millions USD)",
    international_pct = "International percentage of worldwide gross",
    worldwide_gross = "Worldwide box office gross (millions USD)",
    distributor = "Domestic distributor",
    opening_weekend = "Domestic opening weekend gross (millions USD)",
    budget = "Production budget (millions USD)",
    release_date = "Earliest release date",
    mpaa = "MPAA rating",
    runtime_min = "Runtime in minutes",
    genres = "Genres (comma-separated)",
    poster_url = "Movie poster URL (low resolution)",
    poster_url_hires = "Movie poster URL (high resolution)",
    clark_actor = "Actor playing Clark Kent/Superman",
    roi = "Return on investment ((worldwide - budget) / budget)",
    budget_cat = "Budget category",
    box_office_cat = "Box office success category"
  ))

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

#' @noRd
label_superman_combined <- function(df, use_sentinel = TRUE) {
  # Apply movie labels first
  df <- label_superman_movies(df, use_sentinel = FALSE)

  # Convert categorical actor variables to numeric
  if ("clark_grp" %in% names(df) && is.character(df$clark_grp)) {
    df <- df |>
      dplyr::mutate(
        clark_grp = clark_grp |> dplyr::recode_values(
          "Under 6ft" ~ 1,
          "6ft or taller" ~ 2,
          default = NA_real_
        ),
        height_gap = height_gap |> dplyr::recode_values(
          "Minimal" ~ 1,
          "Average" ~ 2,
          "Big" ~ 3,
          default = NA_real_
        ),
        age_grp = age_grp |> dplyr::recode_values(
          "Minimal" ~ 1,
          "Average" ~ 2,
          "Big" ~ 3,
          default = NA_real_
        ),
        tomatometer = tomatometer |> dplyr::recode_values(
          "Rotten" ~ 1,
          "Fresh" ~ 2,
          default = NA_real_
        ),
        popular = popular |> dplyr::recode_values(
          "Low" ~ 1,
          "Mid" ~ 2,
          "High" ~ 3,
          default = NA_real_
        )
      )

    # Apply value labels
    df$clark_grp <- labelled::labelled(
      df$clark_grp,
      labels = c("Under 6ft (<72 inches)" = 1, "6ft or taller (>=72 inches)" = 2)
    )
    df$height_gap <- labelled::labelled(
      df$height_gap,
      labels = c("Minimal (<6 inches)" = 1, "Average (6-8 inches)" = 2, "Big (>8 inches)" = 3)
    )
    df$age_grp <- labelled::labelled(
      df$age_grp,
      labels = c("Minimal (<2 years)" = 1, "Average (2-5 years)" = 2, "Big (>5 years)" = 3)
    )
    df$tomatometer <- labelled::labelled(
      df$tomatometer,
      labels = c("Rotten" = 1, "Fresh" = 2)
    )
    df$popular <- labelled::labelled(
      df$popular,
      labels = c("Low (<1,000 likes)" = 1, "Mid (1,000-100,000 likes)" = 2, "High (>100,000 likes)" = 3)
    )
  }

  # Add 2-level variables for chi-square analysis
  if ("budget_cat" %in% names(df)) {
    df <- df |>
      dplyr::mutate(
        budget2 = dplyr::case_when(
          budget_cat == "High" ~ 1,
          budget_cat %in% c("Low", "Medium") ~ 2,
          TRUE ~ NA_real_
        ),
        boxoffice2 = dplyr::case_when(
          box_office_cat == "High" ~ 1,
          box_office_cat %in% c("Low", "Medium") ~ 2,
          TRUE ~ NA_real_
        )
      )

    df$budget2 <- labelled::labelled(
      df$budget2,
      labels = c("High" = 1, "Low/Medium" = 2)
    )
    df$boxoffice2 <- labelled::labelled(
      df$boxoffice2,
      labels = c("High" = 1, "Low/Medium" = 2)
    )
  }

  # Variable labels
  var_labels <- list(
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
    popular = "Popularity category based on Letterboxd likes",
    budget2 = "Budget Category (2 levels)",
    boxoffice2 = "Box Office Category (2 levels)"
  )

  # Apply only labels for columns that exist
  existing_labels <- var_labels[names(var_labels) %in% names(df)]
  current_labels <- labelled::var_label(df)
  labelled::var_label(df) <- c(current_labels, existing_labels)

  # Replace NA with -99 and set missing values
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(
          dplyr::where(is.numeric),
          \(x) dplyr::if_else(is.na(x), -99, x)
        ),
        dplyr::across(
          dplyr::where(is.character),
          \(x) dplyr::if_else(is.na(x) | x == "", "-99", x)
        )
      )

    numeric_vars <- names(df)[sapply(df, is.numeric)]
    for (var in numeric_vars) {
      df <- labelled::set_na_values(df, !!rlang::sym(var) := -99)
    }
  }

  df
}


# ---- Hot Ones ---------------------------------------------------------------

# ---- Hot Ones (Guests) ------------------------------------------------------

#' @noRd
label_hot_ones <- function(df, use_sentinel = TRUE) {

  # Step 0: If NOT using sentinel, convert any existing -99 to NA first
  if (!use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ dplyr::if_else(.x == -99, NA_real_, .x))
      )
  }

  # Step 1: Convert character categorical variables to numeric codes

  # gender: Male = 1, Female = 2
  # Trim whitespace first to handle "Male " vs "Male"
  if ("gender" %in% names(df) && is.character(df$gender)) {
    df$gender <- dplyr::case_match(
      trimws(df$gender),
      "Male" ~ 1,
      "Female" ~ 2,
      .default = NA_real_
    )
  }

  # result: Succeeded = 1, Failed = 2, Incomplete = 3
  if ("result" %in% names(df) && is.character(df$result)) {
    df$result <- dplyr::case_match(
      trimws(df$result),
      "Succeeded" ~ 1,
      "Failed" ~ 2,
      "Incomplete" ~ 3,
      .default = NA_real_
    )
  }

  # occupation: Convert string to numeric codes
  if ("occupation" %in% names(df) && is.character(df$occupation)) {
    df$occupation <- dplyr::case_match(
      trimws(df$occupation),
      "Rapper" ~ 1,
      "Athlete" ~ 2,
      "Actor" ~ 3,
      "Actor-Comedian" ~ 4,
      "Comedian" ~ 5,
      "Chef" ~ 6,
      "Actor-Musician" ~ 7,
      "Musician" ~ 8,
      "DJ" ~ 9,
      "YouTuber" ~ 10,
      "Model" ~ 11,
      "Wrestler" ~ 12,
      "Magician" ~ 13,
      "Other" ~ 14,
      .default = NA_real_
    )
  }

  # Step 2: Handle missing values based on use_sentinel
  if (use_sentinel) {
    # Convert NA to -99 for SPSS export
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "gender", c("Male" = 1, "Female" = 2))
  df <- safe_labelled(df, "occupation", c(
    "Rapper" = 1, "Athlete" = 2, "Actor" = 3, "Actor-Comedian" = 4,
    "Comedian" = 5, "Chef" = 6, "Actor-Musician" = 7, "Musician" = 8,
    "DJ" = 9, "YouTuber" = 10, "Model" = 11, "Wrestler" = 12,
    "Magician" = 13, "Other" = 14
  ))
  df <- safe_labelled(df, "result", c("Succeeded" = 1, "Failed" = 2, "Incomplete" = 3))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    subn = "Unique number for each guest/participant",
    name = "Guest Full Name",
    gender = "Guest Gender",
    age = "Guest Age",
    occupation = "Guest's primary occupation",
    result = "Whether the guest finished all the wings or quit (wall of flame)",
    appearances = "Number of appearances on Hot Ones",
    season = "Season of Hot Ones",
    order = "Episode number within Season of Hot Ones",
    wing_total = "Number of wings eaten",
    alt_food = "Alternative food used instead of wings",
    helpers = "Drinks or other items used to help with the heat",
    SHU_1 = "Sauce #1 rating in Scoville Heat Units (SHU)",
    SHU_2 = "Sauce #2 rating in Scoville Heat Units (SHU)",
    SHU_3 = "Sauce #3 rating in Scoville Heat Units (SHU)",
    SHU_4 = "Sauce #4 rating in Scoville Heat Units (SHU)",
    SHU_5 = "Sauce #5 rating in Scoville Heat Units (SHU)",
    SHU_6 = "Sauce #6 rating in Scoville Heat Units (SHU)",
    SHU_7 = "Sauce #7 rating in Scoville Heat Units (SHU)",
    SHU_8 = "Sauce #8 rating in Scoville Heat Units (SHU)",
    SHU_9 = "Sauce #9 rating in Scoville Heat Units (SHU)",
    SHU_10 = "Sauce #10 rating in Scoville Heat Units (SHU)",
    views = "Number of times video has been viewed on Youtube (in millions)",
    likes = "Number of times video has been liked on Youtube",
    comments = "Number of comments on video on Youtube"
  ))

  # Step 5: Set SPSS formats (only for existing columns)
  for (var in names(df)) {
    if (var %in% c("gender", "result")) {
      attr(df[[var]], "format.spss") <- "F1.0"
    } else if (var == "occupation") {
      attr(df[[var]], "format.spss") <- "F2.0"
    } else if (grepl("^SHU_", var)) {
      attr(df[[var]], "format.spss") <- "F10.0"
    } else if (var %in% c("age", "season", "order", "appearances", "subn", "wing_total")) {
      attr(df[[var]], "format.spss") <- "F3.0"
    } else if (var %in% c("views", "likes", "comments")) {
      attr(df[[var]], "format.spss") <- "F12.0"
    }
  }

  # Step 6: Set -99 as SPSS missing values (only if using sentinel)
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Hot Ones Sauces --------------------------------------------------------

#' @noRd
label_hot_ones_sauces <- function(df, use_sentinel = TRUE) {

  # Step 0: If NOT using sentinel, convert any existing -99 to NA first
  if (!use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ dplyr::if_else(.x == -99, NA_real_, .x))
      )
  }

  # Step 1: Handle missing values based on use_sentinel
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 2: Apply variable labels
  df <- safe_var_labels(df, list(
    season = "Season of Hot Ones",
    order = "Sauce position in the lineup (1-10)",
    sauce_name = "Name of the hot sauce",
    SHU = "Scoville Heat Units (SHU) rating"
  ))

  # Step 3: Set SPSS formats
  for (var in names(df)) {
    if (var %in% c("season", "order")) {
      attr(df[[var]], "format.spss") <- "F2.0"
    } else if (var == "SHU") {
      attr(df[[var]], "format.spss") <- "F10.0"
    }
  }

  # Step 4: Set -99 as SPSS missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Hot Ones Episodes ------------------------------------------------------

#' @noRd
label_hot_ones_episodes <- function(df, use_sentinel = TRUE) {

  # Step 0: If NOT using sentinel, convert any existing -99 to NA first
  if (!use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ dplyr::if_else(.x == -99, NA_real_, .x))
      )
  }

  # Step 1: Handle missing values based on use_sentinel
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 2: Apply variable labels
  df <- safe_var_labels(df, list(
    season = "Season of Hot Ones",
    order = "Episode number within season",
    guest = "Name of the guest",
    episode_title = "Full title of the episode",
    publish_date = "Date the episode was published on YouTube",
    views = "Number of YouTube views (in millions)",
    likes = "Number of YouTube likes",
    comments = "Number of YouTube comments",
    short_description = "Short description of the episode",
    img = "URL to episode thumbnail image",
    video_id = "YouTube video ID"
  ))

  # Step 3: Set SPSS formats
  for (var in names(df)) {
    if (var %in% c("season", "order")) {
      attr(df[[var]], "format.spss") <- "F2.0"
    } else if (var %in% c("views", "likes", "comments")) {
      attr(df[[var]], "format.spss") <- "F12.0"
    }
  }

  # Step 4: Set -99 as SPSS missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- MCU --------------------------------------------------------------------

#' @noRd
label_mcu <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("phase" %in% names(df) && is.character(df$phase)) {
    df$phase <- dplyr::case_match(
      df$phase,
      "Phase 1" ~ 1,
      "Phase 2" ~ 2,
      "Phase 3" ~ 3,
      .default = NA_real_
    )
  }

  if ("favor" %in% names(df) && is.character(df$favor)) {
    df$favor <- dplyr::case_match(
      df$favor,
      "Critics" ~ 1,
      "Audience" ~ 2,
      .default = NA_real_
    )
  }

  # Step 2: Ensure numeric columns are numeric
  numeric_cols <- c("length_hrs", "length_min", "opening_weekend_us", "gross_us",
                    "gross_world", "critics", "audience")
  for (col in numeric_cols) {
    if (col %in% names(df)) {
      df[[col]] <- as.numeric(df[[col]])
    }
  }

  # Step 3: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 4: Apply value labels
  df <- safe_labelled(df, "phase", c("Phase 1" = 1, "Phase 2" = 2, "Phase 3" = 3))
  df <- safe_labelled(df, "favor", c("Critics" = 1, "Audience" = 2))

  # Step 5: Apply variable labels
  df <- safe_var_labels(df, list(
    movie = "Title of the movie",
    length_hrs = "Length of the movie: hours portion",
    length_min = "Length of the movie: minutes portion",
    release_date = "Date the movie was released in the US",
    opening_weekend_us = "Box office totals for opening weekend in the US (not adjusted for inflation)",
    gross_us = "All box office totals in US (not adjusted for inflation)",
    gross_world = "All box office totals world wide (not adjusted for inflation)",
    phase = "Designated phase of the Marvel Cinematic Universe",
    critics = "Rotten Tomatoes critics score (0-100 scale)",
    audience = "Rotten Tomatoes audience score (0-100 scale)",
    favor = "Whether critics or audience score is higher on Rotten Tomatoes"
  ))

  # Step 6: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Mock Jury --------------------------------------------------------------

#' @noRd
label_mock_jury <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("attr" %in% names(df) && is.character(df$attr)) {
    df$attr <- dplyr::case_match(
      df$attr,
      "Beautiful" ~ 1,
      "Average" ~ 2,
      "Unattractive" ~ 3,
      .default = NA_real_
    )
  }

  if ("crime" %in% names(df) && is.character(df$crime)) {
    df$crime <- dplyr::case_match(
      df$crime,
      "Burglary" ~ 1,
      "Swindle" ~ 2,
      .default = NA_real_
    )
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "attr", c("Beautiful" = 1, "Average" = 2, "Unattractive" = 3))
  df <- safe_labelled(df, "crime", c(
    "Burglary (theft of items from victim's room)" = 1,
    "Swindle (conned a male victim)" = 2
  ))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    attr = "Attractiveness of the photo",
    crime = "Type of crime",
    years = "Length of sentence given the defendant by the mock juror subject (in years)",
    serious = "A rating of how serious the subject thought the defendant's crime was",
    exciting = "Rating of the photo for 'exciting'",
    calm = "Rating of the photo for 'calm'",
    independent = "Rating of the photo for 'independent'",
    sincere = "Rating of the photo for 'sincere'",
    warm = "Rating of the photo for 'warm'",
    phyattr = "Rating of the photo for 'physical attractiveness'",
    sociable = "Rating of the photo for 'sociable'",
    kind = "Rating of the photo for 'kind'",
    intelligent = "Rating of the photo for 'intelligent'",
    strong = "Rating of the photo for 'strong'",
    sophisticated = "Rating of the photo for 'sophisticated'",
    happy = "Rating of the photo for 'happy'",
    ownPA = "Self-rating of the subject for 'physical attractiveness'"
  ))

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Candy (full) -----------------------------------------------------------

#' @noRd
label_candy <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert Yes/No strings to numeric codes
  binary_vars <- c("chocolate", "fruity", "caramel", "peanutyalmondy",
                   "nougat", "crispedricewafer", "hard", "bar", "pluribus")

  for (var in binary_vars) {
    if (var %in% names(df) && is.character(df[[var]])) {
      df[[var]] <- dplyr::case_match(
        df[[var]],
        "Yes" ~ 1,
        "No" ~ 0,
        .default = NA_real_
      )
    }
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 3: Apply value labels
  for (var in binary_vars) {
    df <- safe_labelled(df, var, c("No" = 0, "Yes" = 1))
  }

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    competitorname = "The name of the candy",
    chocolate = "Does it contain chocolate?",
    fruity = "Is it fruit flavored?",
    caramel = "Is there caramel in the candy?",
    peanutyalmondy = "Does it contain peanuts, peanut butter or almonds?",
    nougat = "Does it contain nougat?",
    crispedricewafer = "Does it contain crisped rice, wafers, or a cookie component?",
    hard = "Is it a hard candy?",
    bar = "Is it a candy bar?",
    pluribus = "Is it one of many candies in a bag or box?",
    sugarpercent = "The percentile of sugar it falls under within the data set",
    pricepercent = "The unit price percentile compared to the rest of the set",
    winpercent = "The overall win percentage according to 269,000 matchups"
  ))

  # Set SPSS formats
  for (v in binary_vars) {
    if (v %in% names(df)) {
      attr(df[[v]], "format.spss") <- "F1.0"
      attr(df[[v]], "spss_measure") <- "nominal"
    }
  }
  for (v in c("sugarpercent", "pricepercent", "winpercent")) {
    if (v %in% names(df)) {
      attr(df[[v]], "format.spss") <- "F8.6"
      attr(df[[v]], "spss_measure") <- "scale"
    }
  }

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Candy (simple) ---------------------------------------------------------

#' @noRd
label_candy_simple <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert Yes/No to numeric
  if ("chocolate" %in% names(df) && is.character(df$chocolate)) {
    df$chocolate <- dplyr::case_match(
      df$chocolate,
      "Yes" ~ 1,
      "No" ~ 0,
      .default = NA_real_
    )
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "chocolate", c("No" = 0, "Yes" = 1))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    competitorname = "The name of the candy",
    chocolate = "Does it contain chocolate?",
    sugarpercent = "The percentile of sugar it falls under within the data set",
    pricepercent = "The unit price percentile compared to the rest of the set",
    winpercent = "The overall win percentage according to 269,000 matchups"
  ))

  # Set SPSS formats
  if ("chocolate" %in% names(df)) {
    attr(df$chocolate, "format.spss") <- "F1.0"
    attr(df$chocolate, "spss_measure") <- "nominal"
  }
  for (v in c("sugarpercent", "pricepercent", "winpercent")) {
    if (v %in% names(df)) {
      attr(df[[v]], "format.spss") <- "F8.6"
      attr(df[[v]], "spss_measure") <- "scale"
    }
  }

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}


# ---- Football ---------------------------------------------------------------

#' @noRd
label_football <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("group" %in% names(df) && is.character(df$group)) {
    df$group <- dplyr::case_match(
      df$group,
      "Control" ~ 1,
      "Football no concussion" ~ 2,
      "Football with concussion" ~ 3,
      .default = NA_real_
    )
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "group", c(
    "Control (no football)" = 1,
    "Football player, no concussions" = 2,
    "Football player with concussion history" = 3
  ))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    group = "Group classification",
    years = "Number of years a person played football",
    volume = "Total hippocampus volume, in cubic centimeters"
  ))

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Interpersonal ----------------------------------------------------------

#' @noRd
label_interpersonal <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 2: Apply value labels
  df <- safe_labelled(df, "gender", c(Male = 1, Female = 2, Another = 3))
  df <- safe_labelled(df, "sexorient", c(
    Asexual = 1, Bisexual = 2, Demisexual = 3, Gay = 4,
    Lesbian = 5, Pansexual = 6, Queer = 7, Questioning = 8,
    `Sexually fluid` = 9, `Straight or heterosexual` = 10, Other = 11
  ))
  df <- safe_labelled(df, "race", c(
    Asian = 1, Black = 2, `Indigenous, Aboriginal, or First Nations` = 3,
    `Latino or Hispanic` = 4, `Middle Eastern` = 5, White = 6, Other = 7
  ))
  df <- safe_labelled(df, "hand", c(Right = 1, Left = 2, Both = 3))
  df <- safe_labelled(df, "community", c(Rural = 1, `Small town` = 2, Suburban = 3, Urban = 4))
  df <- safe_labelled(df, "parentedu", c(No = 0, Yes = 1))
  df <- safe_labelled(df, "famclass", c(
    `Working class` = 1, `Lower class` = 2, `Lower middle class` = 3,
    `Upper middle class` = 4, `Upper class` = 5
  ))
  df <- safe_labelled(df, "greek_in", c(Independent = 1, Greek = 2))
  df <- safe_labelled(df, "campus", c(No = 0, Yes = 1))
  df <- safe_labelled(df, "relsp", c(
    "In a monogamous relationship" = 1, "In a polyamorous relationship" = 2,
    "In multiple relationships" = 3, "Not in a relationship" = 4,
    "I prefer not to answer" = 5
  ))

  # Step 3: Apply variable labels
  df <- safe_var_labels(df, list(
    age = "Age",
    gender = "Self-described gender",
    sexorient = "Self-described sexual orientation and/or sexual identity",
    race = "Self-described race",
    hand = "What hand do you use to write with?",
    community = "Type of community where spent majority of childhood",
    parentedu = "Did one or more of your parents graduate from a four-year college",
    famclass = "Social class identity in childhood",
    faminc = "Families' income during senior year in high school",
    numsib = "Number of siblings",
    move = "Number of times moved as child",
    clsfrn = "Number of people you think of as a close friend",
    clsfrlst = "Number of people think would list you as close friend",
    greek_in = "Member of fraternity or sorority",
    campus = "Living on campus during current semester",
    relsp = "Currently in romantic relationship",
    rlength = "Length of current or last relationship in months",
    serious = "Rating seriousness of current or most recent relationship (0-7)",
    numrels = "Number of dating relationships",
    gcb = "Generic Conspiracist Beliefs scale",
    datdaq = "Dating subscale of the DAQ",
    assrtdaq = "Assertiveness subscale of the DAQ",
    emorel = "Emotional reliance on others subscale of the Interpersonal Dependency Inventory",
    lacksc = "Lack of self-confidence subscale of the Interpersonal Dependency Inventory",
    auto = "Assertion of autonomy subscale of the Interpersonal Dependency Inventory",
    perspec = "Perspective-taking subscale of the Interpersonal Reactivity Index",
    fantasy = "Fantasy subscale of the Interpersonal Reactivity Index",
    empath = "Empathic concern subscale of the Interpersonal Reactivity Index",
    distress = "Personal distress subscale of the Interpersonal Reactivity Index",
    polsoc = "Political sociability subscale of Sociability Scale",
    npolsoc = "Non-political sociability subscale of Sociability Scale",
    risc = "Relational-Interdependent Self-Construal Scale",
    lsas = "Liebowitz Social Anxiety Scale self-report total score (LSAS-SR)"
  ))

  # Set SPSS formats (only for existing columns)
  nominal_vars <- c("gender", "sexorient", "race", "hand", "community",
                    "parentedu", "famclass", "greek_in", "campus", "relsp")
  for (var in nominal_vars) {
    if (var %in% names(df)) {
      attr(df[[var]], "format.spss") <- "F1.0"
      attr(df[[var]], "spss_measure") <- "nominal"
    }
  }

  scale_vars <- c("age", "faminc", "numsib", "move", "clsfrn", "clsfrlst",
                  "rlength", "serious", "numrels", "gcb", "datdaq", "assrtdaq",
                  "emorel", "lacksc", "auto", "perspec", "fantasy", "empath",
                  "distress", "polsoc", "npolsoc", "risc", "lsas")
  for (var in scale_vars) {
    if (var %in% names(df)) {
      attr(df[[var]], "spss_measure") <- "scale"
      if (var %in% c("age", "numsib", "move", "clsfrn", "clsfrlst", "numrels",
                     "serious", "rlength", "perspec", "fantasy", "empath",
                     "distress", "polsoc", "npolsoc", "lsas")) {
        attr(df[[var]], "format.spss") <- "F3.0"
      } else if (var == "faminc") {
        attr(df[[var]], "format.spss") <- "F10.0"
      } else {
        attr(df[[var]], "format.spss") <- "F5.2"
      }
    }
  }

  # Step 4: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Self-Descriptive -------------------------------------------------------

#' @noRd
label_self_descriptive <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 2: Apply value labels
  df <- safe_labelled(df, "gender", c(Male = 1, Female = 2, Another = 3))
  df <- safe_labelled(df, "sexorient", c(
    Asexual = 1, Bisexual = 2, Demisexual = 3, Gay = 4,
    Lesbian = 5, Pansexual = 6, Queer = 7, Questioning = 8,
    `Sexually fluid` = 9, `Straight or heterosexual` = 10, Other = 11
  ))
  df <- safe_labelled(df, "race", c(
    Asian = 1, Black = 2, `Indigenous, Aboriginal, or First Nations` = 3,
    `Latino or Hispanic` = 4, `Middle Eastern` = 5, White = 6, Other = 7
  ))
  df <- safe_labelled(df, "hand", c(Right = 1, Left = 2, Both = 3))
  df <- safe_labelled(df, "community", c(Rural = 1, `Small town` = 2, Suburban = 3, Urban = 4))
  df <- safe_labelled(df, "parentedu", c(No = 0, Yes = 1))
  df <- safe_labelled(df, "famclass", c(
    `Working class` = 1, `Lower class` = 2, `Lower middle class` = 3,
    `Upper middle class` = 4, `Upper class` = 5
  ))
  df <- safe_labelled(df, "greek_in", c(Independent = 1, Greek = 2))
  df <- safe_labelled(df, "campus", c(No = 0, Yes = 1))
  df <- safe_labelled(df, "relsp", c(
    "In a monogamous relationship" = 1, "In a polyamorous relationship" = 2,
    "In multiple relationships" = 3, "Not in a relationship" = 4,
    "I prefer not to answer" = 5
  ))

  # Step 3: Apply variable labels
  df <- safe_var_labels(df, list(
    age = "Age",
    gender = "Self-described gender",
    sexorient = "Self-described sexual orientation and/or sexual identity",
    race = "Self-described race",
    hand = "What hand do you use to write with?",
    community = "Type of community where spent majority of childhood",
    parentedu = "Did one or more of your parents graduate from a four-year college",
    famclass = "Social class identity in childhood",
    faminc = "Families' income during senior year in high school",
    numsib = "Number of siblings",
    move = "Number of times moved as child",
    clsfrn = "Number of people you think of as a close friend",
    clsfrlst = "Number of people think would list you as close friend",
    greek_in = "Member of fraternity or sorority",
    campus = "Living on campus during current semester",
    relsp = "Currently in romantic relationship",
    rlength = "Length of current or last relationship in months",
    serious = "Rating seriousness of current or most recent relationship (0-7)",
    numrels = "Number of dating relationships",
    extraversion = "Extraversion subscale (TIPI)",
    agreeableness = "Agreeableness subscale (TIPI)",
    conscientiousness = "Conscientiousness subscale (TIPI)",
    emot_stability = "Emotional Stability subscale (TIPI)",
    openness = "Openness to Experience subscale (TIPI)",
    disc = "Discomfort with Ambiguity subscale (MAAS)",
    moral = "Moral Absolutism/Splitting subscale (MAAS)",
    comp = "Need for Complexity and Novelty subscale (MAAS)",
    maas = "Multidimensional Attitude towards Ambiguity Scale (MAAS) total",
    rse = "Rosenberg Self-Esteem scale",
    promote = "Promotion Focus subscale (RFQ)",
    prevent = "Prevention Focus subscale (RFQ)",
    pmdc = "Personal Maladjustment & Desire for Change subscale (ATQ)",
    nsne = "Negative Self-Concepts & Negative Expectations subscale (ATQ)",
    lse = "Low Self-Esteem subscale (ATQ)",
    help = "Helplessness subscale (ATQ)",
    atq = "Automatic Thoughts Questionnaire (ATQ-30) total",
    ngse = "New general self-efficacy scale"
  ))

  # Set SPSS formats (only for existing columns)
  nominal_vars <- c("gender", "sexorient", "race", "hand", "community",
                    "parentedu", "famclass", "greek_in", "campus", "relsp")
  for (var in nominal_vars) {
    if (var %in% names(df)) {
      attr(df[[var]], "format.spss") <- "F1.0"
      attr(df[[var]], "spss_measure") <- "nominal"
    }
  }

  scale_vars <- c("age", "faminc", "numsib", "move", "clsfrn", "clsfrlst",
                  "rlength", "serious", "numrels", "extraversion", "agreeableness",
                  "conscientiousness", "emot_stability", "openness",
                  "disc", "moral", "comp", "maas", "rse", "promote", "prevent",
                  "pmdc", "nsne", "lse", "help", "atq", "ngse")
  for (var in scale_vars) {
    if (var %in% names(df)) {
      attr(df[[var]], "spss_measure") <- "scale"
      if (var %in% c("age", "numsib", "move", "clsfrn", "clsfrlst", "numrels",
                     "serious", "rlength", "atq")) {
        attr(df[[var]], "format.spss") <- "F3.0"
      } else if (var == "faminc") {
        attr(df[[var]], "format.spss") <- "F10.0"
      } else {
        attr(df[[var]], "format.spss") <- "F5.2"
      }
    }
  }

  # Step 4: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Huskers ----------------------------------------------------------------

#' @noRd
label_huskers <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("site" %in% names(df) && is.character(df$site)) {
    df$site <- dplyr::case_match(
      df$site,
      "Home" ~ 1,
      "Away" ~ 2,
      "Neutral (home)" ~ 3,
      "Neutral (away)" ~ 4,
      .default = NA_real_
    )
  }

  if ("result" %in% names(df) && is.character(df$result)) {
    df$result <- dplyr::case_match(
      df$result,
      "Win" ~ 1,
      "Loss" ~ 2,
      "Tie" ~ 3,
      .default = NA_real_
    )
  }

  if ("conference" %in% names(df) && is.character(df$conference)) {
    df$conference <- dplyr::case_match(
      df$conference,
      "Non-conference" ~ 0,
      "Conference" ~ 1,
      .default = NA_real_
    )
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.character),
                                  ~ifelse(is.na(.x) | .x == "", "-99", .x)))
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "result", c("Win" = 1, "Loss" = 2, "Tie" = 3))
  df <- safe_labelled(df, "site", c("Home" = 1, "Away" = 2, "Neutral (home)" = 3, "Neutral (away)" = 4))
  df <- safe_labelled(df, "conference", c("Non-conference" = 0, "Conference game" = 1))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    date = "Date the game was played",
    time = "Kickoff time (Central Time)",
    season = "Season (year)",
    opp = "Opponent",
    site = "Game location",
    conference = "Conference game",
    opp_rank = "Opponent ranking entering the game",
    ne_rank = "Nebraska ranking entering the game",
    result = "Game result",
    opp_score = "Opponent total score",
    ne_score = "Nebraska total score",
    opp_score_q1 = "Opponent 1st quarter points",
    opp_score_q2 = "Opponent 2nd quarter points",
    opp_score_q3 = "Opponent 3rd quarter points",
    opp_score_q4 = "Opponent 4th quarter points",
    opp_score_ot = "Opponent overtime points",
    ne_score_q1 = "Nebraska 1st quarter points",
    ne_score_q2 = "Nebraska 2nd quarter points",
    ne_score_q3 = "Nebraska 3rd quarter points",
    ne_score_q4 = "Nebraska 4th quarter points",
    ne_score_ot = "Nebraska overtime points",
    opp_rush_att = "Opponent rushing attempts",
    opp_rush_yards = "Opponent rushing yards",
    ne_rush_att = "Nebraska rushing attempts",
    ne_rush_yards = "Nebraska rushing yards",
    opp_pass_comp = "Opponent passing completions",
    opp_pass_att = "Opponent passing attempts",
    opp_pass_yards = "Opponent passing yards",
    ne_pass_comp = "Nebraska passing completions",
    ne_pass_att = "Nebraska passing attempts",
    ne_pass_yards = "Nebraska passing yards",
    opp_first_downs = "Opponent first downs",
    ne_first_downs = "Nebraska first downs",
    opp_third_down_comp = "Opponent third down conversions",
    opp_third_down_att = "Opponent third down attempts",
    ne_third_down_comp = "Nebraska third down conversions",
    ne_third_down_att = "Nebraska third down attempts",
    opp_fourth_down_comp = "Opponent fourth down conversions",
    opp_fourth_down_att = "Opponent fourth down attempts",
    ne_fourth_down_comp = "Nebraska fourth down conversions",
    ne_fourth_down_att = "Nebraska fourth down attempts",
    opp_int = "Opponent interceptions thrown",
    opp_fum = "Opponent fumbles lost",
    ne_int = "Nebraska interceptions thrown",
    ne_fum = "Nebraska fumbles lost",
    opp_pen_num = "Opponent number of penalties",
    opp_pen_yards = "Opponent penalty yards",
    ne_pen_num = "Nebraska number of penalties",
    ne_pen_yards = "Nebraska penalty yards",
    opp_possession = "Opponent time of possession (MM:SS)",
    ne_possession = "Nebraska time of possession (MM:SS)",
    spread = "Point spread (negative = Nebraska favored)",
    total = "Betting total (Over/Under)",
    temp = "Temperature at kickoff (Fahrenheit)",
    humidity = "Relative humidity at kickoff (0-1)",
    wind_speed = "Wind speed at kickoff (mph)",
    wind_bearing = "Wind direction at kickoff (degrees, 0=North)"
  ))

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}

# ---- Tip Jokes --------------------------------------------------------------

#' @noRd
label_tip_jokes <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes
  if ("card" %in% names(df) && is.character(df$card)) {
    df$card <- dplyr::case_match(
      df$card,
      "Advertisement" ~ 1,
      "Joke" ~ 2,
      "None" ~ 3,
      .default = NA_real_
    )
  }

  # Convert Yes/No variables to 0/1
  yes_no_vars <- c("tip", "ad", "joke", "none")
  for (var in yes_no_vars) {
    if (var %in% names(df) && is.character(df[[var]])) {
      df[[var]] <- dplyr::case_match(
        df[[var]],
        "Yes" ~ 1,
        "No" ~ 0,
        .default = NA_real_
      )
    }
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 3: Apply value labels
  df <- safe_labelled(df, "card", c(
    "Advertisement card" = 1,
    "Joke card" = 2,
    "No card" = 3
  ))
  df <- safe_labelled(df, "tip", c("No" = 0, "Yes" = 1))
  df <- safe_labelled(df, "ad", c("No" = 0, "Yes" = 1))
  df <- safe_labelled(df, "joke", c("No" = 0, "Yes" = 1))
  df <- safe_labelled(df, "none", c("No" = 0, "Yes" = 1))

  # Step 4: Apply variable labels
  df <- safe_var_labels(df, list(
    card = "Type of card left by waiter",
    tip = "Whether customer left a tip",
    ad = "Indicator for advertisement card",
    joke = "Indicator for joke card",
    none = "Indicator for no card"
  ))

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- safe_set_na_values(df)
  }

  df
}
