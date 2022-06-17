## Where I Am and Next Steps:
## - Have real-time FFT plot, but it is extrememly slow
## - Next step should look at np.append() in get-fft.ph for speedup

import serial
import time
import pandas as pd
import numpy as np
import pyqtgraph as pg

def getFFT(port = '/dev/ttyACM0', baud = 115200, timeout = 2): 
    ser = serial.Serial(port, baud, timeout = timeout)
    ser.write(bytes("fft", 'utf-8'))
    time.sleep(1)
    fftdat = ser.readlines()
    ser.close()

    fft_df = pd.DataFrame({'frequency': [], 'magnitude': []})
    for i in range(len(fftdat)):
         str = fftdat[i].decode("utf-8").split(", ")
         d = {
             'frequency' : float(str[0]),  # some formula for obtaining values
             'magnitude' : float(str[1].splitlines()[0])
         }
         fft_df = fft_df.append(d, ignore_index=True)   

    return fft_df
    
#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Update a simple plot as rapidly as possible to measure speed.
"""

"""
Demonstrates the usage of DateAxisItem to display properly-formatted 
timestamps on x-axis which automatically adapt to current zoom level.

"""

from pyqtgraph.Qt import QtCore, QtGui
import pyqtgraph as pg

# d = getFFT().to_numpy()
# # pg.plot(data, title="A Plot")
# 
# app = pg.mkQApp("ImageView Example")
# 
# win = pg.GraphicsLayoutWidget(show=True, title="Plot auto-range examples")
# win.resize(800,600)
# win.setWindowTitle('pyqtgraph example: PlotAutoRange')
# p1 = win.addPlot(d)
# 
# def update():
#     data = getFFT().to_numpy()
#     global curve
#     curve.setData(data)
# 
# timer = QtCore.QTimer()
# timer.timeout.connect(update)
# timer.start(50)
# 
# if __name__ == '__main__':
#     pg.exec()
    
    
x = getFFT().frequency.to_numpy()
y = getFFT().magnitude.to_numpy()

app = pg.mkQApp("Plot Auto Range Example")
#mw = QtGui.QMainWindow()
#mw.resize(800,800)

win = pg.GraphicsLayoutWidget(show=True, title="Plot auto-range examples")
win.resize(800,600)
win.setWindowTitle('pyqtgraph example: PlotAutoRange')

p1 = win.addPlot(x = x, y = y)
curve = p1.plot()

def update():
    t = pg.time()
    
    x1 = getFFT().frequency.to_numpy()
    y1 = getFFT().magnitude.to_numpy()
    global curve
    curve.setData(x = x1, y = y1)
    
timer = QtCore.QTimer()
timer.timeout.connect(update)
timer.start(50)

if __name__ == '__main__':
    pg.exec()
