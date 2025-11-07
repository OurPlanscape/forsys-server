library("logger")
library("plumber")

## How to run this script?
## From the planscape repo root, do:
## Rscript rscripts/forsys.R --scenario <scenario_id>
## Replace `<scenario_id>` with an integer, corresponding with the scenario id
library("DBI")
library("dplyr")
library("friendlyeval")
library("glue")
library("import")
library("logger")
library("optparse")
library("purrr")
library("rjson")
library("RPostgreSQL")
library("sf")
library("stringi")
library("stringr")
library("tidyr")
library("uuid")
library("forsys")

# do not use spherical geometries
sf_use_s2(FALSE)

import::from("rscripts/io_processing.R", .all = TRUE)
import::from("rscripts/queries.R", .all = TRUE)
import::from("rscripts/constants.R", .all = TRUE)
import::from("rscripts/base_forsys.R", .all = TRUE)
import::from("rscripts/postprocessing.R", .all = TRUE)


# server.R

#* Health check endpoint
#* @get /health
function() {
  list(msg = paste0("I'm alive!"))
}

#* Execute Forsys
#* @param scenario_id Scenario ID
#* @post /run_forsys
function(res, req, scenario_id=NULL) {
  log_info("Run forsys {scenario_id}")
  if(is.null(scenario_id) || scenario_id == "") {
    res$status <- 400
    return(list(error = "You need to specify the scenario_id."))
  }
  tryCatch({
    scenario_id <- as.integer(scenario_id)
  }, error = function(e) {
    res$status <- 400
    return(list(error = "Scenario ID must be an integer."))
  })
  tryCatch({
    SERVER_PATCHMAX_WD <- Sys.getenv("SERVER_PATCHMAX_WD", "/app/")
    setwd(SERVER_PATCHMAX_WD)
    main(scenario_id)
    res$status <- 200
    return(list("Forsys run finished."))
  }, error = function(e) {
    res$status <- 500
    log_error("Forsys run failed: {e}")
    return(list("Forsys run failed.", error = e$message))
  })
}
