test_that("read_microdata() can load non-warehouse data from path defined with add_microdata_location()", {
  temp_data <- tempfile(fileext = ".csv")
  on.exit(unlink(temp_data))
  
  temp_dir <- dirname(temp_data)
  fake_data <- data.frame(x = sample(0:9, size = 1000, replace = TRUE))
  write.csv(fake_data, temp_data, row.names = FALSE)
  
  manually_loaded_data <- rio::import(temp_data, setclass = "tbl_df")
  
  add_microdata_location(path = temp_dir)
  
  loaded_with_package <- read_microdata(basename(temp_data))
  
  expect_equal(manually_loaded_data, loaded_with_package)
})
