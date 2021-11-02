# test_that("skip_if_onlyread set", {
#   # Test that a skip happens
#   withr::local_envvar(ONLY_READ_TESTS = "yes")
#   expect_condition(skip_if_onlyread(), class = "skip")
# })
#
# test_that("skip_if_onlyread not set", {
#   # Test that a skip doesn't happen
#   withr::local_envvar(ONLY_READ_TESTS = "")
#   expect_condition(skip_if_onlyread(), NA, class = "skip")
# })
