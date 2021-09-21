#' @importFrom glue glue
download_button_callback <- function(ns, button_id, button_label)
  glue(
    "var i = document.createElement('i');",
    "$(i).addClass('fa fa-download');",
    
    "var span = document.createElement('span');",
    # TODO: keep space or use CSS properly?
    "$(span).text(' {button_label}');",
    
    "var a = document.createElement('a');",
    "$(a).addClass('dt-button');",
    "a.href = document.getElementById('{ns(button_id)}').href;",
    "a.download = '';",
    "$(a).attr('target', '_blank');",
    "$(a).attr('tabindex', 0);",
    
    "$(a).append(i);",
    "$(a).append(span);",
    "$('#{ns('table')} .dt-buttons').append(a);"
  )

#' @importFrom DT renderDataTable JS
render_interactions_table <- function(interactions_table, ns)
  renderDataTable(
    interactions_table(),
    options = list(
      dom = glue('lBfrtip'),
      scrollY = "calc(100vh - 330px - var(--correction))",
      scrollX = TRUE,
      scrollCollapse = TRUE,
      lengthMenu = list(c(10, 25, 50, 100, -1), c("10", "25", "50", "100", "All")),
      buttons = "colvis"
    ),
    escape = FALSE,
    filter = "top",
    rownames = FALSE,
    colnames = ag_colnames(interactions_table()),
    extensions = "Buttons",
    callback = JS(
      download_button_callback(ns, "download_csv", "Download as CSV"),
      download_button_callback(ns, "download_xlsx", "Download as Excel"),
      "$('.ag_hidden_btn').hide();"
    )
  )