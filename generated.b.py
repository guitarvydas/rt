
                                                            #line 1#line 2#line 3
class Component_Registry:
    def __init__ (self,):                                   #line 4
        self.templates = {}                                 #line 5#line 6
                                                            #line 7
class Template:
    def __init__ (self,name,template_data,instantiator):    #line 8
        self.name =  name                                   #line 9
        self.template_data =  template_data                 #line 10
        self.instantiator =  instantiator                   #line 11#line 12
                                                            #line 13
def read_and_convert_json_file (pathname,filename):         #line 14

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
                                                            #line 15#line 16#line 17

def json2internal (pathname,container_xml):                 #line 18
    fname =  os.path.basename ( container_xml)              #line 19
    routings = read_and_convert_json_file ( pathname, fname)#line 20
    return  routings                                        #line 21#line 22#line 23

def delete_decls (d):                                       #line 24
    pass                                                    #line 25#line 26#line 27

def make_component_registry ():                             #line 28
    return Component_Registry ()                            #line 29#line 30#line 31

def register_component (reg,template):
    return abstracted_register_component ( reg, template, False)#line 32

def register_component_allow_overwriting (reg,template):
    return abstracted_register_component ( reg, template, True)#line 33#line 34

def abstracted_register_component (reg,template,ok_to_overwrite):#line 35
    name = mangle_name ( template.name)                     #line 36
    if ( name in  reg.templates) and not  ok_to_overwrite:  #line 37
        load_error ( str( "Component /") +  str( template.name) +  "/ already declared"  )#line 38
        return  reg                                         #line 39
    else:                                                   #line 40
        reg.templates.insert (NIY ( name,  template))       #line 41
        return  reg                                         #line 42#line 43#line 44#line 45

def get_component_instance (reg,full_name,owner):           #line 46
    template_name = mangle_name ( full_name)                #line 47
    if  template_name in  reg.templates:                    #line 48
        template =  reg.templates [( template_name)]        #line 49
        if ( template ==  None):                            #line 50
            load_error ( str( "Registry Error (A): Can;t find component /") +  str( template_name) +  "/"  )#line 51
            return  None                                    #line 52
        else:                                               #line 53
            owner_name =  ""                                #line 54
            instance_name =  template_name                  #line 55
            if  None!= owner:                               #line 56
                owner_name =  owner.name                    #line 57
                instance_name =  str( owner_name) +  str( ".") +  template_name  #line 58
            else:                                           #line 59
                instance_name =  template_name              #line 60
            instance =  template.instantiator ( reg, owner, instance_name, template.template_data)#line 61
            instance.depth = calculate_depth ( instance)    #line 62
            return  instance                                #line 63
    else:                                                   #line 64
        load_error ( str( "Registry Error (B): Can't find component /") +  str( template_name) +  "/"  )#line 65
        return  None                                        #line 66#line 67

def calculate_depth (eh):                                   #line 68
    if  eh.owner ==  None:                                  #line 69
        return  0                                           #line 70
    else:                                                   #line 71
        return  1+calculate_depth ( eh.owner)               #line 72#line 73#line 74

def dump_registry (reg):                                    #line 75
    nl ()                                                   #line 76
    print ( "*** PALETTE ***")                              #line 77
    for c in  reg.templates:                                #line 78
        print ( c.name)                                     #line 79
    print ( "***************")                              #line 80
    nl ()                                                   #line 81#line 82#line 83

def print_stats (reg):                                      #line 84
    print ( str( "registry statistics: ") +  reg.stats )    #line 85#line 86#line 87

def mangle_name (s):                                        #line 88
    # trim name to remove code from Container component names _ deferred until later (or never)#line 89
    return  s                                               #line 90#line 91#line 92

def generate_shell_components (reg,container_list):         #line 93
    # [                                                     #line 94
    #     {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 95
    #     {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []}#line 96
    # ]                                                     #line 97
    if  None!= container_list:                              #line 98
        for diagram in  container_list:                     #line 99
            # loop through every component in the diagram and look for names that start with “$“#line 100
            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 101
            for child_descriptor in  diagram [ "children"]: #line 102
                if first_char_is ( child_descriptor [ "name"], "$"):#line 103
                    name =  child_descriptor [ "name"]      #line 104
                    cmd =   name[1:] .strip ()              #line 105
                    generated_leaf = Template ( name, shell_out_instantiate, cmd)#line 106
                    register_component ( reg, generated_leaf)#line 107
                elif first_char_is ( child_descriptor [ "name"], "'"):#line 108
                    name =  child_descriptor [ "name"]      #line 109
                    s =   name[1:]                          #line 110
                    generated_leaf = Template ( name, string_constant_instantiate, s)#line 111
                    register_component_allow_overwriting ( reg, generated_leaf)#line 112#line 113#line 114#line 115#line 116
    return  reg                                             #line 117#line 118#line 119

