

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
        id =  child_desc [ "id"]                            #line 240
        children_by_id [id] =  child_instance               #line 241#line 242#line 243
    container.children =  children                          #line 244
    me =  container                                         #line 245#line 246
    connectors = []                                         #line 247
    for proto_conn in  desc [ "connections"]:               #line 248
        connector = Connector ()                            #line 249
        if  proto_conn [ "dir"] ==  enumDown:               #line 250
            # JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 251
            connector.direction =  "down"                   #line 252
            connector.sender = Sender ( me.name, me, proto_conn [ "source_port"])#line 253
            target_component =  children_by_id [ proto_conn [ "target" [ "id"]]]#line 254
            if ( target_component ==  None):                #line 255
                load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn [ "target"] )#line 256
            else:                                           #line 257
                connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn [ "target_port"], target_component)#line 258
                connectors.append ( connector)              #line 259
        elif  proto_conn [ "dir"] ==  enumAcross:           #line 260
            connector.direction =  "across"                 #line 261
            source_component =  children_by_id [ proto_conn [ "source" [ "id"]]]#line 262
            target_component =  children_by_id [ proto_conn [ "target" [ "id"]]]#line 263
            if  source_component ==  None:                  #line 264
                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn [ "source"] )#line 265
            else:                                           #line 266
                connector.sender = Sender ( source_component.name, source_component, proto_conn [ "source_port"])#line 267
                if  target_component ==  None:              #line 268
                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn.target )#line 269
                else:                                       #line 270
                    connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn [ "target_port"], target_component)#line 271
                    connectors.append ( connector)          #line 272
        elif  proto_conn [ "dir"] ==  enumUp:               #line 273
            connector.direction =  "up"                     #line 274
            source_component =  children_by_id [ proto_conn [ "source" [ "id"]]]#line 275
            if  source_component ==  None:                  #line 276
                print ( str( "internal error: .Up connection source not ok ") +  proto_conn [ "source"] )#line 277
            else:                                           #line 278
                connector.sender = Sender ( source_component.name, source_component, proto_conn [ "source_port"])#line 279
                connector.receiver = Receiver ( me.name, container.outq, proto_conn [ "target_port"], me)#line 280
                connectors.append ( connector)              #line 281
        elif  proto_conn [ "dir"] ==  enumThrough:          #line 282
            connector.direction =  "through"                #line 283
            connector.sender = Sender ( me.name, me, proto_conn [ "source_port"])#line 284
            connector.receiver = Receiver ( me.name, container.outq, proto_conn [ "target_port"], me)#line 285
            connectors.append ( connector)                  #line 286#line 287
    container.connections =  connectors                     #line 288
    return  container                                       #line 289#line 290#line 291

# The default handler for container components.             #line 292
def container_handler (container,message):                  #line 293
    route ( container, container, message)
    # references to 'self' are replaced by the container during instantiation#line 294
    while any_child_ready ( container):                     #line 295
        step_children ( container, message)                 #line 296#line 297#line 298

# Frees the given container and associated data.            #line 299
def destroy_container (eh):                                 #line 300
    pass                                                    #line 301#line 302#line 303

def fifo_is_empty (fifo):                                   #line 304
    return  fifo.empty ()                                   #line 305#line 306#line 307

# Routing connection for a container component. The `direction` field has#line 308
# no affect on the default message routing system _ it is there for debugging#line 309
# purposes, or for reading by other tools.                  #line 310#line 311
class Connector:
    def __init__ (self,):                                   #line 312
        self.direction =  None # down, across, up, through  #line 313
        self.sender =  None                                 #line 314
        self.receiver =  None                               #line 315#line 316
                                                            #line 317
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,#line 318
# based on component ID (pointer) and port name.            #line 319#line 320
class Sender:
    def __init__ (self,name,component,port):                #line 321
        self.name =  name                                   #line 322
        self.component =  component # from                  #line 323
        self.port =  port # from's port                     #line 324#line 325
                                                            #line 326
