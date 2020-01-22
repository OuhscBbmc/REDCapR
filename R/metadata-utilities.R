#' @name metadata_utilities
#' @aliases regex_named_captures checkbox_choices
#'
#' @title Manipulate and interpret the metadata of a REDCap project
#'
#' @description A collection of functions that assists handling REDCap
#' project metadata.
#'
#' @param pattern The regular expression pattern.  Required.
#' @param text The text to apply the regex against.  Required.
#' @param select_choices The text containing the choices that should be parsed
#'   to determine the `id` and `label` values.  Required.
#' @param perl Indicates if perl-compatible regexps should be used.
#'   Default is `TRUE`. Optional.
#'
#' @return Currently, a [base::data.frame()] is returned a row for each match,
#' and a column for each *named* group within a match.  For the
#' `retrieve_checkbox_choices()` function, the columns will be.
#' * `id`: The numeric value assigned to each choice (in the data dictionary).
#' * `label`: The label assigned to each choice (in the data dictionary).
#'
#' @details
#' The [regex_named_captures()] function is general, and not specific to
#' REDCap; it accepts any arbitrary regular expression.
#' It returns a [base::data.frame()] with as many columns as named matches.
#'
#' The [checkbox_choices()] function is specialized, and accommodates the
#' "select choices" for a *single* REDCap checkbox group (where multiple boxes
#' can be selected).  It returns a [base::data.frame()] with two columns, one
#' for the numeric id and one for the text label.
#'
#' @author Will Beasley
#' @references See the official documentation for permissible characters in a
#' checkbox label.
#' *I'm bluffing here, because I don't know where this is located.
#' If you know, please tell me.*
#'
#' @examples
#' # The weird ranges are to avoid the pipe character;
#' #   PCRE doesn't support character negation.
#' pattern_boxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\x20-\x7B\x7D-\x7E]{1,})(?= \\| |\\Z)"
#'
#' choices_1 <- paste0(
#'   "1, American Indian/Alaska Native | ",
#'   "2, Asian | ",
#'   "3, Native Hawaiian or Other Pacific Islander | ",
#'   "4, Black or African American | ",
#'   "5, White | ",
#'   "6, Unknown / Not Reported")
#'
#' # This calls the general function, and requires the correct regex pattern.
#' REDCapR::regex_named_captures(pattern=pattern_boxes, text=choices_1)
#'
#' # This function is designed specifically for the checkbox values.
#' REDCapR::checkbox_choices(select_choices=choices_1)
#'
#' \dontrun{
#' uri         <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token       <- "9A81268476645C4E5F03428B8AC3AA7B"
#'
#' ds_metadata <- redcap_metadata_read(redcap_uri=uri, token=token)$data
#' choices_2   <- ds_metadata[ds_metadata$field_name=="race", "select_choices_or_calculations"]
#'
#' REDCapR::regex_named_captures(pattern=pattern_boxes, text=choices_2)
#' }
#'
#' path_3         <- system.file(package="REDCapR", "test-data/project-simple/simple-metadata.csv")
#' ds_metadata_3  <- read.csv(path_3, stringsAsFactors=FALSE)
#' choices_3      <- ds_metadata_3[ds_metadata_3$field_name=="race", "select_choices_or_calculations"]
#' REDCapR::regex_named_captures(pattern=pattern_boxes, text=choices_3)

#' @export
regex_named_captures <- function(pattern, text, perl=TRUE) {

  checkmate::assert_character(pattern, any.missing=FALSE, min.chars=0L, len=1)
  checkmate::assert_character(text   , any.missing=FALSE, min.chars=0L, len=1)
  checkmate::assert_logical(  perl   , any.missing=FALSE)

  match <- gregexpr(pattern, text, perl = perl)[[1]]
  capture_names <- attr(match, "capture.names")
  d <- as.data.frame(matrix(
    data  = NA_character_,
    nrow  = length(attr(match, "match.length")),
    ncol  = length(capture_names)
  ))
  colnames(d) <- capture_names


  for (column_name in colnames(d)) {
    d[[column_name]] <- mapply(
      function(start, len) {
        substr(text, start, start + len - 1L)
      },
      attr(match, "capture.start" )[, column_name],
      attr(match, "capture.length")[, column_name]
    )
  }
  d
}

#' @rdname metadata_utilities
#' @export
checkbox_choices <- function(select_choices) {
  checkmate::assert_character(select_choices, any.missing=FALSE, len=1, min.chars=1)

  # The weird ranges are to avoid the pipe character;
  #   PCRE doesn't support character negation.
  pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\x21-\x7B\x7D-\x7E ]{1,})(?= \\| |\\Z)"

  regex_named_captures(pattern = pattern_checkboxes, text = select_choices)
}
