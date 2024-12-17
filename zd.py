

import sys
import re
import subprocess
import shlex
import os
import json
from collections import deque
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
    newd = new_datum_string ( d.data)                       #line 51
    return  newd                                            #line 52#line 53#line 54

def reclaim_datum_string (src):                             #line 55
    pass                                                    #line 56#line 57#line 58

def srepr_datum_string (d):                                 #line 59
    return  d.data                                          #line 60#line 61#line 62

def new_datum_bang ():                                      #line 63
    p =  Datum ()                                           #line 64
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
    p =  Datum ()                                           #line 108
    p.data =  b                                             #line 109
    p.clone =  lambda : clone_datum_bytes ( p)              #line 110
    p.reclaim =  lambda : reclaim_datum_bytes ( p)          #line 111
    p.srepr =  lambda : srepr_datum_bytes ( b)              #line 112
    p.raw =  lambda : raw_datum_bytes ( b)                  #line 113
    p.kind =  lambda :  "bytes"                             #line 114
    return  p                                               #line 115#line 116#line 117

def clone_datum_bytes (src):                                #line 118
    p =  Datum ()                                           #line 119
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
    p =  Datum ()                                           #line 145
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
        return  str( m.port) +  str( ":") +  str( m.datum.srepr ()) +  ","   #line 224#line 225#line 226#line 227

enumDown =  0                                               #line 228
enumAcross =  1                                             #line 229
enumUp =  2                                                 #line 230
enumThrough =  3                                            #line 231#line 232
def create_down_connector (container,proto_conn,connectors,children_by_id):#line 233
    # JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 234
    connector =  Connector ()                               #line 235
    connector.direction =  "down"                           #line 236
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])#line 237
    target_proto =  proto_conn [ "target"]                  #line 238
    id_proto =  target_proto [ "id"]                        #line 239
    target_component =  children_by_id [id_proto]           #line 240
    if ( target_component ==  None):                        #line 241
        load_error ( str( "internal error: .Down connection target internal error ") + ( proto_conn [ "target"]) [ "name"] )#line 242
    else:                                                   #line 243
        connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)#line 244#line 245
    return  connector                                       #line 246#line 247#line 248

def create_across_connector (container,proto_conn,connectors,children_by_id):#line 249
    connector =  Connector ()                               #line 250
    connector.direction =  "across"                         #line 251
    source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])]#line 252
    target_component =  children_by_id [(( proto_conn [ "target"]) [ "id"])]#line 253
    if  source_component ==  None:                          #line 254
        load_error ( str( "internal error: .Across connection source not ok ") + ( proto_conn [ "source"]) [ "name"] )#line 255
    else:                                                   #line 256
        connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])#line 257
        if  target_component ==  None:                      #line 258
            load_error ( str( "internal error: .Across connection target not ok ") + ( proto_conn [ "target"]) [ "name"] )#line 259
        else:                                               #line 260
            connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)#line 261#line 262#line 263
    return  connector                                       #line 264#line 265#line 266

def create_up_connector (container,proto_conn,connectors,children_by_id):#line 267
    connector =  Connector ()                               #line 268
    connector.direction =  "up"                             #line 269
    source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])]#line 270
    if  source_component ==  None:                          #line 271
        print ( str( "internal error: .Up connection source not ok ") + ( proto_conn [ "source"]) [ "name"] )#line 272
    else:                                                   #line 273
        connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])#line 274
        connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)#line 275#line 276
    return  connector                                       #line 277#line 278#line 279

def create_through_connector (container,proto_conn,connectors,children_by_id):#line 280
    connector =  Connector ()                               #line 281
    connector.direction =  "through"                        #line 282
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])#line 283
    connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)#line 284
    return  connector                                       #line 285#line 286#line 287
                                                            #line 288