# `Receiver` is a handle to a destination queue, and a `port` name to assign#line 327
# to incoming messages to this queue.                       #line 328#line 329
class Receiver:
    def __init__ (self,name,queue,port,component):          #line 330
        self.name =  name                                   #line 331
        self.queue =  queue # queue (input | output) of receiver#line 332
        self.port =  port # destination port                #line 333
        self.component =  component # to (for bootstrap debug)#line 334#line 335
                                                            #line 336
# Checks if two senders match, by pointer equality and port name matching.#line 337
def sender_eq (s1,s2):                                      #line 338
    same_components = ( s1.component ==  s2.component)      #line 339
    same_ports = ( s1.port ==  s2.port)                     #line 340
    return  same_components and  same_ports                 #line 341#line 342#line 343

# Delivers the given message to the receiver of this connector.#line 344#line 345
def deposit (parent,conn,message):                          #line 346
    new_message = make_message ( conn.receiver.port, message.datum)#line 347
    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)#line 348#line 349#line 350

def force_tick (parent,eh):                                 #line 351
    tick_msg = make_message ( ".",new_datum_tick ())        #line 352
    push_message ( parent, eh, eh.inq, tick_msg)            #line 353
    return  tick_msg                                        #line 354#line 355#line 356

def push_message (parent,receiver,inq,m):                   #line 357
    inq.put ( m)                                            #line 358
    parent.visit_ordering.put ( receiver)                   #line 359#line 360#line 361

def is_self (child,container):                              #line 362
    # in an earlier version “self“ was denoted as ϕ         #line 363
    return  child ==  container                             #line 364#line 365#line 366

def step_child (child,msg):                                 #line 367
    before_state =  child.state                             #line 368
    child.handler ( child, msg)                             #line 369
    after_state =  child.state                              #line 370
    return [ before_state ==  "idle" and  after_state!= "idle", before_state!= "idle" and  after_state!= "idle", before_state!= "idle" and  after_state ==  "idle"]#line 373#line 374#line 375

def save_message (eh,msg):                                  #line 376
    eh.saved_messages.put ( msg)                            #line 377#line 378#line 379

def fetch_saved_message_and_clear (eh):                     #line 380
    return  eh.saved_messages.get ()                        #line 381#line 382#line 383

def step_children (container,causingMessage):               #line 384
    container.state =  "idle"                               #line 385
    for child in list ( container.visit_ordering.queue):    #line 386
        # child = container represents self, skip it        #line 387
        if (not (is_self ( child, container))):             #line 388
            if (not ( child.inq.empty ())):                 #line 389
                msg =  child.inq.get ()                     #line 390
                began_long_run =  None                      #line 391
                continued_long_run =  None                  #line 392
                ended_long_run =  None                      #line 393
                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 394
                if  began_long_run:                         #line 395
                    save_message ( child, msg)              #line 396
                elif  continued_long_run:                   #line 397
                    pass                                    #line 398#line 399
                destroy_message ( msg)                      #line 400
            else:                                           #line 401
                if  child.state!= "idle":                   #line 402
                    msg = force_tick ( container, child)    #line 403
                    child.handler ( child, msg)             #line 404
                    destroy_message ( msg)                  #line 405#line 406
            if  child.state ==  "active":                   #line 407
                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 408
                container.state =  "active"                 #line 409#line 410
            while (not ( child.outq.empty ())):             #line 411
                msg =  child.outq.get ()                    #line 412
                route ( container, child, msg)              #line 413
                destroy_message ( msg)                      #line 414#line 415#line 416#line 417#line 418

def attempt_tick (parent,eh):                               #line 419
    if  eh.state!= "idle":                                  #line 420
        force_tick ( parent, eh)                            #line 421#line 422#line 423

def is_tick (msg):                                          #line 424
    return  "tick" ==  msg.datum.kind ()                    #line 425#line 426#line 427

