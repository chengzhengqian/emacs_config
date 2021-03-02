# python client code to use the emacs eval server
# implement autocomplement
import socket

czq_python_ip="127.0.0.1"
czq_python_port=9001
czq_python_s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
czq_python_conn=czq_python_s.connect((czq_python_ip,czq_python_port))
# czq_python_s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# conn=s2.connect((ip,port))
# s.send("(buffer-name)".encode())
# data=s.recv(1000)
# len(data.decode().split("\n")[1])
# s.close()

# test string
# str="(buffer-name)"
def evalInEmacs(str,s):
    s.send(str.encode())
    sf=s.makefile()
    size=sf.readline()
    size=int(size)+1
    result=sf.readline()
    while(len(result)<size):
        result+=sf.readline()
    return result[0:-1]

    
# get_ipython

# evalInEmacs("(buffer-name)",czq_python_s)
def getInputForAutocomplete():
    result= evalInEmacs("( czq-find-match-part-for-auto-complete)",czq_python_s)
    # print(result)
    return result[1:-1].split("\n")

def czqAutoComplete(pattern):
    result=[]
    if(len(pattern)==1):
        keys= globals().keys()
        pattern_=pattern[0]
    if(len(pattern)==2):
        keys=dir(eval(pattern[0]))
        pattern_=pattern[1]
    for i in keys:
        if(i.startswith(pattern_)):
            result.append(i)
    return ",".join(result)
            
def autocompleteInEmacs():
    patterns=getInputForAutocomplete()
    # print(patterns)
    pattern=patterns[-1]
    results=czqAutoComplete(patterns)
    cmd=f"(czq-autocomplete \"{pattern}\"  \"{results}\")"
    select=evalInEmacs( cmd, czq_python_s)
    # print(cmd)
    print(f"you have selected {select}\n")
    
