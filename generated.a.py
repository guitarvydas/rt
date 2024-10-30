

import sys
import re
import subprocess
import shlex
import os
import json
import queue
                                                                                #line 1#line 2
counter =  0                                                                    #line 3#line 4
digits = [ "₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀", "₂₁", "₂₂", "₂₃", "₂₄", "₂₅", "₂₆", "₂₇", "₂₈", "₂₉"]#line 11#line 12#line 13
def gensymbol (s):                                                              #line 14
    global counter                                                              #line 15
    name_with_id =  str( s) + subscripted_digit ( counter)                      #line 16
    counter =  counter+ 1                                                       #line 17
    return  name_with_id                                                        #line 18#line 19#line 20

def subscripted_digit (n):                                                      #line 21
    global digits                                                               #line 22
    if ( n >=  0 and  n <=  29):                                                #line 23
        return  digits [ n]                                                     #line 24
    else:                                                                       #line 25
        return  str( "₊") +  n                                                  #line 26#line 27#line 28#line 29

class Datum:
    def __init__ (self,):                                                       #line 30
        self.data =  None                                                       #line 31
        self.clone =  None                                                      #line 32
        self.reclaim =  None                                                    #line 33
        self.srepr =  None                                                      #line 34
        self.kind =  None                                                       #line 35
        self.raw =  None                                                        #line 36#line 37
                                                                                #line 38
def new_datum_string (s):                                                       #line 39
    d =  Datum ()                                                               #line 40
    d. data =  s                                                                #line 41
    d. clone =  lambda : clone_datum_string ( d)                                #line 42
    d. reclaim =  lambda : reclaim_datum_string ( d)                            #line 43
    d. srepr =  lambda : srepr_datum_string ( d)                                #line 44
    d. raw =  lambda : raw_datum_string ( d)                                    #line 45
    d. kind =  lambda :  "string"                                               #line 46
    return  d                                                                   #line 47#line 48#line 49

def clone_datum_string (d):                                                     #line 50
    d = new_datum_string ( d. data)                                             #line 51
    return  d                                                                   #line 52#line 53#line 54

def reclaim_datum_string (src):                                                 #line 55
    pass                                                                        #line 56#line 57#line 58

def srepr_datum_string (d):                                                     #line 59
    return  d. data                                                             #line 60#line 61#line 62

def raw_datum_string (d):                                                       #line 63
    return bytearray ( d. data, "UTF_8")                                        #line 64#line 65#line 66

def new_datum_bang ():                                                          #line 67
    p = Datum ()                                                                #line 68
    p. data =  True                                                             #line 69
    p. clone =  lambda : clone_datum_bang ( p)                                  #line 70
    p. reclaim =  lambda : reclaim_datum_bang ( p)                              #line 71
    p. srepr =  lambda : srepr_datum_bang ()                                    #line 72
    p. raw =  lambda : raw_datum_bang ()                                        #line 73
    p. kind =  lambda :  "bang"                                                 #line 74
    return  p                                                                   #line 75#line 76#line 77

def clone_datum_bang (d):                                                       #line 78
    return new_datum_bang ()                                                    #line 79#line 80#line 81

def reclaim_datum_bang (d):                                                     #line 82
    pass                                                                        #line 83#line 84#line 85

def srepr_datum_bang ():                                                        #line 86
    return  "!"                                                                 #line 87#line 88#line 89

def raw_datum_bang ():                                                          #line 90
    return []                                                                   #line 91#line 92#line 93

def new_datum_tick ():                                                          #line 94
    p = new_datum_bang ()                                                       #line 95
    p. kind =  lambda :  "tick"                                                 #line 96
    p. clone =  lambda : new_datum_tick ()                                      #line 97
    p. srepr =  lambda : srepr_datum_tick ()                                    #line 98
    p. raw =  lambda : raw_datum_tick ()                                        #line 99
    return  p                                                                   #line 100#line 101#line 102

def srepr_datum_tick ():                                                        #line 103
    return  "."                                                                 #line 104#line 105#line 106

def raw_datum_tick ():                                                          #line 107
    return []                                                                   #line 108#line 109#line 110

def new_datum_bytes (b):                                                        #line 111
    p = Datum ()                                                                #line 112
    p. data =  b                                                                #line 113
    p. clone =  lambda : clone_datum_bytes ( p)                                 #line 114
    p. reclaim =  lambda : reclaim_datum_bytes ( p)                             #line 115
    p. srepr =  lambda : srepr_datum_bytes ( b)                                 #line 116
    p. raw =  lambda : raw_datum_bytes ( b)                                     #line 117
    p. kind =  lambda :  "bytes"                                                #line 118
    return  p                                                                   #line 119#line 120#line 121

