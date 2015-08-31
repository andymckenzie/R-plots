import numpy as np
import cv2
from matplotlib import pyplot as plt

em = cv2.imread("array.png") 
em = cv2.cvtColor(em,cv2.COLOR_BGR2GRAY)

cv2.imshow("em", em)
