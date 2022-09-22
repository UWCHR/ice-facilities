#
# :author: PN
# :date: 2020-02-14
# :license: GPL 2.0 or greater
#
# ice-facilities/clean/src/Makefile
#
#

.PHONY: clean all

all: \
	output/facil-list.csv.gz
# 	output/dmcp-detailed.csv.gz

clean: 
	rm -r output/*
	
output/facil-list.csv.gz: \
	src/clean.py \
	input/ICEFacilityListReport.csv.gz \
	hand/clean_rules.yaml
	python $< \
		--input=input/ICEFacilityListReport.csv.gz \
		--cleanrules=hand/clean_rules.yaml \
		--header=8 \
		--output=$@

# output/dmcp-detailed.csv.gz: \
# 	src/clean.py \
# 	input/ICEFacilityListAuthorizedDMCPDetailed.csv.gz \
# 	hand/clean_rules.yaml
# 	python $< \
# 		--input=input/ICEFacilityListAuthorizedDMCPDetailed.csv.gz \
# 		--cleanrules=hand/clean_rules.yaml \
# 		--header=7 \
# 		--output=$@
# End.