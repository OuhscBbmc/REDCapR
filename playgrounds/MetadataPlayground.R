rm(list=ls(all=TRUE))
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "D70F9ACD1EDD6F151C6EA78683944E98" #The version that is repeatedly deleted and rewritten for most unit tests.
# token <- "9A81268476645C4E5F03428B8AC3AA7B" #The version that is relatively static (and isn't repeatedly deleted).

d <- redcap_metadata_read(redcap_uri=uri, token=token)$data
# redcap_metadata_read(redcap_uri=uri, token=token, fields=c("record_id", "name_last"))
# redcap_metadata_read(redcap_uri=uri, token=token, fields_collapsed = "record_id, name_last")
# redcap_metadata_read(redcap_uri=uri, token=token, forms = c("health"))
# redcap_metadata_read(redcap_uri=uri, token=token, forms_collapsed = "health")
choices <- d[d$field_name=="race", "select_choices_or_calculations"]

pattern <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\\w ]{1,})(?= \\| |\\Z)"

regex_named_captures <- function( pattern, text, perl=TRUE ) {
  match <- gregexpr(pattern, choices, perl=perl)[[1]]
  capture_names <- attr(match, "capture.names")
  d <- as.data.frame(matrix(NA, nrow=length(attr(match, "match.length")), ncol=length(capture_names)))
  colnames(d) <- capture_names
  
  for( column_name in colnames(d) ) {
    d[, column_name] <- mapply( function (start, len) substr(choices, start, start+len-1),
                                attr(match, "capture.start")[, column_name],
                                attr(match, "capture.length")[, column_name] )
  }
  return( d )
}
regex_named_captures(pattern=pattern, text=choices)
# > regex_named_captures(pattern=pattern, text=choices)
#   id                                     label
# 1  2                                     Asian
# 2  3 Native Hawaiian or Other Pacific Islander
# 3  4                 Black or African American
# 4  5                                     White




pattern_id <- "(?<=\\A| \\| )(?<id>\\d{1,}), [\\w ]{1,}(?= \\| |\\Z)"
pattern_label <- "(?<=\\A| \\| )\\d{1,}, ([\\w ]{1,})(?= \\| |\\Z)"
match_id <- gregexpr(pattern_id, choices, perl=T)[[1]]
match_label <- gregexpr(pattern_label, choices, perl=T)[[1]]

ids <- mapply(function (start, len) as.integer(substr(choices, start, start+len-1)),
                 attr(match, "capture.start")[, "id"],
                 attr(match, "capture.length")[, "id"]
                 )
labels <- mapply(function (start, len) substr(choices, start, start+len-1),
                 attr(match, "capture.start")[, "label"],
                 attr(match, "capture.length")[, "label"]
                 )



#http://stackoverflow.com/questions/952275/regex-group-capture-in-r
ids <- mapply(function (start, len) as.integer(substr(choices, start, start+len-1)),
                 attr(match_id, "capture.start")[, 1],
                 attr(match_id, "capture.length")[, 1]
                 )

labels <- mapply(function (start, len) substr(choices, start, start+len-1),
                 attr(match_label, "capture.start")[, 1],
                 attr(match_label, "capture.length")[, 1]
                 )




# r <- regmatches(choices, gregexpr("(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\\w ]{1,})(?=( | )|\\Z)", choices, perl=TRUE))
# str(r)
# 
# 
# matches <- gregexpr("(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\\w ]{1,})(?=( | )|\\Z)", choices, perl=TRUE);
# result <- lapply(matches, function(m) attr(m, "capture.start")[,1])
# for (i in 1:length(result))
# #   attr(result[[i]], "match.length") <- attr(matches[[i]], "capture.length")[,1]
#   attr(result[[i]], "match.length") <- attr(matches[[i]], "capture.length")[,2]
# regmatches(choices, result)
# 
# str(result)
# 
# r <- regmatches(choices, gregexpr("(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\\w ]{1,})(?=( | )|\\Z)", choices, perl=TRUE));
# str(r)
# 
# 

gregexpr(pattern, choices, perl=T)
# 
# stringr::str_match_all(choices, pattern)

#This function is adapted from https://stat.ethz.ch/R-manual/R-devel/library/base/html/grep.html
parse.one <- function(res, result) {
  m <- do.call(rbind, lapply(seq_along(res), function(i) {
    if(result[i] == -1) return("")
    st <- attr(result, "capture.start")[i, ]
    substring(res[i], st, st + attr(result, "capture.length")[i, ] - 1)
  }))
  colnames(m) <- attr(result, "capture.names")
  m
}
(parsed <- regexpr(pattern=pattern, text=choices, perl = TRUE))
parse.one(choices, parsed)

matches <- stringr::str_extract_all(choices, pattern)
lapply(matches, function(match) {
    str_match(match, pattern)
})
