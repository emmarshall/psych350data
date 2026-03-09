########################################################################
# Internal helpers ########################################################################

#' @noRd
get_dataset <- function(name) {
  valid <- list_datasets()
  if (!name %in% valid) {
    stop("Unknown dataset '", name, "'. Available: ",
         paste(valid, collapse = ", "), call. = FALSE)
  }

  # Special case: combined data requires joining
  if (name == "superman_combined") {
    return(join_superman_data())
  }

  # Load lazy-loaded data properly
  e <- new.env()
  data(list = name, package = "psych350data", envir = e)
  e[[name]]
}


#' Export Parent Child data as SPSS .sav file
#'
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_parent_child_sav <- function(
    path = "parent_child_data.sav",
    use_sentinel = TRUE
) {
  export_sav("parent_child_data", path = path, use_sentinel = use_sentinel)
}


#' Read SPSS Data File
#'
#' Reads an SPSS \code{.sav} file, converts user-missing values to \code{NA},
#' and removes all labels. Optionally applies any active SPSS filter variable.
#'
#' @param file_path Character string. Path to the \code{.sav} file.
#' @param check_filter Logical. If \code{TRUE}, checks for and applies any
#'   active SPSS filter variable. Default is \code{TRUE}.
#' @param verbose Logical. If \code{TRUE}, prints diagnostic information.
#'   Default is \code{FALSE}.
#'
#' @return A tibble with numeric values and no SPSS labels.
#'
#' @importFrom haven read_sav zap_missing zap_labels zap_label is.labelled
#'   as_factor
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate across where
#'
#' @export
get_spss_data <- function(file_path, check_filter = TRUE, verbose = FALSE) {

  data <- haven::read_sav(here::here(file_path))

  if (verbose) {
    cat("\n=== SPSS DATA IMPORT DIAGNOSTICS ===\n")
    cat("Total rows in raw SPSS file:", nrow(data), "\n")
  }

  if (check_filter) {
    filter_var <- attr(data, "filter")
    if (!is.null(filter_var)) {
      if (verbose) {
        warning("SPSS filter detected on variable: ", filter_var)
        warning("Applying filter to match SPSS...")
      }
      data <- data[data[[filter_var]] != 0 & !is.na(data[[filter_var]]), ]
    }
  }

  data <- data |>
    haven::zap_missing() |>
    haven::zap_labels() |>
    haven::zap_label() |>
    tibble::as_tibble() |>
    dplyr::mutate(
      dplyr::across(
        dplyr::where(haven::is.labelled),
        haven::as_factor
      )
    )

  if (verbose) {
    cat("\nMissing data after zap_missing():\n")
    missing_after <- colSums(is.na(data))
    print(missing_after[missing_after > 0])
    cat("\nFinal dataset:", nrow(data), "rows\n")
    cat("=====================================\n\n")
  }

  data
}


