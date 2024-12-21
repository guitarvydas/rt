
                                                            #line 1#line 2#line 3
class Component_Registry:
    def __init__ (self,):                                   #line 4
        self.templates = {}                                 #line 5#line 6
                                                            #line 7
class Template:
    def __init__ (self,):                                   #line 8
        self.name =  None                                   #line 9
        self.template_data =  None                          #line 10
        self.instantiator =  None                           #line 11#line 12
                                                            #line 13
def mkTemplate (name,template_data,instantiator):           #line 14
    templ =  Template ()                                    #line 15
    templ.name =  name                                      #line 16
    templ.template_data =  template_data                    #line 17
    templ.instantiator =  instantiator                      #line 18
    return  templ                                           #line 19#line 20#line 21

def read_and_convert_json_file (pathname,filename):         #line 22

    try:
        fil = open(filename, "r")
        json_data = fil.read()
        routings = json.loads(json_data)
        fil.close ()
        return routings
    except FileNotFoundError:
        print (f"File not found: '{filename}'")
        return None
    except json.JSONDecodeError as e:
        print ("Error decoding JSON in file: '{e}'")
        return None
                                                            #line 23#line 24#line 25

def json2internal (pathname,container_xml):                 #line 26
    fname =  os.path.basename ( container_xml)              #line 27
    routings = read_and_convert_json_file ( pathname, fname)#line 28
    return  routings                                        #line 29#line 30#line 31

def delete_decls (d):                                       #line 32
    pass                                                    #line 33#line 34#line 35

def make_component_registry ():                             #line 36
    return  Component_Registry ()                           #line 37#line 38#line 39

def register_component (reg,template):
    return abstracted_register_component ( reg, template, False)#line 40

def register_component_allow_overwriting (reg,template):
    return abstracted_register_component ( reg, template, True)#line 41#line 42

def abstracted_register_component (reg,template,ok_to_overwrite):#line 43
    name = mangle_name ( template.name)                     #line 44
    if  reg!= None and  name in  reg.templates and not  ok_to_overwrite:#line 45
        load_error ( str( "Component /") +  str( template.name) +  "/ already declared"  )#line 46
        return  reg                                         #line 47
    else:                                                   #line 48
        reg.templates [name] =  template                    #line 49
        return  reg                                         #line 50#line 51#line 52#line 53

def get_component_instance (reg,full_name,owner):           #line 54
    template_name = mangle_name ( full_name)                #line 55
    if  template_name in  reg.templates:                    #line 56
        template =  reg.templates [template_name]           #line 57
        if ( template ==  None):                            #line 58
            load_error ( str( "Registry Error (A): Can;t find component /") +  str( template_name) +  "/"  )#line 59
            return  None                                    #line 60
        else:                                               #line 61
            owner_name =  ""                                #line 62
            instance_name =  template_name                  #line 63
            if  None!= owner:                               #line 64
                owner_name =  owner.name                    #line 65
                instance_name =  str( owner_name) +  str( ".") +  template_name  #line 66
            else:                                           #line 67
                instance_name =  template_name              #line 68#line 69
            instance =  template.instantiator ( reg, owner, instance_name, template.template_data)#line 70
            return  instance                                #line 71#line 72
    else:                                                   #line 73
        load_error ( str( "Registry Error (B): Can't find component /") +  str( template_name) +  "/"  )#line 74
        return  None                                        #line 75#line 76#line 77#line 78

def dump_registry (reg):                                    #line 79
    nl ()                                                   #line 80
    print ( "*** PALETTE ***")                              #line 81
    for c in  reg.templates:                                #line 82
        print ( c.name)                                     #line 83
    print ( "***************")                              #line 84
    nl ()                                                   #line 85#line 86#line 87

def print_stats (reg):                                      #line 88
    print ( str( "registry statistics: ") +  reg.stats )    #line 89#line 90#line 91

def mangle_name (s):                                        #line 92
    # trim name to remove code from Container component names _ deferred until later (or never)#line 93
    return  s                                               #line 94#line 95#line 96

