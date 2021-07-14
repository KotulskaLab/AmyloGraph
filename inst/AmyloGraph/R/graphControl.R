source("R/filterCheckbox.R")

graphControlUI <- function(id, data_groups) {
  div(
    class = "ag-control-panel",
    helper(
      selectInput(
        inputId = NS(id, "label_group"),
        label = "Group edges by",
        choices = c(none = getOption("ag_str_null"), 
                    AmyloGraph:::ag_group_labels(data_groups)),
        multiple = FALSE),
      type = "markdown",
      content = "label_group"),
    checkboxInput(NS(id, "filter_node_info"),
                  "Filter node info data"),
    do.call(
      tagList,
      imap(AmyloGraph:::ag_group_labels(data_groups),
           ~ filterCheckboxInput(NS(id, .x),
                                 AmyloGraph:::ag_color_map(data_groups, .x)[["values"]],
                                 .y))
    )
  )
}

graphControlServer <- function(id, data_interactions, data_groups) {
  moduleServer(id, function(input, output, session) {
    observe({
      walk(AmyloGraph:::ag_group_labels(data_groups),
           ~ toggleCssClass(.x, "filter_checkbox_active",
                            input[["label_group"]] == .x))
    })
    
    ret <- reactiveValues(
      table = NULL,
      graph = NULL,
      node_info = data_interactions
    )
    
    observe({
      ret[["table"]] <- data_interactions %>%
        filter(!!!map(
          AmyloGraph:::ag_group_labels(data_groups) %>% set_names(NULL),
          ~ expr(!!sym(.) %in% !!input[[.]]))
        )
    })
    
    observe({
      if (input[["filter_node_info"]]) {
        ret[["node_info"]] <- ret[["table"]]
      } else {
        ret[["node_info"]] <- data_interactions
      }
    })
    
    observe({
      label_group <- input[["label_group"]] %>%
        when(
          . == getOption("ag_str_null") ~ "",
          ~ .
        )
      
      ret[["graph"]] <- ret[["table"]] %>%
        group_by(to_id, from_id, !!sym(label_group)) %>%
        summarize(
          title = do.call(paste, c(as.list(doi), sep = ",\n")),
          id = cur_group_id(),
          .groups = "drop") %>% 
        mutate(color = AmyloGraph:::ag_color_map(data_groups, label_group)[["colors"]][!!sym(label_group)]) %>%
        select(id, from = from_id, to = to_id, title, any_of(c("color", label_group)))
    })
    
    ret
  })
}