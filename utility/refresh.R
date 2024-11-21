rm(list = ls(all.names = TRUE))
deviceType <- ifelse(R.version$os=="linux-gnu", "X11", "windows")
options(device = deviceType) #https://support.rstudio.org/help/discussions/problems/80-error-in-function-only-one-rstudio-graphics-device-is-permitted

spelling::spell_check_package()
# spelling::update_wordlist()
urlchecker::url_check(); urlchecker::url_update()

devtools::document()
devtools::check_man() #Should return NULL
devtools::clean_vignettes()
devtools::build_vignettes()

lintr::lint_package()
# lintr::lint("R/redcap-metadata-coltypes.R")
checks_to_exclude <- c(
  "covr",
  "cyclocomp",
  "lintr_line_length_linter"
)
gp <-
  goodpractice::all_checks() |>
  purrr::discard(~(. %in% checks_to_exclude)) |>
  {
    \(checks)
    goodpractice::gp(checks = checks)
  }()
goodpractice::results(gp)
gp
# If necessary: tinytex::tlmgr_install("makeindex")
BiocCheck::BiocCheck()
# styler::style_pkg()
# styler::style_file("R/redcap-read-oneshot.R")

devtools::document()
pkgdown::clean_site()
# pkgdown::build_articles() # preview the vignettes
pkgdown::build_site(run_dont_run = TRUE)
# system("R CMD Rd2pdf --no-preview --force --output=./documentation-peek.pdf ." )

devtools::run_examples(); #dev.off() #This overwrites the NAMESPACE file too
# devtools::run_examples(, "redcap_read.Rd")
# pkgload::load_all()
test_results_checked <- devtools::test()
test_results_checked <- devtools::test(filter = "^sanitize")
# withr::local_envvar(ONLYREADTESTS = "true")
# test_results_checked <- devtools::test(filter = "write-batch")

# testthat::test_dir("./tests/")
test_results_not_checked <- testthat::test_dir("./tests/manual/")

# devtools::check(force_suggests = FALSE)
devtools::check(cran=TRUE)
devtools::check( # Equivalent of R-hub
  manual    = TRUE,
  remote    = TRUE,
  incoming  = TRUE
)
# devtools::check_win_devel() # CRAN submission policies encourage the development version
# Check Rhub at <https://github.com/OuhscBbmc/REDCapR/actions/workflows/rhub.yaml>
# Check reverse dependencies at <https://github.com/OuhscBbmc/REDCapR/actions/workflows/recheck.yml>
#   Old way: revdepcheck::revdep_check(num_workers = 4)
# usethis::use_release_issue()
# devtools::release(check=FALSE) #Careful, the last question ultimately uploads it to CRAN, where you can't delete/reverse your decision.