def generate_shell_components (reg,container_list):         #line 97
    # [                                                     #line 98
    #     {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 99
    #     {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []}#line 100
    # ]                                                     #line 101
    if  None!= container_list:                              #line 102
        for diagram in  container_list:                     #line 103
            # loop through every component in the diagram and look for names that start with “$“ or “'“ #line 104
            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 105
            for child_descriptor in  diagram [ "children"]: #line 106
                if first_char_is ( child_descriptor [ "name"], "$"):#line 107
                    name =  child_descriptor [ "name"]      #line 108
                    cmd =   name[1:] .strip ()              #line 109
                    generated_leaf = mkTemplate ( name, cmd, shell_out_instantiate)#line 110
                    register_component ( reg, generated_leaf)#line 111
                elif first_char_is ( child_descriptor [ "name"], "'"):#line 112
                    name =  child_descriptor [ "name"]      #line 113
                    s =   name[1:]                          #line 114
                    generated_leaf = mkTemplate ( name, s, string_constant_instantiate)#line 115
                    register_component_allow_overwriting ( reg, generated_leaf)#line 116#line 117#line 118#line 119#line 120
    return  reg                                             #line 121#line 122#line 123

def first_char (s):                                         #line 124
    return   s[0]                                           #line 125#line 126#line 127

def first_char_is (s,c):                                    #line 128
    return  c == first_char ( s)                            #line 129#line 130#line 131
                                                            #line 132
# TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 133
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 134#line 135#line 136
# Data for an asyncronous component _ effectively, a function with input#line 137
# and output queues of messages.                            #line 138
#                                                           #line 139
# Components can either be a user_supplied function (“lea“), or a “container“#line 140
# that routes messages to child components according to a list of connections#line 141
# that serve as a message routing table.                    #line 142
#                                                           #line 143
# Child components themselves can be leaves or other containers.#line 144
#                                                           #line 145
# `handler` invokes the code that is attached to this component.#line 146
#                                                           #line 147
# `instance_data` is a pointer to instance data that the `leaf_handler`#line 148
# function may want whenever it is invoked again.           #line 149
#                                                           #line 150#line 151
# Eh_States :: enum { idle, active }                        #line 152
class Eh:
    def __init__ (self,):                                   #line 153
        self.name =  ""                                     #line 154
        self.inq =  deque ([])                              #line 155
        self.outq =  deque ([])                             #line 156
        self.owner =  None                                  #line 157
        self.children = []                                  #line 158
        self.visit_ordering =  deque ([])                   #line 159
        self.connections = []                               #line 160
        self.routings =  deque ([])                         #line 161
        self.handler =  None                                #line 162
        self.finject =  None                                #line 163
        self.instance_data =  None                          #line 164
        self.state =  "idle"                                #line 165# bootstrap debugging#line 166
        self.kind =  None # enum { container, leaf, }       #line 167#line 168
                                                            #line 169
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 170
# whose handler function is `container_handler`.            #line 171
def make_container (name,owner):                            #line 172
    eh =  Eh ()                                             #line 173
    eh.name =  name                                         #line 174
    eh.owner =  owner                                       #line 175
    eh.handler =  container_handler                         #line 176
    eh.finject =  container_injector                        #line 177
    eh.state =  "idle"                                      #line 178
    eh.kind =  "container"                                  #line 179
    return  eh                                              #line 180#line 181#line 182

# Creates a new leaf component out of a handler function, and a data parameter#line 183
# that will be passed back to your handler when called.     #line 184#line 185
def make_leaf (name,owner,instance_data,handler):           #line 186
    eh =  Eh ()                                             #line 187
    eh.name =  str( owner.name) +  str( ".") +  name        #line 188
    eh.owner =  owner                                       #line 189
    eh.handler =  handler                                   #line 190
    eh.instance_data =  instance_data                       #line 191
    eh.state =  "idle"                                      #line 192
    eh.kind =  "leaf"                                       #line 193
    return  eh                                              #line 194#line 195#line 196

# Sends a message on the given `port` with `data`, placing it on the output#line 197
# of the given component.                                   #line 198#line 199
def send (eh,port,datum,causingMessage):                    #line 200
    msg = make_message ( port, datum)                       #line 201
    put_output ( eh, msg)                                   #line 202#line 203#line 204

def send_string (eh,port,s,causingMessage):                 #line 205
    datum = new_datum_string ( s)                           #line 206
    msg = make_message ( port, datum)                       #line 207
    put_output ( eh, msg)                                   #line 208#line 209#line 210

