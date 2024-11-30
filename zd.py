

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
    def __init__ (self,):                                   #line 176
        self.port =  None                                   #line 177
        self.datum =  None                                  #line 178#line 179
                                                            #line 180
def clone_port (s):                                         #line 181
    return clone_string ( s)                                #line 182#line 183#line 184

# Utility for making a `Message`. Used to safely “seed“ messages#line 185
# entering the very top of a network.                       #line 186
def make_message (port,datum):                              #line 187
    p = clone_string ( port)                                #line 188
    m =  Message ()                                         #line 189
    m.port =  p                                             #line 190
    m.datum =  datum.clone ()                               #line 191
    return  m                                               #line 192#line 193#line 194

# Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations.#line 195
def message_clone (msg):                                    #line 196
    m =  Message ()                                         #line 197
    m.port = clone_port ( msg.port)                         #line 198
    m.datum =  msg.datum.clone ()                           #line 199
    return  m                                               #line 200#line 201#line 202

# Frees a message.                                          #line 203
def destroy_message (msg):                                  #line 204
    # during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages#line 205
    pass                                                    #line 206#line 207#line 208

def destroy_datum (msg):                                    #line 209
    pass                                                    #line 210#line 211#line 212

def destroy_port (msg):                                     #line 213
    pass                                                    #line 214#line 215#line 216

#                                                           #line 217
def format_message (m):                                     #line 218
    if  m ==  None:                                         #line 219
        return  "ϕ"                                         #line 220
    else:                                                   #line 221
        return  str( "⟪") +  str( m.port) +  str( "⦂") +  str( m.datum.srepr ()) +  "⟫"    #line 225#line 226#line 227#line 228
                                                            #line 229
enumDown =  0                                               #line 230
enumAcross =  1                                             #line 231
enumUp =  2                                                 #line 232
enumThrough =  3                                            #line 233#line 234
def container_instantiator (reg,owner,container_name,desc): #line 235
    global enumDown, enumUp, enumAcross, enumThrough        #line 236
    container = make_container ( container_name, owner)     #line 237
    children = []                                           #line 238
    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here#line 239
    # collect children                                      #line 240
    for child_desc in  desc [ "children"]:                  #line 241
        child_instance = get_component_instance ( reg, child_desc [ "name"], container)#line 242
        children.append ( child_instance)                   #line 243
        id =  child_desc [ "id"]                            #line 244
        children_by_id [id] =  child_instance               #line 245#line 246#line 247
    container.children =  children                          #line 248
    me =  container                                         #line 249#line 250
    connectors = []                                         #line 251
    for proto_conn in  desc [ "connections"]:               #line 252
        connector =  Connector ()                           #line 253
        if  proto_conn [ "dir"] ==  enumDown:               #line 254
            # JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 255
            connector.direction =  "down"                   #line 256
            connector.sender = Sender ( me.name, me, proto_conn [ "source_port"])#line 257
            target_component =  children_by_id [ proto_conn [ "target" [ "id"]]]#line 258
            if ( target_component ==  None):                #line 259
                load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn [ "target"] )#line 260
            else:                                           #line 261
                connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn [ "target_port"], target_component)#line 262
                connectors.append ( connector)              #line 263
        elif  proto_conn [ "dir"] ==  enumAcross:           #line 264
            connector.direction =  "across"                 #line 265
            source_component =  children_by_id [ proto_conn [ "source" [ "id"]]]#line 266
            target_component =  children_by_id [ proto_conn [ "target" [ "id"]]]#line 267
            if  source_component ==  None:                  #line 268
                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn [ "source"] )#line 269
            else:                                           #line 270
                connector.sender = Sender ( source_component.name, source_component, proto_conn [ "source_port"])#line 271
                if  target_component ==  None:              #line 272
                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn.target )#line 273
                else:                                       #line 274
                    connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn [ "target_port"], target_component)#line 275
                    connectors.append ( connector)          #line 276
        elif  proto_conn [ "dir"] ==  enumUp:               #line 277
            connector.direction =  "up"                     #line 278
            source_component =  children_by_id [ proto_conn [ "source" [ "id"]]]#line 279
            if  source_component ==  None:                  #line 280
                print ( str( "internal error: .Up connection source not ok ") +  proto_conn [ "source"] )#line 281
            else:                                           #line 282
                connector.sender = Sender ( source_component.name, source_component, proto_conn [ "source_port"])#line 283
                connector.receiver = Receiver ( me.name, container.outq, proto_conn [ "target_port"], me)#line 284
                connectors.append ( connector)              #line 285
        elif  proto_conn [ "dir"] ==  enumThrough:          #line 286
            connector.direction =  "through"                #line 287
            connector.sender = Sender ( me.name, me, proto_conn [ "source_port"])#line 288
            connector.receiver = Receiver ( me.name, container.outq, proto_conn [ "target_port"], me)#line 289
            connectors.append ( connector)                  #line 290#line 291
    container.connections =  connectors                     #line 292
    return  container                                       #line 293#line 294#line 295

