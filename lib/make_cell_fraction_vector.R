#' Make a cell fraction vector from single cell data with one specific cell type.
#' 
#' It is possible to add background cells (i.e. unrelated cells)
#' 
#' @param input_cell_type cell_type for the immune cell to use
#' @param n number of immune cells to use in the sample
#' @param background named vector giving cell counts of background cells. use `NULL` to exclude background cells. 
make_cell_fraction_vector = function(input_cell_type, n, background=cell_types$background_cells) {
  if(input_cell_type == "T cell CD4+") {
    # combine regulatory and non-regulatory CD4+ T cells
    cell_type_stats = pData(single_cell_schelker$eset) %>% 
      group_by(cell_type) %>% 
      count() %>% 
      as.data.frame() %>% 
      column_to_rownames("cell_type")
    ratio = cell_type_stats["T cell regulatory (Tregs)", "n"]/cell_type_stats["T cell CD4+ (non-regulatory)", "n"]
    cell_n =  c(background, round(n*(1-ratio)), round(n*ratio))
    names(cell_n) = c(names(background), "T cell CD4+ (non-regulatory)", "T cell regulatory (Tregs)")
  } else {
    cell_n =  c(background, n)
    names(cell_n) = c(names(background), input_cell_type)
  }
  cell_n
}