def forward (eh,port,msg):                                  #line 211
    fwdmsg = make_message ( port, msg.datum)                #line 212
    put_output ( eh, msg)                                   #line 213#line 214#line 215

def inject (eh,msg):                                        #line 216
    eh.finject ( eh, msg)                                   #line 217#line 218#line 219

# Returns a list of all output messages on a container.     #line 220
# For testing / debugging purposes.                         #line 221#line 222
def output_list (eh):                                       #line 223
    return  eh.outq                                         #line 224#line 225#line 226

# Utility for printing an array of messages.                #line 227
def print_output_list (eh):                                 #line 228
    print ( "{")                                            #line 229
    for m in  list ( eh.outq):                              #line 230
        print (format_message ( m))                         #line 231#line 232
    print ( "}")                                            #line 233#line 234#line 235

def spaces (n):                                             #line 236
    s =  ""                                                 #line 237
    for i in range( n):                                     #line 238
        s =  s+ " "                                         #line 239
    return  s                                               #line 240#line 241#line 242

def set_active (eh):                                        #line 243
    eh.state =  "active"                                    #line 244#line 245#line 246

def set_idle (eh):                                          #line 247
    eh.state =  "idle"                                      #line 248#line 249#line 250

# Utility for printing a specific output message.           #line 251#line 252
def fetch_first_output (eh,port):                           #line 253
    for msg in  list ( eh.outq):                            #line 254
        if ( msg.port ==  port):                            #line 255
            return  msg.datum                               #line 256
    return  None                                            #line 257#line 258#line 259

def print_specific_output (eh,port):                        #line 260
    # port ∷ “”                                             #line 261
    datum = fetch_first_output ( eh, port)                  #line 262
    print ( datum.v)                                        #line 263#line 264

def print_specific_output_to_stderr (eh,port):              #line 265
    # port ∷ “”                                             #line 266
    datum = fetch_first_output ( eh, port)                  #line 267
    # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 268
    print ( datum.v, file=sys.stderr)                       #line 269#line 270#line 271

def put_output (eh,msg):                                    #line 272
    eh.outq.append ( msg)                                   #line 273#line 274#line 275

root_project =  ""                                          #line 276
root_0D =  ""                                               #line 277#line 278
def set_environment (rproject,r0D):                         #line 279
    global root_project                                     #line 280
    global root_0D                                          #line 281
    root_project =  rproject                                #line 282
    root_0D =  r0D                                          #line 283#line 284#line 285

def probeA_instantiate (reg,owner,name,template_data):      #line 286
    name_with_id = gensymbol ( "?A")                        #line 287
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 288#line 289#line 290

def probeB_instantiate (reg,owner,name,template_data):      #line 291
    name_with_id = gensymbol ( "?B")                        #line 292
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 293#line 294#line 295

def probeC_instantiate (reg,owner,name,template_data):      #line 296
    name_with_id = gensymbol ( "?C")                        #line 297
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 298#line 299#line 300

def probe_handler (eh,msg):                                 #line 301
    s =  msg.datum.v                                        #line 302
    print ( str( "... probe ") +  str( eh.name) +  str( ": ") +  s   , file=sys.stderr)#line 303#line 304#line 305

def trash_instantiate (reg,owner,name,template_data):       #line 306
    name_with_id = gensymbol ( "trash")                     #line 307
    return make_leaf ( name_with_id, owner, None, trash_handler)#line 308#line 309#line 310

def trash_handler (eh,msg):                                 #line 311
    # to appease dumped_on_floor checker                    #line 312
    pass                                                    #line 313#line 314

class TwoMessages:
    def __init__ (self,):                                   #line 315
        self.firstmsg =  None                               #line 316
        self.secondmsg =  None                              #line 317#line 318
                                                            #line 319
# Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg }#line 320
class Deracer_Instance_Data:
    def __init__ (self,):                                   #line 321
        self.state =  None                                  #line 322
        self.buffer =  None                                 #line 323#line 324
                                                            #line 325
def reclaim_Buffers_from_heap (inst):                       #line 326
    pass                                                    #line 327#line 328#line 329

