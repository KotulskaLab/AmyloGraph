reactive_graph_data <- function(data, group) {
  reactive({
    data() %>%
      group_by_attribute(group()) %>%
      color_by_attribute(group()) %>%
      select_graph_columns(group())
  })
}

#' @importFrom dplyr group_by summarize cur_group_id
#' @importFrom glue glue_collapse
#' @importFrom rlang sym
group_by_attribute <- function(data, group) {
  data %>%
    group_by(to_id, from_id, !!sym(group)) %>%
    summarize(
      title = glue_collapse(unique(doi), sep = ", ", last = " and "),
      id = cur_group_id(),
      .groups = "drop"
    )
}

#' @importFrom dplyr mutate
#' @importFrom rlang sym
color_by_attribute <- function(data, group) {
  data %>%
    mutate(color = ag_data_color_map[[group]][!!sym(group)])
}

#' @importFrom dplyr select any_of
select_graph_columns <- function(data, group) {
  data %>%
    select(
      id,
      from = from_id,
      to = to_id,
      title,
      any_of(c("color", group))
    )
}
