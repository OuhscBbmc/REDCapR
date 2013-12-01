
## ----set_options, echo=FALSE, results='hide'-----------------------------
require(knitr)
opts_chunk$set(
    comment=NA, 
    tidy=FALSE
)


## ----project_values------------------------------------------------------
library(REDCapR) #Load the package into the current R session.
uri <- "https://miechvprojects.ouhsc.edu/redcap/api/"
token <- "9446D2E3FAA71ABB815A2336E4692AF3"


## ----return_all----------------------------------------------------------
#Return all records and all variables.
ds_all_rows_all_fields <- redcap_read(redcap_uri=uri, token=token)$data


## ----read_row_subset-----------------------------------------------------
#Return only records with IDs of 1 and 3
desired_records_v1 <- c(1, 3)
ds_some_rows_v1 <- redcap_read(
   redcap_uri=uri, 
   token=token, 
   records=desired_records_v1
)$data

#Return only records with IDs of 1 and 3 (alternate way)
desired_records_v2 <- "1, 3"
ds_some_rows_v2 <- redcap_read(
   redcap_uri=uri, 
   token=token, 
   records_collapsed=desired_records_v2
)$data


## ----read_field_subset---------------------------------------------------
#Return only the fields recordid, first_name, and age
desired_fields_v1 <- c("recordid", "first_name", "age")
ds_some_fields_v1 <- redcap_read(
   redcap_uri=uri, 
   token=token, 
   fields=desired_fields_v1
)$data

#Return only the fields recordid, first_name, and age (alternate way)
desired_fields_v2 <- "recordid, first_name, age"
ds_some_fields_v2 <- redcap_read(
   redcap_uri=uri, 
   token=token, 
   fields_collapsed=desired_fields_v2
)$data


## ----session_info, echo=FALSE--------------------------------------------
cat("Report created by", Sys.info()["user"], "at", strftime(Sys.time(), "%c, %z"))
sessionInfo()


