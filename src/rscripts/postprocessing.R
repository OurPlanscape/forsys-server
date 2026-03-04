rename_column_in_list <- function(in_list, old_column_name, new_column_name) {
  if (!is.list(in_list)) {
    return(in_list)
  }
  
  new_obj <- list()
  for (nm in names(in_list)) {
    new_name <- if (nm == old_column_name) new_column_name else nm
    new_obj[[new_name]] <- in_list[[nm]]
  }
  
  return(new_obj)
}

summarize_metrics <- function(forsys_output, stand_data, datalayers) {
  fields <- paste0("datalayer_", datalayers[["id"]])
  pcp_fields <- paste0("datalayer_", datalayers[["id"]], "_PCP")
  pcp_sum_fields <- paste0("sum_", pcp_fields)
  stand_data <- stand_data |> forsys::calculate_pcp(fields = fields)
  output_fields <- paste0("attain_", datalayers[["name"]])
  lookup <- setNames(pcp_sum_fields, output_fields)
  stand_output <- select(
      filter(
        forsys_output,
        DoTreat == 1
      ), 
      stand_id, 
      proj_id, 
      DoTreat, 
      weightedPriority
    ) |>
    mutate(stand_id = as.integer(stand_id)) |>
    left_join(stand_data, by = "stand_id")

  summarized_metrics <- stand_output |>
    group_by(proj_id) |>
    summarize(across(all_of(pcp_fields), sum, .names = "sum_{col}")) |>
    rename(all_of(lookup))
  summarized_metrics
}