def container_instantiator (reg,owner,container_name,desc): #line 289
    global enumDown, enumUp, enumAcross, enumThrough        #line 290
    container = make_container ( container_name, owner)     #line 291
    children = []                                           #line 292
    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here#line 293
    # collect children                                      #line 294
    for child_desc in  desc [ "children"]:                  #line 295
        child_instance = get_component_instance ( reg, child_desc [ "name"], container)#line 296
        children.append ( child_instance)                   #line 297
        id =  child_desc [ "id"]                            #line 298
        children_by_id [id] =  child_instance               #line 299#line 300#line 301
    container.children =  children                          #line 302#line 303
    connectors = []                                         #line 304
    for proto_conn in  desc [ "connections"]:               #line 305
        connector =  Connector ()                           #line 306
        if  proto_conn [ "dir"] ==  enumDown:               #line 307
            connectors.append (create_down_connector ( container, proto_conn, connectors, children_by_id)) #line 308
        elif  proto_conn [ "dir"] ==  enumAcross:           #line 309
            connectors.append (create_across_connector ( container, proto_conn, connectors, children_by_id)) #line 310
        elif  proto_conn [ "dir"] ==  enumUp:               #line 311
            connectors.append (create_up_connector ( container, proto_conn, connectors, children_by_id)) #line 312
        elif  proto_conn [ "dir"] ==  enumThrough:          #line 313
            connectors.append (create_through_connector ( container, proto_conn, connectors, children_by_id)) #line 314#line 315#line 316
    container.connections =  connectors                     #line 317
    return  container                                       #line 318#line 319#line 320

# The default handler for container components.             #line 321
def container_handler (container,message):                  #line 322
    route ( container, container, message)
    # references to 'self' are replaced by the container during instantiation#line 323
    while any_child_ready ( container):                     #line 324
        step_children ( container, message)                 #line 325#line 326#line 327

# Frees the given container and associated data.            #line 328
def destroy_container (eh):                                 #line 329
    pass                                                    #line 330#line 331#line 332

# Routing connection for a container component. The `direction` field has#line 333
# no affect on the default message routing system _ it is there for debugging#line 334
# purposes, or for reading by other tools.                  #line 335#line 336
class Connector:
    def __init__ (self,):                                   #line 337
        self.direction =  None # down, across, up, through  #line 338
        self.sender =  None                                 #line 339
        self.receiver =  None                               #line 340#line 341
                                                            #line 342
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,#line 343
# based on component ID (pointer) and port name.            #line 344#line 345
class Sender:
    def __init__ (self,):                                   #line 346
        self.name =  None                                   #line 347
        self.component =  None                              #line 348
        self.port =  None                                   #line 349#line 350
                                                            #line 351#line 352#line 353
# `Receiver` is a handle to a destination queue, and a `port` name to assign#line 354
# to incoming messages to this queue.                       #line 355#line 356
class Receiver:
    def __init__ (self,):                                   #line 357
        self.name =  None                                   #line 358
        self.queue =  None                                  #line 359
        self.port =  None                                   #line 360
        self.component =  None                              #line 361#line 362
                                                            #line 363
def mkSender (name,component,port):                         #line 364
    s =  Sender ()                                          #line 365
    s.name =  name                                          #line 366
    s.component =  component                                #line 367
    s.port =  port                                          #line 368
    return  s                                               #line 369#line 370#line 371

def mkReceiver (name,component,port,q):                     #line 372
    r =  Receiver ()                                        #line 373
    r.name =  name                                          #line 374
    r.component =  component                                #line 375
    r.port =  port                                          #line 376
    # We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq.#line 377
    r.queue =  q                                            #line 378
    return  r                                               #line 379#line 380#line 381

# Checks if two senders match, by pointer equality and port name matching.#line 382
def sender_eq (s1,s2):                                      #line 383
    same_components = ( s1.component ==  s2.component)      #line 384
    same_ports = ( s1.port ==  s2.port)                     #line 385
    return  same_components and  same_ports                 #line 386#line 387#line 388

# Delivers the given message to the receiver of this connector.#line 389#line 390
def deposit (parent,conn,message):                          #line 391
    new_message = make_message ( conn.receiver.port, message.datum)#line 392
    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)#line 393#line 394#line 395

def force_tick (parent,eh):                                 #line 396
    tick_msg = make_message ( ".",new_datum_tick ())        #line 397
    push_message ( parent, eh, eh.inq, tick_msg)            #line 398
    return  tick_msg                                        #line 399#line 400#line 401

def push_message (parent,receiver,inq,m):                   #line 402
    inq.append ( m)                                         #line 403
    parent.visit_ordering.append ( receiver)                #line 404#line 405#line 406

def is_self (child,container):                              #line 407
    # in an earlier version “self“ was denoted as ϕ         #line 408
    return  child ==  container                             #line 409#line 410#line 411

