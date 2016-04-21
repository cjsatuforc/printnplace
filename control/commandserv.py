import printcore
import time
import cv2
import picamera
import picamera.array
import io
import numpy as np
import math

class usbcam:
    def __init__(self, camid):
        #self.image=None
        self.camid=camid
        self.stream=None
        self.isopen=False
        #self.open()
        
    def open(self):
        self.stream=cv2.VideoCapture(self.camid)
        self.isopen=True
        
    def close(self):
        self.stream.release()
        self.isopen=False
    
    def img(self):
        i=self.stream.read()
        if i[0]:
            return i[1][:]
        else:
            return None
"""
    def grabimg(self):
        while(not self.stop):
            i=self.stream.read()
            if i[0]:
                self.seqno+=1
                if(self.resetafter>1):
                    self.resetafter=self.resetafter-1
                if(self.flag):
                    self.img=i[1]
                    self.imgno=self.seqno
                    self.flag=0
                if self.resetafter==1:
                    self.stream.release()
                    self.open()
                    return
        self.stream.release()
"""
        
class rpicam:
    def __init__(self):
        self.image=None
        self.stream=None
        self.imgstream=None
        self.isopen=False
        #self.open()
        
    def open(self,res=(2592,1944),crop=(.1,.1,.8,.8)):
        self.stream=picamera.PiCamera()
        self.stream.resolution=res
        self.stream.crop=crop
        self.imgstream=picamera.array.PiRGBArray(self.stream)
        self.isopen=True
        
    def close(self):
        self.imgstream.close()
        self.stream.close()
        self.isopen=False
    
    def img(self,usevideoport=False):
        self.stream.capture(self.imgstream,format="bgr",use_video_port=usevideoport)
        self.image=imgstream.array[:]
        return self.image
        
            
    """
    def grabimg(self):
        while not self.stop:
            with picamera.array.PiRGBArray(self.stream) as imgstream:
                self.stream.capture(imgstream,format="bgr")
                if self.stop:
                    break;
                self.seqno+=1
                if(self.flag):
                    self.img=imgstream.array[:]
                    self.imgno=self.seqno
                    self.flag=0
        self.stream.close()
    """


def rotpoint(point,center,rot):
    rads=math.radians(rot)
    r=[point[0]-center[0],point[1]-center[1]]
    return int(center[0]+math.cos(rads)*r[0]-math.sin(rads)*r[1]),int(center[1]+math.sin(rads)*r[0]+math.cos(rads)*r[1])

class part:
    def __init__(self, name="0603", size=(1.6,0.8,0.5)):
        self.name=name
        self.size=size

