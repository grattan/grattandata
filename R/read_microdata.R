#' @title read_microdata loads data from the Grattan Institute data warehouse
#' 
#' @description This function requires access to the Grattan Institute data warehouse, which
#' is housed in the Grattan Institute Dropbox. If you do not have access to
#' this Dropbox the function will not work.
#'
#' @param filename filename
#' 
#' @param catalog_file Optional. Filename of catalogue file, including extension. 
#' For use with SAS files that store labels in a separate catalogue file. 
#' Must be located in the same directory as the data, or a subdirectory of 
#' that directory.
#' 
#' @param setclass A character vector specifying the format of the object you 
#' wish to import. Default is "tbl", a tibble. Other options are "data.table" and
#' "data.frame". See `?rio::import`.
#'
#' @param ... arguments passed to `rio::import()`. See `?rio::import`
#' 
#' @details 
#' `read_microdata()` is a wrapper around `rio::import()`. See `?rio::import`
#'
#' @examples
#' \donttest{
#' sih_1516 <- read_microdata("SIH15bp.dta")
#' }
#'
#' @importFrom rio import
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr use_series
#' @importFrom tools file_ext
#'
#' @name read_microdata
#' @export

read_microdata <- function(filename,
                           catalog_file = NULL,
                           setclass = "tbl",
                           ...) {
  
  if(class(filename) != "character") stop("`filename` must be a character string.")
  
  if(length(filename) != 1) stop(paste0("`filename` has ", length(filename), " elements. ",
                                        "It must only have one."))

  path <- find_filename(filename)
  
  # Construct catalog_file path if needed -----
  
  if(!is.null(catalog_file)) {
    
    files_in_dir <- list.files(dirname(path), recursive = TRUE)
    
    matched_catalog_file <- files_in_dir[grepl(catalog_file, files_in_dir, ignore.case = TRUE)]
    
    matched_catalog_file <- file.path(dirname(path), matched_catalog_file)
    
    if(length(matched_catalog_file) != 1) {
      stop(paste0("Found ", length(matched_catalog_file), " matches for ",
                  catalog_file, " in ", dirname(path)))
    }
    
  } else { # Case where user did not specify catalog_file
    matched_catalog_file <- NULL
  }

  # Import file ------
  message(paste0("Importing: ",
                 path))
  
  # Note: when passing null args (like `matched_catalog_file = NULL`) 
  # to haven::read_dta, a warning is thrown.
  # We want to avoid that, so don't pass arg when user hasn't supplied it
  
  if(is.null(matched_catalog_file)) {
    .file <- rio::import(file = path,
                setclass = setclass,
                ...)
  } else {
    .file <- rio::import(file = path,
                catalog_file = matched_catalog_file,
                setclass = setclass,
                ...)
  }
  
  return(.file)
  
}

#' @title find_filename finds a file in the Grattan data warehouse
#' @description `find_filename()` finds files that correspond to the provided 
#' input in the Grattan data warehouse.
#' 
#' @param filename A filename or fragment, with or without filepath, such as "SIH15bh.dta", "SIH15bh", 
#' "ABS/SIH/2015-16/Stata/SIH15bh.dta", "SIH".
#' 
#' @return The full local path to the file that matches 'filename' in the Grattan data warehouse.
#' If more than one matches are found, an error will be shown, including details of the multiple matches.
#' 
#' @export

# Function finds filename corresponding to supplied 'filename',
# either fails with appropriate errors or returns filename
find_filename <- function(filename) {
  
  # Get path to business Dropbox on user's computer
  dropbox_path <- get_dropbox_location(type = "business")
  
  if(!dir.exists(dropbox_path)) {
    stop("read_microdata() could not find the Grattan Dropbox on your local machine.")
  }

  # Check for access to the data warehouse
  data_warehouse_path <- file.path(dropbox_path,
                                   "data",
                                   "microdata")
  
  if(file.access(data_warehouse_path, mode = 2) != 0) {
    stop(paste0("You do not appear to have access to the Grattan data
                warehouse,\n", data_warehouse_path))
  }
  
  # Look in all subdirs of the datawarehouse, if a single match is found, return it
  # If 0 matches, stop; if > 1 matches, stop and tell the user what they are
  # First, exclude files with given extensions ('unused_extensions')
  unused_extensions <- c("zip")
  
  all_files <- list.files(data_warehouse_path, recursive = TRUE)
  all_files <- all_files[!tools::file_ext(all_files) %in% unused_extensions]
  
  matched_files <- all_files[grepl(filename, all_files,
                                   ignore.case = TRUE)]
  
  if(length(matched_files) < 1 ) {
    stop(paste0("No matches could be found for ", filename, 
                "\nin the Grattan data warehouse folders to which you have access"))
  }
  
  if(length(matched_files) > 1) {
    stop(paste0("Multiple files were found with the filename ", filename,
                ".\n The matches are:\n", paste0(matched_files, collapse = "\n")))
  }
  
  path <- file.path(data_warehouse_path, matched_files)
  
  # Check if file exists -----
  if(!file.exists(path)) {
    stop(paste0("The file ", path, " cannot be found"))
  }
  
  return(path)
  
}

#' @title get_dropbox_location returns the local path to the user's Dropbox
#' 
#' @param type Either 'business' (the default) or 'personal'. 
#' 
#' @return String corresponding to the path to the user's business or personal 
#' Dropbox.
#' 
#' @export

get_dropbox_location <- function(type = "business") {
  # Code in this function thanks to Hugh Parsonage
  # Locate the .json file containing information about the user's local Dropbox
  
  dropbox_info_location <-
    if (Sys.getenv("OS") == "Windows_NT") {
      file.path(Sys.getenv("LOCALAPPDATA"), "Dropbox", "info.json")
    } else {
      "~/.dropbox/info.json"
    }
  
  if(!file.exists(dropbox_info_location)) {
    stop("read_microdata() could not find your Dropbox location.")
  }
  
  # Construct a path on the local disk to Dropbox (business, not personal)
  dropbox_path <-
    jsonlite::fromJSON(dropbox_info_location) %>%
    magrittr::use_series(type) %>%
    magrittr::use_series("path")
  
  dropbox_path
}

