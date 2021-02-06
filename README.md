
<!-- README.md is generated from README.Rmd. Please edit that file -->

# grattandata

<!-- badges: start -->

[![R-CMD-check](https://github.com/grattan/grattandata/workflows/R-CMD-check/badge.svg)](https://github.com/grattan/grattandata/actions)
<!-- badges: end -->

Easily load microdata from the Grattan Institute data warehouse in R.
Users will require access to the Grattan Institute data warehouse.

## Get access to the data warehouse

Speak to a Grattan R user to get access to the data warehouse. Post in
`#r_at_grattan` Slack if you’re not sure who to speak to.

Note that access to some parts (most) of the warehouse requires you to
be an approved user of the relevant microdata.

## Installation

You can install `grattandata` from Github as follows:

``` r
# If the `remotes` package is not installed, install it
if(!require(remotes)) {
  install.packages("remotes")
}

# Install `grattandata` from GitHub using remotes like this:
remotes::install_github("grattan/grattandata",
                        dependencies = TRUE, 
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
#> Error in find_filename(filename): Multiple files were found with VISTA12_16_ in the filename. .
#>  The matches are:
#> victoria/vista/2012-2016/csv/2012_to_2016/H_VISTA12_16_SA1_V1.csv
#> victoria/vista/2012-2016/csv/2012_to_2016/JTE_VISTA12_16_sa1_V1.csv
#> victoria/vista/2012-2016/csv/2012_to_2016/JTW_VISTA12_16_SA1_V1.csv
#> victoria/vista/2012-2016/csv/2012_to_2016/P_VISTA12_16_SA1_V1.csv
#> victoria/vista/2012-2016/csv/2012_to_2016/S_VISTA12_16_SA1_V1.csv
#> victoria/vista/2012-2016/csv/2012_to_2016/T_VISTA12_16_SA1_V1.csv
```

You can now identify which file you want to load, and be more specific
with the fragment that you pass to `read_microdata()`.

### Data stored elsewhere

Some data - like HILDA - can’t be stored on Dropbox with our other
microdata. The function `add_microdata_location()` enables you to tell
the {grattandata} package where to look for this off-warehouse
microdata. You use it like this:

``` r
add_microdata_location(path = file.path("documents", "hilda"))

read_microdata("hilda_wave1.dta")
read_microdata("hilda_wave2.dta")
```

### Package vignette

For more, see the package vignette by typing
`browseVignettes("grattandata")`. This should open a tab in your web
browser - click ‘HTML’.
