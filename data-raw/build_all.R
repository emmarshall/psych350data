# ============================================================================
# Build all datasets for psyc350data
# Run from package root: source("data-raw/build_all.R")
# ============================================================================

cat("Building all psyc350data datasets...\n\n")

scripts <- c(
  "data-raw/superman/superman-dataprep.R",
  "data-raw/superman/smes-dataprep.R",
  "data-raw/hot_ones/hotones-dataprep.R",
  "data-raw/tip_jokes/tip-dataprep.R",
  "data-raw/mcu/mcu-dataprep.R",
  "data-raw/mock_jury/jury-dataprep.R",
  "data-raw/candy/candy-dataprep.R",
  "data-raw/football/football-dataprep.R"
)

for (script in scripts) {
  cat("Running:", script, "\n")
  source(script, local = new.env())
}

cat("\n====================================\n")
cat("Dataset build complete!\n")
cat("====================================\n")
cat("Available datasets:\n")
cat(paste(" -", list.files("data", pattern = "\\.rda$")), sep = "\n")
cat("\n\nTo export all as SPSS after installing:\n")
cat('  library(psyc350data)\n')
cat('  export_all_sav(dir = "~/Desktop/PSYC350_SPSS/")\n')
