render_XGMML_download <- function(id, edges) {
  insertUI(
    "#downloadgraph",
    where = "afterEnd",
    ui = downloadButton(
      id,
      label = "Download network as XGMML",
      class = "ag-download-button"
    )
  )
  XGMML_download_handler(edges)
}

render_HTML_download <- function(id, node_positions, nodes) {
  insertUI(
    "#downloadgraph",
    where = "afterEnd",
    ui = downloadButton(
      id,
      label = "Download network as HTML",
      class = "ag-download-button"
    )
  )
  HTML_download_handler(node_positions, nodes)
}
