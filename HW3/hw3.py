# -*- coding: utf-8 -*-
"""
ECE661 Homework 3
Ye Shi
shi349@purdue.edu
"""

# Load libs
import numpy as np
import cv2
#import numba
#@numba.jit(nopython=True, parallel=True)

# Function to map image 2 to image 1 by H
def mapping(im1, im2, H, hmin = 0, wmin =0):
    [h2,w2,c2] = im2.shape
    [h1,w1,c1] = im1.shape
    iH = np.linalg.inv(H)
   
    for i in range(h1):
        for j in range(w1):
            x = np.array((i+hmin,j+wmin,1),dtype = 'l')
            y = np.matmul(iH,x.T)
            y = np.floor(y/y[2])
            y = y.astype(int)
            
            if y[0]<h2 and y[0]>=0 and y[1]<w2 and y[1]>=0:
                im1[i][j] = im2[y[0]][y[1]]   
                
# Function to find the size of transformed image
def findSize(H, h,w):
    pst =  np.array([[0,0,1],[0,w,1],[h,0,1],[h,w,1]],dtype = 'f')
    Hpst = np.matmul(H,pst.T).T
    Hpst[0] = Hpst[0]/Hpst[0][-1]
    Hpst[1] = Hpst[1]/Hpst[1][-1]
    Hpst[2] = Hpst[2]/Hpst[2][-1]
    Hpst[3] = Hpst[3]/Hpst[3][-1]
    print(Hpst)
    hmin = int(Hpst.min(axis = 0)[0])
    hmax = int(Hpst.max(axis = 0)[0])
    wmax = int(Hpst.max(axis = 0)[1])
    wmin = int(Hpst.min(axis = 0)[1])
    print([hmin,hmax,wmin,wmax])
    return [hmin,hmax,wmin,wmax]
                    
                    
# Function to project image 1 by H
def project(im1, H):
    [h,w,c] = im1.shape
    [hmin,hmax,wmin,wmax] = findSize(H, h,w) 
    imNew = np.zeros((hmax - hmin, wmax - wmin,3))
    mapping(imNew,im1, H, hmin, wmin)
    return imNew
            
# Function to find homography from corresponding points of image 1 to points of image 2
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

# Function to find homography for removing projective distrotion(Vanishing Line)
def findVLH(pst1):
    # pst1 = [P,Q,R,S] is a points set of physical rectangle object in image
    # P-----------Q
    # \    l3     \
    # \           \
    # \l1         \l2
    # \    l4     \
    # R-----------S
    l1 = np.cross(pst1[0],pst1[2])
    l2 = np.cross(pst1[1],pst1[3])
    vp1 = np.cross(l1,l2)
    l3 = np.cross(pst1[0],pst1[1])
    l4 = np.cross(pst1[2],pst1[3])
    vp2 = np.cross(l3,l4)
    vl = np.cross(vp1,vp2)
    vl = vl/vl[-1]
#    vl =  vl/np.linalg.norm(vl)
    H = np.array([[1,0,0],[0,1,0],vl])
    return H

# Function to find homography for removing affine distortion
def findADH(pst1):
    # pst1 = [P,Q,R,S] is a points set of physical rectangle object in image
    # P-----------Q
    # \    l3     \
    # \           \
    # \l1         \l2
    # \    l4     \
    # R-----------S
    # l1 and l4 are orthogonal
    # l2 and l3 are orthogonal
    # It's free to select other combinations
    l1 = np.cross(pst1[0],pst1[2])
    l1 = l1/l1[-1]
    l2 = np.cross(pst1[1],pst1[3])
    l2  = l2/l2[-1]
    l3 = np.cross(pst1[0],pst1[1])
    l3 = l3/l3[-1]
    l4 = np.cross(pst1[2],pst1[3])
    l4 = l4/l4[-1]
    # LSE Ax = b
    A = np.zeros((4,2))
    A[0][0] = l1[0]*l4[0]
    A[0][1] = l1[0]*l4[1]+l1[1]*l4[0]
    A[1][0] = l2[0]*l3[0]
    A[1][1] = l2[0]*l3[1]+l2[1]*l3[0]
    A[2][0] = l1[0]*l3[0]
    A[2][1] = l1[0]*l3[1]+l1[1]*l3[0]
    A[3][0] = l2[0]*l4[0]
    A[3][1] = l2[0]*l4[1]+l2[1]*l4[0]
