library(dplyr)
library(tidyr)

source("src/rscripts/queries.R")
source("src/rscripts/base_forsys.R")
source("src/rscripts/postprocessing.R")

assert_identical <- function(actual, expected, message) {
  if (!identical(actual, expected)) {
    stop(
      paste0(
        message,
        "\nExpected: ",
        paste(expected, collapse = ", "),
        "\nActual: ",
        paste(actual, collapse = ", ")
      )
    )
  }
}

datalayers <- data.frame(
  id = c(42, 42, 42, 42),
  usage_type = c("PRIORITY", "PRIORITY", "SECONDARY_METRIC", "THRESHOLD"),
  name = rep("risk", 4),
  threshold = c(NA, NA, NA, "value > 2")
)

assert_identical(
  get_datalayer_field_name(datalayers),
  c(
    "datalayer_PRIORITY_42",
    "datalayer_PRIORITY_42",
    "datalayer_SECONDARY_METRIC_42",
    "datalayer_THRESHOLD_42"
  ),
  "Datalayer fields must include usage type and id."
)

deduplicated <- remove_duplicates(datalayers)
stopifnot(nrow(deduplicated) == 3L)
assert_identical(
  deduplicated$usage_type,
  c("PRIORITY", "SECONDARY_METRIC", "THRESHOLD"),
  "Only rows with the same id and usage type should be removed."
)

threshold <- get_stand_thresholds(
  NULL,
  datalayers[datalayers$usage_type == "THRESHOLD", , drop = FALSE]
)
assert_identical(
  threshold,
  "datalayer_THRESHOLD_42 > 2",
  "Threshold expressions must use usage-qualified fields."
)

metric_layers <- datalayers[c(1, 3), , drop = FALSE]
stand_data <- data.frame(
  stand_id = 1:2,
  datalayer_PRIORITY_42 = c(2, 4),
  datalayer_SECONDARY_METRIC_42 = c(3, 5),
  area_acres = c(1, 1)
)
forsys_output <- list(
  stand_output = data.frame(
    stand_id = 1:2,
    proj_id = c(1, 1),
    DoTreat = c(1, 1),
    weightedPriority = c(1, 1)
  )
)

summary <- summarize_metrics(forsys_output, stand_data, metric_layers)
stopifnot(
  all(
    c("attain_PRIORITY_risk", "attain_SECONDARY_METRIC_risk") %in%
      names(summary)
  )
)

message("Usage-qualified datalayer tests passed.")
