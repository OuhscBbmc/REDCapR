skip_if_onlyread <- function() {
  if (identical(Sys.getenv("ONLY_READ_TESTS"), "")) {
    return(invisible(TRUE))
  }

  testthat::skip("Skipping test if only server reads/exports are used. (And server writes/imports are skipped.)" )
}
