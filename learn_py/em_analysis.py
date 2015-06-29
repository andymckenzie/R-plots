import numpy as np
import cv2
from matplotlib import pyplot as plt

em = cv2.imread("em_data/em_peters.png") 
em = cv2.cvtColor(em,cv2.COLOR_BGR2GRAY)
em = cv2.resize(em, (0,0), fx = 0.6, fy = 0.6)

#############################
#Otsu method
ret, thresh = cv2.threshold(em,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)

#cv2.imshow('test', thresh)

##############################
#Canny edge detection 
edges = cv2.Canny(em,100,200)

#cv2.imshow('test', edges)

##############################
# blob detection
#http://stackoverflow.com/questions/8076889/tutorial-on-opencv-simpleblobdetector
#http://answers.opencv.org/question/38218/module-object-has-no-attribute-simpleblobdetector/

params = cv2.SimpleBlobDetector_Params()

# Change thresholds
params.minThreshold = 10
params.maxThreshold = 200

# Filter by Area.
params.filterByArea = True
params.minArea = 50

# Filter by Circularity
params.filterByCircularity = True
params.minCircularity = 0.1

# Filter by Inertia
params.filterByInertia = True
params.minInertiaRatio = 0.01

detector = cv2.SimpleBlobDetector_create(params)
 
keypoints = detector.detect(em)
 
# Draw detected blobs as red circles.
# cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS ensures the size of the circle corresponds to the size of blob
im_with_keypoints = cv2.drawKeypoints(em, keypoints, np.array([]), (0,0,255), cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
 
# Show keypoints
cv2.imshow("Keypoints", im_with_keypoints)
