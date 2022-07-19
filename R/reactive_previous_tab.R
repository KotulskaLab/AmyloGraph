reactive_is_interaction_selected <- function(input) {
  reactive({
    !is.null(input[[NS("single_interaction", "selected_interaction")]])
  })
}

reactive_previous_tab <- function(input) {
  tabs <- reactiveVal(character())
  
  observeEvent(input[["tabset_panel"]], {
    # Set new value with the current tab and the last tab saved
    input[["tabset_panel"]] %>%
      c(tabs()[1]) %>%
      tabs()
  })
  
  reactive({
    # Return the older tab of the two saved
    tabs()[2]
  })
}
