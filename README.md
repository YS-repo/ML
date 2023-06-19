# Brain Tumor detection<br />

This project aims to develop a robust and accurate system for the detection of brain tumors using Yolov8.

## About

Brain tumors pose a significant health risk, and early detection plays a crucial role in improving patient outcomes. This project leverages cutting-edge technologies to assist medical professionals in identifying brain tumors from magnetic resonance imaging (MRI) scans.

## Dataset

This project uses [THIS](https://www.kaggle.com/datasets/mateuszbuda/lgg-mri-segmentation) dataset to train the object detection model. Originally, this dataset is provided for segmentation task, but we changed it to detection format. This is simply done by finding a bounding box of the tumor section in the ground truth and changing it to yolo format. To see more details, take a look at [convert_to_yolo.py](https://github.com/YS-repo/ML/blob/Tumor_Detection/convert_to_yolo.py) file. 

## Yolo
YOLO (You Only Look Once) was introduced by Joseph Redmon, Santosh Divvala, Ross Girshick, and Ali Farhadi in 2016. The original YOLO paper, titled "You Only Look Once: Unified, Real-Time Object Detection," presented a groundbreaking approach to real-time object detection.
YOLO processes an entire image in a single pass, predicting object bounding boxes and class probabilities simultaneously. YOLO's unified approach enables fast and accurate detection across various scales and aspect ratios. It has widespread adoption in domains like autonomous driving and surveillance systems, offering a powerful solution for real-time object detection tasks. To read more about YOLO, visit [THIS](https://pjreddie.com/darknet/yolo/) website.
To date, a total of eight versions of YOLO have been released, and for the implementation of the tumor detection task, we utilize the latest version available.



