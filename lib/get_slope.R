#' Get slope of the linear model true vs. estimated cell fractions. 
get_slope = function(df) {
  fit = lm(estimate~true_fraction, data=df)
  conf_int = confint(fit, "true_fraction", level=0.95)
  data.frame(
    slope = fit$coefficients[2],
    ci_lower = conf_int[1],
    ci_upper = conf_int[2]
  )
}