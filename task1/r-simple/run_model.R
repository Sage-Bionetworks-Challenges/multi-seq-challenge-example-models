#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library("data.table")
  library("tibble")
  library("parallel")
  library("parallelly")
})

# Read arguments
args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]

# Set cores if needed
# Use parallel::detectCores() will not respect cgroups, cpus in the docker
# You could use parallelly::availableCores() instead,
# but suggest to manually set the number of cores
# Do not use more than 20 cores - it might slow down the performance
# ncores <- parallelly::availableCores()
ncores <- 20

# Load your model
source("/imputation_model.R")

# Get input files
input_filenames <- list.files(input_dir, pattern = "*.csv")
# Retrieve the filenames without ext of all downsampled data
filenames <- tools::file_path_sans_ext(input_filenames)
# Add "_imputed" to create prediction/output filenames
output_filenames <- paste0(filenames, "_imputed.csv")

# Iterate to impute all input files - if your model requires lots of memory:
# consider to split input files into smaller chunks or use 'for' loop instead
# your submission will fail if it goes beyond max memory (160g)
res <- parallel::mclapply(seq_along(input_filenames), function(i) {
  # read input data
  input_path <- file.path(input_dir, input_filenames[i])
  input_data <- data.table::fread(input_path, data.table = TRUE)
  input_data <- tibble::column_to_rownames(input_data, "V1")
  # apply your model for imputation
  pred_data <- imputation_model(input_data)

  # # write out the imputed data
  data.table::fwrite(
    data.table::as.data.table(pred_data, keep.rownames = ""),
    file.path(output_dir, output_filenames[i])
  )
}, mc.cores = ncores)
