# Simplified script incorporating a cron job & REDCapR
# Adapted from https://heds.nz/posts/automate-r-reporting-linux-cron/
message("==============================")
message(paste0(Sys.time(), " Starting cron job...\n"))

uri   <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

message("---- simple project --------------------------")
token_1 <- "9A068C425B1341D69E83064A2D273A70"
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token_1)

message("---- repeating measures project w/ environmental token --------------------------")
Sys.setenv(REDCAP_KIRA_SGM_KEY = "77842BD8C18D3408819A21DD0154CCF4")
token_3 <- Sys.getenv("REDCAP_KIRA_SGM_KEY")
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token_3)

message("---- longitudinal project w/ stored token--------------------------")
path <- system.file("misc/example.credentials", package = "REDCapR")
# message(path)
message("Credential file exists: ", fs::file_exists(path))
credential <- REDCapR::retrieve_credential_local(path, 34L)
# message(credential)
REDCapR::redcap_metadata_read(redcap_uri=credential$redcap_uri, token=credential$token)

message("------------------------------")
message(paste0(Sys.time(), " Finished running utility/cron-example.R.\n"))

# * * * * * Rscript ~/redcap/REDCapR/utility/cron-example.R >> ~/redcap/REDCapR/utility/cron-example.log 2>&1
