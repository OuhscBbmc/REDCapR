# tidyREDCap

<details>

* Version: 1.1.0
* GitHub: https://github.com/RaymondBalise/tidyREDCap
* Source code: https://github.com/cran/tidyREDCap
* Date/Publication: 2023-02-18 18:10:02 UTC
* Number of recursive dependencies: 82

Run `revdepcheck::revdep_details(, "tidyREDCap")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
      Running 'testthat.R'
     ERROR
    Running the tests in 'tests/testthat.R' failed.
    Last 13 lines of output:
        8.       │ └─rlang::try_fetch(...)
        9.       │   └─base::withCallingHandlers(...)
       10.       └─tidyselect:::vars_select_eval(...)
       11.         └─tidyselect:::ensure_named(...)
       12.           └─vctrs::vec_as_names(names(pos), repair = "check_unique", call = call)
       13.             └─vctrs (local) `<fn>`()
       14.               └─vctrs:::validate_unique(names = names, arg = arg, call = call)
       15.                 └─vctrs:::stop_names_must_be_unique(names, arg, call = call)
       16.                   └─vctrs:::stop_names(...)
       17.                     └─vctrs:::stop_vctrs(...)
       18.                       └─rlang::abort(message, class = c(class, "vctrs_error"), ..., call = call)
      
      [ FAIL 1 | WARN 0 | SKIP 0 | PASS 4 ]
      Error: Test failures
      Execution halted
    ```

