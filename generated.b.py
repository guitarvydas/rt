
                                                                                #line 1#line 2#line 3
class Component_Registry:
    def __init__ (self,):                                                       #line 4
        self.templates = {}                                                     #line 5#line 6
                                                                                #line 7
class Template:
    def __init__ (self,name,template_data,instantiator):                        #line 8
        self.name =  name                                                       #line 9
        self.template_data =  template_data                                     #line 10
        self.instantiator =  instantiator                                       #line 11#line 12
                                                                                #line 13
def read_and_convert_json_file (filename):                                      #line 14

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

def json2internal (container_xml):                                              #line 18
    fname =  os.path.basename ( container_xml)                                  #line 19
    routings = read_and_convert_json_file ( fname)                              #line 20
    return  routings                                                            #line 21#line 22#line 23

def delete_decls (d):                                                           #line 24
    pass                                                                        #line 25#line 26#line 27

def make_component_registry ():                                                 #line 28
    return Component_Registry ()                                                #line 29#line 30#line 31

def register_component (reg,template):
    return abstracted_register_component ( reg, template, False)                #line 32

def register_component_allow_overwriting (reg,template):
    return abstracted_register_component ( reg, template, True)                 #line 33#line 34

def abstracted_register_component (reg,template,ok_to_overwrite):               #line 35
    name = mangle_name ( template. name)                                        #line 36
    if  name in  reg. templates and not  ok_to_overwrite:                       #line 37
        load_error ( str( "Component ") +  str( template. name) +  " already declared"  )#line 38
    reg. templates [ name] =  template                                          #line 39
    return  reg                                                                 #line 40#line 41#line 42

def register_multiple_components (reg,templates):                               #line 43
    for template in  templates:                                                 #line 44
        register_component ( reg, template)                                     #line 45#line 46#line 47