def clone_datum_bytes (src):                                                    #line 122
    p = Datum ()                                                                #line 123
    p. clone =  src. clone                                                      #line 124
    p. reclaim =  src. reclaim                                                  #line 125
    p. srepr =  src. srepr                                                      #line 126
    p. raw =  src. raw                                                          #line 127
    p. kind =  src. kind                                                        #line 128
    p. data =  src.clone ()                                                     #line 129
    return  p                                                                   #line 130#line 131#line 132

def reclaim_datum_bytes (src):                                                  #line 133
    pass                                                                        #line 134#line 135#line 136

def srepr_datum_bytes (d):                                                      #line 137
    return  d. data.decode ( "UTF_8")                                           #line 138#line 139

def raw_datum_bytes (d):                                                        #line 140
    return  d. data                                                             #line 141#line 142#line 143

def new_datum_handle (h):                                                       #line 144
    return new_datum_int ( h)                                                   #line 145#line 146#line 147

def new_datum_int (i):                                                          #line 148
    p = Datum ()                                                                #line 149
    p. data =  i                                                                #line 150
    p. clone =  lambda : clone_int ( i)                                         #line 151
    p. reclaim =  lambda : reclaim_int ( i)                                     #line 152
    p. srepr =  lambda : srepr_datum_int ( i)                                   #line 153
    p. raw =  lambda : raw_datum_int ( i)                                       #line 154
    p. kind =  lambda :  "int"                                                  #line 155
    return  p                                                                   #line 156#line 157#line 158

def clone_int (i):                                                              #line 159
    p = new_datum_int ( i)                                                      #line 160
    return  p                                                                   #line 161#line 162#line 163

def reclaim_int (src):                                                          #line 164
    pass                                                                        #line 165#line 166#line 167

def srepr_datum_int (i):                                                        #line 168
    return str ( i)                                                             #line 169#line 170#line 171

def raw_datum_int (i):                                                          #line 172
    return  i                                                                   #line 173#line 174#line 175

# Message passed to a leaf component.                                           #line 176
#                                                                               #line 177
# `port` refers to the name of the incoming or outgoing port of this component. #line 178
# `datum` is the data attached to this message.                                 #line 179
class Message:
    def __init__ (self,port,datum):                                             #line 180
        self.port =  port                                                       #line 181
        self.datum =  datum                                                     #line 182#line 183
                                                                                #line 184
def clone_port (s):                                                             #line 185
    return clone_string ( s)                                                    #line 186#line 187#line 188

# Utility for making a `Message`. Used to safely “seed“ messages                #line 189
# entering the very top of a network.                                           #line 190
def make_message (port,datum):                                                  #line 191
    p = clone_string ( port)                                                    #line 192
    m = Message ( p, datum.clone ())                                            #line 193
    return  m                                                                   #line 194#line 195#line 196

# Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations.#line 197
def message_clone (message):                                                    #line 198
    m = Message (clone_port ( message. port), message. datum.clone ())          #line 199
    return  m                                                                   #line 200#line 201#line 202

# Frees a message.                                                              #line 203
def destroy_message (msg):                                                      #line 204
    # during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages#line 205
    pass                                                                        #line 206#line 207#line 208

def destroy_datum (msg):                                                        #line 209
    pass                                                                        #line 210#line 211#line 212

def destroy_port (msg):                                                         #line 213
    pass                                                                        #line 214#line 215#line 216

#                                                                               #line 217
def format_message (m):                                                         #line 218
    if  m ==  None:                                                             #line 219
        return  "ϕ"                                                             #line 220
    else:                                                                       #line 221
        return  str( "⟪") +  str( m. port) +  str( "⦂") +  str( m. datum.srepr ()) +  "⟫"    #line 225#line 226#line 227#line 228
                                                                                #line 229
