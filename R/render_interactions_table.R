#' @importFrom glue glue
download_button_callback <- function(ns, session, button_id, button_label)
  glue(
    "var i = document.createElement('i');",
    "$(i).addClass('fa fa-download');",
    
    "var span = document.createElement('span');",
    # TODO: keep space or use CSS properly?
    "$(span).text(' {button_label}');",
    
    "var a = document.createElement('a');",
    "$(a).addClass('dt-button');",
    "a.href = 'session/{session$token}/download/{ns(button_id)}?w=';",
    "a.download = '';",
    "$(a).attr('target', '_blank');",
    "$(a).attr('tabindex', 0);",
    
    "$(a).append(i);",
    "$(a).append(span);",
    "$('#{ns('table')} .ag-buttons').append(a);"
  )

#' @importFrom DT renderDataTable JS
render_interactions_table <- function(interactions_table, ns, session)
  renderDataTable(
    interactions_table(),
    options = list(
      dom = 'B<"ag-buttons">frtip',
      scrollY = "calc(100vh - 330px - var(--correction))",
      scrollX = TRUE,
      scrollCollapse = TRUE,
      lengthMenu = list(c(10, 25, 50, 100, -1), c("10", "25", "50", "100", "All")),
      buttons = c("pageLength", "selectAll", "selectNone", "colvis"),
      select = list(style = "multi+shift", items = "row")
    ),
    escape = FALSE,
    filter = "top",
    rownames = FALSE,
    colnames = ag_colnames(interactions_table()),
    extensions = c("Select", "Buttons"),
    selection = "none",
    server = FALSE,
    callback = JS(
      download_button_callback(ns, session, "download_csv", "Download selected as CSV"),
      download_button_callback(ns, session, "download_xlsx", "Download selected as Excel"),
      "$('.btn_hidden').hide();"
    )
  )