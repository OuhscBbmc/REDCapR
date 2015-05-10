library(testthat)

###########
context("Sanitize")
###########

test_that("sanitize_last_names", {
  dirty <- data.frame(id=1:3, names=c("Ekstr\xf8m", "J\xf6reskog", "bi\xdfchen Z\xfcrcher"))
  expected <- structure(list(id = c("1", "2", "3"), names = c("Ekstr?m", "Joreskog", 
    "bisschen Zurcher")), .Names = c("id", "names"), row.names = c(NA, 
    -3L), class = "data.frame")

  observed <- REDCapR::redcap_column_sanitize(dirty)
  expect_equal(observed, expected, label="The sanitized values should be correct.")
})
