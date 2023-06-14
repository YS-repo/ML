from ultralytics import YOLO
import matplotlib.pyplot as plt
import cv2

class pred():

   def predic(self, image_src, weight_src, conf):
      """image_src >> path to image file
         weight_src = path to '.pt' file
         conf >> confidence of detection
      """
      conf = conf
      img = cv2.imread(image_src)
      model = YOLO(weight_src)
      res = model.predict(img, conf = conf)
      res_plotted = res[0].plot()
      plt.imshow(res_plotted)
      plt.show()
      # cv2.imshow('result', res_plotted)
      # cv2.waitKey(0)
