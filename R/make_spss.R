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
#' export_sav("superman", path = "superman_data.sav")
#' export_sav("hot_ones", path = "~/Desktop/hot_ones_data.sav")
#' }
export_sav <- function(dataset, path = NULL, use_sentinel = TRUE) {

  if (is.character(dataset) && length(dataset) == 1) {
    ds_name <- dataset
    ds <- get_dataset(ds_name)
  } else if (is.data.frame(dataset)) {
    ds_name <- deparse(substitute(dataset))
    ds <- dataset
  } else {
    stop("'dataset' must be a dataset name (character) or a data frame.")
  }

  ds_labelled <- apply_spss_metadata(ds, ds_name, use_sentinel = use_sentinel)

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
    "mcu", "mock_jury", "candy", "candy_simple", "football",
    "interpersonal_data", "self_descriptive_data")
}


#' Export Superman data as SPSS .sav file
#' @param path File path. Defaults to "superman_data.sav".
#' @param use_sentinel If TRUE (default), NA becomes -99 with SPSS missing codes.
#' @return Invisibly returns the labelled data frame.
#' @export
export_superman_sav <- function(path = "superman_data.sav", use_sentinel = TRUE) {
  export_sav("superman", path = path, use_sentinel = use_sentinel)
}

#' Export Superman SMES data as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_superman_smes_sav <- function(path = "superman_smes_data.sav", use_sentinel = TRUE) {
  export_sav("superman_smes", path = path, use_sentinel = use_sentinel)
}

#' Export Hot Ones data as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_hot_ones_sav <- function(path = "hot_ones_data.sav", use_sentinel = TRUE) {
  export_sav("hot_ones", path = path, use_sentinel = use_sentinel)
}

#' Export Tip-Jokes data as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_tip_jokes_sav <- function(path = "tip_jokes_data.sav", use_sentinel = TRUE) {
  export_sav("tip_jokes", path = path, use_sentinel = use_sentinel)
}

#' Export MCU Films data as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_mcu_sav <- function(path = "mcu_data.sav", use_sentinel = TRUE) {
  export_sav("mcu", path = path, use_sentinel = use_sentinel)
}

#' Export Mock Jury data as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_mock_jury_sav <- function(path = "mock_jury_data.sav", use_sentinel = TRUE) {
  export_sav("mock_jury", path = path, use_sentinel = use_sentinel)
}

#' Export Candy data (full) as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_candy_sav <- function(path = "candy_data.sav", use_sentinel = TRUE) {
  export_sav("candy", path = path, use_sentinel = use_sentinel)
}

#' Export Candy data (simplified) as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_candy_simple_sav <- function(path = "candy_simple_data.sav", use_sentinel = TRUE) {
  export_sav("candy_simple", path = path, use_sentinel = use_sentinel)
}


#' Export Football Concussion data as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_football_sav <- function(path = "football_data.sav", use_sentinel = TRUE) {
  export_sav("football", path = path, use_sentinel = use_sentinel)
}

#' Export Interpersonal Relationships data as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_interpersonal_sav <- function(path = "interpersonal_data.sav", use_sentinel = TRUE) {
  export_sav("interpersonal_data", path = path, use_sentinel = use_sentinel)
}

#' Export Self-Descriptive data as SPSS .sav file
#' @inheritParams export_superman_sav
#' @return Invisibly returns the labelled data frame.
#' @export
export_selfdescriptive_sav <- function(path = "selfdescriptive_data.sav", use_sentinel = TRUE) {
  export_sav("selfdescriptive_data", path = path, use_sentinel = use_sentinel)
}




# ---- Internal helpers -------------------------------------------------------

#' @noRd
get_dataset <- function(name) {
  valid <- list_datasets()
  if (!name %in% valid) {
    stop("Unknown dataset '", name, "'. Available: ",
         paste(valid, collapse = ", "), call. = FALSE)
  }
  get(name, envir = asNamespace("psyc350data"))
}

#' @noRd
apply_spss_metadata <- function(df, name, use_sentinel = TRUE) {
  fn_name <- paste0("label_", name)
  label_fn <- get(fn_name, envir = asNamespace("psyc350data"))
  label_fn(df, use_sentinel = use_sentinel)
}
