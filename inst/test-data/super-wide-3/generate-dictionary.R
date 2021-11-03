
variable_count  <- 35004L # A multiple of the field types
field_types     <- c("text", "radio", "checkbox", "notes", "text", "descriptive")
choices         <- c("", "1, Yup | 2, Nope | 3, Other", "1, Yup | 2, Nope | 3, Other", "", "", "")
validations     <- c("", "", "", "", "date_ymd", "")

cycle_length    <- length(field_types)
cycle_count     <- variable_count %/% cycle_length

section_header_template <- '<div class="rich-text-field-label"><p style="text-align: center;"><span style="color: #000080;">Please answer the following questions in form_%04i</span></p></div>'

ds <-
  tibble::tibble(
    `Variable / Field Name` = c("record_id", sprintf("variable_%05i", 1L + seq_len(variable_count - 1L))),
    `Form Name`                                   = NA_character_,
    `Section Header`                              = NA_character_,
    `Field Type`                                  = rep(field_types, times = cycle_count),
    `Field Label`                                 = NA_character_,
    `Choices, Calculations, OR Slider Labels`     = rep(choices, times = cycle_count),
    `Field Note`                                  = NA_character_,
    `Text Validation Type OR Show Slider Number`  = rep(validations, times = cycle_count),
    `Text Validation Min`                         = "",
    `Text Validation Max`                         = "",
    `Identifier?`                                 = NA_character_,
    `Branching Logic (Show field only if...)`     = NA_character_,
    `Required Field?`                             = NA_character_,
    `Custom Alignment`                            = NA_character_,
    `Question Number (surveys only)`              = "",
    `Matrix Group Name`                           = "",
    `Matrix Ranking?`                             = "",
    `Field Annotation`                            = "",
    variable_index                                = seq_len(variable_count) # Helper variable
  ) |>
  dplyr::mutate(
    `Form Name`         = sprintf("form_%04i", variable_index %/% cycle_length + 1L),
    `Section Header`    = dplyr::if_else(variable_index %% cycle_length == 0L, sprintf(section_header_template, variable_index %/% cycle_length + 1L), ""),
    `Field Label`       = sprintf("Long description for variable %s", `Variable / Field Name`),
    `Field Note`        = sprintf("Field note %s", `Variable / Field Name`),
    `Identifier?`       = dplyr::if_else(variable_index %% 4 == 0L, "y", ""),
    `Branching Logic (Show field only if...)` = dplyr::if_else(variable_index %% 10 == 0L, "[variable_12345] = '1'", ""),
    `Required Field?`   = dplyr::if_else(variable_index %% 2 == 0L & `Field Type` != "descriptive", "y", ""),
    `Custom Alignment`  = dplyr::if_else(variable_index %% 5 == 0L, "RH", ""),
  ) |>
  dplyr::mutate(
    `Field Annotation`    = dplyr::if_else(variable_index %%  6 == 0L, paste(`Field Annotation`, "@READONLY"), ""),
    `Field Annotation`    = dplyr::if_else(variable_index %%  7 == 0L, paste(`Field Annotation`, "@HIDDEN"), ""),
    `Field Annotation`    = dplyr::if_else(variable_index %%  8 == 0L, paste(`Field Annotation`, "@SHARED"), ""),
    `Field Annotation`    = dplyr::if_else(variable_index %%  9 == 0L, paste(`Field Annotation`, "@DEFAULT='-1'"), ""),
    `Field Annotation`    = dplyr::if_else(variable_index %% 10 == 0L, paste(`Field Annotation`, "@NOW"), ""),
  )

# Get a label with things that could potentially mess up JSON if the parser is poor.
ds$`Field Label`[2] <-
  '
    <span lang="en">{Name of University} is one part of a super awesome study.

    We will also collect some small biological samples, such as saliva.

    Do you have any questions about what the study involves?</span>

    <span lang="es">La {nombre de la universidad} forma parte de un estudio fabuloso.

    También se colectará algunas muestras biológicas, como saliva.

    ¿Tiene alguna pregunta sobre lo que implica el estudio?</span>"
  '

ds$variable_index <- NULL # Drop before writing to disk.

readr::write_csv(ds, "inst/test-data/super-wide-3/super-wide-3-dictionary.csv")
