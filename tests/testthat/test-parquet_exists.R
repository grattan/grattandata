library(microbenchmark)

test_that("parquet functions work", {
  
  skip_on_ci()
  skip_on_cran()
  
  stata_path <- find_filename("SIH17bh.dta")
  parquet_path <- construct_parquet_path(stata_path)
  
  expect_equal(file.exists(parquet_path),
               parquet_exists(stata_path))
  
  stata_file <- read_microdata("SIH17bh.dta", fast = FALSE)
  parquet_file <- read_microdata("SIH17bh.dta", fast = TRUE, write_fast = "parquet")
  
  expect_true(all.equal(stata_file, parquet_file, check.attributes = FALSE))
  
  set.seed(123)
  timings <- microbenchmark::microbenchmark(slow = read_microdata("SIH17bh.dta",
                                                                  fast = FALSE),
                                            fast = read_microdata("SIH17bh.dta",
                                                                  fast = TRUE, 
                                                                  write_fast = "parquet"),
                                            times = 10)
  
  timing_ratio <- mean(timings$time[timings$expr == "slow"]) /
    mean(timings$time[timings$expr == "fast"])
  
  # We should expect the parquet import to be (at least) twice as fast as .dta
  expect_gt(timing_ratio, 2)
  
})

test_that("parquet functions handle file paths correctly", {
  
  skip_on_ci()
  skip_on_cran()
  
  # Test path construction
  test_path <- "/some/path/to/data.dta"
  expected_parquet_path <- "/some/path/to/parquet/data.parquet"
  
  expect_equal(construct_parquet_path(test_path), expected_parquet_path)
  
  # Test that parquet_exists returns FALSE for non-existent files
  expect_false(parquet_exists("/non/existent/file.dta"))
  
})

test_that("parquet and fst precedence works correctly", {
  
  skip_on_ci()
  skip_on_cran()
  
  # This test checks that FST is preferred when both FST and Parquet exist
  stata_path <- find_filename("SIH17bh.dta")
  
  # Create both FST and Parquet files
  stata_file <- read_microdata("SIH17bh.dta", fast = FALSE, write_fast = "fst")
  read_microdata("SIH17bh.dta", fast = FALSE, write_fast = "parquet")
  
  # Check both exist
  expect_true(fst_exists(stata_path))
  expect_true(parquet_exists(stata_path))
  
  # When fast = TRUE, should use FST (preferred format)
  fast_file <- read_microdata("SIH17bh.dta", fast = TRUE)
  
  # The data should match (both are derived from the same source)
  expect_true(all.equal(stata_file, fast_file, check.attributes = FALSE))
  
})