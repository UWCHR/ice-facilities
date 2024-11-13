#
# Authors:     PN
# Maintainers: PN
# Copyright:   2024, UWCHR, GPL v2 or later
# =========================================
# ice-facilities/geocode/src/geo.R

library(pacman)

pacman::p_load(argparse, tidyverse, lubridate, here, skimr, yaml, dplyr, ggmap, jsonlite, gdata, tidygeocoder
	)

parser <- ArgumentParser()
parser$add_argument("--input", default = "geocode/input/facilities.csv.gz")
parser$add_argument("--output", default = "geocode/output/facilities.csv.gz")
args <- parser$parse_args()

ggkey = Sys.getenv("GOOGLEGEOCODE_API_KEY")
print(ggkey)
register_google(key = ggkey)

####

inputfile <- (args$input)

facil <- read_delim(
    inputfile, delim = "|")

# Logic here to break script if no new values

facil$loc <- paste0(facil$address, ", ", facil$city, ", ", facil$state, " ", facil$zip)

facil_geo <- geo(facil$loc, method='google', full_results=TRUE)

saveRDS(facil_geo, here("geocode", "frozen", "facil_geocode.rds"))

facil_geo_clean <- facil_geo %>%
  filter(!is.na(lat),
         'partial_match' != TRUE) %>% 
  distinct(address, .keep_all = TRUE)

facil_out <- facil %>% 
  left_join(facil_geo_clean, by = c("loc" = "address")) %>% 
  dplyr::select(-c('loc', 'address_components'))

write_delim(facil_out, args$output, delim = "|")
