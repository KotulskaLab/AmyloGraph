source("R/filterCheckbox.R")

graphControlUI <- function(id, label_groups, label_data) {
  div(
    class = "ag-control-panel",
    helper(
      selectInput(
        inputId = NS(id, "label_group"),
        label = "Group edges by",
        choices = c(none = "none", label_groups),
        multiple = FALSE),
      type = "markdown",
      content = "label_group"),
    do.call(
      tagList,
      imap(label_groups,
           ~ filterCheckboxInput(NS(id, .x), label_data[[.x]][["values"]], .y))
    )
  )
}

graphControlServer <- function(id, edge_data, label_data) {
  moduleServer(id, function(input, output, session) {
    observe({
      walk(names(label_data),
           ~ toggleCssClass(NS(.x, "labels_shown"), "filter_checkbox_active", input[["label_group"]] == .x))
    })
    
    reactive({
      label_groups <- rlang::syms(names(label_data))
      table_edges <- edge_data %>%
        filter(!!!imap(
          label_data,
          ~ expr(!!rlang::sym(.y) %in%
                   !!input[[NS(.y, "labels_shown")]])) %>%
            set_names(NULL)
        )
      
      if (input[["label_group"]] == "none") {
        # table_edges <- edge_data
        graph_edges <- table_edges %>%
          group_by(to_id, from_id) %>%
          summarize(
            title = do.call(paste, c(as.list(doi), sep = ",\n")),
            id = cur_group_id(),
            .groups = "drop") %>% 
          select(id, from = from_id, to = to_id, title)
      } else {
        label_group <- rlang::sym(input[["label_group"]])
        # table_edges <- edge_data %>%
        #   filter(!!label_group %in% input[["labels_shown"]])
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