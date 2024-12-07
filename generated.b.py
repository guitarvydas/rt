
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
                    generated_leaf = mkTemplate ( name, shell_out_instantiate, cmd)#line 107
                    register_component ( reg, generated_leaf)#line 108
                elif first_char_is ( child_descriptor [ "name"], "'"):#line 109
                    name =  child_descriptor [ "name"]      #line 110
                    s =   name[1:]                          #line 111
                    generated_leaf = mkTemplate ( name, string_constant_instantiate, s)#line 112
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
        self.inq =  deque ([])                              #line 152
        self.outq =  deque ([])                             #line 153
        self.owner =  None                                  #line 154
        self.children = []                                  #line 155
        self.visit_ordering =  deque ([])                   #line 156
        self.connections = []                               #line 157
        self.routings =  deque ([])                         #line 158
        self.handler =  None                                #line 159
        self.finject =  None                                #line 160
        self.instance_data =  None                          #line 161
        self.state =  "idle"                                #line 162# bootstrap debugging#line 163
        self.kind =  None # enum { container, leaf, }       #line 164#line 165
                                                            #line 166
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 167
# whose handler function is `container_handler`.            #line 168
def make_container (name,owner):                            #line 169
    eh =  Eh ()                                             #line 170
    eh.name =  name                                         #line 171
    eh.owner =  owner                                       #line 172
    eh.handler =  container_handler                         #line 173
    eh.finject =  container_injector                        #line 174
    eh.state =  "idle"                                      #line 175
    eh.kind =  "container"                                  #line 176
    return  eh                                              #line 177#line 178#line 179

# Creates a new leaf component out of a handler function, and a data parameter#line 180
# that will be passed back to your handler when called.     #line 181#line 182
def make_leaf (name,owner,instance_data,handler):           #line 183
    eh =  Eh ()                                             #line 184
    eh.name =  str( owner.name) +  str( ".") +  name        #line 185
    eh.owner =  owner                                       #line 186
    eh.handler =  handler                                   #line 187
    eh.instance_data =  instance_data                       #line 188
    eh.state =  "idle"                                      #line 189
    eh.kind =  "leaf"                                       #line 190
    return  eh                                              #line 191#line 192#line 193

# Sends a message on the given `port` with `data`, placing it on the output#line 194
# of the given component.                                   #line 195#line 196
def send (eh,port,datum,causingMessage):                    #line 197
    msg = make_message ( port, datum)                       #line 198
    put_output ( eh, msg)                                   #line 199#line 200#line 201

def send_string (eh,port,s,causingMessage):                 #line 202
    datum = new_datum_string ( s)                           #line 203
    msg = make_message ( port, datum)                       #line 204
    put_output ( eh, msg)                                   #line 205#line 206#line 207

def forward (eh,port,msg):                                  #line 208
    fwdmsg = make_message ( port, msg.datum)                #line 209
    put_output ( eh, msg)                                   #line 210#line 211#line 212

def inject (eh,msg):                                        #line 213
    eh.finject ( eh, msg)                                   #line 214#line 215#line 216

# Returns a list of all output messages on a container.     #line 217
# For testing / debugging purposes.                         #line 218#line 219
def output_list (eh):                                       #line 220
    return  eh.outq                                         #line 221#line 222#line 223

# Utility for printing an array of messages.                #line 224
def print_output_list (eh):                                 #line 225
    for m in  list ( eh.outq):                              #line 226
        print (format_message ( m))                         #line 227#line 228#line 229

def spaces (n):                                             #line 230
    s =  ""                                                 #line 231
    for i in range( n):                                     #line 232
        s =  s+ " "                                         #line 233
    return  s                                               #line 234#line 235#line 236

def set_active (eh):                                        #line 237
    eh.state =  "active"                                    #line 238#line 239#line 240

def set_idle (eh):                                          #line 241
    eh.state =  "idle"                                      #line 242#line 243#line 244

# Utility for printing a specific output message.           #line 245#line 246
def fetch_first_output (eh,port):                           #line 247
    for msg in  list ( eh.outq):                            #line 248
        if ( msg.port ==  port):                            #line 249
            return  msg.datum                               #line 250
    return  None                                            #line 251#line 252#line 253

