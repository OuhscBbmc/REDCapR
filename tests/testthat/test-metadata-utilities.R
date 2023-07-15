library(testthat)

test_that("Named Captures", {
  pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\x20-\x7B\x7D-\x7E]{1,})(?= \\| |\\Z)"

  ds_expected <-
    tibble::tribble(
      ~id,                                      ~label,
      "1",             "American Indian/Alaska Native",
      "2",                                     "Asian",
      "3", "Native Hawaiian or Other Pacific Islander",
      "4",                 "Black or African American",
      "5",                                     "White",
      "6",                    "Unknown / Not Reported"
    )

  choices_1 <- "1, American Indian/Alaska Native | 2, Asian | 3, Native Hawaiian or Other Pacific Islander | 4, Black or African American | 5, White | 6, Unknown / Not Reported"
  ds_boxes <- regex_named_captures(pattern=pattern_checkboxes, text=choices_1)

  expect_equal(ds_boxes, expected=ds_expected, label="The returned data.frame should be correct") #dput(ds_boxes)
  expect_s3_class(ds_boxes, "tbl")
})

test_that("checkbox choices -digits", {
  ds_expected <-
    tibble::tribble(
      ~id,                                      ~label,
      "1",             "American Indian/Alaska Native",
      "-2",                                    "Asian",
      "3", "Native Hawaiian or Other Pacific Islander",
      "4",                 "Black or African American",
      "5",                                     "White",
      "66",                   "Unknown / Not Reported"
    )

  # well-behaved
  "1, American Indian/Alaska Native | -2, Asian | 3, Native Hawaiian or Other Pacific Islander | 4, Black or African American | 5, White | 66, Unknown / Not Reported" |>
    checkbox_choices() |>
    expect_equal(ds_expected, label = "well-behaved:")

  # no leading spaces
  "1, American Indian/Alaska Native |-2, Asian |3, Native Hawaiian or Other Pacific Islander |4, Black or African American |5, White |66, Unknown / Not Reported" |>
    checkbox_choices() |>
    expect_equal(ds_expected, label = "no leading spaces:")

  # no trailing spaces
  "1, American Indian/Alaska Native| -2, Asian| 3, Native Hawaiian or Other Pacific Islander| 4, Black or African American| 5, White| 66, Unknown / Not Reported" |>
    checkbox_choices() |>
    expect_equal(ds_expected, label = "no trailing spaces:")
})

test_that("checkbox choices -letters", {
  ds_expected <- # datapasta::tribble_paste(ds_expected)
    tibble::tribble(
      ~id,                                      ~label,
      "a",             "American Indian/Alaska Native",
      "b",                                     "Asian",
      "c", "Native Hawaiian or Other Pacific Islander",
      "dd",                "Black or African American",
      "eee",                                   "White",
      "f",                    "Unknown / Not Reported"
    )

  # well-behaved
  "a, American Indian/Alaska Native | b, Asian | c, Native Hawaiian or Other Pacific Islander | dd, Black or African American | eee, White | f, Unknown / Not Reported" |>
    checkbox_choices() |>
    expect_equal(ds_expected, label = "well-behaved:")

  # no leading spaces
  "a, American Indian/Alaska Native |b, Asian |c, Native Hawaiian or Other Pacific Islander |dd, Black or African American |eee, White |f, Unknown / Not Reported" |>
    checkbox_choices() |>
    expect_equal(ds_expected, label = "no leading spaces:")

  # no trailing spaces
  "a, American Indian/Alaska Native| b, Asian| c, Native Hawaiian or Other Pacific Islander| dd, Black or African American| eee, White| f, Unknown / Not Reported" |>
    checkbox_choices() |>
    expect_equal(ds_expected, label = "no trailing spaces:")
})


test_that("checkbox choices with special characters", {

  ds_boxes <- checkbox_choices(select_choices=choices_1)

  ds_expected <- # datapasta::tribble_paste(ds_expected)
    tibble::tribble(
      ~id,       ~label,
      "1", "Hospital A",
      "2", "Hospitäl B",
      "3", "Hospital Ç",
      "4", "Hospítal D"
    )

  "1, Hospital A | 2, Hospitäl B | 3, Hospital Ç | 4, Hospítal D" |>
    checkbox_choices() |>
    expect_equal(ds_expected)
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
  ds_expected <-
    tibble::tribble(
      ~id,                     ~label,
      "1", "Depressive mood disorder",
      "2",      "Adjustment disorder",
      "3",     "Personality disorder",
      "4",                  "Anxiety",
      "0",                "Not Noted"
     )

  "1, Depressive mood disorder | 2, Adjustment disorder| 3, Personality disorder | 4, Anxiety | 0, Not Noted" |>
    checkbox_choices() |> # datapasta::tribble_paste()
    expect_equal(ds_expected)
})
