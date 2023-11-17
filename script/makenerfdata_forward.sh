CURRENT_DIR=$(realpath $(dirname "$0"))

#！/bin/bash
DATA_PATH=$1 # the same with colmap, make sure the images are in the subfolder named "images"

# config
OMNIDATA_PATH="$CURRENT_DIR/../omnidata/omnidata_tools/torch"
OMNIDATA_PRETRAINED_MODELS="$OMNIDATA_PATH/pretrained_models/"

CONDA_ACTIVATE="$CONDA_PREFIX/bin/activate"
if [ "$CONDA_DEFAULT_ENV" != "base" ]; then
    CONDA_ACTIVATE="$CONDA_PREFIX/../../bin/activate"
else
    CONDA_ACTIVATE="$CONDA_PREFIX/bin/activate"
fi

IMG_DATA_PATH=$DATA_PATH/images
NERF_DATA_PATH=$DATA_PATH/nerfstudio
SDF_DATA_PATH=$DATA_PATH/sdfstudio
LLFF_DATA_PATH=$DATA_PATH/llff

NERF_FILE=$NERF_DATA_PATH/transforms.json
if [ -e "$NERF_FILE" ]; then
    echo "NeRFstudio has done!"
else
    echo "Starting NeRFstudio..."
    source $CONDA_ACTIVATE nerfdata
    ns-process-data images --data $IMG_DATA_PATH --output-dir $NERF_DATA_PATH
    echo "Done NeRFstudio!"
fi


# SDF_FILE=$SDF_DATA_PATH/meta_data.json
# if [ -e "$SDF_FILE" ]; then
#     echo "SDFstudio has done!"
# else
#     echo "Starting SDFstudio..."
#     source $CONDA_ACTIVATE nerfdata
#     cd $CURRENT_DIR/../sdfstudio
#     python scripts/datasets/process_nerfstudio_to_sdfstudio.py \
#         --data $NERF_DATA_PATH \
#         --output-dir $SDF_DATA_PATH \
#         --data-type colmap \
#         --scene-type indoor \
#         --mono-prior \
#         --omnidata-path $OMNIDATA_PATH \
#         --pretrained-models $OMNIDATA_PRETRAINED_MODELS
#     echo "Done SDFstudio!"
# fi


LLFF_FILE=$LLFF_DATA_PATH/poses_bounds.npy
if [ -e "$LLFF_FILE" ]; then
    echo "LLFF has done!"
else
    echo "Starting LLFF..."
    mkdir -p $LLFF_DATA_PATH
    cp -rf $NERF_DATA_PATH/images $LLFF_DATA_PATH
    cp -rf $NERF_DATA_PATH/images_2 $LLFF_DATA_PATH
    cp -rf $NERF_DATA_PATH/images_4 $LLFF_DATA_PATH
    cp -rf $NERF_DATA_PATH/images_8 $LLFF_DATA_PATH
    cp -f $NERF_DATA_PATH/colmap/database.db $LLFF_DATA_PATH
    cp -rf $NERF_DATA_PATH/colmap/sparse $LLFF_DATA_PATH
    
    source $CONDA_ACTIVATE nerfdata
    cd $CURRENT_DIR/../LLFF
    python imgs2poses.py $LLFF_DATA_PATH
    echo "Done LLFF!"
fi

# Blender_FILE=$Blender_DATA_PATH/transforms_train.json
# if [ -e "$Blender_FILE" ]; then
#     echo "BlenderType has done!"
# else
#     echo "Starting transfer to NerfBlender..."
#     # cp -r $NERF_DATA_PATH $Blender_DATA_PATH
#     # mv $NERF_FILE $Blender_FILE
#     source $CONDA_ACTIVATE sdfstudio
#     python "$CURRENT_DIR/nerfstudio2nerfblender.py" --file $NERF_FILE
#     echo "Done NerfBlender!"
# fi

# source $CONDA_ACTIVATE sdfstudio
# python scripts/datasets/extract_monocular_cues.py \
#     --task depth \
#     --img_path $SDF_DATA_PATH \
#     --output_path $SDF_DATA_PATH \
#     --omnidata_path $OMNIDATA_PATH \
#     --pretrained_models $OMNIDATA_PRETRAINED_MODELS


# python /home/ckli/temp/github-test/monosdf/preprocess/extract_monocular_cues.py \
#     --task normal \
#     --img_path $SDF_DATA_PATH \
#     --output_path $SDF_DATA_PATH \
#     --omnidata_path $OMNIDATA_PATH \
#     --pretrained_models $OMNIDATA_PRETRAINED_MODELS

# pip install timm pytorch-lightning torchmetrics
