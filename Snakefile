from snakemake.remote.HTTP import RemoteProvider as HTTPRemoteProvider
HTTP = HTTPRemoteProvider()

RMD_FILES, = glob_wildcards("notebooks/{rmd_files}.Rmd")

# declare all input files here
DATA_FILES = [
    "data/ensemble_hgnc.txt",
    "data/immune_cell_reference/immune_cell_reference_tidy.tsv",
    "data/schelker/ascites_bulk_samples.xls",
    "data/schelker/single_cell_schelker.rda",
    "data/schelker/ascites_facs.xlsx",
    "data/racle/GSE93722_RAW/GSM2461007_LAU1255.genes.results.txt",
    "data/racle/GSE93722_RAW/GSM2461009_LAU1314.genes.results.txt",
    "data/racle/GSE93722_RAW/GSM2461005_LAU355.genes.results.txt",
    "data/racle/GSE93722_RAW/GSM2461003_LAU125.genes.results.txt",
    "data/racle/racle2017_flow_cytometry.xlsx",
    "data/hoeck/HoekPBMC_mixture.RData",
    "data/hoeck/HoekPBMC_gtruth.RData"
]


rule book:
  """build book using R bookdown"""
  input:
    # data
    DATA_FILES,
    # content (Rmd files and related stuff)
    expand("notebooks/{rmd_files}.Rmd", rmd_files = RMD_FILES),
    "notebooks/bibliography.bib",
    "notebooks/_bookdown.yml",
    "notebooks/_output.yml"
  output:
    "_book/index.html"
  conda:
    "envs/bookdown.yml"
  shell:
    "cd notebooks && Rscript -e \"bookdown::render_book('index.Rmd')\""


rule data:
   """download data from archive"""
   input:
     # TODO change to github once published
     HTTP.remote("www.dropbox.com/sh/n3go6ymkp5txz4u/AACfv_a1jQcrJieECAlavufQa?dl=1", keep_local=True, allow_redirects=True)
   output:
     DATA_FILES
   shell:
     "tar xvzf data.tar.gz"


rule upload_book:
  """publish the book on github pages"""
  input:
    "_book/index.html"
    "results/figures/spillover_migration_all.pdf"
  shell:
    """
    cp results/figures/spillover_migration_all.pdf gh-pages/files
    cd gh-pages && \
    cp -R ../_book* ./ && \
    git add --all * && \
    git commit --allow-empty -m "update docs" && \
    git push github gh-pages
    """


rule clean:
  """remove all output files. """
  run:
    _clean()


rule wipe:
  """remove all output files, including bookdown-cache"""
  run:
    _wipe()


rule _data_archive:
    """
    FOR DEVELOPMENT ONLY.

    Generate a data.tar.gz archive from data.in to publish on github.
    """
    input:
      "data.in"
    output:
      "results/data.tar.gz"
    shell:
      "tar cvzf {output} data.in"


def _clean():
  shell(
    """
    rm -rfv _book/*
    rm -rfv notebooks/_bookdown_files/*files
    rm -fv notebooks/_main*
    rm -fv results/figures/*
    """)


def _wipe():
  clean()
  shell(
    """
    rm -rfv notebooks/_bookdown_files
    rm -rfv results/tables/*
    """)

