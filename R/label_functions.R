# ============================================================================
# SPSS labelling functions for each dataset
# Each takes a clean R data frame (with NAs) and returns a labelled version
# matching the original SPSS data prep scripts, ready for haven::write_sav()
#
# When use_sentinel = TRUE:
#   1. All NA values in numeric columns are replaced with -99
#   2. The na_values attribute is set so SPSS treats -99 as user-missing
# ============================================================================

# ---- Superman ---------------------------------------------------------------

#' @noRd
label_superman <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes

  # type: Film = 1, TV Show/TV Series = 2, Serial = 3
  if (is.character(df$type)) {
    df$type <- dplyr::case_match(
      df$type,
      "Film" ~ 1,
      "TV Show" ~ 2,
      "TV Series" ~ 2,
      "Serial" ~ 3,
      .default = NA_real_
    )
  }

  # media: map to numeric codes using media name + year to disambiguate
  if (is.character(df$media)) {
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

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 3: Apply value labels
  df$media <- labelled::labelled(
    df$media,
    labels = c(
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
    )
  )

  df$type <- labelled::labelled(
    df$type,
    labels = c("Film" = 1, "TV Show" = 2, "Serial" = 3)
  )

  df$clark_grp <- labelled::labelled(
    df$clark_grp,
    labels = c(
      "under 6ft tall (<72 inches)" = 1,
      "over 6ft tall (\u226572 inches)" = 2
    )
  )

  df$height_gap <- labelled::labelled(
    df$height_gap,
    labels = c(
      "minimal (< 6 inches)" = 1,
      "average (6-8 inches)" = 2,
      "big (> 8 inches)" = 3
    )
  )

  df$age_grp <- labelled::labelled(
    df$age_grp,
    labels = c(
      "minimal (< 2 years)" = 1,
      "average (2-5 years)" = 2,
      "big (> 5 years)" = 3
    )
  )

  df$popular <- labelled::labelled(
    df$popular,
    labels = c(
      "low (< 1,000 likes)" = 1,
      "mid (1,000-100,000 likes)" = 2,
      "high (> 100,000 likes)" = 3
    )
  )

  df$tomatometer <- labelled::labelled(
    df$tomatometer,
    labels = c("rotten" = 1, "fresh" = 2)
  )

  # Step 4: Apply variable labels
  labelled::var_label(df) <- list(
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
    rt_audience_score = "Rotten Tomatoes audience score (0-100 scale)",
    ldb_likes = "Total number of users that liked the film on Letterboxd",
    ldb_scores = "Letterboxd users average rating (1-5 stars)",
    tomatometer = "Whether the media was liked by more than 60% of critics on Rotten Tomatoes",
    rt_avg = "Average of critics and audience scores on Rotten Tomatoes",
    popular = "Popularity based on number of user likes on Letterboxd (low/mid/high)"
  )

  # Step 5: Set -99 as missing values LAST
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        media = -99,
        type = -99,
        clark_height = -99,
        lois_height = -99,
        clark_height_in = -99,
        clark_age = -99,
        lois_height_in = -99,
        lois_age = -99,
        age_diff = -99,
        age_grp = -99,
        clark_grp = -99,
        height_diff = -99,
        height_gap = -99,
        rt_critics_score = -99,
        rt_audience_score = -99,
        ldb_likes = -99,
        ldb_scores = -99,
        tomatometer = -99,
        rt_avg = -99,
        popular = -99
      )
  }

  df
}


# ---- Hot Ones ---------------------------------------------------------------

