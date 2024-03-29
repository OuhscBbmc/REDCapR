% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/redcap-metadata-read.R
\name{redcap_metadata_read}
\alias{redcap_metadata_read}
\title{Export the metadata of a REDCap project}
\usage{
redcap_metadata_read(
  redcap_uri,
  token,
  forms = NULL,
  fields = NULL,
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

\item{forms}{An array, where each element corresponds to the REDCap form
of the desired fields.  Optional.}

\item{fields}{An array, where each element corresponds to a desired project
field.  Optional.}

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
\item \code{data}: An R \code{\link[tibble:tibble]{tibble::tibble()}} of the desired fields (as rows).
\item \code{success}: A boolean value indicating if the operation was apparently
successful.
\item \code{status_codes}: A collection of
\href{https://en.wikipedia.org/wiki/List_of_HTTP_status_codes}{http status codes},
separated by semicolons.  There is one code for each batch attempted.
\item \code{outcome_messages}: A collection of human readable strings indicating the
operations' semicolons.  There is one code for each batch attempted.  In an
unsuccessful operation, it should contain diagnostic information.
\item \code{forms_collapsed}: The desired records IDs, collapsed into a single
string, separated by commas.
\item \code{fields_collapsed}: The desired field names, collapsed into a single
string, separated by commas.
\item \code{elapsed_seconds}: The duration of the function.
}
}
\description{
Export the metadata (as a data dictionary) of a REDCap project
as a \code{\link[tibble:tibble]{tibble::tibble()}}. Each row in the data dictionary corresponds to
one field in the project's dataset.
}
\examples{
\dontrun{
uri   <- "https://bbmc.ouhsc.edu/redcap/api/"

# A simple project (pid 153)
token <- "9A81268476645C4E5F03428B8AC3AA7B"
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)

# A longitudinal project (pid 212)
token <- "0434F0E9CF53ED0587847AB6E51DE762"
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)

# A repeating measures (pid 3181)
token <- "22C3FF1C8B08899FB6F86D91D874A159"
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)
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
