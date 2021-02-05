#' Add a specified location for microdata not in the Grattan data warehouse
#' @param path File path to non-data warehouse microdata location, such as
#' `file.path("~", "my_data", "hilda")
#' 
#' @description Some microdata, such as HILDA, has access restrictions that
#' mean it cannot be stored on Dropbox, even with the security controls we 
#' have in place. This function allows you to store microdata somewhere else,
#' but still load it with the `read_microdata()` function. This increases 
#' reproducibility within Grattan. `read_microdata()` will look both in the
#' data warehouse and in the location you add with `add_microdata_location()`.
#' @return Sets an environment variable `"R_GRATTANDATA_LOCATION"`. When
#' this variable is set, `grattandata` functions including `read_microdata()`
#' will look for the data file(s) you request in the specified location as well
#' as in the Grattan data warehouse. 
#' 
#' @note You can only set one location (in addition to the Grattan data
#' warehouse). All subfolders of the defined location will be included in
#' the search path for `read_microdata()`.
#' 
#' We recommend that you use the `add_microdata_location()` function in your
#' scripts rather than defining the `"R_GRATTANDATA_LOCATION"` environment
#' variable elsewhere, to improve clarity/reproducibility of your code.
#' @export

add_microdata_location <- function(path) {
  Sys.setenv("R_GRATTANDATA_LOCATION" = path)
  
  invisible(TRUE)
}
