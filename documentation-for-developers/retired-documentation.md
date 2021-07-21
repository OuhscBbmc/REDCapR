Retired Documentation
============================

This file holds old documentations that's no longer relevant, but might have parts worth resurrecting.


### Linux

If installing on Linux, the default R CHECK command will try (and fail) to install the (non-vital) RODBC package.  While this package isn't necessary to interact with your REDCap server (and thus not necessary for the core features of REDCapR).  To check REDCapR's installation on Linux, run the following R code.  Make sure the working directory is set to the root of the REDCapR directory; this will happen automatically when you use RStudio to open the `REDCapR.Rproj` file.
```r
devtools::check(force_suggests = FALSE)
```

Alternatively, the [RODBC](https://CRAN.R-project.org/package=RODBC) package can be installed from your distribution's repository using the shell.  Here are instructions for [Ubuntu](https://cran.r-project.org/bin/linux/ubuntu/README.html) and [Red Hat](https://cran.r-project.org/bin/linux/redhat/README).  `unixodbc` is necessary for the [`RODBCext`](https://CRAN.R-project.org/package=RODBCext) R package to be built.

```shell
#From Ubuntu terminal
sudo apt-get install r-cran-rodbc unixodbc-dev

#From Red Hat terminal
sudo yum install R-RODBC unixODBC-devel
```




### SVN
SVN is necessary if you want to commit to R-Forge (otherwise, just download the release version from CRAN and the development version from [GitHub](https://github.com/OuhscBbmc/REDCapR)).  When a directory is deleted, using the command line to first [update](https://stackoverflow.com/questions/87950/how-do-you-overcome-the-svn-out-of-date-error) and then [delete](https://svnbook.red-bean.com/en/1.2/svn.ref.svn.c.delete.html) works for me.
```
$ svn update doc

$ svn delete doc
$ svn commit -m "Deleted directory 'inst/doc'."
```
