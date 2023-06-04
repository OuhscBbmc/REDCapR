#' @name
#' validate
#'
#' @aliases
#' validate_for_write
#' validate_data_frame_inherits
#' validate_no_logical
#' validate_field_names
#' validate_repeat_instance
#'
#' @usage
#' validate_for_write( d, convert_logical_to_integer )
#'
#' validate_data_frame_inherits( d )
#'
#' validate_no_logical( data_types, stop_on_error )
#'
#' validate_field_names( field_names, stop_on_error = FALSE )
#'
#' validate_repeat_instance( d, stop_on_error )
#'
#' @title
#' Inspect a dataset to anticipate problems before
#' writing to a REDCap project
#'
#' @description
#' This set of functions inspect a data frame
#' to anticipate problems before writing with REDCap's API.
#'
#' @param d The [base::data.frame()] or [tibble::tibble()]
#' containing the dataset used to update
#' the REDCap project.
#' @param data_types The data types of the data frame corresponding
#' to the REDCap project.
#' @param field_names The names of the fields/variables in the REDCap project.
#' Each field is an individual element in the character vector.
#' @param stop_on_error If `TRUE`, an error is thrown for violations.
#' Otherwise, a dataset summarizing the problems is returned.
#' @param convert_logical_to_integer
#' This mimics the `convert_logical_to_integer` parameter  in
#' [redcap_write()] when checking for potential importing problems.
#' Defaults to `FALSE`.
#'
#' @return
#' A [tibble::tibble()], where each potential violation is a row.
#' The two columns are:
#' * `field_name`: The name of the field/column/variable that might cause
#' problems during the upload.
#' * `field_index`: The position of the field.  (For example, a value of
#' '1' indicates the first column, while a '3' indicates the third column.)
#' * `concern`: A description of the problem potentially caused by the `field`.
#' * `suggestion`: A *potential* solution to the concern.
#'
#' @details
#' All functions listed in the Usage section above inspect a specific aspect
#' of the dataset.  The [validate_for_write()] function executes all these
#' individual validation checks.  It allows the client to check everything
#' with one call.
#'
#' Currently it verifies that the dataset
#' * inherits from [data.table::data.table()].
#' * does not contain
#' [logical](https://stat.ethz.ch/R-manual/R-devel/library/base/html/logical.html)
#' values (because REDCap typically wants `0`/`1` values instead of
#' `FALSE`/`TRUE`).
#' * starts with a lowercase letter, and subsequent optional characters are a
#' sequence of (a) lowercase letters, (b) digits 0-9, and/or (c) underscores.
#' (The exact regex is `^[a-z][0-9a-z_]*$`.)
#' * has an integer for `redcap_repeat_instance`, if the column is present.
#'
#' If you encounter additional types of problems when attempting to write to
#' REDCap, please tell us by creating a
#' [new issue](https://github.com/OuhscBbmc/REDCapR/issues), and we'll
#' incorporate a new validation check into this function.
#'
#' @author
#' Will Beasley
#'
#' @references
#' The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' d <- data.frame(
#'   record_id      = 1:4,
#'   flag_logical   = c(TRUE, TRUE, FALSE, TRUE),
#'   flag_Uppercase = c(4, 6, 8, 2)
#' )
#' REDCapR::validate_for_write(d = d)
#'
#' REDCapR::validate_for_write(d = d, convert_logical_to_integer = TRUE)
#'
#' # If `d` is not a data.frame, the remaining validation checks are skipped:
#' # REDCapR::validate_for_write(as.matrix(mtcars))
#' # REDCapR::validate_for_write(c(mtcars, iris))

#' @export
validate_data_frame_inherits <- function(d) {
  if(!base::inherits(d, "data.frame")) {
    stop(
      "The `d` object is not a valid `data.frame`.  ",
      "Make sure it is a data.frame ",
      "or it inherits from a data.frame (like a tibble or data.table).  ",
      "It appears to be a `",
      class(d),
      "`."
    )
  }
}

#' @export
validate_no_logical <- function(data_types, stop_on_error = FALSE) {
  checkmate::assert_character(data_types, any.missing=FALSE, min.len=1, min.chars=2)
  checkmate::assert_logical(stop_on_error, any.missing=FALSE, len=1)

  indices <- which(data_types == "logical")

  if (length(indices) == 0L) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = integer(0),
      concern            = character(0),
      suggestion         = character(0)
    )
  } else if (stop_on_error) {
    stop(
      length(indices),
      " field(s) were logical/boolean. ",
      "The REDCap API does not automatically convert boolean values to 0/1 ",
      "values.  Convert the variable with the `as.integer()` function."
    )
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
validate_field_names <- function(field_names, stop_on_error = FALSE) {
  checkmate::assert_character(field_names, any.missing=FALSE, null.ok=TRUE, min.len=1, min.chars=1)
  checkmate::assert_logical(stop_on_error, any.missing=FALSE, len=1)

  pattern <- "^[a-z][0-9a-z_]*$"

  indices <- which(!grepl(pattern, x = field_names, perl = TRUE))
  if (length(indices) == 0L) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = integer(0),
      concern            = character(0),
      suggestion         = character(0)
    )
  } else if (stop_on_error) {
    stop(
      length(indices),
      " field name(s) violated the naming rules.  Only digits, lowercase ",
      "letters, and underscores are allowed.  The variable must start with ",
      "a letter."
    )
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
validate_repeat_instance <- function(d, stop_on_error = FALSE) {
  checkmate::assert_data_frame(d)
  checkmate::assert_logical(stop_on_error, any.missing = FALSE, len = 1)

  column_name <- "redcap_repeat_instance"
  if(!any(colnames(d) == column_name)) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = integer(0),
      concern            = character(0),
      suggestion         = character(0)
    )
  } else if (inherits(d[[column_name]], "integer")) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = integer(0),
      concern            = character(0),
      suggestion         = character(0)
    )
  } else if (stop_on_error) {
    stop(
      "The `redcap_repeat_instance` column should be an integer.  ",
      "Use `as.integer()` to cast it.  ",
      "Make sure no 'NAs introduced by coercion' warnings appears."
    )
  } else {
    indices <- grep(column_name, x = colnames(d), perl = TRUE)

    tibble::tibble(
      field_name         = column_name,
      field_index        = indices,
      concern            = "The `redcap_repeat_instance` column should be an integer.",
      suggestion         = "Use `as.integer()` to cast it.  Make sure no 'NAs introduced by coercion' warnings appears."
    )
  }
}

# #' @export
# validate_field_names_collapsed <- function(field_names_collapsed, stop_on_error = FALSE) {
#   field_names <- trimws(unlist(strsplit(field_names_collapsed, ",")))
#   validate_field_names(field_names = field_names, stop_on_error = stop_on_error)
# }

#' @export
validate_for_write <- function(
  d,
  convert_logical_to_integer = FALSE
) {
  # checkmate::assert_data_frame(d, any.missing = TRUE, null.ok = FALSE)
  checkmate::assert_logical(convert_logical_to_integer, any.missing = FALSE, len = 1)

  lst_concerns <- list(
    validate_data_frame_inherits(d),
    validate_field_names(colnames(d)),
    validate_repeat_instance(d)
  )

  if (!convert_logical_to_integer) {
    # lst_concerns <-
    #   base::append(
    #     lst_concerns,
    #     validate_no_logical(vapply(d, class, character(1)))
    #   )
    lst_concerns[[length(lst_concerns) + 1L]] <- validate_no_logical(vapply(d, class, character(1)))
  }

  # Vertically stack all the data.frames into a single data frame
  dplyr::bind_rows(lst_concerns)
}
