#' @title List authorized users
#'
#' @description List users authorized for a project.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  The verbose output might contain sensitive information (*e.g.* PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the `httr` package.  See the details below.  Optional.
#'
#' @return a \code{\link[utils:packageDescription]{utils::packageVersion}}.
#'
#' @note
#' **Documentation in REDCap 8.4.0**
#'
#' > This method allows you to export the list of users for a project,
#' > including their user privileges and also email address, first name, and last name.
#'
#' > Note: If the user has been assigned to a user role, it will return the user with
#' >the role's defined privileges.
#'
#' @examples
#' uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token    <- "06DEFB601F9B46847DAA9DF0CFA951B4"
#' result   <- REDCapR::redcap_users_export(redcap_uri=uri, token=token)
#' result$data_user
#' result$data_user_form

#' @export
redcap_users_export <- function( redcap_uri, token, verbose=TRUE, config_options=NULL ) {
  # version_error <- base::package_version("0.0.0")

  checkmate::assert_character(redcap_uri                , any.missing=F, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=F, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token                   = token,
    content                 = 'user',
    format                  = 'csv'
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
    user_rights                   = readr::col_logical(),
    data_access_groups            = readr::col_logical(),
    data_export                   = readr::col_character(),
    reports                       = readr::col_logical(),
    stats_and_charts              = readr::col_logical(),
    manage_survey_participants    = readr::col_logical(),
    calendar                      = readr::col_logical(),
    data_import_tool              = readr::col_logical(),
    data_comparison_tool          = readr::col_logical(),
    logging                       = readr::col_logical(),
    file_repository               = readr::col_logical(),
    data_quality_create           = readr::col_logical(),
    data_quality_execute          = readr::col_logical(),
    api_export                    = readr::col_logical(),
    api_import                    = readr::col_logical(),
    mobile_app                    = readr::col_logical(),
    mobile_app_download_data      = readr::col_logical(),
    record_create                 = readr::col_logical(),
    record_rename                 = readr::col_logical(),
    record_delete                 = readr::col_logical(),
    lock_records_all_forms        = readr::col_logical(),
    lock_records                  = readr::col_logical(),
    lock_records_customization    = readr::col_logical(),
    forms                         = readr::col_character()
  )

  # This is the important line that communicates with the REDCap server.
  kernel <- kernel_api(redcap_uri, post_body, config_options)

  if( kernel$success ) {
    try (
      {
        # readr::spec_csv(kernel$raw_text)
        ds_combined <- readr::read_csv(file=kernel$raw_text, col_types=col_types)

        # Remove the readr's `spec` attribute about the column names & types.
        attr(ds_combined, "spec") <- NULL

        ds_user <-
          ds_combined %>%
          dplyr::select(-.data$forms)

        ds_user_form <-
          ds_combined %>%
          dplyr::select(.data$username, .data$forms) %>%
          tidyr::separate_rows(.data$forms, sep=",") %>%
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
          dplyr::select(-.data$forms)
      },
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )

    if( exists("ds_user") & inherits(ds_user, "data.frame") ) {
      outcome_message <- paste0(
        "The REDCap users were successfully exported in ",
        round(kernel$elapsed_seconds, 1), " seconds.  The http status code was ",
        kernel$status_code, "."
      )
      kernel$raw_text   <- "" # If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
    } else {
      kernel$success   <- FALSE #Override the 'success' determination from the http status code.
      ds_user          <- data.frame() #Return an empty data.frame
      ds_user_form     <- data.frame() #Return an empty data.frame
      outcome_message  <- paste0("The REDCap user export failed.  The http status code was ", kernel$status_code, ".  The 'raw_text' returned was '", kernel$raw_text, "'.")
    }
  } else {
    ds_user          <- data.frame() #Return an empty data.frame
    ds_user_form     <- data.frame() #Return an empty data.frame
    outcome_message  <- paste0("The REDCap user export failed.  The error message was:\n",  kernel$raw_text)
  }

  if( verbose )
    message(outcome_message)

  return( list(
    data_user          = ds_user,
    data_user_form     = ds_user_form,
    success            = kernel$success,
    status_code        = kernel$status_code,
    outcome_message    = outcome_message,
    elapsed_seconds    = kernel$elapsed_seconds,
    raw_text           = kernel$raw_text
  ) )
}
