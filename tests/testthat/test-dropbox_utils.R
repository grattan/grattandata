test_that("Dropbox location can be found", {
  skip_on_travis()
  skip_on_cran()

  expect_is(get_dropbox_location(), "character")

  expect_true(dir.exists(get_dropbox_location()))
})

test_that("check_dropbox_location() gives expected message", {
  skip_on_travis()
  skip_on_cran()

  expect_message(check_dropbox_access(),
                 "You appear to have access to the Grattan data warehouse")

  result_of_dropbox_check <- suppressMessages(check_dropbox_access())
  expect_true(result_of_dropbox_check)
})