# The default handler for container components.             #line 296
def container_handler (container,message):                  #line 297
    route ( container, container, message)
    # references to 'self' are replaced by the container during instantiation#line 298
    while any_child_ready ( container):                     #line 299
        step_children ( container, message)                 #line 300#line 301#line 302

# Frees the given container and associated data.            #line 303
def destroy_container (eh):                                 #line 304
    pass                                                    #line 305#line 306#line 307

def fifo_is_empty (fifo):                                   #line 308
    return  fifo.empty ()                                   #line 309#line 310#line 311

# Routing connection for a container component. The `direction` field has#line 312
# no affect on the default message routing system _ it is there for debugging#line 313
# purposes, or for reading by other tools.                  #line 314#line 315
class Connector:
    def __init__ (self,):                                   #line 316
        self.direction =  None # down, across, up, through  #line 317
        self.sender =  None                                 #line 318
        self.receiver =  None                               #line 319#line 320
                                                            #line 321
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,#line 322
# based on component ID (pointer) and port name.            #line 323#line 324
class Sender:
    def __init__ (self,name,component,port):                #line 325
        self.name =  name                                   #line 326
        self.component =  component # from                  #line 327
        self.port =  port # from's port                     #line 328#line 329
                                                            #line 330
# `Receiver` is a handle to a destination queue, and a `port` name to assign#line 331
# to incoming messages to this queue.                       #line 332#line 333
class Receiver:
    def __init__ (self,name,queue,port,component):          #line 334
        self.name =  name                                   #line 335
        self.queue =  queue # queue (input | output) of receiver#line 336
        self.port =  port # destination port                #line 337
        self.component =  component # to (for bootstrap debug)#line 338#line 339
                                                            #line 340
# Checks if two senders match, by pointer equality and port name matching.#line 341
def sender_eq (s1,s2):                                      #line 342
    same_components = ( s1.component ==  s2.component)      #line 343
    same_ports = ( s1.port ==  s2.port)                     #line 344
    return  same_components and  same_ports                 #line 345#line 346#line 347

# Delivers the given message to the receiver of this connector.#line 348#line 349
def deposit (parent,conn,message):                          #line 350
    new_message = make_message ( conn.receiver.port, message.datum)#line 351
    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)#line 352#line 353#line 354

def force_tick (parent,eh):                                 #line 355
    tick_msg = make_message ( ".",new_datum_tick ())        #line 356
    push_message ( parent, eh, eh.inq, tick_msg)            #line 357
    return  tick_msg                                        #line 358#line 359#line 360

def push_message (parent,receiver,inq,m):                   #line 361
    inq.put ( m)                                            #line 362
    parent.visit_ordering.put ( receiver)                   #line 363#line 364#line 365

def is_self (child,container):                              #line 366
    # in an earlier version “self“ was denoted as ϕ         #line 367
    return  child ==  container                             #line 368#line 369#line 370

def step_child (child,msg):                                 #line 371
    before_state =  child.state                             #line 372
    child.handler ( child, msg)                             #line 373
    after_state =  child.state                              #line 374
    return [ before_state ==  "idle" and  after_state!= "idle", before_state!= "idle" and  after_state!= "idle", before_state!= "idle" and  after_state ==  "idle"]#line 377#line 378#line 379

def save_message (eh,msg):                                  #line 380
    eh.saved_messages.put ( msg)                            #line 381#line 382#line 383

def fetch_saved_message_and_clear (eh):                     #line 384
    return  eh.saved_messages.get ()                        #line 385#line 386#line 387

