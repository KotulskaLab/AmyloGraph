.onLoad <- function(libname, pkgname) {
  prev_options <- options()
  
  new_options <- list(
    ag_str_null = "null", 
    ag_palette = c("#F9564F", "#A4B0F5", "#4F3824", "#00CC66",
                   "#B33F62", "#F3C677", "#0C0A3E", "gray40"),
    ag_side_panel_width = 2,
    ag_main_panel_width = 10,
    ag_colnames = c(`Interactee name` = "interactee_name",
                    `Interactor name` = "interactor_name",
                    `AG_ID` = "AGID",
                    DOI = "doi",
                    `Fibrillization speed` = "aggregation_speed",
                    `Physical binding` = "elongates_by_attaching",
                    `Heterogenous fibers` = "heterogenous_fibers",
                    Details = "details"),
    ag_interaction_attrs = c("aggregation_speed",
                             "elongates_by_attaching",
                             "heterogenous_fibers"),
    ag_center_network = TRUE,
    ag_sequence_group_length = 10,
    ag_sequence_line_length = 80,
    ag_chain_separator = " "
  )
  
  unset_inds <- !(names(new_options) %in% names(prev_options))
  if (any(unset_inds)) {
    options(new_options[unset_inds])
  }
  
  if (packageVersion("rlang") >= "1.0.0") {
    rlang::run_on_load()
  } else {
    assign("ag_data_interactions", {
      readr::read_csv(
        system.file("AmyloGraph", "interactions_data.csv", package = "AmyloGraph"),
        col_types = "ccccfffcccccc"
      ) |>
        dplyr::mutate(from_id = purrr::map_chr(interactor_name, digest::digest),
                      to_id = purrr::map_chr(interactee_name, digest::digest),
                      interactor_sequence = purrr::map(interactor_sequence, read_chains),
                      interactee_sequence = purrr::map(interactee_sequence, read_chains),
                      AGID_button = AGID_button(AGID))
    }, envir = parent.env(environment()))
    
    interaction_attrs <- getOption("ag_interaction_attrs")
    
    assign("ag_data_nodes", {
      ag_data_interactions |>
        dplyr::select(interactor_name, interactee_name) |>
        unlist() %>% 
        unique() %>% 
        dplyr::tibble(label = .,
                      id = purrr::map_chr(label, digest::digest),
                      shape = "box")
    }, envir = parent.env(environment()))
    
    assign("ag_data_group_labels", {
      interaction_attrs %>%
        purrr::map_chr(text_label_attribute) %>%
        setNames(interaction_attrs) %>%
        invert_names()
    }, envir = parent.env(environment()))
    
    assign("ag_data_attribute_values", {
      setNames(purrr::map(
        interaction_attrs,
        ~ sort(unique(ag_data_interactions[[.x]]))
      ), interaction_attrs)
    }, envir = parent.env(environment()))
    
    assign("ag_data_color_map", {
      purrr::map(
        ag_data_attribute_values,
        ~ setNames(getOption("ag_palette")[seq_along(.x)], .x)
      )
    }, envir = parent.env(environment()))
    
    assign("ag_data_proteins", {
      readr::read_csv(
        system.file("AmyloGraph", "protein_data.csv", package = "AmyloGraph"),
        col_types = "ccc"
      ) |>
        dplyr::mutate(id = purrr::map_chr(name, digest::digest))
    }, envir = parent.env(environment()))
    
    assign("ag_data_references", {
      readr::read_csv(
        system.file("AmyloGraph", "reference_table.csv", package = "AmyloGraph"),
        col_types = "cccccn"
      )
    }, envir = parent.env(environment()))
  }
  
  icecream::ic_disable()
  invisible()
}