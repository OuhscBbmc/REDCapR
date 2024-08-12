#' @name
#' validate
#'
#' @aliases
#' validate_for_write
#' validate_data_frame_inherits
#' validate_no_logical
#' validate_field_names
#' validate_record_id_name
#' validate_repeat_instance
#' validate_uniqueness
#'
#' @usage
#' validate_for_write( d, convert_logical_to_integer, record_id_name )
#'
#' validate_data_frame_inherits( d )
#'
#' validate_no_logical( d, stop_on_error = FALSE )
#'
#' validate_field_names( d, stop_on_error = FALSE )
#'
#' validate_record_id_name( d, record_id_name = "record_id", stop_on_error = FALSE )
#'
#' validate_repeat_instance( d, stop_on_error = FALSE )
#'
#' validate_uniqueness( d, record_id_name, stop_on_error = FALSE)
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
#' @param record_id_name The name of the field that represents one record.
#' The default name in REDCap is "record_id".
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
#' * `suggestion`: A _potential_ solution to the concern.
#'
#' @details
#' All functions listed in the Usage section above inspect a specific aspect
#' of the dataset.  The [validate_for_write()] function executes all these
#' individual validation checks.  It allows the client to check everything
#' with one call.
#'
#' Currently, the individual checks include:
#'
#' 1. `validate_data_frame_inherits(d)`:
#'    `d` inherits from [base::data.frame()]
#'
#' 1. `validate_field_names(d)`:
#'    The columns of `d`
#'    start with a lowercase letter, and subsequent optional characters are a
#'    sequence of (a) lowercase letters, (b) digits 0-9, and/or (c) underscores.
#'    (The exact regex is `^[a-z][0-9a-z_]*$`.)
#'
#' 1. `validate_record_id_name(d)`:
#'    `d` contains a field called "record_id",
#'    or whatever value was passed to `record_id_name`.
#'
#' 1. `validate_no_logical(d)` (unless `convert_logical_to_integer` is TRUE):
#'    `d` does not contain
#'    [logical](https://stat.ethz.ch/R-manual/R-devel/library/base/html/logical.html)
#'    values (because REDCap typically wants `0`/`1` values instead of
#'    `FALSE`/`TRUE`).
#'
#' 1. `validate_repeat_instance(d)`:
#'    `d` has an integer for `redcap_repeat_instance`, if the column is present.
#'
#' 1. `validate_uniqueness(d, record_id_name = record_id_name)`:
#'    `d` does not contain multiple rows with duplicate values of
#'    `record_id`,
#'    `redcap_event_name`,
#'    `redcap_repeat_instrument`, and
#'    `redcap_repeat_instance`
#'    (depending on the longitudinal & repeating structure of the project).
#'
#'    Technically duplicate rows are not errors,
#'    but we feel that this will almost always be unintentional,
#'    and lead to an irrecoverable corruption of the data.
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
#' d1 <- data.frame(
#'   record_id      = 1:4,
#'   flag_logical   = c(TRUE, TRUE, FALSE, TRUE),
#'   flag_Uppercase = c(4, 6, 8, 2)
#' )
#' REDCapR::validate_for_write(d = d1)
#'
#' REDCapR::validate_for_write(d = d1, convert_logical_to_integer = TRUE)
#'
#' # If `d1` is not a data.frame, the remaining validation checks are skipped:
#' # REDCapR::validate_for_write(as.matrix(mtcars))
#' # REDCapR::validate_for_write(c(mtcars, iris))
#'
#' d2 <- tibble::tribble(
#'   ~record_id, ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance,
#'   1L, "e1", "i1", 1L,
#'   1L, "e1", "i1", 2L,
#'   1L, "e1", "i1", 3L,
#'   1L, "e1", "i1", 4L,
#'   1L, "e1", "i2", 1L,
#'   1L, "e1", "i2", 2L,
#'   1L, "e1", "i2", 3L,
#'   1L, "e1", "i2", 4L,
#'   2L, "e1", "i1", 1L,
#'   2L, "e1", "i1", 2L,
#'   2L, "e1", "i1", 3L,
#'   2L, "e1", "i1", 4L,
#' )
#' validate_uniqueness(d2)
#' validate_for_write(d2)
#'
#' d3 <- tibble::tribble(
#'   ~record_id, ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance,
#'   1L, "e1", "i1", 1L,
#'   1L, "e1", "i1", 3L,
#'   1L, "e1", "i1", 3L, # Notice this duplicates the row above
#' )
#' # validate_uniqueness(d3)
#' # Throws error:
#' # validate_uniqueness(d3, stop_on_error = TRUE)

