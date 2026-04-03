# ============================================================================
# Parent Child Study Data (Simulated)
# Based on a parent-child observation study with treatment and remediation groups
# ============================================================================

library(dplyr)
library(usethis)
library(here)

set.seed(47474)

n <- 147

# ── Helper functions ─────────────────────────────────────────────────────────

add_missing <- function(x, n = 1) {
  idx <- sample(seq_along(x), n)
  x[idx] <- NA
  x
}

clamp <- function(x, lo, hi) pmin(pmax(x, lo), hi)

# ── Categorical variables (drawn from realistic marginal proportions) ─────────

# magegroup: 1 = 18-27, 2 = 28-35
magegroup <- sample(1:2, n, replace = TRUE, prob = c(0.45, 0.55))

# cagegroup: 1 = 2-3 yrs, 2 = 4-5 yrs
cagegroup <- sample(1:2, n, replace = TRUE, prob = c(0.50, 0.50))

# famtype: 1 = 2-parent, 2 = mother-only
famtype <- sample(1:2, n, replace = TRUE, prob = c(0.60, 0.40))

# CLINREM: 0 = suggested remediation, 1 = no remediation
CLINREM <- sample(0:1, n, replace = TRUE, prob = c(0.35, 0.65))

# tx: 0 = no remediation (control), 1 = remediation (treatment)
tx <- sample(0:1, n, replace = TRUE, prob = c(0.50, 0.50))

# ── Continuous variables (group-differentiated means) ────────────────────────

# mage: continuous version of magegroup
mage <- ifelse(
  magegroup == 1,
  clamp(round(rnorm(n, 23, 2.5)), 18, 27),
  clamp(round(rnorm(n, 31, 2.0)), 28, 35)
)

# cage: continuous version of cagegroup (in months, then convert to years)
cage <- ifelse(
  cagegroup == 1,
  clamp(round(rnorm(n, 30, 4)), 24, 41),
  clamp(round(rnorm(n, 54, 4)), 42, 65)
) / 12  # store as years with decimal

# Observation counts with interaction effects:
#   praise:  famtype x tx interaction (treatment boosts praise more in 2-parent)
#   direct:  magegroup x cagegroup interaction (younger moms more directive with younger kids)
#   negat:   tx and famtype main effects only

praise <- mapply(function(t, fm) {
  mu <- 5 + 1 * t + 0.5 * (fm == 1) + 2.5 * t * (fm == 1)
  clamp(round(rnorm(1, mu, 2)), 0, 20)
}, tx, famtype)

direct <- mapply(function(ma, ca) {
  mu <- 4 + 0.5 * (ma == 2) - 0.3 * (ca == 2) + 2.0 * (ma == 1) * (ca == 1)
  clamp(round(rnorm(1, mu, 2)), 0, 20)
}, magegroup, cagegroup)

negat <- mapply(function(t, fm) {
  mu <- 6 - 1.5 * t + 0.5 * (fm == 2)
  clamp(round(rnorm(1, mu, 2)), 0, 20)
}, tx, famtype)

parent_child_data <- tibble::tibble(
  casenum   = 1:n,
  mage      = add_missing(as.numeric(mage)),
  magegroup = magegroup,
  cage      = add_missing(as.numeric(cage)),
  cagegroup = cagegroup,
  famtype   = famtype,
  CLINREM   = CLINREM,
  tx        = tx,
  praise    = add_missing(as.numeric(praise)),
  direct    = add_missing(as.numeric(direct)),
  negat     = add_missing(as.numeric(negat))
)

usethis::use_data(parent_child_data, overwrite = TRUE)
cat("Created: parent_child_data\n")
