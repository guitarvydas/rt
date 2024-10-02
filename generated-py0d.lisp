

class Message:
    def __init__ (self,port,datum):
        self.port =  port
        self.datum =  datum 

def clone_port (s):
    return clone_string ( s)
# Utility for making a `Message`. Used to safely “seed“ messages# entering the very top of a network.
def make_message (port,datum):
    p = clone_string ( port)
    m = Message (port= p,datum= datum.clone ())
    return  m

def xyz ():
    if  x:
        a =  1
    elif  y:
        a =  2
    else:
        a =  3
    

def low_level_read_text_file_instantiate (reg,owner,name,template_data):
    name_with_id = gensym ( "Low Level Read Text File")
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)

def low_level_read_text_file_handler (eh,msg):
    fname =  msg.datum.srepr ()
    try:
        f = open (fname)
    except Exception as e:
        f ≡ None
    if f != None:
        data ≡ f.read ()
        if data!= None:
            send_string (eh, "", data, msg)
        else:
            send_string (eh, "✗", f"read error on file '{fname}'", msg)
        f.close ()
    else
        send_string (eh, "✗", f"open error on file '{fname}'", msg)
    

def read_and_convert_json_file (filename):
    try:
        fil = open(fname, "r")
        json_data = fil.read()
        routings = json.loads(json_data)
        fil.close ()
        return routings 
    except FileNotFoundError:
        print (f"File not found: '{filename}'")
        return None
    except json.JSONDecodeError as e:
        print ("Error decoding JSON in file: '{e}'"))
        return None
    





