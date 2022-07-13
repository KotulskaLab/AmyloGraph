#' Handle download of AmyloGraph data
#' 
#' @description Creates a download handler that can be inserted into an app and
#' used to download AmyloGraph data in various formats.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the table.
#' @param table_data \[\code{data.frame()}\]\cr
#'  AmyloGraph table data.
#' @param write_function \[\code{function(1)}\]\cr
#'  A function that transforms table data to a file.
#' @param extension \[\code{character(1)}\]\cr
#'  File extension without a dot to append to filename (e.g. `"csv"`).
#' 
#' @return A `downloadHandler` object.
#' 
#' @importFrom dplyr select slice
table_download_handler <- function(input, table_data, write_function, extension)  {
  downloadHandler(
    filename = function() glue("AmyloGraph.{extension}"),
    content = function(file) write_function(
      table_data() %>%
        slice(input[["table_rows_selected"]]) %>%
        select(-c(from_id, to_id)),
      file
    )
  )
}
#' Handle download of AmyloGraph data to XGMML
#' 
#' @description Creates a download handler that can be inserted into an app and
#' used to download AmyloGraph data in XGMML format. All proteins are used as
#' nodes, even is all its interactions are filtered out.
#' 
#' @param edges \[\code{reactivevalues()}\]\cr
#'  AmyloGraph data with "table" element.
#' 
#' @return A `downloadHandler` object.
#' 
#' @importFrom BioNet saveNetwork
#' @importFrom dplyr mutate
#' @importFrom igraph graph_from_data_frame
XGMML_download_handler <- function(edges) {
  downloadHandler(
    filename = function() "AmyloGraph",
    content = function(file) saveNetwork(
      graph_from_data_frame(
        edges[["table"]] %>%
          mutate(
            interactor_sequence = map_chr(interactor_sequence, deparse_chains),
            interactee_sequence = map_chr(interactee_sequence, deparse_chains)
          ),
        vertices = ag_data_nodes()
      ),
      name = "AmyloGraph",
      file = file,
      type = "XGMML"
    )
  )
}

#' Handle download of AmyloGraph network to HTML
#' 
#' @description Creates a download handler that can be inserted into an app and
#' used to download AmyloGraph network data in HTML format.
#' 
#' @param node_positions \[\code{reactive(data.frame())}\]\cr
#'  Table of node positions with `x`, `y`, and `id` columns.
#' @param nodes \[\code{data.frame()}\]\cr
#'  AmyloGraph node data.
#' @param edges \[\code{data.frame()}\]\cr
#'  AmyloGraph edge data.
#' 
#' @return A `downloadHandler` object.
#' 
#' @importFrom dplyr mutate
#' @importFrom visNetwork visSave
HTML_download_handler <- function(node_positions, nodes) {
  downloadHandler(
    filename = function() "AmyloGraph.html",
    content = function(file) {
      node_positions <- node_positions()
      if (!is.null(node_positions)) {
        nodes <- merge(nodes, node_positions, by = "id", all = TRUE)
      }
      
      edges <- ag_data_interactions %>%
        mutate(from = from_id, to = to_id)
      
      visAGNetwork(nodes, edges) %>%
        visSave(file)
    }
  )
}