def step_child (child,msg):                                 #line 412
    before_state =  child.state                             #line 413
    child.handler ( child, msg)                             #line 414
    after_state =  child.state                              #line 415
    return [ before_state ==  "idle" and  after_state!= "idle", before_state!= "idle" and  after_state!= "idle", before_state!= "idle" and  after_state ==  "idle"]#line 418#line 419#line 420

def step_children (container,causingMessage):               #line 421
    container.state =  "idle"                               #line 422
    for child in  list ( container.visit_ordering):         #line 423
        # child = container represents self, skip it        #line 424
        if (not (is_self ( child, container))):             #line 425
            if (not ((0==len( child.inq)))):                #line 426
                msg =  child.inq.popleft ()                 #line 427
                began_long_run =  None                      #line 428
                continued_long_run =  None                  #line 429
                ended_long_run =  None                      #line 430
                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 431
                if  began_long_run:                         #line 432
                    pass                                    #line 433
                elif  continued_long_run:                   #line 434
                    pass                                    #line 435
                elif  ended_long_run:                       #line 436
                    pass                                    #line 437#line 438
                destroy_message ( msg)                      #line 439
            else:                                           #line 440
                if  child.state!= "idle":                   #line 441
                    msg = force_tick ( container, child)    #line 442
                    child.handler ( child, msg)             #line 443
                    destroy_message ( msg)                  #line 444#line 445
            if  child.state ==  "active":                   #line 446
                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 447
                container.state =  "active"                 #line 448#line 449
            while (not ((0==len( child.outq)))):            #line 450
                msg =  child.outq.popleft ()                #line 451
                route ( container, child, msg)              #line 452
                destroy_message ( msg)                      #line 453#line 454#line 455#line 456#line 457

def attempt_tick (parent,eh):                               #line 458
    if  eh.state!= "idle":                                  #line 459
        force_tick ( parent, eh)                            #line 460#line 461#line 462

def is_tick (msg):                                          #line 463
    return  "tick" ==  msg.datum.kind ()                    #line 464#line 465#line 466

