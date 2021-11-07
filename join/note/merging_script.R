library(tidyverse)

#Add datasets: facilities list, dmcp authorized facilities, and new facilities (after 2017)
facilities <- read.csv("../input/facil-list.csv.gz", sep = "|")

new_facilities <- read.csv("../hand/to_research.csv")

#Data cleaning
facilities_clean <- facilities %>% select(1:12, authorizing_authority, over_under_72, capacity, guaranteed_minimum) %>% filter(detloc != "Redacted") %>%
  mutate(over_72 = case_when(over_under_72 == "Over 72" ~ TRUE,
                             over_under_72 == "Under 72" ~ FALSE,
                             TRUE ~ NA)) %>%
  select(-over_under_72)

#str(facilities_clean)
facilities_clean$capacity <- as.numeric(facilities_clean$capacity)

new_facilities_clean <- new_facilities %>% select(1:14, 16:17) %>%
  rename(detloc = detention_facility_code,
         name = detention_facility,
         type = contract) %>%
  filter(rec_count >= 50) %>%
  select(-rec_count) %>%
  mutate(over_72 = case_when(over_72 == "Y" ~ TRUE,
                             TRUE ~ FALSE))

#str(new_facilities_clean)
new_facilities_clean$zip <- as.factor(new_facilities_clean$zip)

#Joining
facilities_both <- bind_rows(facilities_clean, new_facilities_clean) %>%
  mutate(dmcp_auth = case_when(authorizing_authority == "DMCP" ~ TRUE,
                               authorizing_authority %in% c("JFRMU", "OTHER", "BOP") ~ FALSE,
                               TRUE ~ NA))
#dups <- facilities_both %>% filter(duplicated(detloc)) #Check for duplicates
write.csv(facilities_both, "../output/facilities.csv")