#    b = np.array([[-l1[1]*l4[1]],[-l2[1]*l3[1]]],dtype = 'f')

    b = np.array([[-l1[1]*l4[1]],[-l2[1]*l3[1]],[-l1[1]*l3[1]],[-l2[1]*l4[1]]],dtype = 'f')
    x = np.matmul(np.linalg.pinv(A),b)
    # 
    S = np.array([[x[0],x[1]],[x[1],1]],dtype = 'f')
    U, s, Vh = np.linalg.svd(S, full_matrices=True)
    Aad = np.matmul(np.matmul(Vh.conj().T,np.diag(np.sqrt(s))),Vh)
#    Aad = np.matmul(np.matmul(U,np.diag(np.sqrt(s))),Vh)
#    Aad = Aad / Aad.max()
    H = np.append(Aad,[[0,0]],0)
    H = np.append(H,[[0],[0],[1]],1)
    print(H)
    return H

# Function to find homography for distortion by Dual Conic
def findDCH(pst1):
    # pst1 = [P,Q,R,S,T,U,V] is a points set of physical rectangle object in image
    # P-----------Q
    # \    l3     \
    # \           \
    # \l1         \l2
    # \    l4     \
    # R-----------S
    # T-----------U
    # \    l5
    # \
    # \l6
    # \
    # V
        # l1 and l4 are orthogonal
    # l1 and l3 ...
    # l2 and l3 are orthogonal
    # l2 and l4 ...
    # l5 and l6 are orthogonal
    # take the middle of the rectangle as the 5th cross
    # It's free to select other combinations
    l1 = np.cross(pst1[0],pst1[2])
#    l1 = l1/l1[-1]
    l2 = np.cross(pst1[1],pst1[3])
#    l2  = l2/l2[-1]
    l3 = np.cross(pst1[0],pst1[1])
#    l3 = l3/l3[-1]
    l4 = np.cross(pst1[2],pst1[3])
#    l4 = l4/l4[-1]
    l5 = np.cross(pst1[4],pst1[5])
#    l5 = l5/l5[-1]
    l6 = np.cross(pst1[4],pst1[6])
