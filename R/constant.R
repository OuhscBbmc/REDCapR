#' @name constant
#'
#' @title Collection of REDCap-specific constants
#'
#' @description Collection of constants defined by the REDCap developers.
#'
#' @param name Name of constant.  Required character.
#' @param simplify Simplifies the vector of values to a common data-type, if possible.  Passed to the `simplify` parameter of [base::sapply()].
#'
#' @return The constant's value.  Currently all are single integers, but that could be expanded in the future.
#'
#' @details
#' The current constants relate to the 'complete' variable at the end of each form.
#'   * `form_incomplete`: 0L (*i.e.*, an integer)
#'   * `form_unverified`: 1L
#'   * `form_complete`: 2L
#'
#' To add more, please for and edit the
#' [constant.R](https://github.com/OuhscBbmc/REDCapR/blob/master/R/constant.R)
#' on GitHub and submit a pull request.  For instructions, please see
#' [Editing files in another user's repository](https://help.github.com/articles/editing-files-in-another-user-s-repository/)
#' in the GitHub documentation.
#'
#' @author Will Beasley
#'
#' @examples
#'
#' REDCapR::constant("form_incomplete")  # Returns 0L
#' REDCapR::constant("form_unverified")  # Returns 1L
#' REDCapR::constant("form_complete")    # Returns 2L
#'
#' REDCapR::constant(c("form_complete", "form_complete", "form_incomplete")) # Returns c(2L, 2L, 0L)
#'
#' \dontrun{
#' # The following line returns an error:
#' #     Assertion on 'name' failed: Must be a subset of
#' #     {'form_complete','form_incomplete','form_unverified'},
#' #     but is {'bad-name'}.
#'
#' REDCapR::constant("bad-name")    # Returns an error
#'
#' REDCapR::constant(c("form_complete", "bad-name")) # Returns an error
#' }

#' @export
constant <- function( name, simplify=TRUE ) {
  checkmate::assert_character(name, any.missing=F, min.chars=1L)
  checkmate::assert_subset(name, names(constant_list), empty.ok=F)
  checkmate::assert_logical(simplify, any.missing=F, len=1L)

  # return( constant_list[[name]] )
  sapply(
    X         = name,
    FUN       = function( x ) constant_list[[x]],
    USE.NAMES = FALSE,
    simplify  = simplify
  )
}

# To add REDCap-specific constants, modify the list below.
#     This list is intentionally not exported.
constant_list <- list(
  form_incomplete       = 0L,
  form_unverified       = 1L,
  form_complete         = 2L
)
