repos <- "https://cloud.r-project.org/"
options(warn = 2)
if (!require("remotes")) install.packages("remotes", repos=repos)
if (!require("pacman")) install.packages("pacman", repos=repos)
if (!require("import")) install.packages("import", repos=repos)
library(remotes)
library(pacman)
packages <- c(
  "dplyr",
  "textshaping",
  "stringi",
  "ggnewscale",
  "udunits2",
  "sf",
  "ragg",
  "pkgdown",
  "devtools",
  "DBI",
  "RPostgreSQL",
  "RPostgres",
  "optparse",
  "rjson",
  "glue",
  "purrr",
  "logger",
  "tidyr",
  "checkmate",
  "uuid",
  "doParallel",
  "httpuv",
  "plumber"
)

pacman::p_load(packages, character.only=TRUE)

# Required for patchmax pinned version
remotes::install_github("cran/assertive.base")
remotes::install_github("cran/assertive.properties")
remotes::install_github("cran/assertive.types")
remotes::install_github("cran/assertive.numbers")
remotes::install_github("cran/assertive.strings")
remotes::install_github("cran/assertive.datetimes")
remotes::install_github("cran/assertive.files")
remotes::install_github("cran/assertive.sets")
remotes::install_github("cran/assertive.matrices")
remotes::install_github("cran/assertive.models")
remotes::install_github("cran/assertive.data")
remotes::install_github("cran/assertive.data.uk")
remotes::install_github("cran/assertive.data.us")
remotes::install_github("cran/assertive.reflection")
remotes::install_github("cran/assertive.code")
remotes::install_github("cran/assertive")

remotes::install_github("forsys-sp/patchmax@3a5738133de72784e2366865a0049710f4edb0b8")
# Install forsysr from specific commit to ensure compatibility with patchmax version
remotes::install_github("forsys-sp/forsysr@7b9641a5fd0be1e660944ef54c2d062bb2cd228c")
remotes::install_github("milesmcbain/friendlyeval")

print("INSTALLATION DONE")
