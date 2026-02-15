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

  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  df$media <- labelled::labelled(
    df$media,
    labels = c(
      "Superman 2025" = 1,
      "Superman: The Movie" = 2,
      "Smallville" = 3,
      "Superman Returns" = 4,
      "Superman & the Mole Men" = 5,
      "Man of Steel" = 6,
      "Superman" = 7,
      "Superman & Lois" = 8,
      "Lois & Clark: The New Adventures of Superman" = 9,
      "The Adventures of Superboy" = 10
    )
  )

  df$type <- labelled::labelled(
    df$type,
    labels = c("Film" = 1, "TV Series" = 2, "Serial" = 3)
  )

  df$clark_grp <- labelled::labelled(
    df$clark_grp,
    labels = c(
      "under 6ft tall (<72 inches)" = 1,
      "over 6ft tall (\u226572 inches)" = 2
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

  df$height_gap <- labelled::labelled(
    df$height_gap,
    labels = c(
      "minimal (< 6 inches)" = 1,
      "average (6-8 inches)" = 2,
      "big (> 8 inches)" = 3
    )
  )

  labelled::var_label(df) <- list(
    num = "Unique number for each actor in dataset",
    media = "title of media where actor made their first appearance as Clark Kent/Superman",
    year = "Year of release",
    type = "Type of media",
    clark_height = "Height of Clark Kent/Superman actor in meters",
    lois_height = "Height of Lois Lane actor in meters",
    clark_height_in = "Height of Clark Kent/Superman actor in inches",
    lois_height_in = "Height of Lois Lane actor in inches",
    clark_grp = "Whether Clark Kent/Superman actor is taller than 6ft",
    height_diff = "Height difference between Clark Kent/Superman and Lois Lane actors in inches",
    height_gap = "Relative size of height gap between actors (minimal/average/big)",
    rt_critics_score = "Rotten Tomatoes critics score (0-100 scale)",
    rt_critic_count = "Number of critic reviews on Rotten Tomatoes",
    rt_audience_score = "Rotten Tomatoes audience score (0-100 scale)",
    rt_audience_count = "Number of audience ratings on Rotten Tomatoes",
    ldb_likes = "Total number of users that liked the film on Letterboxd",
    ldb_scores = "Letterboxd users average rating (1-5 stars)",
    tomatometer = "whether the media was liked by more than 60% of critics on Rotten Tomatoes",
    rt_avg = "average number of critics and audience members that liked the media on Rotten Tomatoes",
    rt_diff = "weighted difference between number of critics and audience members that liked the media on Rotten Tomatoes",
    popular = "Popularity based on number of user likes on Letterboxd (low/mid/high)"
  )

  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        clark_height = -99,
        lois_height = -99,
        clark_height_in = -99,
        lois_height_in = -99,
        clark_grp = -99,
        height_diff = -99,
        height_gap = -99,
        rt_critics_score = -99,
        rt_critic_count = -99,
        rt_audience_score = -99,
        rt_audience_count = -99,
        ldb_likes = -99,
        ldb_scores = -99,
        tomatometer = -99,
        rt_avg = -99,
        rt_diff = -99,
        popular = -99
      )
  }

  df
}


# ---- Superman SMES ---------------------------------------------------------

#' @noRd
label_superman_smes <- function(df, use_sentinel = TRUE) {

  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  df <- df |>
    dplyr::mutate(
      num = labelled::labelled(num, label = "Unique number for each participant"),
      height_gap = labelled::labelled(
        height_gap,
        label = "Relative size of height gap between actors",
        labels = c(
          "Minimal (< 6 inches)" = 1,
          "Average (6-8 inches)" = 2,
          "Big (> 8 inches)" = 3
        )
      ),
      emotional_impact = labelled::labelled(
        emotional_impact,
        label = "Emotional Impact Subscale of SMES\nsum of 4-items (1-5 scale)"
      ),
      aesthetic_appeal = labelled::labelled(
        aesthetic_appeal,
        label = "Aesthetic Appeal Subscale of SMES\nsum of 3-items (1-5 scale)"
      ),
      cognitive_engagement = labelled::labelled(
        cognitive_engagement,
        label = "Cognitive Engagement Subscale of SMES\naverage of 4-items (0-7 scale)"
      )
    )

  if (use_sentinel) {
    df <- df |>
      labelled::set_na_values(
        num = -99,
        height_gap = -99,
        emotional_impact = -99,
        aesthetic_appeal = -99,
        cognitive_engagement = -99
      )
  }

  df
}


