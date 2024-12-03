

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
                connectors.append ( connector)              #line 263#line 264#line 265
        elif  proto_conn [ "dir"] ==  enumAcross:           #line 266
            connector.direction =  "across"                 #line 267
            source_component =  children_by_id [ proto_conn [ "source" [ "id"]]]#line 268
            target_component =  children_by_id [ proto_conn [ "target" [ "id"]]]#line 269
            if  source_component ==  None:                  #line 270
                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn [ "source"] )#line 271
            else:                                           #line 272
                connector.sender = Sender ( source_component.name, source_component, proto_conn [ "source_port"])#line 273
                if  target_component ==  None:              #line 274
                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn.target )#line 275
                else:                                       #line 276
                    connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn [ "target_port"], target_component)#line 277
                    connectors.append ( connector)          #line 278
        elif  proto_conn [ "dir"] ==  enumUp:               #line 279
            connector.direction =  "up"                     #line 280
            source_component =  children_by_id [ proto_conn [ "source" [ "id"]]]#line 281
            if  source_component ==  None:                  #line 282
                print ( str( "internal error: .Up connection source not ok ") +  proto_conn [ "source"] )#line 283
            else:                                           #line 284
                connector.sender = Sender ( source_component.name, source_component, proto_conn [ "source_port"])#line 285
                connector.receiver = Receiver ( me.name, container.outq, proto_conn [ "target_port"], me)#line 286
                connectors.append ( connector)              #line 287
        elif  proto_conn [ "dir"] ==  enumThrough:          #line 288
            connector.direction =  "through"                #line 289
            connector.sender = Sender ( me.name, me, proto_conn [ "source_port"])#line 290
            connector.receiver = Receiver ( me.name, container.outq, proto_conn [ "target_port"], me)#line 291
            connectors.append ( connector)                  #line 292#line 293
    container.connections =  connectors                     #line 294
    return  container                                       #line 295#line 296#line 297

# The default handler for container components.             #line 298
def container_handler (container,message):                  #line 299
    route ( container, container, message)
    # references to 'self' are replaced by the container during instantiation#line 300
    while any_child_ready ( container):                     #line 301
        step_children ( container, message)                 #line 302#line 303#line 304

# Frees the given container and associated data.            #line 305
def destroy_container (eh):                                 #line 306
    pass                                                    #line 307#line 308#line 309

def fifo_is_empty (fifo):                                   #line 310
    return  fifo.empty ()                                   #line 311#line 312#line 313

# Routing connection for a container component. The `direction` field has#line 314
# no affect on the default message routing system _ it is there for debugging#line 315
# purposes, or for reading by other tools.                  #line 316#line 317
class Connector:
    def __init__ (self,):                                   #line 318
        self.direction =  None # down, across, up, through  #line 319
        self.sender =  None                                 #line 320
        self.receiver =  None                               #line 321#line 322
                                                            #line 323
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,#line 324
# based on component ID (pointer) and port name.            #line 325#line 326
class Sender:
    def __init__ (self,name,component,port):                #line 327
        self.name =  name                                   #line 328
        self.component =  component # from                  #line 329
        self.port =  port # from's port                     #line 330#line 331
                                                            #line 332
# `Receiver` is a handle to a destination queue, and a `port` name to assign#line 333
# to incoming messages to this queue.                       #line 334#line 335
class Receiver:
    def __init__ (self,name,queue,port,component):          #line 336
        self.name =  name                                   #line 337
        self.queue =  queue # queue (input | output) of receiver#line 338
        self.port =  port # destination port                #line 339
        self.component =  component # to (for bootstrap debug)#line 340#line 341
                                                            #line 342
# Checks if two senders match, by pointer equality and port name matching.#line 343
def sender_eq (s1,s2):                                      #line 344
    same_components = ( s1.component ==  s2.component)      #line 345
    same_ports = ( s1.port ==  s2.port)                     #line 346
    return  same_components and  same_ports                 #line 347#line 348#line 349

# Delivers the given message to the receiver of this connector.#line 350#line 351
def deposit (parent,conn,message):                          #line 352
    new_message = make_message ( conn.receiver.port, message.datum)#line 353
    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)#line 354#line 355#line 356

def force_tick (parent,eh):                                 #line 357
    tick_msg = make_message ( ".",new_datum_tick ())        #line 358
    push_message ( parent, eh, eh.inq, tick_msg)            #line 359
    return  tick_msg                                        #line 360#line 361#line 362

