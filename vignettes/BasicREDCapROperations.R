## ----set_options, echo=FALSE, results='hide'-----------------------------
library(knitr)
opts_chunk$set(
    comment = NA, 
    tidy    = FALSE
)
# options(markdown.HTML.header = system.file("misc", "vignette.css", package = "knitr"))
# options(markdown.HTML.header = system.file("misc", "vignette.css", package = "REDCapR"))
# options(markdown.HTML.header = file.path(devtools::inst("REDCapR"), "misc", "vignette.css"))

# options(width=120) #So the output is 50% wider than the default.

## ----project_values------------------------------------------------------
library(REDCapR) #Load the package into the current R session.
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #`UnitTestPhiFree` user and simple project (pid 153)

## ----return_all----------------------------------------------------------
#Return all records and all variables.
ds_all_rows_all_fields <- redcap_read(redcap_uri=uri, token=token)$data
ds_all_rows_all_fields #Inspect the returned dataset

