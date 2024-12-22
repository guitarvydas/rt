

def probeA_instantiate (reg,owner,name,template_data):      #line 1
    name_with_id = gensymbol ( "?A")                        #line 2
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 3#line 4#line 5

def probeB_instantiate (reg,owner,name,template_data):      #line 6
    name_with_id = gensymbol ( "?B")                        #line 7
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 8#line 9#line 10

def probeC_instantiate (reg,owner,name,template_data):      #line 11
    name_with_id = gensymbol ( "?C")                        #line 12
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 13#line 14#line 15

def probe_handler (eh,msg):                                 #line 16
    s =  msg.datum.v                                        #line 17
    print ( str( "... probe ") +  str( eh.name) +  str( ": ") +  s   , file=sys.stderr)#line 18#line 19#line 20

def trash_instantiate (reg,owner,name,template_data):       #line 21
    name_with_id = gensymbol ( "trash")                     #line 22
    return make_leaf ( name_with_id, owner, None, trash_handler)#line 23#line 24#line 25

def trash_handler (eh,msg):                                 #line 26
    # to appease dumped_on_floor checker                    #line 27
    pass                                                    #line 28#line 29

class TwoMessages:
    def __init__ (self,):                                   #line 30
        self.firstmsg =  None                               #line 31
        self.secondmsg =  None                              #line 32#line 33
                                                            #line 34
# Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg }#line 35
class Deracer_Instance_Data:
    def __init__ (self,):                                   #line 36
        self.state =  None                                  #line 37
        self.buffer =  None                                 #line 38#line 39
                                                            #line 40
def reclaim_Buffers_from_heap (inst):                       #line 41
    pass                                                    #line 42#line 43#line 44

def deracer_instantiate (reg,owner,name,template_data):     #line 45
    name_with_id = gensymbol ( "deracer")                   #line 46
    inst =  Deracer_Instance_Data ()                        #line 47
    inst.state =  "idle"                                    #line 48
    inst.buffer =  TwoMessages ()                           #line 49
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 50
    return  eh                                              #line 51#line 52#line 53

def send_firstmsg_then_secondmsg (eh,inst):                 #line 54
    forward ( eh, "1", inst.buffer.firstmsg)                #line 55
    forward ( eh, "2", inst.buffer.secondmsg)               #line 56
    reclaim_Buffers_from_heap ( inst)                       #line 57#line 58#line 59

def deracer_handler (eh,msg):                               #line 60
    inst =  eh.instance_data                                #line 61
    if  inst.state ==  "idle":                              #line 62
        if  "1" ==  msg.port:                               #line 63
            inst.buffer.firstmsg =  msg                     #line 64
            inst.state =  "waitingForSecondmsg"             #line 65
        elif  "2" ==  msg.port:                             #line 66
            inst.buffer.secondmsg =  msg                    #line 67
            inst.state =  "waitingForFirstmsg"              #line 68
        else:                                               #line 69
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 70#line 71
    elif  inst.state ==  "waitingForFirstmsg":              #line 72
        if  "1" ==  msg.port:                               #line 73
            inst.buffer.firstmsg =  msg                     #line 74
            send_firstmsg_then_secondmsg ( eh, inst)        #line 75
            inst.state =  "idle"                            #line 76
        else:                                               #line 77
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 78#line 79
    elif  inst.state ==  "waitingForSecondmsg":             #line 80
        if  "2" ==  msg.port:                               #line 81
            inst.buffer.secondmsg =  msg                    #line 82
            send_firstmsg_then_secondmsg ( eh, inst)        #line 83
            inst.state =  "idle"                            #line 84
        else:                                               #line 85
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg.port )#line 86#line 87
    else:                                                   #line 88
        runtime_error ( "bad state for deracer {eh.state}") #line 89#line 90#line 91#line 92

def low_level_read_text_file_instantiate (reg,owner,name,template_data):#line 93
    name_with_id = gensymbol ( "Low Level Read Text File")  #line 94
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 95#line 96#line 97

def low_level_read_text_file_handler (eh,msg):              #line 98
    fname =  msg.datum.v                                    #line 99

    try:
        f = open (fname)
    except Exception as e:
        f = None
    if f != None:
        data = f.read ()
        if data!= None:
            send_string (eh, "", data, msg)
        else:
            send_string (eh, "✗", f"read error on file '{fname}'", msg)
        f.close ()
    else:
        send_string (eh, "✗", f"open error on file '{fname}'", msg)
                                                            #line 100#line 101#line 102

