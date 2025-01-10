skip_if_onlyread <- function() {
  if (identical(Sys.getenv("ONLY_READ_TESTS"), "")) {
    return(invisible(TRUE))
  }

  testthat::skip("Skipping test if only server reads/exports are used. (And server writes/imports are skipped.)" )
}

# These internal/nonvisible function is copied from
# https://github.com/r-lib/testthat/blob/690fdb87ed8db5411ef80c0d041a188853cd7050/R/skip.R#L257
on_cran <- function() {
  !interactive() && !env_var_is_true("NOT_CRAN")
}

# These internal/invisible function is copied from
# https://github.com/r-lib/testthat/blob/690fdb87ed8db5411ef80c0d041a188853cd7050/R/skip.R#L257
env_var_is_true <- function(x) {
  isTRUE(as.logical(Sys.getenv(x, "false")))
}
