CURRENT_DIR=$(realpath $(dirname "$0"))

#！/bin/bash
DATA_PATH=$1 # the same with colmap, make sure the images are in the subfolder named "images"

CONDA_ACTIVATE="$CONDA_PREFIX/bin/activate"
if [ "$CONDA_DEFAULT_ENV" != "base" ]; then
    CONDA_ACTIVATE="$CONDA_PREFIX/../../bin/activate"
else
    CONDA_ACTIVATE="$CONDA_PREFIX/bin/activate"
fi


NERF_DATA_PATH=$DATA_PATH/nerfstudio


source $CONDA_ACTIVATE nerfstudio
ns-train nerfacto --data $NERF_DATA_PATH