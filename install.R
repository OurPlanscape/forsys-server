repos <- "http://cran.rstudio.com/"
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
remotes::install_bitbucket("richierocks/assertive.base")
remotes::install_bitbucket("richierocks/assertive.properties")
remotes::install_bitbucket("richierocks/assertive.types")
remotes::install_bitbucket("richierocks/assertive.numbers")
remotes::install_bitbucket("richierocks/assertive.strings")
remotes::install_bitbucket("richierocks/assertive.datetimes")
remotes::install_bitbucket("richierocks/assertive.files")
remotes::install_bitbucket("richierocks/assertive.sets")
remotes::install_bitbucket("richierocks/assertive.matrices")
remotes::install_bitbucket("richierocks/assertive.models")
remotes::install_bitbucket("richierocks/assertive.data")
remotes::install_bitbucket("richierocks/assertive.data.uk")
remotes::install_bitbucket("richierocks/assertive.data.us")
remotes::install_bitbucket("richierocks/assertive.reflection")
remotes::install_bitbucket("richierocks/assertive.code")
remotes::install_bitbucket("richierocks/assertive")

remotes::install_github("forsys-sp/patchmax@patchmax_0.2.0")
# Install forsysr from specific commit to ensure compatibility with patchmax version
remotes::install_github("forsys-sp/forsysr@7b9641a5fd0be1e660944ef54c2d062bb2cd228c")
remotes::install_github("milesmcbain/friendlyeval")

print("INSTALLATION DONE")
