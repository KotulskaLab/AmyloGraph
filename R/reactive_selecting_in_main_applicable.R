reactive_selecting_in_main_applicable <- \(input) reactive({
  (!is.null(input[["interactees_rows_selected"]]) || 
     !is.null(input[["interactors_rows_selected"]])) &&
    !input[["ignore_filters"]]
})
