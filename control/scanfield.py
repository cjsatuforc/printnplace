import cv2
import printcore
import time
import threading




flag=0
img=None
stop=0
def grabimg():
	global img
	global flag
	stream=cv2.VideoCapture(0)
	while(not stop):
		i=stream.read()
		if i[0] and flag:
			img=i[1]
			flag=0
	stream.release()
	
p=printcore.printcore()
p.loud=True
threading.Thread(target=grabimg).start()
p.connect(port="/dev/ttyACM0",baud=115200)
for i in xrange(10):
	if(p.online): break
	time.sleep(1)

print("printer online")
time.sleep(2)
x=260
y=210
try:
	p.send_now("G28")
	p.send_now("G1 X200 Y150 F15000")
	p.send_now("M400")
	p.send_now("M400")
#	print p.sent
#	print("attempting join 1 qlen %d"%(p.priqueue.qsize(),))
	if not p.priqueue.empty(): p.priqueue.join()
except:
	p.disconnect()
	raise
for i in xrange(12):
	y=210
	x+=5
	for j in xrange(15):
		y+=5
		print("sending G1 X%d Y%d F15000"%(x,y))
		p.send_now("G1 X%d Y%d F15000"%(x,y))
		p.send_now("M400")
		p.send_now("M400")
		if not p.priqueue.empty(): p.priqueue.join()
		time.sleep(0.25)
		flag=1
		print("waiting for image acquisition")
		while(flag):
			time.sleep(0.1)
		print("Writing image X%dY%d.png"%(x,y))
		cv2.imwrite("X%dY%d.png"%(x,y),img)
#		else: print("failed to get image at %d %d"%(x,y))
		
stop=1
p.disconnect()

