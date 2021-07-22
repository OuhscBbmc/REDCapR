#' @title Read/Export records from a REDCap project --still in development
#'
#' @description This function uses REDCap's API to select and return data.
#' This function is still in development.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap
#' project.  Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param records An array, where each element corresponds to the ID of a
#' desired record.  Optional.
#' @param records_collapsed A single string, where the desired ID values
#' are separated by commas.  Optional.
#' @param fields An array, where each element corresponds to a desired
#' project field.  Optional.
#' @param fields_collapsed A single string, where the desired field names
#' are separated by commas.  Optional.
#' @param forms An array, where each element corresponds to a desired project
#' field.  Optional.
#' @param forms_collapsed A single string, where the desired form names are
#' separated by commas.  Optional.
#' @param events An array, where each element corresponds to a desired project
#' event.  Optional.
#' @param events_collapsed A single string, where the desired event names are
#' separated by commas.  Optional.
#' @param raw_or_label A string (either `'raw'` or `'label'` that specifies
#' whether to export the raw coded values or the labels for the options of
#' multiple choice fields.  Default is `'raw'`.
#' @param raw_or_label_headers A string (either `'raw'` or `'label'` that
#' specifies for the CSV headers whether to export the variable/field names
#' (raw) or the field labels (label).  Default is `'raw'`.
# placeholder: exportCheckboxLabel
# placeholder: returnFormat
# placeholder: export_survey_fields
#' @param export_data_access_groups A boolean value that specifies whether or
#' not to export the `redcap_data_access_group` field when data access groups
#' are utilized in the project. Default is `FALSE`. See the details below.
#' @param filter_logic String of logic text (e.g., `[gender] = 'male'`) for
#' filtering the data to be returned by this API method, in which the API
#' will only return the records (or record-events, if a longitudinal project)
#' where the logic evaluates as TRUE.   An blank/empty string returns all
#' records.
#' @param datetime_range_begin To return only records that have been created or
#' modified *after* a given datetime, provide a
#' [POSIXct]
#' (https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html)
#' value.
#' If not specified, REDCap will assume no begin time.
#' @param datetime_range_end To return only records that have been created or
#' modified *before* a given datetime, provide a
#' [POSIXct]
#' (https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html)
#' value.
#' If not specified, REDCap will assume no end time.
#'
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the
#' `httr` package.  See the details below. Optional.
#'
#' @return Currently, a list is returned with the following elements:
#' * `data`: An R [base::data.frame()] of the desired records and columns.
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `records_collapsed`: The desired records IDs, collapsed into a single
#' string, separated by commas.
#' * `fields_collapsed`: The desired field names, collapsed into a single
#' string, separated by commas.
#' * `filter_logic`: The filter statement passed as an argument.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' @details
#' The full list of configuration options accepted by the `httr` package is
#' viewable by executing [httr::httr_options()].  The `httr`
#' package and documentation is available at
#' https://cran.r-project.org/package=httr.
#'
#' If you do not pass in this export_data_access_groups value, it will
#' default to `FALSE`. The following is from the API help page for version
#' 5.2.3:
#' This flag is only viable if the user whose token is being used to make
#' the API request is *not* in a data access group. If the user is in a
#' group, then this flag will revert to its default value.
#'
#' As of REDCap 6.14.3, this field is not exported in the EAV API call.
#'
#' @author Will Beasley
#'
#' @references The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus
#' REDCap administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token    <- "9A81268476645C4E5F03428B8AC3AA7B"
#'
#' #Return all records and all variables.
#' ds <- REDCapR:::redcap_read_oneshot_eav(redcap_uri=uri, token=token)$data
#'
#' #Return only records with IDs of 1 and 3
#' desired_records_v1 <- c(1, 3)
#' ds_some_rows_v1    <- REDCapR::redcap_read_oneshot_eav(
#'    redcap_uri = uri,
#'    token      = token,
#'    records    = desired_records_v1
#' )$data
#'
#' #Return only the fields record_id, name_first, and age
#' desired_fields_v1 <- c("record_id", "name_first", "age")
#' ds_some_fields_v1 <- redcap_read_oneshot_eav(
#'    redcap_uri = uri,
#'    token      = token,
#'    fields     = desired_fields_v1
#' )$data
#'}