#' @noRd
label_hot_ones <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 2: Apply value labels
  df$gender <- labelled::labelled(
    df$gender,
    labels = c("Male" = 1, "Female" = 2)
  )

  df$occupation <- labelled::labelled(
    df$occupation,
    labels = c(
      "Rapper" = 1, "Athlete" = 2, "Actor" = 3, "Actor-Comedian" = 4,
      "Comedian" = 5, "Chef" = 6, "Actor-Musician" = 7, "Musician" = 8,
      "DJ" = 9, "YouTuber" = 10, "Model" = 11, "Wrestler" = 12,
      "Magician" = 13, "Other" = 14
    )
  )

  df$result <- labelled::labelled(
    df$result,
    labels = c("Succeeded" = 1, "Failed" = 2)
  )

  # Step 3: Apply variable labels
  labelled::var_label(df) <- list(
    subn = "Unique number for each guest/participant",
    name = "Guest Full Name",
    gender = "Guest Gender",
    age = "Guest Age",
    occupation = "Guest's primary occupation",
    result = "Whether the guest finished all the wings or quit (wall of flame)",
    appearances = "Number of appearances on Hot Ones",
    season = "Season of Hot Ones",
    order = "Episode number within Season of Hot Ones",
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
  )

  # Set SPSS formats
  for (var in names(df)) {
    if (var %in% c("gender", "result", "occupation")) {
      attr(df[[var]], "format.spss") <- "F1.0"
    } else if (grepl("^SHU_", var)) {
      attr(df[[var]], "format.spss") <- "F10.0"
    } else if (var %in% c("age", "season", "order", "appearances", "subn")) {
      attr(df[[var]], "format.spss") <- "F3.0"
    } else if (var %in% c("views", "likes", "comments")) {
      attr(df[[var]], "format.spss") <- "F12.0"
    }
  }

  # Step 4: Set -99 as missing values
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        subn = -99,
        gender = -99,
        age = -99,
        occupation = -99,
        SHU_1 = -99, SHU_2 = -99, SHU_3 = -99, SHU_4 = -99, SHU_5 = -99,
        SHU_6 = -99, SHU_7 = -99, SHU_8 = -99, SHU_9 = -99, SHU_10 = -99,
        result = -99,
        appearances = -99,
        season = -99,
        order = -99,
        views = -99,
        likes = -99,
        comments = -99
      )
  }

  df
}


# ---- Tip Jokes --------------------------------------------------------------

#' @noRd
label_tip_jokes <- function(df, use_sentinel = TRUE) {

  # Tip jokes has no missing data, but still apply labels

  # Step 2: Apply value labels
  df$card <- labelled::labelled(
    df$card,
    labels = c("Advertisement card" = 1, "Joke card" = 2, "No card" = 3)
  )

  df$tip <- labelled::labelled(
    as.numeric(df$tip),
    labels = c("No tip" = 0, "Customer left a tip" = 1)
  )

  df$ad <- labelled::labelled(
    as.numeric(df$ad),
    labels = c("No ad card" = 0, "Ad card left" = 1)
  )

  df$joke <- labelled::labelled(
    as.numeric(df$joke),
    labels = c("No joke card" = 0, "Joke card left" = 1)
  )

  df$none <- labelled::labelled(
    as.numeric(df$none),
    labels = c("Ad or joke card left" = 0, "No card left" = 1)
  )

  # Step 3: Apply variable labels
  labelled::var_label(df) <- list(
    card = "Type of card used by waiter",
    tip = "Whether customer left a tip",
    ad = "Indicator for Ad card (1=ad card left, 0=no ad card)",
    joke = "Indicator for Joke card (1=joke card left, 0=no joke card)",
    none = "Indicator for no card (1=no card left, 0=ad or joke card left)"
  )

  df
}


# ---- MCU --------------------------------------------------------------------

