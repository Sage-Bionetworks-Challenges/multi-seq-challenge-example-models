imputation_model <- function(input_data) {
  # here is just an example, please change to use your own model
  pred_data <- input_data * runif(10, 0, 1)
  return(pred_data)
}