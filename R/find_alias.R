# Internal function
# Given a name, tries to find a dataset that could possibly match that name
# This is *only* used to give a *suggestion* to the user when `find_filename`
# does not find a match. 

#' @importFrom stringdist amatch

find_alias <- function(filename) {
  
  .filename <- basename(filename)
  .filename <- tolower(.filename)
  
  # Use fuzzy/approximate string matching to find a rough match for 
  # filename in the lookup table (internal data, created in data-raw)
  possible_match <- names(aliases[stringdist::amatch(.filename, 
                                                     aliases,
                                                     maxDist = 0.38,
                                                     method = "jw")])
  
  possible_match
}