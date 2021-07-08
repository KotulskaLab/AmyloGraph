library(dplyr)
library(stringi)

AG_data <- readRDS("AmyloGraph.RDS")

greek_letters <- c("α", "β", "κ")
greek_letter_names <- c("alpha", "beta", "kappa")
degreekize <- function(names) {
  stri_replace_all_fixed(names, greek_letters, greek_letter_names, vectorize_all = FALSE) %>%
    stri_trans_totitle(type = 'sentence')
}

AG_data %>%
  select(interactor_name = `Interactor name`,
         interactee_name = `Interactee name`,
         aggregation_speed = `Is the interactor affecting interactee’s aggregating speed`,
         elongates_by_attaching = `If interactee is still forming fibrils after the interaction, do fibrils of interactee elongates by attaching to monomers/oligomers/fibrils of interactor?`,
         heterogenous_fibers = `Is interaction resulting in heterogeneous fibrils consisting of interactor and interactee molecules?`,
         doi = `DOI (only number, no the link, e.g., 10.1073/pnas.1610371113)`) %>%
  mutate(interactor_name = degreekize(interactor_name),
         interactee_name = degreekize(interactee_name)) %>%
  
  write.csv("interactions_data.csv", row.names = FALSE)
