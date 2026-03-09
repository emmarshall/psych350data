# ============================================================================
# Hindsight Bias Data (Simulated)
# Two datasets:
#   hindsight_mg_data  - between-groups long format (for BG ANOVA)
#   hindsight_wg_data  - within-groups wide format (for WG ANOVA)
# ============================================================================

library(dplyr)
library(tidyr)
library(purrr)
library(usethis)
library(here)

set.seed(4747)

# ── Parameters ────────────────────────────────────────────────────────────────

n_participants     <- 60  # n=30 per cond
n_faces_per_phase  <- 10
n_famous           <- 5
n_mod_famous       <- 5

# ── Base data structures ──────────────────────────────────────────────────────

participants <- tibble(
  participant_id = 1:n_participants,
  condition      = rep(c(1L, 2L), each = n_participants / 2)  # 1 = Old, 2 = New
)

faces <- tibble(
  face_id    = 1:n_faces_per_phase,
  fame_level = c(rep(1L, n_famous), rep(2L, n_mod_famous))  # 1 = Extremely, 2 = Moderately
)

# ── Trial simulation ──────────────────────────────────────────────────────────

simulate_trial <- function(fame_level, phase, condition) {
  base_score <- ifelse(fame_level == 1L, 8, 30) + rnorm(1, 0, 2)

  if (phase == 2L) {
    fame_adj      <- ifelse(fame_level == 1L, 0.8, 1.5)
    condition_adj <- ifelse(condition  == 1L, 2.5, 1.5)  # Old = more hindsight shift
    base_score    <- base_score - fame_adj - condition_adj - rnorm(1, 0, 0.5)
  }

  correct_prob <- ifelse(fame_level == 1L, 0.80, 0.70)
  correct      <- rbinom(1, 1, correct_prob)

  list(score = base_score, correct = correct)
}

# ── Generate long data across both phases ─────────────────────────────────────

all_data <- map_df(1:2, \(phase) {
  crossing(participants, faces) |>
    mutate(
      trial_results = pmap(list(fame_level, phase, condition), simulate_trial),
      score         = map_dbl(trial_results, "score"),
      correct       = map_int(trial_results, "correct"),
      phase         = phase
    ) |>
    select(-trial_results)
})

# ── Pivot to wide (one row per participant x face) ────────────────────────────

all_data <- all_data |>
  pivot_wider(
    id_cols     = c(participant_id, face_id, condition, fame_level),
    names_from  = phase,
    values_from = c(score, correct),
    names_glue  = "{.value}_{phase}"
  ) |>
  # Use phase 1 correctness as the single correct indicator
  mutate(correct = correct_1) |>
  select(-correct_1, -correct_2)

# ── BG dataset: numeric codes ready for labelling ────────────────────────────

hindsight_mg_data <- all_data |>
  mutate(
    participant_id = as.integer(participant_id),
    face_id        = as.integer(face_id),
    condition      = as.integer(condition),
    fame_level     = as.integer(fame_level),
    score_1        = as.numeric(score_1),
    score_2        = as.numeric(score_2),
    correct        = as.integer(correct)
  )

# ── WG dataset: one row per participant, averaged by fame level ───────────────

hindsight_wg_data <- all_data |>
  summarise(
    avg_score_1 = mean(score_1),
    avg_score_2 = mean(score_2),
    .by = c(participant_id, condition, fame_level)
  ) |>
  pivot_wider(
    names_from  = fame_level,
    values_from = c(avg_score_1, avg_score_2),
    names_glue  = "{.value}_{fame_level}"
  ) |>
  rename(
    EXTREMEavg_1  = avg_score_1_1,
    MODERATEavg_1 = avg_score_1_2,
    EXTREMEavg_2  = avg_score_2_1,
    MODERATEavg_2 = avg_score_2_2
  ) |>
  mutate(
    participant_id = as.integer(participant_id),
    condition      = as.integer(condition)
  ) |>
  arrange(participant_id)

# ── Save ──────────────────────────────────────────────────────────────────────

usethis::use_data(hindsight_mg_data, overwrite = TRUE)
usethis::use_data(hindsight_wg_data, overwrite = TRUE)

cat("Created: hindsight_mg_data\n")
cat("Created: hindsight_wg_data\n")
