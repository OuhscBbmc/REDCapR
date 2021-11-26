d_expected <-
  tibble::tribble(
    ~record_id,~last_name,~height_dot,~height_comma,~weight_dot,~weight_comma,~bmi,~bmi_comma,~demographics_complete,
    1, "Valdez"  ,"1.54", "1,54",  "52.3",  "52,3", "22.1", "22,1", 0,
    2, "Rich"    ,"1.84", "1,84",  "92.3",  "92,3", "27.3", "27,3", 0,
    3, "Furtado" ,"1.95", "1,95", "123.4", "123,4", "32.5", "32,5", 0,
    4, "Akbar"   ,"1.61", "1,61",  "45.9",  "45,9", "17.7", "17,7", 0,
)

s <-
  'record_id,last_name,height_dot,height_comma,weight_dot,weight_comma,bmi,bmi_comma,demographics_complete
1,Valdez,1.54,"1,54",52.3,"52,3",22.1,22.1,0
2,Rich,1.84,"1,84",92.3,"92,3",27.3,27.3,0
3,Furtado,1.95,"1,95",123.4,"123,4",32.5,32.5,0
4,Akbar,1.61,"1,61",45.9,"45,9",17.7,17.7,0'

col_types <- readr::cols_only(
  `record_id`               = readr::col_double(),
  `last_name`               = readr::col_character(),
  `height_dot`              = readr::col_double(),
  `height_comma`            = readr::col_number(),
  `weight_dot`              = readr::col_double(),
  `weight_comma`            = readr::col_number(),
  `bmi`                     = readr::col_double(),
  `bmi_comma`               = readr::col_double(),
  `demographics_complete`   = readr::col_double()
)
# d <-
  readr::read_csv(
    file = I(s),
    locale= readr::locale(decimal_mark = ",")
    # col_types = col_types
  )

