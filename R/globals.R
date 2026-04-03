#' @importFrom rlang :=
#' @importFrom utils data
NULL

# Suppress R CMD check NOTEs for column names used in dplyr/labelled pipelines
utils::globalVariables(c(
  # interpersonal + self_descriptive labels
  "age", "gender", "sexorient", "race", "hand", "community", "parentedu",
  "famclass", "faminc", "numsib", "move", "clsfrn", "clsfrlst", "greek_in",
  "campus", "relsp", "rlength", "serious", "numrels",
  "gcb", "datdaq", "assrtdaq", "emorel", "lacksc", "auto",
  "perspec", "fantasy", "empath", "distress", "polsoc", "npolsoc", "risc", "lsas",
  "extraversion", "agreeableness", "conscientiousness", "emot_stability", "openness",
  "disc", "moral", "comp", "maas", "rse", "promote", "prevent",
  "pmdc", "nsne", "lse", "help", "atq", "ngse",
  # superman_smes labels
  "num", "height_gap", "emotional_impact", "aesthetic_appeal", "cognitive_engagement", "emotion",
  # hotones labels
  "subn", "name", "occupation", "result", "appearances", "season",
  "SHU_1", "SHU_2", "SHU_3", "SHU_4", "SHU_5",
  "SHU_6", "SHU_7", "SHU_8", "SHU_9", "SHU_10",
  "views", "likes", "comments",
  # candy_simple labels
  "competitorname", "chocolate", "sugarpercent", "pricepercent", "winpercent",
  # join_superman_data / superman labels
  "clark_actor", "clark_height", "clark_height_in", "clark_age", "clark_grp",
  "lois_actor", "lois_height", "lois_height_in", "lois_age",
  "height_diff", "age_diff", "age_grp",
  "rt_critics_score", "rt_audience_score", "rt_avg", "tomatometer",
  "ldb_likes", "ldb_scores", "popular",
  # superman_movies labels
  "mpaa", "budget_cat", "box_office_cat", "budget2", "boxoffice2",
  # labelling function reference
  "label_superman_smes", "label_hindsight_mg", "prep_hindsight_mg",
"label_hotones", "label_hotones_episodes", "label_hotones_sauces"
))
