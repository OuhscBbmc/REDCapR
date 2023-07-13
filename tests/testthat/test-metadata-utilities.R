library(testthat)

test_that("Named Captures", {
  pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\x20-\x7B\x7D-\x7E]{1,})(?= \\| |\\Z)"

  choices_1 <- "1, American Indian/Alaska Native | 2, Asian | 3, Native Hawaiian or Other Pacific Islander | 4, Black or African American | 5, White | 6, Unknown / Not Reported"
  ds_boxes <- regex_named_captures(pattern=pattern_checkboxes, text=choices_1)

  ds_expected <- structure(
    list(
      id = c("1", "2", "3", "4", "5", "6"),
      label = c("American Indian/Alaska Native", "Asian", "Native Hawaiian or Other Pacific Islander", "Black or African American", "White", "Unknown / Not Reported")
    ),
    class = c("tbl_df", "tbl", "data.frame"),
    row.names = c(NA, -6L)
  )

  expect_equal(ds_boxes, expected=ds_expected, label="The returned data.frame should be correct") #dput(ds_boxes)
  expect_s3_class(ds_boxes, "tbl")
})

test_that("checkbox choices", {
  choices_1 <- "1, American Indian/Alaska Native | 2, Asian | 3, Native Hawaiian or Other Pacific Islander | 4, Black or African American | 5, White | 6, Unknown / Not Reported"
  ds_boxes <- checkbox_choices(select_choices=choices_1)

  ds_expected <- structure(
    list(
      id = c("1", "2", "3", "4", "5", "6"),
      label = c("American Indian/Alaska Native", "Asian", "Native Hawaiian or Other Pacific Islander", "Black or African American", "White", "Unknown / Not Reported")
    ),
    class = c("tbl_df", "tbl", "data.frame"),
    row.names = c(NA, -6L)
  )

  expect_equal(ds_boxes, expected=ds_expected, label="The returned data.frame should be correct") #dput(ds_boxes)
  expect_s3_class(ds_boxes, "tbl")
})


test_that("checkbox choices with special characters", {
  choices_1 <- "1, Hospital A | 2, Hospitäl B | 3, Hospital Ç | 4, Hospítal D"
  ds_boxes <- checkbox_choices(select_choices=choices_1)

  ds_expected <- structure(
    list(
      id = c("1", "2", "3", "4"),
      label = c("Hospital A", "Hospitäl B", "Hospital Ç", "Hospítal D")
    ),
    class = c("tbl_df", "tbl", "data.frame"),
    row.names = c(NA, -4L)
  )

  expect_equal(ds_boxes, expected=ds_expected, label="The returned data.frame should be correct")
  expect_s3_class(ds_boxes, "tbl")
})

###############################################################################
# Test case where a leading space in front of a checkbox option results in the
# choices string missing a space.
#
# Options set in REDCap, note leading space on option 3
# 1, Depressive mood disorder
# 2, Adjustment disorder
#  3, Personality disorder
# 4, Anxiety
# 0, Not Noted
#
# Previous behavior would result in options 2 and 3 being omitted from the
# choices.
#
# Seen specifically in REDCap 13.7.5 but likely the same behavior in other
# REDCap versions
###############################################################################
test_that("checkbox choices with errant space", {
  choices_1 <- "1, Depressive mood disorder | 2, Adjustment disorder| 3, Personality disorder | 4, Anxiety | 0, Not Noted"
  ds_boxes <- checkbox_choices(select_choices=choices_1)

  ds_expected <- structure(
    list(
      id = c("1", "2", "3", "4", "0"),
      label = c("Depressive mood disorder", "Adjustment disorder", "Personality disorder", "Anxiety", "Not Noted")
    ),
    class = c("tbl_df", "tbl", "data.frame"),
    row.names = c(NA, -5L)
  )

  expect_equal(ds_boxes, expected=ds_expected, label="The returned data.frame should be correct")
  expect_s3_class(ds_boxes, "tbl")
})
