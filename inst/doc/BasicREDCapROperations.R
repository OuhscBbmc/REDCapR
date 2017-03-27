## ----set_options, echo=FALSE, results='hide'-----------------------------
report_render_start_time <- Sys.time()

library(knitr)
library(magrittr)
requireNamespace("kableExtra")

opts_chunk$set(
  comment = NA, 
  tidy    = FALSE
)

knit_print.data.frame = function(x, ...) {
  # Adapted from https://cran.r-project.org/web/packages/knitr/vignettes/knit_print.html
  # res = paste(c("", "", kable(x)), collapse = "\n")
  # asis_output(res)
  x %>% 
    # dplyr::mutate_if(
    #   is.character,
    #   function( s ) gsub("\\n", "<br/>", s)
    # ) %>%
    kable(
      col.names = gsub("_", " ", colnames(.)),
      format = "html"
    ) %>%
    kableExtra::kable_styling(
      bootstrap_options = c("striped", "hover", "condensed", "responsive"),
      full_width        = FALSE
    ) %>%
    c("", "", .) %>% 
    paste(collapse = "\n") %>% 
    asis_output()
  
}
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

## ----read_row_subset, results='hold'-------------------------------------
#Return only records with IDs of 1 and 3
desired_records_v1 <- c(1, 3)
ds_some_rows_v1 <- redcap_read(
   redcap_uri = uri, 
   token      = token, 
   records    = desired_records_v1
)$data

#Return only records with IDs of 1 and 3 (alternate way)
desired_records_v2 <- "1, 3"
ds_some_rows_v2 <- redcap_read(
   redcap_uri        = uri, 
   token             = token, 
   records_collapsed = desired_records_v2
)$data

ds_some_rows_v2 #Inspect the returned dataset

## ----read_field_subset---------------------------------------------------
#Return only the fields record_id, name_first, and age
desired_fields_v1 <- c("record_id", "name_first", "age")
ds_some_fields_v1 <- redcap_read(
   redcap_uri = uri, 
   token      = token, 
   fields     = desired_fields_v1
)$data

#Return only the fields record_id, name_first, and age (alternate way)
desired_fields_v2 <- "record_id, name_first, age"
ds_some_fields_v2 <- redcap_read(
   redcap_uri       = uri, 
   token            = token, 
   fields_collapsed = desired_fields_v2
)$data

ds_some_fields_v2 #Inspect the returned dataset

## ----read_record_field_subset--------------------------------------------
######
## Step 1: First call to REDCap
desired_fields_v3 <- c("record_id", "dob", "weight")
ds_some_fields_v3 <- redcap_read(
   redcap_uri = uri, 
   token      = token, 
   fields     = desired_fields_v3
)$data

ds_some_fields_v3 #Examine the these three variables.

######
## Step 2: identify desired records, based on age & weight
before_1960 <- (ds_some_fields_v3$dob <= as.Date("1960-01-01"))
heavier_than_70_kg <- (ds_some_fields_v3$weight > 70)
desired_records_v3 <- ds_some_fields_v3[before_1960 & heavier_than_70_kg, ]$record_id

desired_records_v3 #Peek at IDs of the identified records

######
## Step 3: second call to REDCap
#Return only records that met the age & weight criteria.
ds_some_rows_v3 <- redcap_read(
   redcap_uri = uri, 
   token      = token, 
   records    = desired_records_v3
)$data

ds_some_rows_v3 #Examine the results.

## ----read_not_just_dataframe---------------------------------------------
#Return only the fields record_id, name_first, and age
all_information <- redcap_read(
   redcap_uri = uri, 
   token      = token, 
   fields     = desired_fields_v1
)
all_information #Inspect the additional information

## ----session-info, echo=FALSE--------------------------------------------
if( requireNamespace("devtools", quietly = TRUE) ) {
  devtools::session_info()
} else {
  sessionInfo()
} 

## ----session-duration, echo=FALSE----------------------------------------
report_render_duration_in_seconds <- round(as.numeric(difftime(Sys.time(), report_render_start_time, units="secs")))

