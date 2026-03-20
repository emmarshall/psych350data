#' Interpersonal Relationships Survey Data
#'
#' Simulated survey data (n = 574) from college students at a predominantly white
#' rural state university, containing demographics, relationship variables, and
#' scores on several interpersonal and psychological scales including the DAQ,
#' Interpersonal Dependency Inventory, Interpersonal Reactivity Index,
#' Sociability Scale, RISC, GCB, and LSAS-SR.
#'
#' @format A tibble with 574 rows and 33 variables:
#' \describe{
#'   \item{age}{Age in years (18-25)}
#'   \item{gender}{Self-described gender: Male (1), Female (2), Another (3)}
#'   \item{sexorient}{Sexual orientation (1-11, see value labels)}
#'   \item{race}{Self-described race: Asian (1), Black (2), Indigenous/Aboriginal/First Nations (3), Latino/Hispanic (4), Middle Eastern (5), White (6), Other (7)}
#'   \item{hand}{Writing hand: Right (1), Left (2), Both (3)}
#'   \item{community}{Childhood community type: Rural (1), Small town (2), Suburban (3), Urban (4)}
#'   \item{parentedu}{Parent graduated from four-year college: No (0), Yes (1)}
#'   \item{famclass}{Childhood social class: Working class (1), Lower class (2), Lower middle class (3), Upper middle class (4), Upper class (5)}
#'   \item{faminc}{Family income during senior year of high school}
#'   \item{numsib}{Number of siblings}
#'   \item{move}{Number of times moved as a child}
#'   \item{clsfrn}{Number of close friends}
#'   \item{clsfrlst}{Number of people who would list you as a close friend}
#'   \item{greek_in}{Fraternity/sorority membership: Independent (1), Greek (2)}
#'   \item{campus}{Living on campus: No (0), Yes (1)}
#'   \item{relsp}{Romantic relationship status (1-5, see value labels)}
#'   \item{rlength}{Length of current or last relationship in months}
#'   \item{serious}{Seriousness rating of current/most recent relationship (1-7)}
#'   \item{numrels}{Number of dating relationships}
#'   \item{gcb}{Generic Conspiracist Beliefs scale score}
#'   \item{datdaq}{Dating subscale of the DAQ}
#'   \item{assrtdaq}{Assertiveness subscale of the DAQ}
#'   \item{emorel}{Emotional Reliance on Others subscale of the IDI}
#'   \item{lacksc}{Lack of Self-Confidence subscale of the IDI}
#'   \item{auto}{Assertion of Autonomy subscale of the IDI}
#'   \item{perspec}{Perspective-Taking subscale of the IRI}
#'   \item{fantasy}{Fantasy subscale of the IRI}
#'   \item{empath}{Empathic Concern subscale of the IRI}
#'   \item{distress}{Personal Distress subscale of the IRI}
#'   \item{polsoc}{Political Sociability subscale of Sociability Scale}
#'   \item{npolsoc}{Non-Political Sociability subscale of Sociability Scale}
#'   \item{risc}{Relational-Interdependent Self-Construal Scale score}
#'   \item{lsas}{Liebowitz Social Anxiety Scale self-report total (LSAS-SR)}
#' }
#'
#' @source Simulated data generated to resemble plausible survey responses
#'   from undergraduate psychology students.
"interpersonal_data"


