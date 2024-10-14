# Use this hack if the cronjob isn't running properly on the server,
#    But the cronjob link is working (see bottom of https://redcap-dev-2.ouhsc.edu/redcap/redcap_v10.5.1/ControlCenter/cron_jobs.php)

httr::GET("https://redcap.ouhsc.edu/redcap/cron.php")
# httr::GET("https://redcap-dev-2.ouhsc.edu/redcap/cron.php")