#    l6 = l6/l6[-1]

    # LSE Ax = b
    A = np.zeros((5,5))
    A[0][0] = l1[0]*l4[0]
    A[0][1] = 0.5*(l1[0]*l4[1]+l1[1]*l4[0])
    A[0][2] = l1[1]*l4[1]
    A[0][3] = 0.5*(l1[0]*l4[2]+l1[2]*l4[0])
    A[0][4] = 0.5*(l1[1]*l4[2]+l1[2]*l4[1])
    
    A[1][0] = l1[0]*l3[0]
    A[1][1] = 0.5*(l1[0]*l3[1]+l1[1]*l3[0])
    A[1][2] = l1[1]*l3[1]
    A[1][3] = 0.5*(l1[0]*l3[2]+l1[2]*l3[0])
    A[1][4] = 0.5*(l1[1]*l3[2]+l1[2]*l3[1])
    
    A[2][0] = l2[0]*l3[0]
    A[2][1] = 0.5*(l2[0]*l3[1]+l2[1]*l3[0])
    A[2][2] = l2[1]*l3[1]
    A[2][3] = 0.5*(l2[0]*l3[2]+l2[2]*l3[0])
    A[2][4] = 0.5*(l2[1]*l3[2]+l2[2]*l3[1])
    
    A[3][0] = l2[0]*l4[0]
    A[3][1] = 0.5*(l2[0]*l4[1]+l2[1]*l4[0])
    A[3][2] = l2[1]*l4[1]
    A[3][3] = 0.5*(l2[0]*l4[2]+l2[2]*l4[0])
    A[3][4] = 0.5*(l2[1]*l4[2]+l2[2]*l4[1])
    
    A[4][0] = l5[0]*l6[0]
    A[4][1] = 0.5*(l5[0]*l6[1]+l5[1]*l6[0])
    A[4][2] = l5[1]*l6[1]
    A[4][3] = 0.5*(l5[0]*l6[2]+l5[2]*l6[0])
    A[4][4] = 0.5*(l5[1]*l6[2]+l5[2]*l6[1])
    
    print(A)
    b = np.zeros((5,1))
    b[0] = - l1[2]*l4[2]
    b[1] = - l1[2]*l3[2]
    b[2] = - l2[2]*l3[2]
    b[3] = - l2[2]*l4[2]
    b[4] = - l5[2]*l6[2]
    
    x = np.matmul(np.linalg.pinv(A),b)
    x = x/np.max(x)
    print(x)
    S = np.zeros((2,2))
    S[0][0] = x[0]
    S[0][1] = x[1]*0.5
    S[1][0] = x[1]*0.5
    S[1][1] = x[2]
    U, s, Vh = np.linalg.svd(S, full_matrices=1)
    print("U",U, "s",s,"Vh", Vh)
    Adc = np.matmul(np.matmul(Vh.conj().T,np.diag(np.sqrt(s))),Vh)
    v = np.matmul( np.array([x[3]*0.5, x[4]*0.5]).T, np.linalg.inv(Adc.T))
    H = np.append(Adc,v,0)
    H = np.append(H,[[0],[0],[1]],1)
    print(H)
    return H
    
# Import Images
im1 = cv2.imread(".\\HW3Pics\\1.jpg")
im2 = cv2.imread(".\\HW3Pics\\2.jpg")
imB = cv2.imread("BRNG.jpg")
imM = cv2.imread("ME.jpg")

# Grip points from images by order in PQRS with HC
PQRS1a = np.array([[817,1141,1],[762,1257,1],[995,1125,1],[947,1242,1]],dtype = 'f') 
#PQRS1a = np.array([[1113,233,1],[24,2214,1],[1752,107,1],[1401,2340,1]],dtype = 'f')  
PQRS1w = np.array([[0,0,1],[0,60,1],[80,0,1],[80,60,1]],dtype = 'f') # Given from HW3WorldCoords
PQRS2a = np.array([[71,247,1],[82,326,1],[270, 245,1],[266,323,1]],dtype = 'f') # Marked by GIMP
PQRS2w = np.array([[0,0,1],[0,100,1],[200,0,1],[200,100,1]],dtype = 'f') # Given from HW3WorldCoords

PQRSEa = np.array([[660,333,1],[720,512,1],[1280,172,1],[1337,454,1]],dtype = 'f')# Given from HW3WorldCoords
PQRSEw = np.array([[0,0,1],[0,100,1],[250,0,1],[250,100,1]],dtype = 'f') # Given from HW3WorldCoords
PQRSTa = np.array([[540,1313,1],[472,1601,1],[855,1303,1],[832,1599,1]],dtype = 'f') # Given from HW3WorldCoords
PQRSTw = np.array([[0,0,1],[0,150,1],[100,0,1],[100,150,1]],dtype = 'f') # Given from HW3WorldCoords

PQRSBa = np.array([[146,611,1],[782,828,1],[989,57,1],[1430,581,1]],dtype = 'f')# Given from HW3WorldCoords
PQRSBw = np.array([[0,0,1],[0,400,1],[400,0,1],[400,400,1]],dtype = 'f') # Given from HW3WorldCoords
PQRSMa = np.array([[471,511,1],[305,911,1],[1017,461,1],[1008,872,1]],dtype = 'f') # Given from HW3WorldCoords
PQRSMw = np.array([[0,0,1],[0,200,1],[200,0,1],[200,200,1]],dtype = 'f') # Given from HW3WorldCoords

