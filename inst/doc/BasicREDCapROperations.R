## ----set_options, echo=FALSE, results='hide'--------------------------------------------------------------------------
library(knitr)
opts_chunk$set(
    comment=NA, 
    tidy=FALSE
)
# options(markdown.HTML.header = system.file("misc", "vignette.css", package = "knitr"))
# options(markdown.HTML.header = system.file("misc", "vignette.css", package = "REDCapR"))
# options(markdown.HTML.header = file.path(devtools::inst("REDCapR"), "misc", "vignette.css"))

options(width=120) #So the output is 50% wider than the default.

## ----project_values---------------------------------------------------------------------------------------------------
library(REDCapR) #Load the package into the current R session.
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `UnitTestPhiFree` account and the simple project (pid 153)

## ----return_all-------------------------------------------------------------------------------------------------------
#Return all records and all variables.
ds_all_rows_all_fields <- redcap_read_oneshot(redcap_uri=uri, token=token)$data
ds_all_rows_all_fields #Inspect the returned dataset

## ----read_row_subset, results='hold'----------------------------------------------------------------------------------
#Return only records with IDs of 1 and 3
desired_records_v1 <- c(1, 3)
ds_some_rows_v1 <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   records = desired_records_v1
)$data

#Return only records with IDs of 1 and 3 (alternate way)
desired_records_v2 <- "1, 3"
ds_some_rows_v2 <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   records_collapsed = desired_records_v2
)$data

ds_some_rows_v2 #Inspect the returned dataset

## ----read_field_subset------------------------------------------------------------------------------------------------
#Return only the fields recordid, name_first, and age
desired_fields_v1 <- c("recordid", "name_first", "age")
ds_some_fields_v1 <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   fields = desired_fields_v1
)$data

#Return only the fields recordid, name_first, and age (alternate way)
desired_fields_v2 <- "recordid, name_first, age"
ds_some_fields_v2 <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   fields_collapsed = desired_fields_v2
)$data

ds_some_fields_v2 #Inspect the returned dataset

## ----read_not_just_dataframe------------------------------------------------------------------------------------------
#Return only the fields recordid, name_first, and age
all_information <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   fields = desired_fields_v1
)
all_information #Inspect the additional information

## ----session_info, echo=FALSE-----------------------------------------------------------------------------------------
cat("Report created by", Sys.info()["user"], "at", strftime(Sys.time(), "%F, %T %z"))
sessionInfo()

