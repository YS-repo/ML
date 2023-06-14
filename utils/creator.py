import os
from tqdm import tqdm
from shutil import copy
from convert_to_yolo import convert_format


obj = convert_format()

def creator(base_dir, target_dir):
    folders = os.listdir(base_dir)

    for folder in tqdm(folders):
        inside_folder = os.path.join(base_dir, folder)
        os.mkdir(os.path.join(target_dir, folder))
        all_images = os.listdir(inside_folder)

        for image_path in all_images:
            if 'mask' in image_path:  # in my dataset, labels have 'mask' suffix in their name
                name = image_path.split('.tif')[0]  # in my dataset, images are in '.tif' format. revise it for your custom dataset.
                img_pth = os.path.join(inside_folder, image_path)
                coords = obj.seg_to_det(img_path = img_pth)
                yolo_form = obj.to_yolo(coord = coords)

                with open(os.path.join(target_dir, folder) + '/' + name + '.txt', 'w') as f:
                    for line in yolo_form:
                        for sub_line in line:
                            sub_line = str(sub_line)
                            f.write(sub_line + ' ')
                        f.write('\n')

            else:
                img_pth = os.path.join(inside_folder, image_path)
                copy(img_pth, os.path.join(target_dir, folder))
