#' @title Access label of currently selected protein
#' 
#' @description This function extracts label of the protein selected in one of
#' the available selectors (drop-down list or clicking on graph node).
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the protein selector.
#' @param node_data \[\code{data.frame()}\]\cr
#'  AmyloGraph node data.
#' 
#' @return A \code{reactive} object with a single string containing protein
#' name.
#' 
#' @importFrom shiny reactive req
#' @importFrom dplyr `%>%` filter pull
reactive_selected_node_label <- function(input, node_data) {
  reactive({
    req(input[["select_node"]])
    node_data %>%
      filter(id == input[["select_node"]]) %>%
      pull(label)
  })
}
