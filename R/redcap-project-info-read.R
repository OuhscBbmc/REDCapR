#' @title
#' Export project information.
#'
#' @description
#' This function exports some of the basic attributes of a given
#' REDCap project, such as the project's title, if it is longitudinal,
#' if surveys are enabled, the time the project was created and moved to
#' production.  Returns a [tibble::tibble()].
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param http_response_encoding  The encoding value passed to
#' [httr::content()].  Defaults to 'UTF-8'.
#' @param locale a [readr::locale()] object to specify preferences like
#' number, date, and time formats.  This object is passed to
#' [readr::read_csv()].  Defaults to [readr::default_locale()].
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options A list of options passed to [httr::POST()].
#' See details at [httr::httr_options()]. Optional.
#' @param handle_httr The value passed to the `handle` parameter of
#' [httr::POST()].
#' This is useful for only unconventional authentication approaches.  It
#' should be `NULL` for most institutions.  Optional.
#'
#' @return
#' Currently, a list is returned with the following elements:
#' * `data`: An R [tibble::tibble()] of all data access groups of the project.
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
#' @details
#' **Timezones**
#'
#' Several datetime variables are returned, such as the project's
#' `creation_time`.  For the time to be meaningful, you'll need to set
#' the time zone because this function uses [readr::read_csv()],
#' which assigns
#' [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time)
#' if no timezone is specified.  Find your server's location listed in
#' [base::OlsonNames()], and pass it to readr's [readr::locale()] function,
#' and then pass that to `redcap_project_info_read()`.  See the examples below
#'
#' For more timezone details see the
#' [Timezones](https://readr.tidyverse.org/articles/locales.html#timezones)
#' section of readr's
#' [locales](https://readr.tidyverse.org/articles/locales.html) vignette.
#'
#' **Columns not yet added**
#' This function casts columns into data types that we think are most natural to
#' use.  For example, `in_production` is cast from a 0/1 to a
#' boolean TRUE/FALSE.  All columns not (yet) recognized by REDCapR will be
#' still be returned to the client, but cast as a character.
#' If the REDCap API adds a new column in the future,
#' please alert us in a
#' [REDCapR issue](https://github.com/OuhscBbmc/REDCapR/issues) and we'll
#' expand the casting specifications.
#'
#' **External Modules**
#'
#' A project's `external_modules` cell contains all its approved EMs,
#' separated by a column.  Consider using a function like
#' [tidyr::separate_rows()] to create a long data structure.
#'
#' @author
#' Will Beasley, Stephan Kadauke
#'
#' @references
#' The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html
#' and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' # Specify your project uri and token(s).
#' uri                  <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token_simple         <- "9A068C425B1341D69E83064A2D273A70"
#' token_longitudinal   <- "DA6F2BB23146BD5A7EA3408C1A44A556"
#'
#' # ---- Simple examples
#' REDCapR::redcap_project_info_read(uri, token_simple      )$data
#' REDCapR::redcap_project_info_read(uri, token_longitudinal)$data
#'
#' # ---- Specify timezone
#' # Specify the server's timezone, for example, US Central
#' server_locale <- readr::locale(tz = "America/Chicago")
#' d3 <-
#'   REDCapR::redcap_project_info_read(
#'     uri,
#'     token_simple,
#'     locale     = server_locale
#'   )$data
#' d3$creation_time
#'
#' # Alternatively, set timezone to the client's location.
#' client_locale <- readr::locale(tz = Sys.timezone())
#'
#' # ---- Inspect multiple projects in the same tibble
#' # Stack all the projects on top of each other in a (nested) tibble,
#' #   starting from a csv of REDCapR test projects.
#' # The native pipes in this snippet require R 4.1+.
#' d_all <-
#'   system.file("misc/dev-2.credentials", package = "REDCapR") |>
#'   readr::read_csv(
#'     comment     = "#",
#'     col_select  = c(redcap_uri, token),
#'     col_types   = readr::cols(.default = readr::col_character())
#'   ) |>
#'   dplyr::filter(32L == nchar(token)) |>
#'   purrr::pmap_dfr(REDCapR::redcap_project_info_read, locale = server_locale)
#'
#' # Inspect values stored on the server.
#' d_all$data
#' # or: View(d_all$data)
#'
#' # Inspect everything returned, including values like the http status code.
#' d_all
#' }

