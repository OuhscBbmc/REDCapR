% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/redcap-file-upload-oneshot.R
\name{redcap_file_upload_oneshot}
\alias{redcap_file_upload_oneshot}
\alias{redcap_upload_file_oneshot}
\title{Upload a file into to a REDCap project record}
\usage{
redcap_file_upload_oneshot(
  file_name,
  record,
  redcap_uri,
  token,
  field,
  event = "",
  verbose = TRUE,
  config_options = NULL,
  handle_httr = NULL
)
}
\arguments{
\item{file_name}{The name of the relative or full file to be uploaded into
the REDCap project.  Required.}

\item{record}{The record ID where the file is to be imported.  Required}

\item{redcap_uri}{The
\href{https://en.wikipedia.org/wiki/Uniform_Resource_Identifier}{uri}/url
of the REDCap server
typically formatted as "https://server.org/apps/redcap/api/".
Required.}

\item{token}{The user-specific string that serves as the password for a
project.  Required.}

\item{field}{The name of the field where the file is saved in REDCap.
Required}

\item{event}{The name of the event where the file is saved in REDCap.
Optional}

\item{verbose}{A boolean value indicating if \code{message}s should be printed
to the R console during the operation.  Optional.}

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
\item \code{success}: A boolean value indicating if the operation was apparently
successful.
\item \code{status_code}: The
\href{https://en.wikipedia.org/wiki/List_of_HTTP_status_codes}{http status code}
of the operation.
\item \code{outcome_message}: A human readable string indicating the operation's
outcome.
\item \code{records_affected_count}: The number of records inserted or updated.
\item \code{affected_ids}: The subject IDs of the inserted or updated records.
\item \code{elapsed_seconds}: The duration of the function.
\item \code{raw_text}: If an operation is NOT successful, the text returned by
REDCap.  If an operation is successful, the \code{raw_text} is returned as
an empty string to save RAM.
}
}
\description{
This function uses REDCap's API to upload a file.
}
\details{
Currently, the function doesn't modify any variable types to conform to
REDCap's supported variables.  See \code{\link[=validate_for_write]{validate_for_write()}} for a helper
function that checks for some common important conflicts.

The function \code{redcap_upload_file_oneshot()} is soft-deprecated
as of REDCapR 1.2.0.
Please rename to \code{\link[=redcap_file_upload_oneshot]{redcap_file_upload_oneshot()}}.
}
\examples{
\dontrun{
# Define some constants
uri    <- "https://bbmc.ouhsc.edu/redcap/api/"
token  <- "D70F9ACD1EDD6F151C6EA78683944E98" # The simple project -pid 213
field  <- "mugshot"
event  <- "" # only for longitudinal events

# Upload a single image file.
record    <- 1
file_path <- system.file("test-data/mugshot-1.jpg", package = "REDCapR")

REDCapR::redcap_file_upload_oneshot(
  file_name  = file_path,
  record     = record,
  field      = field,
  redcap_uri = redcap_uri,
  token      = token
)

# Upload a collection of five images.
records    <- 1:5
file_paths <- system.file(
  paste0("test-data/mugshot-", records, ".jpg"),
  package="REDCapR"
)

for (i in seq_along(records)) {
  record    <- records[i]
  file_path <- file_paths[i]
  REDCapR::redcap_file_upload_oneshot(
    file_name  = file_path,
    record     = record,
    field      = field,
    redcap_uri = redcap_uri,
    token      = token
  )
}
}
}
\references{
The official documentation can be found on the 'API Help Page'
and 'API Examples' pages on the REDCap wiki (ie,
https://community.projectredcap.org/articles/456/api-documentation.html and
https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus REDCap
administrator to send you the static material.
}
\author{
Will Beasley, John J. Aponte
}
