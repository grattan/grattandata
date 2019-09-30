# This script defines known datasets (eg. `SIH`) and the providers they come 
# from (eg. `ABS`) for use by the `read_microdata()` function. If you modify
# the tibble that defines the datasets, you must execute this script, 
# including the `use_data()` line, to update the internal table used by the 
# package.

datasets <- tibble::tribble(
              ~provider,   ~dataset,                    ~full_title,
                  "abs",      "sih", "Survey of Income and Housing",
                  "abs",      "hes", "Household Expenditure Survey",
                  "abs",      "nhs",       "National Health Survey",
                  "ato", "taxstats",      "Individual sample files"
              )


usethis::use_data(datasets, internal = TRUE, overwrite = TRUE)
