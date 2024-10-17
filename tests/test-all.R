# Modeled after the R6 testing structure: https://github.com/wch/R6/blob/master/tests/testthat.R
library(testthat)
library(REDCapR)

Sys.setenv("redcapr_test_server" = "dev-2")

message("Using test server '", Sys.getenv("redcapr_test_server"), "'.")

# source("R/helpers-testing.R")
testthat::test_check("REDCapR")