#' @noRd
label_mcu <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character to numeric - movie stays as character (too many unique values)

  # Ensure numeric columns are numeric
  df$length_hrs <- as.numeric(df$length_hrs)
  df$length_min <- as.numeric(df$length_min)
  df$opening_weekend_us <- as.numeric(df$opening_weekend_us)
  df$gross_us <- as.numeric(df$gross_us)
  df$gross_world <- as.numeric(df$gross_world)
  df$critics <- as.numeric(df$critics)
  df$audience <- as.numeric(df$audience)
  df$phase <- as.numeric(df$phase)
  df$favor <- as.numeric(df$favor)

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 3: Apply value labels
  df$phase <- labelled::labelled(
    df$phase,
    labels = c("Phase 1" = 1, "Phase 2" = 2, "Phase 3" = 3)
  )

  df$favor <- labelled::labelled(
    df$favor,
    labels = c("critics" = 1, "audience" = 2)
  )

  # Step 4: Apply variable labels
  labelled::var_label(df) <- list(
    movie = "Title of the movie",
    length_hrs = "Length of the movie: hours portion",
    length_min = "Length of the movie: minutes portion",
    release_date = "Date the movie was released in the US",
    opening_weekend_us = "Box office totals for opening weekend in the US (not adjusted for inflation)",
    gross_us = "All box office totals in US (not adjusted for inflation)",
    gross_world = "All box office totals world wide (not adjusted for inflation)",
    phase = "Designated phase of the Marvel Cinematic Universe (Phase 1, Phase 2, Phase 3)",
    critics = "Rotten Tomatoes critics score (0-100 scale)",
    audience = "Rotten Tomatoes audience score (0-100 scale)",
    favor = "Whether critics or audience score is higher on Rotten Tomatoes (critics=1; audience=2)"
  )

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        length_hrs = -99,
        length_min = -99,
        opening_weekend_us = -99,
        gross_us = -99,
        gross_world = -99,
        phase = -99,
        critics = -99,
        audience = -99,
        favor = -99
      )
  }

  df
}

# ---- Mock Jury --------------------------------------------------------------

#' @noRd
label_mock_jury <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 2: Apply value labels
  df$attr <- labelled::labelled(
    df$attr,
    labels = c("Beautiful" = 1, "Average" = 2, "Unattractive" = 3)
  )

  df$crime <- labelled::labelled(
    df$crime,
    labels = c(
      "Burglary (theft of items from victim's room)" = 1,
      "Swindle (conned a male victim)" = 2
    )
  )

  # Step 3: Apply variable labels
  labelled::var_label(df) <- list(
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
  )

  # Step 4: Set -99 as missing values
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        attr = -99,
        crime = -99,
        years = -99,
        serious = -99,
        exciting = -99,
        calm = -99,
        independent = -99,
        sincere = -99,
        warm = -99,
        phyattr = -99,
        sociable = -99,
        kind = -99,
        intelligent = -99,
        strong = -99,
        sophisticated = -99,
        happy = -99,
        ownPA = -99
      )
  }

  df
}


# ---- Candy (full) -----------------------------------------------------------

#' @noRd
label_candy <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 2: Apply value labels
  df$chocolate <- labelled::labelled(df$chocolate, labels = c("No" = 0, "Yes" = 1))
  df$fruity <- labelled::labelled(df$fruity, labels = c("No" = 0, "Yes" = 1))
  df$caramel <- labelled::labelled(df$caramel, labels = c("No" = 0, "Yes" = 1))
  df$peanutyalmondy <- labelled::labelled(df$peanutyalmondy, labels = c("No" = 0, "Yes" = 1))
  df$nougat <- labelled::labelled(df$nougat, labels = c("No" = 0, "Yes" = 1))
  df$crispedricewafer <- labelled::labelled(df$crispedricewafer, labels = c("No" = 0, "Yes" = 1))
  df$hard <- labelled::labelled(df$hard, labels = c("No" = 0, "Yes" = 1))
  df$bar <- labelled::labelled(df$bar, labels = c("No" = 0, "Yes" = 1))
  df$pluribus <- labelled::labelled(df$pluribus, labels = c("No" = 0, "Yes" = 1))

  # Step 3: Apply variable labels
  labelled::var_label(df) <- list(
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
  )

  # Set SPSS formats
  binary_vars <- c("chocolate", "fruity", "caramel", "peanutyalmondy",
                   "nougat", "crispedricewafer", "hard", "bar", "pluribus")
  for (v in binary_vars) {
    attr(df[[v]], "format.spss") <- "F1.0"
    attr(df[[v]], "spss_measure") <- "nominal"
  }
  for (v in c("sugarpercent", "pricepercent", "winpercent")) {
    attr(df[[v]], "format.spss") <- "F8.6"
    attr(df[[v]], "spss_measure") <- "scale"
  }

  # Step 4: Set -99 as missing values
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        chocolate = -99,
        fruity = -99,
        caramel = -99,
        peanutyalmondy = -99,
        nougat = -99,
        crispedricewafer = -99,
        hard = -99,
        bar = -99,
        pluribus = -99,
        sugarpercent = -99,
        pricepercent = -99,
        winpercent = -99
      )
  }

  df
}


