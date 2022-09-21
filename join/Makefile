# Authors:     PN
# Maintainers: PN
# Copyright:   2022, UWCHR, GPL v2 or later
# =========================================
# ice-facilities/join/Makefile

.PHONY: all clean

all: output/facilities.csv.gz

clean: 
		-rm -r output/*

output/facilities.csv.gz: \
		src/join.R \
		input/facil-list.csv.gz \
		hand/new_facilities.csv
	Rscript $< \
		--input=input/facil-list.csv.gz \
		--to_join=hand/new_facilities.csv \
		--logfile=output/join.log \
		--output=$@
		
# done.