def push_message (parent,receiver,inq,m):                   #line 363
    inq.put ( m)                                            #line 364
    parent.visit_ordering.put ( receiver)                   #line 365#line 366#line 367

def is_self (child,container):                              #line 368
    # in an earlier version “self“ was denoted as ϕ         #line 369
    return  child ==  container                             #line 370#line 371#line 372

def step_child (child,msg):                                 #line 373
    before_state =  child.state                             #line 374
    child.handler ( child, msg)                             #line 375
    after_state =  child.state                              #line 376
    return [ before_state ==  "idle" and  after_state!= "idle", before_state!= "idle" and  after_state!= "idle", before_state!= "idle" and  after_state ==  "idle"]#line 379#line 380#line 381

def save_message (eh,msg):                                  #line 382
    eh.saved_messages.put ( msg)                            #line 383#line 384#line 385

def fetch_saved_message_and_clear (eh):                     #line 386
    return  eh.saved_messages.get ()                        #line 387#line 388#line 389

def step_children (container,causingMessage):               #line 390
    container.state =  "idle"                               #line 391
    for child in list ( container.visit_ordering.queue):    #line 392
        # child = container represents self, skip it        #line 393
        if (not (is_self ( child, container))):             #line 394
            if (not ( child.inq.empty ())):                 #line 395
                msg =  child.inq.get ()                     #line 396
                began_long_run =  None                      #line 397
                continued_long_run =  None                  #line 398
                ended_long_run =  None                      #line 399
                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 400
                if  began_long_run:                         #line 401
                    save_message ( child, msg)              #line 402
                elif  continued_long_run:                   #line 403
                    pass                                    #line 404#line 405
                destroy_message ( msg)                      #line 406
            else:                                           #line 407
                if  child.state!= "idle":                   #line 408
                    msg = force_tick ( container, child)    #line 409
                    child.handler ( child, msg)             #line 410
                    destroy_message ( msg)                  #line 411#line 412
            if  child.state ==  "active":                   #line 413
                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 414
                container.state =  "active"                 #line 415#line 416
            while (not ( child.outq.empty ())):             #line 417
                msg =  child.outq.get ()                    #line 418
                route ( container, child, msg)              #line 419
                destroy_message ( msg)                      #line 420#line 421#line 422#line 423#line 424

def attempt_tick (parent,eh):                               #line 425
    if  eh.state!= "idle":                                  #line 426
        force_tick ( parent, eh)                            #line 427#line 428#line 429

def is_tick (msg):                                          #line 430
    return  "tick" ==  msg.datum.kind ()                    #line 431#line 432#line 433

# Routes a single message to all matching destinations, according to#line 434
# the container's connection network.                       #line 435#line 436
def route (container,from_component,message):               #line 437
    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)#line 438
    fromname =  ""                                          #line 439
    if is_tick ( message):                                  #line 440
        for child in  container.children:                   #line 441
            attempt_tick ( container, child)                #line 442
        was_sent =  True                                    #line 443
    else:                                                   #line 444
        if (not (is_self ( from_component, container))):    #line 445
            fromname =  from_component.name                 #line 446
        from_sender = Sender ( fromname, from_component, message.port)#line 447#line 448
        for connector in  container.connections:            #line 449
            if sender_eq ( from_sender, connector.sender):  #line 450
                deposit ( container, connector, message)    #line 451
                was_sent =  True                            #line 452
    if not ( was_sent):                                     #line 453
        print ( "\n\n*** Error: ***")                       #line 454
        print ( "***")                                      #line 455
        print ( str( container.name) +  str( ": message '") +  str( message.port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 456
        print ( "***")                                      #line 457
        exit ()                                             #line 458#line 459#line 460#line 461

def any_child_ready (container):                            #line 462
    for child in  container.children:                       #line 463
        if child_is_ready ( child):                         #line 464
            return  True                                    #line 465
    return  False                                           #line 466#line 467#line 468

def child_is_ready (eh):                                    #line 469
    return (not ( eh.outq.empty ())) or (not ( eh.inq.empty ())) or ( eh.state!= "idle") or (any_child_ready ( eh))#line 470#line 471#line 472

def append_routing_descriptor (container,desc):             #line 473
    container.routings.put ( desc)                          #line 474#line 475#line 476

def container_injector (container,message):                 #line 477
    container_handler ( container, message)                 #line 478#line 479#line 480





