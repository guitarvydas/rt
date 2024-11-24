

import sys
import re
import subprocess
import shlex
import os
import json
import queue
                                                            #line 1#line 2
counter =  0                                                #line 3#line 4
digits = [ "₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀", "₂₁", "₂₂", "₂₃", "₂₄", "₂₅", "₂₆", "₂₇", "₂₈", "₂₉"]#line 11#line 12#line 13
def gensymbol (s):                                          #line 14
    global counter                                          #line 15
    name_with_id =  str( s) + subscripted_digit ( counter)  #line 16
    counter =  counter+ 1                                   #line 17
    return  name_with_id                                    #line 18#line 19#line 20

def subscripted_digit (n):                                  #line 21
    global digits                                           #line 22
    if ( n >=  0 and  n <=  29):                            #line 23
        return  digits [ n]                                 #line 24
    else:                                                   #line 25
        return  str( "₊") +  n                              #line 26#line 27#line 28#line 29

class Datum:
    def __init__ (self,):                                   #line 30
        self.data =  None                                   #line 31
        self.clone =  None                                  #line 32
        self.reclaim =  None                                #line 33
        self.srepr =  None                                  #line 34
        self.kind =  None                                   #line 35
        self.raw =  None                                    #line 36#line 37
                                                            #line 38
def new_datum_string (s):                                   #line 39
    d =  Datum ()                                           #line 40
    d.data =  s                                             #line 41
    d.clone =  lambda : clone_datum_string ( d)             #line 42
    d.reclaim =  lambda : reclaim_datum_string ( d)         #line 43
    d.srepr =  lambda : srepr_datum_string ( d)             #line 44
    d.raw = bytearray ( d.data,"UTF_8")                     #line 45
    d.kind =  lambda :  "string"                            #line 46
    return  d                                               #line 47#line 48#line 49

def clone_datum_string (d):                                 #line 50
    d = new_datum_string ( d.data)                          #line 51
    return  d                                               #line 52#line 53#line 54

def reclaim_datum_string (src):                             #line 55
    pass                                                    #line 56#line 57#line 58

def srepr_datum_string (d):                                 #line 59
    return  d.data                                          #line 60#line 61#line 62

def new_datum_bang ():                                      #line 63
    p = Datum ()                                            #line 64
    p.data =  True                                          #line 65
    p.clone =  lambda : clone_datum_bang ( p)               #line 66
    p.reclaim =  lambda : reclaim_datum_bang ( p)           #line 67
    p.srepr =  lambda : srepr_datum_bang ()                 #line 68
    p.raw =  lambda : raw_datum_bang ()                     #line 69
    p.kind =  lambda :  "bang"                              #line 70
    return  p                                               #line 71#line 72#line 73

def clone_datum_bang (d):                                   #line 74
    return new_datum_bang ()                                #line 75#line 76#line 77

def reclaim_datum_bang (d):                                 #line 78
    pass                                                    #line 79#line 80#line 81

def srepr_datum_bang ():                                    #line 82
    return  "!"                                             #line 83#line 84#line 85

def raw_datum_bang ():                                      #line 86
    return []                                               #line 87#line 88#line 89

def new_datum_tick ():                                      #line 90
    p = new_datum_bang ()                                   #line 91
    p.kind =  lambda :  "tick"                              #line 92
    p.clone =  lambda : new_datum_tick ()                   #line 93
    p.srepr =  lambda : srepr_datum_tick ()                 #line 94
    p.raw =  lambda : raw_datum_tick ()                     #line 95
    return  p                                               #line 96#line 97#line 98

def srepr_datum_tick ():                                    #line 99
    return  "."                                             #line 100#line 101#line 102

def raw_datum_tick ():                                      #line 103
    return []                                               #line 104#line 105#line 106

def new_datum_bytes (b):                                    #line 107
    p = Datum ()                                            #line 108
    p.data =  b                                             #line 109
    p.clone =  lambda : clone_datum_bytes ( p)              #line 110
    p.reclaim =  lambda : reclaim_datum_bytes ( p)          #line 111
    p.srepr =  lambda : srepr_datum_bytes ( b)              #line 112
    p.raw =  lambda : raw_datum_bytes ( b)                  #line 113
    p.kind =  lambda :  "bytes"                             #line 114
    return  p                                               #line 115#line 116#line 117

def clone_datum_bytes (src):                                #line 118
    p = Datum ()                                            #line 119
    p.clone =  src.clone                                    #line 120
    p.reclaim =  src.reclaim                                #line 121
    p.srepr =  src.srepr                                    #line 122
    p.raw =  src.raw                                        #line 123
    p.kind =  src.kind                                      #line 124
    p.data =  src.clone ()                                  #line 125
    return  p                                               #line 126#line 127#line 128

def reclaim_datum_bytes (src):                              #line 129
    pass                                                    #line 130#line 131#line 132

def srepr_datum_bytes (d):                                  #line 133
    return  d.data.decode ( "UTF_8")                        #line 134#line 135

def raw_datum_bytes (d):                                    #line 136
    return  d.data                                          #line 137#line 138#line 139

def new_datum_handle (h):                                   #line 140
    return new_datum_int ( h)                               #line 141#line 142#line 143

