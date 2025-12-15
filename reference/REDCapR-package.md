# REDCapR: Interaction Between R and REDCap

Encapsulates functions to streamline calls from R to the REDCap API.
REDCap (Research Electronic Data CAPture) is a web application for
building and managing online surveys and databases developed at
Vanderbilt University. The Application Programming Interface (API)
offers an avenue to access and modify data programmatically, improving
the capacity for literate and reproducible programming.

Comprehensive documentation is also available at
https://ouhscbbmc.github.io/REDCapR/.

Much of this package has been developed to support the needs of the
following projects. We appreciate the support.

- *OUHSC CCAN Independent Evaluation of the State of Oklahoma
  Competitive Maternal, Infant, and Early Childhood Home Visiting
  ([MIECHV](https://mchb.hrsa.gov/programs-impact/maternal-infant-early-childhood-home-visiting-miechv-program))
  Project*. HRSA/ACF D89MC23154. David Bard, PI, OUHSC; 2011-2015.

- *Independent Evaluation of the State of OK MIECHV Evidence Based Home
  Visitation Project*, [NIH](https://www.nih.gov/)-sponsored
  collaboration with [OSDH](https://oklahoma.gov/health.html). David
  Bard, PI, OUHSC; 2015-2017.

- *OSDH ParentPRO Pilot Evaluation*, federally-sponsored collaboration
  with [OSDH](https://oklahoma.gov/health.html). David Bard, PI, OUHSC;
  2015-2017.

- *Title IV-E Waiver Project*,
  [HRSA/MCHB](https://mchb.hrsa.gov/)-sponsored collaboration with
  [OKDHS](https://oklahoma.gov/okdhs.html); David Bard, PI, OUHSC;
  2014-2017.

- *Integrative Analysis of Longitudinal Studies of Aging (IALSA)*,
  sponsored by [NIH
  5P01AG043362](https://grantome.com/grant/NIH/P01-AG043362-05). Scott
  Hofer, PI, University of Victoria; Will Beasley, PI of site-award,
  OUHSC; 2013-2018.

- *Oklahoma Shared Clinical and Translational Resources*, sponsored by
  [NIH NIGMS; U54
  GM104938](https://grantome.com/grant/NIH/U54-GM104938). Judith A.
  James, PI, OUHSC; 2013-2018.

- Additional Institutional Support from OUHSC [Dept of
  Pediatrics](https://medicine.ouhsc.edu/academic-departments/pediatrics);
  2013-2017.

## Note

The release version is available through
[CRAN](https://cran.r-project.org/package=REDCapR) by running
`install.packages('REDCapR')`. The most recent development version is
available through [GitHub](https://github.com/OuhscBbmc/REDCapR) by
running `remotes::install_github('OuhscBbmc/REDCapR')` (make sure
[remotes](https://cran.r-project.org/package=remotes) is already
installed). If you're having trouble with the package, please install
the development version. If this doesn't solve your problem, please
create a [new issue](https://github.com/OuhscBbmc/REDCapR/issues), or
email Will.

See REDCapR's advanced vignette for information and examples for
overriding the default SSL options.

## See also

Useful links:

- <https://ouhscbbmc.github.io/REDCapR/>

- <https://github.com/OuhscBbmc/REDCapR>

- <https://www.ouhsc.edu/bbmc/>

- <https://projectredcap.org>

- Report bugs at <https://github.com/OuhscBbmc/REDCapR/issues>

## Author

**Maintainer**: Will Beasley <wibeasley@hotmail.com>
([ORCID](https://orcid.org/0000-0002-5613-5006))

Other contributors:

- David Bard ([ORCID](https://orcid.org/0000-0002-3922-8489))
  \[contributor\]

- Thomas Wilson \[contributor\]

- John J Aponte <john.aponte@isglobal.org> \[contributor\]

- Rollie Parrish <rparrish@flightweb.com>
  ([ORCID](https://orcid.org/0000-0001-8858-6381)) \[contributor\]

- Benjamin Nutter \[contributor\]

- Andrew Peters ([ORCID](https://orcid.org/0000-0003-2487-1268))
  \[contributor\]

- Hao Zhu ([ORCID](https://orcid.org/0000-0002-3386-6076))
  \[contributor\]

- Janosch Linkersdörfer ([ORCID](https://orcid.org/0000-0002-1577-1233))
  \[contributor\]

- Jonathan Mang ([ORCID](https://orcid.org/0000-0003-0518-4710))
  \[contributor\]

- Felix Torres <fetorres@ucsd.edu> \[contributor\]

- Philip Chase <pbc@ufl.edu>
  ([ORCID](https://orcid.org/0000-0002-5318-9420)) \[contributor\]

- Victor Castro <vcastro@mgh.harvard.edu>
  ([ORCID](https://orcid.org/0000-0001-7390-6354)) \[contributor\]

- Greg Botwin \[contributor\]

- Stephan Kadauke ([ORCID](https://orcid.org/0000-0003-2996-8034))
  \[contributor\]

- Ezra Porter ([ORCID](https://orcid.org/0000-0002-4690-8343))
  \[contributor\]

- Matthew Schuelke <matt@themadstatter.com>
  ([ORCID](https://orcid.org/0000-0001-5755-1725)) \[contributor\]

## Examples

``` r
# \dontrun{
# Install/update REDCapR with the release version from CRAN.
# install.packages('REDCapR')

# Install/update REDCapR with the development version from GitHub
# install.packages("remotes") # Uncomment if `remotes` isn't installed already.
# remotes::install_github('OuhscBbmc/REDCapR')
# }
```