#' @export
redcap_project_info_read <- function(
  redcap_uri,
  token,
  http_response_encoding        = "UTF-8",
  locale                        = readr::default_locale(),
  verbose                       = TRUE,
  config_options                = NULL,
  handle_httr       = NULL
) {

  checkmate::assert_character(redcap_uri                , any.missing = FALSE, len = 1, pattern = "^.{1,}$")
  checkmate::assert_character(token                     , any.missing = FALSE, len = 1, pattern = "^.{1,}$")

  checkmate::assert_character(http_response_encoding    , any.missing=FALSE,   len = 1)
  checkmate::assert_class(    locale, classes = "locale", null.ok = FALSE)
  checkmate::assert_logical(  verbose                   , any.missing=FALSE,   len = 1, null.ok = TRUE)
  checkmate::assert_list(     config_options            , any.missing=TRUE ,            null.ok = TRUE)

  token               <- sanitize_token(token)
  verbose             <- verbose_prepare(verbose)

  post_body <- list(
    token                   = token,
    content                 = "project",
    format                  = "csv"
  )

  # This is the important call that communicates with the REDCap server.
  kernel <- kernel_api(
    redcap_uri      = redcap_uri,
    post_body       = post_body,
    encoding        = http_response_encoding,
    config_options  = config_options,
    handle_httr     = handle_httr
  )

  all_col_types <- readr::cols(
    project_id                              = readr::col_integer(),
    project_title                           = readr::col_character(),
    creation_time                           = readr::col_datetime(format = ""),
    production_time                         = readr::col_datetime(format = ""),
    in_production                           = readr::col_logical(),
    project_language                        = readr::col_character(),
    purpose                                 = readr::col_integer(),
    purpose_other                           = readr::col_character(),
    project_notes                           = readr::col_character(),
    custom_record_label                     = readr::col_character(),
    secondary_unique_field                  = readr::col_character(),
    is_longitudinal                         = readr::col_logical(),
    has_repeating_instruments_or_events     = readr::col_logical(),
    surveys_enabled                         = readr::col_logical(),
    scheduling_enabled                      = readr::col_logical(),
    record_autonumbering_enabled            = readr::col_logical(),
    randomization_enabled                   = readr::col_logical(),
    ddp_enabled                             = readr::col_logical(),
    project_irb_number                      = readr::col_character(),
    project_grant_number                    = readr::col_character(),
    project_pi_firstname                    = readr::col_character(),
    project_pi_lastname                     = readr::col_character(),
    display_today_now_button                = readr::col_logical(),
    missing_data_codes                      = readr::col_character(),
    external_modules                        = readr::col_character(),
    bypass_branching_erase_field_prompt     = readr::col_character(),
    .default                                = readr::col_character()
  )

  if (kernel$success) {
    try(
      {
        # Read column names returned by the API.
        present_names <-
          names(
            readr::read_csv(
              file           = I(kernel$raw_text),
              locale         = locale,
              n_max          = 0,
              show_col_types = FALSE
            )
          )

        # Build a column specification that matches the API response.
        col_types <- readr::cols()
        for (present_name in present_names) {
          col_types$cols <- c(col_types$cols, all_col_types$cols[present_name])
        }

        # Convert the raw text to a dataset.
        ds <-
          readr::read_csv(
            file            = I(kernel$raw_text),
            locale          = locale,
            col_types       = col_types,
            show_col_types  = FALSE
          )

        # Add any missing columns as NA.
        absent_names <- setdiff(names(all_col_types$cols), names(col_types$cols))
        # Don't test coverage for this block b/c it only executes for old versions of REDCap
        # nocov start
        for (absent_name in absent_names) {
          ds[absent_name] <- NA
          attr(ds, "spec")$cols <-
            c(attr(ds, "spec")$cols, all_col_types$cols[absent_name])
        }
        # nocov end
      },

      # Don't print the warning in the try block.  Print it below,
      #   where it's under the control of the caller.
      silent = TRUE
    )

    if (exists("ds") && inherits(ds, "data.frame")) {
      outcome_message <- sprintf(
        "%s rows were read from REDCap in %0.1f seconds.  The http status code was %i.",
        format(nrow(ds), big.mark = ",", scientific = FALSE, trim = TRUE),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      # If an operation is successful, the `raw_text` is no longer returned to
      #   save RAM.  The content is not really necessary with httr's status
      #   message exposed.
      kernel$raw_text   <- ""
    } else { # ds doesn't exist as a tibble.
      # nocov start
      # Override the 'success' determination from the http status code.
      #   and return an empty tibble
      kernel$success   <- FALSE
      ds               <- tibble::tibble()
      outcome_message  <- sprintf(
        "The REDCap log export failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  } else { # kernel fails
    # nocov start
    ds              <- tibble::tibble() # Return an empty tibble
    outcome_message <-
      if (any(grepl(kernel$regex_empty, kernel$raw_text))) {
        "The REDCapR log export operation was not successful.  The returned dataset was empty."  # nocov
      } else {
        sprintf(
          "The REDCapR log export operation was not successful.  The error message was:\n%s",
          kernel$raw_text
        )
      }
    # nocov end
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
