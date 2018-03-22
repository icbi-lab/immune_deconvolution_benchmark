R=R
RMD_FILES= $(wildcard notebooks/*.Rmd)
PREVIEW_FILES = $(patsubst %,%.preview,$(RMD_FILES))
SHELL= /bin/bash
CWD= $(shell pwd)

####################################
# Render Rmarkdown documents
####################################

.PHONY: book
book: $(RMD_FILES)
	cd notebooks && Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

.PHONY: upload-book
upload-book: book
	cd gh-pages && cp -R ../_book/* ./ && git add --all * && git commit --allow-empty -m "update docs" && git push github gh-pages

# render a chapter only by calling `make chapter1.Rmd.preview`
.PHONY: $(PREVIEW_FILES)
	$(PREVIEW_FILES): %.Rmd.preview: %.Rmd
	Rscript -e "bookdown::preview_chapter('$<', 'bookdown::gitbook')"

.PHONY: clean
clean:
	rm -rfv _book/*
	rm -rfv notebooks/_bookdown_files/*_files
	rm -fv notebooks/_main*

.PHONY: wipe
wipe: clean
	rm -rfv _bookdown_files


####################################
# Data acquisition
####################################

data:
	mkdir -p data
	cd data && wget http://fantom.gsc.riken.jp/5/datafiles/latest/extra/CAGE_peaks/hg19.cage_peak_phase1and2combined_tpm_ann.osc.txt.gz

