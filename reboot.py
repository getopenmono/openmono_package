import serial;

port = serial.Serial("/dev/cu.usbmodem14241")
port.setDTR(True)
port.setDTR(False)