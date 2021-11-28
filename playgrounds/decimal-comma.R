d_expected <-
  tibble::tribble(
    ~record_id,~last_name,~height,~weight,~bmi,~demographics_complete,
    1, "Valdez"  , 1.54,  52.3, 22.1, 2L,
    2, "Rich"    , 1.84,  92.3, 27.3, 2L,
    3, "Furtado" , 1.95, 123.4, 32.5, 2L,
    4, "Akbar"   , 1.61,  45.9, 17.7, 2L,
)


# ---- both commas & dots -------------------------------------------------
s_both <-
  'record_id,last_name,height_dot,height_comma,weight_dot,weight_comma,bmi_dot,bmi_comma,demographics_complete
1,Valdez,1.54,"1,54",52.3,"52,3",22.1,"22,1",0
2,Rich,1.84,"1,84",92.3,"92,3",27.3,"27,3",0
3,Furtado,1.95,"1,95",123.4,"123,4",32.5,"32,5",0
4,Akbar,1.61,"1,61",45.9,"45,9",17.7,"17,7",0'

col_types_both <- readr::cols_only(
  `record_id`               = readr::col_integer(),
  `last_name`               = readr::col_character(),
  `height_dot`              = readr::col_double(),
  `height_comma`            = readr::col_character(),
  `weight_dot`              = readr::col_double(),
  `weight_comma`            = readr::col_character(),
  `bmi_dot`                 = readr::col_double(),
  `bmi_comma`               = readr::col_character(),
  `demographics_complete`   = readr::col_double()
)
d_both <-
  readr::read_csv(
    file = I(s_both),
    # locale= readr::locale(decimal_mark = ",")
    col_types = col_types_both
  ) |>
  dplyr::mutate(
    height_comma  = readr::parse_number(height_comma, locale = readr::locale(decimal_mark = ",")),
    weight_comma  = readr::parse_number(weight_comma, locale = readr::locale(decimal_mark = ",")),
    bmi_comma     = readr::parse_number(bmi_comma   , locale = readr::locale(decimal_mark = ",")),
  )
testit::assert(d_both$height_dot == d_both$height_comma)
testit::assert(d_both$weight_dot == d_both$weight_comma)
testit::assert(d_both$bmi_dot    == d_both$bmi_comma   )

testit::assert(d_both$height_dot == d_expected$height)
testit::assert(d_both$weight_dot == d_expected$weight)
testit::assert(d_both$bmi_dot    == d_expected$bmi   )


# ---- commas -------------------------------------------------
s_commas <-
  'record_id,last_name,height,weight,bmi,demographics_complete
1,Valdez,"1,54","52,3","22,1",0
2,Rich,"1,84","92,3","27,3",0
3,Furtado,"1,95","123,4","32,5",0
4,Akbar,"1,61","45,9","17,7",0'

col_types_commas <- readr::cols_only(
  `record_id`               = readr::col_integer(),
  `last_name`               = readr::col_character(),
  `height`                  = readr::col_double(),
  `weight`                  = readr::col_double(),
  `bmi`                     = readr::col_double(),
  `demographics_complete`   = readr::col_double()
)

d_commas <-
  readr::read_csv(
    file = I(s_commas),
    locale= readr::locale(decimal_mark = ","),
    col_types = col_types_commas
  )

testit::assert(d_commas$height == d_expected$height)
testit::assert(d_commas$weight == d_expected$weight)
testit::assert(d_commas$bmi    == d_expected$bmi   )

# ---- dots -------------------------------------------------
s_dots <-
  'record_id,last_name,height,weight,bmi,demographics_complete
1,Valdez,"1.54","52.3","22.1",0
2,Rich,"1.84","92.3","27.3",0
3,Furtado,"1.95","123.4","32.5",0
4,Akbar,"1.61","45.9","17.7",0'

col_types_dots <- readr::cols_only(
  `record_id`               = readr::col_integer(),
  `last_name`               = readr::col_character(),
  `height`                  = readr::col_double(),
  `weight`                  = readr::col_double(),
  `bmi`                     = readr::col_double(),
  `demographics_complete`   = readr::col_double()
)

d_dots <-
  readr::read_csv(
    file = I(s_dots),
    # locale= readr::locale(decimal_mark = ","),
    col_types = col_types_dots
  )

testit::assert(d_dots$height == d_expected$height)
testit::assert(d_dots$weight == d_expected$weight)
testit::assert(d_dots$bmi    == d_expected$bmi   )



d_dots_null <-
  readr::read_csv(
    file = I(s_dots),
    locale    = readr::default_locale(),
    col_types = col_types_dots
  )

testit::assert(d_dots_null$height == d_expected$height)
testit::assert(d_dots_null$weight == d_expected$weight)
testit::assert(d_dots_null$bmi    == d_expected$bmi   )



# # ---- using validation from dictionary ----------------------------------------
# url <- "https://bbmc.ouhsc.edu/redcap/api/"
# token <- "33DDFEF1D68EE5A5119DDF06C602430E"
#
# m <- REDCapR::redcap_metadata_read(url, token)$data
#
# m |>
#   dplyr::select(
#     field_name,
#
#   )
