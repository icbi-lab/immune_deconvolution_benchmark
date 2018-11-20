config = new.env()

registerDoMC(min(detectCores(), 16))

# path to CIBERSORT script and matrix.
config$cibersort_binary = "../lib/CIBERSORT/CIBERSORT.R"
config$cibersort_mat = "../lib/CIBERSORT/LM22.txt"

############## Specify methods used in the benchmark ##################

# these methods will be used in the benchmark. Default: Use all methods
# provided by the `immundeconv` package.
config$deconvolution_methods = immunedeconv::deconvolution_methods

# these methods will be treated as 'absolute' methods in the mixing benchmark
config$abs_methods_mixing = c("cibersort_abs", "epic", "quantiseq", "xcell")

# these methods will be shown as 'absolute' methods in the validation benchmark
config$abs_methods_validation = c("cibersort_abs", "quantiseq", "epic")

# these methods provide scores that support within-sample comparisons
config$methods_within_sample_comparison = c("cibersort", "cibersort_abs", "quantiseq", "epic")


############# Exclude CIBERSORT if unavailable ########################
if(!file.exists(config$cibersort_binary) || !file.exists(config$cibersort_mat)) {
  exclude_cibersort = function(method_list) {
    method_list[!method_list %in% c("cibersort", "cibersort_abs")]
  }
  # exclude cibersort from the analysis
  config$deconvolution_methods = exclude_cibersort(config$deconvolution_methods)
  config$abs_methods_mixing = exclude_cibersort(config$abs_methods_mixing)
  config$abs_methods_validation = exclude_cibersort(config$abs_methods_validation)
} else {
  # set path to CIBERSORT script
  set_cibersort_binary(config$cibersort_binary)
  set_cibersort_mat(config$cibersort_mat)
}


############# Expected cell types for xCell #########################
# xCell performance can be improved by reducing the
# number of signatures considered. (https://github.com/grst/immunedeconv/issues/1).
# Arguably, many of the xCell signatures do not make sense in
# the context of this benchmark, therefore we limit the signatures
# to the cell types available in the immune datasets.

EXPECTED_CELL_TYPES_SC = c("B cell", "Cancer associated fibroblast", "Dendritic cell",
                           "Endothelial cell", "Macrophage/Monocyte", "NK cell",
                           "T cell CD4+ (non-regulatory)", "T cell CD8+",
                           "T cell regulatory (Tregs)")

EXPECTED_CELL_TYPES_FACS = c("B cell", "Dendritic cell", "Monocyte", "NK cell",
                           "T cell CD4+", "T cell CD8+", "T cell")

