path_credential          <- "./inst/misc/example.credentials"
project_id               <- 153L

check_url                <- TRUE
check_username           <- FALSE
check_token_pattern      <- TRUE

# Check that the file exists and read it into a data frame.
if( !file.exists(path_credential) ) stop("The credential file was not found.")
# ds_credentials <- readr::read_csv(path_credential, comment = "#")
ds_credentials <- utils::read.csv(path_credential, comment.char="#", stringsAsFactors=FALSE)

# Select only the records with a matching project id.
ds_credential <- ds_credentials[ds_credentials$project_id==project_id, ]

# Check that one and only one record matches the project id.
if( nrow(ds_credential)==0L ) {
  stop("The project_id was not found in the csv credential file.")
} else if( nrow(ds_credential) > 1 ) {
  stop("More than one matching project_id was found in the csv credential file.  There should be only one.")
} else {
  credential <- list(
    redcap_uri   = ds_credential$redcap_uri[1],
    username     = ds_credential$username[1],
    project_id   = ds_credential$project_id[1],
    token        = ds_credential$token[1],
    comment      = ds_credential$comment[1]
  )
}

# Progress through the optional checks
if( check_url & !grepl("https://", credential$redcap_uri, perl=TRUE) ) {
  error_message_username <- paste(
    "The REDCap URL does not reference an https address.  First check",
    "that the URL is correct, and then consider using SSL to encrypt",
    "the REDCap webserver.  Set the `check_url` parameter to FALSE",
    "if you're sure you have the correct file & file contents."
  )
  stop(error_message_username)
} else if( check_username & (Sys.info()["user"]!=credential$username) ) {
  error_message_username <- paste(
    "The username (according to R's `Sys.info()['user']` doesn't match the",
    "username in the credentials file.  This is a friendly check, and",
    "NOT a security measure.  Set the `check_username` parameter to FALSE",
    "if you're sure you have the correct file & file contents.",
    "Otherwise, you may be pointing to the wrong credentials file."
  )
  stop(error_message_username)
} else if( check_token_pattern & !grepl("[A-Z0-9]{32}", credential$token, perl=TRUE) ) {
  error_message_token <- paste(
    "A REDCap token should be a string of 32 digits and uppercase",
    "characters.  The retrieved value was not.",
    "Set the `check_token_pattern` parameter to FALSE",
    "if you're sure you have the correct file & file contents."
  )
  stop(error_message_token)
}

# Return to caller.
return( credential )
