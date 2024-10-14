#' @name redcap_project
#' @export redcap_project
#' @importFrom methods new
#'
#' @title
#' A Reference Class to make later calls to REDCap more convenient
#'
#' @description
#' This `Reference Class` represents a REDCap project.
#' Once some values are set that are specific to a REDCap project
#' (such as the URI and token), later calls are less verbose
#' (such as reading and writing data).
#'
#' @field redcap_uri The URI (uniform resource identifier) of the
#' REDCap project.  Required.
#' @field token token The user-specific string that serves as the
#' password for a project.  Required.
#'
#' @examples
#' uri     <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token   <- "9A068C425B1341D69E83064A2D273A70"
#' \dontrun{
#' project <- REDCapR::redcap_project$new(redcap_uri=uri, token=token)
#' ds_all  <- project$read()
#'
#' # Demonstrate how repeated calls are more concise when the token and
#' #   url aren't always passed.
#' ds_skinny <- project$read(fields=c("record_id", "sex", "height"))$data
#'
#' ids_of_males    <- ds_skinny$record_id[ds_skinny$sex==1]
#' ids_of_shorties <- ds_skinny$record_id[ds_skinny$height < 40]
#'
#' ds_males        <- project$read(records=ids_of_males, batch_size=2)$data
#' ds_shorties     <- project$read(records=ids_of_shorties)$data
#'
#' }
#' if (FALSE) {
#' # Switch the Genders
#' sex_original   <- ds_skinny$sex
#' ds_skinny$sex  <- (1 - ds_skinny$sex)
#' project$write(ds_skinny)
#'
#' # Switch the Genders back
#' ds_skinny$sex <- sex_original
#' project$write(ds_skinny)
#' }

redcap_project <- setRefClass(
  Class = "redcap_project",

  fields = list(
    redcap_uri  = "character",
    token       = "character",
    verbose     = "logical"
  ),

  methods = list(

    read = function(
      batch_size                  = 100L,
      interbatch_delay            = 0,
      records                     = NULL,
      fields                      = NULL,
      forms                       = NULL,
      events                      = NULL,
      raw_or_label                = "raw",
      raw_or_label_headers        = "raw",
      export_checkbox_label       = FALSE,
      # placeholder returnFormat
      export_survey_fields        = FALSE,
      export_data_access_groups   = FALSE,
      filter_logic                  = "",
      col_types                     = NULL,
      guess_type                    = TRUE,
      guess_max                     = 1000,
      verbose                       = TRUE,
      config_options                = NULL
    ) {

      "Exports records from a REDCap project."

      return(REDCapR::redcap_read(
        batch_size                    = batch_size,
        interbatch_delay              = interbatch_delay,

        redcap_uri                    = redcap_uri,
        token                         = token,
        records                       = records,
        fields                        = fields,
        forms                         = forms,
        events                        = events,
        raw_or_label                  = raw_or_label,
        raw_or_label_headers          = raw_or_label_headers,
        export_checkbox_label         = export_checkbox_label,
        # placeholder returnFormat
        export_survey_fields          = export_survey_fields,
        export_data_access_groups     = export_data_access_groups,
        filter_logic                  = filter_logic,
        col_types                     = col_types,
        guess_type                    = guess_type,
        # placeholder guess_max
        verbose                       = verbose,
        config_options                = config_options
      ))
    },

    write = function(
      ds_to_write,
      batch_size            = 100L,
      interbatch_delay      = 0,
      continue_on_error     = FALSE,
      verbose               = TRUE,
      config_options        = NULL
    ) {

      "Imports records to a REDCap project."

      return(REDCapR::redcap_write(
        ds_to_write             = ds_to_write,
        batch_size              = batch_size,
        interbatch_delay        = interbatch_delay,
        continue_on_error       = continue_on_error,
        redcap_uri              = redcap_uri,
        token                   = token,
        verbose                 = verbose,
        config_options          = config_options
      ))
    }
  ) # End methods list
) # End class

# https://adv-r.had.co.nz/OO-essentials.html # nolint
# https://stackoverflow.com/questions/21875596/mapping-a-c-sharp-class-definition-to-an-r-reference-class-definition # nolint