def step_children (container,causingMessage):               #line 388
    container.state =  "idle"                               #line 389
    for child in list ( container.visit_ordering.queue):    #line 390
        # child = container represents self, skip it        #line 391
        if (not (is_self ( child, container))):             #line 392
            if (not ( child.inq.empty ())):                 #line 393
                msg =  child.inq.get ()                     #line 394
                began_long_run =  None                      #line 395
                continued_long_run =  None                  #line 396
                ended_long_run =  None                      #line 397
                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 398
                if  began_long_run:                         #line 399
                    save_message ( child, msg)              #line 400
                elif  continued_long_run:                   #line 401
                    pass                                    #line 402#line 403
                destroy_message ( msg)                      #line 404
            else:                                           #line 405
                if  child.state!= "idle":                   #line 406
                    msg = force_tick ( container, child)    #line 407
                    child.handler ( child, msg)             #line 408
                    destroy_message ( msg)                  #line 409#line 410
            if  child.state ==  "active":                   #line 411
                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 412
                container.state =  "active"                 #line 413#line 414
            while (not ( child.outq.empty ())):             #line 415
                msg =  child.outq.get ()                    #line 416
                route ( container, child, msg)              #line 417
                destroy_message ( msg)                      #line 418#line 419#line 420#line 421#line 422

def attempt_tick (parent,eh):                               #line 423
    if  eh.state!= "idle":                                  #line 424
        force_tick ( parent, eh)                            #line 425#line 426#line 427

def is_tick (msg):                                          #line 428
    return  "tick" ==  msg.datum.kind ()                    #line 429#line 430#line 431

