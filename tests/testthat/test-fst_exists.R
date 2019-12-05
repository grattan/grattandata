library(microbenchmark)

test_that("fst functions work", {

  skip_on_travis()
  skip_on_cran()

  stata_path <- find_filename("SIH17bh.dta")
  fst_path <- construct_fst_path(stata_path)
  expect_match(fst_path,
               file.path("data", "microdata", "abs", "sih", "2017-18", "Stata",
                         "fst", paste0("SIH17BH.fst")))

  expect_equal(file.exists(fst_path),
               fst_exists(stata_path))

  stata_file <- read_microdata("SIH17bh.dta", fast = FALSE)
  fst_file <- read_microdata("SIH17bh.dta", fast = TRUE)

  expect_true(all.equal(stata_file, fst_file, check.attributes = FALSE))

  set.seed(123)
  timings <- microbenchmark(slow = read_microdata("SIH17bh.dta",
                                                  fast = FALSE),
                            fast = read_microdata("SIH17bh.dta",
                                                  fast = TRUE),
                                      times = 10)

  timing_ratio <- mean(timings$time[timings$expr == "slow"]) /
    mean(timings$time[timings$expr == "fast"])

  expect_gt(timing_ratio, 8)

})
