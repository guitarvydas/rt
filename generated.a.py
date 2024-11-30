

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





