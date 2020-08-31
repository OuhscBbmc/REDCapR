# Modeled after the R6 testing structure: https://github.com/wch/R6/blob/master/tests/testthat.R
library(testthat)
library(REDCapR)

# source("R/helpers-testing.R")
testthat::test_check("REDCapR")