def get_component_instance (reg,full_name,owner):                               #line 48
    template_name = mangle_name ( full_name)                                    #line 49
    if  template_name in  reg. templates:                                       #line 50
        template =  reg. templates [ template_name]                             #line 51
        if ( template ==  None):                                                #line 52
            load_error ( str( "Registry Error: Can;t find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )#line 53
            return  None                                                        #line 54
        else:                                                                   #line 55
            owner_name =  ""                                                    #line 56
            instance_name =  template_name                                      #line 57
            if  None!= owner:                                                   #line 58
                owner_name =  owner. name                                       #line 59
                instance_name =  str( owner_name) +  str( ".") +  template_name  #line 60
            else:                                                               #line 61
                instance_name =  template_name                                  #line 62
            instance =  template.instantiator ( reg, owner, instance_name, template. template_data)#line 63
            instance. depth = calculate_depth ( instance)                       #line 64
            return  instance                                                    #line 65
    else:                                                                       #line 66
        load_error ( str( "Registry Error: Can't find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )#line 67
        return  None                                                            #line 68#line 69

def calculate_depth (eh):                                                       #line 70
    if  eh. owner ==  None:                                                     #line 71
        return  0                                                               #line 72
    else:                                                                       #line 73
        return  1+calculate_depth ( eh. owner)                                  #line 74#line 75#line 76

def dump_registry (reg):                                                        #line 77
    nl ()                                                                       #line 78
    print ( "*** PALETTE ***")                                                  #line 79
    for c in  reg. templates:                                                   #line 80
        print ( c. name)                                                        #line 81
    print ( "***************")                                                  #line 82
    nl ()                                                                       #line 83#line 84#line 85

def print_stats (reg):                                                          #line 86
    print ( str( "registry statistics: ") +  reg. stats )                       #line 87#line 88#line 89

def mangle_name (s):                                                            #line 90
    # trim name to remove code from Container component names _ deferred until later (or never)#line 91
    return  s                                                                   #line 92#line 93#line 94

def generate_shell_components (reg,container_list):                             #line 95
    # [                                                                         #line 96
    #     {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 97
    #     {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []}#line 98
    # ]                                                                         #line 99
    if  None!= container_list:                                                  #line 100
        for diagram in  container_list:                                         #line 101
            # loop through every component in the diagram and look for names that start with “$“#line 102
            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 103
            for child_descriptor in  diagram ["children"]:                      #line 104
                if first_char_is ( child_descriptor ["name"], "$"):             #line 105
                    name =  child_descriptor ["name"]                           #line 106
                    cmd =   name[1:] .strip ()                                  #line 107
                    generated_leaf = Template ( name, shell_out_instantiate, cmd)#line 108
                    register_component ( reg, generated_leaf)                   #line 109
                elif first_char_is ( child_descriptor ["name"], "'"):           #line 110
                    name =  child_descriptor ["name"]                           #line 111
                    s =   name[1:]                                              #line 112
                    generated_leaf = Template ( name, string_constant_instantiate, s)#line 113
                    register_component_allow_overwriting ( reg, generated_leaf) #line 114#line 115#line 116#line 117#line 118#line 119#line 120

def first_char (s):                                                             #line 121
    return   s[0]                                                               #line 122#line 123#line 124

def first_char_is (s,c):                                                        #line 125
    return  c == first_char ( s)                                                #line 126#line 127#line 128
                                                                                #line 129
# TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 130
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 131#line 132#line 133
# Data for an asyncronous component _ effectively, a function with input        #line 134
# and output queues of messages.                                                #line 135
#                                                                               #line 136
# Components can either be a user_supplied function (“lea“), or a “container“   #line 137
# that routes messages to child components according to a list of connections   #line 138
# that serve as a message routing table.                                        #line 139
#                                                                               #line 140
# Child components themselves can be leaves or other containers.                #line 141
#                                                                               #line 142
# `handler` invokes the code that is attached to this component.                #line 143
#                                                                               #line 144
# `instance_data` is a pointer to instance data that the `leaf_handler`         #line 145
# function may want whenever it is invoked again.                               #line 146
#                                                                               #line 147#line 148
# Eh_States :: enum { idle, active }                                            #line 149
class Eh:
    def __init__ (self,):                                                       #line 150
        self.name =  ""                                                         #line 151
        self.inq =  queue.Queue ()                                              #line 152
        self.outq =  queue.Queue ()                                             #line 153
        self.owner =  None                                                      #line 154
        self.saved_messages =  queue.LifoQueue () # stack of saved message(s)   #line 155
        self.children = []                                                      #line 156
        self.visit_ordering =  queue.Queue ()                                   #line 157
        self.connections = []                                                   #line 158
        self.routings =  queue.Queue ()                                         #line 159
        self.handler =  None                                                    #line 160
        self.instance_data =  None                                              #line 161
        self.state =  "idle"                                                    #line 162# bootstrap debugging#line 163
        self.kind =  None # enum { container, leaf, }                           #line 164
        self.trace =  False # set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component)#line 165
        self.depth =  0 # hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc.#line 166#line 167
                                                                                #line 168
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 169
# whose handler function is `container_handler`.                                #line 170
def make_container (name,owner):                                                #line 171
    eh = Eh ()                                                                  #line 172
    eh. name =  name                                                            #line 173
    eh. owner =  owner                                                          #line 174
    eh. handler =  container_handler                                            #line 175
    eh. inject =  container_injector                                            #line 176
    eh. state =  "idle"                                                         #line 177
    eh. kind =  "container"                                                     #line 178
    return  eh                                                                  #line 179#line 180#line 181

# Creates a new leaf component out of a handler function, and a data parameter  #line 182
# that will be passed back to your handler when called.                         #line 183#line 184
def make_leaf (name,owner,instance_data,handler):                               #line 185
    eh = Eh ()                                                                  #line 186
    eh. name =  str( owner. name) +  str( ".") +  name                          #line 187
    eh. owner =  owner                                                          #line 188
    eh. handler =  handler                                                      #line 189
    eh. instance_data =  instance_data                                          #line 190
    eh. state =  "idle"                                                         #line 191
    eh. kind =  "leaf"                                                          #line 192
    return  eh                                                                  #line 193#line 194#line 195

# Sends a message on the given `port` with `data`, placing it on the output     #line 196
# of the given component.                                                       #line 197#line 198
def send (eh,port,datum,causingMessage):                                        #line 199
    msg = make_message ( port, datum)                                           #line 200
    put_output ( eh, msg)                                                       #line 201#line 202#line 203

def send_string (eh,port,s,causingMessage):                                     #line 204
    datum = new_datum_string ( s)                                               #line 205
    msg = make_message ( port, datum)                                           #line 206
    put_output ( eh, msg)                                                       #line 207#line 208#line 209

def forward (eh,port,msg):                                                      #line 210
    fwdmsg = make_message ( port, msg. datum)                                   #line 211
    put_output ( eh, msg)                                                       #line 212#line 213#line 214

def inject (eh,msg):                                                            #line 215
    eh.inject ( eh, msg)                                                        #line 216#line 217#line 218

# Returns a list of all output messages on a container.                         #line 219
# For testing / debugging purposes.                                             #line 220#line 221
def output_list (eh):                                                           #line 222
    return  eh. outq                                                            #line 223#line 224#line 225

# Utility for printing an array of messages.                                    #line 226
def print_output_list (eh):                                                     #line 227
    for m in list ( eh. outq. queue):                                           #line 228
        print (format_message ( m))                                             #line 229#line 230#line 231

def spaces (n):                                                                 #line 232
    s =  ""                                                                     #line 233
    for i in range( n):                                                         #line 234
        s =  s+ " "                                                             #line 235
    return  s                                                                   #line 236#line 237#line 238

def set_active (eh):                                                            #line 239
    eh. state =  "active"                                                       #line 240#line 241#line 242

def set_idle (eh):                                                              #line 243
    eh. state =  "idle"                                                         #line 244#line 245#line 246

# Utility for printing a specific output message.                               #line 247#line 248
def fetch_first_output (eh,port):                                               #line 249
    for msg in list ( eh. outq. queue):                                         #line 250
        if ( msg. port ==  port):                                               #line 251
            return  msg. datum                                                  #line 252
    return  None                                                                #line 253#line 254#line 255

def print_specific_output (eh,port):                                            #line 256
    # port ∷ “”                                                                 #line 257
    datum = fetch_first_output ( eh, port)                                      #line 258
    print ( datum.srepr ())                                                     #line 259#line 260

def print_specific_output_to_stderr (eh,port):                                  #line 261
    # port ∷ “”                                                                 #line 262
    datum = fetch_first_output ( eh, port)                                      #line 263
    # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 264
    print ( datum.srepr (), file=sys.stderr)                                    #line 265#line 266#line 267

def put_output (eh,msg):                                                        #line 268
    eh. outq.put ( msg)                                                         #line 269#line 270#line 271

def injector_NIY (eh,msg):                                                      #line 272
    # print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“')#line 273
    print ( str( "Injector not implemented for this component ") +  str( eh. name) +  str( " kind ∷ ") +  str( eh. kind) +  str( ",  port ∷ ") +  msg. port     )#line 278
    exit ()                                                                     #line 279#line 280#line 281

root_project =  ""                                                              #line 282
root_0D =  ""                                                                   #line 283#line 284
def set_environment (rproject,r0D):                                             #line 285
    global root_project                                                         #line 286
    global root_0D                                                              #line 287
    root_project =  rproject                                                    #line 288
    root_0D =  r0D                                                              #line 289#line 290#line 291

def probe_instantiate (reg,owner,name,template_data):                           #line 292
    name_with_id = gensymbol ( "?")                                             #line 293
    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 294#line 295

def probeA_instantiate (reg,owner,name,template_data):                          #line 296
    name_with_id = gensymbol ( "?A")                                            #line 297
    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 298#line 299#line 300

def probeB_instantiate (reg,owner,name,template_data):                          #line 301
    name_with_id = gensymbol ( "?B")                                            #line 302
    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 303#line 304#line 305

def probeC_instantiate (reg,owner,name,template_data):                          #line 306
    name_with_id = gensymbol ( "?C")                                            #line 307
    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 308#line 309#line 310

def probe_handler (eh,msg):                                                     #line 311
    s =  msg. datum.srepr ()                                                    #line 312
    print ( str( "... probe ") +  str( eh. name) +  str( ": ") +  s   , file=sys.stderr)#line 313#line 314#line 315

def trash_instantiate (reg,owner,name,template_data):                           #line 316
    name_with_id = gensymbol ( "trash")                                         #line 317
    return make_leaf ( name_with_id, owner, None, trash_handler)                #line 318#line 319#line 320

def trash_handler (eh,msg):                                                     #line 321
    # to appease dumped_on_floor checker                                        #line 322
    pass                                                                        #line 323#line 324

class TwoMessages:
    def __init__ (self,first,second):                                           #line 325
        self.first =  first                                                     #line 326
        self.second =  second                                                   #line 327#line 328
                                                                                #line 329
# Deracer_States :: enum { idle, waitingForFirst, waitingForSecond }            #line 330
class Deracer_Instance_Data:
    def __init__ (self,state,buffer):                                           #line 331
        self.state =  state                                                     #line 332
        self.buffer =  buffer                                                   #line 333#line 334
                                                                                #line 335
def reclaim_Buffers_from_heap (inst):                                           #line 336
    pass                                                                        #line 337#line 338#line 339

def deracer_instantiate (reg,owner,name,template_data):                         #line 340
    name_with_id = gensymbol ( "deracer")                                       #line 341
    inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))            #line 342
    inst. state =  "idle"                                                       #line 343
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)                #line 344
    return  eh                                                                  #line 345#line 346#line 347

def send_first_then_second (eh,inst):                                           #line 348
    forward ( eh, "1", inst. buffer. first)                                     #line 349
    forward ( eh, "2", inst. buffer. second)                                    #line 350
    reclaim_Buffers_from_heap ( inst)                                           #line 351#line 352#line 353

def deracer_handler (eh,msg):                                                   #line 354
    inst =  eh. instance_data                                                   #line 355
    if  inst. state ==  "idle":                                                 #line 356
        if  "1" ==  msg. port:                                                  #line 357
            inst. buffer. first =  msg                                          #line 358
            inst. state =  "waitingForSecond"                                   #line 359
        elif  "2" ==  msg. port:                                                #line 360
            inst. buffer. second =  msg                                         #line 361
            inst. state =  "waitingForFirst"                                    #line 362
        else:                                                                   #line 363
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg. port )#line 364
    elif  inst. state ==  "waitingForFirst":                                    #line 365
        if  "1" ==  msg. port:                                                  #line 366
            inst. buffer. first =  msg                                          #line 367
            send_first_then_second ( eh, inst)                                  #line 368
            inst. state =  "idle"                                               #line 369
        else:                                                                   #line 370
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg. port )#line 371
    elif  inst. state ==  "waitingForSecond":                                   #line 372
        if  "2" ==  msg. port:                                                  #line 373
            inst. buffer. second =  msg                                         #line 374
            send_first_then_second ( eh, inst)                                  #line 375
            inst. state =  "idle"                                               #line 376
        else:                                                                   #line 377
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg. port )#line 378
    else:                                                                       #line 379
        runtime_error ( "bad state for deracer {eh.state}")                     #line 380#line 381#line 382

