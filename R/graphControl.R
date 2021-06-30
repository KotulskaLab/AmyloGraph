graphControlUI <- function(id, label_groups) {
  tagList(
    div(
      class = "ag-control-panel",
      helper(
        selectInput(
          inputId = NS(id, "label_group"),
          label = "Group edges by",
          choices = label_groups,
          multiple = FALSE),
        type = "markdown",
        content = "label_group"),
      conditionalPanel(
        condition = "input.label_group != \"none\"",
        helper(
          uiOutput(NS(id, "labels_shown_ui")),
          type = "markdown",
          content = "labels_shown"),
        ns = NS(id)
      )
    )
  )
}

graphControlServer <- function(id, label_data) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input[["label_group"]], {
      label_values <- label_data[[input[["label_group"]]]][["values"]]
      output[["labels_shown_ui"]] <- renderUI({
        checkboxGroupInput(
          inputId = NS(id, "labels_shown"),
          label = "Types of connections to display:",
          choices = label_values,
          selected = label_values)
      })
    })
  })
}