# grattandata
Easily load microdata from the Grattan Institute data warehouse in R. Users will require access to the Grattan Institute data warehouse.

# Install grattandata

```
# If the `remotes` package is not installed, install it
if(require(remotes)) {
  install.packages("remotes")
}

# Install `grattandata` from GitHub using remotes
remotes::install_github("mattcowgill/grattandata",
                        dependencies = TRUE, upgrade = "always")
```

# Read microdata with read_microdata()

Working examples:

```
sih_1516 <- read_microdata("SIH15bh.dta")

sih_1516 <- read_microdata("Stata/sih15bh.dta")

sih_1516 <- read_microdata("ABS/SIH/2015-16/Stata/SIH15BH.dta")

```
