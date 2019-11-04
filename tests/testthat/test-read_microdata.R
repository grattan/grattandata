test_that("check_dropbox_access() works", {
  skip_on_travis()
  skip_on_cran()
  
  expect_true(check_dropbox_access())
  
  expect_message(check_dropbox_access(), regexp = "You appear to")
  
})

test_that("find_filename finds filename", {
  skip_on_travis()
  skip_on_cran()

  expect_is(find_filename("SIH15bh.dta"), "character")

  expect_true(file.exists(find_filename("SIH15bh.dta")))

  expect_error(find_filename("SIH"))
})

test_that("Dropbox location can be found", {
  skip_on_travis()
  skip_on_cran()

  expect_is(get_dropbox_location(), "character")

  expect_true(dir.exists(get_dropbox_location()))
})

test_that("read_microdata loads SIH 2015-16", {
  skip_on_travis()
  skip_on_cran()

  sih_15_16 <- read_microdata("SIH15BH.dta")

  expect_is(sih_15_16, "tbl_df")

  expect_equal(nrow(sih_15_16), 17768)

  sih_15_16_mixed_case <- read_microdata("sIh15bH.dta")

  expect_true(all.equal(sih_15_16, sih_15_16_mixed_case))

  sih_15_16_withpath <- read_microdata("abs/SIH/2015-16/Stata/SIH15BH.dta")

  expect_true(all.equal(sih_15_16, sih_15_16_withpath))
})

test_that("read_microdata fails with multiple matches", {
  skip_on_travis()
  skip_on_cran()

  expect_error(read_microdata("SIH15BH"))
})

test_that("read_microdata fails with no matches", {
  skip_on_travis()
  skip_on_cran()

  fake_filename <- paste0(paste0(sample(letters, 10), collapse = ""), ".dta")

  expect_error(read_microdata(fake_filename))
})

test_that("read_microdata fails with non-character filename", {
  skip_on_travis()
  skip_on_cran()

  expect_error(read_microdata(1))
})


test_that("read_microdata fails with vector input to filename", {
  skip_on_travis()
  skip_on_cran()

  expect_error(read_microdata(c("SIH15bh.dta", "SIH15bp.dta")))
})
