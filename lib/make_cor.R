#' make correlations from a grouped dataframe
make_cor = function(col1, col2) {
  test_res = cor.test(col1, col2, method="pearson")
  data.frame(
    pearson=test_res$estimate,
    conf_int_lower=test_res$conf.int[1],
    conf_int_upper=test_res$conf.int[2]
  )
}