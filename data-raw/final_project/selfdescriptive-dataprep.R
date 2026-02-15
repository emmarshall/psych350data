#' Simulate Self-Descriptive Survey Data
#'
#' Generates a simulated dataset resembling survey responses from undergraduate
#' psychology students at a predominantly white rural state university. Includes
#' demographics, relationship variables, and scores on the TIPI Big Five, MAAS,
#' RFQ, ATQ-30, Rosenberg Self-Esteem, and New General Self-Efficacy scales.
#'
#' @param n Number of observations to simulate. Default is 547.
#' @param seed Random seed for reproducibility. Default is 123.
#'
#' @return A tibble with \code{n} rows and 37 variables with \code{NA} for
#'   missing values. Use \code{label_self_descriptive()} to apply SPSS labels
#'   and \code{haven::write_sav()} to export.
#'
#' @export
#'
#' @examples
#' dat <- simulate_self_descriptive(n = 100, seed = 123)
#' head(dat)
#'
#' # Export to SPSS:
#' # labelled_dat <- label_self_descriptive(dat)
#' # haven::write_sav(labelled_dat, "self_descriptive_data.sav")
simulate_self_descriptive <- function(n = 547, seed = 123) {
  set.seed(seed)

  # ============================================================
  # HELPER FUNCTIONS
  # ============================================================

  rmvnorm <- function(n, mu, Sigma) {
    p <- length(mu)
    Sigma <- (Sigma + t(Sigma)) / 2
    ev <- eigen(Sigma, symmetric = TRUE)
    ev$values[ev$values < 0] <- 0
    L <- chol(ev$vectors %*% diag(ev$values) %*% t(ev$vectors))
    Z <- matrix(stats::rnorm(n * p), nrow = n, ncol = p)
    sweep(Z %*% L, 2, mu, "+")
  }

  inject_na <- function(x, prop = 0.02) {
    idx <- sample(seq_along(x), size = round(prop * length(x)))
    x[idx] <- NA
    x
  }

  # ============================================================
  # STEP 1: GENERATE CORRELATED DEMOGRAPHICS
  # ============================================================

  # Race (predominantly white rural state university)
  race_vec <- sample(
    c("Asian", "Black", "Indigenous, Aboriginal, or First Nations",
      "Latino or Hispanic", "Middle Eastern", "White", "Other"),
    n, replace = TRUE,
    prob = c(0.04, 0.06, 0.03, 0.07, 0.01, 0.77, 0.02)
  )

  # Family class conditioned on race
  famclass_vec <- vapply(race_vec, function(r) {
    probs <- switch(r,
                    "White" = c(0.30, 0.02, 0.33, 0.32, 0.03),
                    "Black" = c(0.42, 0.05, 0.32, 0.19, 0.02),
                    "Latino or Hispanic" = c(0.40, 0.04, 0.34, 0.20, 0.02),
                    "Asian" = c(0.20, 0.02, 0.30, 0.42, 0.06),
                    "Indigenous, Aboriginal, or First Nations" = c(0.45, 0.06, 0.30, 0.17, 0.02),
                    "Middle Eastern" = c(0.22, 0.02, 0.30, 0.40, 0.06),
                    "Other" = c(0.33, 0.03, 0.34, 0.27, 0.03)
    )
    sample(c("Working class", "Lower class", "Lower middle class",
             "Upper middle class", "Upper class"), 1, prob = probs)
  }, character(1))

  # Parent education conditioned on famclass
  parentedu_vec <- vapply(famclass_vec, function(fc) {
    p_yes <- switch(fc,
                    "Lower class" = 0.15,
                    "Working class" = 0.28,
                    "Lower middle class" = 0.55,
                    "Upper middle class" = 0.78,
                    "Upper class" = 0.90
    )
    sample(c("No", "Yes"), 1, prob = c(1 - p_yes, p_yes))
  }, character(1))

  # Community conditioned on famclass
  community_vec <- vapply(famclass_vec, function(fc) {
    probs <- switch(fc,
                    "Lower class" = c(0.40, 0.25, 0.20, 0.15),
                    "Working class" = c(0.38, 0.20, 0.28, 0.14),
                    "Lower middle class" = c(0.28, 0.15, 0.38, 0.19),
                    "Upper middle class" = c(0.18, 0.10, 0.45, 0.27),
                    "Upper class" = c(0.10, 0.08, 0.42, 0.40)
    )
    sample(c("Rural", "Small town", "Suburban", "Urban"), 1, prob = probs)
  }, character(1))

  # Gender: Male=1, Female=2, Another=3
  gender_code_vec <- sample(1:3, n, replace = TRUE, prob = c(0.48, 0.50, 0.02))

  # Sexual orientation conditioned on gender
  sexorient_vec <- vapply(gender_code_vec, function(g) {
    probs <- if (g == 1) {
      # Male
      c(0.005, 0.02, 0.002, 0.03, 0.001, 0.008, 0.005, 0.005, 0.002, 0.92, 0.003)
    } else if (g == 2) {
      # Female
      c(0.01, 0.07, 0.008, 0.005, 0.03, 0.03, 0.015, 0.015, 0.008, 0.80, 0.01)
    } else {
      # Another gender
      c(0.05, 0.15, 0.05, 0.08, 0.08, 0.12, 0.10, 0.05, 0.05, 0.20, 0.07)
    }
    sample(c("Asexual", "Bisexual", "Demisexual", "Gay", "Lesbian", "Pansexual",
             "Queer", "Questioning", "Sexually fluid", "Straight or heterosexual",
             "Other"),
           1, prob = probs)
  }, character(1))

  # Age
  age_vec <- sample(18:25, n, replace = TRUE,
                    prob = c(0.15, 0.25, 0.25, 0.18, 0.10, 0.04, 0.02, 0.01))

  # Campus conditioned on age and community
  campus_vec <- vapply(seq_len(n), function(i) {
    base_p <- if (community_vec[i] %in% c("Rural", "Small town")) 0.35 else 0.55
    if (age_vec[i] >= 22) base_p <- base_p - 0.20
    if (age_vec[i] >= 24) base_p <- base_p - 0.15
    base_p <- max(0.05, min(0.85, base_p))
    sample(c("No", "Yes"), 1, prob = c(1 - base_p, base_p))
  }, character(1))

  # Greek life conditioned on race and famclass
  greek_in_vec <- vapply(seq_len(n), function(i) {
    base_p <- 0.25
    if (famclass_vec[i] %in% c("Upper middle class", "Upper class")) base_p <- base_p + 0.12
    if (famclass_vec[i] == "Lower class") base_p <- base_p - 0.10
    if (race_vec[i] == "White") base_p <- base_p + 0.05
    base_p <- max(0.05, min(0.55, base_p))
    sample(c("Independent", "Greek"), 1, prob = c(1 - base_p, base_p))
  }, character(1))

  # Number of siblings conditioned on famclass and community
  numsib_vec <- vapply(seq_len(n), function(i) {
    lam <- 2.0
    if (famclass_vec[i] %in% c("Working class", "Lower class")) lam <- lam + 0.5
    if (community_vec[i] == "Rural") lam <- lam + 0.3
    if (famclass_vec[i] %in% c("Upper middle class", "Upper class")) lam <- lam - 0.3
    min(6L, max(0L, stats::rpois(1, lambda = max(0.5, lam))))
  }, integer(1))

  # Number of moves conditioned on famclass and community
  move_vec <- vapply(seq_len(n), function(i) {
    lam <- 2.0
    if (community_vec[i] == "Rural") lam <- lam - 0.5
    if (famclass_vec[i] %in% c("Lower class", "Working class")) lam <- lam + 0.5
    if (famclass_vec[i] %in% c("Upper middle class", "Upper class")) lam <- lam + 0.3
    min(10L, max(0L, stats::rpois(1, lambda = max(0.5, lam))))
  }, integer(1))

  # Family income conditioned on famclass
  faminc_vec <- as.integer(dplyr::case_when(
    famclass_vec == "Lower class"        ~ round(stats::rnorm(n, mean = 20000, sd = 5000)) |> pmax(10000),
    famclass_vec == "Working class"      ~ round(stats::rnorm(n, mean = 35000, sd = 10000)) |> pmax(15000),
    famclass_vec == "Lower middle class" ~ round(stats::rnorm(n, mean = 60000, sd = 15000)) |> pmax(25000),
    famclass_vec == "Upper middle class" ~ round(stats::rnorm(n, mean = 120000, sd = 30000)) |> pmax(60000),
    famclass_vec == "Upper class" ~ ifelse(
      stats::runif(n) < 0.7,
      round(stats::rnorm(n, mean = 750000, sd = 150000)) |> pmax(500000) |> pmin(999999),
      round(stats::rlnorm(n, meanlog = 13.8, sdlog = 0.5)) |> pmax(1000000)
    ),
    TRUE ~ NA_real_
  ))

  # Handedness
  hand_vec <- sample(c("Right", "Left", "Both"),
                     n, replace = TRUE, prob = c(0.8, 0.15, 0.05))

  # ============================================================
  # STEP 2: RELATIONSHIP VARIABLES
  # ============================================================

  # Relationship status conditioned on age and greek
  relsp_vec <- vapply(seq_len(n), function(i) {
    p_mono   <- 0.42
    p_poly   <- 0.01
    p_mult   <- 0.05
    p_single <- 0.51
    p_pnta   <- 0.01

    if (age_vec[i] >= 21) {
      p_mono   <- p_mono + 0.08
      p_single <- p_single - 0.08
    }
    if (greek_in_vec[i] == "Greek") {
      p_mono   <- p_mono + 0.05
      p_single <- p_single - 0.05
    }

    probs <- pmax(0.005, c(p_mono, p_poly, p_mult, p_single, p_pnta))
    probs <- probs / sum(probs)

    sample(c("In a monogamous relationship",
             "In a polyamorous relationship (multiple relationships with the consent of participants)",
             "In multiple relationships (without those involved knowing about each other)",
             "Not in a relationship",
             "I prefer not to answer"),
           1, prob = probs)
  }, character(1))

  # Close friends conditioned on greek and campus
  clsfrn_vec <- vapply(seq_len(n), function(i) {
    lam <- 5.0
    if (greek_in_vec[i] == "Greek") lam <- lam + 1.5
    if (campus_vec[i] == "Yes") lam <- lam + 0.8
    min(20L, max(0L, stats::rpois(1, lambda = lam)))
  }, integer(1))

  # Close friends who'd list you (correlated with clsfrn)
  clsfrlst_vec <- vapply(seq_len(n), function(i) {
    lam <- max(1, clsfrn_vec[i] - stats::rpois(1, lambda = 1))
    min(20L, max(0L, stats::rpois(1, lambda = max(0.5, lam))))
  }, integer(1))

  # Relationship length
  rlength_vec <- as.integer(dplyr::case_when(
    relsp_vec == "In a monogamous relationship" ~ round(stats::rnorm(n, mean = 5, sd = 8)),
    relsp_vec == "In a polyamorous relationship (multiple relationships with the consent of participants)" ~ round(stats::rnorm(n, mean = 6, sd = 6)),
    relsp_vec == "In multiple relationships (without those involved knowing about each other)" ~ round(stats::rnorm(n, mean = 8, sd = 5)),
    relsp_vec == "Not in a relationship" ~ round(stats::rnorm(n, mean = 3, sd = 5)),
    TRUE ~ 0
  ) |> pmax(1) |> pmin(60))

  # Seriousness of relationship
  serious_vec <- as.integer(dplyr::case_when(
    relsp_vec == "In a monogamous relationship" ~
      sample(1:7, n, replace = TRUE, prob = c(0.05, 0.1, 0.15, 0.2, 0.2, 0.15, 0.15)),
    relsp_vec == "In a polyamorous relationship (multiple relationships with the consent of participants)" ~
      sample(1:7, n, replace = TRUE, prob = c(0.1, 0.15, 0.2, 0.2, 0.15, 0.1, 0.1)),
    relsp_vec == "In multiple relationships (without those involved knowing about each other)" ~
      sample(1:7, n, replace = TRUE, prob = c(0.2, 0.2, 0.2, 0.15, 0.1, 0.1, 0.05)),
    TRUE ~ NA_real_
  ))

  # Number of relationships
  numrels_vec <- as.integer(dplyr::case_when(
    relsp_vec == "In a monogamous relationship" ~
      pmax(1, stats::rbinom(n, size = 10, prob = 0.3)),
    relsp_vec == "In a polyamorous relationship (multiple relationships with the consent of participants)" ~
      pmax(2, stats::rpois(n, lambda = 3)),
    relsp_vec == "In multiple relationships (without those involved knowing about each other)" ~
      pmax(2, stats::rpois(n, lambda = 4)),
    relsp_vec == "Not in a relationship" ~
      sample(0:10, n, replace = TRUE, prob = c(0.7, rep(0.03, 10))),
    relsp_vec == "I prefer not to answer" ~
      sample(0:10, n, replace = TRUE, prob = c(0.7, rep(0.03, 10))),
    TRUE ~ 0
  ) |> pmin(10))

  # ============================================================
  # STEP 3: SELF-ESTEEM AND SELF-EFFICACY
  # ============================================================

  rse_vec  <- round(pmax(5, pmin(40, stats::rnorm(n, mean = 28.2, sd = 5.8))), 2)
  ngse_vec <- round(pmax(10, pmin(40, stats::rnorm(n, mean = 30.35, sd = 3.32))), 2)

  # ============================================================
  # STEP 4: TIPI BIG FIVE
  # ============================================================

  tipi_means <- c(4.44, 5.23, 5.40, 4.83, 5.38)
  tipi_sds   <- c(1.45, 1.11, 1.11, 1.42, 1.07)

  tipi_cor <- matrix(c(
    1.00,  0.12,  0.17,  0.24,  0.22,
    0.12,  1.00,  0.27,  0.30,  0.15,
    0.17,  0.27,  1.00,  0.24,  0.02,
    0.24,  0.30,  0.24,  1.00,  0.17,
    0.22,  0.15,  0.02,  0.17,  1.00
  ), nrow = 5, byrow = TRUE)

  tipi_cov <- diag(tipi_sds) %*% tipi_cor %*% diag(tipi_sds)
  tipi_raw <- rmvnorm(n = n, mu = tipi_means, Sigma = tipi_cov)

  # Round to nearest 0.5 for TIPI scale
  tipi_raw <- round(tipi_raw * 2) / 2
  tipi_raw[tipi_raw < 1] <- 1
  tipi_raw[tipi_raw > 7] <- 7

  extraversion      <- tipi_raw[, 1]
  agreeableness     <- tipi_raw[, 2]
  conscientiousness <- tipi_raw[, 3]
  emot_stability    <- tipi_raw[, 4]
  openness          <- tipi_raw[, 5]

  # ============================================================
  # STEP 5: MAAS (CONDITIONED ON BIG FIVE)
  # ============================================================

  full_cor <- matrix(c(
    1.00,  0.35,  0.14, -0.22,  0.29, -0.16, -0.08, -0.02,
    0.35,  1.00,  0.05,  0.02,  0.03, -0.12,  0.04, -0.04,
    0.14,  0.05,  1.00,  0.20, -0.04,  0.35,  0.13,  0.10,
    -0.22,  0.02,  0.20,  1.00, -0.28,  0.29,  0.29,  0.20,
    0.29,  0.03, -0.04, -0.28,  1.00, -0.17, -0.34, -0.29,
    -0.16, -0.12,  0.35,  0.29, -0.17,  1.00,  0.22,  0.14,
    -0.08,  0.04,  0.13,  0.29, -0.34,  0.22,  1.00,  0.36,
    -0.02, -0.04,  0.10,  0.20, -0.29,  0.14,  0.36,  1.00
  ), nrow = 8, byrow = TRUE)

  full_means <- c(3.88, 3.45, 4.58, 3.30, 3.00, 3.74, 3.80, 3.70)
  full_sds   <- c(1.18, 1.38, 1.05, 0.73, 0.73, 0.62, 0.64, 0.60)
  full_cov   <- diag(full_sds) %*% full_cor %*% diag(full_sds)

  S11 <- full_cov[1:3, 1:3]
  S12 <- full_cov[1:3, 4:8]
  S21 <- full_cov[4:8, 1:3]
  S22 <- full_cov[4:8, 4:8]
  S22_inv <- solve(S22)

  # Scale TIPI (1-7) to match the MAAS conditioning scale (1-5)
  bf_scaled <- (cbind(extraversion, agreeableness, conscientiousness,
                      emot_stability, openness) - 1) * (4 / 6) + 1

  # Reorder to match full_cor columns 4-8:
  # [extraversion, neuroticism(reversed emot_stab), openness, conscientiousness, agreeableness]
  bf_for_cond <- cbind(
    bf_scaled[, 1],          # extraversion
    6 - bf_scaled[, 4],      # neuroticism (reversed emotional stability)
    bf_scaled[, 5],          # openness
    bf_scaled[, 3],          # conscientiousness
    bf_scaled[, 2]           # agreeableness
  )

  mu_new <- full_means[1:3]
  mu_bf  <- full_means[4:8]

  Sigma_cond <- S11 - S12 %*% S22_inv %*% S21
  Sigma_cond <- (Sigma_cond + t(Sigma_cond)) / 2

  deviations <- sweep(bf_for_cond, 2, mu_bf)
  cond_means <- sweep(deviations %*% S22_inv %*% S21, 2, mu_new, "+")
  new_vars   <- cond_means + rmvnorm(n = n, mu = c(0, 0, 0), Sigma = Sigma_cond)

  disc  <- round(new_vars[, 1], 2)
  moral <- round(new_vars[, 2], 2)
  comp  <- round(new_vars[, 3], 2)
  maas  <- round((disc + moral + comp) / 3, 2)

  # ============================================================
  # STEP 6: RFQ (CONDITIONED ON BIG FIVE)
  # ============================================================

  # Correlation: [promote, prevent, extra, consc, emot_stab, agree, open]
  rfq_cor <- matrix(c(
    1.00,  0.10,  0.28,  0.18,  0.20,  0.08,  0.22,
    0.10,  1.00,  0.05,  0.30,  0.15,  0.25,  0.02,
    0.28,  0.05,  1.00,  0.17,  0.24,  0.12,  0.22,
    0.18,  0.30,  0.17,  1.00,  0.24,  0.27,  0.02,
    0.20,  0.15,  0.24,  0.24,  1.00,  0.30,  0.17,
    0.08,  0.25,  0.12,  0.27,  0.30,  1.00,  0.15,
    0.22,  0.02,  0.22,  0.02,  0.17,  0.15,  1.00
  ), nrow = 7, byrow = TRUE)

  rfq_means <- c(3.60, 3.75, 4.44, 5.40, 4.83, 5.23, 5.38)
  rfq_sds   <- c(0.68, 0.72, 1.45, 1.11, 1.42, 1.11, 1.07)
  rfq_cov   <- diag(rfq_sds) %*% rfq_cor %*% diag(rfq_sds)

  R11 <- rfq_cov[1:2, 1:2]
  R12 <- rfq_cov[1:2, 3:7]
  R22 <- rfq_cov[3:7, 3:7]
  R22_inv <- solve(R22)

  Sigma_rfq_cond <- R11 - R12 %*% R22_inv %*% t(R12)
  Sigma_rfq_cond <- (Sigma_rfq_cond + t(Sigma_rfq_cond)) / 2

  bf_obs_rfq <- cbind(
    as.numeric(extraversion),
    as.numeric(conscientiousness),
    as.numeric(emot_stability),
    as.numeric(agreeableness),
    as.numeric(openness)
  )

  mu_rfq_new <- rfq_means[1:2]
  mu_rfq_bf  <- rfq_means[3:7]

  deviations_rfq <- sweep(bf_obs_rfq, 2, mu_rfq_bf)
  cond_means_rfq <- sweep(deviations_rfq %*% R22_inv %*% t(R12), 2, mu_rfq_new, "+")
  rfq_raw <- cond_means_rfq + rmvnorm(n = n, mu = c(0, 0), Sigma = Sigma_rfq_cond)

  rfq_raw[rfq_raw < 1] <- 1
  rfq_raw[rfq_raw > 5] <- 5

  promote <- round(rfq_raw[, 1], 2)
  prevent <- round(rfq_raw[, 2], 2)

  # ============================================================
  # STEP 7: ATQ-30 (CONDITIONED ON NEUROTICISM & NGSE)
  # ============================================================

  atq_cor <- matrix(c(
    # pmdc   nsne   lse    help   neuro  ngse
    1.00,  0.75,  0.70,  0.72,  0.45, -0.55,
    0.75,  1.00,  0.72,  0.70,  0.48, -0.58,
    0.70,  0.72,  1.00,  0.68,  0.42, -0.60,
    0.72,  0.70,  0.68,  1.00,  0.46, -0.52,
    0.45,  0.48,  0.42,  0.46,  1.00, -0.55,
    -0.55, -0.58, -0.60, -0.52, -0.55,  1.00
  ), nrow = 6, byrow = TRUE)

  atq_means <- c(2.10, 1.85, 1.70, 1.90, 3.00, 30.35)
  atq_sds   <- c(0.65, 0.60, 0.55, 0.62, 0.73,  3.32)
  atq_cov   <- diag(atq_sds) %*% atq_cor %*% diag(atq_sds)

  A11 <- atq_cov[1:4, 1:4]
  A12 <- atq_cov[1:4, 5:6]
  A22 <- atq_cov[5:6, 5:6]
  A22_inv <- solve(A22)

  Sigma_atq_cond <- A11 - A12 %*% A22_inv %*% t(A12)
  Sigma_atq_cond <- (Sigma_atq_cond + t(Sigma_atq_cond)) / 2

  # Convert emotional stability to neuroticism on 1-5 scale
  es_scaled <- (as.numeric(emot_stability) - 1) * (4 / 6) + 1
  neuroticism_scaled <- 6 - es_scaled
  ngse_obs <- as.numeric(ngse_vec)

  obs_atq <- cbind(neuroticism_scaled, ngse_obs)
  mu_atq_new <- atq_means[1:4]
  mu_obs_atq <- atq_means[5:6]

  deviations_atq <- sweep(obs_atq, 2, mu_obs_atq)
  cond_means_atq <- sweep(deviations_atq %*% A22_inv %*% t(A12), 2, mu_atq_new, "+")
  atq_raw <- cond_means_atq + rmvnorm(n = n, mu = c(0, 0, 0, 0), Sigma = Sigma_atq_cond)

  atq_raw[atq_raw < 1] <- 1
  atq_raw[atq_raw > 5] <- 5

  pmdc_val <- round(atq_raw[, 1], 2)
  nsne_val <- round(atq_raw[, 2], 2)
  lse_val  <- round(atq_raw[, 3], 2)
  help_val <- round(atq_raw[, 4], 2)

  # ATQ total: weighted sum of subscale means * number of items per subscale
  atq_total <- as.integer(round(pmdc_val * 9 + nsne_val * 8 + lse_val * 5 + help_val * 8))
  atq_total <- pmax(30L, pmin(150L, atq_total))

  # ============================================================
  # STEP 8: ENCODE CATEGORICAL TO NUMERIC
  # ============================================================

  sexorient_num <- dplyr::case_when(
    sexorient_vec == "Asexual" ~ 1L,
    sexorient_vec == "Bisexual" ~ 2L,
    sexorient_vec == "Demisexual" ~ 3L,
    sexorient_vec == "Gay" ~ 4L,
    sexorient_vec == "Lesbian" ~ 5L,
    sexorient_vec == "Pansexual" ~ 6L,
    sexorient_vec == "Queer" ~ 7L,
    sexorient_vec == "Questioning" ~ 8L,
    sexorient_vec == "Sexually fluid" ~ 9L,
    sexorient_vec == "Straight or heterosexual" ~ 10L,
    sexorient_vec == "Other" ~ 11L
  )

  race_code <- dplyr::case_when(
    race_vec == "Asian" ~ 1L,
    race_vec == "Black" ~ 2L,
    race_vec == "Indigenous, Aboriginal, or First Nations" ~ 3L,
    race_vec == "Latino or Hispanic" ~ 4L,
    race_vec == "Middle Eastern" ~ 5L,
    race_vec == "White" ~ 6L,
    race_vec == "Other" ~ 7L
  )

  hand_code <- dplyr::case_when(
    hand_vec == "Right" ~ 1L,
    hand_vec == "Left" ~ 2L,
    hand_vec == "Both" ~ 3L
  )

  community_code <- dplyr::case_when(
    community_vec == "Rural" ~ 1L,
    community_vec == "Small town" ~ 2L,
    community_vec == "Suburban" ~ 3L,
    community_vec == "Urban" ~ 4L
  )

  parentedu_code <- dplyr::case_when(
    parentedu_vec == "No" ~ 0L,
    parentedu_vec == "Yes" ~ 1L
  )

  famclass_code <- dplyr::case_when(
    famclass_vec == "Working class" ~ 1L,
    famclass_vec == "Lower class" ~ 2L,
    famclass_vec == "Lower middle class" ~ 3L,
    famclass_vec == "Upper middle class" ~ 4L,
    famclass_vec == "Upper class" ~ 5L
  )

  greek_in_code <- dplyr::case_when(
    greek_in_vec == "Independent" ~ 1L,
    greek_in_vec == "Greek" ~ 2L
  )

  campus_code <- dplyr::case_when(
    campus_vec == "No" ~ 0L,
    campus_vec == "Yes" ~ 1L
  )

  relsp_code <- dplyr::case_when(
    relsp_vec == "In a monogamous relationship" ~ 1L,
    relsp_vec == "In a polyamorous relationship (multiple relationships with the consent of participants)" ~ 2L,
    relsp_vec == "In multiple relationships (without those involved knowing about each other)" ~ 3L,
    relsp_vec == "Not in a relationship" ~ 4L,
    relsp_vec == "I prefer not to answer" ~ 5L
  )

  # ============================================================
  # STEP 9: ASSEMBLE TIBBLE
  # ============================================================

  dat <- tibble::tibble(
    age               = as.integer(age_vec),
    gender            = gender_code_vec,
    sexorient         = sexorient_num,
    race              = race_code,
    hand              = hand_code,
    community         = community_code,
    parentedu         = parentedu_code,
    famclass          = famclass_code,
    faminc            = faminc_vec,
    numsib            = numsib_vec,
    move              = move_vec,
    clsfrn            = clsfrn_vec,
    clsfrlst          = clsfrlst_vec,
    greek_in          = greek_in_code,
    campus            = campus_code,
    relsp             = relsp_code,
    rlength           = rlength_vec,
    serious           = serious_vec,
    numrels           = numrels_vec,
    extraversion      = extraversion,
    agreeableness     = agreeableness,
    conscientiousness = conscientiousness,
    emot_stability    = emot_stability,
    openness          = openness,
    disc              = disc,
    moral             = moral,
    comp              = comp,
    maas              = maas,
    rse               = rse_vec,
    promote           = promote,
    prevent           = prevent,
    atq               = atq_total,
    pmdc              = pmdc_val,
    nsne              = nsne_val,
    lse               = lse_val,
    help              = help_val,
    ngse              = ngse_vec
  )

  # ============================================================
  # # Make ~2% of data MISSING VALUES (NA) use labelling function to set to -99 for spss .sav
  # ============================================================

  dat <- dat |>
    dplyr::mutate(dplyr::across(dplyr::everything(), inject_na))

  dat
}

## code to prepare `self_descriptive_data` dataset
# devtools::load_all() first so simulate_self_descriptive() is available
self_descriptive_data <- simulate_self_descriptive(n = 547, seed = 123)

usethis::use_data(self_descriptive_data, overwrite = TRUE)
