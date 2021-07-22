#' @importFrom htmltools div
#' @importFrom shinyhelper helper
#' @importFrom shiny selectInput NS tagList
#' @importFrom purrr imap
graphControlUI <- function(id, data_groups) {
  div(
    class = "ag-control-panel",
    helper(
      selectInput(
        inputId = NS(id, "label_group"),
        label = "Group edges by",
        choices = c(none = ag_option("str_null"), 
                    ag_group_labels(data_groups)),
        multiple = FALSE),
      type = "markdown",
      content = "label_group"),
    checkboxInput(NS(id, "filter_node_info"),
                  "Filter node info data"),
    do.call(
      tagList,
      imap(ag_group_labels(data_groups),
           ~ filterCheckboxInput(NS(id, .x),
                                 ag_color_map(data_groups, .x)[["values"]],
                                 .y))
    )
  )
}

#' @importFrom shiny moduleServer observe reactiveValues
#' @importFrom shinyjs toggleCssClass
#' @importFrom purrr set_names map when walk
#' @importFrom dplyr `%>%` filter group_by summarize cur_group_id mutate select
#' @importFrom glue glue_collapse
#' @importFrom rlang sym expr
graphControlServer <- function(id, data_interactions, data_groups) {
  moduleServer(id, function(input, output, session) {
    observe({
      walk(ag_group_labels(data_groups),
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
          ag_group_labels(data_groups) %>% set_names(NULL),
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
          . == ag_option("str_null") ~ "",
          ~ .
        )
      
      ret[["graph"]] <- ret[["table"]] %>%
        group_by(to_id, from_id, !!sym(label_group)) %>%
        summarize(
          title = glue_collapse(unique(doi), sep = ", ", last = " and "),
          id = cur_group_id(),
          .groups = "drop") %>% 
        mutate(color = ag_color_map(data_groups, label_group)[["colors"]][!!sym(label_group)]) %>%
        select(id, from = from_id, to = to_id, title, any_of(c("color", label_group)))
    })
    
    ret
  })
}