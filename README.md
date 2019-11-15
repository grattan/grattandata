
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
                        upgrade = "always", 
                        build_vignettes = TRUE)
```

## Read microdata with `read_microdata()`

The core function of the package is `read_microdata()`. If you give
`read_microdata()` a unique fragment of a filename - with or without the
directory names - it will load the relevant file for you. Don’t worry
about upper case and lower case letters - either, or a mix of both, will
work.

Here are some working examples using the Victorian Government’s
[VISTA](https://transport.vic.gov.au/about/data-and-research/vista)
travel dataset:

``` r
vista_12_16_p <- read_microdata("P_VISTA12_16_SA1_V1.csv")

vista_12_16_p  <- read_microdata("csv/P_VISTA12_16_SA1_V1.csv")

vista_12_16_p  <- read_microdata("victoria/vista/2009/csv/P_VISTA12_16_SA1_V1.csv")
```

If you give `read_microdata()` a filename fragment that matches multiple
files, it will return an informative error message telling you which
files match your fragment. For example:

``` r
vista <- read_microdata("VISTA12_16_")
#> Error in find_filename(filename): Multiple files were found with the filename VISTA12_16_.
#>  The matches are:
#> victoria/VISTA/2012-2016/csv/H_VISTA12_16_SA1_V1.csv
#> victoria/VISTA/2012-2016/csv/JTE_VISTA12_16_sa1_V1.csv
#> victoria/VISTA/2012-2016/csv/JTW_VISTA12_16_SA1_V1.csv
#> victoria/VISTA/2012-2016/csv/P_VISTA12_16_SA1_V1.csv
#> victoria/VISTA/2012-2016/csv/S_VISTA12_16_SA1_V1.csv
#> victoria/VISTA/2012-2016/csv/T_VISTA12_16_SA1_V1.csv
```

You can now identify which file you want to load, and be more specific
with the fragment that you pass to `read_microdata()`.

For more, see the package vignette.
