rm(list=ls(all=TRUE))
# library(devtools)
deviceType <- ifelse(R.version$os=="linux-gnu", "X11", "windows")
options(device = deviceType) #http://support.rstudio.org/help/discussions/problems/80-error-in-function-only-one-rstudio-graphics-device-is-permitted

devtools::document()
devtools::check_doc() #Should return NULL
system("R CMD Rd2pdf --no-preview --force --output=./DocumentationPeek.pdf ." )

devtools::run_examples(); #dev.off() #This overwrites the NAMESPACE file too
# devtools::run_examples(, "redcap_read.Rd")
test_results_checked <- devtools::test()
# test_results_checked <- devtools::test(filter = "read_b.*")
# test_results_checked <- devtools::test(filter = "write.*")
# testthat::test_dir("./tests/")
test_results_not_checked <- testthat::test_dir("./tests/manual/")
devtools::build_vignettes()

# system("R CMD build --resave-data .") #Then move it up one directory.
# tarBallPattern <- "^REDCapR_.+\\.tar\\.gz$"
# file.copy(from=list.files(pattern=tarBallPattern), to="../", overwrite=TRUE)
# system(paste("R CMD check --as-cran", list.files(pattern=tarBallPattern, path="..//", full.names=TRUE)))
# unlink(list.files(pattern=tarBallPattern))
# unlink(list.files(pattern=tarBallPattern, path="..//", full.names=TRUE))
# unlink("REDCapR.Rcheck", recursive=T)
# system("R CMD check --as-cran D:/Projects/RDev/NlsyLinksStaging/NlsyLinks_1.300.tar.gz")

# devtools::check(force_suggests = FALSE)
# devtools::build_win(version="R-devel") #CRAN submission policies encourage the development version
# devtools::revdep_check(pkg="REDCapR", recursive=TRUE)
# devtools::release(check=FALSE) #Careful, the last question ultimately uploads it to CRAN, where you can't delete/reverse your decision.