def new_datum_int (i):                                      #line 144
    p = Datum ()                                            #line 145
    p.data =  i                                             #line 146
    p.clone =  lambda : clone_int ( i)                      #line 147
    p.reclaim =  lambda : reclaim_int ( i)                  #line 148
    p.srepr =  lambda : srepr_datum_int ( i)                #line 149
    p.raw =  lambda : raw_datum_int ( i)                    #line 150
    p.kind =  lambda :  "int"                               #line 151
    return  p                                               #line 152#line 153#line 154

def clone_int (i):                                          #line 155
    p = new_datum_int ( i)                                  #line 156
    return  p                                               #line 157#line 158#line 159

def reclaim_int (src):                                      #line 160
    pass                                                    #line 161#line 162#line 163

def srepr_datum_int (i):                                    #line 164
    return str ( i)                                         #line 165#line 166#line 167

def raw_datum_int (i):                                      #line 168
    return  i                                               #line 169#line 170#line 171

# Message passed to a leaf component.                       #line 172
#                                                           #line 173
# `port` refers to the name of the incoming or outgoing port of this component.#line 174
# `datum` is the data attached to this message.             #line 175
class Message:
    def __init__ (self,port,datum):                         #line 176
        self.port =  port                                   #line 177
        self.datum =  datum                                 #line 178#line 179
                                                            #line 180
def clone_port (s):                                         #line 181
    return clone_string ( s)                                #line 182#line 183#line 184

# Utility for making a `Message`. Used to safely “seed“ messages#line 185
# entering the very top of a network.                       #line 186
def make_message (port,datum):                              #line 187
    p = clone_string ( port)                                #line 188
    m = Message ( p, datum.clone ())                        #line 189
    return  m                                               #line 190#line 191#line 192

# Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations.#line 193
def message_clone (message):                                #line 194
    m = Message (clone_port ( message.port), message.datum.clone ())#line 195
    return  m                                               #line 196#line 197#line 198

# Frees a message.                                          #line 199
def destroy_message (msg):                                  #line 200
    # during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages#line 201
    pass                                                    #line 202#line 203#line 204

def destroy_datum (msg):                                    #line 205
    pass                                                    #line 206#line 207#line 208

def destroy_port (msg):                                     #line 209
    pass                                                    #line 210#line 211#line 212

#                                                           #line 213
def format_message (m):                                     #line 214
    if  m ==  None:                                         #line 215
        return  "ϕ"                                         #line 216
    else:                                                   #line 217
        return  str( "⟪") +  str( m.port) +  str( "⦂") +  str( m.datum.srepr ()) +  "⟫"    #line 221#line 222#line 223#line 224
                                                            #line 225
enumDown =  0                                               #line 226
enumAcross =  1                                             #line 227
enumUp =  2                                                 #line 228
enumThrough =  3                                            #line 229#line 230
def container_instantiator (reg,owner,container_name,desc): #line 231
    global enumDown, enumUp, enumAcross, enumThrough        #line 232
    container = make_container ( container_name, owner)     #line 233
    children = []                                           #line 234
    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here#line 235
    # collect children                                      #line 236
    for child_desc in  desc [ "children"]:                  #line 237
        child_instance = get_component_instance ( reg, child_desc [ "name"], container)#line 238
        children.append ( child_instance)                   #line 239
        children_by_id [ child_desc [ "id"]] =  child_instance#line 240
    container.children =  children                          #line 241
    me =  container                                         #line 242#line 243
    connectors = []                                         #line 244
    for proto_conn in  desc [ "connections"]:               #line 245
        connector = Connector ()                            #line 246
        if  proto_conn [ "dir"] ==  enumDown:               #line 247
            # JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 248
            connector.direction =  "down"                   #line 249
            connector.sender = Sender ( me.name, me, proto_conn [ "source_port"])#line 250
            target_component =  children_by_id [ proto_conn [ "target" [ "id"]]]#line 251
            if ( target_component ==  None):                #line 252
                load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn [ "target"] )#line 253
            else:                                           #line 254
                connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn [ "target_port"], target_component)#line 255
                connectors.append ( connector)              #line 256
        elif  proto_conn [ "dir"] ==  enumAcross:           #line 257
            connector.direction =  "across"                 #line 258
            source_component =  children_by_id [ proto_conn [ "source" [ "id"]]]#line 259
            target_component =  children_by_id [ proto_conn [ "target" [ "id"]]]#line 260
            if  source_component ==  None:                  #line 261
                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn [ "source"] )#line 262
            else:                                           #line 263
                connector.sender = Sender ( source_component.name, source_component, proto_conn [ "source_port"])#line 264
                if  target_component ==  None:              #line 265
                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn.target )#line 266
                else:                                       #line 267
                    connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn [ "target_port"], target_component)#line 268
                    connectors.append ( connector)          #line 269
        elif  proto_conn [ "dir"] ==  enumUp:               #line 270
            connector.direction =  "up"                     #line 271
            source_component =  children_by_id [ proto_conn [ "source" [ "id"]]]#line 272
            if  source_component ==  None:                  #line 273
                print ( str( "internal error: .Up connection source not ok ") +  proto_conn [ "source"] )#line 274
            else:                                           #line 275
                connector.sender = Sender ( source_component.name, source_component, proto_conn [ "source_port"])#line 276
                connector.receiver = Receiver ( me.name, container.outq, proto_conn [ "target_port"], me)#line 277
                connectors.append ( connector)              #line 278
        elif  proto_conn [ "dir"] ==  enumThrough:          #line 279
            connector.direction =  "through"                #line 280
            connector.sender = Sender ( me.name, me, proto_conn [ "source_port"])#line 281
            connector.receiver = Receiver ( me.name, container.outq, proto_conn [ "target_port"], me)#line 282
            connectors.append ( connector)                  #line 283#line 284
    container.connections =  connectors                     #line 285
    return  container                                       #line 286#line 287#line 288

