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

## Differentiating consecutive frames approach

The idea of this way is really simple. we set the previous frame as a background, then we subtract the cuurent frame from previous one. The background frame would be updated in every step, meaning the current frame would be background frame for the next iteration. Obviously, this method has some weaknesses but overall, it creates good results. Furthermore, with appropriate post-processing, we can get rid of unwanted movements (such as the effect of wind on the leaf of trees). Unfortunately, this method does not work well with shadows. This means even shadows of the objects would be considered as moving object. Following figure, shows an output of this method:

<p align="center">
 


<a href="https://github.com/YS-repo/ML/edit/Tracking/">
  <img src="https://user-images.githubusercontent.com/124210096/236118286-902824d6-1b84-4b42-8452-eb76985985e0.png" alt="Gif" width="350" height="300">
</a>

<a href="https://github.com/YS-repo/ML/edit/Tracking/">
  <img src="https://user-images.githubusercontent.com/124210096/236122092-78a0e152-8a84-4652-ac4d-22360dcec319.png" alt="Gif" width="350" height="300">
</a>

</p>

<br />

Maybe in a first look, the machine learning approach seems more accurate but this is not true. let's take a look to the following gifs:


<p align="center">
 

<a href="https://github.com/YS-repo/ML/edit/Tracking/">
 <img src="https://user-images.githubusercontent.com/124210096/236125011-615b94b5-5bff-4c96-80a5-c2ae95e3391a.gif" alt="Gif" width="350" height="300">
  
</a>

<a href="https://github.com/YS-repo/ML/edit/Tracking/">
 <img src="https://user-images.githubusercontent.com/124210096/236124992-1926f677-54da-4995-81e1-378a28952f9d.gif" alt="Gif" width="350" height="300">
 
 
</a>

</p>
<p align="center">
    <em>Differentiating consecutive frames outputs</em>
</p>
<br />



<p align="center">
 

<a href="https://github.com/YS-repo/ML/edit/Tracking/">
 <img src="https://user-images.githubusercontent.com/124210096/236125011-615b94b5-5bff-4c96-80a5-c2ae95e3391a.gif" alt="Gif" width="350" height="300">
  
</a>

<a href="https://github.com/YS-repo/ML/edit/Tracking/">
 <img src="https://user-images.githubusercontent.com/124210096/236127088-3e87f650-a696-4f57-897e-84b48700f5bd.gif" alt="Gif" width="350" height="300">
 
 
</a>

</p>
<p align="center">
    <em>Machine learning outputs</em>
</p>
<br />


## Triangulation

After obtaining the foreground mask, we will triangulate the foreground. The quality of our triangulation is mainly dependant to the mask we create. IF the mask is good enough, triangulation would be nice and smooth. In contrast, bad mask can lead to falsy results. Remember, we are doing triangulation to highlight the moving objects. Apparently, we will have better results with second method, because the foreground mask is much more better than the first way. To obtain the vertices of triangles, we use the following line of code:

```matlab
delaunay_tri=delaunay(del_points(:,1),del_points(:,2));
 ```
 Here del_points are coordinates of corners and centroids of the foreground mask. The following videos are the final outputs of the two methods:
 

<p align="center">
 

<a href="https://github.com/YS-repo/ML/edit/Tracking/">
 <img src="https://user-images.githubusercontent.com/124210096/236131780-20d37ac2-51bc-4a0b-80ed-401c34795800.gif" alt="Gif" width="350" height="300">
  
</a>

<a href="https://github.com/YS-repo/ML/edit/Tracking/">
 <img src="https://user-images.githubusercontent.com/124210096/236131891-f5b92431-bc8c-4a1e-b763-294c0347affe.gif" alt="Gif" width="350" height="300">
 
 
</a>

</p>
    <em>   &emsp;&emsp; &emsp;&emsp; &emsp;&emsp; &emsp;Differentiating consecutive frames    &emsp; &emsp;&emsp; &emsp;&emsp; &emsp;&emsp; &emsp; &emsp;&emsp;      Machine learning </em>
<br />




