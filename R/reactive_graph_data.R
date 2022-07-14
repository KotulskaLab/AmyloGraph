#' @importFrom dplyr group_by summarize cur_group_id mutate select any_of
#' @importFrom glue glue_collapse
#' @importFrom rlang sym
reactive_graph_data <- function(data, group) {
  reactive({
    data() %>%
      group_by(to_id, from_id, !!sym(group())) %>%
      summarize(
        title = glue_collapse(unique(doi), sep = ", ", last = " and "),
        id = cur_group_id(),
        .groups = "drop"
      ) %>% 
      mutate(color = ag_data_color_map[[group()]][!!sym(group())]) %>%
      select(id, from = from_id, to = to_id, title, any_of(c("color", group())))
  })
}
