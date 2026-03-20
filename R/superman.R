#' Superman Actor Data
#'
#' Physical characteristics and ratings data for actors who have played
#' Superman across various films and TV shows.
#'
#' @format A tibble with 11 rows and variables:
#' \describe{
#'   \item{num}{Participant id number}
#'   \item{type}{Media type (Film, TV Show, Serial)}
#'   \item{title}{Title of the production}
#'   \item{year}{Release year}
#'   \item{clark_actor}{Actor playing Clark Kent/Superman}
#'   \item{clark_height}{Clark Kent/Superman actor's height in meters}
#'   \item{clark_age}{Clark Kent/Superman actor's age at debut
#'   #'(years)}
#'   \item{lois_actor}{Actor playing Lois Lane}
#'   \item{lois_height}{Lois Lane actor's height in meters}
#'   \item{lois_age}{Lois Lane actor's age at debut (years)}
#'   \item{clark_height_in}{Clark Kent/Superman actor's height in inches}
#'   \item{lois_height_in}{Lois Lane actor's height in inches}
#'   \item{clark_grp}{Clark Height group: 1 = under 72 inches, 2 = 72+ inches}
#'   \item{height_diff}{Height difference between Lois and Clark in inches (Clark - Lois)}
#'   \item{age_diff}{Age difference between Lois and Clark in years}

#'   \item{age_gap}{Height gap category: 1 = <6in, 2 = 6-8in, 3 = >8in}
#'   \item{rt_critics_score}{Rotten Tomatoes critics score}
#'   \item{rt_critics_count}{Number of critics reviews on Rotten Tomatoes}
#'   \item{rt_audience_score}{Rotten Tomatoes audience score}
#'   \item{rt_critics_count}{Number of audience reviews on Rotten Tomatoes}
#'   \item{tomatometer}{Critics rating: 1 = Rotten (<60), 2 = Fresh (60+)}
#'   \item{rt_avg}{Average of critics and audience Rotten Tomatoes scores}
#'   \item{rt_diff}{Weighted difference between critics and audience scores on Rotten Tomatoes}
#'   \item{ldb_likes}{Letterboxd likes}
#'   \item{ldb_scores}{Letterboxd score}
#'   \item{popular}{Popularity category based on Letterboxd likes}
#' }
#'
#' @source Compiled from the internet including Rotten Tomatoes, Letterboxd, and IMDb.
"superman"

#' Superman SMES Data
#'
#' Simulated data for 47 participants rating Superman media on the
#' Subjective Media Experience Scale (SMES), grouped by the height gap
#' and age difference between the Superman and Lois Lane actors.
#'
#' @format A data frame with 47 rows and 6 variables:
#' \describe{
#'   \item{num}{Unique participant number}
#'   \item{height_gap}{Height gap category: Minimal (1), Average (2), Big (3)}
#'   \item{age_grp}{Age difference category: Minimal (1), Average (2), Big (3)}
#'   \item{emotional_impact}{Emotional Impact subscale (sum of 4 items, range 4-20)}
#'   \item{aesthetic_appeal}{Aesthetic Appeal subscale (sum of 3 items, range 3-15)}
#'   \item{cognitive_engagement}{Cognitive Engagement subscale (mean of 4 items, range 0-7)}
#' }
"superman_smes"


#' Superman Movies Box Office Data
#'
#' Box office and production data for Superman theatrical films,
#' including budget, domestic and international grosses, and MPAA ratings.
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{imdb_id}{IMDb title ID (e.g., "tt0078346")}
#'   \item{title}{Movie title}
#'   \item{year}{Release year}
#'   \item{description}{Movie description/tagline}
#'   \item{domestic_gross}{Domestic box office gross (millions USD)}
#'   \item{domestic_pct}{Domestic percentage of worldwide gross}
#'   \item{international_gross}{International box office gross (millions USD)}
#'   \item{international_pct}{International percentage of worldwide gross}
#'   \item{worldwide_gross}{Worldwide box office gross (millions USD)}
#'   \item{distributor}{Domestic distributor}
#'   \item{opening_weekend}{Domestic opening weekend gross (millions USD)}
#'   \item{budget}{Production budget (millions USD)}
#'   \item{release_date}{Earliest release date}
#'   \item{mpaa}{MPAA rating (G, PG, PG-13, R)}
#'   \item{runtime_min}{Runtime in minutes}
#'   \item{genres}{Genres (space-separated)}
#'   \item{poster_url}{Movie poster URL (low resolution)}
#'   \item{poster_url_hires}{Movie poster URL (high resolution)}
#'   \item{clark_actor}{Actor playing Clark Kent/Superman (for joining with superman dataset)}
#'   \item{roi}{Return on investment ((worldwide - budget) / budget)}
#'   \item{budget_cat}{Budget category (tercile-based): Low, Medium, High}
#'   \item{box_office_cat}{Box office category (tercile-based): Low, Medium, High}
#' }
#'
#' @source IMDb Box Office Mojo
#'
#' @examples
#' \dontrun{
#' superman_movies
#' combined <- join_superman_data()
#' combined |> export_sav(path = "superman_combined.sav")
#' }
"superman_movies"




