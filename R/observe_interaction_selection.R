#' @importFrom shiny observe req updateTabsetPanel
observe_interaction_selection <- \(input) observe({
  req(input[[NS("single_interaction", "selected_interaction")]])
  updateTabsetPanel(inputId = "app_main_panel",
                    selected = "single_interaction")
  
})