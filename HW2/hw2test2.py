# -*- coding: utf-8 -*-
"""
ECE661 Homework 2
Ye Shi
shi349@purdue.edu
"""

# Load libs
import numpy as np
import cv2
import math

# Function to find homography from points of image 1 to points of image 2
def findH(pst1,pst2):
    n = np.size(pst1,0)
    if n != np.size(pst2,0) or np.size(pst1,1) != np.size(pst2,1):
        print ("Error! Sizes don't match!")
        exit(1)
    n = n+1
    A = np.zeros((2*n,2*n))
    b = np.zeros((2*n,1))
    for i in range(n):
        A[2*i] = [pst2[0][i],pst2[1][i],pst2[2][i],0,0,0,(-pst2[0][i]*pst1[0][i]),(-pst2[1][i]*pst1[0][i])]
        A[2*i+1] = [0,0,0,pst2[0][i],pst2[1][i],pst2[2][i],(-pst2[0][i]*pst1[1][i]),(-pst2[1][i]*pst1[1][i])]
        b[2*i] = pst1[0][i]
        b[2*i+1] = pst1[1][i]
    
    x = np.matmul(np.linalg.pinv(A),b)
    H = np.zeros((3,3))
    H[0] = x[0:3].T
    H[1] = x[3:6].T
    H[2][0:2] = x[6:8].T
    H[2][2] = 1
#    Pinv2d = np.linalg.pinv(pst2.T)
#    H = np.matmul(Pinv2d,pst1.T)
    
    return H


# Grip points from images by order in PQRS with HC
PQRS1a = np.array([[171,1517,1],[721,2954,1],[2239,1485,1],[2051,3003,1]])
PQRS1d = np.array([[0,0,1],[0,im1d.shape[1],1],[im1d.shape[0],0,1], [im1d.shape[0],im1d.shape[1],1]])


Hd2a = findH(PQRS1d.T,PQRS1a.T)
print(Hd2a)