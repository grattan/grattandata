# Read in a .csv file that contains aliases for various datasets in the
# data warehouse. Convert to a named character vector to use as a lookup table

alias_df <- read.csv("data-raw/aliases.csv")

aliases <- as.character(alias_df$alias)
aliases <- tolower(aliases)

names(aliases) <- alias_df$dataset
names(aliases) <- tolower(names(aliases))

# Define extensions that will be excluded from the search path 
# in `find_filename()` etc.

unused_extensions <- c("zip", "txt", "fst", "pdf", "doc")

usethis::use_data(aliases, unused_extensions, internal = TRUE, overwrite = TRUE)
