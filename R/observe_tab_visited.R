observe_tab_visited <- function(tabs_visited, selected_tab) {
  observeEvent(selected_tab(), {
    if (selected_tab() %in% names(tabs_visited)) {
      tabs_visited[[selected_tab()]] <- TRUE
    }
  })
}
