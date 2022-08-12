#
# Date: 2022-08-12
# Author: UWCHR
# Copyright: UWCHR, GPL v2 or later
#
# ice-facilities/join/src/join.R
#

library(tidyverse)
library(here)
library(logger)

log_threshold(TRACE)

log_appender(appender_file(here::here('join', 'output', 'join.log')))

logger <- layout_glue_generator(format = '{time}|{msg}')
log_layout(logger)

facilities <- read_delim(here::here('join', 'input', 'facil-list.csv.gz'),
    delim = "|") 

log_info('input_file|facil-list.csv.gz')
rows_in <- nrow(facilities)
log_info('rows_in|{rows_in}')

new_facilities <- read_delim(here::here('join', 'hand', 'new_facilities.csv'),
    delim = ",")

#Data cleaning
facilities_clean <- facilities %>%
    select(1:12,
        authorizing_authority,
        over_under_72,
        capacity,
        guaranteed_minimum,
        date_of_last_use,
        date_of_first_use) %>%
    filter(detloc != "Redacted") %>%
    mutate(over_72 = case_when(over_under_72 == "Over 72" ~ TRUE,
                               over_under_72 == "Under 72" ~ FALSE,
                               TRUE ~ NA)) %>%
    select(-over_under_72)

post_drop <- nrow(facilities_clean)
log_info('dropped_redacted|{rows_in - post_drop}')

facilities_clean$capacity <- as.numeric(as.character(facilities_clean$capacity))

pre_drop <- nrow(new_facilities)

new_facilities_clean <- new_facilities %>% select(1:14, 16:17) %>%
    rename(detloc = detention_facility_code,
           name = detention_facility,
           type = contract) %>%
    filter(rec_count >= 50) %>%
    select(-rec_count) %>%
    mutate(over_72 = case_when(over_72 == "Y" ~ TRUE,
                             TRUE ~ FALSE))

post_drop <- nrow(new_facilities_clean)
log_info('under_50_pop_dropped|{pre_drop - post_drop}')

new_facilities_clean$zip <- as.factor(new_facilities_clean$zip)

#Joining
facilities_both <- bind_rows(facilities_clean, new_facilities_clean) %>%
    mutate(dmcp_auth = case_when(authorizing_authority == "DMCP" ~ TRUE,
                               authorizing_authority %in% c("JFRMU", "OTHER", "BOP") ~ FALSE,
                               TRUE ~ NA))

output_file <- facilities_both
output_filename <- 'facilities.csv.gz'

write_delim(output_file, here::here('join', 'output', output_filename),
    delim='|')

log_info('rows_out|{nrow(output_file)}')
log_info('output_file|{output_filename}')

# END.