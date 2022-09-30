#!/usr/bin/env python

import argparse
from imputation_model import imputation_model
from multiprocessing import Pool
import os
import random


def get_args():
    """Set up command-line interface and get arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input_dir", type=str, required=True)
    parser.add_argument("-o", "--output_dir", type=str, required=True)
    return parser.parse_args()


def read_basenames(txt_path):
    """Read basenames of all downsampled files."""
    with open(txt_path, "r") as txt_file:
        basenames = txt_file.read().splitlines()
        return basenames


def main():
    """Main function."""
    args = get_args()
    input_dir = args.input_dir
    output_dir = args.output_dir
    # be careful not to exceed memory limit (160g)
    nworkers = 10
    ncores = 6

    basenames_path = os.path.join(input_dir, "scrna_input_basenames.txt")
    basenames = read_basenames(basenames_path)
    # random shuffle the files to avoid grouping large files together in the same iteration
    random.shuffle(basenames)
    input_paths = [f"{input_dir}/{b}.csv" for b in basenames]
    output_paths = [f"{output_dir}/{b}_imputed.csv" for b in basenames]

    model_inputs = zip(input_paths, output_paths, len(basenames)*[int(ncores)])

    # run model in parallel
    with Pool(processes=int(nworkers)) as pool:
        pool.map(imputation_model, model_inputs)

    # compress all predictions into a compressed tarball
    # use pigz for parallel compression
    os.system(
        f"tar -I pigz -cvf {output_dir}/predictions.tar.gz {output_dir}/*_imputed.csv")


if __name__ == "__main__":
    main()