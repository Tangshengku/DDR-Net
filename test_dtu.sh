#!/usr/bin/env bash
TESTPATH="../DTUdataset/dtu"
TESTLIST="lists/dtu/test.txt"
root_path='/home/tsk/cas_clamp/outputs/'
target_path='/home/tsk/cas_clamp/pointoutput/'
CKPT_FILE=$'checkpoints/DDR-Net.ckpt'
python test_dtu.py --dataset=general_eval --batch_size=1 --testpath=$TESTPATH  --testlist=$TESTLIST --loadckpt $CKPT_FILE ${@:2} --outdir $root_path
python collect_pointclouds.py --root_dir $root_path --target_dir $target_path --dataset "dtu" 