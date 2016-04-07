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

    def __enter__(self):
        return self
    
    def __exit__(self, type, value, traceback):
        self.close()
        
    def close(self):
        self.upcam.close()
        self.downcam.close()
        self.disconnect()
        
    def startpump(self):
        self.p.send_now("M400")
        self.p.send_now("M42 P57 S255")
        
    def stoppump(self):
        self.p.send_now("M400")
        self.p.send_now("M42 P57 S0")
        
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
        
    def pick(self,h=49.5):
        self.startpump()
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        self.p.send_now("G1 Z%f F1000"%(h,))
        self.grabpart()
        self.p.send_now("G1 Z%f F1000"%(h-10,))
        
    def place(self,h=49.5,stoppump=True):
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        self.p.send_now("G1 Z%f F1000"%(h,))
        self.droppart()
        if(stoppump):
            self.stoppump()
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        
    def pp_direct(self,start=(100,100),end=(200,200),h1=49.5,h2=49.5,rot=90):
        self.p.send_now("G1 Z%f F2000"%(min(h1,h2)-10,))
        self.p.send_now("G1 X%f Y%f E0 F15000"%start)
        self.pick(h=h1)
        self.p.send_now("G1 Z%f E%f F2000"%(min(h1,h2)-10,rot+15))
        self.p.send_now("G1 X%f Y%f E%f F15000"%(end[0],end[1],rot))
        self.place(h=h2)
    
    def pickfrom(self,pos=(100,100),h=49.5):
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        self.p.send_now("G1 X%f Y%f E0 F15000"%pos)
        self.pick(h=h1)
        
    def placeat(self, pos=(100,100), h=49.5, rot=90):
        self.p.send_now("G1 Z%f F2000"%(h-10,))
        self.p.send_now("G1 Z%f E%f F2000"%(h-10,rot+15))
        self.p.send_now("G1 X%f Y%f E%f F15000"%(pos[0],pos[1],rot))
        self.place(h=h)
        
        
    def home(self):
        self.p.send_now("G28")
        
    def moveto(self, x=None, y=None, z=None, r=None, f=15000):
        if(x is None and y is None and z is None and r is None):
            return
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
        
    def picktocam(self,pos=(100,100),h1=49.5,rot=90,h2=30):
        self.pickfrom(pos,h1)
        self.p.send_now("G1 Z%f E%f F2000"%(min(h1,h2)-10,rot+15))
        self.p.send_now("G1 X%f Y%f E%f F15000"%(self.camerapos[0],self.camerapos[1],rot))
        self.sync()
        
    def downpic(self):
        self.sync()
        self.downcam.flag=1
        while(self.downcam.flag):
            time.sleep(0.1)
        return (self.downcam.imgno, self.downcam.img)
    
    def uppic(self):
        self.sync()
        self.upcam.flag=1
        while(self.upcam.flag):
            time.sleep(0.1)
        return (self.upcam.imgno, self.upcam.img)
        
        
