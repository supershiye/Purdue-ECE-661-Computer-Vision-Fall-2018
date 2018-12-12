# -*- coding: utf-8 -*-
"""
ECE661 Homework 4
Ye Shi
shi349@purdue.edu
"""

# Load libs
import numpy as np
import cv2
from matplotlib import pyplot as plt
#from multiprocessing import Pool
#import numba



# Harris Corner Detector
#@numba.jit(nopython=True, parallel=True)
def HCD(img,sigma = 1.2, scales = 1, k = 2, debug = 1): # defaults given by instruction
    si = sigma*scales
    HaarSize = int(round(np.ceil(4*si)/2.0)*2)
    HaarX = np.concatenate((-np.ones((HaarSize,int(HaarSize/2))), np.ones((HaarSize,int(HaarSize/2)))), axis=1)
    HaarY = np.concatenate((np.ones((HaarSize,int(HaarSize/2))), -np.ones((HaarSize,int(HaarSize/2)))), axis=0)
    imgX = cv2.filter2D(img,-1,HaarX)
    imgY = cv2.filter2D(img,-1,HaarY)
    
    if debug == 1:
        implt(imgX)
        implt(imgY)
        
    [h,w] = np.shape(img)
    WinSize = int(round(np.ceil(5*si)/2.0)*2+1)
    WShalf = int(WinSize/2)
    R = np.zeros((h,w))
    for i in range(WShalf+1,w - WShalf -1):
        for j in range(WShalf+1,h - WShalf -1):
            C = np.zeros((2,2))
            Ix = imgX[j - WShalf : j + WShalf, i - WShalf : i + WShalf]
            Iy = imgY[j - WShalf : j + WShalf, i - WShalf : i + WShalf]
            C[0,0] = np.square(Ix).sum()
            C[0,1] = np.multiply(Ix,Iy).sum()
            C[1,0] = C[0,1]
            C[1,1] = np.square(Iy).sum()

            if np.linalg.matrix_rank(C) == 2:
#                R[j,i] = np.linalg.det(C) + k * np.trace(C)
                r = np.linalg.det(C) / (np.trace(C)**2)
                if r > 0:
                    R[j,i] = r
    # Assign threshold as the mean of non-zero values in R
    threshold  = k * R[np.nonzero(R)].mean()
    Z = np.zeros((h,w))
    Z[np.where(R > threshold)] = 1
    
    if debug == 1:
        implt(Z)
                
    return Z

def implt(img, cmap = 'gray'):
    plt.figure()
    plt.imshow(img, cmap = cmap, interpolation = 'bicubic')
    plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
    plt.show()

#@numba.jit(nopython=True, parallel=True)    
def SSD(R1,R2, N = 30, k = 0.01, debug = 0):
    [h1,w1] = R1.shape
    [h2,w2] = R2.shape
#    cor = np.zeros((1,5))
    counter = 0
    Nh = int(N/2)
    for i in range( Nh + 1, h1 - Nh - 1):
        for j in range(Nh + 1, w1 - Nh - 1):
            if R1[i,j]==1:
                patch1 = R1[i - Nh:i+Nh, j- Nh : j + Nh]
                for l in range( Nh + 1, h2 - Nh - 1):
                    for m in range(Nh + 1, w2 - Nh - 1):
                        if R2[l,m] == 1:
                            patch2 = R2[l - Nh:l+Nh, m- Nh : m + Nh]
                            ssd = np.square((patch1 - patch2)).sum()
                            if ssd <= 5:
                                if counter == 0:
                                    cor = np.array([ssd,i,j,l,m])
                                else:
                                    cor = np.concatenate((cor,np.array([ssd,i,j,l,m])),axis = 0)
                                counter += 1
                                if debug == 1:
                                    print("i = " , i)
                                    print("j = " , j)
                                    print("l = " , l)
                                    print("m = " , m)
                                    print("counter = ",counter)
    print("counter = ",counter) 
#    threshold  = k * cor[:,1].mean()
#    COR = cor[np.where(cor[:,0]>threshold)]
#    
    cor  = cor[(-cor[:,0]).argsort()[int(np.floor(k*counter))]]
    return cor

#@numba.jit(nopython=True, parallel=True) 
def imMatch(im1,im2,cor):
    print("Matching")
    [h1,w1,c1] = im1.shape
    [h2,w2,c2] = im2.shape
    img = np.concatenate((im1, im2), axis=1)
    for item in cor:
        # Draw a diagonal blue line with thickness of 5 px
        img = cv2.line(img,(item[1],item[2]),(item[3],item[4]+w1),(255,0,0),5)
    plt.figure()
    plt.imshow(img)
    plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
    plt.show()


# Load images cv2.imread is BGR
imp1a = cv2.imread(".\\HW4Pics\\pair1\\1.jpg")
imp1b = cv2.imread(".\\HW4Pics\\pair1\\2.jpg")
#imp2a = cv2.imread(".\\HW4Pics\\pair2\\truck1.jpg")
#imp2b = cv2.imread(".\\HW4Pics\\pair2\\truck2.jpg")

# Transfer Images to grayscale
i1a = cv2.cvtColor(imp1a, cv2.COLOR_BGR2GRAY)
i1b = cv2.cvtColor(imp1b, cv2.COLOR_BGR2GRAY)
#i2a = cv2.cvtColor(imp2a, cv2.COLOR_BGR2GRAY)
#i2b = cv2.cvtColor(imp2b, cv2.COLOR_BGR2GRAY)

Ci1a = HCD(i1a)
Ci1b = HCD(i1b)
COR1 = SSD(Ci1a,Ci1b)
imMatch(imp1a,imp1b,COR1)