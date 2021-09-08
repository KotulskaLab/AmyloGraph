#' @importFrom purrr map_chr
#' @importFrom glue glue
#' @importFrom shiny actionButton
details_button <- \(interaction_ids, id, ns, ...) {
  map_chr(interaction_ids, 
          \(interaction_id) as.character(
            #should this values of id be generated manually with NS like this?
            actionButton(glue("ns(interaction_view_selector_{interaction_id})"), 
                         "Details",
                         onclick = glue("Shiny.setInputValue('{NS('single_interaction', 'selected_interaction')}', '{interaction_id}')"))))
}