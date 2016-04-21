import cv2
import numpy as np
import math

xdiff=111
rot=77
tiles=9
target=None

c0603=cv2.imread("0603.png")
c0402=cv2.imread("0402.png")

components=[
(162, 162, 0, c0603),
(34, 317, 90, c0603),
(28, 473, 90, c0603),
(505, 361, 0, c0402),
(663, 356, 0, c0402),
(791, 303, 0, c0603),
(792, 258, 0, c0402),
(476, 80, 90, c0402),
(985, 465, 90,c0603),
]

class part:
    def __init__(self, name="0603", size=(1.6,0.8,0.5)):
        self.name=name
        self.size=size


parts={}
parts["0603"]=part("0603",(1.6,0.8,0.5))


def rotpoint(point,center,rot):
    rads=math.radians(rot)
    r=[point[0]-center[0],point[1]-center[1]]
    return int(center[0]+math.cos(rads)*r[0]-math.sin(rads)*r[1]),int(center[1]+math.sin(rads)*r[0]+math.cos(rads)*r[1])

def drawpartroi(image,part=None,pixscale=22.2,center=None,rot=30,cross=False):
        if part is None:
            part=parts["0603"]
        if(part is not None):
            partsize=part.size
        else:
            return
        dims=image.shape
        rot=rot%360
        if center is None:
            center=(image.shape[1]/2.,image.shape[0]/2.)
        start=((center[0]-partsize[0]*pixscale/2.),(center[1]-partsize[1]*pixscale/2.))
        end=((center[0]+partsize[0]*pixscale/2.),(center[1]+partsize[1]*pixscale/2.))
        cv2.line(image,rotpoint(start,center,rot),rotpoint((start[0],end[1]),center,rot),(0,0,255))
        cv2.line(image,rotpoint(start,center,rot),rotpoint((end[0],start[1]),center,rot),(0,0,255))
        cv2.line(image,rotpoint(end,center,rot),rotpoint((start[0],end[1]),center,rot),(0,0,255))
        cv2.line(image,rotpoint(end,center,rot),rotpoint((end[0],start[1]),center,rot),(0,0,255))
        if(cross):
            cv2.line(image,rotpoint((center[0],center[1]-partsize[1]*pixscale),center,0),rotpoint((center[0],center[1]+partsize[1]*pixscale),center,0),(0,0,255))    
            cv2.line(image,rotpoint((center[0]-partsize[0]*pixscale,center[1]),center,0),rotpoint((center[0]+partsize[0]*pixscale,center[1]),center,0),(0,0,255))    
            cv2.line(image,rotpoint((center[0],center[1]-partsize[0]*pixscale),center,0),rotpoint((center[0],center[1]+partsize[0]*pixscale),center,0),(0,0,255))    
            cv2.line(image,rotpoint((center[0]-partsize[1]*pixscale,center[1]),center,0),rotpoint((center[0]+partsize[1]*pixscale,center[1]),center,0),(0,0,255))    
        
    

def drawcomponent(component, x, y, rot, target):
    w=component.shape[1]
    h=component.shape[0]
    compdiag=int(math.sqrt(w*w + h*h)+.5)
    compimg=np.zeros((compdiag,compdiag,3),np.uint8)
    compmask=np.zeros((compdiag,compdiag,1),np.uint8)
    #compmask[:]=0
    yborder=compdiag/2-h/2
    xborder=compdiag/2-w/2
    
    compmask[yborder:yborder+h, xborder:xborder+w]=255
    compimg[yborder:yborder+h, xborder:xborder+w]=component
    m=cv2.getRotationMatrix2D((compdiag/2,compdiag/2),rot,1.0)
    troi=target[y-compdiag/2:y-compdiag/2+compdiag,x-compdiag/2:x-compdiag/2+compdiag]
    mask=cv2.warpAffine(compmask,m,(compdiag,compdiag))
    cv2.bitwise_and(troi,0,troi,mask=cv2.erode(mask,None))
    cv2.add(troi,cv2.warpAffine(compimg,m,(compdiag,compdiag)),troi,mask=cv2.erode(mask,None))
    
    drawpartroi(target,center=(x,y),rot=rot, cross=True)


def redraw():
    global target
    maxx=tiles
    maxy=tiles
    target=np.zeros((maxx*xdiff+50,maxy*xdiff+50,3),np.uint8)
    m=cv2.getRotationMatrix2D(((640)/2,(480)/2),rot,1.0)
    for x in range(maxx):
        for y in range(maxy):
            roix=target[(0+(x)*xdiff):(xdiff+(x)*xdiff),(0+(maxy-y-1)*xdiff):(xdiff+(maxy-y-1)*xdiff)]
            #print("X%dY%d.png"%(280+x*5,240+y*5))
            im=cv2.imread("../mapimages/X%dY%d.png"%(270+x*5,240+y*5))
            imr=cv2.warpAffine(im,m,(640,480))
            imroi=imr[(640-xdiff)/2+0:(640-xdiff)/2+xdiff+0,(480-xdiff)/2+60:(480-xdiff)/2+xdiff+60]
            cv2.addWeighted(roix,0.0,imroi,1.0,0,roix)
    for i in components:
        drawcomponent(i[3],i[0],i[1],i[2],target)
        
    cv2.imshow('test',target)

def xdcb(val):
    global xdiff
    xdiff=val
    redraw()
def rotcb(val):
    global rot
    rot=val
    redraw()
def tilescb(val):
    global tiles
    tiles=val
    redraw()

def onMouse(event, x, y, a=None, b=None):
    if event==cv2.EVENT_LBUTTONUP:
        print(x,y)
    
cv2.namedWindow('test')
#cv2.createTrackbar('xdiff', 'test', xdiff, 400, xdcb)
#cv2.createTrackbar('rot', 'test', rot, 360, rotcb)
#cv2.createTrackbar('tiles', 'test', tiles, 9, tilescb)
cv2.setMouseCallback("test",onMouse)
redraw()
while(1):
    k = cv2.waitKey(0)
    if k == 27:         # wait for ESC key to exit
        cv2.imwrite("map.png",target)
        cv2.destroyAllWindows()
        break
