#
# :author: PN
# :date: 2020-02-14
# :license: GPL 2.0 or greater
#
# ice-facilities/clean/src/Makefile
#
#

all: \
	output/facil-list.csv.gz 
	
PHONY: all

output/facil-list.csv.gz: \
	src/clean.py \
	input/ICEFacilityListReport.csv.gz
	python $< \
		--input=input/ICEFacilityListReport.csv.gz \
		--cleanrules=hand/clean_rules.yaml \
		--output=$@

# End.