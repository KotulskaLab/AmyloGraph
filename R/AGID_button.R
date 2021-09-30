#' @importFrom purrr map_chr
#' @importFrom glue glue
#' @importFrom shiny actionButton
AGID_button <- \(interaction_ids, id, ns, ...) {
  map_chr(interaction_ids, 
          \(interaction_id) as.character(
            #should this values of id be generated manually with NS like this?
            actionButton(glue("ns(interaction_view_selector_{interaction_id})"), 
                         as.character(interaction_id),
                         onclick = glue("Shiny.setInputValue('{NS('single_interaction', 'selected_interaction')}', '{interaction_id}')"))))
}