def deracer_instantiate (reg,owner,name,template_data):     #line 330
    name_with_id = gensymbol ( "deracer")                   #line 331
    inst =  Deracer_Instance_Data ()                        #line 332
    inst.state =  "idle"                                    #line 333
    inst.buffer =  TwoMessages ()                           #line 334
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 335
    return  eh                                              #line 336#line 337#line 338

def send_firstmsg_then_secondmsg (eh,inst):                 #line 339
    forward ( eh, "1", inst.buffer.firstmsg)                #line 340
    forward ( eh, "2", inst.buffer.secondmsg)               #line 341
    reclaim_Buffers_from_heap ( inst)                       #line 342#line 343#line 344

def deracer_handler (eh,msg):                               #line 345
    inst =  eh.instance_data                                #line 346
    if  inst.state ==  "idle":                              #line 347
        if  "1" ==  msg.port:                               #line 348
            inst.buffer.firstmsg =  msg                     #line 349
            inst.state =  "waitingForSecondmsg"             #line 350
        elif  "2" ==  msg.port:                             #line 351
            inst.buffer.secondmsg =  msg                    #line 352
            inst.state =  "waitingForFirstmsg"              #line 353
        else:                                               #line 354
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 355#line 356
    elif  inst.state ==  "waitingForFirstmsg":              #line 357
        if  "1" ==  msg.port:                               #line 358
            inst.buffer.firstmsg =  msg                     #line 359
            send_firstmsg_then_secondmsg ( eh, inst)        #line 360
            inst.state =  "idle"                            #line 361
        else:                                               #line 362
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 363#line 364
    elif  inst.state ==  "waitingForSecondmsg":             #line 365
        if  "2" ==  msg.port:                               #line 366
            inst.buffer.secondmsg =  msg                    #line 367
            send_firstmsg_then_secondmsg ( eh, inst)        #line 368
            inst.state =  "idle"                            #line 369
        else:                                               #line 370
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg.port )#line 371#line 372
    else:                                                   #line 373
        runtime_error ( "bad state for deracer {eh.state}") #line 374#line 375#line 376#line 377

def low_level_read_text_file_instantiate (reg,owner,name,template_data):#line 378
    name_with_id = gensymbol ( "Low Level Read Text File")  #line 379
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 380#line 381#line 382

def low_level_read_text_file_handler (eh,msg):              #line 383
    fname =  msg.datum.v                                    #line 384

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
                                                            #line 385#line 386#line 387

def ensure_string_datum_instantiate (reg,owner,name,template_data):#line 388
    name_with_id = gensymbol ( "Ensure String Datum")       #line 389
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)#line 390#line 391#line 392

def ensure_string_datum_handler (eh,msg):                   #line 393
    if  "string" ==  msg.datum.kind ():                     #line 394
        forward ( eh, "", msg)                              #line 395
    else:                                                   #line 396
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum #line 397
        send_string ( eh, "✗", emsg, msg)                   #line 398#line 399#line 400#line 401

class Syncfilewrite_Data:
    def __init__ (self,):                                   #line 402
        self.filename =  ""                                 #line 403#line 404
                                                            #line 405
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)#line 406
def syncfilewrite_instantiate (reg,owner,name,template_data):#line 407
    name_with_id = gensymbol ( "syncfilewrite")             #line 408
    inst =  Syncfilewrite_Data ()                           #line 409
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)#line 410#line 411#line 412

def syncfilewrite_handler (eh,msg):                         #line 413
    inst =  eh.instance_data                                #line 414
    if  "filename" ==  msg.port:                            #line 415
        inst.filename =  msg.datum.v                        #line 416
    elif  "input" ==  msg.port:                             #line 417
        contents =  msg.datum.v                             #line 418
        f = open ( inst.filename, "w")                      #line 419
        if  f!= None:                                       #line 420
            f.write ( msg.datum.v)                          #line 421
            f.close ()                                      #line 422
            send ( eh, "done",new_datum_bang (), msg)       #line 423
        else:                                               #line 424
            send_string ( eh, "✗", str( "open error on file ") +  inst.filename , msg)#line 425#line 426#line 427#line 428#line 429

class StringConcat_Instance_Data:
    def __init__ (self,):                                   #line 430
        self.buffer1 =  None                                #line 431
        self.buffer2 =  None                                #line 432
        self.scount =  0                                    #line 433#line 434
                                                            #line 435
