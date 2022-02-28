# Authors:     PN
# Maintainers: PN
# Copyright:   2022, UWCHR, GPL v2 or later
# =========================================
# ice-facilities/join/Makefile

.PHONY: all clean

all: output/facilities.csv

clean: 
		-rm -r output/*

output/facilities.csv: \
		src/join.R
	Rscript \
        --vanilla $< \
		--output=$@
		
# done.