def first_char (s):                                         #line 120
    return   s[0]                                           #line 121#line 122#line 123

def first_char_is (s,c):                                    #line 124
    return  c == first_char ( s)                            #line 125#line 126#line 127
                                                            #line 128
# TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 129
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 130#line 131#line 132
# Data for an asyncronous component _ effectively, a function with input#line 133
# and output queues of messages.                            #line 134
#                                                           #line 135
# Components can either be a user_supplied function (“lea“), or a “container“#line 136
# that routes messages to child components according to a list of connections#line 137
# that serve as a message routing table.                    #line 138
#                                                           #line 139
# Child components themselves can be leaves or other containers.#line 140
#                                                           #line 141
# `handler` invokes the code that is attached to this component.#line 142
#                                                           #line 143
# `instance_data` is a pointer to instance data that the `leaf_handler`#line 144
# function may want whenever it is invoked again.           #line 145
#                                                           #line 146#line 147
# Eh_States :: enum { idle, active }                        #line 148
class Eh:
    def __init__ (self,):                                   #line 149
        self.name =  ""                                     #line 150
        self.inq =  queue.Queue ()                          #line 151
        self.outq =  queue.Queue ()                         #line 152
        self.owner =  None                                  #line 153
        self.saved_messages =  queue.LifoQueue () # stack of saved message(s)#line 154
        self.children = []                                  #line 155
        self.visit_ordering =  queue.Queue ()               #line 156
        self.connections = []                               #line 157
        self.routings =  queue.Queue ()                     #line 158
        self.handler =  None                                #line 159
        self.inject =  None                                 #line 160
        self.instance_data =  None                          #line 161
        self.state =  "idle"                                #line 162# bootstrap debugging#line 163
        self.kind =  None # enum { container, leaf, }       #line 164
        self.trace =  False # set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component)#line 165
        self.depth =  0 # hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc.#line 166#line 167
                                                            #line 168
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 169
# whose handler function is `container_handler`.            #line 170
def make_container (name,owner):                            #line 171
    eh = Eh ()                                              #line 172
    eh.name =  name                                         #line 173
    eh.owner =  owner                                       #line 174
    eh.handler =  container_handler                         #line 175
    eh.inject =  container_injector                         #line 176
    eh.state =  "idle"                                      #line 177
    eh.kind =  "container"                                  #line 178
    return  eh                                              #line 179#line 180#line 181

# Creates a new leaf component out of a handler function, and a data parameter#line 182
# that will be passed back to your handler when called.     #line 183#line 184
def make_leaf (name,owner,instance_data,handler):           #line 185
    eh = Eh ()                                              #line 186
    eh.name =  str( owner.name) +  str( ".") +  name        #line 187
    eh.owner =  owner                                       #line 188
    eh.handler =  handler                                   #line 189
    eh.instance_data =  instance_data                       #line 190
    eh.state =  "idle"                                      #line 191
    eh.kind =  "leaf"                                       #line 192
    return  eh                                              #line 193#line 194#line 195

# Sends a message on the given `port` with `data`, placing it on the output#line 196
# of the given component.                                   #line 197#line 198
def send (eh,port,datum,causingMessage):                    #line 199
    msg = make_message ( port, datum)                       #line 200
    put_output ( eh, msg)                                   #line 201#line 202#line 203

def send_string (eh,port,s,causingMessage):                 #line 204
    datum = new_datum_string ( s)                           #line 205
    msg = make_message ( port, datum)                       #line 206
    put_output ( eh, msg)                                   #line 207#line 208#line 209

def forward (eh,port,msg):                                  #line 210
    fwdmsg = make_message ( port, msg.datum)                #line 211
    put_output ( eh, msg)                                   #line 212#line 213#line 214

def inject (eh,msg):                                        #line 215
    eh.inject ( eh, msg)                                    #line 216#line 217#line 218