# The default handler for container components.             #line 289
def container_handler (container,message):                  #line 290
    route ( container, container, message)
    # references to 'self' are replaced by the container during instantiation#line 291
    while any_child_ready ( container):                     #line 292
        step_children ( container, message)                 #line 293#line 294#line 295

# Frees the given container and associated data.            #line 296
def destroy_container (eh):                                 #line 297
    pass                                                    #line 298#line 299#line 300

def fifo_is_empty (fifo):                                   #line 301
    return  fifo.empty ()                                   #line 302#line 303#line 304

# Routing connection for a container component. The `direction` field has#line 305
# no affect on the default message routing system _ it is there for debugging#line 306
# purposes, or for reading by other tools.                  #line 307#line 308
class Connector:
    def __init__ (self,):                                   #line 309
        self.direction =  None # down, across, up, through  #line 310
        self.sender =  None                                 #line 311
        self.receiver =  None                               #line 312#line 313
                                                            #line 314
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,#line 315
# based on component ID (pointer) and port name.            #line 316#line 317
class Sender:
    def __init__ (self,name,component,port):                #line 318
        self.name =  name                                   #line 319
        self.component =  component # from                  #line 320
        self.port =  port # from's port                     #line 321#line 322
                                                            #line 323
# `Receiver` is a handle to a destination queue, and a `port` name to assign#line 324
# to incoming messages to this queue.                       #line 325#line 326
class Receiver:
    def __init__ (self,name,queue,port,component):          #line 327
        self.name =  name                                   #line 328
        self.queue =  queue # queue (input | output) of receiver#line 329
        self.port =  port # destination port                #line 330
        self.component =  component # to (for bootstrap debug)#line 331#line 332
                                                            #line 333
# Checks if two senders match, by pointer equality and port name matching.#line 334
def sender_eq (s1,s2):                                      #line 335
    same_components = ( s1.component ==  s2.component)      #line 336
    same_ports = ( s1.port ==  s2.port)                     #line 337
    return  same_components and  same_ports                 #line 338#line 339#line 340

# Delivers the given message to the receiver of this connector.#line 341#line 342
def deposit (parent,conn,message):                          #line 343
    new_message = make_message ( conn.receiver.port, message.datum)#line 344
    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)#line 345#line 346#line 347

def force_tick (parent,eh):                                 #line 348
    tick_msg = make_message ( ".",new_datum_tick ())        #line 349
    push_message ( parent, eh, eh.inq, tick_msg)            #line 350
    return  tick_msg                                        #line 351#line 352#line 353

def push_message (parent,receiver,inq,m):                   #line 354
    inq.put ( m)                                            #line 355
    parent.visit_ordering.put ( receiver)                   #line 356#line 357#line 358

def is_self (child,container):                              #line 359
    # in an earlier version “self“ was denoted as ϕ         #line 360
    return  child ==  container                             #line 361#line 362#line 363

def step_child (child,msg):                                 #line 364
    before_state =  child.state                             #line 365
    child.handler ( child, msg)                             #line 366
    after_state =  child.state                              #line 367
    return [ before_state ==  "idle" and  after_state!= "idle", before_state!= "idle" and  after_state!= "idle", before_state!= "idle" and  after_state ==  "idle"]#line 370#line 371#line 372

def save_message (eh,msg):                                  #line 373
    eh.saved_messages.put ( msg)                            #line 374#line 375#line 376

def fetch_saved_message_and_clear (eh):                     #line 377
    return  eh.saved_messages.get ()                        #line 378#line 379#line 380

def step_children (container,causingMessage):               #line 381
    container.state =  "idle"                               #line 382
    for child in list ( container.visit_ordering.queue):    #line 383
        # child = container represents self, skip it        #line 384
        if (not (is_self ( child, container))):             #line 385
            if (not ( child.inq.empty ())):                 #line 386
                msg =  child.inq.get ()                     #line 387
                began_long_run =  None                      #line 388
                continued_long_run =  None                  #line 389
                ended_long_run =  None                      #line 390
                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 391
                if  began_long_run:                         #line 392
                    save_message ( child, msg)              #line 393
                elif  continued_long_run:                   #line 394
                    pass                                    #line 395#line 396
                destroy_message ( msg)                      #line 397
            else:                                           #line 398
                if  child.state!= "idle":                   #line 399
                    msg = force_tick ( container, child)    #line 400
                    child.handler ( child, msg)             #line 401
                    destroy_message ( msg)                  #line 402#line 403
            if  child.state ==  "active":                   #line 404
                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 405
                container.state =  "active"                 #line 406#line 407
            while (not ( child.outq.empty ())):             #line 408
                msg =  child.outq.get ()                    #line 409
                route ( container, child, msg)              #line 410
                destroy_message ( msg)                      #line 411#line 412#line 413#line 414#line 415

