

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





