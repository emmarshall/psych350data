#' Export a dataset as an SPSS .sav file
#'
#' Converts a psyc350data dataset to a labelled SPSS file with variable labels,
#' value labels, and defined missing values (-99).
#'
#' @param dataset Character string naming the dataset, or the dataset object itself.
#'   Valid names: "superman", "superman_smes", "hot_ones", "tip_jokes", "mcu",
#'   "mock_jury", "candy", "candy_simple", "affairs", "football"
#' @param path File path for the output .sav file. If NULL, saves to the
#'   working directory with a default name.
#' @param use_sentinel Logical. If TRUE (default), NA values are replaced with
#'   -99 and marked as SPSS user-defined missing. If FALSE, NAs are written
#'   as system-missing.
#'
#' @return Invisibly returns the labelled data frame that was written.
#' @export
#'
#' @examples
#' \dontrun{
#' # Export by name
#' export_sav("superman", path = "superman_data.sav")
#'
#' # Export to a specific directory
#' export_sav("hot_ones", path = "~/Desktop/hot_ones_data.sav")
#'
#' # Export all datasets at once
#' export_all_sav(dir = "~/Desktop/spss_files/")
#' }
export_sav <- function(dataset, path = NULL, use_sentinel = TRUE) {

  # Resolve dataset name
  if (is.character(dataset) && length(dataset) == 1) {
    ds_name <- dataset
    ds <- get_dataset(ds_name)
  } else if (is.data.frame(dataset)) {
    ds_name <- deparse(substitute(dataset))
    ds <- dataset
  } else {
    stop("'dataset' must be a dataset name (character) or a data frame.")
  }

  # Apply SPSS metadata
  ds_labelled <- apply_spss_metadata(ds, ds_name, use_sentinel = use_sentinel)

  # Default path
  if (is.null(path)) {
    path <- paste0(ds_name, "_data.sav")
  }

  haven::write_sav(ds_labelled, path = path)
  message("Saved: ", path)
  invisible(ds_labelled)
}


#' Export all psyc350data datasets as SPSS .sav files
#'
#' @param dir Directory to save all files. Created if it doesn't exist.
#' @param use_sentinel Logical. If TRUE, NA -> -99 with SPSS missing value codes.
#'
#' @return Invisibly returns a named list of file paths created.
#' @export
#'
#' @examples
#' \dontrun{
#' export_all_sav(dir = "~/Desktop/spss_files/")
#' }
export_all_sav <- function(dir = ".", use_sentinel = TRUE) {
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)

  datasets <- list_datasets()
  paths <- character(length(datasets))
  names(paths) <- datasets

  for (ds_name in datasets) {
    path <- file.path(dir, paste0(ds_name, "_data.sav"))
    export_sav(ds_name, path = path, use_sentinel = use_sentinel)
    paths[ds_name] <- path
  }

  invisible(paths)
}


#' List all available datasets in psyc350data
#'
#' @return Character vector of dataset names.
#' @export
#'
#' @examples
#' list_datasets()
list_datasets <- function() {
  c("superman", "superman_smes", "hot_ones", "tip_jokes",
    "mcu", "mock_jury", "candy", "candy_simple", "affairs", "football")
}


#' Internal: Retrieve a dataset by name from the package namespace
#' @param name Character string dataset name
#' @return The dataset as a data frame
#' @noRd
get_dataset <- function(name) {
  valid <- list_datasets()
  if (!name %in% valid) {
    stop("Unknown dataset '", name, "'. Available: ",
         paste(valid, collapse = ", "), call. = FALSE)
  }
  get(name, envir = asNamespace("psyc350data"))
}


#' Internal: Apply SPSS metadata by dispatching to the correct label function
#' @param df A data frame
#' @param name Character string dataset name
#' @param use_sentinel Logical
#' @return Labelled data frame ready for write_sav
#' @noRd
apply_spss_metadata <- function(df, name, use_sentinel = TRUE) {
  fn_name <- paste0("label_", name)
  label_fn <- get(fn_name, envir = asNamespace("psyc350data"))
  label_fn(df, use_sentinel = use_sentinel)
}
