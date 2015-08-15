library(testthat)

###########
context("Sanitize")
###########

test_that("dry_run", {
  dirty <- data.frame(id=seq_along(letters), names=letters, stringsAsFactors=FALSE) #These aren't really dirty.  And should have no conversion problems
  
  expected <- structure(list(id = as.character(1:26), names = letters), 
                        .Names = c("id", "names"), row.names = c(NA, -26L), class = "data.frame")
  observed <- REDCapR::redcap_column_sanitize(dirty)
  expect_equal(observed, expected, label="The dry-runsanitized values should be correct.")
})

test_that("sanitize_last_names", {
  testthat::skip_on_cran()
  # These tests come from the 'encoding.R" tests (https://svn.r-project.org/R/trunk/tests/) in base R.  
  #   They're just smoke tests, and don't compare any real values.  
  #   So I don't feel compelled to either.  It was having some localization issues too.
  dirty <- data.frame(id=1:3, names=c("Ekstr\xf8m", "J\xf6reskog", "bi\xdfchen Z\xfcrcher"))
  
  expected_linux <- structure(list(id = c("1", "2", "3"), names = c("Ekstr?m", "Joreskog", 
    "bisschen Zurcher")), .Names = c("id", "names"), row.names = c(NA, 
    -3L), class = "data.frame")
  
  expected_windows <- structure(list(id = c("1", "2", "3"), names = c("Ekstrom", "Joreskog", 
    "bi?chen Zurcher")), .Names = c("id", "names"), row.names = c(NA, 
    -3L), class = "data.frame")
  
  #The different OSes can have subtly different conversions, b/c they're based on different underlying conversion libraries.
  if( Sys.info()["sysname"]=="Windows" ) {
    expected <- expected_windows
  } else {
    expected <- expected_linux
  }

  observed <- REDCapR::redcap_column_sanitize(dirty)
  expect_equal(observed, expected, label="The sanitized values should be correct.")
})
