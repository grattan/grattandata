# grattandata 0.1.2
* GitHub Actions is now used rather than Travis-CI for continuous integration
(automated package testing)
* add_microdata_location() allows a user to load files not stored in the Grattan
data warehouse using the `read_microdata()` function.

# grattandata 0.1.1
* `read_microdata()` now has the option of loading .fst files, which 
are created when loading non-fst files
* more informative error message is given when no matches are found, 
suggesting possible matches

# grattandata 0.1
* `read_microdata()` is now a stable function, ready for use.