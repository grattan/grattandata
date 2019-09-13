#' @title read_microdata loads data from the Grattan Institute data warehouse
#'
#' @param path Path to the microdata file within the `microdata` folder,
#' including filename and extension. For example, "ABS/SIH/2015-16/Stata/HES15BP.dta".
#' Use `/` to separate subdirectories, not `\`, regardless of whether you're on a
#' Windows machine or a Mac.
#'
#' @param setclass default = `tbl`. Class of object you wish to be returned.
#' Default returns a tibble. Can also specify `data.frame` or `data.table`.
#'
#' @param ... arguments passed to `rio::import()`. See `?rio::import`
#'
#' @examples
#'
#' \donttest{
#' hes_1516 <- read_microdata("abs/hes/2015-16/hes15bh.sas7bdat")
#' }
#'
#' @importFrom rio import
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr use_series
#'
#' @name read_microdata
#' @export

read_microdata <- function(path = NULL,
                           setclass = "tbl",
                           ...) {

  if(is.null(path)) {
    stop("You must specify either `path`.")
  }

  dropbox_info_location <-
    if (Sys.getenv("OS") == "Windows_NT") {
      file.path(Sys.getenv("LOCALAPPDATA"), "Dropbox", "info.json")
    } else {
      "~/.dropbox/info.json"
    }

  if(!file.exists(dropbox_info_location)) {
    stop("read_microdata() could not find your Dropbox location.")
  }

  dropbox_path <-
    jsonlite::fromJSON(dropbox_info_location) %>%
    magrittr::use_series("business") %>%
    magrittr::use_series("path")

  data_warehouse_path <- file.path(dropbox_path,
                                   "data")

  path <- file.path(data_warehouse_path, path)
  
  dir <- dirname(path)
  
  # Check if directory exists 
  if(!dir.exists(dir)) {
    stop(paste0("Cannot find the directory: ", dir))
  }
  
  # Check if user has access to directory
  if(file.access(dir, mode = 2) != 0) {
    stop(paste0("You do not have access to ", dir))
  }
  
  # Check if file exists
  if(!file.exists(path)) {
    stop(paste0("The file ", path, " cannot be found"))
  }
  

  rio::import(file = path,
              setclass = setclass,
              ...)

}



