#' @title read_microdata loads data from the Grattan Institute data warehouse
#'
#' @param path Path to the microdata file within the `microdata` folder,
#' including filename and extension. For example, "ABS/SIH/2015-16/Stata/HES15BP.dta".
#'
#' @param setclass default = `tbl`. Class of object you wish to be returned.
#' Default returns a tibble. Can also specify `data.frame` or `data.table`.
#'
#' @param ... arguments passed to `rio::import()`. See `?rio::import`
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
    use_series("business") %>%
    use_series("path")

  data_warehouse_path <- file.path(dropbox_path,
                                   "Grattan Team",
                                   "data",
                                   "microdata")

  path <- file.path(data_warehouse_path, path)

  # included for debugging purposes

  print(path)

  rio::import(file = path,
              setclass = setclass,
              ...)

}



