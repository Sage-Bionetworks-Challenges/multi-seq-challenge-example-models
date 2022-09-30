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
# Do not use more than 20 cores - it might slow down the performance
ncores <- parallelly::availableCores()
message("I am using ", ncores, " cores ...")

# Load your model
source("/imputation_model.R")

# Read the basename of all downsampled data
basenames <- read.table(file.path(input_dir, "scrna_input_basenames.txt"), header = FALSE)[, 1]

# Add ".csv" extension to create input filenames 
input_filenames <- paste0(basenames, ".csv")
# Add "_imputed" to create prediction/output filenames
output_filenames <- paste0(basenames, "_imputed.csv")

# Iterate to impute all input files - if your model requires lots of memory:
# consider to split input files into smaller chunks or use 'for' loop instead
# your submission will fail if it goes beyond max memory (160g)
parallel::mclapply(seq_along(input_filenames), function(i) {
  message("Imputing ", input_filenames[i], " ...")
  # read input data
  input_path <- file.path(input_dir, input_filenames[i])
  input_data <- data.table::fread(input_path, data.table = TRUE)
  input_data <- tibble::column_to_rownames(input_data, "V1")
  
  # apply your model for imputation
  pred_data <- imputation_model(input_data)

  # write out the imputed data
  data.table::fwrite(
    data.table::as.data.table(pred_data, keep.rownames = ""),
    file.path(output_dir, output_filenames[i])
  )
}, mc.cores = ncores)

# compress all predictions into a compressed tarball
# use pigz for parallel compression
system(sprintf("tar -I pigz -cvf %s/predictions.tar.gz %s/*_imputed.csv", output_dir, output_dir))