rm(list=ls(all=TRUE))
# library(devtools)
deviceType <- ifelse(R.version$os=="linux-gnu", "X11", "windows")
options(device = deviceType) #http://support.rstudio.org/help/discussions/problems/80-error-in-function-only-one-rstudio-graphics-device-is-permitted

devtools::document()
devtools::check_man() #Should return NULL
system("R CMD Rd2pdf --no-preview --force --output=./documentation-peek.pdf ." )

devtools::run_examples(); #dev.off() #This overwrites the NAMESPACE file too
# devtools::run_examples(, "redcap_read.Rd")
test_results_checked <- devtools::test()
# test_results_checked <- devtools::test(filter = "read-errors*")
# testthat::test_dir("./tests/")
test_results_not_checked <- testthat::test_dir("./tests/manual/")
devtools::build_vignettes()

# devtools::check(force_suggests = FALSE)
# devtools::build_win(version="R-devel") #CRAN submission policies encourage the development version
# devtools::revdep_check(pkg="REDCapR", recursive=TRUE)
# devtools::release(check=FALSE) #Careful, the last question ultimately uploads it to CRAN, where you can't delete/reverse your decision.
