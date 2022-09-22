#!/bin/bash
export INPUT_DIR=$1
export OUPUT_DIR=$2
export INPUT=scatac_input_basenames.txt
export NCORES=10 # don't use more than 10 cores

[ ! -f $INPUT_DIR/$INPUT ] && { echo "$INPUT_DIR/$INPUT file not found"; exit 99; }
mkdir -p $OUPUT_DIR

cat $INPUT_DIR/$INPUT | parallel --max-procs=$NCORES --halt-on-error 2 \
  'macs2 callpeak --keep-dup all -t $INPUT_DIR/{}.bam --nomodel --shift 100 --extsize 200 -n {} --outdir $OUPUT_DIR'

tar cvzf $OUPUT_DIR/predictions.tar.gz $OUPUT_DIR/*_peaks.narrowPeak