# Routes a single message to all matching destinations, according to#line 432
# the container's connection network.                       #line 433#line 434
def route (container,from_component,message):               #line 435
    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)#line 436
    fromname =  ""                                          #line 437
    if is_tick ( message):                                  #line 438
        for child in  container.children:                   #line 439
            attempt_tick ( container, child)                #line 440
        was_sent =  True                                    #line 441
    else:                                                   #line 442
        if (not (is_self ( from_component, container))):    #line 443
            fromname =  from_component.name                 #line 444
        from_sender = Sender ( fromname, from_component, message.port)#line 445#line 446
        for connector in  container.connections:            #line 447
            if sender_eq ( from_sender, connector.sender):  #line 448
                deposit ( container, connector, message)    #line 449
                was_sent =  True                            #line 450
    if not ( was_sent):                                     #line 451
        print ( "\n\n*** Error: ***")                       #line 452
        print ( "***")                                      #line 453
        print ( str( container.name) +  str( ": message '") +  str( message.port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 454
        print ( "***")                                      #line 455
        exit ()                                             #line 456#line 457#line 458#line 459

def any_child_ready (container):                            #line 460
    for child in  container.children:                       #line 461
        if child_is_ready ( child):                         #line 462
            return  True                                    #line 463
    return  False                                           #line 464#line 465#line 466

def child_is_ready (eh):                                    #line 467
    return (not ( eh.outq.empty ())) or (not ( eh.inq.empty ())) or ( eh.state!= "idle") or (any_child_ready ( eh))#line 468#line 469#line 470

def append_routing_descriptor (container,desc):             #line 471
    container.routings.put ( desc)                          #line 472#line 473#line 474

def container_injector (container,message):                 #line 475
    container_handler ( container, message)                 #line 476#line 477#line 478






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
        reg.templates.insert (NIY ( name,  template))       #line 49
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
            instance.depth = calculate_depth ( instance)    #line 70
            return  instance                                #line 71
    else:                                                   #line 72
        load_error ( str( "Registry Error (B): Can't find component /") +  str( template_name) +  "/"  )#line 73
        return  None                                        #line 74#line 75

def calculate_depth (eh):                                   #line 76
    if  eh.owner ==  None:                                  #line 77
        return  0                                           #line 78
    else:                                                   #line 79
        return  1+calculate_depth ( eh.owner)               #line 80#line 81#line 82

def dump_registry (reg):                                    #line 83
    nl ()                                                   #line 84
    print ( "*** PALETTE ***")                              #line 85
    for c in  reg.templates:                                #line 86
        print ( c.name)                                     #line 87
    print ( "***************")                              #line 88
    nl ()                                                   #line 89#line 90#line 91

def print_stats (reg):                                      #line 92
    print ( str( "registry statistics: ") +  reg.stats )    #line 93#line 94#line 95

def mangle_name (s):                                        #line 96
    # trim name to remove code from Container component names _ deferred until later (or never)#line 97
    return  s                                               #line 98#line 99#line 100

def generate_shell_components (reg,container_list):         #line 101
    # [                                                     #line 102
    #     {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 103
    #     {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []}#line 104
    # ]                                                     #line 105
    if  None!= container_list:                              #line 106
        for diagram in  container_list:                     #line 107
            # loop through every component in the diagram and look for names that start with “$“#line 108
            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 109
            for child_descriptor in  diagram [ "children"]: #line 110
                if first_char_is ( child_descriptor [ "name"], "$"):#line 111
                    name =  child_descriptor [ "name"]      #line 112
                    cmd =   name[1:] .strip ()              #line 113
                    generated_leaf = Template ( name, shell_out_instantiate, cmd)#line 114
                    register_component ( reg, generated_leaf)#line 115
                elif first_char_is ( child_descriptor [ "name"], "'"):#line 116
                    name =  child_descriptor [ "name"]      #line 117
                    s =   name[1:]                          #line 118
                    generated_leaf = Template ( name, string_constant_instantiate, s)#line 119
                    register_component_allow_overwriting ( reg, generated_leaf)#line 120#line 121#line 122#line 123#line 124
    return  reg                                             #line 125#line 126#line 127

def first_char (s):                                         #line 128
    return   s[0]                                           #line 129#line 130#line 131

def first_char_is (s,c):                                    #line 132
    return  c == first_char ( s)                            #line 133#line 134#line 135
                                                            #line 136
# TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 137
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 138#line 139#line 140
# Data for an asyncronous component _ effectively, a function with input#line 141
# and output queues of messages.                            #line 142
#                                                           #line 143
# Components can either be a user_supplied function (“lea“), or a “container“#line 144
# that routes messages to child components according to a list of connections#line 145
# that serve as a message routing table.                    #line 146
#                                                           #line 147
# Child components themselves can be leaves or other containers.#line 148
#                                                           #line 149
# `handler` invokes the code that is attached to this component.#line 150
#                                                           #line 151
# `instance_data` is a pointer to instance data that the `leaf_handler`#line 152
# function may want whenever it is invoked again.           #line 153
#                                                           #line 154#line 155
# Eh_States :: enum { idle, active }                        #line 156
class Eh:
    def __init__ (self,):                                   #line 157
        self.name =  ""                                     #line 158
        self.inq =  queue.Queue ()                          #line 159
        self.outq =  queue.Queue ()                         #line 160
        self.owner =  None                                  #line 161
        self.saved_messages =  queue.LifoQueue () # stack of saved message(s)#line 162
        self.children = []                                  #line 163
        self.visit_ordering =  queue.Queue ()               #line 164
        self.connections = []                               #line 165
        self.routings =  queue.Queue ()                     #line 166
        self.handler =  None                                #line 167
        self.finject =  None                                #line 168
        self.instance_data =  None                          #line 169
        self.state =  "idle"                                #line 170# bootstrap debugging#line 171
        self.kind =  None # enum { container, leaf, }       #line 172#line 173
                                                            #line 174
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 175
# whose handler function is `container_handler`.            #line 176
def make_container (name,owner):                            #line 177
    eh =  Eh ()                                             #line 178
    eh.name =  name                                         #line 179
    eh.owner =  owner                                       #line 180
    eh.handler =  container_handler                         #line 181
    eh.finject =  container_injector                        #line 182
    eh.state =  "idle"                                      #line 183
    eh.kind =  "container"                                  #line 184
    return  eh                                              #line 185#line 186#line 187

# Creates a new leaf component out of a handler function, and a data parameter#line 188
# that will be passed back to your handler when called.     #line 189#line 190
def make_leaf (name,owner,instance_data,handler):           #line 191
    eh =  Eh ()                                             #line 192
    eh.name =  str( owner.name) +  str( ".") +  name        #line 193
    eh.owner =  owner                                       #line 194
    eh.handler =  handler                                   #line 195
    eh.instance_data =  instance_data                       #line 196
    eh.state =  "idle"                                      #line 197
    eh.kind =  "leaf"                                       #line 198
    return  eh                                              #line 199#line 200#line 201

# Sends a message on the given `port` with `data`, placing it on the output#line 202
# of the given component.                                   #line 203#line 204
def send (eh,port,datum,causingMessage):                    #line 205
    msg = make_message ( port, datum)                       #line 206
    put_output ( eh, msg)                                   #line 207#line 208#line 209

def send_string (eh,port,s,causingMessage):                 #line 210
    datum = new_datum_string ( s)                           #line 211
    msg = make_message ( port, datum)                       #line 212
    put_output ( eh, msg)                                   #line 213#line 214#line 215

def forward (eh,port,msg):                                  #line 216
    fwdmsg = make_message ( port, msg.datum)                #line 217
    put_output ( eh, msg)                                   #line 218#line 219#line 220

def inject (eh,msg):                                        #line 221
    eh.finject ( eh, msg)                                   #line 222#line 223#line 224

# Returns a list of all output messages on a container.     #line 225
# For testing / debugging purposes.                         #line 226#line 227
def output_list (eh):                                       #line 228
    return  eh.outq                                         #line 229#line 230#line 231

# Utility for printing an array of messages.                #line 232
def print_output_list (eh):                                 #line 233
    for m in list ( eh.outq.queue):                         #line 234
        print (format_message ( m))                         #line 235#line 236#line 237

def spaces (n):                                             #line 238
    s =  ""                                                 #line 239
    for i in range( n):                                     #line 240
        s =  s+ " "                                         #line 241
    return  s                                               #line 242#line 243#line 244

def set_active (eh):                                        #line 245
    eh.state =  "active"                                    #line 246#line 247#line 248

def set_idle (eh):                                          #line 249
    eh.state =  "idle"                                      #line 250#line 251#line 252

# Utility for printing a specific output message.           #line 253#line 254
def fetch_first_output (eh,port):                           #line 255
    for msg in list ( eh.outq.queue):                       #line 256
        if ( msg.port ==  port):                            #line 257
            return  msg.datum                               #line 258
    return  None                                            #line 259#line 260#line 261

def print_specific_output (eh,port):                        #line 262
    # port ∷ “”                                             #line 263
    datum = fetch_first_output ( eh, port)                  #line 264
    print ( datum.srepr ())                                 #line 265#line 266

def print_specific_output_to_stderr (eh,port):              #line 267
    # port ∷ “”                                             #line 268
    datum = fetch_first_output ( eh, port)                  #line 269
    # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 270
    print ( datum.srepr (), file=sys.stderr)                #line 271#line 272#line 273

def put_output (eh,msg):                                    #line 274
    eh.outq.put ( msg)                                      #line 275#line 276#line 277

root_project =  ""                                          #line 278
root_0D =  ""                                               #line 279#line 280
def set_environment (rproject,r0D):                         #line 281
    global root_project                                     #line 282
    global root_0D                                          #line 283
    root_project =  rproject                                #line 284
    root_0D =  r0D                                          #line 285#line 286#line 287

def probe_instantiate (reg,owner,name,template_data):       #line 288
    name_with_id = gensymbol ( "?")                         #line 289
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 290#line 291

def probeA_instantiate (reg,owner,name,template_data):      #line 292
    name_with_id = gensymbol ( "?A")                        #line 293
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 294#line 295#line 296

def probeB_instantiate (reg,owner,name,template_data):      #line 297
    name_with_id = gensymbol ( "?B")                        #line 298
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 299#line 300#line 301

def probeC_instantiate (reg,owner,name,template_data):      #line 302
    name_with_id = gensymbol ( "?C")                        #line 303
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 304#line 305#line 306

def probe_handler (eh,msg):                                 #line 307
    s =  msg.datum.srepr ()                                 #line 308
    print ( str( "... probe ") +  str( eh.name) +  str( ": ") +  s   , file=sys.stderr)#line 309#line 310#line 311

def trash_instantiate (reg,owner,name,template_data):       #line 312
    name_with_id = gensymbol ( "trash")                     #line 313
    return make_leaf ( name_with_id, owner, None, trash_handler)#line 314#line 315#line 316

def trash_handler (eh,msg):                                 #line 317
    # to appease dumped_on_floor checker                    #line 318
    pass                                                    #line 319#line 320

class TwoMessages:
    def __init__ (self,):                                   #line 321
        self.firstmsg =  None                               #line 322
        self.secondmsg =  None                              #line 323#line 324
                                                            #line 325
# Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg }#line 326
class Deracer_Instance_Data:
    def __init__ (self,):                                   #line 327
        self.state =  None                                  #line 328
        self.buffer =  None                                 #line 329#line 330
                                                            #line 331
def reclaim_Buffers_from_heap (inst):                       #line 332
    pass                                                    #line 333#line 334#line 335

def deracer_instantiate (reg,owner,name,template_data):     #line 336
    name_with_id = gensymbol ( "deracer")                   #line 337
    inst =  Deracer_Instance_Data ()                        #line 338
    inst.state =  "idle"                                    #line 339
    inst.buffer =  TwoMessages ()                           #line 340
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 341
    return  eh                                              #line 342#line 343#line 344

def send_firstmsg_then_secondmsg (eh,inst):                 #line 345
    forward ( eh, "1", inst.buffer.firstmsg)                #line 346
    forward ( eh, "2", inst.buffer.secondmsg)               #line 347
    reclaim_Buffers_from_heap ( inst)                       #line 348#line 349#line 350

def deracer_handler (eh,msg):                               #line 351
    inst =  eh.instance_data                                #line 352
    if  inst.state ==  "idle":                              #line 353
        if  "1" ==  msg.port:                               #line 354
            inst.buffer.firstmsg =  msg                     #line 355
            inst.state =  "waitingForSecondmsg"             #line 356
        elif  "2" ==  msg.port:                             #line 357
            inst.buffer.secondmsg =  msg                    #line 358
            inst.state =  "waitingForFirstmsg"              #line 359
        else:                                               #line 360
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 361
    elif  inst.state ==  "waitingForFirstmsg":              #line 362
        if  "1" ==  msg.port:                               #line 363
            inst.buffer.firstmsg =  msg                     #line 364
            send_firstmsg_then_secondmsg ( eh, inst)        #line 365
            inst.state =  "idle"                            #line 366
        else:                                               #line 367
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 368
    elif  inst.state ==  "waitingForSecondmsg":             #line 369
        if  "2" ==  msg.port:                               #line 370
            inst.buffer.secondmsg =  msg                    #line 371
            send_firstmsg_then_secondmsg ( eh, inst)        #line 372
            inst.state =  "idle"                            #line 373
        else:                                               #line 374
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg.port )#line 375
    else:                                                   #line 376
        runtime_error ( "bad state for deracer {eh.state}") #line 377#line 378#line 379

def low_level_read_text_file_instantiate (reg,owner,name,template_data):#line 380
    name_with_id = gensymbol ( "Low Level Read Text File")  #line 381
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 382#line 383#line 384

def low_level_read_text_file_handler (eh,msg):              #line 385
    fname =  msg.datum.srepr ()                             #line 386

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
                                                            #line 387#line 388#line 389

def ensure_string_datum_instantiate (reg,owner,name,template_data):#line 390
    name_with_id = gensymbol ( "Ensure String Datum")       #line 391
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)#line 392#line 393#line 394

