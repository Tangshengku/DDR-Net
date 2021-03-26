# DDR-Net
The official implementation of "DDR-Net: Learning Multi-Stage Multi-View Stereo With Dynamic Depth Range"
# Installation
## Requirements
* python 3.6
* Pytorch >= 1.0.0 and <= 1.2.0 (We advise not to use Pytorch version higher than 1.2.0 because there may be some problems on interpolation.)
* CUDA >= 9.0

```
pip install -r requirements.txt
```

## Option for speeding up training: Apex 
install apex to enable synchronized batch normalization 
```
git clone https://github.com/NVIDIA/apex.git
cd apex
pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
```

# Training and testing on DTU dataset.
## Training
* Download the preprocessed [DTU training data](https://drive.google.com/file/d/1eDjh-_bxKKnEuz5h-HXS7EDJn59clx6V/view)
 and [Depths_raw](https://virutalbuy-public.oss-cn-hangzhou.aliyuncs.com/share/cascade-stereo/CasMVSNet/dtu_data/dtu_train_hr/Depths_raw.zip) 
 (both from [Original MVSNet](https://github.com/YoYo000/MVSNet)), and upzip it as the $MVS_TRANING  folder.
 The directory is formed as follow:

```                
├── Cameras    
├── Depths
├── Depths_raw   
├── Rectified
├── Cameras                               
             
```

* In ``train.sh``, set ``MVS_TRAINING`` to where the training dataset is.
* Train DDR-Net (Multi-GPU training): 

```
export NGPUS=4
export save_results_dir="./checkpoints"  
./train.sh $NGPUS $save_results_dir  --ndepths "48,32,8"  --depth_inter_r "4,2,1"   --dlossw "0.5,1.0,2.0"  --batch_size 2 --eval_freq 3
```

If apex is installed, you can use sync_bn in training:
```
./train.sh $NGPUS $save_results_dir  --ndepths "48,32,8"  --depth_inter_r "4,2,1"   --dlossw "0.5,1.0,2.0"  --batch_size 2 --eval_freq 3  --using_apex  --sync_bn
```

## Testing and Fusion
* Download the preprocessed test data [DTU testing data](https://drive.google.com/open?id=135oKPefcPTsdtLRzoDAQtPpHuoIrpRI_) (from [Original MVSNet](https://github.com/YoYo000/MVSNet)) and unzip it, which should contain one ``cams`` folder, one ``images`` folder and one ``pair.txt`` file.
* In ``test_dtu.sh``, set ``TESTPATH`` to where the test dataset is.
* Set ``CKPT_FILE``  as your checkpoint file, you also can utilize our pretrained model (checkpoints/DDR-Net.ckpt).
* Test DDR-Net and Fusion: 
* The method of fusion is optional, including normal fusion and Gipuma fusion.
* We suggest Gipuma to fusion to provide our results (need to install [fusibile](https://github.com/YoYo000/fusibile)). the script is borrowed from [MVSNet](https://github.com/YoYo000/MVSNet).  Note that more than 20 GB memory is required for tanks and temples fusion.
```
git clone https://github.com/YoYo000/fusibile
cd fusibile
mkdir build&&cd build
cmake..
make
```
* After installing fusibile, set ``--fusibile_exe_path`` to the place where you install fusibile.
* Set ``root_path`` as the path of depth map output and ``target_path`` as the path of point cloud reconstruction.

```
./test.sh
```
* Point cloud reconstruction can be evaluated by offical Matlab code in [DTU](http://roboimagedata.compute.dtu.dk/?page_id=36)
## Results on DTU
|                       | Acc.   | Comp.  | Overall. |
|-----------------------|--------|--------|----------|
| DDR-Net(D=48,32,8)  | 0.339  | 0.320  | 0.329    |

## Results on Tanks and Temples benchmark (D=48,32,8)

| Mean   | Family | Francis | Horse  | Lighthouse | M60    | Panther | Playground | Train |
|--------|--------|---------|--------|------------|--------|---------|------------|-------|
| 54.91  | 76.18  | 53.36   | 43.43  | 55.20	  | 55.57  | 52.28   | 56.04	  | 47.17 |

Please refer to [leaderboard](https://www.tanksandtemples.org/).

if you have any issues, please make an issue or send an email to us (shengkuntang@whu.edu.cn). We will reply as soon as possible.
