choose_dict_lang <- function(dict, lang = c("en")) {
  lang <- match.arg(lang)

  dict <- dict |>
    tidyr::separate(
      field_label,
      c("field_label_en", "field_label_es"),
      '(?=<span lang=\"es\")|(?=<span lang=\'es\')',
      remove = FALSE
    ) |>
    mutate(
      across(
        c(field_label_en, field_label_es),
        ~ textclean::replace_html(.x) |>
          textclean::replace_white() |>
          trimws()
      )
    )

  if (lang == "en") {
    dict <- dict |>
      mutate(
        field_label_new = field_label_en,

      ) |>
      select(- field_label_es  )
  } else if(lang == "es") {
    dict <- dict |>
      mutate(
        field_label_new = field_label_es,

      ) |>
      select(-field_label_en)
  }
  }

  # Slightly change the formula so that the English and Spanish columns aren’t deleted at the end


  # dic_clean

#' Clean Field Labels
#'
#' Removes different unwanted elements (e.g., special characters) from field
#'   labels.
#'   @Amanda: This probably has to be extended for more cases.
#'
#'   @Janosh, I also use purrr:reduce2 here.
# .
#' @param dict tibble. A data frame containing a REDCap data dictionary
#'
#' @param mapping_filepath string. A string containing the address of the `.csv`
#' file that save the error syntax and corresponding correct replacement.
#'
#' @return tibble. A data frame containing the cleaned data dictionary.
clean_field_label <- function(dict) {

  # readr::read_csv(mapping_filepath)
  dict |>
    choose_dict_lang() |>
    mutate(
      field_label_new = field_label_new |>
        stringr::str_remove_all("_x000D_") |>
        stringr::str_remove_all("&nbsp") |>
        stringi::stri_replace_all_fixed(" ,",  ",") |>
        # Amanda added
        stringi::stri_replace_all_fixed(" .", ".")
    )
}
