#' @name constant
#'
#' @aliases
#' constant constant_to_form_completion constant_to_form_rights
#' constant_to_export_rights constant_to_access
#'
#' @title
#' Collection of REDCap-specific constants
#'
#' @description
#' Collection of constants defined by the REDCap developers.
#'
#' @param name Name of constant.  Required character.
#'
#' @return
#' The constant's value.  Currently all are single integers,
#' but that could be expanded in the future.
#'
#' @details
#` Constants have the following groupings.
#'
#' **Form Completeness**
#'
#' The current constants relate to the 'complete' variable at the
#' end of each form.
#' * `form_incomplete`: 0L (_i.e._, an integer)
#' * `form_unverified`: 1L
#' * `form_complete`: 2L
#'
#' **Export Rights**
#'
#' See https://your-server/redcap/api/help/?content=exp_users.
#' * `data_export_rights_no_access`    : 0L
#' * `data_export_rights_deidentified` : 1L
#' * `data_export_rights_full`         : 2L
#'
#' **Form Rights**
#'
#' See https://your-server/redcap/api/help/?content=exp_users.
#' The order of these digits may be unexpected.
#'
#' * `form_rights_no_access`    : 0L
#' * `form_rights_readonly`     : 2L
#' * `form_rights_edit_form`    : 1L
#' * `form_rights_edit_survey`  : 3L
#'
#' **Access Rights**
#'
#' See https://your-server/redcap/api/help/?content=exp_users.
#' * `access_no`    : 0L
#' * `access_yes`   : 1L
#'
#' To add more, please for and edit
#' [constant.R](https://github.com/OuhscBbmc/REDCapR/blob/master/R/constant.R)
#' on GitHub and submit a pull request.  For instructions, please see
#' [Editing files in another user's repository](https://docs.github.com/articles/editing-files-in-another-user-s-repository/) # nolint
#' in the GitHub documentation.
#'
#' @author
#' Will Beasley
#'
#' @examples
#' REDCapR::constant("form_incomplete")  # Returns 0L
#' REDCapR::constant("form_unverified")  # Returns 1L
#' REDCapR::constant("form_complete"  )  # Returns 2L
#'
#' REDCapR::constant("data_export_rights_no_access"   )  # Returns 0L
#' REDCapR::constant("data_export_rights_deidentified")  # Returns 1L
#' REDCapR::constant("data_export_rights_full"        )  # Returns 2L
#'
#' REDCapR::constant("form_rights_no_access")   # Returns 0L
#' REDCapR::constant("form_rights_readonly" )   # Returns 2L --Notice the order
#' REDCapR::constant("form_rights_edit_form")   # Returns 1L
#' REDCapR::constant("form_rights_edit_survey") # Returns 3L
#'
#' REDCapR::constant("access_no" )  # Returns 0L
#' REDCapR::constant("access_yes")  # Returns 1L
#'
#' REDCapR::constant(c(
#'   "form_complete",
#'   "form_complete",
#'   "form_incomplete"
#' )) # Returns c(2L, 2L, 0L)
#' REDCapR::constant(c(
#'   "form_rights_no_access",
#'   "form_rights_readonly",
#'   "form_rights_edit_form",
#'   "form_rights_edit_survey"
#' )) # Returns c(0L, 2L, 1L, 3L)
#'
#'
#' constant_to_form_completion( c(0, 2, 1, 2, NA))
#' constant_to_form_rights(     c(0, 2, 1, 2, NA))
#' constant_to_export_rights(   c(0, 2, 1, 3, NA))
#' constant_to_access(          c(0, 1, 1, 0, NA))
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
constant <- function(name) {
  checkmate::assert_character(name, any.missing = FALSE, min.chars = 1L)
  checkmate::assert_subset(name, names(constant_list), empty.ok = FALSE)

  vapply(
    X         = name,
    FUN       = function(x) constant_list[[x]],
    USE.NAMES = FALSE,
    FUN.VALUE = integer(1)
  )
}

#' @export
constant_to_form_completion <- function(x) {
  if (!inherits(x, "character") && !is.numeric(x)) {
    stop(
      "The value to recode must be a character, integer, or floating point.  ",
      "It was `",
      class(x),
      "`."
    )
  }

  x      <- dplyr::coalesce(as.character(x), "255")
  levels <- c(
    REDCapR::constant("form_incomplete"),
    REDCapR::constant("form_unverified"),
    REDCapR::constant("form_complete"),
    "255"
  )
  labels <- c("incomplete", "unverified", "complete", "unknown")
  factor(as.character(x), levels, labels)
}

#' @export
constant_to_form_rights <- function(x) {
  if (!inherits(x, "character") && !is.numeric(x)) {
    stop(
      "The value to recode must be a character, integer, or floating point.  ",
      "It was `",
      class(x),
      "`."
    )
  }

  x      <- dplyr::coalesce(as.character(x), "255")
  levels <- c(
    REDCapR::constant("form_rights_no_access"),
    REDCapR::constant("form_rights_readonly"),
    REDCapR::constant("form_rights_edit_form"),
    REDCapR::constant("form_rights_edit_survey"),
    "255"
  )
  labels <- c("no_access", "readonly", "edit_form", "edit_survey", "unknown")
  factor(as.character(x), levels, labels)
}

#' @export
constant_to_export_rights <- function(x) {
  if (!inherits(x, "character") && !is.numeric(x)) {
    stop(
      "The value to recode must be a character, integer, or floating point.  ",
      "It was `",
      class(x),
      "`."
    )
  }

  x      <- dplyr::coalesce(as.character(x), "255")
  levels <- c(
    REDCapR::constant("data_export_rights_no_access"),
    REDCapR::constant("data_export_rights_deidentified"),
    REDCapR::constant("data_export_rights_full"),
    "255"
  )
  labels <- c("no_access", "deidentified", "rights_full", "unknown")
  factor(as.character(x), levels, labels)
}

#' @export
constant_to_access <- function(x) {
  if (!inherits(x, "character") && !is.numeric(x)) {
    stop(
      "The value to recode must be a character, integer, or floating point.  ",
      "It was `",
      class(x),
      "`."
    )
  }

  x      <- dplyr::coalesce(as.character(x), "255")
  levels <- c(
    REDCapR::constant("access_no"),
    REDCapR::constant("access_yes"),
    "255"
  )
  labels <- c("no", "yes", "unknown")
  factor(as.character(x), levels, labels)
}


# To add REDCap-specific constants, modify the list below.
#     This list is intentionally not exported.
constant_list <- list(
  form_incomplete       = 0L,
  form_unverified       = 1L,
  form_complete         = 2L,

  # https://redcap-dev-2.ouhsc.edu/redcap/api/help/?content=exp_users
  data_export_rights_no_access    = 0L,
  data_export_rights_deidentified = 1L,
  data_export_rights_full         = 2L,

  # https://redcap-dev-2.ouhsc.edu/redcap/api/help/?content=exp_users
  form_rights_no_access    = 0L,
  form_rights_readonly     = 2L,
  form_rights_edit_form    = 1L,  # Notice order is not sequential
  form_rights_edit_survey  = 3L,

  # https://redcap-dev-2.ouhsc.edu/redcap/api/help/?content=exp_users
  access_no    = 0L,
  access_yes   = 1L
)