def attempt_tick (parent,eh):                               #line 416
    if  eh.state!= "idle":                                  #line 417
        force_tick ( parent, eh)                            #line 418#line 419#line 420

def is_tick (msg):                                          #line 421
    return  "tick" ==  msg.datum.kind ()                    #line 422#line 423#line 424

# Routes a single message to all matching destinations, according to#line 425
# the container's connection network.                       #line 426#line 427
def route (container,from_component,message):               #line 428
    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)#line 429
    fromname =  ""                                          #line 430
    if is_tick ( message):                                  #line 431
        for child in  container.children:                   #line 432
            attempt_tick ( container, child)                #line 433
        was_sent =  True                                    #line 434
    else:                                                   #line 435
        if (not (is_self ( from_component, container))):    #line 436
            fromname =  from_component.name                 #line 437
        from_sender = Sender ( fromname, from_component, message.port)#line 438#line 439
        for connector in  container.connections:            #line 440
            if sender_eq ( from_sender, connector.sender):  #line 441
                deposit ( container, connector, message)    #line 442
                was_sent =  True                            #line 443
    if not ( was_sent):                                     #line 444
        print ( "\n\n*** Error: ***")                       #line 445
        print ( "***")                                      #line 446
        print ( str( container.name) +  str( ": message '") +  str( message.port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 447
        print ( "***")                                      #line 448
        exit ()                                             #line 449#line 450#line 451#line 452

def any_child_ready (container):                            #line 453
    for child in  container.children:                       #line 454
        if child_is_ready ( child):                         #line 455
            return  True                                    #line 456
    return  False                                           #line 457#line 458#line 459

def child_is_ready (eh):                                    #line 460
    return (not ( eh.outq.empty ())) or (not ( eh.inq.empty ())) or ( eh.state!= "idle") or (any_child_ready ( eh))#line 461#line 462#line 463

def append_routing_descriptor (container,desc):             #line 464
    container.routings.put ( desc)                          #line 465#line 466#line 467

def container_injector (container,message):                 #line 468
    container_handler ( container, message)                 #line 469#line 470#line 471






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
        templates_alist =  reg.templates                    #line 41
        reg.insert (NIY ( "templates",  templates_alist.insert (NIY ( name,  template))))#line 42
        return  reg                                         #line 43#line 44#line 45#line 46

def get_component_instance (reg,full_name,owner):           #line 47
    template_name = mangle_name ( full_name)                #line 48
    if  template_name in  reg.templates:                    #line 49
        template =  reg.templates [ template_name]          #line 50
        if ( template ==  None):                            #line 51
            load_error ( str( "Registry Error (A): Can;t find component /") +  str( template_name) +  "/"  )#line 52
            return  None                                    #line 53
        else:                                               #line 54
            owner_name =  ""                                #line 55
            instance_name =  template_name                  #line 56
            if  None!= owner:                               #line 57
                owner_name =  owner.name                    #line 58
                instance_name =  str( owner_name) +  str( ".") +  template_name  #line 59
            else:                                           #line 60
                instance_name =  template_name              #line 61
            instance =  template.instantiator ( reg, owner, instance_name, template.template_data)#line 62
            instance.depth = calculate_depth ( instance)    #line 63
            return  instance                                #line 64
    else:                                                   #line 65
        load_error ( str( "Registry Error (B): Can't find component /") +  str( template_name) +  "/"  )#line 66
        return  None                                        #line 67#line 68

def calculate_depth (eh):                                   #line 69
    if  eh.owner ==  None:                                  #line 70
        return  0                                           #line 71
    else:                                                   #line 72
        return  1+calculate_depth ( eh.owner)               #line 73#line 74#line 75

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
    regkvs =  reg                                           #line 99
    if  None!= container_list:                              #line 100
        for diagram in  container_list:                     #line 101
            # loop through every component in the diagram and look for names that start with “$“#line 102
            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 103
            for child_descriptor in  diagram [ "children"]: #line 104
                if first_char_is ( child_descriptor [ "name"], "$"):#line 105
                    name =  child_descriptor [ "name"]      #line 106
                    cmd =   name[1:] .strip ()              #line 107
                    generated_leaf = Template ( name, shell_out_instantiate, cmd)#line 108
                    regkvs.insert (register_component ( regkvs, generated_leaf))#line 109
                elif first_char_is ( child_descriptor [ "name"], "'"):#line 110
                    name =  child_descriptor [ "name"]      #line 111
                    s =   name[1:]                          #line 112
                    generated_leaf = Template ( name, string_constant_instantiate, s)#line 113
                    regkvs.insert (register_component_allow_overwriting ( regkvs, generated_leaf))#line 114#line 115#line 116#line 117#line 118
    return  regkvs                                          #line 119#line 120#line 121

def first_char (s):                                         #line 122
    return   s[0]                                           #line 123#line 124#line 125

def first_char_is (s,c):                                    #line 126
    return  c == first_char ( s)                            #line 127#line 128#line 129
                                                            #line 130
# TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 131
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 132#line 133#line 134
# Data for an asyncronous component _ effectively, a function with input#line 135
# and output queues of messages.                            #line 136
#                                                           #line 137
# Components can either be a user_supplied function (“lea“), or a “container“#line 138
# that routes messages to child components according to a list of connections#line 139
# that serve as a message routing table.                    #line 140
#                                                           #line 141
# Child components themselves can be leaves or other containers.#line 142
#                                                           #line 143
# `handler` invokes the code that is attached to this component.#line 144
#                                                           #line 145
# `instance_data` is a pointer to instance data that the `leaf_handler`#line 146
# function may want whenever it is invoked again.           #line 147
#                                                           #line 148#line 149
# Eh_States :: enum { idle, active }                        #line 150
class Eh:
    def __init__ (self,):                                   #line 151
        self.name =  ""                                     #line 152
        self.inq =  queue.Queue ()                          #line 153
        self.outq =  queue.Queue ()                         #line 154
        self.owner =  None                                  #line 155
        self.saved_messages =  queue.LifoQueue () # stack of saved message(s)#line 156
        self.children = []                                  #line 157
        self.visit_ordering =  queue.Queue ()               #line 158
        self.connections = []                               #line 159
        self.routings =  queue.Queue ()                     #line 160
        self.handler =  None                                #line 161
        self.instance_data =  None                          #line 162
        self.state =  "idle"                                #line 163# bootstrap debugging#line 164
        self.kind =  None # enum { container, leaf, }       #line 165
        self.trace =  False # set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component)#line 166
        self.depth =  0 # hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc.#line 167#line 168
                                                            #line 169
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 170
# whose handler function is `container_handler`.            #line 171
def make_container (name,owner):                            #line 172
    eh = Eh ()                                              #line 173
    eh.name =  name                                         #line 174
    eh.owner =  owner                                       #line 175
    eh.handler =  container_handler                         #line 176
    eh.inject =  container_injector                         #line 177
    eh.state =  "idle"                                      #line 178
    eh.kind =  "container"                                  #line 179
    return  eh                                              #line 180#line 181#line 182

# Creates a new leaf component out of a handler function, and a data parameter#line 183
# that will be passed back to your handler when called.     #line 184#line 185
def make_leaf (name,owner,instance_data,handler):           #line 186
    eh = Eh ()                                              #line 187
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
    eh.inject ( eh, msg)                                    #line 217#line 218#line 219

# Returns a list of all output messages on a container.     #line 220
# For testing / debugging purposes.                         #line 221#line 222
def output_list (eh):                                       #line 223
    return  eh.outq                                         #line 224#line 225#line 226

# Utility for printing an array of messages.                #line 227
def print_output_list (eh):                                 #line 228
    for m in list ( eh.outq.queue):                         #line 229
        print (format_message ( m))                         #line 230#line 231#line 232

def spaces (n):                                             #line 233
    s =  ""                                                 #line 234
    for i in range( n):                                     #line 235
        s =  s+ " "                                         #line 236
    return  s                                               #line 237#line 238#line 239

def set_active (eh):                                        #line 240
    eh.state =  "active"                                    #line 241#line 242#line 243

def set_idle (eh):                                          #line 244
    eh.state =  "idle"                                      #line 245#line 246#line 247

# Utility for printing a specific output message.           #line 248#line 249
def fetch_first_output (eh,port):                           #line 250
    for msg in list ( eh.outq.queue):                       #line 251
        if ( msg.port ==  port):                            #line 252
            return  msg.datum                               #line 253
    return  None                                            #line 254#line 255#line 256

def print_specific_output (eh,port):                        #line 257
    # port ∷ “”                                             #line 258
    datum = fetch_first_output ( eh, port)                  #line 259
    print ( datum.srepr ())                                 #line 260#line 261

def print_specific_output_to_stderr (eh,port):              #line 262
    # port ∷ “”                                             #line 263
    datum = fetch_first_output ( eh, port)                  #line 264
    # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 265
    print ( datum.srepr (), file=sys.stderr)                #line 266#line 267#line 268

def put_output (eh,msg):                                    #line 269
    eh.outq.put ( msg)                                      #line 270#line 271#line 272

root_project =  ""                                          #line 273
root_0D =  ""                                               #line 274#line 275
def set_environment (rproject,r0D):                         #line 276
    global root_project                                     #line 277
    global root_0D                                          #line 278
    root_project =  rproject                                #line 279
    root_0D =  r0D                                          #line 280#line 281#line 282

def probe_instantiate (reg,owner,name,template_data):       #line 283
    name_with_id = gensymbol ( "?")                         #line 284
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 285#line 286

def probeA_instantiate (reg,owner,name,template_data):      #line 287
    name_with_id = gensymbol ( "?A")                        #line 288
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 289#line 290#line 291

def probeB_instantiate (reg,owner,name,template_data):      #line 292
    name_with_id = gensymbol ( "?B")                        #line 293
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 294#line 295#line 296

def probeC_instantiate (reg,owner,name,template_data):      #line 297
    name_with_id = gensymbol ( "?C")                        #line 298
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 299#line 300#line 301

def probe_handler (eh,msg):                                 #line 302
    s =  msg.datum.srepr ()                                 #line 303
    print ( str( "... probe ") +  str( eh.name) +  str( ": ") +  s   , file=sys.stderr)#line 304#line 305#line 306

def trash_instantiate (reg,owner,name,template_data):       #line 307
    name_with_id = gensymbol ( "trash")                     #line 308
    return make_leaf ( name_with_id, owner, None, trash_handler)#line 309#line 310#line 311

def trash_handler (eh,msg):                                 #line 312
    # to appease dumped_on_floor checker                    #line 313
    pass                                                    #line 314#line 315

class TwoMessages:
    def __init__ (self,first,second):                       #line 316
        self.first =  first                                 #line 317
        self.second =  second                               #line 318#line 319
                                                            #line 320
# Deracer_States :: enum { idle, waitingForFirst, waitingForSecond }#line 321
class Deracer_Instance_Data:
    def __init__ (self,state,buffer):                       #line 322
        self.state =  state                                 #line 323
        self.buffer =  buffer                               #line 324#line 325
                                                            #line 326
def reclaim_Buffers_from_heap (inst):                       #line 327
    pass                                                    #line 328#line 329#line 330

def deracer_instantiate (reg,owner,name,template_data):     #line 331
    name_with_id = gensymbol ( "deracer")                   #line 332
    inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))#line 333
    inst.state =  "idle"                                    #line 334
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 335
    return  eh                                              #line 336#line 337#line 338

