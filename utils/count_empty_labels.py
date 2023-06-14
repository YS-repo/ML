import os


def count_empty_labels(path):
    """This method counts the number of labels which are blank. Blank labels in segmentation task are annotations
        that does not include any region of interest. In this case, the label does not include any tumor part."""
    zeros = 0
    non_zeros = 0
    files = os.listdir(path)

    for file in files:
        if '.txt' in file:
            size = os.stat(os.path.join(path, file)).st_size

            if size == 0:
                zeros += 1

            else:
                non_zeros += 1

    print(f'{zeros} label(s) are blank!\n{non_zeros} label(s) have region of interest!')