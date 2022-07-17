#' Generate graph data
#' 
#' @description Applies a set of transformations to base tabular data based on
#' currently selected attribute to group by.
#' 
#' @param data \[\code{reactive(tibble())}\]\cr
#'  AmyloGraph tabular edge data.
#' @param group \[\code{reactive(character(1))}\]\cr
#'  Name of a currently selected attribute (if none, empty string).
#' 
#' @return A \code{reactive} object with a \code{tibble} containing mutated
#' graph data.
reactive_graph_data <- function(data, group) {
  reactive({
    data() %>%
      group_by_attribute(group()) %>%
      color_by_attribute(group()) %>%
      select_graph_columns(group())
  })
}

#' Group data by attribute value
#' 
#' @description Groups interaction data by start and end nodes, and attribute
#' value (if applicable). Generates edge labels from all DOIs for given group.
#' 
#' @param data \[\code{tibble()}\]\cr
#'  Data to modify.
#' @param group \[\code{character(1)}\]\cr
#'  Name of a currently selected attribute (if none, empty string).
#' 
#' @return A `tibble` where each observation corresponds to a single edge on
#' the graph.
#' 
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

#' Add colors depending on attribute value
#' 
#' @description 
#' 
#' @param data \[\code{tibble()}\]\cr
#'  Data to modify.
#' @param group \[\code{character(1)}\]\cr
#'  Name of a currently selected attribute (if none, empty string).
#' 
#' @return A `tibble` with additional `color` column of character type.
#' 
#' @importFrom dplyr mutate
#' @importFrom rlang sym
color_by_attribute <- function(data, group) {
  data %>%
    mutate(color = ag_data_color_map[[group]][!!sym(group)])
}

#' Select columns relevant to graph data
#' 
#' @description Subsets columns to only use the ones relevant to the graph.
#' 
#' @param data \[\code{tibble()}\]\cr
#'  Data to modify.
#' @param group \[\code{character(1)}\]\cr
#'  Name of a currently selected attribute (if none, empty string).
#' 
#' @return A `tibble` with a set of selected and possibly renamed columns.
#' 
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
