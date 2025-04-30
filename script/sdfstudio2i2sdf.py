import os
import numpy as np
import json
import shutil
from PIL import Image
import argparse 
import imageio

rootdir = './lego_flashcam_tensoir'
outdir = './lego_flashcam_nerf'

def read_transforms_json(file):
    with open(os.path.join(file), 'r') as f:
        meta = json.load(f)
    return meta

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--jsonfile', type=str, help='path to meta_data.json file')
    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = get_args()
    args.jsonfile = "/home/ckli/temp/flash_nerf/data/shb1023table_torch/sdfstudio/meta_data.json"
    meta = read_transforms_json(args.jsonfile)
    dir_name = os.path.dirname(args.jsonfile)  # data dir path

    # convert to a new place
    new_dir = os.path.join(dir_name, "..", 'i2sdf')
    new_img_dir = os.path.join(new_dir, "image")
    new_dpt_dir = os.path.join(new_dir, "image")
    new_normal_dir = os.path.join(new_dir, "normal")
    if not os.path.exists(new_img_dir):
        os.makedirs(new_img_dir)
    if not os.path.exists(new_dpt_dir):
        os.makedirs(new_dpt_dir)
    if not os.path.exists(new_normal_dir):
        os.makedirs(new_normal_dir)

    # delete meta ext
    for i, frame in enumerate(meta['frames']):
        img_n = frame['rgb_path']
        img_pth = os.path.join(dir_name, img_n) 
        
        dpt_n = frame['mono_depth_path']
        dpt_pth = os.path.join(dir_name, dpt_n)
        dpt_data = np.load(dpt_pth)
        print(np.max(dpt_data), np.min(dpt_data))
        



    
    