def send_first_then_second (eh,inst):                       #line 339
    forward ( eh, "1", inst.buffer.first)                   #line 340
    forward ( eh, "2", inst.buffer.second)                  #line 341
    reclaim_Buffers_from_heap ( inst)                       #line 342#line 343#line 344

def deracer_handler (eh,msg):                               #line 345
    inst =  eh.instance_data                                #line 346
    if  inst.state ==  "idle":                              #line 347
        if  "1" ==  msg.port:                               #line 348
            inst.buffer.first =  msg                        #line 349
            inst.state =  "waitingForSecond"                #line 350
        elif  "2" ==  msg.port:                             #line 351
            inst.buffer.second =  msg                       #line 352
            inst.state =  "waitingForFirst"                 #line 353
        else:                                               #line 354
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 355
    elif  inst.state ==  "waitingForFirst":                 #line 356
        if  "1" ==  msg.port:                               #line 357
            inst.buffer.first =  msg                        #line 358
            send_first_then_second ( eh, inst)              #line 359
            inst.state =  "idle"                            #line 360
        else:                                               #line 361
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 362
    elif  inst.state ==  "waitingForSecond":                #line 363
        if  "2" ==  msg.port:                               #line 364
            inst.buffer.second =  msg                       #line 365
            send_first_then_second ( eh, inst)              #line 366
            inst.state =  "idle"                            #line 367
        else:                                               #line 368
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg.port )#line 369
    else:                                                   #line 370
        runtime_error ( "bad state for deracer {eh.state}") #line 371#line 372#line 373

