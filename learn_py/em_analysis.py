import numpy as np
import cv2
from matplotlib import pyplot as plt

em = cv2.imread("em_data/em_peters.png") 
em = cv2.cvtColor(em,cv2.COLOR_BGR2GRAY)
em = cv2.resize(em, (0,0), fx = 0.6, fy = 0.6)
#
ret, thresh = cv2.threshold(thresh,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)

#
edges = cv2.Canny(em,100,200)
plt.subplot(121),plt.imshow(em,cmap = 'gray')
plt.title('Original Image'), plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(edges,cmap = 'gray')
plt.title('Edge Image'), plt.xticks([]), plt.yticks([])

plt.show()