enumDown =  0                                                                   #line 230
enumAcross =  1                                                                 #line 231
enumUp =  2                                                                     #line 232
enumThrough =  3                                                                #line 233#line 234
def container_instantiator (reg,owner,container_name,desc):                     #line 235
    global enumDown, enumUp, enumAcross, enumThrough                            #line 236
    container = make_container ( container_name, owner)                         #line 237
    children = []                                                               #line 238
    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here#line 239
    # collect children                                                          #line 240
    for child_desc in  desc ["children"]:                                       #line 241
        child_instance = get_component_instance ( reg, child_desc ["name"], container)#line 242
        children.append ( child_instance)                                       #line 243
        children_by_id [ child_desc ["id"]] =  child_instance                   #line 244
    container. children =  children                                             #line 245
    me =  container                                                             #line 246#line 247
    connectors = []                                                             #line 248
    for proto_conn in  desc ["connections"]:                                    #line 249
        connector = Connector ()                                                #line 250
        if  proto_conn ["dir"] ==  enumDown:                                    #line 251
            # JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 252
            connector. direction =  "down"                                      #line 253
            connector. sender = Sender ( me. name, me, proto_conn ["source_port"])#line 254
            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 255
            if ( target_component ==  None):                                    #line 256
                load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn ["target"] )#line 257
            else:                                                               #line 258
                connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)#line 259
                connectors.append ( connector)                                  #line 260
        elif  proto_conn ["dir"] ==  enumAcross:                                #line 261
            connector. direction =  "across"                                    #line 262
            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 263
            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 264
            if  source_component ==  None:                                      #line 265
                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn ["source"] )#line 266
            else:                                                               #line 267
                connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])#line 268
                if  target_component ==  None:                                  #line 269
                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn. target )#line 270
                else:                                                           #line 271
                    connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)#line 272
                    connectors.append ( connector)                              #line 273
        elif  proto_conn ["dir"] ==  enumUp:                                    #line 274
            connector. direction =  "up"                                        #line 275
            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 276
            if  source_component ==  None:                                      #line 277
                print ( str( "internal error: .Up connection source not ok ") +  proto_conn ["source"] )#line 278
            else:                                                               #line 279
                connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])#line 280
                connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)#line 281
                connectors.append ( connector)                                  #line 282
        elif  proto_conn ["dir"] ==  enumThrough:                               #line 283
            connector. direction =  "through"                                   #line 284
            connector. sender = Sender ( me. name, me, proto_conn ["source_port"])#line 285
            connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)#line 286
            connectors.append ( connector)                                      #line 287#line 288
    container. connections =  connectors                                        #line 289
    return  container                                                           #line 290#line 291#line 292

# The default handler for container components.                                 #line 293
def container_handler (container,message):                                      #line 294
    route ( container, container, message)
    # references to 'self' are replaced by the container during instantiation   #line 295
    while any_child_ready ( container):                                         #line 296
        step_children ( container, message)                                     #line 297#line 298#line 299

# Frees the given container and associated data.                                #line 300
def destroy_container (eh):                                                     #line 301
    pass                                                                        #line 302#line 303#line 304

def fifo_is_empty (fifo):                                                       #line 305
    return  fifo.empty ()                                                       #line 306#line 307#line 308

# Routing connection for a container component. The `direction` field has       #line 309
# no affect on the default message routing system _ it is there for debugging   #line 310
# purposes, or for reading by other tools.                                      #line 311#line 312
class Connector:
    def __init__ (self,):                                                       #line 313
        self.direction =  None # down, across, up, through                      #line 314
        self.sender =  None                                                     #line 315
        self.receiver =  None                                                   #line 316#line 317
                                                                                #line 318
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,  #line 319
# based on component ID (pointer) and port name.                                #line 320#line 321
class Sender:
    def __init__ (self,name,component,port):                                    #line 322
        self.name =  name                                                       #line 323
        self.component =  component # from                                      #line 324
        self.port =  port # from's port                                         #line 325#line 326
                                                                                #line 327
# `Receiver` is a handle to a destination queue, and a `port` name to assign    #line 328
# to incoming messages to this queue.                                           #line 329#line 330
class Receiver:
    def __init__ (self,name,queue,port,component):                              #line 331
        self.name =  name                                                       #line 332
        self.queue =  queue # queue (input | output) of receiver                #line 333
        self.port =  port # destination port                                    #line 334
        self.component =  component # to (for bootstrap debug)                  #line 335#line 336
                                                                                #line 337
# Checks if two senders match, by pointer equality and port name matching.      #line 338
def sender_eq (s1,s2):                                                          #line 339
    same_components = ( s1. component ==  s2. component)                        #line 340
    same_ports = ( s1. port ==  s2. port)                                       #line 341
    return  same_components and  same_ports                                     #line 342#line 343#line 344

# Delivers the given message to the receiver of this connector.                 #line 345#line 346
def deposit (parent,conn,message):                                              #line 347
    new_message = make_message ( conn. receiver. port, message. datum)          #line 348
    push_message ( parent, conn. receiver. component, conn. receiver. queue, new_message)#line 349#line 350#line 351

def force_tick (parent,eh):                                                     #line 352
    tick_msg = make_message ( ".",new_datum_tick ())                            #line 353
    push_message ( parent, eh, eh. inq, tick_msg)                               #line 354
    return  tick_msg                                                            #line 355#line 356#line 357

def push_message (parent,receiver,inq,m):                                       #line 358
    inq.put ( m)                                                                #line 359
    parent. visit_ordering.put ( receiver)                                      #line 360#line 361#line 362

def is_self (child,container):                                                  #line 363
    # in an earlier version “self“ was denoted as ϕ                             #line 364
    return  child ==  container                                                 #line 365#line 366#line 367

