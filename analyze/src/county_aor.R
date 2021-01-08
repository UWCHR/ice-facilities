# Authors:     TM, PN
# Maintainers: PN, MVL
# Copyright:   2020, UWCHR, GPL v2 or later
# =========================================
# ice/facilities/analyze/src/county_aor.R

library(tidyverse)
library(tidycensus)
library(tigris)
library(sf)
library(yaml)
library(here)
library(assertr)

# setwd('~/git/ice-facilities/analyze/src/')

# https://walker-data.com/tidycensus/articles/basic-usage.html
# check census api key
Sys.getenv("CENSUS_API_KEY")

# use tigris
options(tigris_use_cache = TRUE)

# load table of variable names, labels
v18 <- load_variables(2018, "acs1", cache = TRUE)

# return data frame of geographical unit identifier and descriptive name
df_counties <- get_acs(
  geography = "county", 
  variables = c("Total Population" = "B01003_001"),
  year = 2018,
  survey = "acs1")

# standardize variable names
df_counties$name <- tolower(df_counties$name)
  
# separate geoid into state and county identifiers
df_counties <- df_counties %>%
  separate(geoid, 
           c("geoid_state", 
             "geoid_county"), 
           sep = 2,
           remove = FALSE
           )

# generate variable indicating aor
df_counties <- df_counties %>%
  mutate(aor = NA_character_)