# ---- Hot Ones ---------------------------------------------------------------

#' @noRd
label_hot_ones <- function(df, use_sentinel = TRUE) {

  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  df <- df |>
    dplyr::mutate(
      subn = labelled::labelled(subn, label = "Unique number for each guest/participant"),
      name = labelled::labelled(name, label = "Guest Full Name"),
      gender = labelled::labelled(
        gender,
        label = "Guest Gender",
        labels = c("Male" = 1, "Female" = 2)
      ),
      age = labelled::labelled(age, label = "Guest Age"),
      occupation = labelled::labelled(
        occupation,
        label = "Guest's primary occupation",
        labels = c(
          "Rapper" = 1, "Athlete" = 2, "Actor" = 3, "Actor-Comedian" = 4,
          "Comedian" = 5, "Chef" = 6, "Actor-Musician" = 7, "Musician" = 8,
          "DJ" = 9, "YouTuber" = 10, "Model" = 11, "Wrestler" = 12,
          "Magician" = 13, "Other" = 14
        )
      ),
      result = labelled::labelled(
        result,
        label = "Whether the guest finished all the wings or quit (wall of flame)",
        labels = c("Succeeded" = 1, "Failed" = 2)
      ),
      appearances = labelled::labelled(appearances, label = "Number of appearances on Hot Ones"),
      season = labelled::labelled(season, label = "Season of Hot Ones"),
      order = labelled::labelled(order, label = "Episode number within Season of Hot Ones"),
      SHU_1 = labelled::labelled(SHU_1, label = "Sauce #1 rating in Scoville Heat Units (SHU)"),
      SHU_2 = labelled::labelled(SHU_2, label = "Sauce #2 rating in Scoville Heat Units (SHU)"),
      SHU_3 = labelled::labelled(SHU_3, label = "Sauce #3 rating in Scoville Heat Units (SHU)"),
      SHU_4 = labelled::labelled(SHU_4, label = "Sauce #4 rating in Scoville Heat Units (SHU)"),
      SHU_5 = labelled::labelled(SHU_5, label = "Sauce #5 rating in Scoville Heat Units (SHU)"),
      SHU_6 = labelled::labelled(SHU_6, label = "Sauce #6 rating in Scoville Heat Units (SHU)"),
      SHU_7 = labelled::labelled(SHU_7, label = "Sauce #7 rating in Scoville Heat Units (SHU)"),
      SHU_8 = labelled::labelled(SHU_8, label = "Sauce #8 rating in Scoville Heat Units (SHU)"),
      SHU_9 = labelled::labelled(SHU_9, label = "Sauce #9 rating in Scoville Heat Units (SHU)"),
      SHU_10 = labelled::labelled(SHU_10, label = "Sauce #10 rating in Scoville Heat Units (SHU)"),
      views = labelled::labelled(views, label = "Number of times video has been viewed on Youtube (in millions)"),
      likes = labelled::labelled(likes, label = "Number of times video has been liked on Youtube"),
      comments = labelled::labelled(comments, label = "Number of comments on video on Youtube")
    )

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

  df$card <- labelled::labelled(
    df$card,
    labels = c("Advertisement card" = 1, "Joke card" = 2, "No card" = 3),
    label = "Type of card used by waiter"
  )

  df$tip <- labelled::labelled(
    as.numeric(df$tip),
    labels = c("No tip" = 0, "Customer left a tip" = 1),
    label = "Whether customer left a tip"
  )

  df$ad <- labelled::labelled(
    as.numeric(df$ad),
    labels = c("No ad card" = 0, "Ad card left" = 1),
    label = "Indicator for Ad card (1=ad card left, 0=no ad card)"
  )

  df$joke <- labelled::labelled(
    as.numeric(df$joke),
    labels = c("No joke card" = 0, "Joke card left" = 1),
    label = "Indicator for Joke card (1=joke card left, 0=no joke card)"
  )

  df$none <- labelled::labelled(
    as.numeric(df$none),
    labels = c("Ad or joke card left" = 0, "No card left" = 1),
    label = "Indicator for no card (1=no card left, 0=ad or joke card left)"
  )

  df
}