def ensure_string_datum_handler (eh,msg):                   #line 395
    if  "string" ==  msg.datum.kind ():                     #line 396
        forward ( eh, "", msg)                              #line 397
    else:                                                   #line 398
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum #line 399
        send_string ( eh, "✗", emsg, msg)                   #line 400#line 401#line 402

class Syncfilewrite_Data:
    def __init__ (self,):                                   #line 403
        self.filename =  ""                                 #line 404#line 405
                                                            #line 406
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)#line 407
def syncfilewrite_instantiate (reg,owner,name,template_data):#line 408
    name_with_id = gensymbol ( "syncfilewrite")             #line 409
    inst =  Syncfilewrite_Data ()                           #line 410
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)#line 411#line 412#line 413

def syncfilewrite_handler (eh,msg):                         #line 414
    inst =  eh.instance_data                                #line 415
    if  "filename" ==  msg.port:                            #line 416
        inst.filename =  msg.datum.srepr ()                 #line 417
    elif  "input" ==  msg.port:                             #line 418
        contents =  msg.datum.srepr ()                      #line 419
        f = open ( inst.filename, "w")                      #line 420
        if  f!= None:                                       #line 421
            f.write ( msg.datum.srepr ())                   #line 422
            f.close ()                                      #line 423
            send ( eh, "done",new_datum_bang (), msg)       #line 424
        else:                                               #line 425
            send_string ( eh, "✗", str( "open error on file ") +  inst.filename , msg)#line 426#line 427#line 428

