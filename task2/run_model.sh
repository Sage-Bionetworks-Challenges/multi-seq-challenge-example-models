#!/bin/bash
export INPUT_DIR=$1
export OUPUT_DIR=$2
export INPUT=scatac_input_basenames.txt
export NCORES=4

[ ! -f $INPUT_DIR/$INPUT ] && { echo "$INPUT_DIR/$INPUT file not found"; exit 99; }
mkdir -p $OUPUT_DIR

cat $INPUT_DIR/$INPUT | parallel --max-procs=$NCORES -d "\r\n" --halt-on-error 2 \
  'macs2 callpeak --keep-dup all -t $INPUT_DIR/{}.bam -n {} --outdir $OUPUT_DIR'

tar cvzf $OUPUT_DIR/predictions.tar.gz $OUPUT_DIR/*_peaks.narrowPeak