observe_filter_active <- function(group, attribute) {
  observe({
    toggleCssClass(
      id = "filter",
      class = "filter_checkbox_active",
      condition = group() == attribute
    )
  })
}
