# Internal function
# Given a name, tries to find a dataset that could possibly match that name
# This is *only* used to give a *suggestion* to the user when `find_filename`
# does not find a match. 

#' @importFrom stringdist amatch

find_alias <- function(filename) {
  
  .filename <- basename(filename)
  .filename <- tolower(.filename)
  
  data_warehouse_path <- get_data_warehouse_path()
  
  all_files <- list.files(data_warehouse_path, recursive = TRUE)
  all_files <- all_files[!tolower(file_ext(all_files)) %in% unused_extensions]
  all_files <- basename(all_files)
  all_files <- tolower(all_files)
  names(all_files) <- all_files
  
  # Aliases is an internal data object; see 'data-raw'
  files_and_aliases <- c(all_files, aliases, use.names = TRUE)
  
  # Use fuzzy/approximate string matching to find a rough match for 
  # filename in the lookup table 
  possible_match <- names(files_and_aliases[amatch(.filename, 
                                                   files_and_aliases,
                                                   maxDist = 0.38,
                                                   method = "jw")])
  
  possible_match
}