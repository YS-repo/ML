# Brain Tumor detection<br />

This project aims to develop a robust and accurate system for the detection of brain tumors using Yolov8.

## About

Brain tumors pose a significant health risk, and early detection plays a crucial role in improving patient outcomes. This project leverages cutting-edge technologies to assist medical professionals in identifying brain tumors from magnetic resonance imaging (MRI) scans.

## Dataset

This project uses [THIS](https://www.kaggle.com/datasets/mateuszbuda/lgg-mri-segmentation) dataset to train the object detection model. Originally, this dataset is provided for the segmentation task, but we changed it to detection format. This is simply done by finding a bounding box of the tumor section in the ground truth and changing it to Yolo format. To see more details, take a look at [convert_to_yolo.py](https://github.com/YS-repo/ML/blob/Tumor_Detection/convert_to_yolo.py) file. 

## Yolo
YOLO (You Only Look Once) was introduced by Joseph Redmon, Santosh Divvala, Ross Girshick, and Ali Farhadi in 2016. The original YOLO paper, titled "You Only Look Once: Unified, Real-Time Object Detection," presented a groundbreaking approach to real-time object detection.
YOLO processes an entire image in a single pass, simultaneously predicting object bounding boxes and class probabilities. YOLO's unified approach enables fast and accurate detection across various scales and aspect ratios. It has widespread adoption in domains like autonomous driving and surveillance systems, offering a powerful solution for real-time object detection tasks. To read more about YOLO, visit [THIS](https://pjreddie.com/darknet/yolo/) website.
To date, a total of eight versions of YOLO have been released, and for the implementation of the tumor detection task, we utilize the latest version available.
A full description of how to work with yolov8 can be found on [ultralytics](https://docs.ultralytics.com/) website.

## Usage

Clone the repository to your local system. Follow the instructions below for r=each purpose:

### Converting data to Yolo format
- - -
In [convert_to_yolo.py](https://github.com/YS-repo/ML/blob/Tumor_Detection/convert_to_yolo.py) file, utilize the "seg_to_det" method to extract the bounding box of your ground truths.
For converting the bounding box coordinates to Yolo format you can use the "to_yolo" method. The output of the previous step can be fed to this method. However, if you already possess a dataset in the YOLO format, you can disregard this step.

### Training
- - -
For training on your custom data, you can easily use the train_yolo method in [training.py](https://github.com/YS-repo/ML/blob/Tumor_Detection/training.py). To specify the "yaml_path" argument, provide the path to your customized YAML file. Feel free to create this file according to your specific requirements and preferences. It should look something like the below:

![yaml](https://github.com/YS-repo/ML/assets/124210096/3da7a737-797d-45d9-8366-4f5e213c6b1a)

The directory of the dataset looks like below:

```
├── Tomur Data
│   ├── train
│   │   ├── image1.png
│   │   ├── image1.txt
│   │   ├── image2.png
│   │   ├── image2.txt
│   │   ├── .
│   │   ├── .
│   │   ├── .
│   ├── test
│   │   ├── image1_test.png
│   │   ├── image1_test.txt
│   │   ├── image2_test.png
│   │   ├── image2_test.txt
│   │   ├── .
│   │   ├── .
│   │   ├── .
```
You can specify the number of epochs and image size as desired.

### Prediction
- - -
To predict, from [prediction.py](https://github.com/YS-repo/ML/blob/Tumor_Detection/prediction.py) use 'predic' method. There three paramerters in this method:\
**image_src**: path to desired image for prediction\
**weight_src**: path to saved model. The weights of our model are at [models](https://github.com/YS-repo/ML/tree/Tumor_Detection/models). \
**conf**: The confidence of the extracted bounding box during prediction.



## Results

The below table shows loss and accuracy parameters through some epochs.

|     Epoch     | train box loss|   precision   |      recall   |      mAP50    |    mAP50-95   |  val box loss |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: |
|      10       |     1.2548    | 0.80787   | 0.7449 | 0.82167| 0.58541  |    1.1096   |
|      20       |     1.1416    | 0.92301   | 0.76531 | 0.84454| 0.589  |    1.1195   |
|      30       |     1.1112    | 0.88205   | 0.76306 | 0.85002| 0.58129  |    1.1252  |
|      40       |     1.0528    | 0.90594   | 0.7551 | 0.82722| 0.59756  |    1.08  |
|      50       |     0.92611   | 0.93269   | 0.79592| 0.89163| 0.62593  |    1.0237  |

By increasing the number of training epochs and utilizing a larger dataset, the model's performance would see a significant improvement. Here are a few examples of the model's outputs on the test set:

|  Original Image | Corresponding Mask (segmentation format) | Output of model |
| :-:             |                    :-:                   |        :-:      |
| ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_CS_4941_19960909_12__1_.png) | ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_CS_4941_19960909_12_mask__1_.png) | ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_CS_4941_19960909_12_detected.png) |
| ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_CS_4942_19970222_9.png) | ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_CS_4942_19970222_9_mask.png) | ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_CS_4942_19970222_9_detected.png) |
| ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_CS_6669_20020102_10.png) | ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_CS_6669_20020102_10_mask.png) | ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_CS_6669_20020102_10_detected.png) |
| ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_DU_5849_19950405_20.png) | ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_DU_5849_19950405_20_mask.png) | ![](https://filebin.net/n72lzs7v1j7p8qds/TCGA_DU_5849_19950405_20_detected.png) |

## License
This project is licensed under the [MIT License](https://choosealicense.com/licenses/mit/). Feel free to use, modify, and distribute the code, while keeping the license file intact.

## Contact
If you have any questions, suggestions, or feedback, please reach out to us at younesshokoohi@gmail.com.
We hope this Brain Tumor Detection system proves valuable in aiding healthcare professionals in their fight against brain tumors. Thank you for your interest in our project!

