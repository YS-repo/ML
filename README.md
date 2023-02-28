# Left Artry Segmentation<br />
Why is left coronary artery important?
The left main coronary artery supplies blood to the left side of the heart muscle (the left ventricle and left atrium). The left main coronary divides into branches: The left anterior descending artery branches off the left coronary artery and supplies blood to the front of the left side of the heart.
This script implements left artry segmentation with UNet.<br />


## Dataset
The dataset used for this project can be found [Here](https://www.kaggle.com/datasets/adarshsng/heart-mri-image-dataset-left-atrial-segmentation). Also the paper can be downloaded from [Here](https://arxiv.org/pdf/1902.09063.pdf). This dataset provides heart MRI images in NITFI format. Some images and the corrosponding masks are merged toghether to create a gif like follows:<br />

<p align="center">
 


<a href="https://github.com/YS-repo/ML/edit/Medicine/">
  <img src="https://user-images.githubusercontent.com/124210096/221981967-37568abf-dc4d-4a82-a913-a0a974765148.gif" alt="Gif" width="350" height="300">
</a>

<a href="https://github.com/YS-repo/ML/edit/Medicine/">
  <img src="https://user-images.githubusercontent.com/124210096/221981999-c0d4a285-1e71-40b5-8bd5-0009836630d4.gif" alt="Gif" width="350" height="300">
</a>

</p>



<br />

## UNet<br />
UNet architecture consists of a contraction and expansion path. the contraction path follows the formula:<br />
```python
conv_layer1 -> conv_layer2 -> max_pooling -> dropout(optional)
```
for implementing the simplest block of this sample we use the following code:
```python
    c1 = Conv2D(16, (3,3), activation='elu', kernel_initializer='he_normal', padding='same')(inputs)
    c1 = Conv2D(16, (3,3), activation='elu', kernel_initializer='he_normal', padding='same')(c1)
    p1 = MaxPooling2D((2,2))(c1)
    c1 = Dropout(0.1)(p1)
 ```
 
 In the expansive path, the image is going to be upsized to its original size. The formula follows:
 ``` python
 conv_2d_transpose -> concatenate -> conv_layer1 -> conv_layer2
 ```
 To implement this we use the following code:
 ``` python
    u6 = Conv2DTranspose(128, (2,2), strides=(2,2), padding='same')(c5)
    u6 = concatenate([u6, c4])
    c6 = Conv2D(128, (3,3), activation='elu', kernel_initializer='he_normal', padding='same')(u6)
    c6 = Conv2D(128, (3,3), activation='elu', kernel_initializer='he_normal', padding='same')(c6) 
 ```
 A good and simple step-by-step explanation of UNet can be found [Here](https://towardsdatascience.com/unet-line-by-line-explanation-9b191c76baf5). Below is a famous schematic of the UNet. The left and right part are the contraction and expansion paths respectively.


![UNet](https://user-images.githubusercontent.com/124210096/221975464-9293564b-c8ce-4e7e-ad14-4a5f30e8543b.png)








Also you can use the colab [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1HqDVY6d1uBk5kam0OJA4ZhHp1jxB_B2D?authuser=1) notebook and train or evaluate on your own data.