# ---- Candy (simple) ---------------------------------------------------------

#' @noRd
label_candy_simple <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  # Step 2: Apply value labels
  df$chocolate <- labelled::labelled(df$chocolate, labels = c("No" = 0, "Yes" = 1))

  # Step 3: Apply variable labels
  labelled::var_label(df) <- list(
    competitorname = "The name of the candy",
    chocolate = "Does it contain chocolate?",
    sugarpercent = "The percentile of sugar it falls under within the data set",
    pricepercent = "The unit price percentile compared to the rest of the set",
    winpercent = "The overall win percentage according to 269,000 matchups"
  )

  # Set SPSS formats
  attr(df$chocolate, "format.spss") <- "F1.0"
  attr(df$chocolate, "spss_measure") <- "nominal"
  for (v in c("sugarpercent", "pricepercent", "winpercent")) {
    attr(df[[v]], "format.spss") <- "F8.6"
    attr(df[[v]], "spss_measure") <- "scale"
  }

  # Step 4: Set -99 as missing values
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        chocolate = -99,
        sugarpercent = -99,
        pricepercent = -99,
        winpercent = -99
      )
  }

  df
}


# ---- Football ---------------------------------------------------------------

#' @noRd
label_football <- function(df, use_sentinel = TRUE) {

  # Step 1: Replace NA with -99
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  # Step 2: Apply value labels
  df$group <- labelled::labelled(
    df$group,
    labels = c(
      "Control (no football)" = 1,
      "Football player, no concussions" = 2,
      "Football player with concussion history" = 3
    )
  )

  # Step 3: Apply variable labels
  labelled::var_label(df) <- list(
    group = "Group classification",
    years = "Number of years a person played football",
    volume = "Total hippocampus volume, in cubic centimeters"
  )

  # Step 4: Set -99 as missing values
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        group = -99,
        years = -99,
        volume = -99
      )
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
  df$gender <- labelled::labelled(df$gender, labels = c(Male = 1, Female = 2, Another = 3))
  df$sexorient <- labelled::labelled(df$sexorient,
                                     labels = c(Asexual = 1, Bisexual = 2, Demisexual = 3, Gay = 4,
                                                Lesbian = 5, Pansexual = 6, Queer = 7, Questioning = 8,
                                                `Sexually fluid` = 9, `Straight or heterosexual` = 10,
                                                Other = 11))
  df$race <- labelled::labelled(df$race,
                                labels = c(Asian = 1, Black = 2,
                                           `Indigenous, Aboriginal, or First Nations` = 3,
                                           `Latino or Hispanic` = 4, `Middle Eastern` = 5,
                                           White = 6, Other = 7))
  df$hand <- labelled::labelled(df$hand, labels = c(Right = 1, Left = 2, Both = 3))
  df$community <- labelled::labelled(df$community,
                                     labels = c(Rural = 1, `Small town` = 2, Suburban = 3, Urban = 4))
  df$parentedu <- labelled::labelled(df$parentedu, labels = c(No = 0, Yes = 1))
  df$famclass <- labelled::labelled(df$famclass,
                                    labels = c(`Working class` = 1, `Lower class` = 2, `Lower middle class` = 3,
                                               `Upper middle class` = 4, `Upper class` = 5))
  df$greek_in <- labelled::labelled(df$greek_in, labels = c(Independent = 1, Greek = 2))
  df$campus <- labelled::labelled(df$campus, labels = c(No = 0, Yes = 1))
  df$relsp <- labelled::labelled(df$relsp,
                                 labels = c("In a monogamous relationship" = 1,
                                            "In a polyamorous relationship" = 2,
                                            "In multiple relationships" = 3,
                                            "Not in a relationship" = 4,
                                            "I prefer not to answer" = 5))

  # Step 3: Apply variable labels
  labelled::var_label(df) <- list(
    age = "age",
    gender = "self-described gender",
    sexorient = "self-described sexual orientation and/or sexual identity",
    race = "self-described race",
    hand = "What hand do you use to write with?",
    community = "type of community where spent majority of childhood",
    parentedu = "did one or more of your parents graduate from a four-year college",
    famclass = "social class identity in childhood",
    faminc = "families' income during senior year in high school",
    numsib = "number of siblings",
    move = "number of times moved as child",
    clsfrn = "number of people you think of as a close friend",
    clsfrlst = "number of people think would list you as close friend",
    greek_in = "member of fraternity or sorority",
    campus = "living on campus during current semester",
    relsp = "currently in romantic relationship",
    rlength = "length of current or last relationship in months",
    serious = "rating seriousness of current or most recent relationship (0-7)",
    numrels = "number of dating relationships",
    gcb = "Generic Conspiracist Beliefs scale",
    datdaq = "dating subscale of the DAQ",
    assrtdaq = "assertiveness subscale of the DAQ",
    emorel = "emotional reliance on others subscale of the Interpersonal Dependency Inventory",
    lacksc = "lack of self-confidence subscale of the Interpersonal Dependency Inventory",
    auto = "assertion of autonomy subscale of the Interpersonal Dependency Inventory",
    perspec = "perspective-taking subscale of the Interpersonal Reactivity Index",
    fantasy = "fantasy subscale of the Interpersonal Reactivity Index",
    empath = "empathic concern subscale of the Interpersonal Reactivity Index",
    distress = "personal distress subscale of the Interpersonal Reactivity Index",
    polsoc = "political sociability subscale of Sociability Scale",
    npolsoc = "non-political sociability subscale of Sociability Scale",
    risc = "Relational-Interdependent Self-Construal Scale",
    lsas = "Liebowitz Social Anxiety Scale self-report total score (LSAS-SR)"
  )

  # Set SPSS formats
  nominal_vars <- c("gender", "sexorient", "race", "hand", "community",
                    "parentedu", "famclass", "greek_in", "campus", "relsp")
  for (var in nominal_vars) {
    attr(df[[var]], "format.spss") <- "F1.0"
    attr(df[[var]], "spss_measure") <- "nominal"
  }

  scale_vars <- c("age", "faminc", "numsib", "move", "clsfrn", "clsfrlst",
                  "rlength", "serious", "numrels", "gcb", "datdaq", "assrtdaq",
                  "emorel", "lacksc", "auto", "perspec", "fantasy", "empath",
                  "distress", "polsoc", "npolsoc", "risc", "lsas")
  for (var in scale_vars) {
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

  # Step 4: Set -99 as missing values
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        age = -99, gender = -99, sexorient = -99, race = -99, hand = -99,
        community = -99, parentedu = -99, famclass = -99, faminc = -99,
        numsib = -99, move = -99, clsfrn = -99, clsfrlst = -99, greek_in = -99,
        campus = -99, relsp = -99, rlength = -99, serious = -99, numrels = -99,
        gcb = -99, datdaq = -99, assrtdaq = -99, emorel = -99, lacksc = -99,
        auto = -99, perspec = -99, fantasy = -99, empath = -99, distress = -99,
        polsoc = -99, npolsoc = -99, risc = -99, lsas = -99
      )
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
  df$gender <- labelled::labelled(df$gender, labels = c(Male = 1, Female = 2, Another = 3))
  df$sexorient <- labelled::labelled(df$sexorient,
                                     labels = c(Asexual = 1, Bisexual = 2, Demisexual = 3, Gay = 4,
                                                Lesbian = 5, Pansexual = 6, Queer = 7, Questioning = 8,
                                                `Sexually fluid` = 9, `Straight or heterosexual` = 10,
                                                Other = 11))
  df$race <- labelled::labelled(df$race,
                                labels = c(Asian = 1, Black = 2,
                                           `Indigenous, Aboriginal, or First Nations` = 3,
                                           `Latino or Hispanic` = 4, `Middle Eastern` = 5,
                                           White = 6, Other = 7))
  df$hand <- labelled::labelled(df$hand, labels = c(Right = 1, Left = 2, Both = 3))
  df$community <- labelled::labelled(df$community,
                                     labels = c(Rural = 1, `Small town` = 2, Suburban = 3, Urban = 4))
  df$parentedu <- labelled::labelled(df$parentedu, labels = c(No = 0, Yes = 1))
  df$famclass <- labelled::labelled(df$famclass,
                                    labels = c(`Working class` = 1, `Lower class` = 2, `Lower middle class` = 3,
                                               `Upper middle class` = 4, `Upper class` = 5))
  df$greek_in <- labelled::labelled(df$greek_in, labels = c(Independent = 1, Greek = 2))
  df$campus <- labelled::labelled(df$campus, labels = c(No = 0, Yes = 1))
  df$relsp <- labelled::labelled(df$relsp,
                                 labels = c("In a monogamous relationship" = 1,
                                            "In a polyamorous relationship" = 2,
                                            "In multiple relationships" = 3,
                                            "Not in a relationship" = 4,
                                            "I prefer not to answer" = 5))

  # Step 3: Apply variable labels
  labelled::var_label(df) <- list(
    age = "age",
    gender = "self-described gender",
    sexorient = "self-described sexual orientation and/or sexual identity",
    race = "self-described race",
    hand = "What hand do you use to write with?",
    community = "type of community where spent majority of childhood",
    parentedu = "did one or more of your parents graduate from a four-year college",
    famclass = "social class identity in childhood",
    faminc = "families' income during senior year in high school",
    numsib = "number of siblings",
    move = "number of times moved as child",
    clsfrn = "number of people you think of as a close friend",
    clsfrlst = "number of people think would list you as close friend",
    greek_in = "member of fraternity or sorority",
    campus = "living on campus during current semester",
    relsp = "currently in romantic relationship",
    rlength = "length of current or last relationship in months",
    serious = "rating seriousness of current or most recent relationship (0-7)",
    numrels = "number of dating relationships",
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
  )

  # Set SPSS formats
  nominal_vars <- c("gender", "sexorient", "race", "hand", "community",
                    "parentedu", "famclass", "greek_in", "campus", "relsp")
  for (var in nominal_vars) {
    attr(df[[var]], "format.spss") <- "F1.0"
    attr(df[[var]], "spss_measure") <- "nominal"
  }

  scale_vars <- c("age", "faminc", "numsib", "move", "clsfrn", "clsfrlst",
                  "rlength", "serious", "numrels", "extraversion", "agreeableness",
                  "conscientiousness", "emot_stability", "openness",
                  "disc", "moral", "comp", "maas", "rse", "promote", "prevent",
                  "pmdc", "nsne", "lse", "help", "atq", "ngse")
  for (var in scale_vars) {
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

  # Step 4: Set -99 as missing values
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        age = -99, gender = -99, sexorient = -99, race = -99, hand = -99,
        community = -99, parentedu = -99, famclass = -99, faminc = -99,
        numsib = -99, move = -99, clsfrn = -99, clsfrlst = -99, greek_in = -99,
        campus = -99, relsp = -99, rlength = -99, serious = -99, numrels = -99,
        extraversion = -99, agreeableness = -99, conscientiousness = -99,
        emot_stability = -99, openness = -99, disc = -99, moral = -99,
        comp = -99, maas = -99, rse = -99, promote = -99, prevent = -99,
        pmdc = -99, nsne = -99, lse = -99, help = -99, atq = -99, ngse = -99
      )
  }

  df
}


