import os
from tqdm import tqdm


def revise_name(data_dir):
    """This method is going to correct the names of labels. in my dataset, images are 'X.tif' and labels are in 'X_mask.txt' format. 
        for training purposes using yolo, we revise the labels to have the same name as images. i.e. images 'X.tif' and labels 'X.txt' 
    """
    files = os.listdir(data_dir)

    for file in tqdm(files):
        
        if '.txt' in file:
            new_name = file.replace('_mask.txt', '.txt')
            os.rename(os.path.join(data_dir, file), os.path.join(data_dir, new_name))