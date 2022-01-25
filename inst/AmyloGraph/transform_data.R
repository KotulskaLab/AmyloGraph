library(dplyr)
library(stringi)
library(stringr)
library(glue)

greek_letters <- c("^α", "^β", "^γ", "^δ", "^κ",
                   "α", "β", "γ", "δ", "κ")
greek_letter_names <- c("Alpha", "Beta", "Gamma", "Delta", "Kappa",
                        "alpha", "beta", "gamma", "delta", "kappa")
degreekize <- function(names)
  stri_replace_all_regex(names, greek_letters, greek_letter_names, vectorize_all = FALSE)

remove_breaklines <- function(text) stri_replace_all_fixed(text, "\n", " ")

sequentize <- function(sequences) sequences %>%
  stri_replace_all_regex("[0-9]| ", "") %>%
  stri_trans_toupper

substitute_with_na <- function(sequences) sequences %>%
  ifelse(. %in% c("sequence unavailable (protein complex)", "sequence unavailable"),
         NA_character_, .)

as_logical <- function(vector)
  ifelse(vector %in% c("TRUE", "PRAWDA"), TRUE,
         ifelse(vector %in% c("FALSE", "FAŁSZ"), FALSE, NA))

# interaction data ----

readRDS("inst/AmyloGraph/AmyloGraph.RDS") %>%
  filter(!as_logical(invalid_record),
         !as_logical(invalid_value)) %>%
  mutate(across(everything(), remove_breaklines)) %>%
  select(interactor_name, interactee_name,
         interactor_sequence, interactee_sequence,
         aggregation_speed = q1_answer,
         elongates_by_attaching = q2_answer,
         heterogenous_fibers = q3_answer,
         aggregation_speed_details = q1_text,
         elongates_by_attaching_details = q2_text,
         heterogenous_fibers_details = q3_text,
         general_remarks_field, doi) %>%
  mutate(across(ends_with("sequence"), substitute_with_na)) %>%
  mutate(interactor_name = degreekize(interactor_name),
         interactee_name = degreekize(interactee_name),
         interactor_sequence = sequentize(interactor_sequence),
         interactee_sequence = sequentize(interactee_sequence),
         aggregation_speed_details = degreekize(aggregation_speed_details),
         elongates_by_attaching_details = degreekize(elongates_by_attaching_details),
         heterogenous_fibers_details = degreekize(heterogenous_fibers_details),
         general_remarks_field = degreekize(general_remarks_field),
         AGID = glue("AG{str_pad(cur_group_rows(), 5, 'left', '0')}")) %>%
  filter(doi != "10.1101/2021.01.04.425177") %>% 
  write.csv("inst/AmyloGraph/interactions_data.csv",
            row.names = FALSE, fileEncoding = "UTF-8")

# the publication 10.1101/2021.01.04.425177 is removed in this very naive manner as we cannot alter the AGIDs right now

# protein data ----

tmp <- readRDS("inst/AmyloGraph/AmyloGraph_proteins.RDS") %>%
  select(name = `Protein name`,
         source = `Additional information`,
         uniprot_id = `Uniprot ID`) %>%
  mutate(name = degreekize(name)) %>%
  write.csv("inst/AmyloGraph/protein_data.csv",
            row.names = FALSE, fileEncoding = "UTF-8")