# Returns a list of all output messages on a container.     #line 219
# For testing / debugging purposes.                         #line 220#line 221
def output_list (eh):                                       #line 222
    return  eh.outq                                         #line 223#line 224#line 225

# Utility for printing an array of messages.                #line 226
def print_output_list (eh):                                 #line 227
    for m in list ( eh.outq.queue):                         #line 228
        print (format_message ( m))                         #line 229#line 230#line 231

def spaces (n):                                             #line 232
    s =  ""                                                 #line 233
    for i in range( n):                                     #line 234
        s =  s+ " "                                         #line 235
    return  s                                               #line 236#line 237#line 238

def set_active (eh):                                        #line 239
    eh.state =  "active"                                    #line 240#line 241#line 242

def set_idle (eh):                                          #line 243
    eh.state =  "idle"                                      #line 244#line 245#line 246

# Utility for printing a specific output message.           #line 247#line 248
def fetch_first_output (eh,port):                           #line 249
    for msg in list ( eh.outq.queue):                       #line 250
        if ( msg.port ==  port):                            #line 251
            return  msg.datum                               #line 252
    return  None                                            #line 253#line 254#line 255

def print_specific_output (eh,port):                        #line 256
    # port ∷ “”                                             #line 257
    datum = fetch_first_output ( eh, port)                  #line 258
    print ( datum.srepr ())                                 #line 259#line 260

def print_specific_output_to_stderr (eh,port):              #line 261
    # port ∷ “”                                             #line 262
    datum = fetch_first_output ( eh, port)                  #line 263
    # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 264
    print ( datum.srepr (), file=sys.stderr)                #line 265#line 266#line 267

def put_output (eh,msg):                                    #line 268
    eh.outq.put ( msg)                                      #line 269#line 270#line 271

root_project =  ""                                          #line 272
root_0D =  ""                                               #line 273#line 274
def set_environment (rproject,r0D):                         #line 275
    global root_project                                     #line 276
    global root_0D                                          #line 277
    root_project =  rproject                                #line 278
    root_0D =  r0D                                          #line 279#line 280#line 281

def probe_instantiate (reg,owner,name,template_data):       #line 282
    name_with_id = gensymbol ( "?")                         #line 283
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 284#line 285

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
    s =  msg.datum.srepr ()                                 #line 302
    print ( str( "... probe ") +  str( eh.name) +  str( ": ") +  s   , file=sys.stderr)#line 303#line 304#line 305

def trash_instantiate (reg,owner,name,template_data):       #line 306
    name_with_id = gensymbol ( "trash")                     #line 307
    return make_leaf ( name_with_id, owner, None, trash_handler)#line 308#line 309#line 310

def trash_handler (eh,msg):                                 #line 311
    # to appease dumped_on_floor checker                    #line 312
    pass                                                    #line 313#line 314

class TwoMessages:
    def __init__ (self,first,second):                       #line 315
        self.first =  first                                 #line 316
        self.second =  second                               #line 317#line 318
                                                            #line 319
# Deracer_States :: enum { idle, waitingForFirst, waitingForSecond }#line 320
class Deracer_Instance_Data:
    def __init__ (self,state,buffer):                       #line 321
        self.state =  state                                 #line 322
        self.buffer =  buffer                               #line 323#line 324
                                                            #line 325
def reclaim_Buffers_from_heap (inst):                       #line 326
    pass                                                    #line 327#line 328#line 329

def deracer_instantiate (reg,owner,name,template_data):     #line 330
    name_with_id = gensymbol ( "deracer")                   #line 331
    inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))#line 332
    inst.state =  "idle"                                    #line 333
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 334
    return  eh                                              #line 335#line 336#line 337

def send_first_then_second (eh,inst):                       #line 338
    forward ( eh, "1", inst.buffer.first)                   #line 339
    forward ( eh, "2", inst.buffer.second)                  #line 340
    reclaim_Buffers_from_heap ( inst)                       #line 341#line 342#line 343

