## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE----------------------------------------------------------
#  vista <- read_microdata("/Users/jnolan1/Dropbox (Grattan Institute)/data/microdata/victoria/vista/2009/csv/JourneyToWork_VISTA09_v3_VISTA_Online.csv")

## ----eval=FALSE----------------------------------------------------------
#  # If the `remotes` package is not installed, install it
#  if(!require(remotes)) {
#    install.packages("remotes")
#  }
#  
#  # Install `grattandata` from GitHub using remotes
#  remotes::install_github("grattan/grattandata",
#                          dependencies = TRUE, upgrade = "always")

## ----setup---------------------------------------------------------------
library(grattandata)

## ----eval=FALSE----------------------------------------------------------
#  vista <- read_microdata("P_VISTA12_16_SA1_V1.csv")
#  
#  vista <- read_microdata("csv/P_VISTA12_16_SA1_V1.csv")
#  
#  vista <- read_microdata("victoria/vista/2009/csv/P_VISTA12_16_SA1_V1.csv")
#  

## ----error=TRUE----------------------------------------------------------
vista <- read_microdata("VISTA12_16_")


## ----eval=FALSE----------------------------------------------------------
#  vista <- read_microdata("P_VISTA12_16_SA1_V1.csv",skip = 5)

