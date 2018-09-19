#' @name validate
#' @aliases validate_for_write validate_no_logical validate_field_names
#' @usage
#' validate_for_write( d )
#'
#' validate_no_logical( data_types, stop_on_error )
#'
#' validate_field_names( field_names, stop_on_error )
#'
#' @title Inspect a [base::data.frame()] to anticipate problems before writing to a REDCap project
#'
#' @description This set of functions inspect a [base::data.frame()] to anticipate problems before writing with REDCap's API.
#'
#' @param d The [base::data.frame()] containing the dataset used to update the REDCap project.
#' @param data_types The data types of the [base::data.frame()] corresponding to the REDCap project.
#' @param field_names The names of the fields/variables in the REDCap project.
#' @param stop_on_error If `TRUE`, an error is thrown for violations.  Otherwise, a dataset summarizing the problems is returned.
#'
#' @return A [tibble::tibble()], where each potential violation is a row.  The two columns are:
#' * `field_name`: The name of the [base::data.frame()] that might cause problems during the upload.
#' * `field_index`: The position of the field.  (For example, a value of '1' indicates the first column, while a '3' indicates the third column.)
#' * `concern`: A description of the problem potentially caused by the `field`.
#' * `suggestion`: A *potential* solution to the concern.
#'
#' @details
#' All functions listed in the Usage section above inspect a specific aspect of the dataset.
#' The [validate_for_write()] function executes all
#' these individual validation checks.  It allows the client to check everything with one call.
#'
#' @author Will Beasley
#'
#' @references The official documentation can be found on the 'API Help Page' and 'API Examples' pages
#' on the REDCap wiki (*i.e.*, https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html). If you do not have an account
#' for the wiki, please ask your campus REDCap administrator to send you the static material.
#'
#' @examples
#' d <- data.frame(
#'   record_id      = 1:4,
#'   flag_logical   = c(TRUE, TRUE, FALSE, TRUE),
#'   flag_Uppercase = c(4, 6, 8, 2)
#' )
#' REDCapR::validate_for_write(d = d)

#' @export
validate_no_logical <- function( data_types, stop_on_error=FALSE ) {
  checkmate::assert_character(data_types, any.missing=F, min.len=1, min.chars=2)
  checkmate::assert_logical(stop_on_error, any.missing=F, len=1)

  # indices <- which(sapply(d, class)=="logical")
  indices <- which(data_types=="logical")

  if( length(indices) == 0L ) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = integer(0),
      concern            = character(0),
      suggestion         = character(0)
    )
  } else if( stop_on_error) {
    stop(length(indices), " field(s) were logical/boolean.  The REDCap API does not automatically convert boolean values to 0/1 values.  Convert the variable with the `as.integer()` function.")
  } else {
    tibble::tibble(
      field_name         = names(data_types)[indices],
      field_index        = indices,
      concern            = "The REDCap API does not automatically convert boolean values to 0/1 values.",
      suggestion         = "Convert the variable with the `as.integer()` function."
    )
  }
}

#' @export
validate_field_names <- function( field_names, stop_on_error=FALSE ) {
  checkmate::assert_character(field_names, any.missing=F, null.ok=T, min.len=1, min.chars=2)
  checkmate::assert_logical(stop_on_error, any.missing=F, len=1)

  pattern <- "^[0-9a-z_]+$"

  indices <- which(!grepl(pattern, x=field_names, perl=TRUE))
  if( length(indices) == 0 ) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = integer(0),
      concern            = character(0),
      suggestion         = character(0)
    )
  } else if( stop_on_error) {
    stop(length(indices), " field name(s) violated the naming rules.  Only digits, lowercase letters, and underscores are allowed.")
  } else {
    tibble::tibble(
      field_name         = field_names[indices],
      field_index        = indices,
      concern            = "A REDCap project does not allow field names with an uppercase letter.",
      suggestion         = "Change the uppercase letters to lowercase, potentially with `base::tolower()`."
    )
  }
}

#' @export
validate_for_write <- function( d ) {
  checkmate::assert_data_frame(d, any.missing=F)

  lst_concerns <- list(
    validate_no_logical(sapply(d, class)),
    validate_field_names(colnames(d))
  )
  ds_concern <- dplyr::bind_rows(lst_concerns) #Vertically stack all the data.frames into a single data.frame

 return( ds_concern )
}
