library(dplyr)

AG_data <- readRDS("AmyloGraph.RDS")

AG_data %>%
  select(interactor_name = `Interactor name`,
         interactee_name = `Interactee name`,
         aggregation_speed = `Is the interactor affecting interactee’s aggregating speed`,
         elongates_by_attaching = `If interactee is still forming fibrils after the interaction, do fibrils of interactee elongates by attaching to monomers/oligomers/fibrils of interactor?`,
         heterogenous_fibers = `Is interaction resulting in heterogeneous fibrils consisting of interactor and interactee molecules?`,
         doi = `DOI (only number, no the link, e.g., 10.1073/pnas.1610371113)`) %>%
  write.csv("interactions_data.csv", row.names = FALSE)
