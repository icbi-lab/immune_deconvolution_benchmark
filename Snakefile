RMD_FILES, = glob_wildcards("notebooks/{rmd_files}.Rmd")

def clean():
  shell(
    """
    rm -rfv _book/*
    rm -rfv notebooks/_bookdown_files/*files
    rm -fv notebooks/_main*
    rm -fv results/figures/*
    """)

def wipe():
  clean()
  shell(
    """
    rm -rfv notebooks/_bookdown_files
    rm -rfv results/tables/*
    """)

rule book:
  """build book using R bookdown"""
  input:
    expand("notebooks/{rmd_files}.Rmd", rmd_files = RMD_FILES),
    "notebooks/bibliography.bib",
    "notebooks/_bookdown.yml"
    "notebooks/_output.yml"
  output:
    "_book/index.html"
  conda:
    "envs/bookdown.yml"
  shell:
    "cd notebooks && Rscript -e \"bookdown::render_book('index.Rmd')\""

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
    clean()

rule wipe:
  """remove all output files, including bookdown-cache"""
  run:
    wipe()

