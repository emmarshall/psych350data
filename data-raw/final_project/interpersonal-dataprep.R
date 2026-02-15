#' Simulate Interpersonal Relationships Survey Data
#'
#' Generates a simulated dataset resembling survey responses from undergraduate
#' psychology students at a predominantly white rural state university. Includes
#' demographics, relationship variables, and scores on the DAQ, IDI, IRI,
#' Sociability Scale, RISC, GCB, and LSAS-SR.
#'
#' @param n Number of observations to simulate. Default is 574.
#' @param seed Random seed for reproducibility. Default is 147.
#'
#' @return A tibble with \code{n} rows and 33 variables with \code{NA} for
#'   missing values. Use \code{label_interpersonal()} to apply SPSS labels
#'   and \code{haven::write_sav()} to export.
#'
#' @export
#'
#' @examples
#' dat <- simulate_interpersonal(n = 100, seed = 147)
#' head(dat)
#'
#' # Export to SPSS:
#' # labelled_dat <- label_interpersonal(dat)
#' # haven::write_sav(labelled_dat, "interpersonal_data.sav")
simulate_interpersonal <- function(n = 574, seed = 147) {
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
    } else if (g == 3) {
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
  # STEP 3: SCALE/SUBSCALE VARIABLES
  # ============================================================

  # DAQ subscales
  datdaq   <- as.integer(round(pmax(15, pmin(100, stats::rnorm(n, mean = 45, sd = 12)))))
  assrtdaq <- as.integer(round(pmax(15, pmin(100, stats::rnorm(n, mean = 50, sd = 11)))))

  # IDI subscales (correlated)
  idi_sds <- c(7, 6, 7)
  idi_cor <- matrix(c(
    1.00,  0.45, -0.30,
    0.45,  1.00, -0.35,
    -0.30, -0.35,  1.00
  ), nrow = 3, byrow = TRUE)
  idi_cov <- diag(idi_sds) %*% idi_cor %*% diag(idi_sds)
  idi_raw <- rmvnorm(n, c(35, 30, 40), idi_cov)

  emorel <- as.integer(round(pmax(10, pmin(60, idi_raw[, 1]))))
  lacksc <- as.integer(round(pmax(10, pmin(60, idi_raw[, 2]))))
  auto   <- as.integer(round(pmax(10, pmin(60, idi_raw[, 3]))))

  # IRI subscales (correlated)
  iri_sds <- c(4.5, 5.5, 4.0, 5.0)
  iri_cor <- matrix(c(
    1.00,  0.12,  0.30, -0.25,
    0.12,  1.00,  0.30,  0.15,
    0.30,  0.30,  1.00, -0.05,
    -0.25,  0.15, -0.05,  1.00
  ), nrow = 4, byrow = TRUE)
  iri_cov <- diag(iri_sds) %*% iri_cor %*% diag(iri_sds)
  iri_raw <- rmvnorm(n, c(17.5, 16.5, 20.0, 11.5), iri_cov)

  perspec  <- as.integer(round(pmax(0, pmin(28, iri_raw[, 1]))))
  fantasy  <- as.integer(round(pmax(0, pmin(28, iri_raw[, 2]))))
  empath   <- as.integer(round(pmax(0, pmin(28, iri_raw[, 3]))))
  distress <- as.integer(round(pmax(0, pmin(28, iri_raw[, 4]))))

  # Sociability subscales (correlated)
  soc_sds <- c(4.5, 3.8)
  soc_cor <- matrix(c(1.0, 0.35, 0.35, 1.0), nrow = 2)
  soc_cov <- diag(soc_sds) %*% soc_cor %*% diag(soc_sds)
  soc_raw <- rmvnorm(n, c(15.2, 20.0), soc_cov)

  polsoc  <- as.integer(round(pmax(4, pmin(28, soc_raw[, 1]))))
  npolsoc <- as.integer(round(pmax(4, pmin(28, soc_raw[, 2]))))

  # RISC (conditioned on empathy and perspective-taking)
  risc_base <- stats::rnorm(n, mean = 4.8, sd = 0.9) +
    0.02 * (empath - 20.0) +
    0.01 * (perspec - 17.5)
  risc <- round(pmax(1, pmin(7, risc_base)), 2)

  # GCB
  gcb <- round(pmax(1, pmin(5, stats::rnorm(n, mean = 2.44, sd = 1.00))), 2)

  # LSAS-SR (conditioned on distress, lacksc, datdaq, npolsoc)
  lsas_base <- stats::rnorm(n, mean = 40, sd = 16) +
    0.35 * (distress - 11.5) +
    0.30 * (lacksc - 30) -
    0.20 * (datdaq - 45) -
    0.15 * (npolsoc - 20)
  lsas <- as.integer(round(pmax(24, pmin(96, lsas_base))))

  # ============================================================
  # STEP 4: ENCODE CATEGORICAL TO NUMERIC
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
  # STEP 5: ASSEMBLE TIBBLE
  # ============================================================

  dat <- tibble::tibble(
    age      = as.integer(age_vec),
    gender   = gender_code_vec,
    sexorient = sexorient_num,
    race     = race_code,
    hand     = hand_code,
    community = community_code,
    parentedu = parentedu_code,
    famclass = famclass_code,
    faminc   = faminc_vec,
    numsib   = numsib_vec,
    move     = move_vec,
    clsfrn   = clsfrn_vec,
    clsfrlst = clsfrlst_vec,
    greek_in = greek_in_code,
    campus   = campus_code,
    relsp    = relsp_code,
    rlength  = rlength_vec,
    serious  = serious_vec,
    numrels  = numrels_vec,
    gcb      = gcb,
    datdaq   = datdaq,
    assrtdaq = assrtdaq,
    emorel   = emorel,
    lacksc   = lacksc,
    auto     = auto,
    perspec  = perspec,
    fantasy  = fantasy,
    empath   = empath,
    distress = distress,
    polsoc   = polsoc,
    npolsoc  = npolsoc,
    risc     = risc,
    lsas     = lsas
  )

# ============================================================
  # Make ~2% of data MISSING VALUES (NA) use labelling function to set to -99 for spss .sav
# ============================================================

  dat <- dat |>
    dplyr::mutate(dplyr::across(dplyr::everything(), inject_na))

  dat
}

## code to prepare `interpersonal_data` dataset
# devtools::load_all() first so simulate_interpersonal() is available
interpersonal_data <- simulate_interpersonal(n = 574, seed = 147)
usethis::use_data(interpersonal_data, overwrite = TRUE)
