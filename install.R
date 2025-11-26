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

remotes::install_github("forsys-sp/patchmax@ab174cc6dc7f1fe7277c360eba1e6abcaf610429")
remotes::install_github("forsys-sp/forsysr@179045ffc861ad5f6c313c726d70885e9071df20")
remotes::install_github("milesmcbain/friendlyeval")

print("INSTALLATION DONE")
