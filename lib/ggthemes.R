theme_title = function(...) theme(plot.title = element_text(face="bold", size=10, ...))
theme_benchmark = function(...) {
  theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), ...)
}