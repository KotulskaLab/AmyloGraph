source("R/filterCheckbox.R")

graphControlUI <- function(id, label_data) {
  div(
    class = "ag-control-panel",
    helper(
      selectInput(
        inputId = NS(id, "label_group"),
        label = "Group edges by",
        choices = c(none = "none", ag_groups(label_data)),
        multiple = FALSE),
      type = "markdown",
      content = "label_group"),
    do.call(
      tagList,
      imap(ag_groups(label_data),
           ~ filterCheckboxInput(NS(id, .x),
                                 ag_data(label_data, .x)[["values"]],
                                 .y))
    )
  )
}

graphControlServer <- function(id, edge_data, label_data) {
  moduleServer(id, function(input, output, session) {
    observe({
      walk(ag_groups(label_data),
           ~ toggleCssClass(NS(.x, "labels_shown"),
                            "filter_checkbox_active",
                            input[["label_group"]] == .x))
    })
    
    reactive({
      table_edges <- edge_data %>%
        filter(!!!map(
          ag_groups(label_data) %>% set_names(NULL),
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
        mutate(color = ag_data(label_data, label_group)[["colors"]][!!sym(label_group)]) %>%
        select(id, from = from_id, to = to_id, title, any_of(c("color", label_group)))
      
      list(
        table = table_edges,
        graph = graph_edges
      )
    })
  })
}