def ensure_string_datum_instantiate (reg,owner,name,template_data):#line 103
    name_with_id = gensymbol ( "Ensure String Datum")       #line 104
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)#line 105#line 106#line 107

def ensure_string_datum_handler (eh,msg):                   #line 108
    if  "string" ==  msg.datum.kind ():                     #line 109
        forward ( eh, "", msg)                              #line 110
    else:                                                   #line 111
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum #line 112
        send_string ( eh, "✗", emsg, msg)                   #line 113#line 114#line 115#line 116

class Syncfilewrite_Data:
    def __init__ (self,):                                   #line 117
        self.filename =  ""                                 #line 118#line 119
                                                            #line 120
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)#line 121
def syncfilewrite_instantiate (reg,owner,name,template_data):#line 122
    name_with_id = gensymbol ( "syncfilewrite")             #line 123
    inst =  Syncfilewrite_Data ()                           #line 124
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)#line 125#line 126#line 127

def syncfilewrite_handler (eh,msg):                         #line 128
    inst =  eh.instance_data                                #line 129
    if  "filename" ==  msg.port:                            #line 130
        inst.filename =  msg.datum.v                        #line 131
    elif  "input" ==  msg.port:                             #line 132
        contents =  msg.datum.v                             #line 133
        f = open ( inst.filename, "w")                      #line 134
        if  f!= None:                                       #line 135
            f.write ( msg.datum.v)                          #line 136
            f.close ()                                      #line 137
            send ( eh, "done",new_datum_bang (), msg)       #line 138
        else:                                               #line 139
            send_string ( eh, "✗", str( "open error on file ") +  inst.filename , msg)#line 140#line 141#line 142#line 143#line 144

class StringConcat_Instance_Data:
    def __init__ (self,):                                   #line 145
        self.buffer1 =  None                                #line 146
        self.buffer2 =  None                                #line 147
        self.scount =  0                                    #line 148#line 149
                                                            #line 150
def stringconcat_instantiate (reg,owner,name,template_data):#line 151
    name_with_id = gensymbol ( "stringconcat")              #line 152
    instp =  StringConcat_Instance_Data ()                  #line 153
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 154#line 155#line 156

def stringconcat_handler (eh,msg):                          #line 157
    inst =  eh.instance_data                                #line 158
    if  "1" ==  msg.port:                                   #line 159
        inst.buffer1 = clone_string ( msg.datum.v)          #line 160
        inst.scount =  inst.scount+ 1                       #line 161
        maybe_stringconcat ( eh, inst, msg)                 #line 162
    elif  "2" ==  msg.port:                                 #line 163
        inst.buffer2 = clone_string ( msg.datum.v)          #line 164
        inst.scount =  inst.scount+ 1                       #line 165
        maybe_stringconcat ( eh, inst, msg)                 #line 166
    else:                                                   #line 167
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 168#line 169#line 170#line 171

def maybe_stringconcat (eh,inst,msg):                       #line 172
    if  inst.scount >=  2:                                  #line 173
        if ( 0 == len ( inst.buffer1)) and ( 0 == len ( inst.buffer2)):#line 174
            runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 175
        else:                                               #line 176
            concatenated_string =  ""                       #line 177
            if  0 == len ( inst.buffer1):                   #line 178
                concatenated_string =  inst.buffer2         #line 179
            elif  0 == len ( inst.buffer2):                 #line 180
                concatenated_string =  inst.buffer1         #line 181
            else:                                           #line 182
                concatenated_string =  inst.buffer1+ inst.buffer2#line 183#line 184
            send_string ( eh, "", concatenated_string, msg) #line 185
            inst.buffer1 =  None                            #line 186
            inst.buffer2 =  None                            #line 187
            inst.scount =  0                                #line 188#line 189#line 190#line 191#line 192

#                                                           #line 193#line 194
def string_constant_instantiate (reg,owner,name,template_data):#line 195
    global root_project                                     #line 196
    global root_0D                                          #line 197
    name_with_id = gensymbol ( "strconst")                  #line 198
    s =  template_data                                      #line 199
    if  root_project!= "":                                  #line 200
        s = re.sub ( "_00_",  root_project,  s)             #line 201#line 202
    if  root_0D!= "":                                       #line 203
        s = re.sub ( "_0D_",  root_0D,  s)                  #line 204#line 205
    return make_leaf ( name_with_id, owner, s, string_constant_handler)#line 206#line 207#line 208

def string_constant_handler (eh,msg):                       #line 209
    s =  eh.instance_data                                   #line 210
    send_string ( eh, "", s, msg)                           #line 211#line 212