def low_level_read_text_file_instantiate (reg,owner,name,template_data):#line 374
    name_with_id = gensymbol ( "Low Level Read Text File")  #line 375
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 376#line 377#line 378

def low_level_read_text_file_handler (eh,msg):              #line 379
    fname =  msg.datum.srepr ()                             #line 380

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
                                                            #line 381#line 382#line 383

def ensure_string_datum_instantiate (reg,owner,name,template_data):#line 384
    name_with_id = gensymbol ( "Ensure String Datum")       #line 385
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)#line 386#line 387#line 388

def ensure_string_datum_handler (eh,msg):                   #line 389
    if  "string" ==  msg.datum.kind ():                     #line 390
        forward ( eh, "", msg)                              #line 391
    else:                                                   #line 392
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum #line 393
        send_string ( eh, "✗", emsg, msg)                   #line 394#line 395#line 396

class Syncfilewrite_Data:
    def __init__ (self,):                                   #line 397
        self.filename =  ""                                 #line 398#line 399
                                                            #line 400
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)#line 401
def syncfilewrite_instantiate (reg,owner,name,template_data):#line 402
    name_with_id = gensymbol ( "syncfilewrite")             #line 403
    inst = Syncfilewrite_Data ()                            #line 404
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)#line 405#line 406#line 407

def syncfilewrite_handler (eh,msg):                         #line 408
    inst =  eh.instance_data                                #line 409
    if  "filename" ==  msg.port:                            #line 410
        inst.filename =  msg.datum.srepr ()                 #line 411
    elif  "input" ==  msg.port:                             #line 412
        contents =  msg.datum.srepr ()                      #line 413
        f = open ( inst.filename, "w")                      #line 414
        if  f!= None:                                       #line 415
            f.write ( msg.datum.srepr ())                   #line 416
            f.close ()                                      #line 417
            send ( eh, "done",new_datum_bang (), msg)       #line 418
        else:                                               #line 419
            send_string ( eh, "✗", str( "open error on file ") +  inst.filename , msg)#line 420#line 421#line 422

class StringConcat_Instance_Data:
    def __init__ (self,):                                   #line 423
        self.buffer1 =  None                                #line 424
        self.buffer2 =  None                                #line 425
        self.count =  0                                     #line 426#line 427
                                                            #line 428
