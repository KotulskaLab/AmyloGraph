#' @importFrom shiny observe req updateTabsetPanel
observe_interaction_selection <- \(input) observe({
  req(input[[NS("interaction_view", "selected_interaction")]])
  updateTabsetPanel(inputId = "graph-table-panel",
                    selected = "interaction_view")
  
})