# Routes a single message to all matching destinations, according to#line 467
# the container's connection network.                       #line 468#line 469
def route (container,from_component,message):               #line 470
    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)#line 471
    fromname =  ""                                          #line 472
    if is_tick ( message):                                  #line 473
        for child in  container.children:                   #line 474
            attempt_tick ( container, child)                #line 475
        was_sent =  True                                    #line 476
    else:                                                   #line 477
        if (not (is_self ( from_component, container))):    #line 478
            fromname =  from_component.name                 #line 479
        from_sender = mkSender ( fromname, from_component, message.port)#line 480#line 481
        for connector in  container.connections:            #line 482
            if sender_eq ( from_sender, connector.sender):  #line 483
                deposit ( container, connector, message)    #line 484
                was_sent =  True                            #line 485
    if not ( was_sent):                                     #line 486
        print ( "\n\n*** Error: ***")                       #line 487
        print ( "***")                                      #line 488
        print ( str( container.name) +  str( ": message '") +  str( message.port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 489
        print ( "***")                                      #line 490
        exit ()                                             #line 491#line 492#line 493#line 494

def any_child_ready (container):                            #line 495
    for child in  container.children:                       #line 496
        if child_is_ready ( child):                         #line 497
            return  True                                    #line 498
    return  False                                           #line 499#line 500#line 501

def child_is_ready (eh):                                    #line 502
    return (not ((0==len( eh.outq)))) or (not ((0==len( eh.inq)))) or ( eh.state!= "idle") or (any_child_ready ( eh))#line 503#line 504#line 505

def append_routing_descriptor (container,desc):             #line 506
    container.routings.append ( desc)                       #line 507#line 508#line 509

def container_injector (container,message):                 #line 510
    container_handler ( container, message)                 #line 511#line 512#line 513






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
            # loop through every component in the diagram and look for names that start with “$“ or “'“ #line 101
            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 102
            for child_descriptor in  diagram [ "children"]: #line 103
                if first_char_is ( child_descriptor [ "name"], "$"):#line 104
                    name =  child_descriptor [ "name"]      #line 105
                    cmd =   name[1:] .strip ()              #line 106
                    generated_leaf = mkTemplate ( name, cmd, shell_out_instantiate)#line 107
                    register_component ( reg, generated_leaf)#line 108
                elif first_char_is ( child_descriptor [ "name"], "'"):#line 109
                    name =  child_descriptor [ "name"]      #line 110
                    s =   name[1:]                          #line 111
                    generated_leaf = mkTemplate ( name, s, string_constant_instantiate)#line 112
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
    print ( "{")                                            #line 226
    for m in  list ( eh.outq):                              #line 227
        print (format_message ( m))                         #line 228#line 229
    print ( "}")                                            #line 230#line 231#line 232

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
    for msg in  list ( eh.outq):                            #line 251
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
    eh.outq.append ( msg)                                   #line 270#line 271#line 272

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
    def __init__ (self,):                                   #line 316
        self.firstmsg =  None                               #line 317
        self.secondmsg =  None                              #line 318#line 319
                                                            #line 320
# Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg }#line 321
class Deracer_Instance_Data:
    def __init__ (self,):                                   #line 322
        self.state =  None                                  #line 323
        self.buffer =  None                                 #line 324#line 325
                                                            #line 326
def reclaim_Buffers_from_heap (inst):                       #line 327
    pass                                                    #line 328#line 329#line 330

def deracer_instantiate (reg,owner,name,template_data):     #line 331
    name_with_id = gensymbol ( "deracer")                   #line 332
    inst =  Deracer_Instance_Data ()                        #line 333
    inst.state =  "idle"                                    #line 334
    inst.buffer =  TwoMessages ()                           #line 335
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 336
    return  eh                                              #line 337#line 338#line 339

def send_firstmsg_then_secondmsg (eh,inst):                 #line 340
    forward ( eh, "1", inst.buffer.firstmsg)                #line 341
    forward ( eh, "2", inst.buffer.secondmsg)               #line 342
    reclaim_Buffers_from_heap ( inst)                       #line 343#line 344#line 345

def deracer_handler (eh,msg):                               #line 346
    inst =  eh.instance_data                                #line 347
    if  inst.state ==  "idle":                              #line 348
        if  "1" ==  msg.port:                               #line 349
            inst.buffer.firstmsg =  msg                     #line 350
            inst.state =  "waitingForSecondmsg"             #line 351
        elif  "2" ==  msg.port:                             #line 352
            inst.buffer.secondmsg =  msg                    #line 353
            inst.state =  "waitingForFirstmsg"              #line 354
        else:                                               #line 355
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 356
    elif  inst.state ==  "waitingForFirstmsg":              #line 357
        if  "1" ==  msg.port:                               #line 358
            inst.buffer.firstmsg =  msg                     #line 359
            send_firstmsg_then_secondmsg ( eh, inst)        #line 360
            inst.state =  "idle"                            #line 361
        else:                                               #line 362
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 363
    elif  inst.state ==  "waitingForSecondmsg":             #line 364
        if  "2" ==  msg.port:                               #line 365
            inst.buffer.secondmsg =  msg                    #line 366
            send_firstmsg_then_secondmsg ( eh, inst)        #line 367
            inst.state =  "idle"                            #line 368
        else:                                               #line 369
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg.port )#line 370
    else:                                                   #line 371
        runtime_error ( "bad state for deracer {eh.state}") #line 372#line 373#line 374

def low_level_read_text_file_instantiate (reg,owner,name,template_data):#line 375
    name_with_id = gensymbol ( "Low Level Read Text File")  #line 376
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 377#line 378#line 379

def low_level_read_text_file_handler (eh,msg):              #line 380
    fname =  msg.datum.srepr ()                             #line 381

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
                                                            #line 382#line 383#line 384

def ensure_string_datum_instantiate (reg,owner,name,template_data):#line 385
    name_with_id = gensymbol ( "Ensure String Datum")       #line 386
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)#line 387#line 388#line 389

def ensure_string_datum_handler (eh,msg):                   #line 390
    if  "string" ==  msg.datum.kind ():                     #line 391
        forward ( eh, "", msg)                              #line 392
    else:                                                   #line 393
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum #line 394
        send_string ( eh, "✗", emsg, msg)                   #line 395#line 396#line 397

class Syncfilewrite_Data:
    def __init__ (self,):                                   #line 398
        self.filename =  ""                                 #line 399#line 400
                                                            #line 401
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)#line 402
def syncfilewrite_instantiate (reg,owner,name,template_data):#line 403
    name_with_id = gensymbol ( "syncfilewrite")             #line 404
    inst =  Syncfilewrite_Data ()                           #line 405
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)#line 406#line 407#line 408

