library(dplyr)
library(stringi)
library(stringr)
library(glue)
library(rcrossref)

greek_letters <- c("^α", "^β", "^γ", "^δ", "^κ",
                   "α", "β", "γ", "δ", "κ")
greek_letter_names <- c("Alpha", "Beta", "Gamma", "Delta", "Kappa",
                        "alpha", "beta", "gamma", "delta", "kappa")
degreekize <- function(names)
  stri_replace_all_regex(names, greek_letters, greek_letter_names, vectorize_all = FALSE)

remove_breaklines <- function(text) stri_replace_all_fixed(text, "\n", " ")

substitute_with_na <- function(sequences) sequences %>%
  ifelse(. %in% c("sequence unavailable (protein complex)", "sequence unavailable"),
         NA_character_, .)

# interaction data ----

insulin_interactions <- readRDS("inst/AmyloGraph/AmyloGraph_insulins.RDS") %>%
  mutate(obsolete = FALSE)

readRDS("inst/AmyloGraph/AmyloGraph.RDS") %>%
  mutate(obsolete = interactor_name == "Insulin" |
           interactee_name == "Insulin" |
           # Publication 10.1101/2021.01.04.425177 is removed in this very naive
           #  manner as we cannot alter the AGIDs right now
           doi == "10.1101/2021.01.04.425177") %>%
  bind_rows(insulin_interactions) %>%
  filter(!invalid_record, !invalid_value) %>%
  mutate(across(where(is.character), remove_breaklines)) %>%
  select(interactor_name, interactee_name,
         interactor_sequence, interactee_sequence,
         aggregation_speed = q1_answer,
         elongates_by_attaching = q2_answer,
         heterogenous_fibers = q3_answer,
         aggregation_speed_details = q1_text,
         elongates_by_attaching_details = q2_text,
         heterogenous_fibers_details = q3_text,
         general_remarks_field, doi, obsolete) %>%
  mutate(across(ends_with("sequence"), substitute_with_na)) %>%
  mutate(interactor_name = degreekize(interactor_name),
         interactee_name = degreekize(interactee_name),
         interactor_sequence = interactor_sequence,
         interactee_sequence = interactee_sequence,
         aggregation_speed_details = degreekize(aggregation_speed_details),
         elongates_by_attaching_details = degreekize(elongates_by_attaching_details),
         heterogenous_fibers_details = degreekize(heterogenous_fibers_details),
         general_remarks_field = degreekize(general_remarks_field),
         AGID = glue("AG{str_pad(cur_group_rows(), 5, 'left', '0')}")) %>%
  filter(!obsolete) %>%
  select(-obsolete) %>%
  write.csv("inst/AmyloGraph/interactions_data.csv",
            row.names = FALSE, fileEncoding = "UTF-8")

# protein data ----

tmp <- readRDS("inst/AmyloGraph/AmyloGraph_proteins.RDS") %>%
  select(name = `Protein name`,
         source = `Additional information`,
         uniprot_id = `Uniprot ID`) %>%
  mutate(name = degreekize(name)) %>%
  write.csv("inst/AmyloGraph/protein_data.csv",
            row.names = FALSE, fileEncoding = "UTF-8")


all_dois <- read.csv("inst/AmyloGraph/interactions_data.csv")[["doi"]] %>%
  unique() %>%
  enc2utf8()

doi_df <- cr_works(all_dois)

nms <- lapply(doi_df[["data"]][["author"]], function(x) filter(x, sequence == "first"))

all_names <- sapply(doi_df[["data"]][["author"]], function(x) {
  paste0(apply(x, 1, function(ith_row) paste0(ith_row["given"], " ", ith_row["family"])), collapse = ", ")
})
#sapply(nms, function(i) paste0(substr(i[["given"]], 0, 1), " ", i[["family"]], " et al."))) %>% 

get_year <- function(x) {
  as.numeric(sapply(strsplit(x, "-"), first))
}

years <- select(doi_df[["data"]], doi, published.print, published.online) %>% 
  mutate(published.print = get_year(published.print),
         published.online = get_year(published.online)) %>% 
  group_by(doi) %>% 
  mutate(year = min(published.print, published.online, na.rm = TRUE)) %>% 
  pull(year)

data.frame(doi = doi_df[["data"]][["doi"]],
           nm = sapply(nms, function(i) i[["family"]]),
           all_names = all_names, 
           title = remove_breaklines(doi_df[["data"]][["title"]]),
           journal = doi_df[["data"]][["container.title"]],
           year = years) %>% 
  write.csv("inst/AmyloGraph/reference_table.csv",
            row.names = FALSE, fileEncoding = "UTF-8")