def stringconcat_instantiate (reg,owner,name,template_data):#line 429
    name_with_id = gensymbol ( "stringconcat")              #line 430
    instp = StringConcat_Instance_Data ()                   #line 431
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 432#line 433#line 434

def stringconcat_handler (eh,msg):                          #line 435
    inst =  eh.instance_data                                #line 436
    if  "1" ==  msg.port:                                   #line 437
        inst.buffer1 = clone_string ( msg.datum.srepr ())   #line 438
        inst.count =  inst.count+ 1                         #line 439
        maybe_stringconcat ( eh, inst, msg)                 #line 440
    elif  "2" ==  msg.port:                                 #line 441
        inst.buffer2 = clone_string ( msg.datum.srepr ())   #line 442
        inst.count =  inst.count+ 1                         #line 443
        maybe_stringconcat ( eh, inst, msg)                 #line 444
    else:                                                   #line 445
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 446#line 447#line 448#line 449

def maybe_stringconcat (eh,inst,msg):                       #line 450
    if ( 0 == len ( inst.buffer1)) and ( 0 == len ( inst.buffer2)):#line 451
        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 452
    if  inst.count >=  2:                                   #line 453
        concatenated_string =  ""                           #line 454
        if  0 == len ( inst.buffer1):                       #line 455
            concatenated_string =  inst.buffer2             #line 456
        elif  0 == len ( inst.buffer2):                     #line 457
            concatenated_string =  inst.buffer1             #line 458
        else:                                               #line 459
            concatenated_string =  inst.buffer1+ inst.buffer2#line 460
        send_string ( eh, "", concatenated_string, msg)     #line 461
        inst.buffer1 =  None                                #line 462
        inst.buffer2 =  None                                #line 463
        inst.count =  0                                     #line 464#line 465#line 466

#                                                           #line 467#line 468
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 469
def shell_out_instantiate (reg,owner,name,template_data):   #line 470
    name_with_id = gensymbol ( "shell_out")                 #line 471
    cmd = shlex.split ( template_data)                      #line 472
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)#line 473#line 474#line 475

def shell_out_handler (eh,msg):                             #line 476
    cmd =  eh.instance_data                                 #line 477
    s =  msg.datum.srepr ()                                 #line 478
    ret =  None                                             #line 479
    rc =  None                                              #line 480
    stdout =  None                                          #line 481
    stderr =  None                                          #line 482
    ret = subprocess.run ( cmd,   s, "UTF_8")
    rc = ret.returncode
    stdout = ret.stdout
    stderr = ret.stderr                                     #line 483
    if  rc!= 0:                                             #line 484
        send_string ( eh, "✗", stderr, msg)                 #line 485
    else:                                                   #line 486
        send_string ( eh, "", stdout, msg)                  #line 487#line 488#line 489#line 490

def string_constant_instantiate (reg,owner,name,template_data):#line 491
    global root_project                                     #line 492
    global root_0D                                          #line 493
    name_with_id = gensymbol ( "strconst")                  #line 494
    s =  template_data                                      #line 495
    if  root_project!= "":                                  #line 496
        s = re.sub ( "_00_",  root_project,  s)             #line 497#line 498
    if  root_0D!= "":                                       #line 499
        s = re.sub ( "_0D_",  root_0D,  s)                  #line 500#line 501
    return make_leaf ( name_with_id, owner, s, string_constant_handler)#line 502#line 503#line 504

def string_constant_handler (eh,msg):                       #line 505
    s =  eh.instance_data                                   #line 506
    send_string ( eh, "", s, msg)                           #line 507#line 508#line 509

def string_make_persistent (s):                             #line 510
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 511
    return  s                                               #line 512#line 513#line 514

def string_clone (s):                                       #line 515
    return  s                                               #line 516#line 517#line 518

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...#line 519
# where ${_00_} is the root directory for the project       #line 520
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)#line 521#line 522
def initialize_component_palette (root_project,root_0D,diagram_source_files):#line 523
    reg = make_component_registry ()                        #line 524
    for diagram_source in  diagram_source_files:            #line 525
        all_containers_within_single_file = json2internal ( root_project, diagram_source)#line 526
        reg = generate_shell_components ( reg, all_containers_within_single_file)#line 527
        for container in  all_containers_within_single_file:#line 528
            reg.insert (register_component ( reg,Template ( container [ "name"], container, container_instantiator)))#line 529#line 530#line 531
    print ( reg)                                            #line 532
    reg = initialize_stock_components ( reg)                #line 533
    return  reg                                             #line 534#line 535#line 536

def print_error_maybe (main_container):                     #line 537
    error_port =  "✗"                                       #line 538
    err = fetch_first_output ( main_container, error_port)  #line 539
    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):#line 540
        print ( "___ !!! ERRORS !!! ___")                   #line 541
        print_specific_output ( main_container, error_port) #line 542#line 543#line 544

# debugging helpers                                         #line 545#line 546
def nl ():                                                  #line 547
    print ( "")                                             #line 548#line 549#line 550

def dump_outputs (main_container):                          #line 551
    nl ()                                                   #line 552
    print ( "___ Outputs ___")                              #line 553
    print_output_list ( main_container)                     #line 554#line 555#line 556

