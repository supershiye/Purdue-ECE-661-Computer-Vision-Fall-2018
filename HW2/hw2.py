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

# Function to map image 2 to image 1 by H
def mapping(im1, im2, H, hiOff = 0, wiOff = 0):
    [h2,w2,c2] = im2.shape
    [h1,w1,c1] = im1.shape
    method = 1
    if method == 2: 
        # This method may have some points not covered
        for i in range(h2):
            for j in range(w2):
                y = np.array((i,j,1))
                x = np.matmul(H,y.T)
                x = np.floor(x/x[2])
                x = x.astype(int)
                if x[0] <h1 and x[0]>=0 and x[1] <w1 and x[1] >=0:
                    im1[x[0]][x[1]] = im2[i][j]
                    
    elif method == 1:
        for i in range(h1):
            for j in range(w1):
                x = np.array((i,j,1))
                y = np.matmul(np.linalg.inv(H),x.T)
                y = np.floor(y/y[2])
                y = y.astype(int)
                
                if y[0]<h2 and y[0]>=0 and y[1]<w2 and y[1]>=0:
                    im1[i][j] = im2[y[0]][y[1]]   
                    

# Function to project image 1 by H
def project(im1, H, hiOff = 0, wiOff = 0):
    [h,w,c] = im1.shape
    imNew = np.zeros((h,w,c))
    for i in range(h):
        for j in range(w):
            x = np.array((i,j,1))
            y = np.matmul(H,x.T)
            y = np.floor(y/y[2])
            y = y.astype(int)
            
            if y[0]<h and y[0]>=0 and y[1]<w and y[1]>=0:
                imNew[i][j] = im1[y[0]][y[1]] 
    return imNew
            
# Function to find homography from points of image 1 to points of image 2
def findH(pst1,pst2):
    
    n = np.size(pst1,0)
    # check points number and dimension to be identical
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
    return H

# Problem 1a
# Import Images
im1a = cv2.imread(".\\PicsHw2\\1.jpg")
im1b = cv2.imread(".\\PicsHw2\\2.jpg")
im1c = cv2.imread(".\\PicsHw2\\3.jpg")
im1d = cv2.imread(".\\PicsHw2\\jackie.jpg")

# Grip points from images by order in PQRS with HC
PQRS1a = np.array([[171,1517,1],[721,2954,1],[2239,1485,1],[2051,3003,1]])
PQRS1b = np.array([[338,1326,1],[622,3012,1],[2014,1292,1],[1897,3033,1]])
PQRS1c = np.array([[732,920,1],[388,2797,1],[2094,898,1],[2232,2854,1]])
PQRS1d = np.array([[0,0,1],[0,im1d.shape[1],1],[im1d.shape[0],0,1], [im1d.shape[0],im1d.shape[1],1]])

# Find homographies
# 1d to 1a
Hd2a = findH(PQRS1a.T,PQRS1d.T)
# 1d to 1b
Hd2b = findH(PQRS1b.T,PQRS1d.T)
# 1d to 1a
Hd2c = findH(PQRS1c.T,PQRS1d.T)

# Project Images and Save
mapping(im1a, im1d, Hd2a)
cv2.imwrite('1a1.jpg',im1a)

mapping(im1b, im1d, Hd2b)
cv2.imwrite('1a2.jpg',im1b)

mapping(im1c, im1d, Hd2c)
cv2.imwrite('1a3.jpg',im1c)


# Problem 1b

# Import Images again to refresh
im1a = cv2.imread(".\\PicsHw2\\1.jpg")
im1b = cv2.imread(".\\PicsHw2\\2.jpg")
im1c = cv2.imread(".\\PicsHw2\\3.jpg")
im1d = cv2.imread(".\\PicsHw2\\jackie.jpg")

# Find homographies
# 1a to 1b
Ha2b = findH(PQRS1b.T,PQRS1a.T)
# 1b to 1c
Hb2c = findH(PQRS1c.T,PQRS1b.T)
# 1a to 1b to 1c
Ha2b2c = np.matmul(Hb2c,Ha2b)

# Project 1a by Ha2b2c
imNew = np.zeros(im1a.shape)
mapping(imNew,im1a, Ha2b2c)
cv2.imwrite('1b1.jpg',imNew)

# Problem 2a

# Import Images
im2a = cv2.imread("im2a.jpg")
im2b = cv2.imread("im2b.jpg")
im2c = cv2.imread("im2c.jpg")
im2d = cv2.imread("im2d.jpg")

# Grip points from images by order in PQRS with HC
PQRS2a = np.array([[1218,1442,1],[1240,2206,1],[1882,1446,1],[1724,2218,1]])
PQRS2b = np.array([[1156,1042,1],[1158,1996,1],[1690,1054,1],[1670,2000,1]])
PQRS2c = np.array([[952,1010,1],[1084,1914,1],[1438,1066,1],[1586,1916,1]])
PQRS2d = np.array([[0,0,1],[0,im2d.shape[1],1],[im2d.shape[0],0,1], [im2d.shape[0],im2d.shape[1],1]])

# Find homographies
# 2d to 2a
Hd2a2 = findH(PQRS2a.T,PQRS2d.T)
# 2d to 2b
Hd2b2 = findH(PQRS2b.T,PQRS2d.T)
# 2d to 2a
Hd2c2 = findH(PQRS2c.T,PQRS2d.T)

# Project Images and Save
mapping(im2a, im2d, Hd2a2)
cv2.imwrite('2a1.jpg',im2a)

mapping(im2b, im2d, Hd2b2)
cv2.imwrite('2a2.jpg',im2b)

mapping(im2c, im2d, Hd2c2)
cv2.imwrite('2a3.jpg',im2c)


# Problem 2b

# Import Images again to refresh
im2a = cv2.imread("im2a.jpg")
im2b = cv2.imread("im2b.jpg")
im2c = cv2.imread("im2c.jpg")
im2d = cv2.imread("im2d.jpg")

# Find homographies
# 2a to 2b
Ha2b2 = findH(PQRS2b.T,PQRS2a.T)
# 2b to 2c
Hb2c2 = findH(PQRS2c.T,PQRS2b.T)
# 2a to 2b to 2c
Ha2b2c2 = np.matmul(Hb2c2,Ha2b2)

# Project 2a by Ha2b2c2
imNew = np.zeros(im2a.shape)
mapping(imNew,im2a, Ha2b2c2)
cv2.imwrite('2b1.jpg',imNew)