#!/usr/bin/env Rscript
Sys.setenv("RETICULATE_MINICONDA_ENABLED" = FALSE)
suppressPackageStartupMessages({
  library("data.table")
  library("tibble")
  library("Rmagic")
})

# Read arguments
args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]

# Set cores if needed
# Do not use more than 30 cores - it might slow down the performance
ncores <- 30

# Load your model
source("/imputation_model.R")

# Get input files
input_filenames <- list.files(input_dir, pattern = "*.csv")
# Retrieve the filenames without ext of all downsampled data
filenames <- tools::file_path_sans_ext(input_filenames)
# Add "_imputed" to create prediction/output filenames
output_filenames <- paste0(filenames, "_imputed.csv")

# split into smaller chunks (index) to reduce memory usage
set.seed(1234)
chunks <- split(
  sample(seq_along(input_filenames)),
  cut(seq_along(input_filenames), 3, labels = FALSE)
)

for (c in chunks) {
  parallel::mclapply(c, function(i) {
    # read input data
    input_path <- file.path(input_dir, input_filenames[i])
    input_data <- data.table::fread(input_path, data.table = FALSE)
    input_data <- tibble::column_to_rownames(input_data, "V1")

    # apply your model for imputation
    pred_data <- imputation_model(input_data)

    # write out the imputed data
    data.table::fwrite(
      data.table::as.data.table(pred_data, keep.rownames = ""),
      file.path(output_dir, output_filenames[i])
    )
  }, mc.cores = ncores)
}
