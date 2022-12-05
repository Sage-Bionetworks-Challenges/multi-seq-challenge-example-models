#!/usr/bin/env python

import argparse
from imputation_model import imputation_model
from multiprocessing import Pool
import os
import glob
import random


def get_args():
    """Set up command-line interface and get arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input_dir", type=str, required=True)
    parser.add_argument("-o", "--output_dir", type=str, required=True)
    return parser.parse_args()


def list_split(large_list, chunk_size, shuffle=False):
    """Split large list into smaller chunks."""
    if shuffle:
        random.shuffle(large_list)
    for i in range(0, len(large_list), chunk_size):
        yield large_list[i:i + chunk_size]


def get_filenames(input_dir, pattern="*.csv"):
    """Retrieve filenames without extensions of all downsampled files."""
    input_files = [os.path.basename(x) for x in glob.glob(
        os.path.join(input_dir, pattern))]
    # get filenames without extensions
    filenames = [os.path.splitext(f)[0] for f in input_files]

    return filenames


def main():
    """Main function."""
    args = get_args()
    input_dir = args.input_dir
    output_dir = args.output_dir
    # be careful not to exceed memory limit (160g)
    nworkers = 10  # used to impute files in parallel
    ncores = 4  # used to run model on single file

    # get filenames without extensions
    filenames = get_filenames(input_dir, "*.csv")
    # if needed, split into smaller chunks to reduce memory usage
    # split_filenames = list_split(filenames, 40, shuffle=True)
    # and then iterate each chunk of filenames, but we don't need in this model

    # set input and output file paths
    input_paths = [f"{input_dir}/{b}.csv" for b in filenames]
    output_paths = [f"{output_dir}/{b}_imputed.csv" for b in filenames]

    model_inputs = zip(input_paths, output_paths, len(filenames)*[int(ncores)])

    # run model in parallel
    with Pool(processes=int(nworkers)) as pool:
        pool.map(imputation_model, model_inputs)


if __name__ == "__main__":
    main()
