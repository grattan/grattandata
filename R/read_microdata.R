#' @title read_microdata loads data from the Grattan Institute data warehouse
#'
#' @description \code{read_microdata()} loads data from the Grattan Institute
#' data warehouse. This function finds the file you're looking for with
#' \code{find_filename()} and imports it using \code{rio::import()}.
#' Run \code{browseVignettes("grattandata")} for  more on how to use
#' \code{read_microdata()}.
#'
#' This function requires access to the Grattan Institute data warehouse, which
#' is housed in the Grattan Institute Dropbox. If you do not have access to
#' this Dropbox the function will not work. Run \code{check_dropbox_access()}
#' if you are unsure if you have access. If you have selective sync enabled in
#' Dropbox (as you should), the file may have to be downloaded before it can
#' be imported, which may take time.
#'
#' @param filename A filename, or fragment of a filename, corresponding to
#' a file in the Grattan data warehouse, such as "SIH15BP.dta".
#' Can include, or not include, the directory name(s). If you specify a
#' file extension, such as ".dta", ".csv", or ".sas7bdat", the extension
#' must match exactly. See examples below for more information.
#'
#' @param fast `FALSE` by default. If set to `TRUE`, `read_microdata()` will
#' look for a ".fst" version of the file you have requested, and load it if
#' it exists. fst files are a compressed data format that is quick to load.
#' Note that .fst files do not include attributes such as column labels that
#' may be present in Stata and SAS files.
#'
#' @param catalog_file Optional. Filename of SAS catalogue file,
#' including extension. For use with SAS files that store labels in a
#' separate catalogue file. Must be located in the same directory as the data,
#' or a subdirectory of that directory. Will be ignored if `fast` is `TRUE`.
#'
#' @param setclass Optional. A character vector specifying the format of the
#' object you wish to import. Default is "tbl", a tibble. Other options are
#' "data.table" and "data.frame". See `?rio::import`.
#'
#' @param ... arguments passed to `rio::import()`. See `?rio::import`
#'
#' @details
#' `read_microdata()` uses the `find_filename()` function to search the Grattan
#' data warehouse for a file that matches the filename you supply.
#' If no matches are found, it will return an error. If one match is found,
#' it will load the file. If more than one files are found that match your
#' filename, it will tell you what the matches are so you can be more specific.
#'
#' `read_microdata()` loads files using `rio::import()`. See `?rio::import`
#' for information on the range of options you can specify, such as the number
#' of lines to skip in a CSV or the range and/or worksheet to import from an
#' Excel workbook.
#'
#' @examples
#'
#' # You can import a file by specifying its filename, without the path:
#' \donttest{
#' sih_1516 <- read_microdata("SIH15bp.dta")
#' }
#'
#' # You can also include part of the file path if you like:
#' \donttest{
#' sih_1516 <- read_microdata("abs/sih/2015-16/stata/SIH15BP.dta")
#' }
#'
#' # If the filename you supply matches multiple files in the data
#' # warehouse, you'll be told what the matches are so you can be
#' # more specific.
#' \donttest{
#' sih_1516 <- read_microdata("SIH15BP")
#' }
#'
#'
#' @importFrom rio import
#' @importFrom fst write_fst
#'
#' @name read_microdata
#' @export

read_microdata <- function(filename,
                           fast = FALSE,
                           catalog_file = NULL,
                           setclass = "tbl",
                           ...) {
  if (class(filename) != "character") {
    stop("`filename` must be a character string.")
  }

  if (length(filename) != 1) {
    stop(paste0(
      "`filename` has ", length(filename), " elements. ",
      "It must only have one."
    ))
  }

  if (isTRUE(fast) & !is.null(catalog_file)) {
    warning("`fast` is set to `TRUE`, so `catalog_file` will be ignored.")
    catalog_file <- NULL
  }

  path <- find_filename(filename)
  fst_present <- fst_exists(path)

  if (isTRUE(fast)) {
    if (isTRUE(fst_present)) {
      path <- construct_fst_path(path)
    }
  }

  # Construct catalog_file path if needed -----

  if (!is.null(catalog_file)) {
    files_in_dir <- list.files(dirname(path), recursive = TRUE)

    matched_catalog_file <- files_in_dir[grepl(catalog_file,
                                               files_in_dir,
                                               ignore.case = TRUE)]

    matched_catalog_file <- file.path(dirname(path), matched_catalog_file)

    if (length(matched_catalog_file) != 1) {
      stop(paste0(
        "Found ", length(matched_catalog_file), " matches for ",
        catalog_file, " in ", dirname(path)
      ))
    }
  } else { # Case where user did not specify catalog_file
    matched_catalog_file <- NULL
  }

  # Import file ------
  message(paste0(
    "Importing: ",
    path
  ))

  # Note: when passing null args (like `matched_catalog_file = NULL`)
  # to haven::read_dta, a warning is thrown.
  # We want to avoid that, so don't pass arg when user hasn't supplied it

  if (is.null(matched_catalog_file)) {
    .file <- rio::import(
      file = path,
      setclass = setclass,
      ...
    )
  } else {
    .file <- rio::import(
      file = path,
      catalog_file = matched_catalog_file,
      setclass = setclass,
      ...
    )
  }

  # If an .fst file is not present, we want to create one for next time

  if (isFALSE(fst_present)) {

    fst_path <- construct_fst_path(path)
    fst_dir <- dirname(fst_path)

    if (isFALSE(dir.exists(fst_dir))) {
      dir.create(fst_dir)
    }

    fst::write_fst(.file, fst_path)
  }

  return(.file)
}