def print_specific_output (eh,port):                        #line 254
    # port ∷ “”                                             #line 255
    datum = fetch_first_output ( eh, port)                  #line 256
    print ( datum.srepr ())                                 #line 257#line 258

def print_specific_output_to_stderr (eh,port):              #line 259
    # port ∷ “”                                             #line 260
    datum = fetch_first_output ( eh, port)                  #line 261
    # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 262
    print ( datum.srepr (), file=sys.stderr)                #line 263#line 264#line 265

def put_output (eh,msg):                                    #line 266
    eh.outq.append ( msg)                                   #line 267#line 268#line 269

root_project =  ""                                          #line 270
root_0D =  ""                                               #line 271#line 272
def set_environment (rproject,r0D):                         #line 273
    global root_project                                     #line 274
    global root_0D                                          #line 275
    root_project =  rproject                                #line 276
    root_0D =  r0D                                          #line 277#line 278#line 279

def probe_instantiate (reg,owner,name,template_data):       #line 280
    name_with_id = gensymbol ( "?")                         #line 281
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 282#line 283

def probeA_instantiate (reg,owner,name,template_data):      #line 284
    name_with_id = gensymbol ( "?A")                        #line 285
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 286#line 287#line 288

def probeB_instantiate (reg,owner,name,template_data):      #line 289
    name_with_id = gensymbol ( "?B")                        #line 290
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 291#line 292#line 293

def probeC_instantiate (reg,owner,name,template_data):      #line 294
    name_with_id = gensymbol ( "?C")                        #line 295
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 296#line 297#line 298

def probe_handler (eh,msg):                                 #line 299
    s =  msg.datum.srepr ()                                 #line 300
    print ( str( "... probe ") +  str( eh.name) +  str( ": ") +  s   , file=sys.stderr)#line 301#line 302#line 303

def trash_instantiate (reg,owner,name,template_data):       #line 304
    name_with_id = gensymbol ( "trash")                     #line 305
    return make_leaf ( name_with_id, owner, None, trash_handler)#line 306#line 307#line 308

def trash_handler (eh,msg):                                 #line 309
    # to appease dumped_on_floor checker                    #line 310
    pass                                                    #line 311#line 312

class TwoMessages:
    def __init__ (self,):                                   #line 313
        self.firstmsg =  None                               #line 314
        self.secondmsg =  None                              #line 315#line 316
                                                            #line 317
# Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg }#line 318
class Deracer_Instance_Data:
    def __init__ (self,):                                   #line 319
        self.state =  None                                  #line 320
        self.buffer =  None                                 #line 321#line 322
                                                            #line 323
def reclaim_Buffers_from_heap (inst):                       #line 324
    pass                                                    #line 325#line 326#line 327

def deracer_instantiate (reg,owner,name,template_data):     #line 328
    name_with_id = gensymbol ( "deracer")                   #line 329
    inst =  Deracer_Instance_Data ()                        #line 330
    inst.state =  "idle"                                    #line 331
    inst.buffer =  TwoMessages ()                           #line 332
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 333
    return  eh                                              #line 334#line 335#line 336

def send_firstmsg_then_secondmsg (eh,inst):                 #line 337
    forward ( eh, "1", inst.buffer.firstmsg)                #line 338
    forward ( eh, "2", inst.buffer.secondmsg)               #line 339
    reclaim_Buffers_from_heap ( inst)                       #line 340#line 341#line 342

def deracer_handler (eh,msg):                               #line 343
    inst =  eh.instance_data                                #line 344
    if  inst.state ==  "idle":                              #line 345
        if  "1" ==  msg.port:                               #line 346
            inst.buffer.firstmsg =  msg                     #line 347
            inst.state =  "waitingForSecondmsg"             #line 348
        elif  "2" ==  msg.port:                             #line 349
            inst.buffer.secondmsg =  msg                    #line 350
            inst.state =  "waitingForFirstmsg"              #line 351
        else:                                               #line 352
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 353
    elif  inst.state ==  "waitingForFirstmsg":              #line 354
        if  "1" ==  msg.port:                               #line 355
            inst.buffer.firstmsg =  msg                     #line 356
            send_firstmsg_then_secondmsg ( eh, inst)        #line 357
            inst.state =  "idle"                            #line 358
        else:                                               #line 359
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 360
    elif  inst.state ==  "waitingForSecondmsg":             #line 361
        if  "2" ==  msg.port:                               #line 362
            inst.buffer.secondmsg =  msg                    #line 363
            send_firstmsg_then_secondmsg ( eh, inst)        #line 364
            inst.state =  "idle"                            #line 365
        else:                                               #line 366
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg.port )#line 367
    else:                                                   #line 368
        runtime_error ( "bad state for deracer {eh.state}") #line 369#line 370#line 371

