library(dplyr)
library(stringi)
library(stringr)
library(glue)

AG_data <- readRDS("inst/AmyloGraph/AmyloGraph.RDS")

greek_letters <- c("^α", "^β", "^δ", "^κ", "α", "β", "κ", "δ")
greek_letter_names <- c("Alpha", "Beta", "Delta", "Kappa", "alpha", "beta", "delta", "kappa")
degreekize <- function(names) stri_replace_all_regex(names, greek_letters, greek_letter_names, vectorize_all = FALSE)

sequentize <- function(sequences) 
  stri_replace_all_regex(sequences, "\n", "", ) %>%
  stri_replace_all_regex("[0-9]", "") %>%
  stri_trans_toupper %>%
  stri_extract_last_regex("[A-Z]+$")
  

AG_data %>%
  select(interactor_name = `Interactor name`,
         interactee_name = `Interactee name`,
         interactor_sequence = Sequence,
         interactee_sequence = `Sample sequence`,
         aggregation_speed = `Is the interactor affecting interactee’s aggregating speed`,
         elongates_by_attaching = `If interactee is still forming fibrils after the interaction, do fibrils of interactee elongates by attaching to monomers/oligomers/fibrils of interactor?`,
         heterogenous_fibers = `Is interaction resulting in heterogeneous fibrils consisting of interactor and interactee molecules?`,
         doi = `DOI (only number, no the link, e.g., 10.1073/pnas.1610371113)`) %>%
  mutate(interactor_name = degreekize(interactor_name),
         interactee_name = degreekize(interactee_name),
         interactor_sequence = sequentize(interactor_sequence),
         interactee_sequence = sequentize(interactee_sequence),
         AGID = glue("AG{str_pad(cur_group_rows(), 5, 'left', '0')}")) %>%
  write.csv("inst/AmyloGraph/interactions_data.csv", row.names = FALSE)
