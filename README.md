# Benchmarking methods for estimating immune cell abundance from bulk RNA-sequencing data

Sturm, G. and Aneichyk T. *Manuscript in preparation.*

The source code in this project can be used to reproduce our results and to use our pipeline for testing additional methods.

## Getting started

### Prerequisites
This pipeline uses [Anaconda](https://conda.io/miniconda.html) and
[Snakemake](https://snakemake.readthedocs.io/en/stable/).

1. **Download and install [Miniconda](https://conda.io/miniconda.html)**
2. **Install snakemake**
```
conda install snakemake
```

3. **Clone this repo.** We use a [git submodule](https://git-scm.com/docs/git-submodule) to import
the source code for the [immundeconv](https://github.com/grst/immunedeconv) R package.
```
git clone --recurse-submodules git@github.com:grst/immune_deconvolution_benchmark.git
```

If you have problems retrieving the submodule, read this [question on
stackoverflow](https://stackoverflow.com/questions/3796927/how-to-git-clone-including-submodules).


### CIBERSORT
Due to licensing restrictions, CIBERSORT could not be included in this repo.
You have to got to the [CIBERSORT website](https://cibersort.stanford.edu),
obtain a license and download the source code.

Place the files `CIBERSORT.R` and `LM22.txt` in the
```
libs/CIBERSORT/
```
folder of this repository.


### Run the pipeline
To perform all computations and to generate a HTML report with [bookdown](https://bookdown.org/yihui/bookdown/) invoke
the corresponding `Snakemake` target:

```
snakemake --use-conda book
```

Make sure to use the `--use-conda` flag to tell Snakemake to download all dependencies from Anaconda.org.


## Test your own method [TODO]

Our pipeline is designed in a way that you can easily test your own method and benchmark it against the
state-of-the-art. All you have to do is to write an `R` function within the `immunedeconv` package that calls your
method.

Here we demonstrate how to implement and test a method step-by-step using a nonsense random predictor.

1. The sourcecode of the `immunedeconv` package is located in `./immunedeconv`. The pipeline always loads this package from the source code there.

Note that you can use `system()` to call an arbitrary command line tool.

2. Test if your method works by running the `immunedeconv` unit tests
```
snakemake --use-conda test_immunedeconv
```

3. Run the pipeline
```bash
snakemake wipe   # use this command to clear up previous results and to eradicate the cache
snakemake --use-conda book
```
