library(tidyverse)
library(here)

facilities <- read_delim(here::here('join', 'input', 'facil-list.csv.gz'),
    delim = "|") 

new_facilities <- read_delim(here::here('join', 'hand', 'new_facilities.csv'),
    delim = ",")

#Data cleaning
facilities_clean <- facilities %>%
    select(1:12, authorizing_authority, over_under_72, capacity, guaranteed_minimum) %>%
    filter(detloc != "Redacted") %>%
    mutate(over_72 = case_when(over_under_72 == "Over 72" ~ TRUE,
                               over_under_72 == "Under 72" ~ FALSE,
                               TRUE ~ NA)) %>%
    select(-over_under_72)

facilities_clean$capacity <- as.numeric(as.character(facilities_clean$capacity))

# TO DO: Log dropped facilities
new_facilities_clean <- new_facilities %>% select(1:14, 16:17) %>%
    rename(detloc = detention_facility_code,
           name = detention_facility,
           type = contract) %>%
    filter(rec_count >= 50) %>%
    select(-rec_count) %>%
    mutate(over_72 = case_when(over_72 == "Y" ~ TRUE,
                             TRUE ~ FALSE))

new_facilities_clean$zip <- as.factor(new_facilities_clean$zip)

#Joining
facilities_both <- bind_rows(facilities_clean, new_facilities_clean) %>%
    mutate(dmcp_auth = case_when(authorizing_authority == "DMCP" ~ TRUE,
                               authorizing_authority %in% c("JFRMU", "OTHER", "BOP") ~ FALSE,
                               TRUE ~ NA))

#dups <- facilities_both %>% filter(duplicated(detloc)) #Check for duplicates

write_delim(facilities_both, here::here('join', 'output', 'facilities.csv.gz'),
    delim='|')

# END.