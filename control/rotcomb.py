import cv2
import numpy as np
import math

xdiff=111
rot=77

def redraw():
    maxx=8
    maxy=9
    target=np.zeros((640+5*xdiff,480+5*xdiff,3),np.uint8)
    m=cv2.getRotationMatrix2D(((640)/2,(480)/2),rot,1.0)
    for x in range(maxx):
        for y in range(maxy):
            roix=target[(0+(x)*xdiff):(xdiff+(x)*xdiff),(0+(maxy-y-1)*xdiff):(xdiff+(maxy-y-1)*xdiff)]
#            print("X%dY%d.png"%(280+x*5,240+y*5))
            im=cv2.imread("../mapimages/X%dY%d.png"%(280+x*5,240+y*5))
            imr=cv2.warpAffine(im,m,(640,480))
            imroi=imr[(640-xdiff)/2+0:(640-xdiff)/2+xdiff+0,(480-xdiff)/2+60:(480-xdiff)/2+xdiff+60]
            cv2.addWeighted(roix,0.0,imroi,1.0,0,roix)
    cv2.imshow('test',target)

def xdcb(val):
    global xdiff
    xdiff=val
    redraw()
def rotcb(val):
    global rot
    rot=val
    redraw()
    
    
cv2.namedWindow('test')
cv2.createTrackbar('xdiff', 'test', xdiff, 400, xdcb)
cv2.createTrackbar('rot', 'test', rot, 360, rotcb)
redraw()
while(1):
    k = cv2.waitKey(0)
    if k == 27:         # wait for ESC key to exit
        cv2.destroyAllWindows()
        break
