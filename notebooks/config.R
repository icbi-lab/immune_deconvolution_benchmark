config = new.env()

registerDoMC(min(detectCores(), 16))

# path to CIBERSORT script and matrix.
config$cibersort_binary = "../lib/CIBERSORT/CIBERSORT.R"
config$cibersort_mat = "../lib/CIBERSORT/LM22.txt"

if(!file.exists(config$cibersort_binary) || !file.exists(config$cibersort_mat)) {
  # exclude cibersort from the analysis
  config$deconvolution_methods = immunedeconv::deconvolution_methods[!immunedeconv::deconvolution_methods %in%
                                                                     c("cibersort", "cibersort_abs")]

  # these methods will be treated as 'absolute' methods in the mixing benchmark
  config$abs_methods_mixing = c("epic", "quantiseq", "xcell", "random")

  # these methods will be shown as 'absolute' methods in the publication-ready figures
  config$abs_methods_final = c("quantiseq", "epic", "random")

} else {
  # set path to CIBERSORT script
  set_cibersort_binary(config$cibersort_binary)
  set_cibersort_mat(config$cibersort_mat)

  config$deconvolution_methods = immunedeconv::deconvolution_methods

  # these methods will be treated as 'absolute' methods in the mixing benchmark
  config$abs_methods_mixing = c("cibersort_abs", "epic", "quantiseq", "xcell")

  # these methods will be shown as 'absolute' methods in the publication-ready figures
  config$abs_methods_final = c("quantiseq", "epic")
}