class StringConcat_Instance_Data:
    def __init__ (self,):                                   #line 429
        self.buffer1 =  None                                #line 430
        self.buffer2 =  None                                #line 431
        self.scount =  0                                    #line 432#line 433
                                                            #line 434
def stringconcat_instantiate (reg,owner,name,template_data):#line 435
    name_with_id = gensymbol ( "stringconcat")              #line 436
    instp =  StringConcat_Instance_Data ()                  #line 437
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 438#line 439#line 440

def stringconcat_handler (eh,msg):                          #line 441
    inst =  eh.instance_data                                #line 442
    if  "1" ==  msg.port:                                   #line 443
        inst.buffer1 = clone_string ( msg.datum.srepr ())   #line 444
        inst.scount =  inst.scount+ 1                       #line 445
        maybe_stringconcat ( eh, inst, msg)                 #line 446
    elif  "2" ==  msg.port:                                 #line 447
        inst.buffer2 = clone_string ( msg.datum.srepr ())   #line 448
        inst.scount =  inst.scount+ 1                       #line 449
        maybe_stringconcat ( eh, inst, msg)                 #line 450
    else:                                                   #line 451
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 452#line 453#line 454#line 455

def maybe_stringconcat (eh,inst,msg):                       #line 456
    if ( 0 == len ( inst.buffer1)) and ( 0 == len ( inst.buffer2)):#line 457
        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 458
    if  inst.scount >=  2:                                  #line 459
        concatenated_string =  ""                           #line 460
        if  0 == len ( inst.buffer1):                       #line 461
            concatenated_string =  inst.buffer2             #line 462
        elif  0 == len ( inst.buffer2):                     #line 463
            concatenated_string =  inst.buffer1             #line 464
        else:                                               #line 465
            concatenated_string =  inst.buffer1+ inst.buffer2#line 466
        send_string ( eh, "", concatenated_string, msg)     #line 467
        inst.buffer1 =  None                                #line 468
        inst.buffer2 =  None                                #line 469
        inst.scount =  0                                    #line 470#line 471#line 472

