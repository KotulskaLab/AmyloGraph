#' Display "Single interaction" tab on selection
#' 
#' @description Updates tabset panel to show "Single interaction" tab on the
#' tab list and moves the user there if an interaction is selected. If an
#' interaction is deselected, hides the tab and moves the user back to graph.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app.
observe_interaction_selection <- function(input) {
  previous_tab <- reactive_previous_tab(input)
  is_interaction_selected <- reactive_is_interaction_selected(input)
  
  observeEvent({
    input[[NS("single_interaction", "selected_interaction")]]
    is_interaction_selected()
  }, {
    if (!is_interaction_selected()) {
      updateTabsetPanel(inputId = "tabset_panel",
                        selected = previous_tab())
      hideTab(inputId = "tabset_panel", target = "single_interaction")
    } else {
      showTab(inputId = "tabset_panel", target = "single_interaction")
      updateTabsetPanel(inputId = "tabset_panel",
                        selected = "single_interaction")
    }
  })
}