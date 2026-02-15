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
  "num", "height_gap", "emotional_impact", "aesthetic_appeal", "cognitive_engagement",
  # hot_ones labels
  "subn", "name", "occupation", "result", "appearances", "season",
  "SHU_1", "SHU_2", "SHU_3", "SHU_4", "SHU_5",
  "SHU_6", "SHU_7", "SHU_8", "SHU_9", "SHU_10",
  "views", "likes", "comments",
  # candy_simple labels
  "competitorname", "chocolate", "sugarpercent", "pricepercent", "winpercent"
))
