# -*- coding: utf-8 -*-
"""
Created on Mon Sep  3 23:47:44 2018

@author: Super
"""

import cv2
import numpy as np
import math

im1a = cv2.imread(".\\PicsHw2\\1.jpg")
im1d = cv2.imread(".\\PicsHw2\\jackie.jpg")

# Homogeneous points obtained from gimp
PQRS1a = np.array([[171,1517,1],[721,2954,1],[2239,1485,1],[2051,3003,1]])
PQRS1d = np.array([[0,0,1],[0,1280,1],[720,0,1],\
                   [720,1280,1]])
# Finding Homography A of Ax=b
def Homography(points_src,points_dest):
    Mat_A=np.zeros((8,8))
    b = np.zeros((1,8))
    if points_src.shape[0] != points_dest.shape[0] or points_src.shape[1]\
        != points_dest.shape[1]:
        print( "No. of Source and destination points donot match")
        exit(1)
    for i in range(0,len(points_src)):
        Mat_A[i*2]=[points_src[i][0],points_src[i][1],points_src[i][2],\
        0,0,0,(-1*points_src[i][0]*points_dest[i][0]),(-1*points_src[i][1]*points_dest[i][0])]
        Mat_A[i*2+1]=[0,0,0,points_src[i][0],points_src[i][1],points_src[i][2],(-1*points_src[i][0]*points_dest[i][1]),(-1*points_src[i][1]*points_dest[i][1])]
        b[0][i*2] = points_dest[i][0]
        b[0][i*2+1] = points_dest[i][1]
    # A, b matrix formed
    # if no. of points is not 4 then using the below code
    tmp_H=np.dot(np.linalg.pinv(Mat_A),b.T)
    homography= np.zeros((3,3))
    homography[0]= tmp_H[0:3,0]
    homography[1]= tmp_H[3:6,0]
    homography[2][0:2]= tmp_H[6:8,0]
    homography[2][2]= 1
    return homography

# image mapping code starts here
def image_mapping(src_image,dest_image,points_src,Homography):
    tmp_srcimage=np.zeros((src_image.shape[0],src_image.shape[1],3),  dtype='uint8')
    pts = np.array([[points_src[0][1],points_src[0][0]],[points_src[1][1],points_src[1][0]],[points_src[3][1],points_src[3][0]],[points_src[2][1],points_src[2][0]]])
    cv2.fillPoly(tmp_srcimage,[pts],(255,255,255))
    for i in range(0,(src_image.shape[0]-1)):
        for j in range(0,(src_image.shape[1]-1)):
            if tmp_srcimage[i,j,1]==255 and tmp_srcimage[i,j,0]==255 and \
                tmp_srcimage[i,j,2]==255:
                point_tmp = np.array([i, j, 1])
                trans_coord = np.array(np.dot(Homography,point_tmp))
                trans_coord = trans_coord/trans_coord[2]
                if (trans_coord[0]>0) and (trans_coord[0]< dest_image.shape[0]) \
                and (trans_coord[1]>0) and (trans_coord[1]<dest_image.shape[1]):
                    src_image[i][j]=dest_image [math.floor(trans_coord[0]),
                    math.floor(trans_coord[1])]
                else:
                    continue
    return src_image

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

            
H=Homography(PQRS1a,PQRS1d)
H2 = findH(PQRS1d.T,PQRS1a.T)
output=image_mapping(im1a,im1d,PQRS1a,H)
cv2.imwrite('final_image1.jpg',output)
print(H)
print(H2)