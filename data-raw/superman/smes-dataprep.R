# ============================================================================
# Superman SMES Data (Simulated)
# ============================================================================
library(dplyr)
library(usethis)
library(here)

load(here::here("data", "superman.rda"))

set.seed(47474)

# Pull both height_gap and age_grp together (preserving natural co-occurrence)
# Use base R match() to convert character levels to numeric codes
level_map <- c("Minimal" = 1L, "Average" = 2L, "Big" = 3L)

grouping_data <- superman |>
  filter(!is.na(height_gap), !is.na(age_grp)) |>
  mutate(
    hg_num = level_map[height_gap],
    ag_num = level_map[age_grp]
  ) |>
  select(hg_num, ag_num)

target_n <- 47

# Sample rows together so height_gap and age_grp maintain their relationship
sampled_rows <- grouping_data[sample(nrow(grouping_data), target_n, replace = TRUE), ]
height_gap_sample <- sampled_rows$hg_num
age_grp_sample <- sampled_rows$ag_num

# Helper to introduce < 1% missingness (1 NA per continuous variable)
add_missing <- function(x, n = 1) {
  idx <- sample(seq_along(x), n)
  x[idx] <- NA
  x
}

# Generate continuous variables first
emo_raw <- sapply(height_gap_sample, function(gap) {
  mu <- c(11, 12, 14)[gap]
  pmin(pmax(round(rnorm(1, mu, 3)), 4), 20)
})

aes_raw <- sapply(height_gap_sample, function(gap) {
  mu <- c(9, 9.5, 10)[gap]
  pmin(pmax(round(rnorm(1, mu, 2.5)), 3), 15)
})

cog_raw <- sapply(height_gap_sample, function(gap) {
  mu <- c(3.8, 4.0, 4.5)[gap]
  pmin(pmax(round(rnorm(1, mu, 1.2), 1), 0), 7)
})

# Generate emotion category correlated with emotional_impact and aesthetic_appeal
# Higher emo/aes scores -> more likely joy(2); lower -> more likely fear(1)/sadness(3)
emotion_raw <- sapply(seq_len(target_n), function(i) {
  # Combine emotional_impact (rescaled 0-1) and aesthetic_appeal (rescaled 0-1)
  emo_z <- (emo_raw[i] - 4) / 16     # rescale to 0-1
  aes_z <- (aes_raw[i] - 3) / 12     # rescale to 0-1
  combo <- 0.6 * emo_z + 0.4 * aes_z # weighted composite
  # Map composite to emotion probabilities
  # High combo -> joy(2), moderate -> anxiety(6)/anger(4), low -> fear(1)/sadness(3)/disgust(5)
  probs <- if (combo > 0.65) {
    c(0.05, 0.50, 0.05, 0.10, 0.05, 0.25)  # mostly joy
  } else if (combo > 0.40) {
    c(0.10, 0.25, 0.10, 0.20, 0.10, 0.25)  # mixed
  } else {
    c(0.30, 0.05, 0.25, 0.15, 0.15, 0.10)  # mostly fear/sadness
  }
  sample(1:6, 1, prob = probs)
})

superman_smes <- tibble::tibble(
  num                  = 1:target_n,
  height_gap           = height_gap_sample,
  age_grp              = age_grp_sample,
  emotional_impact     = add_missing(emo_raw),
  aesthetic_appeal      = add_missing(aes_raw),
  cognitive_engagement = add_missing(cog_raw),
  emotion              = emotion_raw
)

usethis::use_data(superman_smes, overwrite = TRUE)
cat("Created: superman_smes\n")
