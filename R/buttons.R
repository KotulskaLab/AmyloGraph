# Predefined buttons

# TODO: use define_button() after replacing BUTTONS list with a function
#' @importFrom readr write_csv
#' @importFrom writexl write_xlsx
BUTTONS <- list(
  DOWNLOAD_CSV = list(
    ui = \(ns) downloadButton(
      ns("download_csv"),
      label = "Download selected as CSV",
      class = "ag-download-button"
    ),
    server = \(input, output, ..., table_data) {
      output[["download_csv"]] <- table_download_handler(
        input, table_data, write_csv, "csv"
      )
    },
    tags = "DOWNLOAD"
  ),
  DOWNLOAD_XLSX = list(
    ui = \(ns) downloadButton(
      ns("download_xlsx"),
      label = "Download selected as Excel",
      class = "ag-download-button"
    ),
    server = \(input, output, ..., table_data) {
      output[["download_xlsx"]] <- table_download_handler(
        input, table_data, write_xlsx, "xlsx"
      )
    },
    tags = "DOWNLOAD"
  ),
  SELECT_ALL = list(
    ui = \(ns) actionButton(
      ns("select_all"),
      label = "Select all",
      class = "ag-selection-button"
    ),
    server = \(input, output, ..., table_proxy) {
      observe_selecting_all(input, "select_all", table_proxy)
    },
    tags = "SELECT"
  ),
  DESELECT_ALL = list(
    ui = \(ns) actionButton(
      ns("deselect_all"),
      label = "Deselect all",
      class = "ag-deselection-button"
    ),
    server = \(input, output, ..., table_proxy) {
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
  SELECT = \(ns, ...) {}
)
