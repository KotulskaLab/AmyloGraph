#' @importFrom shiny observe req updateTabsetPanel hideTab showTab
observe_interaction_selection <- \(input) {
  observe({
    if (is.null(input[[NS("single_interaction", "selected_interaction")]])) {
      updateTabsetPanel(inputId = "tabset_panel",
                        selected = "graph")
      hideTab(inputId = "tabset_panel", target = "single_interaction")
    } else {
      showTab(inputId = "tabset_panel", target = "single_interaction")
      updateTabsetPanel(inputId = "tabset_panel",
                        selected = "single_interaction")
    }
  })
  
  observe({
    req(input[[NS("single_interaction", "selected_interaction")]])
    updateTabsetPanel(inputId = "tabset_panel",
                      selected = "single_interaction")
    
  })
}