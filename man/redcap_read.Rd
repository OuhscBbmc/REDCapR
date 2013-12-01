\name{redcap_read}
\alias{redcap_read}
\title{Read records from a REDCap project.}
\usage{
  redcap_read(redcap_uri, token, records = NULL,
    records_collapsed = NULL, fields = NULL,
    fields_collapsed = NULL, verbose = TRUE,
    cert_location = NULL)
}
\arguments{
  \item{redcap_uri}{The URI of the REDCap project.
  Required.}

  \item{token}{The user-specific string that serves as the
  password for a project.  Required.}

  \item{records}{An array, where each element corresponds
  to the ID of a desired record.  Optional.}

  \item{records_collapsed}{A single string, where the
  desired ID values are separated by commas.  Optional.}

  \item{fields}{An array, where each element corresponds a
  desired project field.  Optional.}

  \item{fields_collapsed}{A single string, where the
  desired field names are separated by commas.  Optional.}

  \item{verbose}{A boolean value indicating if
  \code{message}s should be printed to the R console during
  the operation.  Optional.}

  \item{cert_location}{If present, this string should point
  to the location of the cert files required for SSL.  If
  the value is missing or NULL, the server's identity will
  not be verified.}
}
\value{
  Currently, a list is returned with the following
  elements, \enumerate{ \item \code{data}: an R
  \code{data.frame} of the desired records and columns.
  \item \code{raw_csv}: the text of comma separated values
  returned by REDCap through \code{RCurl}.  \item
  \code{records_collapsed}: the desired records IDs,
  collapsed into a single string, separated by commas.
  \item \code{fields_collapsed}: the desired field names,
  collapsed into a single string, separated by commas.
  \item \code{elapsed_seconds}: the duration of the
  function.  \item \code{status_message}: a boolean value
  indicating if the operation was apparently successful. }
}
\description{
  This function uses REDCap's
  \href{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}{API}
  to select and return data.
}
\details{
  I like how \href{http://sburns.org/PyCap/}{PyCap} creates
  a `project' object with methods that read and write from
  REDCap.  However this isn't a style that R clients
  typically use. I like the logic that it's associated with
  a particular REDCap project that shouldn't change between
  calls. As a compromise, I think I'll wrap the uri, token,
  and cert location into a single \code{S4} object that's
  passed to these methods.  It will make these calls take
  less space.
}
\examples{
\dontrun{
library(REDCapR) #Load the package into the current R session.
uri <- "https://ouhsc.edu/redcap-test"
token <- "ReadThisFromAnEncryptedSomethingButNotHardCodedSourceCode"

#Return all records and all variables.
ds_all_rows_all_fields <- redcap_read(redcap_uri=uri, token=token)$data

#Return only records with IDs of 101, 102, 103, and 104
desired_records_v1 <- c(101, 102, 103, 104)
ds_some_rows_v1 <- redcap_read(
   redcap_uri=uri,
   token=token,
   records=desired_records_v1
)$data

#Return only records with IDs of 101, 102, 103, and 104 (alternate way)
desired_records_v2 <- "101, 102, 103, 104"
ds_some_rows_v2 <- redcap_read(
   redcap_uri=uri,
   token=token,
   records_collapsed=desired_records_v2
)$data

#Return only the fields recordid, dob, gender, and apgar
desired_fields_v1 <- c("recordid", "dob", "gender", "apgar")
ds_some_fields_v1 <- redcap_read(
   redcap_uri=uri,
   token=token,
   fields=desired_fields_v1
)$data

#Return only the fields recordid, dob, gender, and apgar (alternate way)
desired_fields_v2 <- "recordid, dob, gender, apgar"
ds_some_fields_v2 <- redcap_read(
   redcap_uri=uri,
   token=token,
   fields_collapsed=desired_fields_v2
)$data

} #End DontRun
}
\author{
  Will Beasley
}
\references{
  The `API Examples' page on the REDCap wiki
  (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}).
  A user account is required.
}

