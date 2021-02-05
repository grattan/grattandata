test_that("find_alias behaves as expected", {
  
  skip_on_cran()
  skip_on_ci()
  
  expect_match(find_alias("survey of income and housing"), 
               "sih")
  
  expect_match(find_alias("survey of and housing"), 
               "sih")
  
  expect_match(find_alias("sovey income"), 
               "sih")
  
  expect_match(find_alias("expenditure"), 
               "hes")
  
  expect_equal(find_alias("blah blah some string"),
            NA_character_)
  
})
