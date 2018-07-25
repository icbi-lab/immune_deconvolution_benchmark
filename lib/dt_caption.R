#' insert a caption for a DT::datatable in bookdown
#'
#' see also https://github.com/rstudio/bookdown/issues/313
#'
#' @param caption table caption to display.
dt_caption = function(caption) {
  cat("<table>",paste0("<caption>", "(#tab:mytab)", caption,  "</caption>"),"</table>", sep ="\n")
}