#                                                           #line 473#line 474
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 475
def shell_out_instantiate (reg,owner,name,template_data):   #line 476
    name_with_id = gensymbol ( "shell_out")                 #line 477
    cmd = shlex.split ( template_data)                      #line 478
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)#line 479#line 480#line 481

def shell_out_handler (eh,msg):                             #line 482
    cmd =  eh.instance_data                                 #line 483
    s =  msg.datum.srepr ()                                 #line 484
    ret =  None                                             #line 485
    rc =  None                                              #line 486
    stdout =  None                                          #line 487
    stderr =  None                                          #line 488
    ret = subprocess.run ( cmd,   s, "UTF_8")
    rc = ret.returncode
    stdout = ret.stdout
    stderr = ret.stderr                                     #line 489
    if  rc!= 0:                                             #line 490
        send_string ( eh, "✗", stderr, msg)                 #line 491
    else:                                                   #line 492
        send_string ( eh, "", stdout, msg)                  #line 493#line 494#line 495#line 496

def string_constant_instantiate (reg,owner,name,template_data):#line 497
    global root_project                                     #line 498
    global root_0D                                          #line 499
    name_with_id = gensymbol ( "strconst")                  #line 500
    s =  template_data                                      #line 501
    if  root_project!= "":                                  #line 502
        s = re.sub ( "_00_",  root_project,  s)             #line 503#line 504
    if  root_0D!= "":                                       #line 505
        s = re.sub ( "_0D_",  root_0D,  s)                  #line 506#line 507
    return make_leaf ( name_with_id, owner, s, string_constant_handler)#line 508#line 509#line 510

def string_constant_handler (eh,msg):                       #line 511
    s =  eh.instance_data                                   #line 512
    send_string ( eh, "", s, msg)                           #line 513#line 514#line 515

def string_make_persistent (s):                             #line 516
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 517
    return  s                                               #line 518#line 519#line 520

def string_clone (s):                                       #line 521
    return  s                                               #line 522#line 523#line 524

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...#line 525
# where ${_00_} is the root directory for the project       #line 526
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)#line 527#line 528
def initialize_component_palette (root_project,root_0D,diagram_source_files):#line 529
    reg = make_component_registry ()                        #line 530
    for diagram_source in  diagram_source_files:            #line 531
        all_containers_within_single_file = json2internal ( root_project, diagram_source)#line 532
        reg = generate_shell_components ( reg, all_containers_within_single_file)#line 533
        for container in  all_containers_within_single_file:#line 534
            register_component ( reg,Template ( container [ "name"], container, container_instantiator))#line 535#line 536#line 537
    print ( reg)                                            #line 538
    reg = initialize_stock_components ( reg)                #line 539
    return  reg                                             #line 540#line 541#line 542

def print_error_maybe (main_container):                     #line 543
    error_port =  "✗"                                       #line 544
    err = fetch_first_output ( main_container, error_port)  #line 545
    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):#line 546
        print ( "___ !!! ERRORS !!! ___")                   #line 547
        print_specific_output ( main_container, error_port) #line 548#line 549#line 550

# debugging helpers                                         #line 551#line 552
def nl ():                                                  #line 553
    print ( "")                                             #line 554#line 555#line 556

def dump_outputs (main_container):                          #line 557
    nl ()                                                   #line 558
    print ( "___ Outputs ___")                              #line 559
    print_output_list ( main_container)                     #line 560#line 561#line 562

def trimws (s):                                             #line 563
    # remove whitespace from front and back of string       #line 564
    return  s.strip ()                                      #line 565#line 566#line 567

def clone_string (s):                                       #line 568
    return  s                                               #line 569#line 570#line 571

