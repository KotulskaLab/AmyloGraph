#' @importFrom glue glue
table_download_handler <- \(input, edges, write_function, extension)  downloadHandler(
  filename = \() glue("AmyloGraph.{extension}"),
  content = \(file) write_function(
    edges[["table"]] %>%
      slice(input[["table_rows_selected"]]) %>%
      select(-c(from_id, to_id)),
    file
  )
)

#' @importFrom BioNet saveNetwork
XGMML_download_handler <- \(edges) {
  downloadHandler(
    filename = \() "AmyloGraph.XGMML",
    content = \(file) saveNetwork(
      igraph::graph_from_data_frame(
        edges[["table"]],
        # Will create igraph object will all nodes, even those with all interactions
        # filtered out
        vertices = ag_data_nodes()
      ),
      name = "AmyloGraph",
      file = file,
      type = "XGMML"
    )
  )
}