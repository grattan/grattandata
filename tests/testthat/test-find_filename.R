test_that("find_filename finds filename", {
  skip_on_ci()
  skip_on_cran()

  expect_is(find_filename("SIH15bh.dta"), "character")
  
  # When requesting a .zip file, function should return it
  expect_is(find_filename("census.zip"), "character")
  
  expect_true(file.exists(find_filename("census.zip")))

  expect_true(file.exists(find_filename("SIH15bh.dta")))

  expect_error(find_filename("SIH15BL_FREQ.txt"))
})
