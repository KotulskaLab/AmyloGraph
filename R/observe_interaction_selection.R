#' Display "Single interaction" tab on selection
#' 
#' @description Updates tabset panel to show "Single interaction" tab on the
#' tab list and moves the user there if an interaction is selected. If an
#' interaction is deselected, hides the tab and moves the user back to graph.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app.
#' 
#' @return An observer that moves the user to the "Single interaction" tab.
#' 
#' @importFrom shiny observe NS req updateTabsetPanel hideTab showTab
observe_interaction_selection <- function(input) {
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