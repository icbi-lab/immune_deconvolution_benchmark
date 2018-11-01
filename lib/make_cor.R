#' make correlations from a grouped dataframe
make_cor = function(col1, col2) {
  test_res = cor.test(col1, col2, method="pearson")
  data.frame(
    pearson=test_res$estimate,
    conf_int_lower=test_res$conf.int[1],
    conf_int_upper=test_res$conf.int[2],
    p_value=test_res$p.value,
    p_signif=symnum(test_res$p.value, corr = FALSE, na = NA,
                    cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1), symbols = c("****", "***", "**", "*", "ns"))
  )
}