def step_child (child,msg):                                                     #line 368
    before_state =  child. state                                                #line 369
    child.handler ( child, msg)                                                 #line 370
    after_state =  child. state                                                 #line 371
    return [ before_state ==  "idle" and  after_state!= "idle", before_state!= "idle" and  after_state!= "idle", before_state!= "idle" and  after_state ==  "idle"]#line 374#line 375#line 376

def save_message (eh,msg):                                                      #line 377
    eh. saved_messages.put ( msg)                                               #line 378#line 379#line 380

def fetch_saved_message_and_clear (eh):                                         #line 381
    return  eh. saved_messages.get ()                                           #line 382#line 383#line 384

def step_children (container,causingMessage):                                   #line 385
    container. state =  "idle"                                                  #line 386
    for child in list ( container. visit_ordering. queue):                      #line 387
        # child = container represents self, skip it                            #line 388
        if (not (is_self ( child, container))):                                 #line 389
            if (not ( child. inq.empty ())):                                    #line 390
                msg =  child. inq.get ()                                        #line 391
                began_long_run =  None                                          #line 392
                continued_long_run =  None                                      #line 393
                ended_long_run =  None                                          #line 394
                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 395
                if  began_long_run:                                             #line 396
                    save_message ( child, msg)                                  #line 397
                elif  continued_long_run:                                       #line 398
                    pass                                                        #line 399#line 400
                destroy_message ( msg)                                          #line 401
            else:                                                               #line 402
                if  child. state!= "idle":                                      #line 403
                    msg = force_tick ( container, child)                        #line 404
                    child.handler ( child, msg)                                 #line 405
                    destroy_message ( msg)                                      #line 406#line 407
            if  child. state ==  "active":                                      #line 408
                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 409
                container. state =  "active"                                    #line 410#line 411
            while (not ( child. outq.empty ())):                                #line 412
                msg =  child. outq.get ()                                       #line 413
                route ( container, child, msg)                                  #line 414
                destroy_message ( msg)                                          #line 415#line 416#line 417#line 418#line 419

def attempt_tick (parent,eh):                                                   #line 420
    if  eh. state!= "idle":                                                     #line 421
        force_tick ( parent, eh)                                                #line 422#line 423#line 424

def is_tick (msg):                                                              #line 425
    return  "tick" ==  msg. datum.kind ()                                       #line 426#line 427#line 428

# Routes a single message to all matching destinations, according to            #line 429
# the container's connection network.                                           #line 430#line 431
def route (container,from_component,message):                                   #line 432
    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)       #line 433
    fromname =  ""                                                              #line 434
    if is_tick ( message):                                                      #line 435
        for child in  container. children:                                      #line 436
            attempt_tick ( container, child)                                    #line 437
        was_sent =  True                                                        #line 438
    else:                                                                       #line 439
        if (not (is_self ( from_component, container))):                        #line 440
            fromname =  from_component. name                                    #line 441
        from_sender = Sender ( fromname, from_component, message. port)         #line 442#line 443
        for connector in  container. connections:                               #line 444
            if sender_eq ( from_sender, connector. sender):                     #line 445
                deposit ( container, connector, message)                        #line 446
                was_sent =  True                                                #line 447
    if not ( was_sent):                                                         #line 448
        print ( "\n\n*** Error: ***")                                           #line 449
        dump_possible_connections ( container)                                  #line 450
        print_routing_trace ( container)                                        #line 451
        print ( "***")                                                          #line 452
        print ( str( container. name) +  str( ": message '") +  str( message. port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 453
        print ( "***")                                                          #line 454
        exit ()                                                                 #line 455#line 456#line 457

def dump_possible_connections (container):                                      #line 458
    print ( str( "*** possible connections for ") +  str( container. name) +  ":"  )#line 459
    for connector in  container. connections:                                   #line 460
        print ( str( connector. direction) +  str( " ") +  str( connector. sender. name) +  str( ".") +  str( connector. sender. port) +  str( " -> ") +  str( connector. receiver. name) +  str( ".") +  connector. receiver. port        )#line 461#line 462#line 463

def any_child_ready (container):                                                #line 464
    for child in  container. children:                                          #line 465
        if child_is_ready ( child):                                             #line 466
            return  True                                                        #line 467
    return  False                                                               #line 468#line 469#line 470

def child_is_ready (eh):                                                        #line 471
    return (not ( eh. outq.empty ())) or (not ( eh. inq.empty ())) or ( eh. state!= "idle") or (any_child_ready ( eh))#line 472#line 473#line 474

def print_routing_trace (eh):                                                   #line 475
    print (routing_trace_all ( eh))                                             #line 476#line 477#line 478

def append_routing_descriptor (container,desc):                                 #line 479
    container. routings.put ( desc)                                             #line 480#line 481#line 482

def container_injector (container,message):                                     #line 483
    container_handler ( container, message)                                     #line 484#line 485#line 486





