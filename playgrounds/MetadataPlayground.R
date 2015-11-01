rm(list=ls(all=TRUE))
library(REDCapR)
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #The version that is relatively static (and isn't repeatedly deleted).
# token <- "D70F9ACD1EDD6F151C6EA78683944E98" #The version that is repeatedly deleted and rewritten for most unit tests.

d <- redcap_metadata_read(redcap_uri=uri, token=token)$data
# redcap_metadata_read(redcap_uri=uri, token=token, fields=c("record_id", "name_last"))
# redcap_metadata_read(redcap_uri=uri, token=token, fields_collapsed = "record_id, name_last")
# redcap_metadata_read(redcap_uri=uri, token=token, forms = c("health"))
# redcap_metadata_read(redcap_uri=uri, token=token, forms_collapsed = "health")
choices <- d[d$field_name=="race", "select_choices_or_calculations"]

# pattern <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\\w ]{1,})(?= \\| |\\Z)"
# pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\\w ]{1,})(?= \\| |\\Z)"
# pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\\w ]{1,})(?= \\s|\\Z)"
# pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\\w ]{1,})(?=[ | ] |\\Z)"
# pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\\w ]{1,})"
pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\x21-\x7B\x7D-\x7E ]{1,})(?= \\| |\\Z)" #The weird ranges are to avoid the pipe character; PCRE doesn't support character negation.

# regex_named_captures <- function( pattern, text, perl=TRUE ) {
#   match <- gregexpr(pattern, choices, perl=perl)[[1]]
#   capture_names <- attr(match, "capture.names")
#   d <- as.data.frame(matrix(NA, nrow=length(attr(match, "match.length")), ncol=length(capture_names)))
#   colnames(d) <- capture_names
#   
#   for( column_name in colnames(d) ) {
#     d[, column_name] <- mapply( function (start, len) substr(choices, start, start+len-1),
#                                 attr(match, "capture.start")[, column_name],
#                                 attr(match, "capture.length")[, column_name] )
#   }
#   return( d )
# }
# REDCapR::
regex_named_captures(pattern=pattern_checkboxes, text=choices)
#   id                                     label
# 1  1             American Indian/Alaska Native
# 2  2                                     Asian
# 3  3 Native Hawaiian or Other Pacific Islander
# 4  4                 Black or African American
# 5  5                                     White
# 6  6                    Unknown / Not Reported


# checkbox_choices <- function( select_choices ) {
#   #The weird ranges are to avoid the pipe character; PCRE doesn't support character negation.
#   pattern_checkboxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\x21-\x7B\x7D-\x7E ]{1,})(?= \\| |\\Z)" 
#   
#   d <- regex_named_captures(pattern=pattern_checkboxes, text=select_choices)
#   return( d )
# }

checkbox_choices(select_choices=choices)



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

gregexpr(pattern_id, choices, perl=T)
gregexpr(pattern_label, choices, perl=T)

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
(parsed <- regexpr(pattern=pattern_id, text=choices, perl = TRUE))
parse.one(choices, parsed)

matches <- stringr::str_extract_all(choices, pattern_id)
lapply(matches, function(match) {
    stringr::str_match(match, pattern_id)
})
