import serial;
import serial.tools.list_ports
import re
import sys
import time

portName = None

if (sys.platform.startswith("darwin") or sys.platform.startswith("linux")):
    ports = serial.tools.list_ports.comports()
    cnt = []
    for pn in ports:
        #m = re.search("/dev/cu.usbmodem([0-9]+)", pn[0])
        m = re.search('USB VID:PID=([0-9ABCDEF]{3,4}):([0-9ABCDEF]{4})', pn[2], re.I)
        if m != None:
            if (m.group(1).upper() == "4B4" or m.group(1).upper() == "04B4") and m.group(2).upper() == "F232":
                cnt.append(pn[0])
    
    if len(cnt) > 0:
        cnt.sort()
        portName = cnt[len(cnt)-1]
        print portName
        exit(0)

print "Mono does not seem to have mounted a serial port (Is it in bootloader or in sleep?)"
exit(1)