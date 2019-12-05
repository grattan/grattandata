test_that("find_filename finds filename", {
  skip_on_travis()
  skip_on_cran()

  expect_is(find_filename("SIH15bh.dta"), "character")

  expect_true(file.exists(find_filename("SIH15bh.dta")))

  expect_error(find_filename("SIH"))
  expect_error(find_filename("census.zip"))
  expect_error(find_filename("SIH15BL_FREQ.txt"))
})