# Part 1 Using Point-to-Point Correspondences
# Find homographies
#H1aw = findH(PQRS1w.T,PQRS1a.T)
#cv2.imwrite('1pp.jpg',project(im1, H1aw))
#
H2aw = findH(PQRS2w.T,PQRS2a.T)
cv2.imwrite('2pp.jpg',project(im2, H2aw))

#HBaw = findH(PQRSBw.T,PQRSBa.T)
#cv2.imwrite('Bpp.jpg',project(imB, HBaw))
#
#HMaw = findH(PQRSMw.T,PQRSMa.T)
#cv2.imwrite('Mpp.jpg',project(imM, HMaw))
#
#
## Part 2 2-Step Method
#H1vl = findVLH(PQRS1a)
#cv2.imwrite('1ts1.jpg',project(im1, H1vl))
#H1ad = findADH(np.matmul(H1vl,PQRS1a.T).T)
#H1ts = np.matmul(np.linalg.inv(H1ad),H1vl)
#cv2.imwrite('1ts2.jpg',project(im1, H1ts))
#
#
#H2vl = findVLH(PQRS2a)
#cv2.imwrite('2ts1.jpg',project(im2, H2vl))
#H2ad = findADH(np.matmul(H2vl,PQRS2a.T).T)
#H2ts =  np.matmul(np.linalg.inv(H2ad),H2vl)
#cv2.imwrite('2ts2.jpg',project(im2, H2ts))
#
#z = 0.2
#Hz = np.array([[z,0,0],[0,z,0],[0,0,1]],dtype = 'f')
#
#HBvl = findVLH(PQRSBa)
#HBvlz = np.matmul(Hz,HBvl)
#cv2.imwrite('Bts1.jpg',project(imB, HBvlz))
#HBad = findADH(np.matmul(HBvl,PQRSBa.T).T)
#HBts =  np.matmul(np.linalg.inv(HBad),HBvl)
#HBts = np.matmul(Hz,HBts)
#
#cv2.imwrite('Bts2.jpg',project(imB, HBts))
#
#HMvl = findVLH(PQRSMa)
##HMvl = np.matmul(Hz,HMvl)
#cv2.imwrite('Mts1.jpg',project(imM, HMvl))
#HMad = findADH(np.matmul(HMvl,PQRSMa.T).T)
#HMts =  np.matmul(np.linalg.inv(HMad),HMvl)
#cv2.imwrite('Mts2.jpg',project(imM,HMts))



# Part 3 1-step Method
#PQRS1b = np.append(PQRS1a, [[775,1045,1],[723,1150,1],[863,1036,1]],axis = 0 )
#H1dc = findDCH(PQRS1b)
#cv2.imwrite('1os.jpg',project(im1,np.linalg.inv(H1dc)))
#
#PQRS2b = np.append(PQRS2a, [[57,237,1],[72,339,1],[284,236,1]],axis = 0 )
#H2dc = findDCH(PQRS2b)
#cv2.imwrite('2os.jpg',project(im2,np.linalg.inv(H2dc)))

z = 1
Hz = np.array([[z,0,0],[0,z,0],[0,0,1]],dtype = 'f')

#PQRSBa = np.array([[601,598,1],[664,627,1],[771,510,1],[830,545,1]],dtype = 'f')# Given from HW3WorldCoords
#
#PQRSBb = np.append(PQRSBa, [[1000,645,1],[845,707,1],[1037,668,1]],axis = 0 )
#HBdc = findDCH(PQRSBb)
#HBdc = np.matmul(Hz,np.linalg.inv(HBdc))
#cv2.imwrite('Bos.jpg',project(imB,HBdc))

#PQRSMb = np.append(PQRSMa, [[440,497,1],[1058,439,1],[240,954,1]],axis = 0 )
#HMdc = findDCH(PQRSMb)
##HMdc = np.matmul(Hz, np.linalg.inv(HMdc))
#HMdc = np.linalg.inv(HMdc)
#cv2.imwrite('Mos.jpg',project(imM,HMdc))