# Simplified script incorporating a cron job & REDCapR
# Adapated from https://heds.nz/posts/automate-r-reporting-linux-cron/
cat(paste0(Sys.time(), " Starting cron job...\n"))

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

cat(paste0(Sys.time(), " Finished running scripts/new_iris.R.\n"))

# * * * * * Rscript ~/redcap/REDCapR/utility/cron-example.R >> ~/redcap/REDCapR/utility/cron-example.log 2>&1