def low_level_read_text_file_instantiate (reg,owner,name,template_data):        #line 383
    name_with_id = gensymbol ( "Low Level Read Text File")                      #line 384
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 385#line 386#line 387

def low_level_read_text_file_handler (eh,msg):                                  #line 388
    fname =  msg. datum.srepr ()                                                #line 389

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
                                                                                #line 390#line 391#line 392

def ensure_string_datum_instantiate (reg,owner,name,template_data):             #line 393
    name_with_id = gensymbol ( "Ensure String Datum")                           #line 394
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)  #line 395#line 396#line 397

def ensure_string_datum_handler (eh,msg):                                       #line 398
    if  "string" ==  msg. datum.kind ():                                        #line 399
        forward ( eh, "", msg)                                                  #line 400
    else:                                                                       #line 401
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg. datum #line 402
        send_string ( eh, "✗", emsg, msg)                                       #line 403#line 404#line 405

class Syncfilewrite_Data:
    def __init__ (self,):                                                       #line 406
        self.filename =  ""                                                     #line 407#line 408
                                                                                #line 409
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)   #line 410
def syncfilewrite_instantiate (reg,owner,name,template_data):                   #line 411
    name_with_id = gensymbol ( "syncfilewrite")                                 #line 412
    inst = Syncfilewrite_Data ()                                                #line 413
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)        #line 414#line 415#line 416