def deracer_handler (eh,msg):                               #line 344
    inst =  eh.instance_data                                #line 345
    if  inst.state ==  "idle":                              #line 346
        if  "1" ==  msg.port:                               #line 347
            inst.buffer.first =  msg                        #line 348
            inst.state =  "waitingForSecond"                #line 349
        elif  "2" ==  msg.port:                             #line 350
            inst.buffer.second =  msg                       #line 351
            inst.state =  "waitingForFirst"                 #line 352
        else:                                               #line 353
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 354
    elif  inst.state ==  "waitingForFirst":                 #line 355
        if  "1" ==  msg.port:                               #line 356
            inst.buffer.first =  msg                        #line 357
            send_first_then_second ( eh, inst)              #line 358
            inst.state =  "idle"                            #line 359
        else:                                               #line 360
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 361
    elif  inst.state ==  "waitingForSecond":                #line 362
        if  "2" ==  msg.port:                               #line 363
            inst.buffer.second =  msg                       #line 364
            send_first_then_second ( eh, inst)              #line 365
            inst.state =  "idle"                            #line 366
        else:                                               #line 367
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg.port )#line 368
    else:                                                   #line 369
        runtime_error ( "bad state for deracer {eh.state}") #line 370#line 371#line 372

def low_level_read_text_file_instantiate (reg,owner,name,template_data):#line 373
    name_with_id = gensymbol ( "Low Level Read Text File")  #line 374
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 375#line 376#line 377

def low_level_read_text_file_handler (eh,msg):              #line 378
    fname =  msg.datum.srepr ()                             #line 379

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
                                                            #line 380#line 381#line 382

def ensure_string_datum_instantiate (reg,owner,name,template_data):#line 383
    name_with_id = gensymbol ( "Ensure String Datum")       #line 384
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)#line 385#line 386#line 387

def ensure_string_datum_handler (eh,msg):                   #line 388
    if  "string" ==  msg.datum.kind ():                     #line 389
        forward ( eh, "", msg)                              #line 390
    else:                                                   #line 391
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum #line 392
        send_string ( eh, "✗", emsg, msg)                   #line 393#line 394#line 395

class Syncfilewrite_Data:
    def __init__ (self,):                                   #line 396
        self.filename =  ""                                 #line 397#line 398
                                                            #line 399
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)#line 400
def syncfilewrite_instantiate (reg,owner,name,template_data):#line 401
    name_with_id = gensymbol ( "syncfilewrite")             #line 402
    inst = Syncfilewrite_Data ()                            #line 403
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)#line 404#line 405#line 406

def syncfilewrite_handler (eh,msg):                         #line 407
    inst =  eh.instance_data                                #line 408
    if  "filename" ==  msg.port:                            #line 409
        inst.filename =  msg.datum.srepr ()                 #line 410
    elif  "input" ==  msg.port:                             #line 411
        contents =  msg.datum.srepr ()                      #line 412
        f = open ( inst.filename, "w")                      #line 413
        if  f!= None:                                       #line 414
            f.write ( msg.datum.srepr ())                   #line 415
            f.close ()                                      #line 416
            send ( eh, "done",new_datum_bang (), msg)       #line 417
        else:                                               #line 418
            send_string ( eh, "✗", str( "open error on file ") +  inst.filename , msg)#line 419#line 420#line 421

class StringConcat_Instance_Data:
    def __init__ (self,):                                   #line 422
        self.buffer1 =  None                                #line 423
        self.buffer2 =  None                                #line 424
        self.count =  0                                     #line 425#line 426
                                                            #line 427
def stringconcat_instantiate (reg,owner,name,template_data):#line 428
    name_with_id = gensymbol ( "stringconcat")              #line 429
    instp = StringConcat_Instance_Data ()                   #line 430
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 431#line 432#line 433

def stringconcat_handler (eh,msg):                          #line 434
    inst =  eh.instance_data                                #line 435
    if  "1" ==  msg.port:                                   #line 436
        inst.buffer1 = clone_string ( msg.datum.srepr ())   #line 437
        inst.count =  inst.count+ 1                         #line 438
        maybe_stringconcat ( eh, inst, msg)                 #line 439
    elif  "2" ==  msg.port:                                 #line 440
        inst.buffer2 = clone_string ( msg.datum.srepr ())   #line 441
        inst.count =  inst.count+ 1                         #line 442
        maybe_stringconcat ( eh, inst, msg)                 #line 443
    else:                                                   #line 444
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 445#line 446#line 447#line 448

