# python client code to use the emacs eval server
import socket

ip="127.0.0.1"
port=9001
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
conn=s.connect((ip,port))
s.send("(buffer-name)".encode())
data=s.recv(1000)
len(data.decode().split("\n")[1])
s.close()

