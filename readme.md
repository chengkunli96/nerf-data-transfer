``` bash
# basic env
conda create --name nerfdata -y python=3.8
conda activate nerfdata
python -m pip install --upgrade pip
pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113
pip install git+https://github.com/NVlabs/tiny-cuda-nn/#subdirectory=bindings/torch
pip install timm pytorch-lightning torchmetrics
pip install keyring==23.4.1
pip install importlib-metadata==4.13.0
pip install timm
pip install pytorch_lightning

# sdfstudio env
cd ./sdfstudio
pip install --upgrade pip setuptools
pip install -e .
# install tab completion
ns-install-cli

# omnidata pretrain model
cd omnidata/omnidata_tools/torch
sh ./tools/download_depth_models.sh
sh ./tools/download_surface_normal_models.sh
```

``` bash
# the same with colmap, make sure the images are in the subfolder named "images"
# it means image_sequence_folder_pth_abs must have a subfolder named "images"
bash script/makenerfdata.sh [image_sequence_folder_pth_abs]
```

``` bash
# For checking you have install nerfstudio firstly
bash script/checkcolmapinnerfstudio.sh [image_sequence_folder_pth_abs]
```