def trimws (s):                                             #line 557
    # remove whitespace from front and back of string       #line 558
    return  s.strip ()                                      #line 559#line 560#line 561

def clone_string (s):                                       #line 562
    return  s                                               #line 563#line 564#line 565

load_errors =  False                                        #line 566
runtime_errors =  False                                     #line 567#line 568
def load_error (s):                                         #line 569
    global load_errors                                      #line 570
    print ( s)                                              #line 571
    print ()                                                #line 572
    load_errors =  True                                     #line 573#line 574#line 575

def runtime_error (s):                                      #line 576
    global runtime_errors                                   #line 577
    print ( s)                                              #line 578
    runtime_errors =  True                                  #line 579#line 580#line 581

def fakepipename_instantiate (reg,owner,name,template_data):#line 582
    instance_name = gensymbol ( "fakepipe")                 #line 583
    return make_leaf ( instance_name, owner, None, fakepipename_handler)#line 584#line 585#line 586

rand =  0                                                   #line 587#line 588
def fakepipename_handler (eh,msg):                          #line 589
    global rand                                             #line 590
    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 591
    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)#line 592#line 593#line 594
                                                            #line 595
# all of the the built_in leaves are listed here            #line 596
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 597#line 598
def initialize_stock_components (reg):                      #line 599
    regkvs = register_component ( reg,Template ( "1then2", None, deracer_instantiate))#line 600
    regkvs.insert (register_component ( regkvs,Template ( "?", None, probe_instantiate)))#line 601
    regkvs.insert (register_component ( regkvs,Template ( "?A", None, probeA_instantiate)))#line 602
    regkvs.insert (register_component ( regkvs,Template ( "?B", None, probeB_instantiate)))#line 603
    regkvs.insert (register_component ( regkvs,Template ( "?C", None, probeC_instantiate)))#line 604
    regkvs.insert (register_component ( regkvs,Template ( "trash", None, trash_instantiate)))#line 605#line 606
    regkvs.insert (register_component ( regkvs,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate)))#line 607
    regkvs.insert (register_component ( regkvs,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate)))#line 608#line 609
    regkvs.insert (register_component ( regkvs,Template ( "syncfilewrite", None, syncfilewrite_instantiate)))#line 610
    regkvs.insert (register_component ( regkvs,Template ( "stringconcat", None, stringconcat_instantiate)))#line 611
    # for fakepipe                                          #line 612
    regkvs.insert (register_component ( regkvs,Template ( "fakepipename", None, fakepipename_instantiate)))#line 613
    return  regkvs                                          #line 614#line 615#line 616

def argv ():                                                #line 617
    sys.argv                                                #line 618#line 619#line 620

def initialize ():                                          #line 621
    root_of_project =  sys.argv[ 1]                         #line 622
    root_of_0D =  sys.argv[ 2]                              #line 623
    arg =  sys.argv[ 3]                                     #line 624
    main_container_name =  sys.argv[ 4]                     #line 625
    diagram_names =  sys.argv[ 5:]                          #line 626
    palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)#line 627
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 628#line 629#line 630

def start (palette,env):
    start_helper ( palette, env, False)                     #line 631

def start_show_all (palette,env):
    start_helper ( palette, env, True)                      #line 632

def start_helper (palette,env,show_all_outputs):            #line 633
    root_of_project =  env [ 0]                             #line 634
    root_of_0D =  env [ 1]                                  #line 635
    main_container_name =  env [ 2]                         #line 636
    diagram_names =  env [ 3]                               #line 637
    arg =  env [ 4]                                         #line 638
    set_environment ( root_of_project, root_of_0D)          #line 639
    # get entrypoint container                              #line 640
    main_container = get_component_instance ( palette, main_container_name, None)#line 641
    if  None ==  main_container:                            #line 642
        load_error ( str( "Couldn't find container with page name /") +  str( main_container_name) +  str( "/ in files ") +  str(str ( diagram_names)) +  " (check tab names, or disable compression?)"    )#line 646#line 647
    if not  load_errors:                                    #line 648
        arg = new_datum_string ( arg)                       #line 649
        msg = make_message ( "", arg)                       #line 650
        inject ( main_container, msg)                       #line 651
        if  show_all_outputs:                               #line 652
            dump_outputs ( main_container)                  #line 653
        else:                                               #line 654
            print_error_maybe ( main_container)             #line 655
            outp = fetch_first_output ( main_container, "") #line 656
            if  None ==  outp:                              #line 657
                print ( "(no outputs)")                     #line 658
            else:                                           #line 659
                print_specific_output ( main_container, "") #line 660#line 661#line 662
        if  show_all_outputs:                               #line 663
            print ( "--- done ---")                         #line 664#line 665#line 666#line 667#line 668
                                                            #line 669#line 670
# utility functions                                         #line 671
def send_int (eh,port,i,causing_message):                   #line 672
    datum = new_datum_int ( i)                              #line 673
    send ( eh, port, datum, causing_message)                #line 674#line 675#line 676

def send_bang (eh,port,causing_message):                    #line 677
    datum = new_datum_bang ()                               #line 678
    send ( eh, port, datum, causing_message)                #line 679#line 680#line 681





