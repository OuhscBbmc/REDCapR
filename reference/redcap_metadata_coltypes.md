# Suggests a col_type for each field in a REDCap project

This function inspects a REDCap project to determine a
[`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
object that is compatible with the the project's current definition. It
can be copied and pasted into the R code so future calls to the server
will produce a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with an equivalent set of data types.

## Usage

``` r
redcap_metadata_coltypes(
  redcap_uri,
  token,
  print_col_types_to_console = TRUE,
  http_response_encoding = "UTF-8",
  locale = readr::default_locale(),
  verbose = FALSE,
  config_options = NULL,
  handle_httr = NULL
)
```

## Arguments

- redcap_uri:

  The
  [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
  of the REDCap server typically formatted as
  "https://server.org/apps/redcap/api/". Required.

- token:

  The user-specific string that serves as the password for a project.
  Required.

- print_col_types_to_console:

  Should the
  [`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
  object be printed to the console?

- http_response_encoding:

  The encoding value passed to
  [`httr::content()`](https://httr.r-lib.org/reference/content.html).
  Defaults to 'UTF-8'.

- locale:

  a
  [`readr::locale()`](https://readr.tidyverse.org/reference/locale.html)
  object to specify preferences like number, date, and time formats.
  This object is passed to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).
  Defaults to
  [`readr::default_locale()`](https://readr.tidyverse.org/reference/locale.html).

- verbose:

  A boolean value indicating if `message`s should be printed to the R
  console during the operation. The verbose output might contain
  sensitive information (*e.g.* PHI), so turn this off if the output
  might be visible somewhere public. Optional.

- config_options:

  A list of options passed to
  [`httr::POST()`](https://httr.r-lib.org/reference/POST.html). See
  details at
  [`httr::httr_options()`](https://httr.r-lib.org/reference/httr_options.html).
  Optional.

- handle_httr:

  The value passed to the `handle` parameter of
  [`httr::POST()`](https://httr.r-lib.org/reference/POST.html). This is
  useful for only unconventional authentication approaches. It should be
  `NULL` for most institutions. Optional.

## Value

A [`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
object is returned, which can be passed to
[`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
or
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md).

Additionally objected is printed to the console, see the Details below.

## Details

`redcap_metadata_coltypes()` returns a
[`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
object in two ways. First, a literal object is returned that can be
passed to
[`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
or
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md).

Second, the function acts as a code generator. It prints text to the
console so that it can be copied and pasted into an R file. This is
useful to (a) document what fields and data types are expected, and (b)
adjust those fields and data types if the defaults can be customized for
your needs. For instance, you may choose to exclude some variables or
tweak a data type (*e.g.*, changing a patient's height from an integer
to a double).

When printing to the console, each data type decision is accompanied by
an explanation on the far right. See the output from the examples below.
Please file an [issue](https://github.com/OuhscBbmc/REDCapR/issues) if
you think something is too restrictive or can be improved.

The overall heuristic is assign a data type down a waterfall of
decisions:

1.  Is the field built into REDCap? This includes an autonumber
    `record_id`, `redcap_event_name`, `redcap_repeat_instrument`,
    `redcap_repeat_instance`, and an instrument's completion status.

2.  What is the field's type? For example, sliders should be an
    [integer](https://stat.ethz.ch/R-manual/R-devel/library/base/html/integer.html),
    while check marks should be
    [logical](https://rdrr.io/r/base/logical.html)(https://stat.ethz.ch/R-manual/R-devel/library/base/html/logical.html.

3.  If the field type is "text", what is the validation type? For
    instance, a postal code should be a
    [character](https://stat.ethz.ch/R-manual/R-devel/library/base/html/character.html)
    (even though it looks like a number), a "mdy" should be cast to a
    [date](https://stat.ethz.ch/R-manual/R-devel/library/base/html/date.html),
    and a "number_2dp" should be cast to a [floating
    point](https://stat.ethz.ch/R-manual/R-devel/library/base/html/double.html)

4.  If the field type or validation type is not recognized, the field
    will be cast to
    [character](https://stat.ethz.ch/R-manual/R-devel/library/base/html/character.html).
    This will happen when REDCap develops & releases a new type. If you
    see something like, "# validation doesn't have an associated
    col_type. Tell us in a new REDCapR issue", please make sure REDCapR
    is running the newest [GitHub
    release](https://ouhscbbmc.github.io/REDCapR/index.html#installation-and-documentation)
    and file a new [issue](https://github.com/OuhscBbmc/REDCapR/issues)
    if it's still not recognized.

For details of the current implementation, the decision logic starts
about half-way down in the [function's source
code](https://github.com/OuhscBbmc/REDCapR/blob/HEAD/R/redcap-metadata-coltypes.R)

\**Validation does NOT Guarantee Conformity*

If you're coming to REDCap from a database world, this will be
unexpected. A validation type does NOT guarantee that all retrieved
values will conform to complementary the data type. The validation
setting affects only the values entered *after* the validation was set.

For example, if values like "abcd" where entered in a field for a few
months, then the project manager selected the "integer" validation
option, all those "abcd" values remain untouched.

This is one reason `redcap_metadata_coltypes()` prints it suggestions to
the console. It allows the developer to adjust the specifications to
match the values returned by the API. The the "abcd" scenario, consider
(a) changing the type from `col_integer` to `col_character`, (b)
excluding the trash values, then (c) in a
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)
statement, use
[`readr::parse_integer()`](https://readr.tidyverse.org/reference/parse_atomic.html)
to cast it to the desired type.

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (*i.e.*,
<https://redcap.vumc.org/community/post.php?id=456> and
<https://redcap.vumc.org/community/post.php?id=462> ). If you do not
have an account for the wiki, please ask your campus REDCap
administrator to send you the static material.

## Author

Will Beasley, Philip Chase

## Examples

``` r
if (FALSE) { # \dontrun{
uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

# A simple project
token      <- "9A068C425B1341D69E83064A2D273A70" # simple
col_types  <- redcap_metadata_coltypes(uri, token)
redcap_read_oneshot(uri, token, col_types = col_types)$data

# A longitudinal project
token      <- "DA6F2BB23146BD5A7EA3408C1A44A556" # longitudinal
col_types  <- redcap_metadata_coltypes(uri, token)
redcap_read_oneshot(uri, token, col_types = col_types)$data

# A repeating instruments project
token      <- "64720C527CA236880FBA785C9934F02A" # repeating-instruments-sparse
col_types  <- redcap_metadata_coltypes(uri, token)
redcap_read_oneshot(uri, token, col_types = col_types)$data

# A project with every field type and validation type.
#   Notice it throws a warning that some fields use a comma for a decimal,
#   while other fields use a period/dot as a decimal
token      <- "EB1FD5DDE583364AE605629AB7619397" # validation-types-1
col_types  <- redcap_metadata_coltypes(uri, token)
redcap_read_oneshot(uri, token, col_types = col_types)$data
} # }
```
