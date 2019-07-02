#' @title read_microdata loads data from the Grattan Institute data warehouse
#'
#' @importFrom rio import
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr use_series
#'
#' @name read_microdata
#' @export

read_microdata <- function(release = NULL,
                           provider = "ABS",
                           date = NULL,
                           format = NULL,
                           file = NULL,
                           path = NULL,
                           setclass = "tbl",
                           ...) {


  if(is.null(path) & is.null(release)) {
    stop("You must specify either `path` or `release`")
  }

  path <- construct_path(release = release,
                           provider = provider,
                           date = date,
                           format = format,
                           file = file,
                           path = path,
                           setclass = setclass)


  rio::import(file = path,
              setclass = setclass,
              ...)

}




# Internal function to construct path to data
construct_path <- function(release,
                           provider,
                           date,
                           format,
                           file,
                           path,
                           setclass,
                           ...) {

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

  # If the user supplies an argument to `path`, use that and ignore the rest
  if(!is.null(path)) {

    if(!is.null(release)) {
      warning("Value supplied to both `path` and `release`; ignoring `release`.")
    }

    path <- file.path(data_warehouse_path,
                      path)

  } else {

    if(is.null(date)) {

      if(length(list.dirs(file.path(data_warehouse_path,
                                    provider,
                                    release),
                          recursive = FALSE)) == 0) {

        stop("There are no files corresponding to the specified provider and release.")

      }

      if(length(list.dirs(file.path(data_warehouse_path,
                                    provider,
                                    release),
                          recursive = FALSE)) > 1) {

        stop(paste0("There are multiple dates for this dataset:",
                    paste0(basename(list.dirs(file.path(data_warehouse_path,
                                                        provider,
                                                        release),
                                              recursive = FALSE)),
                           collapse = ", "),
                    ". You must specify `date`."))
      }

      date <- basename(list.dirs(file.path(data_warehouse_path,
                                           provider,
                                           release),
                                 recursive = FALSE))

    }

    if(is.null(format)) {

      if(length(list.dirs(file.path(data_warehouse_path,
                                    provider,
                                    release,
                                    date),
                          recursive = FALSE)) == 0) {

        stop("There are no files corresponding to the specified provider,  release and date.")

      }

      if(length(list.dirs(file.path(data_warehouse_path,
                                    provider,
                                    release,
                                    date),
                          recursive = FALSE)) > 1) {


        warning(paste0("There are multiple formats for this dataset:",
                    paste0(basename(list.dirs(file.path(data_warehouse_path,
                                                        provider,
                                                        release,
                                                        date),
                                              recursive = FALSE)),
                           collapse = ", "),
                    ". Using ", format, ". Specify `format` to override."))
      }

      format <- basename(list.dirs(file.path(data_warehouse_path,
                                           provider,
                                           release,
                                           date),
                                 recursive = FALSE))[1]


    }

    if(is.null(file)) {

      files_in_dir <- list.files(path = file.path(data_warehouse_path,
                                                  provider,
                                                  release,
                                                  date,
                                                  format),
                                 pattern = "^[^documentation].+$",
                                 include.dirs = FALSE,
                                 recursive = FALSE)

      if(length(files_in_dir) == 0) {
        stop("There are no files corresponding to the specified `provider`, `release`, `d")
      }

      if(length(files_in_dir) > 1) {


        stop(paste0("There are multiple files for this dataset:",
                       paste0(basename(list.dirs(file.path(data_warehouse_path,
                                                           provider,
                                                           release,
                                                           date),
                                                 recursive = FALSE)),
                              collapse = ", "),
                       ". Specify `file` to indicate which one you wish to read."))

      }

      file <-

    }

  }


    path
}

