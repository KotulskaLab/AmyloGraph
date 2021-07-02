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
           ~ toggleCssClass(NS(.x, "labels_shown"),
                            "filter_checkbox_active",
                            input[["label_group"]] == .x))
    })
    
    reactive({
      table_edges <- edge_data %>%
        filter(!!!map(
          names(label_data),
          ~ expr(!!rlang::sym(.) %in%
                   !!input[[NS(., "labels_shown")]]))
        )
      
      label_group <- input[["label_group"]] %>%
        when(
          . == "none" ~ "",
          ~ .
        )
      
      graph_edges <- table_edges %>%
        group_by(to_id, from_id, !!sym(label_group)) %>%
        summarize(
          title = do.call(paste, c(as.list(doi), sep = ",\n")),
          id = cur_group_id(),
          .groups = "drop") %>% 
        mutate(color = label_data[[label_group]][["colors"]][!!sym(label_group)]) %>%
        select(id, from = from_id, to = to_id, title, any_of(c("color", label_group)))
      
      list(
        table = table_edges,
        graph = graph_edges
      )
    })
  })
}