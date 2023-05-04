# Tracking Moving Objects<br />
In this repo, a classical method is proposed to track moving objects in video frames. Our main assumption is the camera recording the video is constant and does not move at all. There are two approaches to achieve this goal: 1- Using machine learning technique 2- Using diffrentation of continuous frames. We will discuss both pros and cons for the 2 ways and show some results.

## What is foreground/background?
The element of the photo closest to you makes up the foreground. The furthest element away from you is the background. Here in this repo, foreground would be the moving objects, and rest of the image would be background. This is a very simple and straight explanation of this concept. 

## Machine Learning Approach

In this method, we use a built-in function in matlab which has been developed for estimating foreground. To implement this, we use the following line of code:
```matlab
foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, 'NumTrainingFrames', 50);
 ```
This approach, uses Gaussian Mixture Model (GMM) to predict the foreground. To read more about the GMM, you can visit [THIS](https://towardsdatascience.com/gaussian-mixture-models-explained-6986aaf5a95) site.
The defined detector would be applied on every frame and estimates the foreground. It is necessary to mention setting different parameters inside the function would result in different outputs. Applying this technique on a frame would create a binary image which background would have zero value (black) and foreground would be one (white). After doing some post-processing, redundant parts of the mask will be removed. The following figure illustrates some outputs of this algorithm:

<p align="center">
 


<a href="https://github.com/YS-repo/ML/edit/Tracking/">
  <img src="https://user-images.githubusercontent.com/124210096/236118286-902824d6-1b84-4b42-8452-eb76985985e0.png" alt="Gif" width="350" height="300">
</a>

<a href="https://github.com/YS-repo/ML/edit/Tracking/">
  <img src="https://user-images.githubusercontent.com/124210096/236118324-cf262274-bab6-4297-8a97-96b409b9a461.png" alt="Gif" width="350" height="300">
</a>

</p>

<br />