# ---- MCU --------------------------------------------------------------------

#' @noRd
label_mcu <- function(df, use_sentinel = TRUE) {

  df$length_hrs <- as.numeric(df$length_hrs)
  df$length_min <- as.numeric(df$length_min)
  df$opening_weekend_us <- as.numeric(df$opening_weekend_us)
  df$gross_us <- as.numeric(df$gross_us)
  df$gross_world <- as.numeric(df$gross_world)
  df$critics <- as.numeric(df$critics)
  df$audience <- as.numeric(df$audience)

  labelled::var_label(df$movie) <- "Title of the movie"
  labelled::var_label(df$length_hrs) <- "Length of the movie: hours portion"
  labelled::var_label(df$length_min) <- "Length of the movie: minutes portion"
  labelled::var_label(df$release_date) <- "Date the movie was released in the US"
  labelled::var_label(df$opening_weekend_us) <- "Box office totals for opening weekend in the US (not adjusted for inflation)"
  labelled::var_label(df$gross_us) <- "All box office totals in US (not adjusted for inflation)"
  labelled::var_label(df$gross_world) <- "All box office totals world wide (not adjusted for inflation)"
  labelled::var_label(df$critics) <- "Rotten Tomatoes critics score (0-100 scale)"
  labelled::var_label(df$audience) <- "Rotten Tomatoes audience score (0-100 scale)"

  df$phase <- labelled::labelled(
    as.numeric(df$phase),
    labels = c("Phase 1" = 1, "Phase 2" = 2, "Phase 3" = 3),
    label = "Designated phase of the Marvel Cinematic Universe (Phase 1, Phase 2, Phase 3)"
  )

  df$favor <- labelled::labelled(
    as.numeric(df$favor),
    labels = c("critics" = 1, "audience" = 2),
    label = "Whether critics or audience score is higher on Rotten Tomatoes (critics=1; audience=2)"
  )

  df
}


# ---- Mock Jury --------------------------------------------------------------

#' @noRd
label_mock_jury <- function(df, use_sentinel = TRUE) {

  df$attr <- labelled::labelled(
    df$attr,
    labels = c("Beautiful" = 1, "Average" = 2, "Unattractive" = 3),
    label = "Attractiveness of the photo"
  )

  df$crime <- labelled::labelled(
    df$crime,
    labels = c(
      "Burglary (theft of items from victim's room)" = 1,
      "Swindle (conned a male victim)" = 2
    ),
    label = "Type of crime"
  )

  labelled::var_label(df$years) <- "Length of sentence given the defendant by the mock juror subject (in years)"
  labelled::var_label(df$serious) <- "A rating of how serious the subject thought the defendant's crime was"
  labelled::var_label(df$exciting) <- "Rating of the photo for 'exciting'"
  labelled::var_label(df$calm) <- "Rating of the photo for 'calm'"
  labelled::var_label(df$independent) <- "Rating of the photo for 'independent'"
  labelled::var_label(df$sincere) <- "Rating of the photo for 'sincere'"
  labelled::var_label(df$warm) <- "Rating of the photo for 'warm'"
  labelled::var_label(df$phyattr) <- "Rating of the photo for 'physical attractiveness'"
  labelled::var_label(df$sociable) <- "Rating of the photo for 'sociable'"
  labelled::var_label(df$kind) <- "Rating of the photo for 'kind'"
  labelled::var_label(df$intelligent) <- "Rating of the photo for 'intelligent'"
  labelled::var_label(df$strong) <- "Rating of the photo for 'strong'"
  labelled::var_label(df$sophisticated) <- "Rating of the photo for 'sophisticated'"
  labelled::var_label(df$happy) <- "Rating of the photo for 'happy'"
  labelled::var_label(df$ownPA) <- "Self-rating of the subject for 'physical attractiveness'"

  df
}


