# Analysis of ICE detention facilities characteristics

This repository minimally processes and selects data from ICE detention facility characteristics spreadsheet obtained via FOIA NIJC 2017; and joins this to a table of UWCHR-researched facility characteristics for facilities not included in NIJC 2017.

## Sources for ice-facilities characteristics

Data in ice-facilities/hand/to_research.csv, which is a file containing information for "new" detention facilities (in use from 2017), comes from:

- For `aor` (Area of Responsiblity) column: 
  - [ICE Dentention Facilities website](https://www.ice.gov/detention-facilities)
  - [ACLU's "Justice-Free Zones" report](https://www.aclu.org/report/justice-free-zones-us-immigration-detention-under-trump-administration), Appendix p. 60-61
- For addresses columns (`address`, `city`, `state`, `zip`), and some observations' `contract`, `type_detailed`, and `guaranteed_minimum`:
  - [TRAC Immigration](https://trac.syr.edu/immigration/detentionstats/facilities.html)
- More on `guaranteed_minimum`:
  - [DHS US Immigration and Customs Enforcement Budget Overview](https://www.dhs.gov/sites/default/files/publications/19_0318_MGMT_CBJ-Immigration-Customs-Enforcement_0.pdf), p. 145
- For `county` column: Google results based on detailed address
- For `circuit` column: 
  - [SCOTUS Circuit Assignments](https://www.supremecourt.gov/about/circuitassignments.aspx)
- For `over_72` column: 
  - [ICE Detention Statistics - Over-72-Hour Facilities](https://www.ice.gov/doclib/detention/Over72HourFacilities.xlsx)
- Most columns and info from other sources were taken from and compared with:
  - [ICE Detention Statistics - FY21_detentionStats07082021.xlsx](https://github.com/UWCHR/ice-facilities/import/input/FY21_detentionStats07082021.xlsx)
