#' @title read_microdata loads data from the Grattan Institute data warehouse
#'
#' @param dataset The abbreviated name of the dataset you wish to load, such as
#' `sih` for the ABS Survey of Income and Housing.
#' 
#' @param year The year of the dataset you wish to load, such as `2015-16` or
#' `2012`.
#' 
#' @param level Optional. Some datasets include multiple files corresponding to 
#' different levels - such as the household or person level. 
#' 
#' @param provider Optional. The provider of the dataset you wish to load, such as
#' 'ABS' or 'ATO'. `read_microdata()` can usually figure this out for itself.
#' 
#' @param filetype Optional. Possible values include 'stata', 'sas', and 'csv'. 
#' By default, `read_microdata()` will load Stata files
#' if available, falling back to SAS files if they're not available, and CSV
#' if neither Stata nor SAS files are present.
#'
#' @param path Optional. Specifying the filepath is an alternative to using the 
#' other arguments such as 'dataset'. If specified, 'path' should be the file
#' path to the microdata file within the `microdata` folder,
#' including filename and extension. For example, "abs/sih/2015-16/HES15BP.dta".
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

read_microdata <- function(dataset = NULL,
                           year = NULL, 
                           level = NULL,
                           provider = NULL,
                           filetype = NULL,
                           path = NULL,
                           setclass = "tbl",
                           ...) {

  if(is.null(path) & is.null(dataset)) {
    stop("You must specify either `path` or `dataset`.")
  }

  
  if(!is.null(dataset) & is.null(year)) {
    stop("You must specify the year of the data you wish to load.")
  }
  
  if(!is.null(path) & !is.null(dataset)) {
    warning("You have specified both 'path' and 'dataset'. Ignoring 'dataset'
            and using 'path'.")
    
    dataset <- NULL
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
                                   "data",
                                   "microdata")
  
  # Check if user has access to data warehouse
  if(file.access(data_warehouse_path, mode = 2) != 0) {
    stop(paste0("You do not appear to have access to the Grattan data
                warehousehose,\n", data_warehouse_path))
  }
  
  # Contruct file path from given arguments if `path` not specified
  if(is.null(path)) {
    
    data_dir <- construct_path(dataset = dataset,
                               year = year,
                               level = level,
                               provider = provider,
                               filetype = filetype,
                               data_warehouse_path = data_warehouse_path)
    
  }
  
  if(is.null(path)) {
    
    data_dir <- file.path(data_warehouse_path, data_dir)
  } else {
    data_dir <- dirname(path)
  }
  
  
  # Check if directory exists 
  if(!dir.exists(data_dir)) {
    stop(paste0("Cannot find the directory: ", data_dir))
  }
  
  # Check if user has access to directory
  if(file.access(data_dir, mode = 2) != 0) {
    stop(paste0("You do not have access to ", data_dir))
  }
  
  # Get filename if not supplied
  
  if(is.null(path)) {
    
    filename <- get_filename(data_dir = data_dir,
                             level = level,
                             filetype = filetype)
    
    path <- file.path(data_dir, filename)
  }
  
  
  # Check if file exists
  if(!file.exists(path)) {
    stop(paste0("The file ", path, " cannot be found"))
  }
  

  rio::import(file = path,
              setclass = setclass,
              ...)

}

# Internal function to construct a path from various supplied arguments
construct_path <- function(dataset,
                           year, 
                           level,
                           provider,
                           filetype,
                           data_warehouse_path) {
  
  # If the user doesn't specify the data provider, we first try known datasets
  # contained in the internal `datasets` table; if not there, we loop through 
  # the various providers 
  
  if(is.null(provider)) {
    
    # First, check the known datasets in `datasets`
    if(dataset %in% datasets$dataset) {
      
      provider <- datasets$provider[datasets$dataset == dataset]
      
    } else {
      
      all_providers <- list.dirs(data_warehouse_path, 
                                 recursive = FALSE,
                                 full.names = FALSE)
      
      # Initialise an empty vector; fill with provider name if dataset found
      prov_with_dataset <- as.character()
      
      # Loop through all providers to see if the dataset can be found
      for(prov in all_providers) {
        
        prov_datasets <- list.dirs(file.path(data_warehouse_path,
                                             prov),
                                   recursive = FALSE,
                                   full.names = FALSE)
        
        if(dataset %in% prov_datasets) {
          prov_with_dataset <- prov
        }
      }
      
      if(length(prov_with_dataset) == 0) {
        stop(paste0("Could not find the provider for dataset ",
                    dataset, "."))
      }
      
      provider <- prov_with_dataset
      
    } # End of logic that applies when dataset not in `datasets` table
    
  } # End of logic that applies when provider isn't supplied by the user
  
  # If the user hasn't specified a filetype, try to find it
  if(is.null(filetype)) {
    
    path_without_type <- file.path(data_warehouse_path,
                                   provider,
                                   dataset,
                                   year)
    
    filetypes <- list.dirs(path_without_type,
                           recursive = FALSE,
                           full.names = FALSE)
    
    filetypes <- tolower(filetypes)
    
    if("stata" %in% filetypes) {
      filetype <- "stata"
    } else if("sas" %in% filetypes) {
      filetype <- "sas"
    } else if("csv" %in% filetype) {
      filetype <- "csv"
    } else {
      stop(paste0("Could not find Stata, SAS, or CSV subfolders at ",
                  path_without_type, "."))
    }
    
  }
  
  path <- file.path(provider, dataset, year, filetype)
  
  path
  
} 

get_filename <- function(data_dir,
                         level,
                         filetype) {
  
  files_in_dir <- list.files(data_dir, 
                             recursive = FALSE,
                             include.dirs = FALSE,
                             ignore.case = TRUE)
  
  # If the user hasn't specified a level & there's only one file in the dir, 
  # use that file
  if(length(files_in_dir) == 1 & is.null(level)) {
    
    file <- files_in_dir[1]
    
  } else {
    
    # If there's >1 file and the user hasn't specified a level, stop 
    if(is.null(level)) {
      stop(paste0("There are multiple files in the directory",
                  data_dir, ". Do you need to set the 'level'?",
                  "\nFiles in this directory are: ", 
                  paste(files_in_dir, collapse = ", ")))
    } else {
      
      # User has specified level - find the file that ends in the specified level
      file <- files_in_dir[endsWith(tools::file_path_sans_ext(tolower(files_in_dir)),
                                    tolower(level))]
      
      # Check to see if a file exists with specified level - return an error if not
      if(length(file) == 0) {
        stop(paste0("Could not find a file with level '", level, "' in ",
                    data_dir, "\nFiles in this directory are: ", 
                    paste(files_in_dir, collapse = ", ")))
        
      }
      
      
    } 
    
    
  } 
  file
  
}


