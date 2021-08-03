#' @importFrom shiny renderUI req HTML
render_protein_info <- \(input, selected_node_label) renderUI({
  req(input[["select_node"]])
  HTML(random_description(selected_node_label()))
})