# Routes a single message to all matching destinations, according to#line 428
# the container's connection network.                       #line 429#line 430
def route (container,from_component,message):               #line 431
    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)#line 432
    fromname =  ""                                          #line 433
    if is_tick ( message):                                  #line 434
        for child in  container.children:                   #line 435
            attempt_tick ( container, child)                #line 436
        was_sent =  True                                    #line 437
    else:                                                   #line 438
        if (not (is_self ( from_component, container))):    #line 439
            fromname =  from_component.name                 #line 440
        from_sender = Sender ( fromname, from_component, message.port)#line 441#line 442
        for connector in  container.connections:            #line 443
            if sender_eq ( from_sender, connector.sender):  #line 444
                deposit ( container, connector, message)    #line 445
                was_sent =  True                            #line 446
    if not ( was_sent):                                     #line 447
        print ( "\n\n*** Error: ***")                       #line 448
        print ( "***")                                      #line 449
        print ( str( container.name) +  str( ": message '") +  str( message.port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 450
        print ( "***")                                      #line 451
        exit ()                                             #line 452#line 453#line 454#line 455

def any_child_ready (container):                            #line 456
    for child in  container.children:                       #line 457
        if child_is_ready ( child):                         #line 458
            return  True                                    #line 459
    return  False                                           #line 460#line 461#line 462

def child_is_ready (eh):                                    #line 463
    return (not ( eh.outq.empty ())) or (not ( eh.inq.empty ())) or ( eh.state!= "idle") or (any_child_ready ( eh))#line 464#line 465#line 466

def append_routing_descriptor (container,desc):             #line 467
    container.routings.put ( desc)                          #line 468#line 469#line 470

def container_injector (container,message):                 #line 471
    container_handler ( container, message)                 #line 472#line 473#line 474






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
        template =  reg.templates [template_name]           #line 49
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
        self.kind =  None # enum { container, leaf, }       #line 164#line 165
                                                            #line 166
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 167
# whose handler function is `container_handler`.            #line 168
def make_container (name,owner):                            #line 169
    eh = Eh ()                                              #line 170
    eh.name =  name                                         #line 171
    eh.owner =  owner                                       #line 172
    eh.handler =  container_handler                         #line 173
    eh.inject =  container_injector                         #line 174
    eh.state =  "idle"                                      #line 175
    eh.kind =  "container"                                  #line 176
    return  eh                                              #line 177#line 178#line 179

# Creates a new leaf component out of a handler function, and a data parameter#line 180
# that will be passed back to your handler when called.     #line 181#line 182
def make_leaf (name,owner,instance_data,handler):           #line 183
    eh = Eh ()                                              #line 184
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
    eh.inject ( eh, msg)                                    #line 214#line 215#line 216

# Returns a list of all output messages on a container.     #line 217
# For testing / debugging purposes.                         #line 218#line 219
def output_list (eh):                                       #line 220
    return  eh.outq                                         #line 221#line 222#line 223

# Utility for printing an array of messages.                #line 224
def print_output_list (eh):                                 #line 225
    for m in list ( eh.outq.queue):                         #line 226
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
    for msg in list ( eh.outq.queue):                       #line 248
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
    eh.outq.put ( msg)                                      #line 267#line 268#line 269

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
    def __init__ (self,firstmsg,secondmsg):                 #line 313
        self.firstmsg =  firstmsg                           #line 314
        self.secondmsg =  secondmsg                         #line 315#line 316
                                                            #line 317
# Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg }#line 318
class Deracer_Instance_Data:
    def __init__ (self,state,buffer):                       #line 319
        self.state =  state                                 #line 320
        self.buffer =  buffer                               #line 321#line 322
                                                            #line 323
def reclaim_Buffers_from_heap (inst):                       #line 324
    pass                                                    #line 325#line 326#line 327

def deracer_instantiate (reg,owner,name,template_data):     #line 328
    name_with_id = gensymbol ( "deracer")                   #line 329
    inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))#line 330
    inst.state =  "idle"                                    #line 331
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 332
    return  eh                                              #line 333#line 334#line 335

