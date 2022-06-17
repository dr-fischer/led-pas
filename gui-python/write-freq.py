import serial
import time

def writeFrequency(f): 
    ser = serial.Serial('/dev/ttyACM0', 115200)
    ser.write(bytes("f."+str(f), 'utf-8'))
    print(ser.readline())
    ser.close()

writeFrequency(1500)   




# from pyqtgraph.Qt import QtGui, QtCore
# import numpy as np
# import pyqtgraph as pg
# 
# app = pg.mkQApp("Plotting Example")
# 
# win = pg.GraphicsLayoutWidget(show=True, title="Basic plotting examples")
# win.resize(1000,600)
# win.setWindowTitle('pyqtgraph example: Plotting')
