#' @title Get the logging of a project.
#'
#' @description This function reads the available logging messages from
#'   REDCap an returns them as a [base::data.frame()].
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap
#' project.  Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param log_begin_date Return the events occurring after midnight of this
#' date.
#' Defaults to the past week; this default mimics the behavior in the browser
#' and also reduces the strain on your server.
#' @param log_end_date Return the events occurring before 24:00 of this date.
#' Defaults to today.
#' @param record Return the events belonging only to specific record
#' (referring to an existing record name).
#' Defaults to `NULL` which returns
#' logging activity related to all records.
#' If a record value passed, it must be a single value.
#' @param user Return the events belonging only to specific user
#' (referring to an existing username).
#' Defaults to `NULL` which returns
#' logging activity related to all users.
#' If a user value passed, it must be a single value.
#' @param http_response_encoding  The encoding value passed to
#' [httr::content()].  Defaults to 'UTF-8'.
#' @param locale a [readr::locale()] object to specify preferences like
#' number, date, and time formats.  This object is passed to
#' [`readr::read_csv()`].  Defaults to [readr::default_locale()].
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the
#' `httr` package.
#'
#' @return Currently, a list is returned with the following elements:
#' * `data`: An R [base::data.frame()] of all data access groups of the project.
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_codes`: A collection of
#' [http status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
#' separated by semicolons.  There is one code for each batch attempted.
#' * `outcome_messages`: A collection of human readable strings indicating the
#' operations' semicolons.  There is one code for each batch attempted.  In an
#' unsuccessful operation, it should contain diagnostic information.
#' * `elapsed_seconds`: The duration of the function.
#'
#' @author Jonathan M. Mang, Will Beasley
#' @references The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html
#' and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' uri          <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token        <- "9A81268476645C4E5F03428B8AC3AA7B"
#'
#' ds_last_week <- REDCapR::redcap_log_read(redcap_uri=uri, token=token)$data
#' head(ds_last_week)
#'
#' ds_one_day <-
#'   REDCapR::redcap_log_read(
#'     redcap_uri     = uri,
#'     token          = token,
#'     log_begin_date = as.Date("2020-08-10"),
#'     log_end_date   = as.Date("2020-08-10")
#'   )$data
#' head(ds_one_day)
#'
#' ds_one_day_single_record_single_user <-
#'   REDCapR::redcap_log_read(
#'     redcap_uri     = uri,
#'     token          = token,
#'     log_begin_date = as.Date("2021-07-11"),
#'     log_end_date   = as.Date("2021-07-11"),
#'     record         = as.character(3),
#'     user           = "unittestphifree"
#'   )$data
#' head(ds_one_day_single_record_single_user)
#' }

#' @export
redcap_log_read <- function(
  redcap_uri,
  token,
  log_begin_date                = Sys.Date() - 7L,
  log_end_date                  = Sys.Date(),
  record                        = NULL,
  user                          = NULL,
  http_response_encoding        = "UTF-8",
  locale                        = readr::default_locale(),
  verbose                       = TRUE,
  config_options                = NULL
) {
  checkmate::assert_character(redcap_uri                , any.missing = FALSE, len = 1, pattern = "^.{1,}$")
  checkmate::assert_character(token                     , any.missing = FALSE, len = 1, pattern = "^.{1,}$")
  checkmate::assert_date(     log_begin_date            , any.missing = FALSE, len = 1)
  checkmate::assert_date(     log_end_date              , any.missing = FALSE, len = 1)
  checkmate::assert_character(record                    , any.missing = FALSE, len = 1, null.ok = TRUE)
  checkmate::assert_character(user                      , any.missing = FALSE, len = 1, null.ok = TRUE)

  checkmate::assert_character(http_response_encoding    , any.missing=FALSE,   len = 1)
  checkmate::assert_class(    locale, classes = "locale", null.ok = FALSE)
  checkmate::assert_logical(  verbose                   , any.missing=FALSE,   len = 1, null.ok = TRUE)
  checkmate::assert_list(     config_options            , any.missing=TRUE ,            null.ok = TRUE)

  token               <- sanitize_token(token)
  verbose             <- verbose_prepare(verbose)
  log_begin_datetime  <- strftime(log_begin_date    , "%Y-%m-%d 00:00")
  log_end_datetime    <- strftime(log_end_date      , "%Y-%m-%d 24:00")

  post_body <- list(
    token                   = token,
    content                 = "log",
    format                  = "csv",
    beginTime               = log_begin_datetime,
    endTime                 = log_end_datetime,
    record                  = record,
    user                    = user
  )

  # This is the important line that communicates with the REDCap server.
  kernel <- kernel_api(
    redcap_uri      = redcap_uri,
    post_body       = post_body,
    config_options  = config_options,
    encoding        = http_response_encoding
  )

  if (kernel$success) {
    try(
      # Convert the raw text to a dataset.
      ds <-
        readr::read_csv(
          file            = I(kernel$raw_text),
          locale          = locale,
          show_col_types  = FALSE
        ) %>%
        as.data.frame(),

      # Don't print the warning in the try block.  Print it below,
      #   where it's under the control of the caller.
      silent = TRUE
    )

    if (exists("ds") & inherits(ds, "data.frame")) {
      outcome_message <- sprintf(
        "%s rows were read from REDCap in %0.1f seconds.  The http status code was %i.",
        format(  nrow(ds), big.mark = ",", scientific = FALSE, trim = TRUE),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      # If an operation is successful, the `raw_text` is no longer returned to
      #   save RAM.  The content is not really necessary with httr's status
      #   message exposed.
      kernel$raw_text   <- ""
    } else { # ds doesn't exist as a data.frame.
      # nocov start
      # Override the 'success' determination from the http status code.
      #   and return an empty data.frame.
      kernel$success   <- FALSE
      ds               <- data.frame()
      outcome_message  <- sprintf(
        "The REDCap log export failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  } else { # kernel fails
    ds              <- data.frame() #Return an empty data.frame
    outcome_message <- if (any(grepl(kernel$regex_empty, kernel$raw_text))) {
      "The REDCapR log export operation was not successful.  The returned dataset was empty."  # nocov
    } else {
      sprintf(
        "The REDCapR log export operation was not successful.  The error message was:\n%s",
        kernel$raw_text
      )
    }
  }

  if (verbose)
    message(outcome_message)

  list(
    data               = ds,
    success            = kernel$success,
    status_code        = kernel$status_code,
    outcome_message    = outcome_message,
    elapsed_seconds    = kernel$elapsed_seconds,
    raw_text           = kernel$raw_text
  )
}