def low_level_read_text_file_instantiate (reg,owner,name,template_data):#line 372
    name_with_id = gensymbol ( "Low Level Read Text File")  #line 373
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 374#line 375#line 376

def low_level_read_text_file_handler (eh,msg):              #line 377
    fname =  msg.datum.srepr ()                             #line 378

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
                                                            #line 379#line 380#line 381

def ensure_string_datum_instantiate (reg,owner,name,template_data):#line 382
    name_with_id = gensymbol ( "Ensure String Datum")       #line 383
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)#line 384#line 385#line 386

def ensure_string_datum_handler (eh,msg):                   #line 387
    if  "string" ==  msg.datum.kind ():                     #line 388
        forward ( eh, "", msg)                              #line 389
    else:                                                   #line 390
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum #line 391
        send_string ( eh, "✗", emsg, msg)                   #line 392#line 393#line 394

class Syncfilewrite_Data:
    def __init__ (self,):                                   #line 395
        self.filename =  ""                                 #line 396#line 397
                                                            #line 398
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)#line 399
def syncfilewrite_instantiate (reg,owner,name,template_data):#line 400
    name_with_id = gensymbol ( "syncfilewrite")             #line 401
    inst =  Syncfilewrite_Data ()                           #line 402
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)#line 403#line 404#line 405

def syncfilewrite_handler (eh,msg):                         #line 406
    inst =  eh.instance_data                                #line 407
    if  "filename" ==  msg.port:                            #line 408
        inst.filename =  msg.datum.srepr ()                 #line 409
    elif  "input" ==  msg.port:                             #line 410
        contents =  msg.datum.srepr ()                      #line 411
        f = open ( inst.filename, "w")                      #line 412
        if  f!= None:                                       #line 413
            f.write ( msg.datum.srepr ())                   #line 414
            f.close ()                                      #line 415
            send ( eh, "done",new_datum_bang (), msg)       #line 416
        else:                                               #line 417
            send_string ( eh, "✗", str( "open error on file ") +  inst.filename , msg)#line 418#line 419#line 420

class StringConcat_Instance_Data:
    def __init__ (self,):                                   #line 421
        self.buffer1 =  None                                #line 422
        self.buffer2 =  None                                #line 423
        self.scount =  0                                    #line 424#line 425
                                                            #line 426
def stringconcat_instantiate (reg,owner,name,template_data):#line 427
    name_with_id = gensymbol ( "stringconcat")              #line 428
    instp =  StringConcat_Instance_Data ()                  #line 429
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 430#line 431#line 432

def stringconcat_handler (eh,msg):                          #line 433
    inst =  eh.instance_data                                #line 434
    if  "1" ==  msg.port:                                   #line 435
        inst.buffer1 = clone_string ( msg.datum.srepr ())   #line 436
        inst.scount =  inst.scount+ 1                       #line 437
        maybe_stringconcat ( eh, inst, msg)                 #line 438
    elif  "2" ==  msg.port:                                 #line 439
        inst.buffer2 = clone_string ( msg.datum.srepr ())   #line 440
        inst.scount =  inst.scount+ 1                       #line 441
        maybe_stringconcat ( eh, inst, msg)                 #line 442
    else:                                                   #line 443
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 444#line 445#line 446#line 447

def maybe_stringconcat (eh,inst,msg):                       #line 448
    if ( 0 == len ( inst.buffer1)) and ( 0 == len ( inst.buffer2)):#line 449
        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 450
    if  inst.scount >=  2:                                  #line 451
        concatenated_string =  ""                           #line 452
        if  0 == len ( inst.buffer1):                       #line 453
            concatenated_string =  inst.buffer2             #line 454
        elif  0 == len ( inst.buffer2):                     #line 455
            concatenated_string =  inst.buffer1             #line 456
        else:                                               #line 457
            concatenated_string =  inst.buffer1+ inst.buffer2#line 458
        send_string ( eh, "", concatenated_string, msg)     #line 459
        inst.buffer1 =  None                                #line 460
        inst.buffer2 =  None                                #line 461
        inst.scount =  0                                    #line 462#line 463#line 464

