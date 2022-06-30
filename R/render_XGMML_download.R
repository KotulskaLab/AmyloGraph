render_XGMML_download <- function(id, edge_data) {
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