# ---- Candy (full) -----------------------------------------------------------

#' @noRd
label_candy <- function(df, use_sentinel = TRUE) {

  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  labelled::var_label(df$competitorname) <- "The name of the candy"

  df$chocolate <- labelled::labelled(df$chocolate,
                                     label = "Does it contain chocolate?", labels = c("No" = 0, "Yes" = 1))
  df$fruity <- labelled::labelled(df$fruity,
                                  label = "Is it fruit flavored?", labels = c("No" = 0, "Yes" = 1))
  df$caramel <- labelled::labelled(df$caramel,
                                   label = "Is there caramel in the candy?", labels = c("No" = 0, "Yes" = 1))
  df$peanutyalmondy <- labelled::labelled(df$peanutyalmondy,
                                          label = "Does it contain peanuts, peanut butter or almonds?", labels = c("No" = 0, "Yes" = 1))
  df$nougat <- labelled::labelled(df$nougat,
                                  label = "Does it contain nougat?", labels = c("No" = 0, "Yes" = 1))
  df$crispedricewafer <- labelled::labelled(df$crispedricewafer,
                                            label = "Does it contain crisped rice, wafers, or a cookie component?", labels = c("No" = 0, "Yes" = 1))
  df$hard <- labelled::labelled(df$hard,
                                label = "Is it a hard candy?", labels = c("No" = 0, "Yes" = 1))
  df$bar <- labelled::labelled(df$bar,
                               label = "Is it a candy bar?", labels = c("No" = 0, "Yes" = 1))
  df$pluribus <- labelled::labelled(df$pluribus,
                                    label = "Is it one of many candies in a bag or box?", labels = c("No" = 0, "Yes" = 1))

  labelled::var_label(df$sugarpercent) <- "The percentile of sugar it falls under within the data set"
  labelled::var_label(df$pricepercent) <- "The unit price percentile compared to the rest of the set"
  labelled::var_label(df$winpercent) <- "The overall win percentage according to 269,000 matchups"

  binary_vars <- c("chocolate", "fruity", "caramel", "peanutyalmondy",
                   "nougat", "crispedricewafer", "hard", "bar", "pluribus")

  for (v in binary_vars) {
    attr(df[[v]], "format.spss") <- "F1.0"
    attr(df[[v]], "spss_measure") <- "nominal"
    attr(df[[v]], "na_values") <- -99
  }
  for (v in c("sugarpercent", "pricepercent", "winpercent")) {
    attr(df[[v]], "format.spss") <- "F8.6"
    attr(df[[v]], "spss_measure") <- "scale"
    attr(df[[v]], "na_values") <- -99
  }

  df
}


# ---- Candy (simple) ---------------------------------------------------------

