# ============================================================================
# Build all datasets for psych350data
# Run from package root: source("build_all.R")
# ============================================================================

library(dplyr)
library(readxl)
library(lubridate)
library(stringr)
library(purrr)
library(usethis)
library(here)

source_dir <- here("data-raw")

cat("Building all psych350data datasets...\n\n")

# ── Dataset scripts ───────────────────────────────────────────────────────────
# Each entry is a path relative to data-raw/
# Scripts are run in order — add new datasets at the bottom

scripts <- c(

  # ── Existing datasets ───────────────────────────────────────────────────────
  here(source_dir, "superman",    "superman-dataprep.R"),
  here(source_dir, "hotones",    "hotones-dataprep.R"),
  here(source_dir, "tip_jokes",   "tip-dataprep.R"),
  here(source_dir, "mcu",         "mcu-dataprep.R"),
  here(source_dir, "mock_jury",   "jury-dataprep.R"),
  here(source_dir, "candy",       "candy-dataprep.R"),
  here(source_dir, "football",    "football-dataprep.R"),
  here(source_dir, "huskers",     "huskers-dataprep.R"),
  here(source_dir, "cheese",      "cheese-dataprep.R"),
  here(source_dir, "lpd_stops",  "lpd-dataprep.R"),

  # Simulated datasets ────────────────────────────────────────────────────────────
  here(source_dir, "superman", "smes-dataprep.R"),
  here(source_dir, "parent_child", "parent-dataprep.R"),
  here(source_dir, "final_project", "interpersonal-dataprep.R"),
  here(source_dir, "final_project", "selfdescriptive-dataprep.R"),
  here(source_dir, "hindsight_bias",   "hindsightbias-dataprep.R")


)

# ── Run each script ───────────────────────────────────────────────────────────
# Each script runs in its own environment so nothing bleeds between datasets.
# Errors are caught and reported without stopping the whole build.

results <- list(ok = character(), failed = character())

for (script in scripts) {

  # Check the file exists before trying to source it
  if (!file.exists(script)) {
    cat("  [SKIP] Not found:", script, "\n")
    results$failed <- c(results$failed, script)
    next
  }

  cat("Running:", basename(script), "\n")

  tryCatch(
    {
      source(script, local = new.env())
      cat("  [OK]\n")
      results$ok <- c(results$ok, script)
    },
    error = function(e) {
      cat("  [FAIL]", conditionMessage(e), "\n")
      results$failed <<- c(results$failed, script)
    }
  )
}

# ── Summary ───────────────────────────────────────────────────────────────────

cat("\n============================================\n")
cat("  Dataset rebuild complete\n")
cat("============================================\n\n")

# Datasets successfully built
rda_files <- list.files(here("data"), pattern = "\\.rda$")
cat(sprintf("  Built: %d .rda file(s) in /data\n", length(rda_files)))
cat(paste0("    - ", rda_files, collapse = "\n"), "\n")

# Scripts that ran OK
cat(sprintf("\n  Scripts OK:   %d / %d\n", length(results$ok), length(scripts)))

# Scripts that failed or were skipped
if (length(results$failed) > 0) {
  cat(sprintf("  Scripts FAILED or SKIPPED: %d\n", length(results$failed)))
  cat(paste0("    - ", basename(results$failed), collapse = "\n"), "\n")
} else {
  cat("  No failures\n")
}

cat("\n============================================\n")