def send_firstmsg_then_secondmsg (eh,inst):                 #line 336
    forward ( eh, "1", inst.buffer.firstmsg)                #line 337
    forward ( eh, "2", inst.buffer.secondmsg)               #line 338
    reclaim_Buffers_from_heap ( inst)                       #line 339#line 340#line 341

def deracer_handler (eh,msg):                               #line 342
    inst =  eh.instance_data                                #line 343
    if  inst.state ==  "idle":                              #line 344
        if  "1" ==  msg.port:                               #line 345
            inst.buffer.firstmsg =  msg                     #line 346
            inst.state =  "waitingForSecondmsg"             #line 347
        elif  "2" ==  msg.port:                             #line 348
            inst.buffer.secondmsg =  msg                    #line 349
            inst.state =  "waitingForFirstmsg"              #line 350
        else:                                               #line 351
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 352
    elif  inst.state ==  "waitingForFirstmsg":              #line 353
        if  "1" ==  msg.port:                               #line 354
            inst.buffer.firstmsg =  msg                     #line 355
            send_firstmsg_then_secondmsg ( eh, inst)        #line 356
            inst.state =  "idle"                            #line 357
        else:                                               #line 358
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 359
    elif  inst.state ==  "waitingForSecondmsg":             #line 360
        if  "2" ==  msg.port:                               #line 361
            inst.buffer.secondmsg =  msg                    #line 362
            send_firstmsg_then_secondmsg ( eh, inst)        #line 363
            inst.state =  "idle"                            #line 364
        else:                                               #line 365
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg.port )#line 366
    else:                                                   #line 367
        runtime_error ( "bad state for deracer {eh.state}") #line 368#line 369#line 370

def low_level_read_text_file_instantiate (reg,owner,name,template_data):#line 371
    name_with_id = gensymbol ( "Low Level Read Text File")  #line 372
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 373#line 374#line 375

def low_level_read_text_file_handler (eh,msg):              #line 376
    fname =  msg.datum.srepr ()                             #line 377

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
                                                            #line 378#line 379#line 380

def ensure_string_datum_instantiate (reg,owner,name,template_data):#line 381
    name_with_id = gensymbol ( "Ensure String Datum")       #line 382
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)#line 383#line 384#line 385

def ensure_string_datum_handler (eh,msg):                   #line 386
    if  "string" ==  msg.datum.kind ():                     #line 387
        forward ( eh, "", msg)                              #line 388
    else:                                                   #line 389
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum #line 390
        send_string ( eh, "✗", emsg, msg)                   #line 391#line 392#line 393

class Syncfilewrite_Data:
    def __init__ (self,):                                   #line 394
        self.filename =  ""                                 #line 395#line 396
                                                            #line 397
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)#line 398
def syncfilewrite_instantiate (reg,owner,name,template_data):#line 399
    name_with_id = gensymbol ( "syncfilewrite")             #line 400
    inst = Syncfilewrite_Data ()                            #line 401
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)#line 402#line 403#line 404

def syncfilewrite_handler (eh,msg):                         #line 405
    inst =  eh.instance_data                                #line 406
    if  "filename" ==  msg.port:                            #line 407
        inst.filename =  msg.datum.srepr ()                 #line 408
    elif  "input" ==  msg.port:                             #line 409
        contents =  msg.datum.srepr ()                      #line 410
        f = open ( inst.filename, "w")                      #line 411
        if  f!= None:                                       #line 412
            f.write ( msg.datum.srepr ())                   #line 413
            f.close ()                                      #line 414
            send ( eh, "done",new_datum_bang (), msg)       #line 415
        else:                                               #line 416
            send_string ( eh, "✗", str( "open error on file ") +  inst.filename , msg)#line 417#line 418#line 419

class StringConcat_Instance_Data:
    def __init__ (self,):                                   #line 420
        self.buffer1 =  None                                #line 421
        self.buffer2 =  None                                #line 422
        self.count =  0                                     #line 423#line 424
                                                            #line 425
