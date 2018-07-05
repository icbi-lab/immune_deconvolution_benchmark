R=R
RMD_FILES= $(wildcard notebooks/*.Rmd)
PREVIEW_FILES = $(patsubst %,%.preview,$(RMD_FILES))
SHELL= /bin/bash
CWD= $(shell pwd)


help:
	@echo "The following commands are available:"
	@echo "    book              render all Rmarkdown documents to a gitbook (bookdown)"
	@echo "    upload-book       publish book on github-pages"
	@echo "    <file>.Rmd.preview     only render a single Rmd file as preview (bookdown)"
	@echo "    clean             clean bookdown results"
	@echo "    wipe              clean + erase cache"


####################################
# Render Rmarkdown documents
####################################

.PHONY: book
book: $(RMD_FILES)
	cd notebooks && Rscript -e "bookdown::render_book('index.Rmd')"

.PHONY: upload-book
upload-book: book
	cp ./tables/summary.xlsx gh-pages/files
	cp ./results/figures/spillover_migration_all.pdf gh-pages/files
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
	rm -fv results/figures/*

.PHONY: wipe
wipe: clean
	rm -rfv notebooks/_bookdown_files
	rm -rfv results/tables/*