#' Self-Descriptive Survey Data
#'
#' Simulated survey data (n = 547) from college students at a predominantly white
#' rural state university, containing demographics, relationship variables, and
#' scores on personality and self-concept measures including the TIPI Big Five,
#' MAAS, RFQ, ATQ-30, Rosenberg Self-Esteem, and New General Self-Efficacy scales.
#'
#' @format A tibble with 547 rows and 37 variables:
#' \describe{
#'   \item{age}{Age in years (18-25)}
#'   \item{gender}{Self-described gender: Male (1), Female (2), Another (3)}
#'   \item{sexorient}{Sexual orientation (1-11, see value labels)}
#'   \item{race}{Self-described race: Asian (1), Black (2), Indigenous/Aboriginal/First Nations (3), Latino/Hispanic (4), Middle Eastern (5), White (6), Other (7)}
#'   \item{hand}{Writing hand: Right (1), Left (2), Both (3)}
#'   \item{community}{Childhood community type: Rural (1), Small town (2), Suburban (3), Urban (4)}
#'   \item{parentedu}{Parent graduated from four-year college: No (0), Yes (1)}
#'   \item{famclass}{Childhood social class: Working class (1), Lower class (2), Lower middle class (3), Upper middle class (4), Upper class (5)}
#'   \item{faminc}{Family income during senior year of high school}
#'   \item{numsib}{Number of siblings}
#'   \item{move}{Number of times moved as a child}
#'   \item{clsfrn}{Number of close friends}
#'   \item{clsfrlst}{Number of people who would list you as a close friend}
#'   \item{greek_in}{Fraternity/sorority membership: Independent (1), Greek (2)}
#'   \item{campus}{Living on campus: No (0), Yes (1)}
#'   \item{relsp}{Romantic relationship status (1-5, see value labels)}
#'   \item{rlength}{Length of current or last relationship in months}
#'   \item{serious}{Seriousness rating of current/most recent relationship (1-7)}
#'   \item{numrels}{Number of dating relationships}
#'   \item{extraversion}{Extraversion subscale of the TIPI (1-7)}
#'   \item{agreeableness}{Agreeableness subscale of the TIPI (1-7)}
#'   \item{conscientiousness}{Conscientiousness subscale of the TIPI (1-7)}
#'   \item{emot_stability}{Emotional Stability subscale of the TIPI (1-7)}
#'   \item{openness}{Openness to Experience subscale of the TIPI (1-7)}
#'   \item{disc}{Discomfort with Ambiguity subscale of the MAAS}
#'   \item{moral}{Moral Absolutism/Splitting subscale of the MAAS}
#'   \item{comp}{Need for Complexity and Novelty subscale of the MAAS}
#'   \item{maas}{MAAS total score}
#'   \item{rse}{Rosenberg Self-Esteem scale score}
#'   \item{promote}{Promotion Focus subscale of the RFQ}
#'   \item{prevent}{Prevention Focus subscale of the RFQ}
#'   \item{atq}{Automatic Thoughts Questionnaire (ATQ-30) total score}
#'   \item{pmdc}{Personal Maladjustment and Desire for Change subscale of the ATQ}
#'   \item{nsne}{Negative Self-Concepts and Negative Expectations subscale of the ATQ}
#'   \item{lse}{Low Self-Esteem subscale of the ATQ}
#'   \item{help}{Helplessness subscale of the ATQ}
#'   \item{ngse}{New General Self-Efficacy scale score}
#' }
#'
#' @source Simulated data generated to resemble plausible survey responses
#'   from undergraduate psychology students.
"self_descriptive_data"


## Label functions!!

# ---- Interpersonal ----------------------------------------------------------

#' @noRd
label_interpersonal <- function(df, use_sentinel = TRUE) {

  # Step 1: Apply value labels (safe_labelled converts character -> numeric)
  # NOTE: sentinel NA replacement is deferred until after character columns
  #       are converted to numeric, so -99 is applied to all columns.
  df <- safe_labelled(df, "gender", c(Male = 1, Female = 2, Another = 3))
  df <- safe_labelled(df, "sexorient", c(
    Asexual = 1, Bisexual = 2, Demisexual = 3, Gay = 4,
    Lesbian = 5, Pansexual = 6, Queer = 7, Questioning = 8,
    `Sexually fluid` = 9, `Straight or heterosexual` = 10, Other = 11
  ))
  df <- safe_labelled(df, "race", c(
    Asian = 1, Black = 2, `Indigenous/Aboriginal/First Nations` = 3,
    `Latino/Hispanic` = 4, `Middle Eastern` = 5, White = 6, Other = 7
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

  # Step 2: Replace NA with -99 (after character -> numeric conversion)
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

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

  # Step 1: Apply value labels (safe_labelled converts character -> numeric)
  # NOTE: sentinel NA replacement is deferred until after character columns
  #       are converted to numeric, so -99 is applied to all columns.
  df <- safe_labelled(df, "gender", c(Male = 1, Female = 2, Another = 3))
  df <- safe_labelled(df, "sexorient", c(
    Asexual = 1, Bisexual = 2, Demisexual = 3, Gay = 4,
    Lesbian = 5, Pansexual = 6, Queer = 7, Questioning = 8,
    `Sexually fluid` = 9, `Straight or heterosexual` = 10, Other = 11
  ))
  df <- safe_labelled(df, "race", c(
    Asian = 1, Black = 2, `Indigenous/Aboriginal/First Nations` = 3,
    `Latino/Hispanic` = 4, `Middle Eastern` = 5, White = 6, Other = 7
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

  # Step 2: Replace NA with -99 (after character -> numeric conversion)
  if (use_sentinel) {
    df <- df |>
      dplyr::mutate(dplyr::across(dplyr::where(is.numeric),
                                  ~ifelse(is.na(.x), -99, .x)))
  }

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
