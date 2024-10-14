'Color Boxes' Test Project
=================================

The schema for this project was originally designed by [Benjamin Nutter](https://github.com/nutterb) to better isolate the blank/NA behavior described in [Issue 51](https://github.com/OuhscBbmc/REDCapR/issues/51).

The data dictionary and the datasets are saved as CSVs in this directory.  For convenience, the are

```
"Variable / Field Name","Form Name","Section Header","Field Type","Field Label","Choices, Calculations, OR Slider Labels","Field Note","Text Validation Type OR Show Slider Number","Text Validation Min","Text Validation Max",Identifier?,"Branching Logic (Show field only if...)","Required Field?","Custom Alignment","Question Number (surveys only)","Matrix Group Name","Matrix Ranking?"
id,thisform,,text,"Subject ID",,,,,,,,,,,,
color,thisform,,checkbox,Color,"r, Red | g, Green | b, Blue | p, Purple",,,,,,,,,,,
```

and

```
id,redcap_data_access_group,color___r,color___g,color___b,color___p,thisform_complete
"1","",1,0,0,0,0
"2","",0,0,1,0,0
"3","",0,1,1,0,0
"4","",0,0,0,0,0
```

The url and token of the project are:
```r
url <- "https://redcap-dev-2.ouhsc.edu/redcap/api"
token <- "BECD55331CA005887DA3543230E10284"
```

Here's some (slightly modified) code that Benjamin wrote for Issue #51:
```r
> url <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
> token <- "BECD55331CA005887DA3543230E10284"
> 
> post_result_all <- httr::POST(url=url, body=list(token=token, content='record', format='csv', rawOrLabel='label', fields='id, color'))
> (csv_all <- as.character(post_result_all))
[1] "id,color___r,color___g,color___b,color___p\n\"1\",\"Red\",\"\",\"\",\"\"\n\"2\",\"\",\"\",\"Blue\",\"\"\n\"3\",\"\",\"Green\",\"Blue\",\"\"\n\"4\",\"\",\"\",\"\",\"\"\n"
> (ds_all <- read.csv(textConnection(csv_all)))
  id color___r color___g color___b color___p
1  1       Red                            NA
2  2                          Blue        NA
3  3               Green      Blue        NA
4  4                                      NA
> 
> post_result_some <- httr::POST(url=url, body=list(token=token, content='record', format='csv', rawOrLabel='label', fields='id, color', records='2,3,4'))
> (csv_some <- as.character(post_result_some))
[1] "id,color___r,color___g,color___b,color___p\n\"2\",\"\",\"\",\"Blue\",\"\"\n\"3\",\"\",\"Green\",\"Blue\",\"\"\n\"4\",\"\",\"\",\"\",\"\"\n"
> (ds_some <- read.csv(textConnection(csv_some)))
  id color___r color___g color___b color___p
1  2        NA                Blue        NA
2  3        NA     Green      Blue        NA
3  4        NA                            NA
```
