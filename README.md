
<!-- README.md is generated from README.Rmd. Please edit that file -->

# grattandata

Easily load microdata from the Grattan Institute data warehouse in R.
Users will require access to the Grattan Institute data warehouse.

## Get access to the data warehouse

Speak to Jonathan, Will, or Matt to get access to the data warehouse.

Note that access to some parts of the warehouse requires you to be an
approved user of the relevant microdata.

## Installation

You can install `grattandata` from Github as follows:

``` r
# If the `remotes` package is not installed, install it
if(!require(remotes)) {
  install.packages("remotes")
}

# Install `grattandata` from GitHub using remotes
remotes::install_github("grattan/grattandata",
                        dependencies = TRUE, upgrade = "always")
```

And the development version from [GitHub](https://github.com/) with:

## Read microdata with `read_microdata()`

The core function of the package is `read_microdata()`. If you give
`read_microdata()` a unique fragment of a filename - with or without the
directory names - it will load the relevant file for you. Don’t worry
about upper case and lower case letters - either, or a mix of both, will
work.

Here are some working examples:

``` r
sih_1516 <- read_microdata("SIH15bh.dta")

sih_1516 <- read_microdata("Stata/sih15bh.dta")

sih_1516 <- read_microdata("ABS/SIH/2015-16/Stata/SIH15BH.dta")
```

If you give `read_microdata()` a filename fragment that matches multiple
files, it will return an informative error message telling you which
files match your fragment. For example:

``` r
sih_1516 <- read_microdata("SIH15BH")
#> Error in find_filename(filename): Multiple files were found with the filename SIH15BH.
#>  The matches are:
#> abs/sih/2015-16/csv/documentation/SIH15BH_FREQ.txt
#> abs/sih/2015-16/csv/SIH15BH.csv
#> abs/sih/2015-16/doc/SIH15BH_FREQ.txt
#> abs/sih/2015-16/sas/documentation/SIH15BH_FREQ.txt
#> abs/sih/2015-16/sas/sih15bh.sas7bdat
#> abs/sih/2015-16/stata/SIH15BH.dta
```

You can now identify which file you want to load, and be more specific
with the fragment that you pass to `read_microdata()`.

For more, see the package vignette.
