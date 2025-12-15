# Validate and sanitize the user's REDCap token

Verifies the token is nonmissing and conforms to the legal pattern of a
32-character hexadecimal value. Each character must be an (a) digit 0-9,
(b) uppercase letter A-F, or (c) lowercase letter a-f. Trailing line
endings are removed.

A typical user does not call this function directly. However functions
like
[`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
call it to provide a more informative error message to the user.

Some institutions create their own tokens –not the standard 32-character
hexadecimal value. The pattern that validates their tokens can be
specified with the system environmental variable `REDCAP_TOKEN_PATTERN`
using [base::Sys.setenv](https://rdrr.io/r/base/Sys.setenv.html).

For example, the following regex pattern captures a [base64 encoded
value](https://en.wikipedia.org/wiki/Base64) with 40 characters (as
opposed to a hexadecimal/base16 value with 32 characters):
`^([A-Za-z\\d+/\\+=]{40})$`. See <https://rgxdb.com/r/1NUN74O6> for
alternative approaches to validate base64 values.

If no pattern is specified, the default is a 32-character hex token:
`^([0-9A-Fa-f]{32})(?:\\n)?$`. The important segment is contained in the
first (and only) capturing group (*i.e.*, `[0-9A-Fa-f]{32}`). Any
trailing newline character is removed.

## Usage

``` r
sanitize_token(token)
```

## Arguments

- token:

  The REDCap token. Required.

## Value

The token, without a terminal newline character.

## Details

Although the function does not accept a parameter, it is influenced by
the `REDCAP_TOKEN_PATTERN` environmental variable.

## Note

Contact your institution's REDCap administrator for more information
about your project-specific token.

## Author

Hao Zhu, Benjamin Nutter, Will Beasley, Jordan Mark Barbone

## Examples

``` r
secret_token_1 <- "12345678901234567890123456ABCDEF"
secret_token_2 <- "12345678901234567890123456ABCDEF\n"
secret_token_3 <- "12345678901234567890123456abcdef"
REDCapR::sanitize_token(secret_token_1)
#> [1] "12345678901234567890123456ABCDEF"
REDCapR::sanitize_token(secret_token_2)
#> [1] "12345678901234567890123456ABCDEF"
REDCapR::sanitize_token(secret_token_3)
#> [1] "12345678901234567890123456abcdef"

# Some institutions use a token system that follows a different pattern
Sys.setenv("REDCAP_TOKEN_PATTERN" = "^([A-Za-z\\d+/\\+=]{10})$")

secret_token_4 <- "abcde1234="
REDCapR::sanitize_token(secret_token_4)
#> [1] "abcde1234="
Sys.getenv("REDCAP_TOKEN_PATTERN")
#> [1] "^([A-Za-z\\d+/\\+=]{10})$"
Sys.unsetenv("REDCAP_TOKEN_PATTERN")
```