#' @export
validate_data_frame_inherits <- function(d) {
  if (!base::inherits(d, "data.frame")) {
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
validate_no_logical <- function(d, stop_on_error = FALSE) {
  checkmate::assert_data_frame(d)
  checkmate::assert_logical(stop_on_error, any.missing = FALSE, len = 1L)

  indices <- which(vapply(d, \(x) inherits(x, "logical"), logical(1)))

  if (length(indices) == 0L) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = character(0),
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
      field_name         = colnames(d)[indices],
      field_index        = as.character(indices),
      concern            = "The REDCap API does not automatically convert boolean values to 0/1 values.",
      suggestion         = "Convert the variable with the `as.integer()` function."
    )
  }
}

#' @export
validate_field_names <- function(d, stop_on_error = FALSE) {
  checkmate::assert_data_frame(d)
  checkmate::assert_logical(stop_on_error, any.missing = FALSE, len = 1L)

  pattern <- "^[a-z][0-9a-z_]*$"
  field_names <- colnames(d)

  indices <- grep(pattern, x = field_names, perl = TRUE, invert = TRUE)
  if (length(indices) == 0L) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = character(0),
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
      field_index        = as.character(indices),
      concern            = "A REDCap project does not allow field names with an uppercase letter.",
      suggestion         = "Change the uppercase letters to lowercase, potentially with `base::tolower()`."
    )
  }
}

# Intentionally not exported
assert_field_names <- function(field_names) {
  checkmate::assert_character(field_names, any.missing=FALSE, null.ok=TRUE, min.len=1, min.chars=1)
  pattern <- "^[a-z][0-9a-z_]*$"

  bad_names <- grep(pattern, x = field_names, perl = TRUE, invert = TRUE)

  if (0L < length(bad_names)) {
    paste(
      "%i field name(s) violated the naming rules.  Only digits, lowercase ",
      "letters, and underscores are allowed.  The variable must start with ",
      "a letter.  The bad names are {%s}.",
      collapse = ""
    ) %>%
      sprintf(length(bad_names), paste(bad_names, collapse = ", ")) %>%
      stop()
  }
}

#' @export
validate_record_id_name <- function(
  d,
  record_id_name              = "record_id",
  stop_on_error               = FALSE
) {
  checkmate::assert_data_frame(d)
  checkmate::assert_character(record_id_name, len = 1L, any.missing = FALSE, min.chars = 1L)
  checkmate::assert_logical(stop_on_error, any.missing = FALSE, len = 1L)

  record_id_found <- (record_id_name %in% colnames(d))

  if (record_id_found) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = character(0),
      concern            = character(0),
      suggestion         = character(0)
    )
  } else if (stop_on_error) {
    "The field called `%s` is not found in the dataset.\nAdjust the value passed to the `record_id_name` if this isn't the correct named used by your specific REDCap project." %>%
      sprintf(record_id_name) %>%
      stop()
  } else {
    tibble::tibble(
      field_name         = record_id_name,
      field_index        = NA_character_,
      concern            = "The field is not found in the dataset.",
      suggestion         = "Adjust the value passed to the `record_id_name` if this isn't the correct named used by your specific REDCap project."
    )
  }
}

