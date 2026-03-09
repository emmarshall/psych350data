
#' Hot Ones Guest Data
#'
#' Data on guests from the YouTube show Hot Ones, including demographic
#' information, Scoville ratings for each sauce, and YouTube engagement metrics.
#'
#' @format A tibble with variables including:
#' \describe{
#'   \item{subn}{Unique guest/participant number}
#'   \item{name}{Guest full name}
#'   \item{gender}{Guest gender: Male (1), Female (2)}
#'   \item{age}{Guest age at time of appearance}
#'   \item{occupation}{Guest primary occupation (1-14, see value labels)}
#'   \item{wing_total}{Number of wings eaten}
#'   \item{alt_food}{Alternative food used instead of wings}
#'   \item{helpers}{Drinks or other items used to help with the heat}
#'   \item{SHU_1}{Sauce 1 Scoville Heat Units}
#'   \item{SHU_2}{Sauce 2 Scoville Heat Units}
#'   \item{SHU_3}{Sauce 3 Scoville Heat Units}
#'   \item{SHU_4}{Sauce 4 Scoville Heat Units}
#'   \item{SHU_5}{Sauce 5 Scoville Heat Units}
#'   \item{SHU_6}{Sauce 6 Scoville Heat Units}
#'   \item{SHU_7}{Sauce 7 Scoville Heat Units}
#'   \item{SHU_8}{Sauce 8 Scoville Heat Units}
#'   \item{SHU_9}{Sauce 9 Scoville Heat Units}
#'   \item{SHU_10}{Sauce 10 Scoville Heat Units}
#'   \item{result}{Succeeded (1), Failed (2), or Incomplete (3)}
#'   \item{appearances}{Number of appearances on the show}
#'   \item{season}{Season number}
#'   \item{order}{Episode number within season}
#'   \item{views}{YouTube views (in millions)}
#'   \item{likes}{YouTube likes}
#'   \item{comments}{YouTube comments}
#' }
#'
#' @source Hot Ones / First We Feast (YouTube)
"hotones"

#' Hot Ones Sauce Data
#'
#' Data on hot sauces used in each season and position of Hot Ones,
#' including Scoville Heat Unit ratings.
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{season}{Season of Hot Ones}
#'   \item{order}{Sauce position in the lineup (1-10, from mildest to hottest)}
#'   \item{sauce_name}{Name of the hot sauce}
#'   \item{SHU}{Scoville Heat Units (SHU) rating}
#' }
#'
#' @source Hot Ones / First We Feast (YouTube)
"hotones_sauces"

#' Hot Ones Episode Data
#'
#' Episode-level data from the YouTube show Hot Ones, including
#' guest names, titles, and YouTube engagement metrics.
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{season}{Season of Hot Ones}
#'   \item{order}{Episode number within season}
#'   \item{guest}{Name of the guest}
#'   \item{episode_title}{Full title of the episode}
#'   \item{publish_date}{Date the episode was published on YouTube}
#'   \item{views}{Number of YouTube views (in millions)}
#'   \item{likes}{Number of YouTube likes}
#'   \item{comments}{Number of YouTube comments}
#'   \item{short_description}{Short description of the episode}
#'   \item{img}{URL to episode thumbnail image}
#'   \item{video_id}{YouTube video ID}
#' }
#'
#' @source Hot Ones / First We Feast (YouTube)
"hotones_episodes"


# ---- Hot Ones Labels ---------------------------------------------------------------

# ---- Hot Ones (Guests) ------------------------------------------------------

#' @noRd
label_hotones <- function(df, use_sentinel = TRUE) {

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
label_hotones_sauces <- function(df, use_sentinel = TRUE) {

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
label_hotones_episodes <- function(df, use_sentinel = TRUE) {

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
