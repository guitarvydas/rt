

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





