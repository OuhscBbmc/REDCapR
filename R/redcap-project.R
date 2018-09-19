#' @name redcap_project
#' @export redcap_project
#' @importFrom methods new
#'
#' @title A `Reference Class` to make later calls to REDCap more convenient
#'
#' @description This `Reference Class` represents a REDCap project.
#' Once some values are set that are specific to a REDCap project (such as the URI and token),
#' later calls are less verbose (such as reading and writing data).  The functionality
#'
#' @field redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @field token token The user-specific string that serves as the password for a project.  Required.
#'
#' @examples
#' uri     <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token   <- "D70F9ACD1EDD6F151C6EA78683944E98"
#' \dontrun{
#' project <- REDCapR::redcap_project$new(redcap_uri=uri, token=token)
#' ds_all  <- project$read()
#'
#' #Demonstrate how repeated calls are more concise when the token and url aren't always passed.
#' ds_three_columns <- project$read(fields=c("record_id", "sex", "height"))$data
#'
#' ids_of_males vv <- ds_three_columns$record_id[ds_three_columns$sex==1]
#' ids_of_shorties <- ds_three_columns$record_id[ds_three_columns$height < 40]
#'
#' ds_males        <- project$read(records=ids_of_males, batch_size=2)$data
#' ds_shorties     <- project$read(records=ids_of_shorties)$data
#'
#' #Switch the Genders
#' sex_original         <- ds_three_columns$sex
#' ds_three_columns$sex <- (1 - ds_three_columns$sex)
#' project$write(ds_three_columns)
#'
#' #Switch the Genders back
#' ds_three_columns$sex <- sex_original
#' project$write(ds_three_columns)
#' }

redcap_project <- setRefClass(
  Class = "redcap_project",

  fields = list(
    redcap_uri  = "character",
    token       = "character"
  ),

  methods = list(

    read = function(
      batch_size                  = 100L,
      interbatch_delay            = 0,
      records                     = NULL , records_collapsed = "",
      fields                      = NULL , fields_collapsed  = "",
      forms                       = NULL , forms_collapsed   = "",
      events                      = NULL , events_collapsed  = "",
      raw_or_label                = 'raw',
      raw_or_label_headers        = 'raw',
      export_checkbox_label       = FALSE,
      # placeholder returnFormat
      export_survey_fields        = FALSE,
      export_data_access_groups   = FALSE,
      filter_logic                  = "",

      guess_type                    = TRUE,
      guess_max                     = 1000L,
      verbose                       = TRUE,
      config_options                = NULL
    ) {

      "Exports records from a REDCap project."

      return( REDCapR::redcap_read(
        batch_size                    = batch_size,
        interbatch_delay              = interbatch_delay,

        redcap_uri                    = redcap_uri,
        token                         = token,
        records                       = records                  , records_collapsed = records_collapsed,
        fields                        = fields                   , fields_collapsed  = fields_collapsed ,
        forms                         = forms                    , forms_collapsed   = forms_collapsed  ,
        events                        = events                   , events_collapsed  = events_collapsed ,
        raw_or_label                  = raw_or_label,
        raw_or_label_headers          = raw_or_label_headers,
        export_checkbox_label         = export_checkbox_label,
        # placeholder returnFormat
        export_survey_fields          = export_survey_fields,
        export_data_access_groups     = export_data_access_groups,
        filter_logic                  = filter_logic,

        guess_type                    = guess_type,
        # placeholder guess_max
        verbose                       = verbose,
        config_options                = config_options
      ) )
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

      return( REDCapR::redcap_write(
        ds_to_write             = ds_to_write,
        batch_size              = batch_size,
        interbatch_delay        = interbatch_delay,
        continue_on_error       = continue_on_error,
        redcap_uri              = redcap_uri,
        token                   = token,
        config_options          = config_options
      ) )
    }
  ) #End methods list
) #End class
# http://adv-r.had.co.nz/OO-essentials.html

# http://stackoverflow.com/questions/21875596/mapping-a-c-sharp-class-definition-to-an-r-reference-class-definition

# REDCapR::redcap_project$new()
# # library(REDCapR) #Load the package into the current R session.
# uri <- "https://bbmc.ouhsc.edu/redcap/api/"
# token <- "9A81268476645C4E5F03428B8AC3AA7B"
# token <- "D70F9ACD1EDD6F151C6EA78683944E98"
# # #
# # # uri <- "https://redcap.vanderbilt.edu/api/"
# # # token <- "8E66DB6844D58E990075AFB51658A002"
# #
# project <- redcap_project$new(redcap_uri=uri, token=token)
# ds_three_columns <- project$redcap_uri(fields=c("record_id", "sex", "age"))$data
# ds_three_columns$sex <- (1- ds_three_columns$sex)
# ds_three_columns <- project$(fields=c("record_id", "sex", "age"))$data
#
# ids_of_males <- ds_three_columns[ds_three_columns$sex==1, "record_id"]
# ids_of_minors <- ds_three_columns[ds_three_columns$age < 18, "record_id"]
#
# dsMales <- project$read(records=ids_of_males, batch_size=2)$data
# dsMinors <- project$read(records=ids_of_minors)$data
