reactive_selecting_in_main_applicable <- \(input) reactive({
  (!is.null(input[["interactees-table_rows_selected"]]) || 
     !is.null(input[["interactors-table_rows_selected"]])) &&
    !input[["ignore_filters"]]
})