def syncfilewrite_handler (eh,msg):                         #line 409
    inst =  eh.instance_data                                #line 410
    if  "filename" ==  msg.port:                            #line 411
        inst.filename =  msg.datum.srepr ()                 #line 412
    elif  "input" ==  msg.port:                             #line 413
        contents =  msg.datum.srepr ()                      #line 414
        f = open ( inst.filename, "w")                      #line 415
        if  f!= None:                                       #line 416
            f.write ( msg.datum.srepr ())                   #line 417
            f.close ()                                      #line 418
            send ( eh, "done",new_datum_bang (), msg)       #line 419
        else:                                               #line 420
            send_string ( eh, "✗", str( "open error on file ") +  inst.filename , msg)#line 421#line 422#line 423

class StringConcat_Instance_Data:
    def __init__ (self,):                                   #line 424
        self.buffer1 =  None                                #line 425
        self.buffer2 =  None                                #line 426
        self.scount =  0                                    #line 427#line 428
                                                            #line 429
def stringconcat_instantiate (reg,owner,name,template_data):#line 430
    name_with_id = gensymbol ( "stringconcat")              #line 431
    instp =  StringConcat_Instance_Data ()                  #line 432
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 433#line 434#line 435

def stringconcat_handler (eh,msg):                          #line 436
    inst =  eh.instance_data                                #line 437
    if  "1" ==  msg.port:                                   #line 438
        inst.buffer1 = clone_string ( msg.datum.srepr ())   #line 439
        inst.scount =  inst.scount+ 1                       #line 440
        maybe_stringconcat ( eh, inst, msg)                 #line 441
    elif  "2" ==  msg.port:                                 #line 442
        inst.buffer2 = clone_string ( msg.datum.srepr ())   #line 443
        inst.scount =  inst.scount+ 1                       #line 444
        maybe_stringconcat ( eh, inst, msg)                 #line 445
    else:                                                   #line 446
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 447#line 448#line 449#line 450

def maybe_stringconcat (eh,inst,msg):                       #line 451
    if ( 0 == len ( inst.buffer1)) and ( 0 == len ( inst.buffer2)):#line 452
        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 453
    if  inst.scount >=  2:                                  #line 454
        concatenated_string =  ""                           #line 455
        if  0 == len ( inst.buffer1):                       #line 456
            concatenated_string =  inst.buffer2             #line 457
        elif  0 == len ( inst.buffer2):                     #line 458
            concatenated_string =  inst.buffer1             #line 459
        else:                                               #line 460
            concatenated_string =  inst.buffer1+ inst.buffer2#line 461
        send_string ( eh, "", concatenated_string, msg)     #line 462
        inst.buffer1 =  None                                #line 463
        inst.buffer2 =  None                                #line 464
        inst.scount =  0                                    #line 465#line 466#line 467

#                                                           #line 468#line 469
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 470
def shell_out_instantiate (reg,owner,name,template_data):   #line 471
    name_with_id = gensymbol ( "shell_out")                 #line 472
    cmd = shlex.split ( template_data)                      #line 473
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)#line 474#line 475#line 476

def shell_out_handler (eh,msg):                             #line 477
    cmd =  eh.instance_data                                 #line 478
    s =  msg.datum.srepr ()                                 #line 479
    ret =  None                                             #line 480
    rc =  None                                              #line 481
    stdout =  None                                          #line 482
    stderr =  None                                          #line 483

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
                                                            #line 484
    if  rc!= 0:                                             #line 485
        send_string ( eh, "✗", stderr, msg)                 #line 486
    else:                                                   #line 487
        send_string ( eh, "", stdout, msg)                  #line 488#line 489#line 490#line 491

def string_constant_instantiate (reg,owner,name,template_data):#line 492
    global root_project                                     #line 493
    global root_0D                                          #line 494
    name_with_id = gensymbol ( "strconst")                  #line 495
    s =  template_data                                      #line 496
    if  root_project!= "":                                  #line 497
        s = re.sub ( "_00_",  root_project,  s)             #line 498#line 499
    if  root_0D!= "":                                       #line 500
        s = re.sub ( "_0D_",  root_0D,  s)                  #line 501#line 502
    return make_leaf ( name_with_id, owner, s, string_constant_handler)#line 503#line 504#line 505

def string_constant_handler (eh,msg):                       #line 506
    s =  eh.instance_data                                   #line 507
    send_string ( eh, "", s, msg)                           #line 508#line 509#line 510

def string_make_persistent (s):                             #line 511
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 512
    return  s                                               #line 513#line 514#line 515