#                                                           #line 465#line 466
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 467
def shell_out_instantiate (reg,owner,name,template_data):   #line 468
    name_with_id = gensymbol ( "shell_out")                 #line 469
    cmd = shlex.split ( template_data)                      #line 470
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)#line 471#line 472#line 473

def shell_out_handler (eh,msg):                             #line 474
    cmd =  eh.instance_data                                 #line 475
    s =  msg.datum.srepr ()                                 #line 476
    ret =  None                                             #line 477
    rc =  None                                              #line 478
    stdout =  None                                          #line 479
    stderr =  None                                          #line 480
    ret = subprocess.run ( cmd,   s, "UTF_8")
    rc = ret.returncode
    stdout = ret.stdout
    stderr = ret.stderr                                     #line 481
    if  rc!= 0:                                             #line 482
        send_string ( eh, "✗", stderr, msg)                 #line 483
    else:                                                   #line 484
        send_string ( eh, "", stdout, msg)                  #line 485#line 486#line 487#line 488

def string_constant_instantiate (reg,owner,name,template_data):#line 489
    global root_project                                     #line 490
    global root_0D                                          #line 491
    name_with_id = gensymbol ( "strconst")                  #line 492
    s =  template_data                                      #line 493
    if  root_project!= "":                                  #line 494
        s = re.sub ( "_00_",  root_project,  s)             #line 495#line 496
    if  root_0D!= "":                                       #line 497
        s = re.sub ( "_0D_",  root_0D,  s)                  #line 498#line 499
    return make_leaf ( name_with_id, owner, s, string_constant_handler)#line 500#line 501#line 502

def string_constant_handler (eh,msg):                       #line 503
    s =  eh.instance_data                                   #line 504
    send_string ( eh, "", s, msg)                           #line 505#line 506#line 507

def string_make_persistent (s):                             #line 508
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 509
    return  s                                               #line 510#line 511#line 512

def string_clone (s):                                       #line 513
    return  s                                               #line 514#line 515#line 516

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...#line 517
# where ${_00_} is the root directory for the project       #line 518
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)#line 519#line 520
def initialize_component_palette (root_project,root_0D,diagram_source_files):#line 521
    reg = make_component_registry ()                        #line 522
    for diagram_source in  diagram_source_files:            #line 523
        all_containers_within_single_file = json2internal ( root_project, diagram_source)#line 524
        reg = generate_shell_components ( reg, all_containers_within_single_file)#line 525
        for container in  all_containers_within_single_file:#line 526
            register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))#line 527#line 528#line 529
    initialize_stock_components ( reg)                      #line 530
    return  reg                                             #line 531#line 532#line 533

def print_error_maybe (main_container):                     #line 534
    error_port =  "✗"                                       #line 535
    err = fetch_first_output ( main_container, error_port)  #line 536
    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):#line 537
        print ( "___ !!! ERRORS !!! ___")                   #line 538
        print_specific_output ( main_container, error_port) #line 539#line 540#line 541

# debugging helpers                                         #line 542#line 543
def nl ():                                                  #line 544
    print ( "")                                             #line 545#line 546#line 547

def dump_outputs (main_container):                          #line 548
    nl ()                                                   #line 549
    print ( "___ Outputs ___")                              #line 550
    print_output_list ( main_container)                     #line 551#line 552#line 553

def trimws (s):                                             #line 554
    # remove whitespace from front and back of string       #line 555
    return  s.strip ()                                      #line 556#line 557#line 558

def clone_string (s):                                       #line 559
    return  s                                               #line 560#line 561#line 562

load_errors =  False                                        #line 563
runtime_errors =  False                                     #line 564#line 565
def load_error (s):                                         #line 566
    global load_errors                                      #line 567
    print ( s)                                              #line 568
    print ()                                                #line 569
    load_errors =  True                                     #line 570#line 571#line 572

def runtime_error (s):                                      #line 573
    global runtime_errors                                   #line 574
    print ( s)                                              #line 575
    runtime_errors =  True                                  #line 576#line 577#line 578