def stringconcat_instantiate (reg,owner,name,template_data):#line 436
    name_with_id = gensymbol ( "stringconcat")              #line 437
    instp =  StringConcat_Instance_Data ()                  #line 438
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 439#line 440#line 441

def stringconcat_handler (eh,msg):                          #line 442
    inst =  eh.instance_data                                #line 443
    if  "1" ==  msg.port:                                   #line 444
        inst.buffer1 = clone_string ( msg.datum.v)          #line 445
        inst.scount =  inst.scount+ 1                       #line 446
        maybe_stringconcat ( eh, inst, msg)                 #line 447
    elif  "2" ==  msg.port:                                 #line 448
        inst.buffer2 = clone_string ( msg.datum.v)          #line 449
        inst.scount =  inst.scount+ 1                       #line 450
        maybe_stringconcat ( eh, inst, msg)                 #line 451
    else:                                                   #line 452
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 453#line 454#line 455#line 456

def maybe_stringconcat (eh,inst,msg):                       #line 457
    if  inst.scount >=  2:                                  #line 458
        if ( 0 == len ( inst.buffer1)) and ( 0 == len ( inst.buffer2)):#line 459
            runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 460
        else:                                               #line 461
            concatenated_string =  ""                       #line 462
            if  0 == len ( inst.buffer1):                   #line 463
                concatenated_string =  inst.buffer2         #line 464
            elif  0 == len ( inst.buffer2):                 #line 465
                concatenated_string =  inst.buffer1         #line 466
            else:                                           #line 467
                concatenated_string =  inst.buffer1+ inst.buffer2#line 468#line 469
            send_string ( eh, "", concatenated_string, msg) #line 470
            inst.buffer1 =  None                            #line 471
            inst.buffer2 =  None                            #line 472
            inst.scount =  0                                #line 473#line 474#line 475#line 476#line 477

#                                                           #line 478#line 479
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 480
def shell_out_instantiate (reg,owner,name,template_data):   #line 481
    name_with_id = gensymbol ( "shell_out")                 #line 482
    cmd = shlex.split ( template_data)                      #line 483
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)#line 484#line 485#line 486

def shell_out_handler (eh,msg):                             #line 487
    cmd =  eh.instance_data                                 #line 488
    s =  msg.datum.v                                        #line 489
    ret =  None                                             #line 490
    rc =  None                                              #line 491
    stdout =  None                                          #line 492
    stderr =  None                                          #line 493

    try:
        ret = subprocess.run ( cmd, input= s, text=True, capture_output=True)
        rc = ret.returncode
        stdout = ret.stdout.strip ()
        stderr = ret.stderr.strip ()
    except Exception as e:
        ret = None
        rc = 1
        stdout = ''
        stderr = str(e)
                                                            #line 494
    if  rc!= 0:                                             #line 495
        send_string ( eh, "✗", stderr, msg)                 #line 496
    else:                                                   #line 497
        send_string ( eh, "", stdout, msg)                  #line 498#line 499#line 500#line 501

def string_constant_instantiate (reg,owner,name,template_data):#line 502
    global root_project                                     #line 503
    global root_0D                                          #line 504
    name_with_id = gensymbol ( "strconst")                  #line 505
    s =  template_data                                      #line 506
    if  root_project!= "":                                  #line 507
        s = re.sub ( "_00_",  root_project,  s)             #line 508#line 509
    if  root_0D!= "":                                       #line 510
        s = re.sub ( "_0D_",  root_0D,  s)                  #line 511#line 512
    return make_leaf ( name_with_id, owner, s, string_constant_handler)#line 513#line 514#line 515

def string_constant_handler (eh,msg):                       #line 516
    s =  eh.instance_data                                   #line 517
    send_string ( eh, "", s, msg)                           #line 518#line 519#line 520

def string_make_persistent (s):                             #line 521
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 522
    return  s                                               #line 523#line 524#line 525