#' @noRd
label_candy_simple <- function(df, use_sentinel = TRUE) {

  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(
        dplyr::across(dplyr::where(is.numeric), ~ifelse(is.na(.x), -99, .x)),
        dplyr::across(dplyr::where(is.character),
                      ~ifelse(is.na(.) | . == "", "-99", .))
      )
  }

  df <- df |>
    dplyr::mutate(
      competitorname = labelled::labelled(competitorname, label = "The name of the candy"),
      chocolate = labelled::labelled(
        chocolate,
        label = "Does it contain chocolate?",
        labels = c("No" = 0, "Yes" = 1)
      ),
      sugarpercent = labelled::labelled(
        sugarpercent,
        label = "The percentile of sugar it falls under within the data set"
      ),
      pricepercent = labelled::labelled(
        pricepercent,
        label = "The unit price percentile compared to the rest of the set"
      ),
      winpercent = labelled::labelled(
        winpercent,
        label = "The overall win percentage according to 269,000 matchups"
      )
    )

  attr(df$chocolate, "format.spss") <- "F1.0"
  attr(df$chocolate, "na_values") <- -99
  attr(df$chocolate, "spss_measure") <- "nominal"

  for (v in c("sugarpercent", "pricepercent", "winpercent")) {
    attr(df[[v]], "format.spss") <- "F8.6"
    attr(df[[v]], "na_values") <- -99
    attr(df[[v]], "spss_measure") <- "scale"
  }

  df
}


# ---- Football ---------------------------------------------------------------

#' @noRd
label_football <- function(df, use_sentinel = TRUE) {

  df$group <- labelled::labelled(
    df$group,
    labels = c(
      "Control (no football)" = 1,
      "Football player, no concussions" = 2,
      "Football player with concussion history" = 3
    ),
    label = "Group classification"
  )

  labelled::var_label(df$years) <- "Number of years a person played football"
  labelled::var_label(df$volume) <- "Total hippocampus volume, in cubic centimeters"

  df
}

# ---- Interpersonal ----------------------------------------------------------

#' @noRd
label_interpersonal <- function(df, use_sentinel = TRUE) {

  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  df <- df |>
    dplyr::mutate(
      age = labelled::labelled(age, label = "age"),
      gender = labelled::labelled(gender, label = "self-described gender",
                                  labels = c(Male = 1, Female = 2, Another = 3, Missing = -99)),
      sexorient = labelled::labelled(sexorient,
                                     label = "self-described sexual orientation and/or sexual identity",
                                     labels = c(Asexual = 1, Bisexual = 2, Demisexual = 3, Gay = 4,
                                                Lesbian = 5, Pansexual = 6, Queer = 7, Questioning = 8,
                                                `Sexually fluid` = 9, `Straight or heterosexual` = 10,
                                                Other = 11, Missing = -99)),
      race = labelled::labelled(race, label = "self-described race",
                                labels = c(Asian = 1, Black = 2,
                                           `Indigenous, Aboriginal, or First Nations` = 3,
                                           `Latino or Hispanic` = 4, `Middle Eastern` = 5,
                                           White = 6, Other = 7, Missing = -99)),
      hand = labelled::labelled(hand,
                                label = "What hand do you use to write with?",
                                labels = c(Right = 1, Left = 2, Both = 3, Missing = -99)),
      community = labelled::labelled(community,
                                     label = "type of community where spent majority of childhood",
                                     labels = c(Rural = 1, `Small town` = 2, Suburban = 3, Urban = 4, Missing = -99)),
      parentedu = labelled::labelled(parentedu,
                                     label = "did one or more of your parents graduate from a four-year college",
                                     labels = c(No = 0, Yes = 1, Missing = -99)),
      famclass = labelled::labelled(famclass,
                                    label = "social class identity in childhood",
                                    labels = c(`Working class` = 1, `Lower class` = 2, `Lower middle class` = 3,
                                               `Upper middle class` = 4, `Upper class` = 5, Missing = -99)),
      faminc = labelled::labelled(faminc, label = "families' income during senior year in high school"),
      numsib = labelled::labelled(numsib, label = "number of siblings"),
      move = labelled::labelled(move, label = "number of times moved as child"),
      clsfrn = labelled::labelled(clsfrn, label = "number of people you think of as a close friend"),
      clsfrlst = labelled::labelled(clsfrlst, label = "number of people think would list you as close friend"),
      greek_in = labelled::labelled(greek_in, label = "member of fraternity or sorority",
                                    labels = c(Independent = 1, Greek = 2, Missing = -99)),
      campus = labelled::labelled(campus, label = "living on campus during current semester",
                                  labels = c(No = 0, Yes = 1, Missing = -99)),
      relsp = labelled::labelled(relsp, label = "currently in romantic relationship",
                                 labels = c("In a monogamous relationship" = 1,
                                            "In a polyamorous relationship (multiple relationships with the consent of participants)" = 2,
                                            "In multiple relationships (without those involved knowing about each other)" = 3,
                                            "Not in a relationship" = 4, "I prefer not to answer" = 5, Missing = -99)),
      rlength = labelled::labelled(rlength, label = "length of current or last relationship in months"),
      serious = labelled::labelled(serious, label = "rating seriousness of current or most recent relationship (0-7)"),
      numrels = labelled::labelled(numrels, label = "number of dating relationships"),
      gcb = labelled::labelled(gcb, label = "Generic Conspiracist Beliefs scale"),
      datdaq = labelled::labelled(datdaq, label = "dating subscale of the DAQ"),
      assrtdaq = labelled::labelled(assrtdaq, label = "assertiveness subscale of the DAQ"),
      emorel = labelled::labelled(emorel, label = "emotional reliance on others subscale of the Interpersonal Dependency Inventory"),
      lacksc = labelled::labelled(lacksc, label = "lack of self-confidence subscale of the Interpersonal Dependency Inventory"),
      auto = labelled::labelled(auto, label = "assertion of autonomy subscale of the Interpersonal Dependency Inventory"),
      perspec = labelled::labelled(perspec, label = "perspective-taking subscale of the Interpersonal Reactivity Index"),
      fantasy = labelled::labelled(fantasy, label = "fantasy subscale of the Interpersonal Reactivity Index"),
      empath = labelled::labelled(empath, label = "empathic concern subscale of the Interpersonal Reactivity Index"),
      distress = labelled::labelled(distress, label = "personal distress subscale of the Interpersonal Reactivity Index"),
      polsoc = labelled::labelled(polsoc, label = "political sociability subscale of Sociability Scale"),
      npolsoc = labelled::labelled(npolsoc, label = "non-political sociability subscale of Sociability Scale"),
      risc = labelled::labelled(risc, label = "Relational-Interdependent Self-Construal Scale"),
      lsas = labelled::labelled(lsas, label = "Liebowitz Social Anxiety Scale self-report total score (LSAS-SR)")
    )

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

  if (use_sentinel) {
    for (var in names(df)[sapply(df, is.numeric)]) {
      if (-99 %in% df[[var]]) attr(df[[var]], "na_values") <- -99
    }
  }

  df
}


