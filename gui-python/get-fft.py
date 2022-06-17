import serial
import time
import pandas as pd

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
    
# print(getFFT())