def syncfilewrite_handler (eh,msg):                                             #line 417
    inst =  eh. instance_data                                                   #line 418
    if  "filename" ==  msg. port:                                               #line 419
        inst. filename =  msg. datum.srepr ()                                   #line 420
    elif  "input" ==  msg. port:                                                #line 421
        contents =  msg. datum.srepr ()                                         #line 422
        f = open ( inst. filename, "w")                                         #line 423
        if  f!= None:                                                           #line 424
            f.write ( msg. datum.srepr ())                                      #line 425
            f.close ()                                                          #line 426
            send ( eh, "done",new_datum_bang (), msg)                           #line 427
        else:                                                                   #line 428
            send_string ( eh, "✗", str( "open error on file ") +  inst. filename , msg)#line 429#line 430#line 431

class StringConcat_Instance_Data:
    def __init__ (self,):                                                       #line 432
        self.buffer1 =  None                                                    #line 433
        self.buffer2 =  None                                                    #line 434
        self.count =  0                                                         #line 435#line 436
                                                                                #line 437
def stringconcat_instantiate (reg,owner,name,template_data):                    #line 438
    name_with_id = gensymbol ( "stringconcat")                                  #line 439
    instp = StringConcat_Instance_Data ()                                       #line 440
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)        #line 441#line 442#line 443