def fakepipename_instantiate (reg,owner,name,template_data):#line 579
    instance_name = gensymbol ( "fakepipe")                 #line 580
    return make_leaf ( instance_name, owner, None, fakepipename_handler)#line 581#line 582#line 583

rand =  0                                                   #line 584#line 585
def fakepipename_handler (eh,msg):                          #line 586
    global rand                                             #line 587
    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 588
    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)#line 589#line 590#line 591
                                                            #line 592
# all of the the built_in leaves are listed here            #line 593
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 594#line 595
def initialize_stock_components (reg):                      #line 596
    register_component ( reg,mkTemplate ( "1then2", None, deracer_instantiate))#line 597
    register_component ( reg,mkTemplate ( "?", None, probe_instantiate))#line 598
    register_component ( reg,mkTemplate ( "?A", None, probeA_instantiate))#line 599
    register_component ( reg,mkTemplate ( "?B", None, probeB_instantiate))#line 600
    register_component ( reg,mkTemplate ( "?C", None, probeC_instantiate))#line 601
    register_component ( reg,mkTemplate ( "trash", None, trash_instantiate))#line 602#line 603
    register_component ( reg,mkTemplate ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 604
    register_component ( reg,mkTemplate ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 605#line 606
    register_component ( reg,mkTemplate ( "syncfilewrite", None, syncfilewrite_instantiate))#line 607
    register_component ( reg,mkTemplate ( "stringconcat", None, stringconcat_instantiate))#line 608
    # for fakepipe                                          #line 609
    register_component ( reg,mkTemplate ( "fakepipename", None, fakepipename_instantiate))#line 610#line 611#line 612

def initialize ():                                          #line 613
    root_of_project =  sys.argv[ 1]                         #line 614
    root_of_0D =  sys.argv[ 2]                              #line 615
    arg =  sys.argv[ 3]                                     #line 616
    main_container_name =  sys.argv[ 4]                     #line 617
    diagram_names =  sys.argv[ 5:]                          #line 618
    palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)#line 619
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 620#line 621#line 622

def start (palette,env):
    start_helper ( palette, env, False)                     #line 623

def start_show_all (palette,env):
    start_helper ( palette, env, True)                      #line 624

def start_helper (palette,env,show_all_outputs):            #line 625
    root_of_project =  env [ 0]                             #line 626
    root_of_0D =  env [ 1]                                  #line 627
    main_container_name =  env [ 2]                         #line 628
    diagram_names =  env [ 3]                               #line 629
    arg =  env [ 4]                                         #line 630
    set_environment ( root_of_project, root_of_0D)          #line 631
    # get entrypoint container                              #line 632
    main_container = get_component_instance ( palette, main_container_name, None)#line 633
    if  None ==  main_container:                            #line 634
        load_error ( str( "Couldn't find container with page name /") +  str( main_container_name) +  str( "/ in files ") +  str(str ( diagram_names)) +  " (check tab names, or disable compression?)"    )#line 638#line 639
    if not  load_errors:                                    #line 640
        marg = new_datum_string ( arg)                      #line 641
        msg = make_message ( "", marg)                      #line 642
        inject ( main_container, msg)                       #line 643
        if  show_all_outputs:                               #line 644
            dump_outputs ( main_container)                  #line 645
        else:                                               #line 646
            print_error_maybe ( main_container)             #line 647
            outp = fetch_first_output ( main_container, "") #line 648
            if  None ==  outp:                              #line 649
                print ( "(no outputs)")                     #line 650
            else:                                           #line 651
                print_specific_output ( main_container, "") #line 652#line 653#line 654
        if  show_all_outputs:                               #line 655
            print ( "--- done ---")                         #line 656#line 657#line 658#line 659#line 660
                                                            #line 661#line 662
# utility functions                                         #line 663
def send_int (eh,port,i,causing_message):                   #line 664
    datum = new_datum_int ( i)                              #line 665
    send ( eh, port, datum, causing_message)                #line 666#line 667#line 668

def send_bang (eh,port,causing_message):                    #line 669
    datum = new_datum_bang ()                               #line 670
    send ( eh, port, datum, causing_message)                #line 671#line 672#line 673





