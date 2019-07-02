test_that("read_microdata loads SIH 2015-16", {

  skip_on_travis()

  sih_15_16 <- read_microdata("ABS/SIH/2015-16/Stata/SIH15BH.dta")

  expect_is(sih_15_16, "tbl_df")

  expect_equal(nrow(sih_15_16), 17768)

})
