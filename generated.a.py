

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