class commandserv:
    def __init__(self,port="/dev/ttyACM0",baud=115200):
        self.p=printcore.printcore()
        self.p.connect(port,baud)
        self.camerapos=(300,300)
        self.downcam=usbcam(0)
        self.upcam=rpicam()
        self.pumpon=0
        self.defaulth=42
        self.camoffset=(15.3,40.1)
        self.pinoffset=(0,0)
        self.blcomp=0.5
        self.upcamrot=90
        self.upcamillum=127
        self.camrot=77
        self.camstep=111
        self.parts={}
        self.parts["0603"]=part("0603",(1.6,0.8,0.5))

    def __enter__(self):
        return self
    
    def __exit__(self, type, value, traceback):
        self.close()
        
    def close(self):
        self.p.disconnect()
        if(self.upcam.isopen):
            self.upcam.close()
        if(self.downcam.isopen):
            self.downcam.close()
        
    def startpump(self):
        self.p.send_now("M42 P10 S0")
        if self.pumpon:
            return
        self.p.send_now("M400")
        self.p.send_now("M42 P57 S255")
        self.p.send_now("G4 P50")
        self.p.send_now("M400")
        self.pumpon=1
        
    def stoppump(self):
        self.p.send_now("M400")
        self.p.send_now("M42 P57 S0")
        self.pumpon=0;
        
    def grabpart(self):
        self.p.send_now("M42 P10 S0")
        self.p.send_now("M106")
        self.p.send_now("M400")
        self.p.send_now("G4 P50")

    def droppart(self):
        self.p.send_now("M400")
        self.p.send_now("M107")
        self.p.send_now("M42 P10 S255")
        self.p.send_now("G4 P50")
        
        
    def pick(self,h=None):
        if h is None:
            h=self.defaulth
        self.startpump()
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        self.p.send_now("G1 Z%f F1000"%(h,))
        self.grabpart()
        self.p.send_now("G1 Z%f F1000"%(h-10,))
        
    def place(self,h=None,stoppump=True):
        if h is None:
            h=self.defaulth
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        self.p.send_now("G1 Z%f F1000"%(h,))
        self.droppart()
        if(stoppump):
            self.stoppump()
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        if(not stoppump):
            self.p.send_now("M42 P10 S0")
        
    def pp_direct(self,start=(100,100),end=(200,200),h1=None,h2=None,rot=90):
        if h1 is None:
            h1=self.defaulth
        if h2 is None:
            h2=self.defaulth
        self.p.send_now("G1 Z%f F2000"%(min(h1,h2)-10,))
        self.p.send_now("G1 X%f Y%f E0 F15000"%(start[0]-self.blcomp,start[1]-self.blcomp))
        self.p.send_now("G1 X%f Y%f E0 F15000"%start)
        self.pick(h=h1)
        self.p.send_now("G1 Z%f E%f F2000"%(min(h1,h2)-10,rot+15))
        self.p.send_now("G1 X%f Y%f E%f F15000"%(end[0]-self.blcomp,end[1]-self.blcomp,rot))
        self.p.send_now("G1 X%f Y%f E%f F15000"%(end[0],end[1],rot))
        self.place(h=h2)
    
    def pickfrom(self,pos=(100,100),h=None):
        if h is None:
            h=self.defaulth
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        self.p.send_now("G1 X%f Y%f E0 F15000"%(pos[0]-self.blcomp,pos[1]-self.blcomp))
        self.p.send_now("G1 X%f Y%f E0 F15000"%pos)
        self.pick(h=h1)
        
    def placeat(self, pos=(100,100), h=None, rot=90):
        if h is None:
            h=self.defaulth
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        self.p.send_now("G1 Z%f E%f F2000"%(h-10,rot+15))
        self.p.send_now("G1 X%f Y%f E%f F15000"%(pos[0]-self.blcomp,pos[1]-self.blcomp,rot))
        self.p.send_now("G1 X%f Y%f E%f F15000"%(pos[0],pos[1],rot))
        self.place(h=h)
        
        
    def home(self, param=None):
        command="G28"
        if param is not None:
            command+=" "+param
        self.p.send_now(command)
        
    def movecamto(self, x, y, z=None, r=None, f=15000):
        self.moveto(x+self.camoffset[0],y+self.camoffset[1],z,r,f)
        self.p.send_now("M400")
        self.p.send_now("G4 P100")
        self.p.send_now("M400")
        
    def moveto(self, x=None, y=None, z=None, r=None, f=15000):
        if(x is None and y is None and z is None and r is None):
            return
        command="G1 "
        if(x is not None): command += "X%f "%(x-self.blcomp,)
        if(y is not None): command += "Y%f "%(y-self.blcomp,)
        if(z is not None): command += "Z%f "%(z,)
        if(r is not None): command += "E%f "%(r,)
        command+="F%d"%(f,)
        self.p.send_now(command)
        command="G1 "
        if(x is not None): command += "X%f "%(x,)
        if(y is not None): command += "Y%f "%(y,)
        if(z is not None): command += "Z%f "%(z,)
        if(r is not None): command += "E%f "%(r,)
        command+="F%d"%(f,)
        self.p.send_now(command)
        
    def sync(self):
        self.p.send_now("M400")
        self.p.send_now("M400")
        if not self.p.priqueue.empty(): self.p.priqueue.join()
        
    def picktocam(self,pos=(100,100),h1=None,rot=90,h2=None):
        if h1 is None:
            h1=self.defaulth
        if h2 is None:
            h2=self.defaulth
        self.pickfrom(pos,h1)
        self.p.send_now("G1 Z%f E%f F2000"%(min(h1,h2)-10,rot+15))
        self.p.send_now("G1 X%f Y%f E%f F15000"%(self.camerapos[0]-self.blcomp,self.camerapos[1]-self.blcomp,rot))
        self.p.send_now("G1 X%f Y%f E%f F15000"%(self.camerapos[0],self.camerapos[1],rot))
        self.p.send_now("G4 P100")
        self.sync()
        
    def downpic(self):
        if(not self.downcam.isopen):
            self.downcam.open()
        self.sync()
        return self.downcam.img()
    
    def downpicrot(self,rot=None,size=None,cross=True):
        if size is None:
            size=self.camstep
        if rot is None:
            rot=self.camrot
        xdiff=size
        im=self.downpic()
        if im is None:
            return None
        m=cv2.getRotationMatrix2D(((640)/2,(480)/2),rot,1.0)
        imr=cv2.warpAffine(im,m,(640,480))
        imroi=imr[(640-xdiff)/2+0:(640-xdiff)/2+xdiff+0,(480-xdiff)/2+60:(480-xdiff)/2+xdiff+60]
        dims=imroi.shape
        if cross:
            cv2.line(imroi,(dims[1]/2,0),(dims[1]/2,dims[0]-1),(0,0,255))
            cv2.line(imroi,(0,dims[0]/2),(dims[1]-1,dims[0]/2),(0,0,255))
        return imroi
        
    def uppicrot(self,rot=None,cross=True):
        if rot is None:
            rot=self.upcamrot
        xdiff=size
        im=self.downpic()
        if im is None:
            return None
        odims=im.shape
        m=cv2.getRotationMatrix2D(((odims[1])/2,(odims[0])/2),rot,1.0)
        imr=cv2.warpAffine(im,m,(odims[1],odims[0]))
        imroi=imr# [(odims[1]-xdiff)/2+0:(odims[1]-xdiff)/2+xdiff+0,(odims[0]-xdiff)/2+60:(odims[0]-xdiff)/2+xdiff+60]
        dims=imroi.shape
        if cross:
            cv2.line(imroi,(dims[1]/2,0),(dims[1]/2,dims[0]-1),(0,0,255))
            cv2.line(imroi,(0,dims[0]/2),(dims[1]-1,dims[0]/2),(0,0,255))
        return imroi
        
    def drawpartroi(self,image,part=None,pixscale=None,center=None,rot=0,cross=False):
        if part is None:
            part=self.parts["0603"]
        if(part is not None):
            partsize=part.size
        else:
            return
        if pixscale is None:
            pixscale=self.camstep/5.
        dims=image.shape
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
        
        
    def savedprot(self, filename, rot=None, size=None, cross=True):
        cv2.imwrite(filename,self.downpicrot(rot,size,cross))
    
    def saveuprot(self, filename, rot=None, cross=True):
        cv2.imwrite(filename,self.uppicrot(rot,cross))
        
    def uppic(self,illum=None):
        if illum is None:
            illum=self.upcamillum
        self.p.send_now("M42 P8 S%d" % illum)
        if(not self.downcam.isopen):
            self.downcam.open()
        self.sync()
        return self.upcam.img()
        self.p.send_now("M42 P8 S0")
        
        
    def saveuppic(self, filename):
        cv2.imwrite(filename,self.uppic())
        
    def map(self, xstart=270, ystart=240, xsize=70, ysize=170, step=5, camstep=None, rot=None):
        if camstep is None:
            camstep=step*self.camstep/5
        if rot is None:
            rot=self.camrot
        self.home("Z")
        target=np.zeros(((xsize/step)*camstep,(ysize/step)*camstep,3),np.uint8)
        for i in xrange(xsize/step):
            x=xstart+i*step
            for j in xrange(ysize/step):
                y=ystart+j*step
                invj=ysize/step-j-1
                self.movecamto(x,y)
                im=self.downpicrot(rot,camstep)
                target[i*camstep:(i+1)*camstep, invj*camstep:(invj+1)*camstep]=im
        self.downca
        return target
    
    def savemap(filename, xstart=270, ystart=240, xsize=70, ysize=170, step=5, camstep=None, rot=None):
        cv2.imwrite(filename, self.map(xstart, ystart, xsize, ysize, step, camstep, rot))
        
