
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
def Template (name,template_data,instantiator):             #line 14
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
    if  name in  reg.templates and not  ok_to_overwrite:    #line 45
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
                instance_name =  template_name              #line 68
            instance =  template.instantiator ( reg, owner, instance_name, template.template_data)#line 69
            return  instance                                #line 70
    else:                                                   #line 71
        load_error ( str( "Registry Error (B): Can't find component /") +  str( template_name) +  "/"  )#line 72
        return  None                                        #line 73#line 74#line 75

def dump_registry (reg):                                    #line 76
    nl ()                                                   #line 77
    print ( "*** PALETTE ***")                              #line 78
    for c in  reg.templates:                                #line 79
        print ( c.name)                                     #line 80
    print ( "***************")                              #line 81
    nl ()                                                   #line 82#line 83#line 84

def print_stats (reg):                                      #line 85
    print ( str( "registry statistics: ") +  reg.stats )    #line 86#line 87#line 88

def mangle_name (s):                                        #line 89
    # trim name to remove code from Container component names _ deferred until later (or never)#line 90
    return  s                                               #line 91#line 92#line 93

def generate_shell_components (reg,container_list):         #line 94
    # [                                                     #line 95
    #     {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 96
    #     {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []}#line 97
    # ]                                                     #line 98
    if  None!= container_list:                              #line 99
        for diagram in  container_list:                     #line 100
            # loop through every component in the diagram and look for names that start with “$“#line 101
            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 102
            for child_descriptor in  diagram [ "children"]: #line 103
                if first_char_is ( child_descriptor [ "name"], "$"):#line 104
                    name =  child_descriptor [ "name"]      #line 105
                    cmd =   name[1:] .strip ()              #line 106
                    generated_leaf = Template ( name, shell_out_instantiate, cmd)#line 107
                    register_component ( reg, generated_leaf)#line 108
                elif first_char_is ( child_descriptor [ "name"], "'"):#line 109
                    name =  child_descriptor [ "name"]      #line 110
                    s =   name[1:]                          #line 111
                    generated_leaf = Template ( name, string_constant_instantiate, s)#line 112
                    register_component_allow_overwriting ( reg, generated_leaf)#line 113#line 114#line 115#line 116#line 117
    return  reg                                             #line 118#line 119#line 120

def first_char (s):                                         #line 121
    return   s[0]                                           #line 122#line 123#line 124

def first_char_is (s,c):                                    #line 125
    return  c == first_char ( s)                            #line 126#line 127#line 128
                                                            #line 129
# TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 130
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 131#line 132#line 133
# Data for an asyncronous component _ effectively, a function with input#line 134
# and output queues of messages.                            #line 135
#                                                           #line 136
# Components can either be a user_supplied function (“lea“), or a “container“#line 137
# that routes messages to child components according to a list of connections#line 138
# that serve as a message routing table.                    #line 139
#                                                           #line 140
# Child components themselves can be leaves or other containers.#line 141
#                                                           #line 142
# `handler` invokes the code that is attached to this component.#line 143
#                                                           #line 144
# `instance_data` is a pointer to instance data that the `leaf_handler`#line 145
# function may want whenever it is invoked again.           #line 146
#                                                           #line 147#line 148
# Eh_States :: enum { idle, active }                        #line 149
class Eh:
    def __init__ (self,):                                   #line 150
        self.name =  ""                                     #line 151
        self.inq =  queue.Queue ()                          #line 152
        self.outq =  queue.Queue ()                         #line 153
        self.owner =  None                                  #line 154
        self.saved_messages =  queue.LifoQueue () # stack of saved message(s)#line 155
        self.children = []                                  #line 156
        self.visit_ordering =  queue.Queue ()               #line 157
        self.connections = []                               #line 158
        self.routings =  queue.Queue ()                     #line 159
        self.handler =  None                                #line 160
        self.finject =  None                                #line 161
        self.instance_data =  None                          #line 162
        self.state =  "idle"                                #line 163# bootstrap debugging#line 164
        self.kind =  None # enum { container, leaf, }       #line 165#line 166
                                                            #line 167
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 168
# whose handler function is `container_handler`.            #line 169
def make_container (name,owner):                            #line 170
    eh =  Eh ()                                             #line 171
    eh.name =  name                                         #line 172
    eh.owner =  owner                                       #line 173
    eh.handler =  container_handler                         #line 174
    eh.finject =  container_injector                        #line 175
    eh.state =  "idle"                                      #line 176
    eh.kind =  "container"                                  #line 177
    return  eh                                              #line 178#line 179#line 180

