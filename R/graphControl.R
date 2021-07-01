graphControlUI <- function(id, label_groups) {
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
}

graphControlServer <- function(id, edge_data, label_data) {
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
    
    reactive({
      if (input[["label_group"]] == "none") {
        table_edges <- edge_data
        graph_edges <- table_edges %>%
          group_by(to_id, from_id) %>%
          summarize(
            title = do.call(paste, c(as.list(doi), sep = ",\n")),
            id = cur_group_id(),
            .groups = "drop") %>% 
          select(id, from = from_id, to = to_id, title)
      } else {
        label_group <- rlang::sym(input[["label_group"]])
        table_edges <- edge_data %>%
          filter(!!label_group %in% input[["labels_shown"]])
        graph_edges <- table_edges %>%
          group_by(to_id, from_id, !!label_group) %>%
          summarize(
            title = do.call(paste, c(as.list(doi), sep = ",\n")),
            id = cur_group_id(),
            .groups = "drop") %>% 
          mutate(color = label_data[[input[["label_group"]]]][["colors"]][!!label_group]) %>%
          select(id, from = from_id, to = to_id, title, color, !!label_group)
      }
      list(
        table = table_edges,
        graph = graph_edges
      )
    })
  })
}