library(testthat)
context("Metadata Utilities")

test_that("Named Captures", {
  pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\x20-\x7B\x7D-\x7E]{1,})(?= \\| |\\Z)"
  
  choices_1 <- "1, American Indian/Alaska Native | 2, Asian | 3, Native Hawaiian or Other Pacific Islander | 4, Black or African American | 5, White | 6, Unknown / Not Reported"
  dsBoxes <- regex_named_captures(pattern=pattern_checkboxes, text=choices_1)
  
  dsExpected <- structure(list(id = c("1", "2", "3", "4", "5", "6"), label = c("American Indian/Alaska Native", 
    "Asian", "Native Hawaiian or Other Pacific Islander", "Black or African American", 
    "White", "Unknown / Not Reported")), .Names = c("id", "label"
    ), row.names = c(NA, -6L), class = "data.frame")
  
  expect_equal(dsBoxes, expected=dsExpected, label="The returned data.frame should be correct") #dput(dsBoxes)
})

test_that("Named Captures", {
  pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\x20-\x7B\x7D-\x7E]{1,})(?= \\| |\\Z)"
  
  choices_1 <- "1, American Indian/Alaska Native | 2, Asian | 3, Native Hawaiian or Other Pacific Islander | 4, Black or African American | 5, White | 6, Unknown / Not Reported"
  dsBoxes <- checkbox_choices(select_choices=choices_1)
  
  dsExpected <- structure(list(id = c("1", "2", "3", "4", "5", "6"), label = c("American Indian/Alaska Native", 
    "Asian", "Native Hawaiian or Other Pacific Islander", "Black or African American", 
    "White", "Unknown / Not Reported")), .Names = c("id", "label"
    ), row.names = c(NA, -6L), class = "data.frame")
  
  expect_equal(dsBoxes, expected=dsExpected, label="The returned data.frame should be correct") #dput(dsBoxes)
})
