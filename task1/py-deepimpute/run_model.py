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


def set_batches(orig_list, batch_size, shuffle=False):
    """Split large list into smaller batches."""
    if shuffle:
        random.shuffle(orig_list)
    for i in range(0, len(orig_list), batch_size):
        yield orig_list[i:i + batch_size]


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
    # be careful not to exceed memory limit (240g)
    nworkers = 30  # used to impute files in parallel
    ncores = 6  # used to run model on single file

    # get filenames without extensions
    filenames = get_filenames(input_dir, "*.csv")
    # if needed, split into smaller batches to reduce memory usage
    batches = set_batches(filenames, 30, shuffle=True)

    # set input and output file paths
    for batch in batches:
        input_paths = [f"{input_dir}/{b}.csv" for b in batch]
        output_paths = [f"{output_dir}/{b}_imputed.csv" for b in batch]

        model_inputs = zip(input_paths, output_paths,
                           len(filenames)*[int(ncores)])

        # run model in parallel
        with Pool(processes=int(nworkers)) as pool:
            pool.map(imputation_model, model_inputs)


if __name__ == "__main__":
    main()
