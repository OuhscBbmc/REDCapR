# Modeled after the R6 testing structure: https://github.com/r-lib/R6/blob/main/tests/testthat.R
library(testthat)
library(REDCapR)
# source("R/helpers-testing.R")

Sys.setenv("redcapr_test_server" = "dev-2")
message("Using test server '", Sys.getenv("redcapr_test_server"), "'.")
testthat::test_check("REDCapR")

# Sys.setenv("redcapr_test_server" = "bbmc")
# message("Using test server '", Sys.getenv("redcapr_test_server"), "'.")
# testthat::test_check("REDCapR")

# Sys.setenv("redcapr_test_server" = "coph")
# message("Using test server '", Sys.getenv("redcapr_test_server"), "'.")
# testthat::test_check("REDCapR")