#' @importFrom magrittr %>%
#' @importFrom utils type.convert
#' @importFrom rlang .data
# @export  # Not currently exported.
redcap_read_oneshot_eav <- function(
  redcap_uri,
  token,
  records                       = NULL,
  records_collapsed             = "",
  fields                        = NULL,
  fields_collapsed              = "",
  forms                         = NULL,
  forms_collapsed               = "",
  events                        = NULL,
  events_collapsed              = "",
  raw_or_label                  = "raw",
  raw_or_label_headers          = "raw",
  # placeholder: exportCheckboxLabel
  # placeholder: returnFormat
  # placeholder: export_survey_fields
  export_data_access_groups     = FALSE,
  filter_logic                  = "",
  datetime_range_begin          = as.POSIXct(NA),
  datetime_range_end            = as.POSIXct(NA),

  # placeholder: guess_type
  # placeholder: guess_max
  verbose                       = TRUE,
  config_options                = NULL
) {

  checkmate::assert_character(redcap_uri                , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_atomic(records                      , any.missing=TRUE , min.len=0)
  checkmate::assert_character(records_collapsed         , any.missing=TRUE , len=1, pattern="^.{0,}$", null.ok=TRUE )
  checkmate::assert_character(fields                    , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE )
  checkmate::assert_character(fields_collapsed          , any.missing=TRUE , len=1, pattern="^.{0,}$", null.ok=TRUE )
  checkmate::assert_character(forms                     , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE )
  checkmate::assert_character(forms_collapsed           , any.missing=TRUE , len=1, pattern="^.{0,}$", null.ok=TRUE )
  checkmate::assert_character(events                    , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE )
  checkmate::assert_character(events_collapsed          , any.missing=TRUE , len=1, pattern="^.{0,}$", null.ok=TRUE)
  checkmate::assert_character(raw_or_label              , any.missing=FALSE, len=1)
  checkmate::assert_subset(   raw_or_label              , c("raw", "label"))
  checkmate::assert_character(raw_or_label_headers      , any.missing=FALSE, len=1)
  checkmate::assert_subset(   raw_or_label_headers      , c("raw", "label"))
  # placeholder: export_checkbox_label --irrelevant in EAV
  # placeholder: returnFormat
  # placeholder: export_survey_fields
  checkmate::assert_logical(  export_data_access_groups , any.missing=FALSE, len=1)
  checkmate::assert_character(filter_logic              , any.missing=FALSE, len=1, pattern="^.{0,}$")
  checkmate::assert_posixct(  datetime_range_begin      , any.missing=TRUE , len=1, null.ok=TRUE)
  checkmate::assert_posixct(  datetime_range_end        , any.missing=TRUE , len=1, null.ok=TRUE)

  # placeholder: checkmate::assert_logical(  guess_type                , any.missing=FALSE, len=1)
  # placeholder: checkmate::assert_integerish(guess_max                , any.missing=FALSE, len=1, lower=1)
  checkmate::assert_logical(  verbose                   , any.missing=FALSE, len=1, null.ok=TRUE)
  checkmate::assert_list(     config_options            , any.missing=TRUE ,        null.ok=TRUE)

  validate_field_names(fields, stop_on_error = TRUE)

  token               <- sanitize_token(token)
  records_collapsed   <- collapse_vector(records  , records_collapsed)
  fields_collapsed    <- collapse_vector(fields   , fields_collapsed)
  forms_collapsed     <- collapse_vector(forms    , forms_collapsed)
  events_collapsed    <- collapse_vector(events   , events_collapsed)
  export_data_access_groups <- ifelse(export_data_access_groups, "true", "false")
  filter_logic        <- filter_logic_prepare(filter_logic)
  datetime_range_begin<- dplyr::coalesce(strftime(datetime_range_begin, "%Y-%m-%d %H:%M:%S"), "")
  datetime_range_end  <- dplyr::coalesce(strftime(datetime_range_end  , "%Y-%m-%d %H:%M:%S"), "")
  verbose             <- verbose_prepare(verbose)

  if (1L <= nchar(fields_collapsed) )
    validate_field_names_collapsed(fields_collapsed, stop_on_error = TRUE)

  post_body <- list(
    token                   = token,
    content                 = "record",
    format                  = "csv",
    type                    = "eav",
    rawOrLabel              = raw_or_label,
    rawOrLabelHeaders       = raw_or_label_headers,
    exportDataAccessGroups  = export_data_access_groups,
    filterLogic             = filter_logic,
    dateRangeBegin          = datetime_range_begin,
    dateRangeEnd            = datetime_range_end
    # record, fields, forms & events are specified below
  )

  if (0L < nchar(records_collapsed)) post_body$records  <- records_collapsed
  if (0L < nchar(fields_collapsed )) post_body$fields   <- fields_collapsed
  if (0L < nchar(forms_collapsed  )) post_body$forms    <- forms_collapsed
  if (0L < nchar(events_collapsed )) post_body$events   <- events_collapsed

  # This is the important line that communicates with the REDCap server.
  kernel      <- kernel_api(redcap_uri, post_body, config_options)

  if (!kernel$success) {
    error_message     <- sprintf(
      "The REDCapR record export operation was not successful.  The error message was:\n%s",
      kernel$raw_text
    )
    stop(error_message)
  }


  ds_metadata <-
    REDCapR::redcap_metadata_read(
      redcap_uri,
      token,
      forms_collapsed = forms_collapsed
    )$data
  ds_variable <- REDCapR::redcap_variables(redcap_uri, token)$data

  if (kernel$success) {
    try (
      {
        ds_eav <-
          readr::read_csv(
            file            = I(kernel$raw_text),
            show_col_types  = FALSE
          )

        ds_metadata_expanded <-
          ds_metadata %>%
          dplyr::select(.data$field_name, .data$select_choices_or_calculations, .data$field_type) %>%
          dplyr::mutate(
            is_checkbox   = (.data$field_type == "checkbox"),
            ids           = dplyr::if_else(.data$is_checkbox, .data$select_choices_or_calculations, "1"),
            ids           = gsub("(\\d+),.+?(\\||$)", "\\1", .data$ids),
            ids           = strsplit(.data$ids, " ")
          ) %>%
          dplyr::select(-.data$select_choices_or_calculations, -.data$field_type) %>%
          tidyr::unnest(.data$ids) %>%
          dplyr::transmute(
            .data$is_checkbox,
            field_name          = dplyr::if_else(.data$is_checkbox, paste0(.data$field_name, "___", .data$ids), .data$field_name)
          ) %>%
          tibble::as_tibble()

        distinct_checkboxes <-
          ds_metadata_expanded %>%
          dplyr::filter(.data$is_checkbox) %>%
          dplyr::pull(.data$field_name)

        ds_possible_checkbox_rows  <-
          tidyr::crossing(
            field_name = distinct_checkboxes,
            record     = unique(ds_eav$record),
            field_type = "checkbox",
            event_id   =  unique(ds_eav$event_id)
          )

        variables_to_keep <-
          ds_metadata_expanded %>%
          dplyr::select(.data$field_name) %>%
          dplyr::union(
            ds_variable %>%
              dplyr::select(field_name = .data$export_field_name) %>%
              dplyr::filter(grepl("^\\w+?_complete$", .data$field_name))
          ) %>%
          dplyr::pull(.data$field_name) #%>% rev()

        ds_eav_2 <-
          ds_eav %>%
          dplyr::left_join(
            ds_metadata %>%
              dplyr::select(.data$field_name, .data$field_type),
            by = "field_name"
          ) %>%
          dplyr::mutate(
            field_name = dplyr::if_else(!is.na(.data$field_type) & (.data$field_type == "checkbox"), paste0(.data$field_name, "___", .data$value), .data$field_name)
          ) %>%
          dplyr::full_join(ds_possible_checkbox_rows, by=c("record", "field_name", "field_type", "event_id")) %>%
          dplyr::mutate(
            value      = dplyr::if_else(!is.na(.data$field_type) & (.data$field_type == "checkbox"), as.character(!is.na(.data$value)), .data$value)
          )

        . <- NULL # For the sake of avoiding an R CMD check note.
        ds <-
          ds_eav_2 %>%
          dplyr::select(-.data$field_type) %>%
          # dplyr::select(-.data$redcap_repeat_instance) %>%        # TODO: need a good fix for repeats
          # tidyr::drop_na(event_id) %>%                            # TODO: need a good fix for repeats
          tidyr::spread(key = .data$field_name, value = .data$value) %>%
          dplyr::select(.data = ., !!intersect(variables_to_keep, colnames(.)))

        ds_2 <-
          ds %>%
          dplyr::mutate_if(is.character, ~type.convert(., as.is = FALSE)) %>%
          dplyr::mutate_if(is.factor   , as.character)
      }, #Convert the raw text to a dataset.
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )

    if (ifelse(exists("ds_2"), inherits(ds_2, "data.frame"), FALSE)) {
      outcome_message <- sprintf(
        "%s records and %s columns were read from REDCap in %0.1f seconds.  The http status code was %i.",
        format(  nrow(ds), big.mark = ",", scientific = FALSE, trim = TRUE),
        format(length(ds), big.mark = ",", scientific = FALSE, trim = TRUE),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      kernel$raw_text   <- "" # If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
    } else {
      kernel$success    <- FALSE #Override the 'success' determination from the http status code.
      ds_2              <- tibble::tibble() #Return an empty data.frame
      outcome_message   <- sprintf(
        "The REDCap read failed.  The http status code was %s.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
    }
  } else {
    ds_2            <- tibble::tibble() #Return an empty data.frame
    outcome_message <- if (any(grepl(kernel$regex_empty, kernel$raw_text))) {
      "The REDCapR read/export operation was not successful.  The returned dataset was empty."
    } else {
      sprintf(
        "The REDCapR read/export operation was not successful.  The error message was:\n%s",
        kernel$raw_text
      )
    }
  }

  if (verbose)
    message(outcome_message)

  list(
    data               = ds_2,
    success            = kernel$success,
    status_code        = kernel$status_code,
    outcome_message    = outcome_message,
    records_collapsed  = records_collapsed,
    fields_collapsed   = fields_collapsed,
    filter_logic       = filter_logic,
    datetime_range_begin= datetime_range_begin,
    datetime_range_end  = datetime_range_end,
    events_collapsed   = events_collapsed,
    elapsed_seconds    = kernel$elapsed_seconds,
    raw_text           = kernel$raw_text
  )
}