# Creates a new leaf component out of a handler function, and a data parameter#line 181
# that will be passed back to your handler when called.     #line 182#line 183
def make_leaf (name,owner,instance_data,handler):           #line 184
    eh =  Eh ()                                             #line 185
    eh.name =  str( owner.name) +  str( ".") +  name        #line 186
    eh.owner =  owner                                       #line 187
    eh.handler =  handler                                   #line 188
    eh.instance_data =  instance_data                       #line 189
    eh.state =  "idle"                                      #line 190
    eh.kind =  "leaf"                                       #line 191
    return  eh                                              #line 192#line 193#line 194

# Sends a message on the given `port` with `data`, placing it on the output#line 195
# of the given component.                                   #line 196#line 197
def send (eh,port,datum,causingMessage):                    #line 198
    msg = make_message ( port, datum)                       #line 199
    put_output ( eh, msg)                                   #line 200#line 201#line 202

def send_string (eh,port,s,causingMessage):                 #line 203
    datum = new_datum_string ( s)                           #line 204
    msg = make_message ( port, datum)                       #line 205
    put_output ( eh, msg)                                   #line 206#line 207#line 208

def forward (eh,port,msg):                                  #line 209
    fwdmsg = make_message ( port, msg.datum)                #line 210
    put_output ( eh, msg)                                   #line 211#line 212#line 213

def inject (eh,msg):                                        #line 214
    eh.finject ( eh, msg)                                   #line 215#line 216#line 217

# Returns a list of all output messages on a container.     #line 218
# For testing / debugging purposes.                         #line 219#line 220
def output_list (eh):                                       #line 221
    return  eh.outq                                         #line 222#line 223#line 224

# Utility for printing an array of messages.                #line 225
def print_output_list (eh):                                 #line 226
    for m in list ( eh.outq.queue):                         #line 227
        print (format_message ( m))                         #line 228#line 229#line 230

def spaces (n):                                             #line 231
    s =  ""                                                 #line 232
    for i in range( n):                                     #line 233
        s =  s+ " "                                         #line 234
    return  s                                               #line 235#line 236#line 237

def set_active (eh):                                        #line 238
    eh.state =  "active"                                    #line 239#line 240#line 241

def set_idle (eh):                                          #line 242
    eh.state =  "idle"                                      #line 243#line 244#line 245

# Utility for printing a specific output message.           #line 246#line 247
def fetch_first_output (eh,port):                           #line 248
    for msg in list ( eh.outq.queue):                       #line 249
        if ( msg.port ==  port):                            #line 250
            return  msg.datum                               #line 251
    return  None                                            #line 252#line 253#line 254

def print_specific_output (eh,port):                        #line 255
    # port ∷ “”                                             #line 256
    datum = fetch_first_output ( eh, port)                  #line 257
    print ( datum.srepr ())                                 #line 258#line 259

def print_specific_output_to_stderr (eh,port):              #line 260
    # port ∷ “”                                             #line 261
    datum = fetch_first_output ( eh, port)                  #line 262
    # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 263
    print ( datum.srepr (), file=sys.stderr)                #line 264#line 265#line 266

def put_output (eh,msg):                                    #line 267
    eh.outq.put ( msg)                                      #line 268#line 269#line 270

root_project =  ""                                          #line 271
root_0D =  ""                                               #line 272#line 273
def set_environment (rproject,r0D):                         #line 274
    global root_project                                     #line 275
    global root_0D                                          #line 276
    root_project =  rproject                                #line 277
    root_0D =  r0D                                          #line 278#line 279#line 280

def probe_instantiate (reg,owner,name,template_data):       #line 281
    name_with_id = gensymbol ( "?")                         #line 282
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 283#line 284

def probeA_instantiate (reg,owner,name,template_data):      #line 285
    name_with_id = gensymbol ( "?A")                        #line 286
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 287#line 288#line 289

def probeB_instantiate (reg,owner,name,template_data):      #line 290
    name_with_id = gensymbol ( "?B")                        #line 291
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 292#line 293#line 294

def probeC_instantiate (reg,owner,name,template_data):      #line 295
    name_with_id = gensymbol ( "?C")                        #line 296
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 297#line 298#line 299

