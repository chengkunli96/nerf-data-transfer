import os
import numpy
import json
import shutil
from PIL import Image
import argparse 


rootdir = './lego_flashcam_tensoir'
outdir = './lego_flashcam_nerf'

def read_transforms_json(file):
    with open(os.path.join(file), 'r') as f:
        meta = json.load(f)
    return meta

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--file', type=str, help='path to transforms_json file')
    args = parser.parse_args()
    return args

def convert_jpg_to_png(jpg_path, png_path):
    img = Image.open(jpg_path)
    img.save(png_path)

if __name__ == "__main__":
    args = get_args()
    meta = read_transforms_json(args.file)

    # compute comera_angle_x
    focal = meta["fl_x"]
    image_width = meta["w"]
    meta["camera_angle_x"] = 2 * numpy.arctan(image_width / (2 * focal))

    dir_name = os.path.dirname(args.file)
    # transform jpg to png of a dir 
    new_dir = os.path.join(dir_name, "..", 'blendertype')
    new_img_dir = os.path.join(new_dir, "images")
    if not os.path.exists(new_img_dir):
        os.makedirs(new_img_dir)
    # delete meta ext
    for i, frame in enumerate(meta['frames']):
        file = frame['file_path']
        file_without_ext = os.path.splitext(file)[0]
        
        jpg_file_pth = os.path.join(dir_name, file)
        png_file_pth = os.path.join(new_dir, file_without_ext + ".png")
        convert_jpg_to_png(jpg_file_pth, png_file_pth)

        meta['frames'][i]['file_path'] = file_without_ext

    
    with open(os.path.join(new_dir, "transforms_train.json"), 'w') as f:
        json.dump(meta, f, indent=4)
    
    