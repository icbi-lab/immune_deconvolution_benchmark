config = new.env()

registerDoMC(detectCores(logical=FALSE))

set_cibersort_binary("../lib/CIBERSORT/CIBERSORT.R")
set_cibersort_mat("../lib/CIBERSORT/LM22.txt")

# these methods will be treated as 'absolute' methods in the mixing benchmark
config$abs_methods_mixing = c("cibersort_abs", "epic", "quantiseq", "xcell", "random")

# these methods will be shown as 'absolute' methods in the publication-ready figures
config$abs_methods_final = c("quantiseq", "epic", "random")
