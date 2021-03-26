#!/usr/bin/env bash
TESTPATH="../../disk60t/tsk/tankandtemples"
TESTLIST="lists/tanks/test.txt"
root_path='/home/tsk/cas_clamp/outputs/'
target_path='/home/tsk/cas_clamp/pointoutput/'
CKPT_FILE=$'checkpoints/DDR-Net.ckpt'
python test_tanks.py --dataset=general_eval --batch_size=1 --testpath=$TESTPATH  --testlist=$TESTLIST --loadckpt $CKPT_FILE ${@:2} --outdir $root_path
python collect_pointclouds.py --root_dir $root_path --target_dir $target_path --dataset "tanks" testlist=$TESTLIST --loadckpt $CKPT_FILE ${@:2}