#' @export
validate_repeat_instance <- function(d, stop_on_error = FALSE) {
  checkmate::assert_data_frame(d)
  checkmate::assert_logical(stop_on_error, any.missing = FALSE, len = 1L)

  column_name <- "redcap_repeat_instance"
  if (!any(colnames(d) == column_name)) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = character(0),
      concern            = character(0),
      suggestion         = character(0)
    )
  } else if (inherits(d[[column_name]], "integer")) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = character(0),
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
      field_index        = as.character(indices),
      concern            = "The `redcap_repeat_instance` column should be an integer.",
      suggestion         = "Use `as.integer()` to cast it.  Make sure no 'NAs introduced by coercion' warnings appears."
    )
  }
}

#' @importFrom magrittr %>%
#' @export
validate_uniqueness <- function(d, record_id_name = "record_id", stop_on_error = FALSE) {
  checkmate::assert_data_frame(d)
  checkmate::assert_character(record_id_name, len = 1L, any.missing = FALSE, min.chars = 1L)
  checkmate::assert_logical(stop_on_error, any.missing = FALSE, len = 1L)

  count_of_records <- NULL
  plumbing  <- c(record_id_name, "redcap_event_name", "redcap_repeat_instrument", "redcap_repeat_instance")
  variables <- intersect(colnames(d), plumbing)

  d_replicates <-
    d %>%
    dplyr::count(
      !!!rlang::parse_exprs(variables),
      name  = "count_of_records"
    ) %>%
    dplyr::filter(1L < count_of_records)

  if (nrow(d_replicates) == 0L) {
    tibble::tibble(
      field_name         = character(0),
      field_index        = character(0),
      concern            = character(0),
      suggestion         = character(0)
    )
  } else if (stop_on_error) {
    m <-
      if (requireNamespace("knitr", quietly = TRUE)) {
        d_replicates %>%
          knitr::kable() %>%
          paste(collapse = "\n")
      } else {
        paste(d_replicates, collapse = "\n")  # nocov
      }

    "There are %i record(s) that violate the uniqueness requirement:\n%s" %>%
      sprintf(nrow(d_replicates), m) %>%
      stop()
  } else {
    indices <- paste(which(colnames(d) == variables), collapse = ", ")

    tibble::tibble(
      field_name         = paste(variables, collapse = ", "),
      field_index        = as.character(indices),
      concern            = "The values in these variables were not unique.",
      suggestion         = "Run `validate_uniqueness()` with `stop_on_error = TRUE` to see the specific values that are duplicated."
    )
  }
}
# validate_uniqueness(d2)
# validate_uniqueness(d3)
# validate_uniqueness(d3, stop_on_error = TRUE)
# #' @export
# validate_field_names_collapsed <- function(field_names_collapsed, stop_on_error = FALSE) {
#   field_names <- trimws(unlist(strsplit(field_names_collapsed, ",")))
#   validate_field_names(field_names = field_names, stop_on_error = stop_on_error)
# }

#' @export
validate_for_write <- function(
  d,
  convert_logical_to_integer  = FALSE,
  record_id_name              = "record_id"
) {
  # checkmate::assert_data_frame(d, any.missing = TRUE, null.ok = FALSE)
  checkmate::assert_logical(convert_logical_to_integer, any.missing = FALSE, len = 1)
  checkmate::assert_character(record_id_name, len = 1L, any.missing = FALSE, min.chars = 1L)

  lst_concerns <- list(
    validate_data_frame_inherits(d),
    validate_field_names(d),
    validate_record_id_name(d),
    validate_uniqueness(d, record_id_name = record_id_name),
    validate_repeat_instance(d)
  )

  if (!convert_logical_to_integer) {
    # lst_concerns <-
    #   base::append(
    #     lst_concerns,
    #     validate_no_logical(vapply(d, class, character(1)))
    #   )
    lst_concerns[[length(lst_concerns) + 1L]] <- validate_no_logical(d)
  }

  # browser()
  # Vertically stack all the data.frames into a single data frame
  dplyr::bind_rows(lst_concerns)
}
