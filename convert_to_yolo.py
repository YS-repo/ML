import cv2


class convert_format():

    def seg_to_det(self, img_path):
        coords = []
        img_path = img_path
        img = cv2.imread(img_path)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        # apply thresholding on the gray image to create a binary image
        ret,thresh = cv2.threshold(gray,127,255,0)
        # find the contours
        contours, _ = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
        
        for i in range(len(contours)):
            cnt = contours[i]
            # compute the bounding rectangle of the contour
            x,y,w,h = cv2.boundingRect(cnt)
            coords.append([x,y,w,h])

        coords.append(list(img.shape))
        return coords
    
    

    def to_yolo(self, coord):
        yolo_format = []    # Storing coordinates in yolo format
        object_class = 0    # First argument in yolo format (class of object)
        for j in range(len(coord)):
            shape = coord[-1]
            if j != len(coord) - 1:
                point = coord[j]
                new_x = (point[0] + point[2]/2)/shape[0]
                new_y = (point[1] + point[3]/2)/shape[1]
                new_w,new_h = point[2]/shape[0], point[3]/shape[1]
                yolo_format.append([object_class, new_x, new_y, new_w, new_h])
        return yolo_format
