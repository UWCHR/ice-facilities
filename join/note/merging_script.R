library(tidyverse)

#Add datasets: facilities list, dmcp authorized facilities, and new facilities (after 2017)
facilities <- read.csv("../input/facil-list.csv.gz", sep = "|")
dmcp <- read.csv("../input/dmcp-detailed.csv.gz", sep = "|")
new_facilities <- read.csv("../hand/to_research.csv")

#Data cleaning
facilities_clean <- facilities %>% select(1:12, authorizing_authority, over_under_72, capacity) %>% filter(detloc != "Redacted") %>%
  mutate(over_72 = case_when(over_under_72 == "Over 72" ~ TRUE,
                             over_under_72 == "Under 72" ~ FALSE,
                             TRUE ~ NA)) %>%
  select(-over_under_72)
new_facilities_clean <- new_facilities %>% select(1:7) %>%
  rename(detloc = detention_facility_code,
         name = detention_facility,
         type = contract) %>%
  filter(rec_count >= 50) %>%
  select(-rec_count) %>%
  mutate(over_72 = case_when(over_72 == "Y" ~ TRUE,
                             TRUE ~ FALSE))
#dmcp_clean <- dmcp %>% select(detloc, over_under_72) %>%
  #mutate(over_72 = case_when(over_under_72 == "Over 72" ~ TRUE,
                             #TRUE ~ FALSE)) %>%
  #select(-over_under_72) %>%
  #add_column(dmcp_auth = TRUE)

#Joining
#facilities_clean <- left_join(facilities_clean, dmcp_clean, by = "detloc")
facilities_both <- bind_rows(facilities_clean, new_facilities_clean) %>% distinct(detloc, .keep_all = TRUE)
write.csv(facilities_both, "../output/facilities.csv")
