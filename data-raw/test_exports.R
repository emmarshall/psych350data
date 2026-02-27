# ============================================================================
# Test SPSS exports for all datasets
# Run from package root: source("data-raw/test_exports.R")
# ============================================================================

devtools::load_all()

# ----------------------------------------------------------------------------
# Test all dataset exports
# ----------------------------------------------------------------------------

test_all_exports <- function() {
  datasets_to_test <- list_datasets()

  results <- list()

  for (ds in datasets_to_test) {
    cat("\n=== Testing:", ds, "===\n")
    tryCatch({
      path <- tempfile(fileext = ".sav")
      export_sav(ds, path = path)

      # Read back and check for labelled variables
      test_data <- haven::read_sav(path)
      labelled_vars <- names(test_data)[sapply(test_data, haven::is.labelled)]

      if (length(labelled_vars) > 0) {
        cat("Labelled variables:", paste(labelled_vars, collapse = ", "), "\n")
      } else {
        cat("WARNING: No labelled variables found!\n")
      }

      cat("[OK] Export successful\n")
      results[[ds]] <- list(status = "OK", labelled = labelled_vars)

    }, error = function(e) {
      cat("[ERROR]:", e$message, "\n")
      results[[ds]] <- list(status = "ERROR", message = e$message)
    })
  }

  invisible(results)
}

# ----------------------------------------------------------------------------
# Check labels for a specific dataset
# ----------------------------------------------------------------------------

check_spss_labels <- function(dataset_name) {
  path <- tempfile(fileext = ".sav")
  export_sav(dataset_name, path = path)
  df <- haven::read_sav(path)

  cat("=== Variable Types for", dataset_name, "===\n")
  for (var in names(df)) {
    val_labs <- labelled::val_labels(df[[var]])
    var_lab <- labelled::var_label(df[[var]])

    if (!is.null(val_labs)) {
      cat(sprintf("\n%s: %s\n", var, class(df[[var]])[1]))
      cat("  Variable label:", if (!is.null(var_lab)) var_lab else "(none)", "\n")
      cat("  Value labels:\n")
      for (i in seq_along(val_labs)) {
        cat(sprintf("    %s = %s\n", val_labs[i], names(val_labs)[i]))
      }
    }
  }

  invisible(df)
}

# ----------------------------------------------------------------------------
# Preview data with factor labels (mimics SPSS display)
# ----------------------------------------------------------------------------

preview_as_spss <- function(dataset_name, n = 10) {
  path <- tempfile(fileext = ".sav")
  export_sav(dataset_name, path = path)
  df <- haven::read_sav(path)

  # Convert labelled columns to factors for display
  df |>
    haven::as_factor() |>
    head(n) |>
    print()

  invisible(df)
}

# ----------------------------------------------------------------------------
# Run tests
# ----------------------------------------------------------------------------

cat("Running export tests...\n")
test_all_exports()

cat("\n\nTo check a specific dataset's labels:\n")
cat('  check_spss_labels("superman")\n')
cat('  check_spss_labels("hot_ones")\n')

cat("\nTo preview data as SPSS would display it:\n")
cat('  preview_as_spss("superman")\n')
