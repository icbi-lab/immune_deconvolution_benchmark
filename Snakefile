from snakemake.remote.HTTP import RemoteProvider as HTTPRemoteProvider
HTTP = HTTPRemoteProvider()

RMD_FILES, = glob_wildcards("notebooks/pipeline/{rmd_files}.Rmd")

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
    expand("notebooks/pipeline/{rmd_files}.Rmd", rmd_files = RMD_FILES),
    "notebooks/pipeline/bibliography.bib",
    "_bookdown.yml",
    "_output.yml"
  output:
    "results/book/index.html"
  conda:
    "envs/bookdown.yml"
  shell:
    "Rscript -e \"bookdown::render_book('notebooks/pipeline/index.Rmd')\""


rule data:
   """download data from archive"""
   input:
     # TODO change to github once published
     HTTP.remote("www.cip.ifi.lmu.de/~sturmg/data.tar.gz", allow_redirects=True)
   output:
     DATA_FILES
   shell:
     "mkdir -p data && "
     "tar -xvzf {input} -C data --strip-components 1"


rule upload_book:
  """publish the book on github pages"""
  input:
    "results/book/index.html"
    "results/figures/spillover_migration_all.pdf"
  shell:
    """
    cp results/figures/spillover_migration_all.pdf gh-pages/files
    cd gh-pages && \
    cp -R ../results/book/* ./ && \
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
    rm -rfv results/book/*
    rm -rfv notebooks/pipeline/_bookdown_files/*files
    rm -fv notebooks/pipeline/_main*
    rm -fv results/figures/*
    """)


def _wipe():
  clean()
  shell(
    """
    rm -rfv notebooks/pipeline/_bookdown_files
    rm -rfv results/tables/*
    """)