# assign states to aors
df_counties <- mutate(df_counties, aor = 
    # assign states to aors
        ifelse(geoid_state %in% c("13", "37", "45"), "ATL",
        ifelse(geoid_state %in% c("24"), "BAL", 
        ifelse(geoid_state %in% c("09", "23", "25", "33", "44", "50"), "BOS", 
        ifelse(geoid_state %in% c("17", "18", "55", "29", "21", "20"), "CHI", 
        ifelse(geoid_state %in% c("08", "56"), "DEN", 
        ifelse(geoid_state %in% c("26", "39"), "DET", 
        ifelse(geoid_state %in% c("35"), "ELP", 
        ifelse(geoid_state %in% c("12", "72", "78"), "MIA", 
        ifelse(geoid_state %in% c("34"), "NEW", 
        ifelse(geoid_state %in% c("01", "05", "22", "28", "47"), "NOL", 
        ifelse(geoid_state %in% c("10", "42", "54"), "PHI", 
        ifelse(geoid_state %in% c("04"), "PHO", 
        ifelse(geoid_state %in% c("02", "41", "53"), "SEA", 
        ifelse(geoid_state %in% c("15", "14"), "SFR", # missing Saipan
        ifelse(geoid_state %in% c("49", "16", "30", "32"), "SLC", 
        ifelse(geoid_state %in% c("19", "27", "31", "38", "46"), "SPM", 
        ifelse(geoid_state %in% c("11", "51"), "WAS", 
        ifelse(geoid_state %in% c("40"), "DAL", 
    # assign counties to aors
        ifelse(geoid %in% c("36001", "36003", "36007", "36009", "36011", "36013", "36015", "36017", "36019", "36021", "36023", "36025", "36029", "36031", "36033", "36035", "36037", "36039", "36041", "36043", "36045", "36049", "36051", "36053", "36055", "36057", "36063", "36065", "36067", "36069", "36073", "36075", "36077", "36083", "36091", "36093", "36095", "36097", "36099", "36089", "36101", "36107", "36109", "36113", "36115", "36117", "36121", "36123"), "BUF", 
        ifelse(geoid %in% c(
"48001", # Anderson County, Texas
"48387",    # Red River County, Texas
"48073",    # Cherokee County, Texas
"48349",    # Navarro County, Texas
"48213",    # Henderson County, Texas
"48105",    # Crockett County, Texas
"48435",    # Sutton County, Texas
"48077",    # Clay County, Texas
"48009",    # Archer County, Texas
"48011",    # Armstrong County, Texas
"48017",    # Bailey County, Texas
"48023",    # Baylor County, Texas
"48111",    # Dallam County, Texas
"48117",    # Deaf Smith County, Texas
"48165",    # Gaines County, Texas
"48115",    # Dawson County, Texas
"48095",    # Concho County, Texas
"48327",    # Menard County, Texas
"48413",    # Schleicher County, Texas
"48451",    # Tom Green County, Texas
"48235",    # Irion County, Texas
"48383",    # Reagan County, Texas
"48431",    # Sterling County, Texas
"48173",    # Glasscock County, Texas
"48081",    # Coke County, Texas
"48227",    # Howard County, Texas
"48295",    # Lipscomb County, Texas
"48357",    # Ochiltree County, Texas
"48195",    # Hansford County, Texas
"48421",    # Sherman County, Texas
"48211",    # Hemphill County, Texas
"48393",    # Roberts County, Texas
"48233",    # Hutchinson County, Texas
"48341",    # Moore County, Texas
"48205",    # Hartley County, Texas
"48445",    # Terry County, Texas
"48497",    # Wise County, Texas
"48503",    # Young County, Texas
"48501",    # Yoakum County, Texas
"48499",    # Wood County, Texas
"48437",    # Swisher County, Texas
"48485",    # Wichita County, Texas
"48449",    # Titus County, Texas
"48433",    # Stonewall County, Texas
"48333",    # Mills County, Texas
"48033",    # Borden County, Texas
"48037",    # Bowie County, Texas
"48045",    # Briscoe County, Texas
"48049",    # Brown County, Texas
"48059",    # Callahan County, Texas
"48063",    # Camp County, Texas
"48065",    # Carson County, Texas
"48067",    # Cass County, Texas
"48223",    # Hopkins County, Texas
"48069",    # Castro County, Texas
"48075",    # Childress County, Texas
"48359",    # Oldham County, Texas
"48079",    # Cochran County, Texas
"48083",    # Coleman County, Texas
"48085",    # Collin County, Texas
"48087",    # Collingsworth County, Texas
"48093",    # Comanche County, Texas
"48097",    # Cooke County, Texas
"48101",    # Cottle County, Texas
"48107",    # Crosby County, Texas
"48113",    # Dallas County, Texas
"48119",    # Delta County, Texas
"48159",    # Franklin County, Texas
"48121",    # Denton County, Texas
"48125",    # Dickens County, Texas
"48129",    # Donley County, Texas
"48487",    # Wilbarger County, Texas
"48139",    # Ellis County, Texas
"48143",    # Erath County, Texas
"48147",    # Fannin County, Texas
"48151",    # Fisher County, Texas
"48153",    # Floyd County, Texas
"48155",    # Foard County, Texas
"48169",  # Garza County, Texas
"48483",    # Wheeler County, Texas
"48467",    # Van Zandt County, Texas
"48459",    # Upshur County, Texas
"48179",    # Gray County, Texas
"48181",    # Grayson County, Texas
"48429",    # Stephens County, Texas
"48439",    # Tarrant County, Texas
"48441",    # Taylor County, Texas
"48447",    # Throckmorton County, Texas
"48183",    # Gregg County, Texas
"48353",    # Nolan County, Texas
"48189",    # Hale County, Texas
"48191",    # Hall County, Texas
"48197",    # Hardeman County, Texas
"48423",    # Smith County, Texas
"48231",    # Hunt County, Texas
"48203",    # Harrison County, Texas
"48207",    # Haskell County, Texas
"48219",    # Hockley County, Texas
"48221",    # Hood County, Texas
"48237",    # Jack County, Texas
"48251",    # Johnson County, Texas
"48253",    # Jones County, Texas
"48257",    # Kaufman County, Texas
"48263",    # Kent County, Texas
"48415",    # Scurry County, Texas
"48417",    # Shackelford County, Texas
"48401",    # Rusk County, Texas
"48399",    # Runnels County, Texas
"48397",    # Rockwall County, Texas
"48375",    # Potter County, Texas
"48379",    # Rains County, Texas
"48381",    # Randall County, Texas
"48269",    # King County, Texas
"48275",    # Knox County, Texas
"48277",    # Lamar County, Texas
"48279",    # Lamb County, Texas
"48303",    # Lubbock County, Texas
"48305",    # Lynn County, Texas
"48315",    # Marion County, Texas
"48335",  # Mitchell County, Texas
"48337",    # Montague County, Texas
"48343",    # Morris County, Texas
"48345",    # Motley County, Texas
"48363",    # Palo Pinto County, Texas
"48365",    # Panola County, Texas
"48367",  # Parker County, Texas
"48133", # Eastland County, Texas, 
"48369"),   # Parmer County, Texas 
"DAL", 
        ifelse(geoid %in% c(
"48141",    # El Paso County, Texas
"48003",    # Andrews County, Texas
"48317",    # Martin County, Texas
"48229",    # Hudspeth County, Texas
"48377",    # Presidio County, Texas
"48243",    # Jeff Davis County, Texas
"48109",    # Culberson County, Texas
"48389",    # Reeves County, Texas
"48371",    # Pecos County, Texas
"48043",    # Brewster County, Texas
"48443",    # Terrell County, Texas
"48301",    # Loving County, Texas
"48495",    # Winkler County, Texas
"48135",    # Ector County, Texas
"48329",    # Midland County, Texas
"48475",    # Ward County, Texas
"48103",    # Crane County, Texas
"48461"),   # Upton County, Texas
"ELP", 
        ifelse(geoid %in% c(
"48005",    # Angelina County, Texas
"48007",    # Aransas County, Texas
"48457",    # Tyler County, Texas
"48015",    # Austin County, Texas
"48025",    # Bee County, Texas
"48391",    # Refugio County, Texas
"48339",    # Montgomery County, Texas
"48039",    # Brazoria County, Texas
"48041",    # Brazos County, Texas
"48051",    # Burleson County, Texas
"48047",    # Brooks County, Texas
"48261",    # Kenedy County, Texas
"48057",    # Calhoun County, Texas
"48071",    # Chambers County, Texas
"48089",    # Colorado County, Texas
"48167",    # Galveston County, Texas
"48123",    # DeWitt County, Texas
"48149",    # Fayette County, Texas
"48157",    # Fort Bend County, Texas
"48473",    # Waller County, Texas
"48477",    # Washington County, Texas
"48481",    # Wharton County, Texas
"48469",    # Victoria County, Texas
"48471",    # Walker County, Texas
"48175",    # Goliad County, Texas
"48455",    # Trinity County, Texas
"48185",    # Grimes County, Texas
"48199",    # Hardin County, Texas
"48419",    # Shelby County, Texas
"48287",    # Lee County, Texas
"48201",    # Harris County, Texas
"48361",    # Orange County, Texas
"48225",    # Houston County, Texas
"48239",    # Jackson County, Texas
"48241",    # Jasper County, Texas
"48245",    # Jefferson County, Texas
"48249",    # Jim Wells County, Texas
"48395",    # Robertson County, Texas
"48403",    # Sabine County, Texas
"48405",    # San Augustine County, Texas
"48407",    # San Jacinto County, Texas
"48409",    # San Patricio County, Texas
"48273",    # Kleberg County, Texas
"48285",    # Lavaca County, Texas
"48289",    # Leon County, Texas
"48291",    # Liberty County, Texas
"48297",    # Live Oak County, Texas
"48313",    # Madison County, Texas
"48321",    # Matagorda County, Texas
"48331",    # Milam County, Texas
"48347",    # Nacogdoches County, Texas
"48351",    # Newton County, Texas
"48355",    # Nueces County, Texas
"48373"),   # Polk County, Texas 
"HOU", 
        ifelse(geoid %in% c(
"48307",    # McCulloch County, Texas
"48507",    # Zavala County, Texas 
"48505",    # Zapata County, Texas
"48013",    # Atascosa County, Texas
"48019",    # Bandera County, Texas
"48491",    # Williamson County, Texas
"48021",    # Bastrop County, Texas
"48027",    # Bell County, Texas
"48453",    # Travis County, Texas
"48029",    # Bexar County, Texas
"48031",    # Blanco County, Texas
"48035",    # Bosque County, Texas
"48489",    # Willacy County, Texas
"48061",    # Cameron County, Texas
"48215",    # Hidalgo County, Texas
"48427",    # Starr County, Texas
"48247",    # Jim Hogg County, Texas
"48479",    # Webb County, Texas
"48053",    # Burnet County, Texas
"48055",    # Caldwell County, Texas
"48267",    # Kimble County, Texas
"48493",    # Wilson County, Texas
"48091",    # Comal County, Texas
"48099",    # Coryell County, Texas
"48127",    # Dimmit County, Texas
"48131",    # Duval County, Texas
"48137",    # Edwards County, Texas
"48145",    # Falls County, Texas
"48161",    # Freestone County, Texas
"48163",    # Frio County, Texas
"48463",    # #Uvalde County, Texas
"48465",    # Val Verde County, Texas
"48171",    # Gillespie County, Texas
"48177",    # Gonzales County, Texas
"48187",    # Guadalupe County, Texas
"48425",    # Somervell County, Texas
"48209",    # Hays County, Texas
"48217",    # Hill County, Texas
"48193",    # Hamilton County, Texas
"48271",    # Kinney County, Texas
"48255",    # Karnes County, Texas
"48259",    # Kendall County, Texas
"48265",    # Kerr County, Texas
"48411",    # San Saba County, Texas
"48385",    # Real County, Texas
"48283",    # La Salle County, Texas
"48281",    # Lampasas County, Texas
"48293",    # Limestone County, Texas
"48299",    # Llano County, Texas
"48319",    # Mason County, Texas
"48323",    # Maverick County, Texas
"48309",    # McLennan County, Texas
"48311",    # McMullen County, Texas
"48325"),   # Medina County, Texas
"SNA", 
        ifelse(geoid %in% c("06079", "06083", "06111", "06037", "06059", "06065", "06071"), "LOS", 
        ifelse(geoid %in% c("36005", "36061", "36081", "36047", "36085", "36027", "36059", "36079", "36103", "36105", "36071", "36087", "36111", "36119"), "NYC", 
        ifelse(geoid %in% c("06029", "06015", "06093", "06049", "06023", "06105", "06089", "06035", "06103", "06063", "06045", "06021", "06033", "06011", "06007", "06115", "06057", "06091", "06097", "06055", "06041", "06101", "06113", "06095", "06067", "06061", "06017", "06005", "06009", "06003", "06109", "06051", "06075", "06013", "06001", "06077", "06099", "06043", "06081", "06085", "06047", "06039", "06087", "06053", "06069", "06019", "06031", "06107", "06027"), "SFR", 
        ifelse(geoid %in% c("06073", "06025"), "SND", "Fail"))))))))))))))))))))))))))))

# Check if any estimate fields null
# df_counties %>% 
#  assert(not_na(), estimate)

# Writing out county to AOR mapping
outputfile <- here('analyze', 'output', 'county_aor.csv')
write_csv(df_counties, outputfile)

outputfile <- here('analyze', 'output', 'county_aor.yaml')
write_yaml(select(df_counties, geoid, aor), outputfile, fileEncoding = "UTF-8")

us <- counties(year = 2018, class = "sf")
names(us) <- tolower(names(us))
us <- merge(us, select(df_counties, aor, geoid), by='geoid')

ggplot(us) + 
    geom_sf(aes(fill = aor), color = NA) + 
    coord_sf(xlim = c(-130, -65), ylim = c(24, 51), expand = FALSE) +
    theme_void()

# https://r-spatial.github.io/sf/articles/sf4.html
# https://crd150.github.io/lab4.html