# ---- Self-Descriptive -------------------------------------------------------

#' @noRd
label_self_descriptive <- function(df, use_sentinel = TRUE) {

  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

  df <- df |>
    dplyr::mutate(
      age = labelled::labelled(age, label = "age"),
      gender = labelled::labelled(gender, label = "self-described gender",
                                  labels = c(Male = 1, Female = 2, Another = 3, Missing = -99)),
      sexorient = labelled::labelled(sexorient,
                                     label = "self-described sexual orientation and/or sexual identity",
                                     labels = c(Asexual = 1, Bisexual = 2, Demisexual = 3, Gay = 4,
                                                Lesbian = 5, Pansexual = 6, Queer = 7, Questioning = 8,
                                                `Sexually fluid` = 9, `Straight or heterosexual` = 10,
                                                Other = 11, Missing = -99)),
      race = labelled::labelled(race, label = "self-described race",
                                labels = c(Asian = 1, Black = 2,
                                           `Indigenous, Aboriginal, or First Nations` = 3,
                                           `Latino or Hispanic` = 4, `Middle Eastern` = 5,
                                           White = 6, Other = 7, Missing = -99)),
      hand = labelled::labelled(hand,
                                label = "What hand do you use to write with?",
                                labels = c(Right = 1, Left = 2, Both = 3, Missing = -99)),
      community = labelled::labelled(community,
                                     label = "type of community where spent majority of childhood",
                                     labels = c(Rural = 1, `Small town` = 2, Suburban = 3, Urban = 4, Missing = -99)),
      parentedu = labelled::labelled(parentedu,
                                     label = "did one or more of your parents graduate from a four-year college",
                                     labels = c(No = 0, Yes = 1, Missing = -99)),
      famclass = labelled::labelled(famclass,
                                    label = "social class identity in childhood",
                                    labels = c(`Working class` = 1, `Lower class` = 2, `Lower middle class` = 3,
                                               `Upper middle class` = 4, `Upper class` = 5, Missing = -99)),
      faminc = labelled::labelled(faminc, label = "families' income during senior year in high school"),
      numsib = labelled::labelled(numsib, label = "number of siblings"),
      move = labelled::labelled(move, label = "number of times moved as child"),
      clsfrn = labelled::labelled(clsfrn, label = "number of people you think of as a close friend"),
      clsfrlst = labelled::labelled(clsfrlst, label = "number of people think would list you as close friend"),
      greek_in = labelled::labelled(greek_in, label = "member of fraternity or sorority",
                                    labels = c(Independent = 1, Greek = 2, Missing = -99)),
      campus = labelled::labelled(campus, label = "living on campus during current semester",
                                  labels = c(No = 0, Yes = 1, Missing = -99)),
      relsp = labelled::labelled(relsp, label = "currently in romantic relationship",
                                 labels = c("In a monogamous relationship" = 1,
                                            "In a polyamorous relationship (multiple relationships with the consent of participants)" = 2,
                                            "In multiple relationships (without those involved knowing about each other)" = 3,
                                            "Not in a relationship" = 4, "I prefer not to answer" = 5, Missing = -99)),
      rlength = labelled::labelled(rlength, label = "length of current or last relationship in months"),
      serious = labelled::labelled(serious, label = "rating seriousness of current or most recent relationship (0-7)"),
      numrels = labelled::labelled(numrels, label = "number of dating relationships"),
      extraversion = labelled::labelled(extraversion, label = "Extraversion subscale (TIPI)"),
      agreeableness = labelled::labelled(agreeableness, label = "Agreeableness subscale (TIPI)"),
      conscientiousness = labelled::labelled(conscientiousness, label = "Conscientiousness subscale (TIPI)"),
      emot_stability = labelled::labelled(emot_stability, label = "Emotional Stability subscale (TIPI)"),
      openness = labelled::labelled(openness, label = "Openness to Experience subscale (TIPI)"),
      disc = labelled::labelled(disc, label = "Discomfort with Ambiguity subscale (MAAS)"),
      moral = labelled::labelled(moral, label = "Moral Absolutism/Splitting subscale (MAAS)"),
      comp = labelled::labelled(comp, label = "Need for Complexity and Novelty subscale (MAAS)"),
      maas = labelled::labelled(maas, label = "Multidimensional Attitude towards Ambiguity Scale (MAAS) total"),
      rse = labelled::labelled(rse, label = "Rosenberg Self-Esteem scale"),
      promote = labelled::labelled(promote, label = "Promotion Focus subscale (RFQ)"),
      prevent = labelled::labelled(prevent, label = "Prevention Focus subscale (RFQ)"),
      pmdc = labelled::labelled(pmdc, label = "Personal Maladjustment & Desire for Change subscale (ATQ)"),
      nsne = labelled::labelled(nsne, label = "Negative Self-Concepts & Negative Expectations subscale (ATQ)"),
      lse = labelled::labelled(lse, label = "Low Self-Esteem subscale (ATQ)"),
      help = labelled::labelled(help, label = "Helplessness subscale (ATQ)"),
      atq = labelled::labelled(atq, label = "Automatic Thoughts Questionnaire (ATQ-30) total"),
      ngse = labelled::labelled(ngse, label = "New general self-efficacy scale")
    )

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

  if (use_sentinel) {
    for (var in names(df)[sapply(df, is.numeric)]) {
      if (-99 %in% df[[var]]) attr(df[[var]], "na_values") <- -99
    }
  }

  df
}
