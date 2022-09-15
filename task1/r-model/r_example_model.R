#!/usr/bin/env Rscript
suppressMessages(library("data.table"))
suppressMessages(library("tibble"))

# Read arguments
args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]

# Set cores if needed - using more than provided 20 cores might slow down the performance
ncores <- 20

# Read the basename of all downsampled data
basenames <- read.table(file.path(args[1], "scrna_input_basenames.txt"), header = FALSE)[, 1]

# Add ".csv" extension to create input filenames
input_filenames <- paste0(basenames, ".csv")
# Add "_imputed" to create prediction/output filenames
output_filenames <- paste0(basenames, "_imputed.csv")

# Iterate to impute all input files
for (i in seq_along(input_filenames)) {
  # read input data
  input_path <- file.path(input_dir, input_filenames[i])
  input_data <- data.table::fread(input_path, data.table = TRUE) %>% tibble::column_to_rownames("V1")

  # apply your model for imputation
  pred_data <- input_data * runif(1, 0, 1)

  # write out the imputed data
  data.table::fwrite(
    data.table::as.data.table(pred_data, keep.rownames = ""),
    file.path(output_dir, output_filenames[i])
  )
}

# Compress all predictions into a compressed tarball using pigz
system(sprintf("tar -I pigz -cvf %s/predictions.tar.gz %s/*_imputed.csv", output_dir, output_dir))