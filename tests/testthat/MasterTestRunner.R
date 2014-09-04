###
### Remember to build the package first, so the tests get copied to the package directory.
###

rm(list=ls(all=TRUE)) #Clear all the variables before starting a new run.

require(testthat)
require(devtools)

#directoryTests <- file.path(devtools::inst("REDCapR"), "tests/testthat")
directoryTests <- file.path(devtools::inst("REDCapR"), "tests")

ClearMostVariables <- function( ) {
  rm(list=ls(all=TRUE)[!(ls(all=TRUE) %in% c("ClearMostVariables", "directoryTests"))])
}

try(detach("package:REDCapR"), silent=TRUE)
require(REDCapR)
#?REDCapR

ClearMostVariables()
test_file(file.path(directoryTests, "test-read.R"))