def maybe_stringconcat (eh,inst,msg):                       #line 449
    if ( 0 == len ( inst.buffer1)) and ( 0 == len ( inst.buffer2)):#line 450
        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 451
    if  inst.count >=  2:                                   #line 452
        concatenated_string =  ""                           #line 453
        if  0 == len ( inst.buffer1):                       #line 454
            concatenated_string =  inst.buffer2             #line 455
        elif  0 == len ( inst.buffer2):                     #line 456
            concatenated_string =  inst.buffer1             #line 457
        else:                                               #line 458
            concatenated_string =  inst.buffer1+ inst.buffer2#line 459
        send_string ( eh, "", concatenated_string, msg)     #line 460
        inst.buffer1 =  None                                #line 461
        inst.buffer2 =  None                                #line 462
        inst.count =  0                                     #line 463#line 464#line 465

#                                                           #line 466#line 467
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 468
def shell_out_instantiate (reg,owner,name,template_data):   #line 469
    name_with_id = gensymbol ( "shell_out")                 #line 470
    cmd = shlex.split ( template_data)                      #line 471
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)#line 472#line 473#line 474

def shell_out_handler (eh,msg):                             #line 475
    cmd =  eh.instance_data                                 #line 476
    s =  msg.datum.srepr ()                                 #line 477
    ret =  None                                             #line 478
    rc =  None                                              #line 479
    stdout =  None                                          #line 480
    stderr =  None                                          #line 481
    ret = subprocess.run ( cmd,   s, "UTF_8")
    rc = ret.returncode
    stdout = ret.stdout
    stderr = ret.stderr                                     #line 482
    if  rc!= 0:                                             #line 483
        send_string ( eh, "✗", stderr, msg)                 #line 484
    else:                                                   #line 485
        send_string ( eh, "", stdout, msg)                  #line 486#line 487#line 488#line 489

def string_constant_instantiate (reg,owner,name,template_data):#line 490
    global root_project                                     #line 491
    global root_0D                                          #line 492
    name_with_id = gensymbol ( "strconst")                  #line 493
    s =  template_data                                      #line 494
    if  root_project!= "":                                  #line 495
        s = re.sub ( "_00_",  root_project,  s)             #line 496#line 497
    if  root_0D!= "":                                       #line 498
        s = re.sub ( "_0D_",  root_0D,  s)                  #line 499#line 500
    return make_leaf ( name_with_id, owner, s, string_constant_handler)#line 501#line 502#line 503

def string_constant_handler (eh,msg):                       #line 504
    s =  eh.instance_data                                   #line 505
    send_string ( eh, "", s, msg)                           #line 506#line 507#line 508

def string_make_persistent (s):                             #line 509
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 510
    return  s                                               #line 511#line 512#line 513

def string_clone (s):                                       #line 514
    return  s                                               #line 515#line 516#line 517

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...#line 518
# where ${_00_} is the root directory for the project       #line 519
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)#line 520#line 521
def initialize_component_palette (root_project,root_0D,diagram_source_files):#line 522
    reg = make_component_registry ()                        #line 523
    for diagram_source in  diagram_source_files:            #line 524
        all_containers_within_single_file = json2internal ( root_project, diagram_source)#line 525
        reg = generate_shell_components ( reg, all_containers_within_single_file)#line 526
        for container in  all_containers_within_single_file:#line 527
            register_component ( reg,Template ( container [ "name"], container, container_instantiator))#line 528#line 529#line 530
    print ( reg)                                            #line 531
    reg = initialize_stock_components ( reg)                #line 532
    return  reg                                             #line 533#line 534#line 535

def print_error_maybe (main_container):                     #line 536
    error_port =  "✗"                                       #line 537
    err = fetch_first_output ( main_container, error_port)  #line 538
    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):#line 539
        print ( "___ !!! ERRORS !!! ___")                   #line 540
        print_specific_output ( main_container, error_port) #line 541#line 542#line 543

# debugging helpers                                         #line 544#line 545
def nl ():                                                  #line 546
    print ( "")                                             #line 547#line 548#line 549

def dump_outputs (main_container):                          #line 550
    nl ()                                                   #line 551
    print ( "___ Outputs ___")                              #line 552
    print_output_list ( main_container)                     #line 553#line 554#line 555

def trimws (s):                                             #line 556
    # remove whitespace from front and back of string       #line 557
    return  s.strip ()                                      #line 558#line 559#line 560

def clone_string (s):                                       #line 561
    return  s                                               #line 562#line 563#line 564

load_errors =  False                                        #line 565
runtime_errors =  False                                     #line 566#line 567
def load_error (s):                                         #line 568
    global load_errors                                      #line 569
    print ( s)                                              #line 570
    print ()                                                #line 571
    load_errors =  True                                     #line 572#line 573#line 574