# ---- Huskers ----------------------------------------------------------------

#' Apply SPSS labels to the huskers dataset
#'
#' @param df The huskers data frame.
#' @param use_sentinel If TRUE, replace NA with -99 and set as SPSS missing.
#' @return A labelled data frame ready for haven::write_sav().
# ---- Huskers ----------------------------------------------------------------

#' @noRd
label_huskers <- function(df, use_sentinel = TRUE) {

  # Step 1: Convert character categorical variables to numeric codes

  # site: home = 1, away = 2, neutral-home = 3, neutral-away = 4
  if (is.character(df$site)) {
    df$site <- dplyr::case_match(
      df$site,
      "home" ~ 1,
      "away" ~ 2,
      "neutral-home" ~ 3,
      "neutral-away" ~ 4,
      .default = NA_real_
    )
  }

  # result: W = 1, L = 2, T = 3
  if (is.character(df$result)) {
    df$result <- dplyr::case_match(
      df$result,
      "W" ~ 1,
      "L" ~ 2,
      "T" ~ 3,
      .default = NA_real_
    )
  }

  # conference: convert logical to integer
  if (is.logical(df$conference)) {
    df$conference <- as.integer(df$conference)
  }

  # Step 2: Replace NA with -99
  if (use_sentinel) {
    # Numeric columns
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
    # Character columns (like opp)
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.character),
                                  ~ifelse(is.na(.x) | .x == "", "-99", .x)))
  }

  # Step 3: Apply value labels
  df$result <- labelled::labelled(
    df$result,
    labels = c("Win" = 1, "Loss" = 2, "Tie" = 3)
  )

  df$site <- labelled::labelled(
    df$site,
    labels = c("Home" = 1, "Away" = 2, "Neutral (home)" = 3, "Neutral (away)" = 4)
  )

  df$conference <- labelled::labelled(
    df$conference,
    labels = c("Non-conference" = 0, "Conference game" = 1)
  )

  # Step 4: Apply variable labels
  labelled::var_label(df) <- list(
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
  )

  # Step 5: Set -99 as missing values
  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        site = -99,
        result = -99,
        season = -99,
        conference = -99,
        opp_rank = -99,
        ne_rank = -99,
        opp_score = -99,
        ne_score = -99,
        opp_score_q1 = -99,
        opp_score_q2 = -99,
        opp_score_q3 = -99,
        opp_score_q4 = -99,
        opp_score_ot = -99,
        ne_score_q1 = -99,
        ne_score_q2 = -99,
        ne_score_q3 = -99,
        ne_score_q4 = -99,
        ne_score_ot = -99,
        opp_rush_att = -99,
        opp_rush_yards = -99,
        ne_rush_att = -99,
        ne_rush_yards = -99,
        opp_pass_comp = -99,
        opp_pass_att = -99,
        opp_pass_yards = -99,
        ne_pass_comp = -99,
        ne_pass_att = -99,
        ne_pass_yards = -99,
        opp_first_downs = -99,
        ne_first_downs = -99,
        opp_third_down_comp = -99,
        opp_third_down_att = -99,
        ne_third_down_comp = -99,
        ne_third_down_att = -99,
        opp_fourth_down_comp = -99,
        opp_fourth_down_att = -99,
        ne_fourth_down_comp = -99,
        ne_fourth_down_att = -99,
        opp_int = -99,
        opp_fum = -99,
        ne_int = -99,
        ne_fum = -99,
        opp_pen_num = -99,
        opp_pen_yards = -99,
        ne_pen_num = -99,
        ne_pen_yards = -99,
        spread = -99,
        total = -99,
        temp = -99,
        humidity = -99,
        wind_speed = -99,
        wind_bearing = -99
      )
  }

  df
}
