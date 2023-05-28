#
# Date: 2022-08-12
# Author: UWCHR
# Copyright: UWCHR, GPL v2 or later
#
# ice-facilities/join/src/join.R
#

library(pacman)
p_load(argparse, tidyverse, here, logger)

parser <- ArgumentParser()
parser$add_argument("--input", default = 'input/facil-list.csv.gz')
parser$add_argument("--to_join", default = 'hand/new_facilities.csv')
parser$add_argument("--logfile", default = 'output/join.log')
parser$add_argument("--output", default = 'output/facilities.csv.gz') 
args <- parser$parse_args()

log_threshold(TRACE)
log_appender(appender_file(args$logfile))
logger <- layout_glue_generator(format = '{time}|{msg}')
log_layout(logger)

facilities <- read_delim(args$input,
    delim = "|") 

log_info('Input file: {args$input}')
rows_in <- nrow(facilities)
log_info('NIJC rows in: {rows_in}')

log_info('File to join: {args$to_join}')
new_facilities <- read_delim(args$to_join,
    delim = ",")
rows_in <- nrow(new_facilities)
log_info('New facil rows in: {rows_in}')


#Data cleaning
pre_drop <- nrow(facilities)

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

facilities_clean[facilities_clean == "nan"] <- NA

post_drop <- nrow(facilities_clean)
log_info('Facilities with redacted DETLOC dropped: {pre_drop - post_drop}')

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
log_info('Facilities with under 50 total headcount dropped: {pre_drop - post_drop}')

new_facilities_clean$zip <- as.factor(new_facilities_clean$zip)

#Joining
df <- bind_rows(facilities_clean, new_facilities_clean) %>%
    mutate(dmcp_auth = case_when(authorizing_authority == "DMCP" ~ TRUE,
                               authorizing_authority %in% c("JFRMU", "OTHER", "BOP") ~ FALSE,
                               TRUE ~ NA))

write_delim(df, args$output,
    delim='|')

log_info('Rows out: {nrow(df)}')
log_info('Output file: {args$output}')

# END.