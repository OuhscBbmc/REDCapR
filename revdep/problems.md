# tidyREDCap

<details>

* Version: 1.1.1
* GitHub: https://github.com/RaymondBalise/tidyREDCap
* Source code: https://github.com/cran/tidyREDCap
* Date/Publication: 2023-05-29 16:30:02 UTC
* Number of recursive dependencies: 88

Run `revdepcheck::revdep_details(, "tidyREDCap")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
      Running 'testthat.R'
     ERROR
    Running the tests in 'tests/testthat.R' failed.
    Last 13 lines of output:
        7.       ├─tidyselect:::with_subscript_errors(...)
        8.       │ └─base::withCallingHandlers(...)
        9.       └─tidyselect:::vars_select_eval(...)
       10.         └─tidyselect:::ensure_named(...)
       11.           └─vctrs::vec_as_names(names(pos), repair = "check_unique", call = call)
       12.             └─vctrs (local) `<fn>`()
       13.               └─vctrs:::validate_unique(names = names, arg = arg, call = call)
       14.                 └─vctrs:::stop_names_must_be_unique(names, arg, call = call)
       15.                   └─vctrs:::stop_names(...)
       16.                     └─vctrs:::stop_vctrs(...)
       17.                       └─rlang::abort(message, class = c(class, "vctrs_error"), ..., call = call)
      
      [ FAIL 1 | WARN 8 | SKIP 0 | PASS 13 ]
      Error: Test failures
      Execution halted
    ```