def string_clone (s):                                       #line 516
    return  s                                               #line 517#line 518#line 519

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...#line 520
# where ${_00_} is the root directory for the project       #line 521
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)#line 522#line 523
def initialize_component_palette (root_project,root_0D,diagram_source_files):#line 524
    reg = make_component_registry ()                        #line 525
    for diagram_source in  diagram_source_files:            #line 526
        all_containers_within_single_file = json2internal ( root_project, diagram_source)#line 527
        reg = generate_shell_components ( reg, all_containers_within_single_file)#line 528
        for container in  all_containers_within_single_file:#line 529
            register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))#line 530#line 531#line 532
    initialize_stock_components ( reg)                      #line 533
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
    register_component ( reg,mkTemplate ( "1then2", None, deracer_instantiate))#line 600
    register_component ( reg,mkTemplate ( "?", None, probe_instantiate))#line 601
    register_component ( reg,mkTemplate ( "?A", None, probeA_instantiate))#line 602
    register_component ( reg,mkTemplate ( "?B", None, probeB_instantiate))#line 603
    register_component ( reg,mkTemplate ( "?C", None, probeC_instantiate))#line 604
    register_component ( reg,mkTemplate ( "trash", None, trash_instantiate))#line 605#line 606
    register_component ( reg,mkTemplate ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 607
    register_component ( reg,mkTemplate ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 608#line 609
    register_component ( reg,mkTemplate ( "syncfilewrite", None, syncfilewrite_instantiate))#line 610
    register_component ( reg,mkTemplate ( "stringconcat", None, stringconcat_instantiate))#line 611
    # for fakepipe                                          #line 612
    register_component ( reg,mkTemplate ( "fakepipename", None, fakepipename_instantiate))#line 613#line 614#line 615

def argv ():                                                #line 616
    return  sys.argv                                        #line 617#line 618#line 619

def initialize ():                                          #line 620
    root_of_project =  sys.argv[ 1]                         #line 621
    root_of_0D =  sys.argv[ 2]                              #line 622
    arg =  sys.argv[ 3]                                     #line 623
    main_container_name =  sys.argv[ 4]                     #line 624
    diagram_names =  sys.argv[ 5:]                          #line 625
    palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)#line 626
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 627#line 628#line 629

def start (palette,env):
    start_helper ( palette, env, False)                     #line 630

def start_show_all (palette,env):
    start_helper ( palette, env, True)                      #line 631

def start_helper (palette,env,show_all_outputs):            #line 632
    root_of_project =  env [ 0]                             #line 633
    root_of_0D =  env [ 1]                                  #line 634
    main_container_name =  env [ 2]                         #line 635
    diagram_names =  env [ 3]                               #line 636
    arg =  env [ 4]                                         #line 637
    set_environment ( root_of_project, root_of_0D)          #line 638
    # get entrypoint container                              #line 639
    main_container = get_component_instance ( palette, main_container_name, None)#line 640
    if  None ==  main_container:                            #line 641
        load_error ( str( "Couldn't find container with page name /") +  str( main_container_name) +  str( "/ in files ") +  str(str ( diagram_names)) +  " (check tab names, or disable compression?)"    )#line 645#line 646
    if not  load_errors:                                    #line 647
        marg = new_datum_string ( arg)                      #line 648
        msg = make_message ( "", marg)                      #line 649
        inject ( main_container, msg)                       #line 650
        if  show_all_outputs:                               #line 651
            dump_outputs ( main_container)                  #line 652
        else:                                               #line 653
            print_error_maybe ( main_container)             #line 654
            outp = fetch_first_output ( main_container, "") #line 655
            if  None ==  outp:                              #line 656
                print ( "(no outputs)")                     #line 657
            else:                                           #line 658
                print_specific_output ( main_container, "") #line 659#line 660#line 661
        if  show_all_outputs:                               #line 662
            print ( "--- done ---")                         #line 663#line 664#line 665#line 666#line 667
                                                            #line 668#line 669
# utility functions                                         #line 670
def send_int (eh,port,i,causing_message):                   #line 671
    datum = new_datum_int ( i)                              #line 672
    send ( eh, port, datum, causing_message)                #line 673#line 674#line 675

def send_bang (eh,port,causing_message):                    #line 676
    datum = new_datum_bang ()                               #line 677
    send ( eh, port, datum, causing_message)                #line 678#line 679#line 680





