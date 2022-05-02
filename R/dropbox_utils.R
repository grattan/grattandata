#' @title get_dropbox_location returns the local path to the user's Dropbox
#'
#' @param type Either 'business' (the default) or 'personal'.
#'
#' @return String corresponding to the path to the user's business or personal
#' Dropbox.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr extract2
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

  if (!file.exists(dropbox_info_location)) {
    stop("read_microdata() could not find your Dropbox location.")
  }

  # Construct a path on the local disk to Dropbox (business, not personal)
  dropbox_path <-
    jsonlite::fromJSON(dropbox_info_location) %>%
    magrittr::extract2(type) %>%
    magrittr::extract2("path")

  dropbox_path
}

#' @title `check_dropbox_access` checks if you have access
#' to the Grattan data warehouse
#'
#' @description Use of \code{read_microdata()} relies on access to the
#' Grattan data warehouse, which is housed on Dropbox.
#' The \code{check_dropbox_access()} function checks if you have
#' access to the Dropbox folder.
#'
#' @return `TRUE` if you appear to have access to the data warehouse;
#' `FALSE` if not.
#'
#' @export

check_dropbox_access <- function() {

  path <- file.path(get_dropbox_location(),
                    "data",
                    "microdata")

  result <- file.access(path, mode = 0) == 0

  result_message <- ifelse(isTRUE(result),
                           "appear",
                           "do not appear")

  message(paste("You",
                result_message,
                "to have access to the Grattan data warehouse."))

  invisible(result)
}


get_data_warehouse_path <- function() {
  
  # Get path to business Dropbox on user's computer
  dropbox_path <- get_dropbox_location(type = "business")
  
  if (!dir.exists(dropbox_path)) {
    stop("read_microdata() could not find the",
         "Grattan Dropbox on your local machine.")
  }
  
  # Check for access to the data warehouse
  data_warehouse_path <- file.path(
    dropbox_path,
    "data",
    "microdata"
  )
  
  if (file.access(data_warehouse_path, mode = 0) != 0) {
    stop(paste0("You do not appear to have access to the Grattan data
                warehouse,\n", data_warehouse_path))
  }
  
  data_warehouse_path
  
}

get_data_path <- function() {
  data_warehouse_path <- get_data_warehouse_path()
  user_data_path <- Sys.getenv("R_GRATTANDATA_LOCATION")
  data_path <- c(data_warehouse_path,
                 user_data_path)
  
  data_path
}