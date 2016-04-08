import printcore
import time
import cv2
import threading
import picamera
import picamera.array
import io
import numpy as np

class usbcam:
    def __init__(self, camid):
        self.img=None
        self.camid=camid
        self.seqno=0
        self.imgno=0
        self.stream=cv2.VideoCapture(camid)
        self.stop=0
        self.flag=0
        self.thread=threading.Thread(target=self.grabimg)
        self.thread.start()
    
    def close(self):
        self.stop=1
    
    def grabimg(self):
        while(not self.stop):
            i=self.stream.read()
            if i[0]:
                self.seqno+=1
                if(self.flag):
                    self.img=i[1]
                    self.imgno=self.seqno
                    self.flag=0
        self.stream.release()
        
class rpicam:
    def __init__(self):
        self.img=None
        self.camid=-1
        self.seqno=0
        self.imgno=0
        self.stream=picamera.PiCamera()
        self.stream.resolution=(2592,1944)
        self.stop=0
        self.flag=0
        self.thread=threading.Thread(target=self.grabimg)
        self.thread.start()
    
    def close(self):
        self.stop=1
    
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
        self.camrot=77
        self.camstep=111

    def __enter__(self):
        return self
    
    def __exit__(self, type, value, traceback):
        self.close()
        
    def close(self):
        self.upcam.close()
        self.downcam.close()
        self.p.disconnect()
        
    def startpump(self):
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
        self.p.send_now("M42 P10 S0")
        
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
        self.moveto(x-self.camoffset[0],y-self.camoffset[1],z,r,f)
        
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
        self.sync()
        
    def downpic(self):
        self.sync()
        self.downcam.flag=1
        while(self.downcam.flag):
            time.sleep(0.1)
        return (self.downcam.imgno, self.downcam.img)
        
    def downpicrot(self,rot=77,size=111,cross=True):
        xdiff=size
        im=self.downpic()[1]
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
        
    def uppic(self):
        self.sync()
        self.upcam.flag=1
        while(self.upcam.flag):
            time.sleep(0.1)
        return (self.upcam.imgno, self.upcam.img)
        
    def map(self, xstart=220, ystart=240, xsize=140, ysize=340, step=5, camstep=None, rot=None):
        if camstep is None:
            camstep=self.camstep
        if rot is None:
            rot=self.camrot
        self.home("Z")
        target=np.zeros((xsize/step*camstep,ysize/step*camstep,3),np.uint8)
        for i in xrange(xsize/step):
            x=xstart+i*step
            for j in xrange(ysize/step):
                y=ystart+j*step
                self.movecamto(x,y)
                im=self.downpicrot(rot,camstep)
                target[j*camstep:(j+1)*camstep, i*camstep:(i+1)*camstep]=im
        return target
                
                
        