#' Check SPSS Export Quality
#'
#' Reads an exported \code{.sav} file and audits its structure to confirm that
#' variable labels, value labels, and missing value codes are correctly applied.
#' Prints a formatted summary report and invisibly returns a list of audit
#' results.
#'
#' @param file_path Character string. Path to the \code{.sav} file to check.
#' @param sentinel Numeric. The missing value sentinel to look for.
#'   Default \code{-99}.
#' @param show_all Logical. If \code{TRUE}, prints details for every variable
#'   including those that pass all checks. If \code{FALSE} (default), only
#'   prints variables with issues.
#'
#' @return Invisibly returns a list with components:
#'   \describe{
#'     \item{variables}{Data frame with one row per variable and audit columns.}
#'     \item{n_vars}{Total number of variables.}
#'     \item{missing_var_labels}{Variables with no variable label.}
#'     \item{missing_val_labels}{Numeric variables with no value labels
#'       (informational only -- not all numeric vars need them).}
#'     \item{missing_na_values}{Numeric variables where sentinel appears in
#'       data but is not declared as SPSS missing.}
#'     \item{sentinel_not_found}{Numeric variables with NAs in raw data but
#'       no sentinel value found in export.}
#'   }
#'
#' @importFrom haven read_sav
#' @importFrom labelled val_labels var_label na_values
#'
#' @export
check_sav_export <- function(file_path, sentinel = -99, show_all = FALSE) {

  data <- haven::read_sav(here::here(file_path))
  n_vars <- ncol(data)
  var_names <- names(data)

  cat("\n============================================\n")
  cat("  SPSS EXPORT AUDIT:", basename(file_path), "\n")
  cat("============================================\n")
  cat(sprintf("  Variables : %d\n", n_vars))
  cat(sprintf("  Rows      : %d\n", nrow(data)))
  cat("--------------------------------------------\n\n")

  results <- purrr::map_dfr(var_names, \(v) {

    col        <- data[[v]]
    is_numeric <- is.numeric(col) || inherits(col, "haven_labelled_spss")
    is_char    <- is.character(col)

    # Variable label
    vlab       <- attr(col, "label")
    has_vlab   <- !is.null(vlab) && nchar(trimws(vlab)) > 0

    # Value labels
    vlabs      <- labelled::val_labels(col)
    has_vlabs  <- !is.null(vlabs) && length(vlabs) > 0

    # SPSS missing value declaration
    na_vals    <- labelled::na_values(col)
    has_na_dec <- !is.null(na_vals) && sentinel %in% na_vals

    # Sentinel appears in raw data
    sentinel_in_data <- is_numeric && !is.null(col) &&
      any(as.numeric(col) == sentinel, na.rm = TRUE)

    # NAs in exported data (after haven reads and applies missing codes)
    n_na <- sum(is.na(haven::zap_missing(col)))

    # Issue flags
    issue_no_vlab     <- !has_vlab
    issue_no_na_dec   <- is_numeric && sentinel_in_data && !has_na_dec
    issue_sentinel_na <- is_numeric && n_na > 0 && !sentinel_in_data && !has_na_dec

    tibble::tibble(
      variable          = v,
      type              = dplyr::case_when(
        is_numeric ~ "numeric",
        is_char    ~ "character",
        TRUE       ~ "other"
      ),
      has_var_label     = has_vlab,
      var_label         = if (has_vlab) vlab else NA_character_,
      has_val_labels    = has_vlabs,
      n_val_labels      = if (has_vlabs) length(vlabs) else 0L,
      has_na_declaration = has_na_dec,
      sentinel_in_data  = sentinel_in_data,
      n_missing_zapped  = n_na,
      issue_no_vlab     = issue_no_vlab,
      issue_no_na_dec   = issue_no_na_dec,
      issue_sentinel_na = issue_sentinel_na
    )
  })

  # --- Summary counts --------------------------------------------------------

  n_no_vlab   <- sum(results$issue_no_vlab)
  n_no_na_dec <- sum(results$issue_no_na_dec)
  n_sent_na   <- sum(results$issue_sentinel_na)
  n_issues    <- n_no_vlab + n_no_na_dec + n_sent_na

  # --- Print variable-level report -------------------------------------------

  print_var <- function(r) {
    status <- if (r$issue_no_vlab || r$issue_no_na_dec || r$issue_sentinel_na) {
      "  [!]"
    } else {
      "  [ ]"
    }

    cat(sprintf("%s %s (%s)\n", status, r$variable, r$type))

    if (r$has_var_label) {
      cat(sprintf("      Label    : %s\n", r$var_label))
    } else {
      cat("      Label    : *** MISSING ***\n")
    }

    if (r$has_val_labels) {
      cat(sprintf("      Values   : %d label(s) defined\n", r$n_val_labels))
    }

    if (r$type == "numeric") {
      if (r$sentinel_in_data && r$has_na_declaration) {
        cat(sprintf("      Missing  : %d rows = %d (declared OK)\n",
                    r$n_missing_zapped, sentinel))
      } else if (r$sentinel_in_data && !r$has_na_declaration) {
        cat(sprintf("      Missing  : *** %d found in data but NOT declared as missing ***\n",
                    sentinel))
      } else if (!r$sentinel_in_data && r$n_missing_zapped > 0) {
        cat(sprintf("      Missing  : *** %d NAs but no sentinel found ***\n",
                    r$n_missing_zapped))
      } else {
        cat("      Missing  : none\n")
      }
    }

    cat("\n")
  }

  if (show_all) {
    purrr::walk(purrr::transpose(results), print_var)
  } else if (n_issues > 0) {
    cat("Variables with issues (use show_all = TRUE to see all):\n\n")
    issues <- results |> dplyr::filter(
      .data$issue_no_vlab | .data$issue_no_na_dec | .data$issue_sentinel_na
    )
    purrr::walk(purrr::transpose(issues), print_var)
  }

  # --- Print summary ---------------------------------------------------------

  cat("--------------------------------------------\n")
  cat("  SUMMARY\n")
  cat("--------------------------------------------\n")

  if (n_issues == 0) {
    cat("  All checks passed\n")
  } else {
    if (n_no_vlab > 0) {
      cat(sprintf("  [!] %d variable(s) missing variable labels\n", n_no_vlab))
      cat(sprintf("      %s\n",
                  paste(results$variable[results$issue_no_vlab], collapse = ", ")))
    }
    if (n_no_na_dec > 0) {
      cat(sprintf("  [!] %d variable(s) have sentinel (%d) in data but not declared missing\n",
                  n_no_na_dec, sentinel))
      cat(sprintf("      %s\n",
                  paste(results$variable[results$issue_no_na_dec], collapse = ", ")))
    }
    if (n_sent_na > 0) {
      cat(sprintf("  [!] %d variable(s) have NAs but no sentinel found\n", n_sent_na))
      cat(sprintf("      %s\n",
                  paste(results$variable[results$issue_sentinel_na], collapse = ", ")))
    }
  }

  cat("============================================\n\n")

  invisible(list(
    variables            = results,
    n_vars               = n_vars,
    missing_var_labels   = results$variable[results$issue_no_vlab],
    missing_na_values    = results$variable[results$issue_no_na_dec],
    sentinel_not_found   = results$variable[results$issue_sentinel_na]
  ))
}



#' List all available datasets in psych350data
#'
#' @return Character vector of dataset names.
#' @export
#'
#' @examples
#' list_datasets()
list_datasets <- function() {
  c(
    "superman",
    "superman_smes",
    "superman_movies",
    "superman_combined",
    "hotones",
    "hotones_sauces",
    "hotones_episodes",
    "tip_jokes",
    "mcu",
    "mock_jury",
    "candy",
    "candy_simple",
    "football",
    "huskers",
    "interpersonal_data",
    "self_descriptive_data",
    "parent_child_data",
    "hindsight_mg_data",
    "hindsight_wg_data",
    "cheese_data",
    "lpd_data"
  )
}
