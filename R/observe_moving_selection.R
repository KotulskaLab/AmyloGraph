observe_moving_selection <- \(input, subtables, edges, table_proxy, rvals) observeEvent(
  input[[NS("single_protein", "select_in_table")]],
  {
    ns <- NS("single_protein")
    if (input[[ns("select_in_table")]] > 0) {
      interactees_rows_selected <- input[[ns("interactees-table_rows_selected")]]
      interactors_rows_selected <- input[[ns("interactors-table_rows_selected")]]
      
      indices <- unique(c(
        subtables[["interactees"]]()[interactees_rows_selected, "original_AGID", drop = TRUE],
        subtables[["interactors"]]()[interactors_rows_selected, "original_AGID", drop = TRUE]
      ))
      
      new_selection <-
        edges[["table"]] %>%
        mutate(rownr = cur_group_rows()) %>%
        filter(AGID %in% indices) %>%
        pull(rownr) 
      
      if (ic(rvals[["table_visited"]])) {
        selectRows(table_proxy, new_selection)
      } else {
        rvals[["initially_selected"]] <- new_selection
      }
      
      updateTabsetPanel(inputId = "tabset_panel",
                        selected = "table")
    }
  }
)