def string_clone (s):                                       #line 526
    return  s                                               #line 527#line 528#line 529

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...#line 530
# where ${_00_} is the root directory for the project       #line 531
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)#line 532#line 533
def initialize_component_palette (root_project,root_0D,diagram_source_files):#line 534
    reg = make_component_registry ()                        #line 535
    for diagram_source in  diagram_source_files:            #line 536
        all_containers_within_single_file = json2internal ( root_project, diagram_source)#line 537
        reg = generate_shell_components ( reg, all_containers_within_single_file)#line 538
        for container in  all_containers_within_single_file:#line 539
            register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))#line 540#line 541#line 542
    initialize_stock_components ( reg)                      #line 543
    return  reg                                             #line 544#line 545#line 546

def print_error_maybe (main_container):                     #line 547
    error_port =  "✗"                                       #line 548
    err = fetch_first_output ( main_container, error_port)  #line 549
    if ( err!= None) and ( 0 < len (trimws ( err.v))):      #line 550
        print ( "___ !!! ERRORS !!! ___")                   #line 551
        print_specific_output ( main_container, error_port) #line 552#line 553#line 554#line 555

# debugging helpers                                         #line 556#line 557
def nl ():                                                  #line 558
    print ( "")                                             #line 559#line 560#line 561

def dump_outputs (main_container):                          #line 562
    nl ()                                                   #line 563
    print ( "___ Outputs ___")                              #line 564
    print_output_list ( main_container)                     #line 565#line 566#line 567

def trimws (s):                                             #line 568
    # remove whitespace from front and back of string       #line 569
    return  s.strip ()                                      #line 570#line 571#line 572

def clone_string (s):                                       #line 573
    return  s                                               #line 574#line 575#line 576

load_errors =  False                                        #line 577
runtime_errors =  False                                     #line 578#line 579
def load_error (s):                                         #line 580
    global load_errors                                      #line 581
    print ( s)                                              #line 582
    print ()                                                #line 583
    load_errors =  True                                     #line 584#line 585#line 586

def runtime_error (s):                                      #line 587
    global runtime_errors                                   #line 588
    print ( s)                                              #line 589
    runtime_errors =  True                                  #line 590#line 591#line 592

def fakepipename_instantiate (reg,owner,name,template_data):#line 593
    instance_name = gensymbol ( "fakepipe")                 #line 594
    return make_leaf ( instance_name, owner, None, fakepipename_handler)#line 595#line 596#line 597

rand =  0                                                   #line 598#line 599
def fakepipename_handler (eh,msg):                          #line 600
    global rand                                             #line 601
    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 602
    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)#line 603#line 604#line 605
                                                            #line 606
class Switch1star_Instance_Data:
    def __init__ (self,):                                   #line 607
        self.state =  "1"                                   #line 608#line 609
                                                            #line 610
def switch1star_instantiate (reg,owner,name,template_data): #line 611
    name_with_id = gensymbol ( "switch1*")                  #line 612
    instp =  Switch1star_Instance_Data ()                   #line 613
    return make_leaf ( name_with_id, owner, instp, switch1star_handler)#line 614#line 615#line 616

def switch1star_handler (eh,msg):                           #line 617
    inst =  eh.instance_data                                #line 618
    whichOutput =  inst.state                               #line 619
    if  "" ==  msg.port:                                    #line 620
        if  "1" ==  whichOutput:                            #line 621
            forward ( eh, "1*", msg.datum.v)                #line 622
            inst.state =  "*"                               #line 623
        elif  "*" ==  whichOutput:                          #line 624
            forward ( eh, "*", msg.datum.v)                 #line 625
        else:                                               #line 626
            send ( eh, "✗", "internal error bad state in switch1*", msg)#line 627#line 628
    elif  "reset" ==  msg.port:                             #line 629
        inst.state =  "1"                                   #line 630
    else:                                                   #line 631
        send ( eh, "✗", "internal error bad message for switch1*", msg)#line 632#line 633#line 634#line 635

class Latch_Instance_Data:
    def __init__ (self,):                                   #line 636
        self.datum =  None                                  #line 637#line 638
                                                            #line 639
def latch_instantiate (reg,owner,name,template_data):       #line 640
    name_with_id = gensymbol ( "latch")                     #line 641
    instp =  Latch_Instance_Data ()                         #line 642
    return make_leaf ( name_with_id, owner, instp, latch_handler)#line 643#line 644#line 645

