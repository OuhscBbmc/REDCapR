% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/redcap-read-eav-oneshot.R
\name{redcap_read_eav_oneshot}
\alias{redcap_read_eav_oneshot}
\title{Read/Export records from a REDCap project, returned as eav}
\usage{
redcap_read_eav_oneshot(
  redcap_uri,
  token,
  records = NULL,
  fields = NULL,
  forms = NULL,
  events = NULL,
  export_survey_fields = FALSE,
  export_data_access_groups = FALSE,
  filter_logic = "",
  datetime_range_begin = as.POSIXct(NA),
  datetime_range_end = as.POSIXct(NA),
  blank_for_gray_form_status = FALSE,
  http_response_encoding = "UTF-8",
  locale = readr::default_locale(),
  verbose = TRUE,
  config_options = NULL,
  handle_httr = NULL
)
}
\arguments{
\item{redcap_uri}{The
\href{https://en.wikipedia.org/wiki/Uniform_Resource_Identifier}{uri}/url
of the REDCap server
typically formatted as "https://server.org/apps/redcap/api/".
Required.}

\item{token}{The user-specific string that serves as the password for a
project.  Required.}

\item{records}{An array, where each element corresponds to the ID of a
desired record.  Optional.}

\item{fields}{An array, where each element corresponds to a desired project
field.  Optional.}

\item{forms}{An array, where each element corresponds to a desired project
form.  Optional.}

\item{events}{An array, where each element corresponds to a desired project
event.  Optional.}

\item{export_survey_fields}{A boolean that specifies whether to export the
survey identifier field (e.g., 'redcap_survey_identifier') or survey
timestamp fields (e.g., instrument+'_timestamp').
The timestamp outputs reflect the survey's \emph{completion} time
(according to the time and timezone of the REDCap server.)}

\item{export_data_access_groups}{A boolean value that specifies whether or
not to export the \code{redcap_data_access_group} field when data access groups
are utilized in the project. Default is \code{FALSE}. See the details below.}

\item{filter_logic}{String of logic text (e.g., \verb{[gender] = 'male'}) for
filtering the data to be returned by this API method, in which the API will
only return the records (or record-events, if a longitudinal project) where
the logic evaluates as TRUE.   An blank/empty string returns all records.}

\item{datetime_range_begin}{To return only records that have been created or
modified \emph{after} a given datetime, provide a
\href{https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html}{POSIXct}
value.
If not specified, REDCap will assume no begin time.}

\item{datetime_range_end}{To return only records that have been created or
modified \emph{before} a given datetime, provide a
\href{https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html}{POSIXct}
value.
If not specified, REDCap will assume no end time.}

\item{blank_for_gray_form_status}{A boolean value that specifies whether
or not to export blank values for instrument complete status fields that have
a gray status icon. All instrument complete status fields having a gray icon
can be exported either as a blank value or as "0" (Incomplete). Blank values
are recommended in a data export if the data will be re-imported into a
REDCap project. Default is \code{FALSE}.}

\item{http_response_encoding}{The encoding value passed to
\code{\link[httr:content]{httr::content()}}.  Defaults to 'UTF-8'.}

\item{locale}{a \code{\link[readr:locale]{readr::locale()}} object to specify preferences like
number, date, and time formats.  This object is passed to
\code{\link[readr:read_delim]{readr::read_csv()}}.  Defaults to \code{\link[readr:locale]{readr::default_locale()}}.}

\item{verbose}{A boolean value indicating if \code{message}s should be printed
to the R console during the operation.  The verbose output might contain
sensitive information (\emph{e.g.} PHI), so turn this off if the output might
be visible somewhere public. Optional.}

\item{config_options}{A list of options passed to \code{\link[httr:POST]{httr::POST()}}.
See details at \code{\link[httr:httr_options]{httr::httr_options()}}. Optional.}

\item{handle_httr}{The value passed to the \code{handle} parameter of
\code{\link[httr:POST]{httr::POST()}}.
This is useful for only unconventional authentication approaches.  It
should be \code{NULL} for most institutions.  Optional.}
}
\value{
Currently, a list is returned with the following elements:
\itemize{
\item \code{data}: A \code{\link[tibble:tibble]{tibble::tibble()}} of the desired records and columns.
\item \code{success}: A boolean value indicating if the operation was apparently
successful.
\item \code{status_code}: The
\href{https://en.wikipedia.org/wiki/List_of_HTTP_status_codes}{http status code}
of the operation.
\item \code{outcome_message}: A human readable string indicating the operation's
outcome.
\item \code{records_collapsed}: The desired records IDs, collapsed into a single
string, separated by commas.
\item \code{fields_collapsed}: The desired field names, collapsed into a single
string, separated by commas.
\item \code{filter_logic}: The filter statement passed as an argument.
\item \code{elapsed_seconds}: The duration of the function.
\item \code{raw_text}: If an operation is NOT successful, the text returned by
REDCap.  If an operation is successful, the \code{raw_text} is returned as an
empty string to save RAM.
}
}
\description{
This function uses REDCap's API to select and return data in an
\href{https://en.wikipedia.org/wiki/Entity\%E2\%80\%93attribute\%E2\%80\%93value_model}{eav}
}
\details{
If you do not pass an \code{export_data_access_groups} value, it will default
to \code{FALSE}. The following is from the API help page for version 10.5.1:
\emph{This flag is only viable if the user whose token is being used to make the
API request is \strong{not} in a data access group. If the user is in a group,
then this flag will revert to its default value}.
}
\examples{
\dontrun{
uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
token    <- "9A81268476645C4E5F03428B8AC3AA7B"

# Return all records and all variables.
ds <- REDCapR:::redcap_read_eav_oneshot(redcap_uri=uri, token=token)$data

# Return only records with IDs of 1 and 3
desired_records_v1 <- c(1, 3)
ds_some_rows_v1 <- REDCapR:::redcap_read_eav_oneshot(
  redcap_uri = uri,
  token      = token,
  records    = desired_records_v1
)$data

# Return only the fields record_id, name_first, and age
desired_fields_v1 <- c("record_id", "name_first", "age")
ds_some_fields_v1 <- REDCapR:::redcap_read_eav_oneshot(
  redcap_uri = uri,
  token      = token,
  fields     = desired_fields_v1
)$data

# Repeating
token <- "56F43A10D01D6578A46393394D76D88F"  # PHI-free demo: Repeating Instruments --Sparse # 2603
ds <- REDCapR:::redcap_read_eav_oneshot(redcap_uri=uri, token=token)$data
}
}
\references{
The official documentation can be found on the 'API Help Page'
and 'API Examples' pages on the REDCap wiki (\emph{i.e.},
https://community.projectredcap.org/articles/456/api-documentation.html and
https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus REDCap
administrator to send you the static material.
}
\author{
Will Beasley
}
