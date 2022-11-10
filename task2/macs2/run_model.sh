#!/bin/bash
export INPUT_DIR=$1
export OUPUT_DIR=$2
export NCORES=10 # don't use more than 10 cores

mkdir -p $OUPUT_DIR

# 1. run macs2 on each downsampled bam
# 2. rename _summits.bed to .bed
ls $INPUT_DIR/*.bam | parallel --max-procs=$NCORES --halt-on-error 2 \
  'macs2 callpeak --keep-dup all -t $INPUT_DIR/{}.bam --nomodel --shift 100 --extsize 200 -n {} --outdir $OUPUT_DIR &&
   mv $OUPUT_DIR/{}_summits.bed $OUPUT_DIR/{}.bed'

tar -I pigz -cvf $OUPUT_DIR/predictions.tar.gz $OUPUT_DIR/*.bed