def latch_handler (eh,msg):                                 #line 646
    inst =  eh.instance_data                                #line 647
    whichOutput =  inst.state                               #line 648
    if  "" ==  msg.port:                                    #line 649
        inst.datum =  msg.datum                             #line 650
    elif  "release" ==  msg.port:                           #line 651
        d =  inst.datum                                     #line 652
        send ( eh, "", d, msg)                              #line 653
    else:                                                   #line 654
        send ( eh, "✗", "internal error bad message for latch", msg)#line 655#line 656#line 657#line 658

# all of the the built_in leaves are listed here            #line 659
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 660#line 661
def initialize_stock_components (reg):                      #line 662
    register_component ( reg,mkTemplate ( "1then2", None, deracer_instantiate))#line 663
    register_component ( reg,mkTemplate ( "?A", None, probeA_instantiate))#line 664
    register_component ( reg,mkTemplate ( "?B", None, probeB_instantiate))#line 665
    register_component ( reg,mkTemplate ( "?C", None, probeC_instantiate))#line 666
    register_component ( reg,mkTemplate ( "trash", None, trash_instantiate))#line 667#line 668
    register_component ( reg,mkTemplate ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 669
    register_component ( reg,mkTemplate ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 670#line 671
    register_component ( reg,mkTemplate ( "syncfilewrite", None, syncfilewrite_instantiate))#line 672
    register_component ( reg,mkTemplate ( "stringconcat", None, stringconcat_instantiate))#line 673
    register_component ( reg,mkTemplate ( "switch1*", None, switch1star_instantiate))#line 674
    register_component ( reg,mkTemplate ( "latch", None, latch_instantiate))#line 675
    # for fakepipe                                          #line 676
    register_component ( reg,mkTemplate ( "fakepipename", None, fakepipename_instantiate))#line 677#line 678#line 679

def argv ():                                                #line 680
    return  sys.argv                                        #line 681#line 682#line 683

def initialize ():                                          #line 684
    root_of_project =  sys.argv[ 1]                         #line 685
    root_of_0D =  sys.argv[ 2]                              #line 686
    arg =  sys.argv[ 3]                                     #line 687
    main_container_name =  sys.argv[ 4]                     #line 688
    diagram_names =  sys.argv[ 5:]                          #line 689
    palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)#line 690
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 691#line 692#line 693

def start (palette,env):
    start_helper ( palette, env, False)                     #line 694

def start_show_all (palette,env):
    start_helper ( palette, env, True)                      #line 695

def start_helper (palette,env,show_all_outputs):            #line 696
    root_of_project =  env [ 0]                             #line 697
    root_of_0D =  env [ 1]                                  #line 698
    main_container_name =  env [ 2]                         #line 699
    diagram_names =  env [ 3]                               #line 700
    arg =  env [ 4]                                         #line 701
    set_environment ( root_of_project, root_of_0D)          #line 702
    # get entrypoint container                              #line 703
    main_container = get_component_instance ( palette, main_container_name, None)#line 704
    if  None ==  main_container:                            #line 705
        load_error ( str( "Couldn't find container with page name /") +  str( main_container_name) +  str( "/ in files ") +  str(str ( diagram_names)) +  " (check tab names, or disable compression?)"    )#line 709#line 710
    if not  load_errors:                                    #line 711
        marg = new_datum_string ( arg)                      #line 712
        msg = make_message ( "", marg)                      #line 713
        inject ( main_container, msg)                       #line 714
        if  show_all_outputs:                               #line 715
            dump_outputs ( main_container)                  #line 716
        else:                                               #line 717
            print_error_maybe ( main_container)             #line 718
            outp = fetch_first_output ( main_container, "") #line 719
            if  None ==  outp:                              #line 720
                print ( "«««no outputs»»»)")                #line 721
            else:                                           #line 722
                print_specific_output ( main_container, "") #line 723#line 724#line 725
        if  show_all_outputs:                               #line 726
            print ( "--- done ---")                         #line 727#line 728#line 729#line 730#line 731
                                                            #line 732
# utility functions                                         #line 733
def send_int (eh,port,i,causing_message):                   #line 734
    datum = new_datum_string (str ( i))                     #line 735
    send ( eh, port, datum, causing_message)                #line 736#line 737#line 738

def send_bang (eh,port,causing_message):                    #line 739
    datum = new_datum_bang ()                               #line 740
    send ( eh, port, datum, causing_message)                #line 741#line 742





