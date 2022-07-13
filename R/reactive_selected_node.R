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
#' @importFrom dplyr filter pull
reactive_selected_node_label <- function(input) {
  reactive({
    req(input[["select_node"]])
    ag_data_nodes %>%
      filter(id == input[["select_node"]]) %>%
      pull(label)
  })
}