load_errors =  False                                        #line 572
runtime_errors =  False                                     #line 573#line 574
def load_error (s):                                         #line 575
    global load_errors                                      #line 576
    print ( s)                                              #line 577
    print ()                                                #line 578
    load_errors =  True                                     #line 579#line 580#line 581

def runtime_error (s):                                      #line 582
    global runtime_errors                                   #line 583
    print ( s)                                              #line 584
    runtime_errors =  True                                  #line 585#line 586#line 587

def fakepipename_instantiate (reg,owner,name,template_data):#line 588
    instance_name = gensymbol ( "fakepipe")                 #line 589
    return make_leaf ( instance_name, owner, None, fakepipename_handler)#line 590#line 591#line 592

rand =  0                                                   #line 593#line 594
def fakepipename_handler (eh,msg):                          #line 595
    global rand                                             #line 596
    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 597
    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)#line 598#line 599#line 600
                                                            #line 601
# all of the the built_in leaves are listed here            #line 602
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 603#line 604
def initialize_stock_components (reg):                      #line 605
    register_component ( reg,Template ( "1then2", None, deracer_instantiate))#line 606
    register_component ( reg,Template ( "?", None, probe_instantiate))#line 607
    register_component ( reg,Template ( "?A", None, probeA_instantiate))#line 608
    register_component ( reg,Template ( "?B", None, probeB_instantiate))#line 609
    register_component ( reg,Template ( "?C", None, probeC_instantiate))#line 610
    register_component ( reg,Template ( "trash", None, trash_instantiate))#line 611#line 612
    register_component ( reg,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 613
    register_component ( reg,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 614#line 615
    register_component ( reg,Template ( "syncfilewrite", None, syncfilewrite_instantiate))#line 616
    register_component ( reg,Template ( "stringconcat", None, stringconcat_instantiate))#line 617
    # for fakepipe                                          #line 618
    register_component ( reg,Template ( "fakepipename", None, fakepipename_instantiate))#line 619#line 620#line 621

def argv ():                                                #line 622
    sys.argv                                                #line 623#line 624#line 625

def initialize ():                                          #line 626
    root_of_project =  sys.argv[ 1]                         #line 627
    root_of_0D =  sys.argv[ 2]                              #line 628
    arg =  sys.argv[ 3]                                     #line 629
    main_container_name =  sys.argv[ 4]                     #line 630
    diagram_names =  sys.argv[ 5:]                          #line 631
    palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)#line 632
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 633#line 634#line 635

def start (palette,env):
    start_helper ( palette, env, False)                     #line 636

def start_show_all (palette,env):
    start_helper ( palette, env, True)                      #line 637

def start_helper (palette,env,show_all_outputs):            #line 638
    root_of_project =  env [ 0]                             #line 639
    root_of_0D =  env [ 1]                                  #line 640
    main_container_name =  env [ 2]                         #line 641
    diagram_names =  env [ 3]                               #line 642
    arg =  env [ 4]                                         #line 643
    set_environment ( root_of_project, root_of_0D)          #line 644
    # get entrypoint container                              #line 645
    main_container = get_component_instance ( palette, main_container_name, None)#line 646
    if  None ==  main_container:                            #line 647
        load_error ( str( "Couldn't find container with page name /") +  str( main_container_name) +  str( "/ in files ") +  str(str ( diagram_names)) +  " (check tab names, or disable compression?)"    )#line 651#line 652
    if not  load_errors:                                    #line 653
        arg = new_datum_string ( arg)                       #line 654
        msg = make_message ( "", arg)                       #line 655
        inject ( main_container, msg)                       #line 656
        if  show_all_outputs:                               #line 657
            dump_outputs ( main_container)                  #line 658
        else:                                               #line 659
            print_error_maybe ( main_container)             #line 660
            outp = fetch_first_output ( main_container, "") #line 661
            if  None ==  outp:                              #line 662
                print ( "(no outputs)")                     #line 663
            else:                                           #line 664
                print_specific_output ( main_container, "") #line 665#line 666#line 667
        if  show_all_outputs:                               #line 668
            print ( "--- done ---")                         #line 669#line 670#line 671#line 672#line 673
                                                            #line 674#line 675
# utility functions                                         #line 676
def send_int (eh,port,i,causing_message):                   #line 677
    datum = new_datum_int ( i)                              #line 678
    send ( eh, port, datum, causing_message)                #line 679#line 680#line 681

def send_bang (eh,port,causing_message):                    #line 682
    datum = new_datum_bang ()                               #line 683
    send ( eh, port, datum, causing_message)                #line 684#line 685#line 686





