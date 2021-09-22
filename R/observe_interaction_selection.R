#' @importFrom shiny observe req updateTabsetPanel hideTab showTab
observe_interaction_selection <- \(input) {
  observe({
    if (is.null(input[[NS("single_interaction", "selected_interaction")]]))
      hideTab(inputId = "app_main_panel", target = "single_interaction")
    else
      showTab(inputId = "app_main_panel", target = "single_interaction")
  })
  
  observe({
    req(input[[NS("single_interaction", "selected_interaction")]])
    updateTabsetPanel(inputId = "app_main_panel",
                      selected = "single_interaction")
    
  })
}