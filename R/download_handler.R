#' @title Handle download of AmyloGraph data
#' 
#' @description Creates a download handler that can be inserted into an app and
#' used to download AmyloGraph data in various formats.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the table.
#' @param edges \[\code{reactivevalues()}\]\cr
#'  AmyloGraph data with "table" element.
#' @param write_function \[\code{function(1)}\]\cr
#'  A function that transforms table data to a file.
#' @param extension \[\code{character(1)}\]\cr
#'  File extension without a dot to append to filename (e.g. `"csv"`).
#' 
#' @return A `downloadHandler` object.
#' 
#' @importFrom shiny downloadHandler
#' @importFrom dplyr `%>%` slice select
#' @importFrom glue glue
table_download_handler <- \(input, edges, write_function, extension)  {
  downloadHandler(
    filename = \() glue("AmyloGraph.{extension}"),
    content = \(file) write_function(
      edges[["table"]] %>%
        slice(input[["table_rows_selected"]]) %>%
        select(-c(from_id, to_id)),
      file
    )
  )
}
#' @title Handle download of AmyloGraph data to XGMML
#' 
#' @description Creates a download handler that can be inserted into an app and
#' used to download AmyloGraph datain XGMML format. All proteins are used as
#' nodes, even is all its interactions are filtered out.
#' 
#' @param edges \[\code{reactivevalues()}\]\cr
#'  AmyloGraph data with "table" element.
#' 
#' @return A `downloadHandler` object.
#' 
#' @importFrom shiny downloadHandler
#' @importFrom BioNet saveNetwork
XGMML_download_handler <- \(edges) {
  downloadHandler(
    filename = \() "AmyloGraph.XGMML",
    content = \(file) saveNetwork(
      igraph::graph_from_data_frame(
        edges[["table"]],
        vertices = ag_data_nodes()
      ),
      name = "AmyloGraph",
      file = file,
      type = "XGMML"
    )
  )
}