#' @title
#' List authorized users
#'
#' @description
#' List users authorized for a project.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
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
#; Currently, a list is returned with the following elements:
#' * `data_user`: A [tibble::tibble()] of all users associated with the project.
#' One row represents one user.
#' * `data_user_form`: A [tibble::tibble()] of permissions for users and forms.
#' One row represents a unique user-by-form combination.
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
#' @note
#' **Documentation in REDCap 8.4.0**
#'
#' ```
#' This method allows you to export the list of users for a project,
#' including their user privileges and also email address, first name,
#' and last name.
#'
#' Note: If the user has been assigned to a user role, it will return
#' the user with the role's defined privileges.
#' ```
#'
#' @examples
#' \dontrun{
#' uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token    <- "0BF920AAF9566A8E603F528A498A5729" # dag
#' result   <- REDCapR::redcap_users_export(redcap_uri=uri, token=token)
#' result$data_user
#' result$data_user_form
#' }

#' @importFrom magrittr %>%
#' @export
redcap_users_export <- function(
  redcap_uri,
  token,
  verbose         = TRUE,
  config_options  = NULL,
  handle_httr       = NULL
) {

  checkmate::assert_character(redcap_uri , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token      , any.missing=FALSE, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token    = token,
    content  = "user",
    format   = "csv"
  )

  col_types <- readr::cols(
    username                      = readr::col_character(),
    email                         = readr::col_character(),
    firstname                     = readr::col_character(),
    lastname                      = readr::col_character(),
    expiration                    = readr::col_date(),
    data_access_group             = readr::col_character(),
    data_access_group_id          = readr::col_character(),
    design                        = readr::col_logical(),
    user_rights                   = readr::col_integer(),
    data_access_groups            = readr::col_logical(),
    # data_export                   = readr::col_character(), # dropped sometime between 10.5.1 and 12.5.2
    reports                       = readr::col_logical(),
    stats_and_charts              = readr::col_logical(),
    manage_survey_participants    = readr::col_logical(),
    calendar                      = readr::col_logical(),
    data_import_tool              = readr::col_logical(),
    data_comparison_tool          = readr::col_logical(),
    logging                       = readr::col_logical(),
    email_logging                 = readr::col_logical(), # added 14.6.0
    file_repository               = readr::col_logical(),
    data_quality_create           = readr::col_logical(),
    data_quality_execute          = readr::col_logical(),
    api_export                    = readr::col_logical(),
    api_import                    = readr::col_logical(),
    api_modules                   = readr::col_logical(), # added 14.6.0 maybe
    mobile_app                    = readr::col_logical(),
    mobile_app_download_data      = readr::col_logical(),
    record_create                 = readr::col_logical(),
    record_rename                 = readr::col_logical(),
    record_delete                 = readr::col_logical(),
    lock_records_all_forms        = readr::col_logical(),
    lock_records                  = readr::col_logical(),
    lock_records_customization    = readr::col_logical(),
    forms                         = readr::col_character(),
    forms_export                  = readr::col_character(),  # Added sometime between 10.5.1 and 12.5.2
  )

  # This is the important call that communicates with the REDCap server.
  kernel <-
    kernel_api(
      redcap_uri      = redcap_uri,
      post_body       = post_body,
      config_options  = config_options,
      handle_httr     = handle_httr
    )

  if (kernel$success) {
    try(
      { # readr::spec_csv(kernel$raw_text)
        ds_combined <- readr::read_csv(
          file            = I(kernel$raw_text),
          col_types       = col_types,
          show_col_types  = FALSE
        )

        # Remove the readr's `spec` attribute about the column names & types.
        attr(ds_combined, "spec") <- NULL

        ds_user <-
          ds_combined %>%
          dplyr::select(-"forms")

        ds_user_form <-
          ds_combined %>%
          dplyr::select("username", "forms") %>%
          tidyr::separate_rows("forms", sep = ",") %>%
          # tidyr::separate_(
          #   col     = "form",
          #   into    = c("form_name", "permission"),
          #   sep     = ":",
          #   convert = FALSE
          # ) %>%
          dplyr::mutate(
            form_name     = sub("^(\\w+):([0-2])$", "\\1", .data$forms),
            permission_id = sub("^(\\w+):([0-2])$", "\\2", .data$forms),
            permission_id = as.integer(.data$permission_id),
            permission    = constant_to_form_rights(.data$permission_id)
            #   translate_form_rights(
            #   .data$permission_id,
            #   # levels      = c(0L          , 2L          , 1L          ),
            #   levels      = REDCapR::constant(c("form_rights_no_access", "form_rights_readonly", "form_rights_edit_form", "form_rights_edit_survey")) ,
            #   labels      = c("No Access" , "Read Only" , "Read/Write"),
            #   ordered     = TRUE
            # )
          ) %>%
          dplyr::select(-"forms")
      },
      silent = TRUE
      # Don't print the warning in the try block.  Print it below, where it's
      #   under the control of the caller.
    )

    if (exists("ds_user") && inherits(ds_user, "data.frame")) {
      outcome_message <- sprintf(
        "The REDCap users were successfully exported in %0.1f seconds.  The http status code was %i.",
        kernel$elapsed_seconds,
        kernel$status_code
      )
      outcome_message <- sprintf(
        "The REDCap users were successfully exported in %0.1f seconds.  The http status code was %i.",
        kernel$elapsed_seconds,
        kernel$status_code
      )
      kernel$raw_text   <- ""
      # If an operation is successful, the `raw_text` is no longer returned
      #   to save RAM.  The content is not really necessary with httr's
      #   status message exposed.
    } else {
      # nocov start
      kernel$success   <- FALSE # Override the 'success' http status code.
      ds_user          <- tibble::tibble() # Return an empty data.frame
      ds_user_form     <- tibble::tibble() # Return an empty data.frame
      outcome_message  <- sprintf(
        "The REDCap user export failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  } else {
    ds_user          <- tibble::tibble() # Return an empty data.frame
    ds_user_form     <- tibble::tibble() # Return an empty data.frame
    outcome_message  <- sprintf(
      "The REDCap user export failed.  The error message was:\n%s",
      kernel$raw_text
    )
  }

  if (verbose)
    message(outcome_message)

  list(
    data_user          = ds_user,
    data_user_form     = ds_user_form,
    success            = kernel$success,
    status_code        = kernel$status_code,
    outcome_message    = outcome_message,
    elapsed_seconds    = kernel$elapsed_seconds,
    raw_text           = kernel$raw_text
  )
}