def stringconcat_instantiate (reg,owner,name,template_data):#line 426
    name_with_id = gensymbol ( "stringconcat")              #line 427
    instp = StringConcat_Instance_Data ()                   #line 428
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 429#line 430#line 431

def stringconcat_handler (eh,msg):                          #line 432
    inst =  eh.instance_data                                #line 433
    if  "1" ==  msg.port:                                   #line 434
        inst.buffer1 = clone_string ( msg.datum.srepr ())   #line 435
        inst.count =  inst.count+ 1                         #line 436
        maybe_stringconcat ( eh, inst, msg)                 #line 437
    elif  "2" ==  msg.port:                                 #line 438
        inst.buffer2 = clone_string ( msg.datum.srepr ())   #line 439
        inst.count =  inst.count+ 1                         #line 440
        maybe_stringconcat ( eh, inst, msg)                 #line 441
    else:                                                   #line 442
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 443#line 444#line 445#line 446

def maybe_stringconcat (eh,inst,msg):                       #line 447
    if ( 0 == len ( inst.buffer1)) and ( 0 == len ( inst.buffer2)):#line 448
        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 449
    if  inst.count >=  2:                                   #line 450
        concatenated_string =  ""                           #line 451
        if  0 == len ( inst.buffer1):                       #line 452
            concatenated_string =  inst.buffer2             #line 453
        elif  0 == len ( inst.buffer2):                     #line 454
            concatenated_string =  inst.buffer1             #line 455
        else:                                               #line 456
            concatenated_string =  inst.buffer1+ inst.buffer2#line 457
        send_string ( eh, "", concatenated_string, msg)     #line 458
        inst.buffer1 =  None                                #line 459
        inst.buffer2 =  None                                #line 460
        inst.count =  0                                     #line 461#line 462#line 463

#                                                           #line 464#line 465
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 466
def shell_out_instantiate (reg,owner,name,template_data):   #line 467
    name_with_id = gensymbol ( "shell_out")                 #line 468
    cmd = shlex.split ( template_data)                      #line 469
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)#line 470#line 471#line 472

def shell_out_handler (eh,msg):                             #line 473
    cmd =  eh.instance_data                                 #line 474
    s =  msg.datum.srepr ()                                 #line 475
    ret =  None                                             #line 476
    rc =  None                                              #line 477
    stdout =  None                                          #line 478
    stderr =  None                                          #line 479
    ret = subprocess.run ( cmd,   s, "UTF_8")
    rc = ret.returncode
    stdout = ret.stdout
    stderr = ret.stderr                                     #line 480
    if  rc!= 0:                                             #line 481
        send_string ( eh, "✗", stderr, msg)                 #line 482
    else:                                                   #line 483
        send_string ( eh, "", stdout, msg)                  #line 484#line 485#line 486#line 487

def string_constant_instantiate (reg,owner,name,template_data):#line 488
    global root_project                                     #line 489
    global root_0D                                          #line 490
    name_with_id = gensymbol ( "strconst")                  #line 491
    s =  template_data                                      #line 492
    if  root_project!= "":                                  #line 493
        s = re.sub ( "_00_",  root_project,  s)             #line 494#line 495
    if  root_0D!= "":                                       #line 496
        s = re.sub ( "_0D_",  root_0D,  s)                  #line 497#line 498
    return make_leaf ( name_with_id, owner, s, string_constant_handler)#line 499#line 500#line 501

def string_constant_handler (eh,msg):                       #line 502
    s =  eh.instance_data                                   #line 503
    send_string ( eh, "", s, msg)                           #line 504#line 505#line 506

def string_make_persistent (s):                             #line 507
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 508
    return  s                                               #line 509#line 510#line 511

