#' @name retrieve_credential
#' @aliases retrieve_credential_local
#' @export retrieve_credential_local
#' @title Read a token and other credentials from a (non-REDCap) database or file.
#'
#' @description These functions are not essential to calling the REDCap API, but instead are functions that help manage tokens securely.
#'
#' @param path_credential The file path to the CSV containing the credentials. Required.
#' @param project_id The ID assigned to the project withing REDCap.  This allows the user to store tokens to multiple REDCap projects in one file.  Required
#' @param check_url A \code{logical} value indicates if the url in the credential file should be checked to have approximately the correct form.  Defaults to TRUE.
#' @param check_username A \code{logical} value indicates if the username in the credential file should be checked against the username returned by R.  Defaults to FALSE.
#' @param check_token_pattern A \code{logical} value indicates if the token in the credential file is a 32-character hexadecimal string.  Defaults to FALSE.
#'
#' @return A list of the following elements
#' \enumerate{
#'  \item \code{redcap_uri}: The URI of the REDCap Server.
#'  \item \code{username}: Username.
#'  \item \code{project_id}: The ID assigned to the project withing REDCap.
#'  \item \code{token}: The token to pass to the REDCap server
#'  \item \code{comment}: An optional string.
#' }
#' @note
#' Although we strongly encourage storing all the tokens on a central server (\emph{e.g.}, see the 
#' \code{retrieve_token_mssql()} function and the "SecurityDatabase" vignette), there are times
#' when this approach is not feasible and the token must be stored locally.  Please contact us 
#' if your institution is using something other than SQL Server, and 
#' would like help adapting this approach to your infrastructure.
#' @author Will Beasley
#'
#' @examples
#' library(REDCapR) #Load the package into the current R session.
#' # ---- Local File Example ----------------------------
#' path <- system.file("misc/example.credentials", package="REDCapR")
#' (p1 <- retrieve_credential_local(path, 153))
#' (p2 <- retrieve_credential_local(path, 212))

retrieve_credential_local <- function(
  path_credential,
  project_id,
  check_url                = TRUE,
  check_username           = FALSE,
  check_token_pattern      = TRUE
) {

  # Check that the file exists and read it into a data frame.
  if( !file.exists(path_credential) ) stop("The credential file was not found.")
  ds_credentials <- utils::read.csv(path_credential, comment.char="#", stringsAsFactors=FALSE)
  
  # Check that it's a data.frame with valid variable names
  if( !inherits(ds_credentials, "data.frame") ) {
    stop("The credentials file was not correctly transformed into a `data.frame`.  Make sure it's a well-formed CSV.")
  } else if ( !identical(colnames(ds_credentials), c("redcap_uri", "username", "project_id", "token", "comment")) ) {
    stop("The credentials file did not contain the proper variables of `redcap_uri`, `username`, `project_id`, `token`,  and `comment`.")
  }
  
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
    
  } else if( check_token_pattern & !grepl("[A-F0-9]{32}", credential$token, perl=TRUE) ) {
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
}