def probe_handler (eh,msg):                                 #line 300
    s =  msg.datum.srepr ()                                 #line 301
    print ( str( "... probe ") +  str( eh.name) +  str( ": ") +  s   , file=sys.stderr)#line 302#line 303#line 304

def trash_instantiate (reg,owner,name,template_data):       #line 305
    name_with_id = gensymbol ( "trash")                     #line 306
    return make_leaf ( name_with_id, owner, None, trash_handler)#line 307#line 308#line 309

def trash_handler (eh,msg):                                 #line 310
    # to appease dumped_on_floor checker                    #line 311
    pass                                                    #line 312#line 313

class TwoMessages:
    def __init__ (self,):                                   #line 314
        self.firstmsg =  None                               #line 315
        self.secondmsg =  None                              #line 316#line 317
                                                            #line 318
# Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg }#line 319
class Deracer_Instance_Data:
    def __init__ (self,):                                   #line 320
        self.state =  None                                  #line 321
        self.buffer =  None                                 #line 322#line 323
                                                            #line 324
def reclaim_Buffers_from_heap (inst):                       #line 325
    pass                                                    #line 326#line 327#line 328

def deracer_instantiate (reg,owner,name,template_data):     #line 329
    name_with_id = gensymbol ( "deracer")                   #line 330
    inst =  Deracer_Instance_Data ()                        #line 331
    inst.state =  "idle"                                    #line 332
    inst.buffer =  TwoMessages ()                           #line 333
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 334
    return  eh                                              #line 335#line 336#line 337

def send_firstmsg_then_secondmsg (eh,inst):                 #line 338
    forward ( eh, "1", inst.buffer.firstmsg)                #line 339
    forward ( eh, "2", inst.buffer.secondmsg)               #line 340
    reclaim_Buffers_from_heap ( inst)                       #line 341#line 342#line 343

def deracer_handler (eh,msg):                               #line 344
    inst =  eh.instance_data                                #line 345
    if  inst.state ==  "idle":                              #line 346
        if  "1" ==  msg.port:                               #line 347
            inst.buffer.firstmsg =  msg                     #line 348
            inst.state =  "waitingForSecondmsg"             #line 349
        elif  "2" ==  msg.port:                             #line 350
            inst.buffer.secondmsg =  msg                    #line 351
            inst.state =  "waitingForFirstmsg"              #line 352
        else:                                               #line 353
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 354
    elif  inst.state ==  "waitingForFirstmsg":              #line 355
        if  "1" ==  msg.port:                               #line 356
            inst.buffer.firstmsg =  msg                     #line 357
            send_firstmsg_then_secondmsg ( eh, inst)        #line 358
            inst.state =  "idle"                            #line 359
        else:                                               #line 360
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 361
    elif  inst.state ==  "waitingForSecondmsg":             #line 362
        if  "2" ==  msg.port:                               #line 363
            inst.buffer.secondmsg =  msg                    #line 364
            send_firstmsg_then_secondmsg ( eh, inst)        #line 365
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
    inst =  Syncfilewrite_Data ()                           #line 403
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
        self.scount =  0                                    #line 425#line 426
                                                            #line 427
def stringconcat_instantiate (reg,owner,name,template_data):#line 428
    name_with_id = gensymbol ( "stringconcat")              #line 429
    instp =  StringConcat_Instance_Data ()                  #line 430
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 431#line 432#line 433

def stringconcat_handler (eh,msg):                          #line 434
    inst =  eh.instance_data                                #line 435
    if  "1" ==  msg.port:                                   #line 436
        inst.buffer1 = clone_string ( msg.datum.srepr ())   #line 437
        inst.scount =  inst.scount+ 1                       #line 438
        maybe_stringconcat ( eh, inst, msg)                 #line 439
    elif  "2" ==  msg.port:                                 #line 440
        inst.buffer2 = clone_string ( msg.datum.srepr ())   #line 441
        inst.scount =  inst.scount+ 1                       #line 442
        maybe_stringconcat ( eh, inst, msg)                 #line 443
    else:                                                   #line 444
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 445#line 446#line 447#line 448

def maybe_stringconcat (eh,inst,msg):                       #line 449
    if ( 0 == len ( inst.buffer1)) and ( 0 == len ( inst.buffer2)):#line 450
        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 451
    if  inst.scount >=  2:                                  #line 452
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
        inst.scount =  0                                    #line 463#line 464#line 465

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