def string_clone (s):                                       #line 512
    return  s                                               #line 513#line 514#line 515

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...#line 516
# where ${_00_} is the root directory for the project       #line 517
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)#line 518#line 519
def initialize_component_palette (root_project,root_0D,diagram_source_files):#line 520
    reg = make_component_registry ()                        #line 521
    for diagram_source in  diagram_source_files:            #line 522
        all_containers_within_single_file = json2internal ( root_project, diagram_source)#line 523
        reg = generate_shell_components ( reg, all_containers_within_single_file)#line 524
        for container in  all_containers_within_single_file:#line 525
            register_component ( reg,Template ( container [ "name"], container, container_instantiator))#line 526#line 527#line 528
    print ( reg)                                            #line 529
    reg = initialize_stock_components ( reg)                #line 530
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
    register_component ( reg,Template ( "1then2", None, deracer_instantiate))#line 597
    register_component ( reg,Template ( "?", None, probe_instantiate))#line 598
    register_component ( reg,Template ( "?A", None, probeA_instantiate))#line 599
    register_component ( reg,Template ( "?B", None, probeB_instantiate))#line 600
    register_component ( reg,Template ( "?C", None, probeC_instantiate))#line 601
    register_component ( reg,Template ( "trash", None, trash_instantiate))#line 602#line 603
    register_component ( reg,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 604
    register_component ( reg,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 605#line 606
    register_component ( reg,Template ( "syncfilewrite", None, syncfilewrite_instantiate))#line 607
    register_component ( reg,Template ( "stringconcat", None, stringconcat_instantiate))#line 608
    # for fakepipe                                          #line 609
    register_component ( reg,Template ( "fakepipename", None, fakepipename_instantiate))#line 610#line 611#line 612

def argv ():                                                #line 613
    sys.argv                                                #line 614#line 615#line 616

def initialize ():                                          #line 617
    root_of_project =  sys.argv[ 1]                         #line 618
    root_of_0D =  sys.argv[ 2]                              #line 619
    arg =  sys.argv[ 3]                                     #line 620
    main_container_name =  sys.argv[ 4]                     #line 621
    diagram_names =  sys.argv[ 5:]                          #line 622
    palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)#line 623
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 624#line 625#line 626

def start (palette,env):
    start_helper ( palette, env, False)                     #line 627

def start_show_all (palette,env):
    start_helper ( palette, env, True)                      #line 628

def start_helper (palette,env,show_all_outputs):            #line 629
    root_of_project =  env [ 0]                             #line 630
    root_of_0D =  env [ 1]                                  #line 631
    main_container_name =  env [ 2]                         #line 632
    diagram_names =  env [ 3]                               #line 633
    arg =  env [ 4]                                         #line 634
    set_environment ( root_of_project, root_of_0D)          #line 635
    # get entrypoint container                              #line 636
    main_container = get_component_instance ( palette, main_container_name, None)#line 637
    if  None ==  main_container:                            #line 638
        load_error ( str( "Couldn't find container with page name /") +  str( main_container_name) +  str( "/ in files ") +  str(str ( diagram_names)) +  " (check tab names, or disable compression?)"    )#line 642#line 643
    if not  load_errors:                                    #line 644
        arg = new_datum_string ( arg)                       #line 645
        msg = make_message ( "", arg)                       #line 646
        inject ( main_container, msg)                       #line 647
        if  show_all_outputs:                               #line 648
            dump_outputs ( main_container)                  #line 649
        else:                                               #line 650
            print_error_maybe ( main_container)             #line 651
            outp = fetch_first_output ( main_container, "") #line 652
            if  None ==  outp:                              #line 653
                print ( "(no outputs)")                     #line 654
            else:                                           #line 655
                print_specific_output ( main_container, "") #line 656#line 657#line 658
        if  show_all_outputs:                               #line 659
            print ( "--- done ---")                         #line 660#line 661#line 662#line 663#line 664
                                                            #line 665#line 666
# utility functions                                         #line 667
def send_int (eh,port,i,causing_message):                   #line 668
    datum = new_datum_int ( i)                              #line 669
    send ( eh, port, datum, causing_message)                #line 670#line 671#line 672

def send_bang (eh,port,causing_message):                    #line 673
    datum = new_datum_bang ()                               #line 674
    send ( eh, port, datum, causing_message)                #line 675#line 676#line 677