def stringconcat_handler (eh,msg):                                              #line 444
    inst =  eh. instance_data                                                   #line 445
    if  "1" ==  msg. port:                                                      #line 446
        inst. buffer1 = clone_string ( msg. datum.srepr ())                     #line 447
        inst. count =  inst. count+ 1                                           #line 448
        maybe_stringconcat ( eh, inst, msg)                                     #line 449
    elif  "2" ==  msg. port:                                                    #line 450
        inst. buffer2 = clone_string ( msg. datum.srepr ())                     #line 451
        inst. count =  inst. count+ 1                                           #line 452
        maybe_stringconcat ( eh, inst, msg)                                     #line 453
    else:                                                                       #line 454
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg. port )  #line 455#line 456#line 457#line 458

def maybe_stringconcat (eh,inst,msg):                                           #line 459
    if ( 0 == len ( inst. buffer1)) and ( 0 == len ( inst. buffer2)):           #line 460
        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 461
    if  inst. count >=  2:                                                      #line 462
        concatenated_string =  ""                                               #line 463
        if  0 == len ( inst. buffer1):                                          #line 464
            concatenated_string =  inst. buffer2                                #line 465
        elif  0 == len ( inst. buffer2):                                        #line 466
            concatenated_string =  inst. buffer1                                #line 467
        else:                                                                   #line 468
            concatenated_string =  inst. buffer1+ inst. buffer2                 #line 469
        send_string ( eh, "", concatenated_string, msg)                         #line 470
        inst. buffer1 =  None                                                   #line 471
        inst. buffer2 =  None                                                   #line 472
        inst. count =  0                                                        #line 473#line 474#line 475

#                                                                               #line 476#line 477
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 478
def shell_out_instantiate (reg,owner,name,template_data):                       #line 479
    name_with_id = gensymbol ( "shell_out")                                     #line 480
    cmd == shlex.split ( template_data)                                         #line 481
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)             #line 482#line 483#line 484

def shell_out_handler (eh,msg):                                                 #line 485
    cmd =  eh. instance_data                                                    #line 486
    s =  msg. datum.srepr ()                                                    #line 487
    ret =  None                                                                 #line 488
    rc =  None                                                                  #line 489
    stdout =  None                                                              #line 490
    stderr =  None                                                              #line 491
    ret = subprocess.run ( cmd,   s, "UTF_8")
    rc = ret.returncode
    stdout = ret.stdout
    stderr = ret.stderr                                                         #line 492
    if  rc!= 0:                                                                 #line 493
        send_string ( eh, "✗", stderr, msg)                                     #line 494
    else:                                                                       #line 495
        send_string ( eh, "", stdout, msg)                                      #line 496#line 497#line 498#line 499

def string_constant_instantiate (reg,owner,name,template_data):                 #line 500
    global root_project                                                         #line 501
    global root_0D                                                              #line 502
    name_with_id = gensymbol ( "strconst")                                      #line 503
    s =  template_data                                                          #line 504
    if  root_project!= "":                                                      #line 505
        s = re.sub ( "_00_",  root_project,  s)                                 #line 506#line 507
    if  root_0D!= "":                                                           #line 508
        s = re.sub ( "_0D_",  root_0D,  s)                                      #line 509#line 510
    return make_leaf ( name_with_id, owner, s, string_constant_handler)         #line 511#line 512#line 513

