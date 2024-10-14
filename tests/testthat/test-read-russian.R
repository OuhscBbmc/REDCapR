library(testthat)

credential  <- retrieve_credential_testing("russian")

test_that("Russian Recruit", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token)
  )

  d <- returned_object$data
  # d$recruitment_other
  # message(d$recruitment_other)

  expected_single <- "от сотрудницы"
  expected_multiple <- c("от сотрудницы", "мама и сестра", "подруга по общежитию")
  # expected_multiple <- c("a", "b", "c")
  # Encoding(expected_multiple) <- "latin1"
  # Sys.getlocale()
  # Experiment w/ Joe Cheng's answer at https://stackoverflow.com/questions/5031630/how-to-source-r-file-saved-using-utf-8-encoding

  # expect_equal(d$recruitment_other[1], expected_single)
  # expect_equal(d$recruitment_other, expected_multiple)
})

# test_that("Russian Encoded", {
#   testthat::skip_on_cran()
#   expect_message(
#     returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token)
#   )
#
#   d <- returned_object$data
#   d$recruitment_other
#
#   expected <- c("<U+043E><U+0442> <U+0441><U+043E><U+0442><U+0440><U+0443><U+0434><U+043D><U+0438><U+0446><U+044B>",
#                 "<U+043C><U+0430><U+043C><U+0430> <U+0438> <U+0441><U+0435><U+0441><U+0442><U+0440><U+0430>",
#                 "<U+043F><U+043E><U+0434><U+0440><U+0443><U+0433><U+0430> <U+043F><U+043E> <U+043E><U+0431><U+0449><U+0435><U+0436><U+0438><U+0442><U+0438><U+044E>")
#   iconv("н", "UTF-8")
#   iconv("s", "UTF-8")
#   iconv(d$recruitment_other, "latin1", "ASCII", sub = "byte")
#   expect_equal(d$recruitment_other, expected)
# })

rm(credential)
