from ultralytics import YOLO
import cv2


class train():

    def train_yolo(self, yaml_path, epochs = 75, imgsize = 640):

        model = YOLO('yolov8n.yaml')
        model = YOLO('yolov8n.pt')
        model = YOLO('yolov8n.yaml').load('yolov8n.pt')
        model.train(data = yaml_path, epochs = epochs, imgsz = imgsize, workers = 0)
