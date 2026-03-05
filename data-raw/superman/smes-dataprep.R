# ============================================================================
# Superman SMES Data (Simulated)
# ============================================================================
library(dplyr)
library(usethis)
library(here)

load(here::here("data", "superman.rda"))

set.seed(47474)

# Pull height_gap and convert strings to numeric codes
height_gap_numeric <- superman |>
  filter(!is.na(height_gap)) |>
  pull(height_gap) |>
  (\(x) dplyr::case_match(x,
                          "Minimal" ~ 1L,
                          "Average" ~ 2L,
                          "Big"     ~ 3L
  ))()

target_n <- 47

height_gap_sample <- sample(height_gap_numeric, target_n, replace = TRUE)

# Helper to introduce < 1% missingness (1 NA per continuous variable)
add_missing <- function(x, n = 1) {
  idx <- sample(seq_along(x), n)
  x[idx] <- NA
  x
}

superman_smes <- tibble::tibble(
  num        = 1:target_n,
  height_gap = height_gap_sample,
  emotional_impact = add_missing(sapply(height_gap_sample, function(gap) {
    mu <- c(11, 12, 14)[gap]
    pmin(pmax(round(rnorm(1, mu, 3)), 4), 20)
  })),
  aesthetic_appeal = add_missing(sapply(height_gap_sample, function(gap) {
    mu <- c(9, 9.5, 10)[gap]
    pmin(pmax(round(rnorm(1, mu, 2.5)), 3), 15)
  })),
  cognitive_engagement = add_missing(sapply(height_gap_sample, function(gap) {
    mu <- c(3.8, 4.0, 4.5)[gap]
    pmin(pmax(round(rnorm(1, mu, 1.2), 1), 0), 7)
  }))
)

usethis::use_data(superman_smes, overwrite = TRUE)
cat("Created: superman_smes\n")
