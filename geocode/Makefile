# vim: set ts=4 softtabstop=0 expandtab sw=4 si fileencoding=utf-8:
#
# Authors:     TS
# Maintainers: TS
# Copyright:   2024, HRDAG, GPL v2 or later
# =========================================
# ice-facilities/geocode/Makefile

proot := $(shell git rev-parse --show-toplevel)
input := $(proot)/geocode/input/facilities.csv.gz

.PHONY: all clean

all: output/facilities.csv.gz

clean: 
		-rm -r output/*

output/facilities.csv.gz: \
		src/geo.R \
		$(input)
	Rscript $< \
		--input=$(input) \
		--output=$@
		
# done.
