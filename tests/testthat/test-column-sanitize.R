library(testthat)
context("Sanitize")

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
  expected_ubuntu_1     <- c("Ekstr?m", "Joreskog", "bisschen Zurcher")
  expected_ubuntu_2     <- c("Ekstrom", "--"      , "--"              )
  expected_fedora       <- c("Ekstrom", "Joreskog", "bisschen Zurcher")
  expected_windows      <- c("Ekstrom", "Joreskog", "bi?chen Zurcher" )

  dirty <- data.frame(id=1:3, names=c("Ekstr\xf8m", "J\xf6reskog", "bi\xdfchen Z\xfcrcher"))
  observed <- REDCapR::redcap_column_sanitize(dirty)$names

  #The different OSes can have subtly different conversions, b/c they're based on different underlying conversion libraries.
  if( Sys.info()["sysname"]=="Windows" ) {
    expect_equal(observed, expected_windows, label="The sanitized values should be correct.")
  } else if ( grepl("^Fedora", sessionInfo()$running) ) {
    expect_equal(observed, expected_fedora, label="The sanitized values should be correct.")
  } else {
    fits_ubuntu <- any(observed==expected_ubuntu_1 | observed==expected_ubuntu_2)
    expect_true(fits_ubuntu, label="One of the possible Ubuntu matches should be correct.")
  }

})
