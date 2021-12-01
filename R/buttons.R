# Predefined buttons

#' @importFrom shiny downloadButton actionButton
#' @importFrom readr write_csv
#' @importFrom writexl write_xlsx
BUTTONS <- list(
  DOWNLOAD_CSV = list(
    ui = \(ns) downloadButton(
      ns("download_csv"),
      label = "Download selected as CSV",
      class = "ag-download-button"
    ),
    server = \(ns, input, output, table_proxy, ..., edges, any_row_selected) {
      output[["download_csv"]] <- download_handler(input, edges, write_csv, "csv")
    },
    tags = "DOWNLOAD"
  ),
  DOWNLOAD_XSLX = list(
    ui = \(ns) downloadButton(
      ns("download_xslx"),
      label = "Download selected as Excel",
      class = "ag-download-button"
    ),
    server = \(ns, input, output, table_proxy, ..., edges, any_row_selected) {
      output[["download_xlsx"]] <- download_handler(input, edges, write_xslx, "xlsx")
    },
    tags = "DOWNLOAD"
  ),
  SELECT_ALL = list(
    ui = \(ns) actionButton(
      ns("select_all"),
      label = "Select all",
      class = "ag-selection-button"
    ),
    server = \(ns, input, output, table_proxy, ..., interactions_table) {
      observe_selecting_all(input, "select_all", table_proxy, interactions_table)
    },
    tags = "SELECT"
  ),
  DESELECT_ALL = list(
    ui = \(ns) actionButton(
      ns("deselect_all"),
      label = "Deselect all",
      class = "ag-deselection-button"
    ),
    server = \(ns, input, output, table_proxy, ...) {
      observe_deselecting_all(input, "deselect_all", table_proxy)
    },
    tags = "DESELECT"
  )
)

BUTTON_TAGS <- list(
  DOWNLOAD = \(ns, ..., any_row_selected) {
    observe_download_buttons(ns, any_row_selected)
  },
  DESELECT = \(ns, ..., any_row_selected) {
    observe_deselect_buttons(ns, any_row_selected)
  },
  SELECT = \(ns, ..., any_row_selected) {}
)