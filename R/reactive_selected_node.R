#' @title Access label of currently selected protein
#' 
#' @description This function extracts label from protein info.
#' 
#' @param selected_node_info \[\code{reactive(data.frame())}\]\cr
#'  A row from AmyloGraph node data for a single protein.
#' 
#' @return A \code{reactive} object with a single string containing protein
#' name.
#' 
#' @importFrom shiny reactive
reactive_selected_node_label <- function(selected_node_info) {
  reactive({
    selected_node_info()[["label"]]
  })
}

#' @title Access info of currently selected protein
#' 
#' @description This function accesses information about protein selected in
#' one of the available selectors (drop-down list or clicking on graph node).
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the protein selector.
#' @param node_data \[\code{data.frame()}\]\cr
#'  AmyloGraph node data.
#' 
#' @return A \code{reactive} object with a \code{data.frame} with exactly one
#' row of data, corresponding to currently selected node/protein.
#' 
#' @importFrom shiny reactive req
#' @importFrom dplyr `%>%` filter
reactive_selected_node_info <- function(input, node_data) {
  reactive({
    req(input[["select_node"]])
    node_data %>%
      filter(id == input[["select_node"]])
  })
}