def string_constant_handler (eh,msg):                                           #line 514
    s =  eh. instance_data                                                      #line 515
    send_string ( eh, "", s, msg)                                               #line 516#line 517#line 518

def string_make_persistent (s):                                                 #line 519
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 520
    return  s                                                                   #line 521#line 522#line 523

def string_clone (s):                                                           #line 524
    return  s                                                                   #line 525#line 526#line 527

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...   #line 528
# where ${_00_} is the root directory for the project                           #line 529
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)        #line 530#line 531#line 532#line 533
def initialize_component_palette (root_project,root_0D,diagram_source_files):   #line 534
    reg = make_component_registry ()                                            #line 535
    for diagram_source in  diagram_source_files:                                #line 536
        all_containers_within_single_file = json2internal ( diagram_source)     #line 537
        generate_shell_components ( reg, all_containers_within_single_file)     #line 538
        for container in  all_containers_within_single_file:                    #line 539
            register_component ( reg,Template ( container ["name"], container, container_instantiator))#line 540
    initialize_stock_components ( reg)                                          #line 541
    return  reg                                                                 #line 542#line 543#line 544

def print_error_maybe (main_container):                                         #line 545
    error_port =  "✗"                                                           #line 546
    err = fetch_first_output ( main_container, error_port)                      #line 547
    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):                   #line 548
        print ( "___ !!! ERRORS !!! ___")                                       #line 549
        print_specific_output ( main_container, error_port, False)              #line 550#line 551#line 552

# debugging helpers                                                             #line 553#line 554
def nl ():                                                                      #line 555
    print ( "")                                                                 #line 556#line 557#line 558

def dump_outputs (main_container):                                              #line 559
    nl ()                                                                       #line 560
    print ( "___ Outputs ___")                                                  #line 561
    print_output_list ( main_container)                                         #line 562#line 563#line 564

def trace_outputs (main_container):                                             #line 565
    nl ()                                                                       #line 566
    print ( "___ Message Traces ___")                                           #line 567
    print_routing_trace ( main_container)                                       #line 568#line 569#line 570

def dump_hierarchy (main_container):                                            #line 571
    nl ()                                                                       #line 572
    print ( str( "___ Hierarchy ___") + (build_hierarchy ( main_container)) )   #line 573#line 574#line 575

def build_hierarchy (c):                                                        #line 576
    s =  ""                                                                     #line 577
    for child in  c. children:                                                  #line 578
        s =  str( s) + build_hierarchy ( child)                                 #line 579
    indent =  ""                                                                #line 580
    for i in range( c. depth):                                                  #line 581
        indent =  indent+ "  "                                                  #line 582
    return  str( "\n") +  str( indent) +  str( "(") +  str( c. name) +  str( s) +  ")"     #line 583#line 584#line 585

def dump_connections (c):                                                       #line 586
    nl ()                                                                       #line 587
    print ( "___ connections ___")                                              #line 588
    dump_possible_connections ( c)                                              #line 589
    for child in  c. children:                                                  #line 590
        nl ()                                                                   #line 591
        dump_possible_connections ( child)                                      #line 592#line 593#line 594

def trimws (s):                                                                 #line 595
    # remove whitespace from front and back of string                           #line 596
    return  s.strip ()                                                          #line 597#line 598#line 599

def clone_string (s):                                                           #line 600
    return  s                                                                   #line 601#line 602#line 603

load_errors =  False                                                            #line 604
runtime_errors =  False                                                         #line 605#line 606
def load_error (s):                                                             #line 607
    global load_errors                                                          #line 608
    print ( s)                                                                  #line 609
    quit ()                                                                     #line 610
    load_errors =  True                                                         #line 611#line 612#line 613

def runtime_error (s):                                                          #line 614
    global runtime_errors                                                       #line 615
    print ( s)                                                                  #line 616
    quit ()                                                                     #line 617
    runtime_errors =  True                                                      #line 618#line 619#line 620

def fakepipename_instantiate (reg,owner,name,template_data):                    #line 621
    instance_name = gensymbol ( "fakepipe")                                     #line 622
    return make_leaf ( instance_name, owner, None, fakepipename_handler)        #line 623#line 624#line 625