## Label it!

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
    type = "Type of media (1=Film, 2=TV Series, 3=Serial)",
    clark_actor = "Actor playing Clark Kent/Superman",
    clark_height = "Height of Clark Kent/Superman actor in meters",
    clark_age = "Age of Clark Kent/Superman actor at debut in years",
    lois_actor = "Actor playing Lois Lane",
    lois_height = "Height of Lois Lane actor in meters",
    lois_age = "Age of Lois Lane actor at debut in years",
    age_diff = "Age difference between Lois and Clark in years",
    age_grp = "Relative age difference between actors (1=minimal (<2yr), 2=average (2-6), 3=big ())",
    clark_height_in = "Height of Clark Kent/Superman actor in inches",
    lois_height_in = "Height of Lois Lane actor in inches",
    clark_grp = "Whether Clark Kent/Superman actor is taller than 6ft (1 = under 6ft tall, 2 = over 6ft tall)",
    height_diff = "Height difference between Clark Kent/Superman and Lois Lane actors in inches",
    height_gap = "Relative size of height gap between actors (1 = minimal (< 6 inches), 2 = average (6-8 inches), and 3 = big (> 8 inches))",
    rt_critics_score = "Rotten Tomatoes critics score (0-100% scale)",
    rt_critic_count = "Number of Rotten Tomatoes critic reviews",
    rt_audience_score = "Rotten Tomatoes audience score (0-100% scale)",
    rt_audience_count = "Number of Rotten Tomatoes audience reviews",
    ldb_likes = "Total number of users that liked the film on Letterboxd",
    ldb_scores = "Letterboxd users average rating (1-5 stars)",
    tomatometer = "Whether the media was liked by more than 60% of critics on Rotten Tomatoes (1 = Rotten, 2=Fresh)",
    rt_avg = "Average of critics and audience scores on Rotten Tomatoes",
    rt_diff = "Weighted difference between critics and audience scores on Rotten Tomatoes",
    popular = "Popularity based on number of user likes on Letterboxd (1 = Low (<1,000 likes), 2 = Mid (1,000-100,000 likes), 3 = High (>100,000 likes))"
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

  if ("age_grp" %in% names(df) && is.character(df$age_grp)) {
    df$age_grp <- dplyr::case_match(
      df$age_grp,
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

  df <- safe_labelled(df, "age_grp", c(
    "Minimal (<2 years)"  = 1,
    "Average (2-5 years)" = 2,
    "Big (>5 years)"      = 3
  ))

  # Step 3: Apply variable labels
  df <- safe_var_labels(df, list(
    num                  = "Unique participant number",
    height_gap           = "Height gap category between Superman and Lois Lane actors (1=Minimal (<6 inches), 2=Average (6-8 inches), 3=Big (>8 inches))",
    age_grp              = "Age difference category between Superman and Lois Lane actors (1=Minimal (<2 years), 2=Average (2-5 years), 3=Big (>5 years))",
    emotional_impact     = "Emotional Impact subscale (sum of 4 items, range 4-20)",
    aesthetic_appeal     = "Aesthetic Appeal subscale (sum of 3 items, range 3-15)",
    cognitive_engagement = "Cognitive Engagement subscale (mean of 4 items, range 0-7)"
  ))

  # Step 4: Set SPSS formats
  if ("height_gap" %in% names(df)) {
    attr(df$height_gap, "format.spss") <- "F1.0"
  }
  if ("age_grp" %in% names(df)) {
    attr(df$age_grp, "format.spss") <- "F1.0"
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

  if ("budget_cat" %in% names(df) && (is.character(df$budget_cat) || is.factor(df$budget_cat))) {
    df$budget_cat <- dplyr::case_match(
      as.character(df$budget_cat),
      "Low" ~ 1,
      "Medium" ~ 2,
      "High" ~ 3,
      .default = NA_real_
    )
  }

  if ("box_office_cat" %in% names(df) && (is.character(df$box_office_cat) || is.factor(df$box_office_cat))) {
    df$box_office_cat <- dplyr::case_match(
      as.character(df$box_office_cat),
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
  df <- safe_labelled(df, "budget_cat", c("Low (bottom tercile)" = 1, "Medium (middle tercile)" = 2, "High (top tercile)" = 3))
  df <- safe_labelled(df, "box_office_cat", c("Low (bottom tercile)" = 1, "Medium (middle tercile)" = 2, "High (top tercile)" = 3))

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
          as.character(budget_cat) == "High" ~ 1,
          as.character(budget_cat) %in% c("Low", "Medium") ~ 2,
          TRUE ~ NA_real_
        ),
        boxoffice2 = dplyr::case_when(
          as.character(box_office_cat) == "High" ~ 1,
          as.character(box_office_cat) %in% c("Low", "Medium") ~ 2,
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



## Combined Big 'ol Superman dataset functions

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