def runtime_error (s):                                      #line 575
    global runtime_errors                                   #line 576
    print ( s)                                              #line 577
    runtime_errors =  True                                  #line 578#line 579#line 580

def fakepipename_instantiate (reg,owner,name,template_data):#line 581
    instance_name = gensymbol ( "fakepipe")                 #line 582
    return make_leaf ( instance_name, owner, None, fakepipename_handler)#line 583#line 584#line 585

rand =  0                                                   #line 586#line 587
def fakepipename_handler (eh,msg):                          #line 588
    global rand                                             #line 589
    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 590
    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)#line 591#line 592#line 593
                                                            #line 594
# all of the the built_in leaves are listed here            #line 595
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 596#line 597
def initialize_stock_components (reg):                      #line 598
    register_component ( reg,Template ( "1then2", None, deracer_instantiate))#line 599
    register_component ( reg,Template ( "?", None, probe_instantiate))#line 600
    register_component ( reg,Template ( "?A", None, probeA_instantiate))#line 601
    register_component ( reg,Template ( "?B", None, probeB_instantiate))#line 602
    register_component ( reg,Template ( "?C", None, probeC_instantiate))#line 603
    register_component ( reg,Template ( "trash", None, trash_instantiate))#line 604#line 605
    register_component ( reg,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 606
    register_component ( reg,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 607#line 608
    register_component ( reg,Template ( "syncfilewrite", None, syncfilewrite_instantiate))#line 609
    register_component ( reg,Template ( "stringconcat", None, stringconcat_instantiate))#line 610
    # for fakepipe                                          #line 611
    register_component ( reg,Template ( "fakepipename", None, fakepipename_instantiate))#line 612#line 613#line 614

def argv ():                                                #line 615
    sys.argv                                                #line 616#line 617#line 618

def initialize ():                                          #line 619
    root_of_project =  sys.argv[ 1]                         #line 620
    root_of_0D =  sys.argv[ 2]                              #line 621
    arg =  sys.argv[ 3]                                     #line 622
    main_container_name =  sys.argv[ 4]                     #line 623
    diagram_names =  sys.argv[ 5:]                          #line 624
    palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)#line 625
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 626#line 627#line 628

def start (palette,env):
    start_helper ( palette, env, False)                     #line 629

def start_show_all (palette,env):
    start_helper ( palette, env, True)                      #line 630

def start_helper (palette,env,show_all_outputs):            #line 631
    root_of_project =  env [ 0]                             #line 632
    root_of_0D =  env [ 1]                                  #line 633
    main_container_name =  env [ 2]                         #line 634
    diagram_names =  env [ 3]                               #line 635
    arg =  env [ 4]                                         #line 636
    set_environment ( root_of_project, root_of_0D)          #line 637
    # get entrypoint container                              #line 638
    main_container = get_component_instance ( palette, main_container_name, None)#line 639
    if  None ==  main_container:                            #line 640
        load_error ( str( "Couldn't find container with page name /") +  str( main_container_name) +  str( "/ in files ") +  str(str ( diagram_names)) +  " (check tab names, or disable compression?)"    )#line 644#line 645
    if not  load_errors:                                    #line 646
        arg = new_datum_string ( arg)                       #line 647
        msg = make_message ( "", arg)                       #line 648
        inject ( main_container, msg)                       #line 649
        if  show_all_outputs:                               #line 650
            dump_outputs ( main_container)                  #line 651
        else:                                               #line 652
            print_error_maybe ( main_container)             #line 653
            outp = fetch_first_output ( main_container, "") #line 654
            if  None ==  outp:                              #line 655
                print ( "(no outputs)")                     #line 656
            else:                                           #line 657
                print_specific_output ( main_container, "") #line 658#line 659#line 660
        if  show_all_outputs:                               #line 661
            print ( "--- done ---")                         #line 662#line 663#line 664#line 665#line 666
                                                            #line 667#line 668
# utility functions                                         #line 669
def send_int (eh,port,i,causing_message):                   #line 670
    datum = new_datum_int ( i)                              #line 671
    send ( eh, port, datum, causing_message)                #line 672#line 673#line 674

def send_bang (eh,port,causing_message):                    #line 675
    datum = new_datum_bang ()                               #line 676
    send ( eh, port, datum, causing_message)                #line 677#line 678#line 679





