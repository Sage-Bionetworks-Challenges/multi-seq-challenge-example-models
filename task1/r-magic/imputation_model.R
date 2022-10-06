imputation_model <- function(input_data) {

  # here is just an example, please change to use your own model

  # remove 0 genes and cells, otherwise MAGIC will complain
  input_data <- input_data[rowSums(input_data) > 0, colSums(input_data) > 0]
  # save cell names
  cells <- colnames(input_data)

  # reformat data for MAGIC
  magic_data <- input_data %>%
    t() %>%
    as.data.frame() %>%
    tibble::remove_rownames()
  # normalize data
  norm_data <- library.size.normalize(magic_data)
  norm_data <- sqrt(norm_data)
  # run MAGIC with default settings
  pred_data <- magic(norm_data, seed = 1234, verbose = FALSE)
  # convert back to origin count format
  pred_data <- pred_data$result %>%
    t() %>%
    as.data.frame() %>%
    setNames(cells)

  return(pred_data)
}
