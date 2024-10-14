#' @name metadata_utilities
#'
#' @aliases
#' regex_named_captures checkbox_choices
#'
#' @title
#' Manipulate and interpret the metadata of a REDCap project
#'
#' @description
#' A collection of functions that assists handling REDCap
#' project metadata.
#'
#' @param pattern The regular expression pattern.  Required.
#' @param text The text to apply the regex against.  Required.
#' @param select_choices The text containing the choices that should be parsed
#' to determine the `id` and `label` values.  Required.
#' @param perl Indicates if perl-compatible regexps should be used.
#' Default is `TRUE`. Optional.
#'
#' @return
#' Currently, a [tibble::tibble()] is returned a row for each match,
#' and a column for each *named* group within a match.  For the
#' `retrieve_checkbox_choices()` function, the columns will be.
#' * `id`: The numeric value assigned to each choice (in the data dictionary).
#' * `label`: The label assigned to each choice (in the data dictionary).
#'
#' @details
#' The [regex_named_captures()] function is general, and not specific to
#' REDCap; it accepts any arbitrary regular expression.
#' It returns a [tibble::tibble()] with as many columns as named matches.
#'
#' The [checkbox_choices()] function is specialized, and accommodates the
#' "select choices" for a *single* REDCap checkbox group (where multiple boxes
#' can be selected).  It returns a [tibble::tibble()] with two columns, one
#' for the numeric id and one for the text label.
#'
#' The parse will probably fail if a label contains a pipe (*i.e.*, `|`),
#' since that the delimiter REDCap uses to separate choices
#' presented to the user.
#'
#' @author
#' Will Beasley
#'
#' @references
#' See the official documentation for permissible characters in a
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
#'   "6, Unknown / Not Reported"
#' )
#'
#' # This calls the general function, and requires the correct regex pattern.
#' REDCapR::regex_named_captures(pattern=pattern_boxes, text=choices_1)
#'
#' # This function is designed specifically for the checkbox values.
#' REDCapR::checkbox_choices(select_choices=choices_1)
#'
#' \dontrun{
#' uri         <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token       <- "9A068C425B1341D69E83064A2D273A70"
#'
#' ds_metadata <- redcap_metadata_read(uri, token)$data
#' choices_2   <- ds_metadata[ds_metadata$field_name == "race", ]$select_choices_or_calculations
#'
#' REDCapR::regex_named_captures(pattern = pattern_boxes, text = choices_2)
#' }
#'
#' path_3     <- system.file(package = "REDCapR", "test-data/projects/simple/metadata.csv")
#' ds_metadata_3  <- read.csv(path_3)
#' choices_3  <- ds_metadata_3[ds_metadata_3$field_name=="race", "select_choices_or_calculations"]
#' REDCapR::regex_named_captures(pattern = pattern_boxes, text = choices_3)

#' @importFrom magrittr %>%
#' @export
regex_named_captures <- function(pattern, text, perl = TRUE) {
  checkmate::assert_character(pattern, any.missing = FALSE, len = 1, min.chars = 0L)
  checkmate::assert_character(text   , any.missing = FALSE, len = 1, min.chars = 0L)
  checkmate::assert_logical(  perl   , any.missing = FALSE, len = 1                )

  match <- gregexpr(pattern, text, perl = perl)[[1]]
  capture_names <- attr(match, "capture.names")
  d <- base::data.frame(matrix(
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
  tibble::as_tibble(d)
}

#' @rdname metadata_utilities
#' @importFrom rlang .data
#' @export
checkbox_choices <- function(select_choices) {
  checkmate::assert_character(select_choices, any.missing=FALSE, len=1, min.chars=1)

  pattern <- "^(.+?),\\s*+(.*)$"

  select_choices %>%
    strsplit(split = "|", fixed = TRUE) %>%
    magrittr::extract2(1) %>%
    base::trimws() %>%
    tibble::as_tibble() %>% # default column name is `value`
    dplyr::filter(.data$value != "") %>%
    dplyr::transmute(
      id    = sub(pattern, "\\1", .data$value, perl = TRUE),
      label = sub(pattern, "\\2", .data$value, perl = TRUE),
    )

  # pattern_checkboxes <- "(?<=\\A| \\| |\\| )(?<id>\\d{1,}), (?<label>[^|]{1,}?)(?= \\| |\\| |\\Z)"
  # pattern_checkboxes <- "(?<=\\A| \\| |\\| | \\|)(?<id>\\d{1,}), ?(?<label>[^|]{1,}?)(?= \\| |\\| | \\||\\Z)"
  # regex_named_captures(pattern = pattern_checkboxes, text = select_choices)
}
