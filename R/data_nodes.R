#' @importFrom dplyr `%>%` select 
#' @importFrom purrr map_chr
#' @importFrom tibble tibble
#' @importFrom digest digest
ag_data_nodes <- function()
  ag_data_interactions() %>%
  select(interactor_name, interactee_name) %>% 
  unlist() %>% 
  unique() %>% 
  tibble(label = .,
         id = map_chr(label, digest),
         shape = "box")