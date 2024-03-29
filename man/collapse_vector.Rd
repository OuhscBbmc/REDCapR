% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities.R
\name{collapse_vector}
\alias{collapse_vector}
\title{Collapse a vector of values into a single string when necessary}
\usage{
collapse_vector(elements)
}
\arguments{
\item{elements}{An array of values.  Can be \code{NULL}.  Required.}
}
\value{
A single character element, where the values are separated by
commas.  Can be blank. (\emph{i.e.}, \code{""}).
}
\description{
REDCap's API frequently specifies a series of values
separated by commas.
In the R world, it's easier to keep these values as separate elements in a
vector. This functions squashes them together in a single character element
(presumably right before the return value is passed to the API)
}
\examples{
library(REDCapR) # Load the package into the current R session.
REDCapR:::collapse_vector(elements = NULL   )
REDCapR:::collapse_vector(elements = letters)
}
\author{
Will Beasley
}