rand =  0                                                                       #line 626#line 627
def fakepipename_handler (eh,msg):                                              #line 628
    global rand                                                                 #line 629
    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 630
    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)                  #line 631#line 632#line 633
                                                                                #line 634
# all of the the built_in leaves are listed here                                #line 635
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 636#line 637#line 638
def initialize_stock_components (reg):                                          #line 639
    register_component ( reg,Template ( "1then2", None, deracer_instantiate))   #line 640
    register_component ( reg,Template ( "?", None, probe_instantiate))          #line 641
    register_component ( reg,Template ( "?A", None, probeA_instantiate))        #line 642
    register_component ( reg,Template ( "?B", None, probeB_instantiate))        #line 643
    register_component ( reg,Template ( "?C", None, probeC_instantiate))        #line 644
    register_component ( reg,Template ( "trash", None, trash_instantiate))      #line 645#line 646
    register_component ( reg,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 647
    register_component ( reg,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 648#line 649
    register_component ( reg,Template ( "syncfilewrite", None, syncfilewrite_instantiate))#line 650
    register_component ( reg,Template ( "stringconcat", None, stringconcat_instantiate))#line 651
    # for fakepipe                                                              #line 652
    register_component ( reg,Template ( "fakepipename", None, fakepipename_instantiate))#line 653#line 654#line 655

def argv ():                                                                    #line 656
    sys.argv                                                                    #line 657#line 658#line 659

def initialize ():                                                              #line 660
    root_of_project =  sys.argv[ 1]                                             #line 661
    root_of_0D =  sys.argv[ 2]                                                  #line 662
    arg =  sys.argv[ 3]                                                         #line 663
    main_container_name =  sys.argv[ 4]                                         #line 664
    diagram_names =  sys.argv[ 5:]                                              #line 665
    palette = initialize_component_palette ( root_project, root_0D, diagram_names)#line 666
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 667#line 668#line 669

def start (palette,env):
    start_with_debug ( palette, env, False, False, False, False)                #line 670

def start_with_debug (palette,env,show_hierarchy,show_connections,show_traces,show_all_outputs):#line 671
    # show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥   #line 672
    root_of_project =  env [ 0]                                                 #line 673
    root_of_0D =  env [ 1]                                                      #line 674
    main_container_name =  env [ 2]                                             #line 675
    diagram_names =  env [ 3]                                                   #line 676
    arg =  env [ 4]                                                             #line 677
    set_environment ( root_of_project, root_of_0D)                              #line 678
    # get entrypoint container                                                  #line 679
    main_container = get_component_instance ( palette, main_container_name, None)#line 680
    if  None ==  main_container:                                                #line 681
        load_error ( str( "Couldn't find container with page name ") +  str( main_container_name) +  str( " in files ") +  str( diagram_names) +  "(check tab names, or disable compression?)"    )#line 685#line 686
    if  show_hierarchy:                                                         #line 687
        dump_hierarchy ( main_container)                                        #line 688#line 689
    if  show_connections:                                                       #line 690
        dump_connections ( main_container)                                      #line 691#line 692
    if not  load_errors:                                                        #line 693
        arg = new_datum_string ( arg)                                           #line 694
        msg = make_message ( "", arg)                                           #line 695
        inject ( main_container, msg)                                           #line 696
        if  show_all_outputs:                                                   #line 697
            dump_outputs ( main_container)                                      #line 698
        else:                                                                   #line 699
            print_error_maybe ( main_container)                                 #line 700
            print_specific_output ( main_container, "")                         #line 701
            if  show_traces:                                                    #line 702
                print ( "--- routing traces ---")                               #line 703
                print (routing_trace_all ( main_container))                     #line 704#line 705#line 706
        if  show_all_outputs:                                                   #line 707
            print ( "--- done ---")                                             #line 708#line 709#line 710#line 711#line 712
                                                                                #line 713#line 714
# utility functions                                                             #line 715
def send_int (eh,port,i,causing_message):                                       #line 716
    datum = new_datum_int ( i)                                                  #line 717
    send ( eh, port, datum, causing_message)                                    #line 718#line 719#line 720

def send_bang (eh,port,causing_message):                                        #line 721
    datum = new_datum_bang ()                                                   #line 722
    send ( eh, port, datum, causing_message)                                    #line 723#line 724#line 725





