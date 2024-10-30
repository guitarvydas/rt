

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






                                                                                #line 1#line 2#line 3
class Component_Registry:
    def __init__ (self,):                                                       #line 4
        self.templates = {}                                                     #line 5#line 6
                                                                                #line 7
class Template:
    def __init__ (self,name,template_data,instantiator):                        #line 8
        self.name =  name                                                       #line 9
        self.template_data =  template_data                                     #line 10
        self.instantiator =  instantiator                                       #line 11#line 12
                                                                                #line 13
def read_and_convert_json_file (filename):                                      #line 14

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

def json2internal (container_xml):                                              #line 18
    fname =  os.path.basename ( container_xml)                                  #line 19
    routings = read_and_convert_json_file ( fname)                              #line 20
    return  routings                                                            #line 21#line 22#line 23

def delete_decls (d):                                                           #line 24
    pass                                                                        #line 25#line 26#line 27

def make_component_registry ():                                                 #line 28
    return Component_Registry ()                                                #line 29#line 30#line 31

def register_component (reg,template):
    return abstracted_register_component ( reg, template, False)                #line 32

def register_component_allow_overwriting (reg,template):
    return abstracted_register_component ( reg, template, True)                 #line 33#line 34

def abstracted_register_component (reg,template,ok_to_overwrite):               #line 35
    name = mangle_name ( template. name)                                        #line 36
    if  name in  reg. templates and not  ok_to_overwrite:                       #line 37
        load_error ( str( "Component ") +  str( template. name) +  " already declared"  )#line 38
    reg. templates [ name] =  template                                          #line 39
    return  reg                                                                 #line 40#line 41#line 42

def register_multiple_components (reg,templates):                               #line 43
    for template in  templates:                                                 #line 44
        register_component ( reg, template)                                     #line 45#line 46#line 47

def get_component_instance (reg,full_name,owner):                               #line 48
    template_name = mangle_name ( full_name)                                    #line 49
    if  template_name in  reg. templates:                                       #line 50
        template =  reg. templates [ template_name]                             #line 51
        if ( template ==  None):                                                #line 52
            load_error ( str( "Registry Error: Can;t find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )#line 53
            return  None                                                        #line 54
        else:                                                                   #line 55
            owner_name =  ""                                                    #line 56
            instance_name =  template_name                                      #line 57
            if  None!= owner:                                                   #line 58
                owner_name =  owner. name                                       #line 59
                instance_name =  str( owner_name) +  str( ".") +  template_name  #line 60
            else:                                                               #line 61
                instance_name =  template_name                                  #line 62
            instance =  template.instantiator ( reg, owner, instance_name, template. template_data)#line 63
            instance. depth = calculate_depth ( instance)                       #line 64
            return  instance                                                    #line 65
    else:                                                                       #line 66
        load_error ( str( "Registry Error: Can't find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )#line 67
        return  None                                                            #line 68#line 69

def calculate_depth (eh):                                                       #line 70
    if  eh. owner ==  None:                                                     #line 71
        return  0                                                               #line 72
    else:                                                                       #line 73
        return  1+calculate_depth ( eh. owner)                                  #line 74#line 75#line 76

def dump_registry (reg):                                                        #line 77
    nl ()                                                                       #line 78
    print ( "*** PALETTE ***")                                                  #line 79
    for c in  reg. templates:                                                   #line 80
        print ( c. name)                                                        #line 81
    print ( "***************")                                                  #line 82
    nl ()                                                                       #line 83#line 84#line 85

def print_stats (reg):                                                          #line 86
    print ( str( "registry statistics: ") +  reg. stats )                       #line 87#line 88#line 89

def mangle_name (s):                                                            #line 90
    # trim name to remove code from Container component names _ deferred until later (or never)#line 91
    return  s                                                                   #line 92#line 93#line 94

def generate_shell_components (reg,container_list):                             #line 95
    # [                                                                         #line 96
    #     {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 97
    #     {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []}#line 98
    # ]                                                                         #line 99
    if  None!= container_list:                                                  #line 100
        for diagram in  container_list:                                         #line 101
            # loop through every component in the diagram and look for names that start with “$“#line 102
            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 103
            for child_descriptor in  diagram ["children"]:                      #line 104
                if first_char_is ( child_descriptor ["name"], "$"):             #line 105
                    name =  child_descriptor ["name"]                           #line 106
                    cmd =   name[1:] .strip ()                                  #line 107
                    generated_leaf = Template ( name, shell_out_instantiate, cmd)#line 108
                    register_component ( reg, generated_leaf)                   #line 109
                elif first_char_is ( child_descriptor ["name"], "'"):           #line 110
                    name =  child_descriptor ["name"]                           #line 111
                    s =   name[1:]                                              #line 112
                    generated_leaf = Template ( name, string_constant_instantiate, s)#line 113
                    register_component_allow_overwriting ( reg, generated_leaf) #line 114#line 115#line 116#line 117#line 118#line 119#line 120

def first_char (s):                                                             #line 121
    return   s[0]                                                               #line 122#line 123#line 124

def first_char_is (s,c):                                                        #line 125
    return  c == first_char ( s)                                                #line 126#line 127#line 128

# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 129
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 130
def run_command (eh,cmd,s):                                                     #line 131
    # capture_output ∷ ⊤                                                        #line 132
    ret =  subprocess.run ( cmd, s, "UTF_8")                                    #line 133
    if not ( ret. returncode ==  0):                                            #line 134
        if  ret. stderr!= None:                                                 #line 135
            return [ "", ret. stderr]                                           #line 136
        else:                                                                   #line 137
            return [ "", str( "error in shell_out ") +  ret. returncode ]       #line 138
    else:                                                                       #line 139
        return [ ret. stdout, None]                                             #line 140#line 141#line 142

# Data for an asyncronous component _ effectively, a function with input        #line 143
# and output queues of messages.                                                #line 144
#                                                                               #line 145
# Components can either be a user_supplied function (“lea“), or a “container“   #line 146
# that routes messages to child components according to a list of connections   #line 147
# that serve as a message routing table.                                        #line 148
#                                                                               #line 149
# Child components themselves can be leaves or other containers.                #line 150
#                                                                               #line 151
# `handler` invokes the code that is attached to this component.                #line 152
#                                                                               #line 153
# `instance_data` is a pointer to instance data that the `leaf_handler`         #line 154
# function may want whenever it is invoked again.                               #line 155
#                                                                               #line 156#line 157
# Eh_States :: enum { idle, active }                                            #line 158
class Eh:
    def __init__ (self,):                                                       #line 159
        self.name =  ""                                                         #line 160
        self.inq =  queue.Queue ()                                              #line 161
        self.outq =  queue.Queue ()                                             #line 162
        self.owner =  None                                                      #line 163
        self.saved_messages =  queue.LifoQueue () # stack of saved message(s)   #line 164
        self.children = []                                                      #line 165
        self.visit_ordering =  queue.Queue ()                                   #line 166
        self.connections = []                                                   #line 167
        self.routings =  queue.Queue ()                                         #line 168
        self.handler =  None                                                    #line 169
        self.instance_data =  None                                              #line 170
        self.state =  "idle"                                                    #line 171# bootstrap debugging#line 172
        self.kind =  None # enum { container, leaf, }                           #line 173
        self.trace =  False # set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component)#line 174
        self.depth =  0 # hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc.#line 175#line 176
                                                                                #line 177
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 178
# whose handler function is `container_handler`.                                #line 179
def make_container (name,owner):                                                #line 180
    eh = Eh ()                                                                  #line 181
    eh. name =  name                                                            #line 182
    eh. owner =  owner                                                          #line 183
    eh. handler =  container_handler                                            #line 184
    eh. inject =  container_injector                                            #line 185
    eh. state =  "idle"                                                         #line 186
    eh. kind =  "container"                                                     #line 187
    return  eh                                                                  #line 188#line 189#line 190

# Creates a new leaf component out of a handler function, and a data parameter  #line 191
# that will be passed back to your handler when called.                         #line 192#line 193
def make_leaf (name,owner,instance_data,handler):                               #line 194
    eh = Eh ()                                                                  #line 195
    eh. name =  str( owner. name) +  str( ".") +  name                          #line 196
    eh. owner =  owner                                                          #line 197
    eh. handler =  handler                                                      #line 198
    eh. instance_data =  instance_data                                          #line 199
    eh. state =  "idle"                                                         #line 200
    eh. kind =  "leaf"                                                          #line 201
    return  eh                                                                  #line 202#line 203#line 204

# Sends a message on the given `port` with `data`, placing it on the output     #line 205
# of the given component.                                                       #line 206#line 207
def send (eh,port,datum,causingMessage):                                        #line 208
    msg = make_message ( port, datum)                                           #line 209
    put_output ( eh, msg)                                                       #line 210#line 211#line 212

def send_string (eh,port,s,causingMessage):                                     #line 213
    datum = new_datum_string ( s)                                               #line 214
    msg = make_message ( port, datum)                                           #line 215
    put_output ( eh, msg)                                                       #line 216#line 217#line 218

def forward (eh,port,msg):                                                      #line 219
    fwdmsg = make_message ( port, msg. datum)                                   #line 220
    put_output ( eh, msg)                                                       #line 221#line 222#line 223

def inject (eh,msg):                                                            #line 224
    eh.inject ( eh, msg)                                                        #line 225#line 226#line 227

# Returns a list of all output messages on a container.                         #line 228
# For testing / debugging purposes.                                             #line 229#line 230
def output_list (eh):                                                           #line 231
    return  eh. outq                                                            #line 232#line 233#line 234

# Utility for printing an array of messages.                                    #line 235
def print_output_list (eh):                                                     #line 236
    for m in list ( eh. outq. queue):                                           #line 237
        print (format_message ( m))                                             #line 238#line 239#line 240

def spaces (n):                                                                 #line 241
    s =  ""                                                                     #line 242
    for i in range( n):                                                         #line 243
        s =  s+ " "                                                             #line 244
    return  s                                                                   #line 245#line 246#line 247

def set_active (eh):                                                            #line 248
    eh. state =  "active"                                                       #line 249#line 250#line 251

def set_idle (eh):                                                              #line 252
    eh. state =  "idle"                                                         #line 253#line 254#line 255

# Utility for printing a specific output message.                               #line 256#line 257
def fetch_first_output (eh,port):                                               #line 258
    for msg in list ( eh. outq. queue):                                         #line 259
        if ( msg. port ==  port):                                               #line 260
            return  msg. datum                                                  #line 261
    return  None                                                                #line 262#line 263#line 264

def print_specific_output (eh,port):                                            #line 265
    # port ∷ “”                                                                 #line 266
    datum = fetch_first_output ( eh, port)                                      #line 267
    print ( datum.srepr ())                                                     #line 268#line 269

def print_specific_output_to_stderr (eh,port):                                  #line 270
    # port ∷ “”                                                                 #line 271
    datum = fetch_first_output ( eh, port)                                      #line 272
    # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 273
    print ( datum.srepr (), file=sys.stderr)                                    #line 274#line 275#line 276

def put_output (eh,msg):                                                        #line 277
    eh. outq.put ( msg)                                                         #line 278#line 279#line 280

def injector_NIY (eh,msg):                                                      #line 281
    # print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“')#line 282
    print ( str( "Injector not implemented for this component ") +  str( eh. name) +  str( " kind ∷ ") +  str( eh. kind) +  str( ",  port ∷ ") +  msg. port     )#line 287
    exit ()                                                                     #line 288#line 289#line 290

root_project =  ""                                                              #line 291
root_0D =  ""                                                                   #line 292#line 293
def set_environment (rproject,r0D):                                             #line 294
    global root_project                                                         #line 295
    global root_0D                                                              #line 296
    root_project =  rproject                                                    #line 297
    root_0D =  r0D                                                              #line 298#line 299#line 300

def probe_instantiate (reg,owner,name,template_data):                           #line 301
    name_with_id = gensymbol ( "?")                                             #line 302
    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 303#line 304

def probeA_instantiate (reg,owner,name,template_data):                          #line 305
    name_with_id = gensymbol ( "?A")                                            #line 306
    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 307#line 308#line 309

def probeB_instantiate (reg,owner,name,template_data):                          #line 310
    name_with_id = gensymbol ( "?B")                                            #line 311
    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 312#line 313#line 314

def probeC_instantiate (reg,owner,name,template_data):                          #line 315
    name_with_id = gensymbol ( "?C")                                            #line 316
    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 317#line 318#line 319

def probe_handler (eh,msg):                                                     #line 320
    s =  msg. datum.srepr ()                                                    #line 321
    print ( str( "... probe ") +  str( eh. name) +  str( ": ") +  s   , file=sys.stderr)#line 322#line 323#line 324

def trash_instantiate (reg,owner,name,template_data):                           #line 325
    name_with_id = gensymbol ( "trash")                                         #line 326
    return make_leaf ( name_with_id, owner, None, trash_handler)                #line 327#line 328#line 329

def trash_handler (eh,msg):                                                     #line 330
    # to appease dumped_on_floor checker                                        #line 331
    pass                                                                        #line 332#line 333

class TwoMessages:
    def __init__ (self,first,second):                                           #line 334
        self.first =  first                                                     #line 335
        self.second =  second                                                   #line 336#line 337
                                                                                #line 338
# Deracer_States :: enum { idle, waitingForFirst, waitingForSecond }            #line 339
class Deracer_Instance_Data:
    def __init__ (self,state,buffer):                                           #line 340
        self.state =  state                                                     #line 341
        self.buffer =  buffer                                                   #line 342#line 343
                                                                                #line 344
def reclaim_Buffers_from_heap (inst):                                           #line 345
    pass                                                                        #line 346#line 347#line 348

def deracer_instantiate (reg,owner,name,template_data):                         #line 349
    name_with_id = gensymbol ( "deracer")                                       #line 350
    inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))            #line 351
    inst. state =  "idle"                                                       #line 352
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)                #line 353
    return  eh                                                                  #line 354#line 355#line 356

def send_first_then_second (eh,inst):                                           #line 357
    forward ( eh, "1", inst. buffer. first)                                     #line 358
    forward ( eh, "2", inst. buffer. second)                                    #line 359
    reclaim_Buffers_from_heap ( inst)                                           #line 360#line 361#line 362

def deracer_handler (eh,msg):                                                   #line 363
    inst =  eh. instance_data                                                   #line 364
    if  inst. state ==  "idle":                                                 #line 365
        if  "1" ==  msg. port:                                                  #line 366
            inst. buffer. first =  msg                                          #line 367
            inst. state =  "waitingForSecond"                                   #line 368
        elif  "2" ==  msg. port:                                                #line 369
            inst. buffer. second =  msg                                         #line 370
            inst. state =  "waitingForFirst"                                    #line 371
        else:                                                                   #line 372
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg. port )#line 373
    elif  inst. state ==  "waitingForFirst":                                    #line 374
        if  "1" ==  msg. port:                                                  #line 375
            inst. buffer. first =  msg                                          #line 376
            send_first_then_second ( eh, inst)                                  #line 377
            inst. state =  "idle"                                               #line 378
        else:                                                                   #line 379
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg. port )#line 380
    elif  inst. state ==  "waitingForSecond":                                   #line 381
        if  "2" ==  msg. port:                                                  #line 382
            inst. buffer. second =  msg                                         #line 383
            send_first_then_second ( eh, inst)                                  #line 384
            inst. state =  "idle"                                               #line 385
        else:                                                                   #line 386
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg. port )#line 387
    else:                                                                       #line 388
        runtime_error ( "bad state for deracer {eh.state}")                     #line 389#line 390#line 391

def low_level_read_text_file_instantiate (reg,owner,name,template_data):        #line 392
    name_with_id = gensymbol ( "Low Level Read Text File")                      #line 393
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 394#line 395#line 396

def low_level_read_text_file_handler (eh,msg):                                  #line 397
    fname =  msg. datum.srepr ()                                                #line 398

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
                                                                                #line 399#line 400#line 401

def ensure_string_datum_instantiate (reg,owner,name,template_data):             #line 402
    name_with_id = gensymbol ( "Ensure String Datum")                           #line 403
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)  #line 404#line 405#line 406

def ensure_string_datum_handler (eh,msg):                                       #line 407
    if  "string" ==  msg. datum.kind ():                                        #line 408
        forward ( eh, "", msg)                                                  #line 409
    else:                                                                       #line 410
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg. datum #line 411
        send_string ( eh, "✗", emsg, msg)                                       #line 412#line 413#line 414

class Syncfilewrite_Data:
    def __init__ (self,):                                                       #line 415
        self.filename =  ""                                                     #line 416#line 417
                                                                                #line 418
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)   #line 419
def syncfilewrite_instantiate (reg,owner,name,template_data):                   #line 420
    name_with_id = gensymbol ( "syncfilewrite")                                 #line 421
    inst = Syncfilewrite_Data ()                                                #line 422
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)        #line 423#line 424#line 425

def syncfilewrite_handler (eh,msg):                                             #line 426
    inst =  eh. instance_data                                                   #line 427
    if  "filename" ==  msg. port:                                               #line 428
        inst. filename =  msg. datum.srepr ()                                   #line 429
    elif  "input" ==  msg. port:                                                #line 430
        contents =  msg. datum.srepr ()                                         #line 431
        f = open ( inst. filename, "w")                                         #line 432
        if  f!= None:                                                           #line 433
            f.write ( msg. datum.srepr ())                                      #line 434
            f.close ()                                                          #line 435
            send ( eh, "done",new_datum_bang (), msg)                           #line 436
        else:                                                                   #line 437
            send_string ( eh, "✗", str( "open error on file ") +  inst. filename , msg)#line 438#line 439#line 440

class StringConcat_Instance_Data:
    def __init__ (self,):                                                       #line 441
        self.buffer1 =  None                                                    #line 442
        self.buffer2 =  None                                                    #line 443
        self.count =  0                                                         #line 444#line 445
                                                                                #line 446
def stringconcat_instantiate (reg,owner,name,template_data):                    #line 447
    name_with_id = gensymbol ( "stringconcat")                                  #line 448
    instp = StringConcat_Instance_Data ()                                       #line 449
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)        #line 450#line 451#line 452

def stringconcat_handler (eh,msg):                                              #line 453
    inst =  eh. instance_data                                                   #line 454
    if  "1" ==  msg. port:                                                      #line 455
        inst. buffer1 = clone_string ( msg. datum.srepr ())                     #line 456
        inst. count =  inst. count+ 1                                           #line 457
        maybe_stringconcat ( eh, inst, msg)                                     #line 458
    elif  "2" ==  msg. port:                                                    #line 459
        inst. buffer2 = clone_string ( msg. datum.srepr ())                     #line 460
        inst. count =  inst. count+ 1                                           #line 461
        maybe_stringconcat ( eh, inst, msg)                                     #line 462
    else:                                                                       #line 463
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg. port )  #line 464#line 465#line 466#line 467

def maybe_stringconcat (eh,inst,msg):                                           #line 468
    if ( 0 == len ( inst. buffer1)) and ( 0 == len ( inst. buffer2)):           #line 469
        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 470
    if  inst. count >=  2:                                                      #line 471
        concatenated_string =  ""                                               #line 472
        if  0 == len ( inst. buffer1):                                          #line 473
            concatenated_string =  inst. buffer2                                #line 474
        elif  0 == len ( inst. buffer2):                                        #line 475
            concatenated_string =  inst. buffer1                                #line 476
        else:                                                                   #line 477
            concatenated_string =  inst. buffer1+ inst. buffer2                 #line 478
        send_string ( eh, "", concatenated_string, msg)                         #line 479
        inst. buffer1 =  None                                                   #line 480
        inst. buffer2 =  None                                                   #line 481
        inst. count =  0                                                        #line 482#line 483#line 484

#                                                                               #line 485#line 486
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 487
def shell_out_instantiate (reg,owner,name,template_data):                       #line 488
    name_with_id = gensymbol ( "shell_out")                                     #line 489
    cmd == shlex.split ( template_data)                                         #line 490
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)             #line 491#line 492#line 493

def shell_out_handler (eh,msg):                                                 #line 494
    cmd =  eh. instance_data                                                    #line 495
    s =  msg. datum.srepr ()                                                    #line 496
    stdout =  None                                                              #line 497
    stderr =  None                                                              #line 498
    [ stdout, stderr] = run_command ( eh, cmd, s)                               #line 499
    if  stderr!= None:                                                          #line 500
        send_string ( eh, "✗", stderr, msg)                                     #line 501
    else:                                                                       #line 502
        send_string ( eh, "", stdout, msg)                                      #line 503#line 504#line 505

def string_constant_instantiate (reg,owner,name,template_data):                 #line 506
    global root_project                                                         #line 507
    global root_0D                                                              #line 508
    name_with_id = gensymbol ( "strconst")                                      #line 509
    s =  template_data                                                          #line 510
    if  root_project!= "":                                                      #line 511
        s =  re.sub ( "_00_", root_project, s)                                  #line 512
    if  root_0D!= "":                                                           #line 513
        s =  re.sub ( "_0D_", root_0D, s)                                       #line 514
    return make_leaf ( name_with_id, owner, s, string_constant_handler)         #line 515#line 516#line 517

def string_constant_handler (eh,msg):                                           #line 518
    s =  eh. instance_data                                                      #line 519
    send_string ( eh, "", s, msg)                                               #line 520#line 521#line 522

def string_make_persistent (s):                                                 #line 523
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 524
    return  s                                                                   #line 525#line 526#line 527

def string_clone (s):                                                           #line 528
    return  s                                                                   #line 529#line 530#line 531

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...   #line 532
# where ${_00_} is the root directory for the project                           #line 533
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)        #line 534#line 535#line 536#line 537
def initialize_component_palette (root_project,root_0D,diagram_source_files):   #line 538
    reg = make_component_registry ()                                            #line 539
    for diagram_source in  diagram_source_files:                                #line 540
        all_containers_within_single_file = json2internal ( diagram_source)     #line 541
        generate_shell_components ( reg, all_containers_within_single_file)     #line 542
        for container in  all_containers_within_single_file:                    #line 543
            register_component ( reg,Template ( container ["name"], container, container_instantiator))#line 544
    initialize_stock_components ( reg)                                          #line 545
    return  reg                                                                 #line 546#line 547#line 548

def print_error_maybe (main_container):                                         #line 549
    error_port =  "✗"                                                           #line 550
    err = fetch_first_output ( main_container, error_port)                      #line 551
    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):                   #line 552
        print ( "___ !!! ERRORS !!! ___")                                       #line 553
        print_specific_output ( main_container, error_port, False)              #line 554#line 555#line 556

# debugging helpers                                                             #line 557#line 558
def nl ():                                                                      #line 559
    print ( "")                                                                 #line 560#line 561#line 562

def dump_outputs (main_container):                                              #line 563
    nl ()                                                                       #line 564
    print ( "___ Outputs ___")                                                  #line 565
    print_output_list ( main_container)                                         #line 566#line 567#line 568

def trace_outputs (main_container):                                             #line 569
    nl ()                                                                       #line 570
    print ( "___ Message Traces ___")                                           #line 571
    print_routing_trace ( main_container)                                       #line 572#line 573#line 574

def dump_hierarchy (main_container):                                            #line 575
    nl ()                                                                       #line 576
    print ( str( "___ Hierarchy ___") + (build_hierarchy ( main_container)) )   #line 577#line 578#line 579

def build_hierarchy (c):                                                        #line 580
    s =  ""                                                                     #line 581
    for child in  c. children:                                                  #line 582
        s =  str( s) + build_hierarchy ( child)                                 #line 583
    indent =  ""                                                                #line 584
    for i in range( c. depth):                                                  #line 585
        indent =  indent+ "  "                                                  #line 586
    return  str( "\n") +  str( indent) +  str( "(") +  str( c. name) +  str( s) +  ")"     #line 587#line 588#line 589

def dump_connections (c):                                                       #line 590
    nl ()                                                                       #line 591
    print ( "___ connections ___")                                              #line 592
    dump_possible_connections ( c)                                              #line 593
    for child in  c. children:                                                  #line 594
        nl ()                                                                   #line 595
        dump_possible_connections ( child)                                      #line 596#line 597#line 598

def trimws (s):                                                                 #line 599
    # remove whitespace from front and back of string                           #line 600
    return  s.strip ()                                                          #line 601#line 602#line 603

def clone_string (s):                                                           #line 604
    return  s                                                                   #line 605#line 606#line 607

load_errors =  False                                                            #line 608
runtime_errors =  False                                                         #line 609#line 610
def load_error (s):                                                             #line 611
    global load_errors                                                          #line 612
    print ( s)                                                                  #line 613
    quit ()                                                                     #line 614
    load_errors =  True                                                         #line 615#line 616#line 617

def runtime_error (s):                                                          #line 618
    global runtime_errors                                                       #line 619
    print ( s)                                                                  #line 620
    quit ()                                                                     #line 621
    runtime_errors =  True                                                      #line 622#line 623#line 624

def fakepipename_instantiate (reg,owner,name,template_data):                    #line 625
    instance_name = gensymbol ( "fakepipe")                                     #line 626
    return make_leaf ( instance_name, owner, None, fakepipename_handler)        #line 627#line 628#line 629

rand =  0                                                                       #line 630#line 631
def fakepipename_handler (eh,msg):                                              #line 632
    global rand                                                                 #line 633
    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 634
    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)                  #line 635#line 636#line 637
                                                                                #line 638
# all of the the built_in leaves are listed here                                #line 639
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 640#line 641#line 642
def initialize_stock_components (reg):                                          #line 643
    register_component ( reg,Template ( "1then2", None, deracer_instantiate))   #line 644
    register_component ( reg,Template ( "?", None, probe_instantiate))          #line 645
    register_component ( reg,Template ( "?A", None, probeA_instantiate))        #line 646
    register_component ( reg,Template ( "?B", None, probeB_instantiate))        #line 647
    register_component ( reg,Template ( "?C", None, probeC_instantiate))        #line 648
    register_component ( reg,Template ( "trash", None, trash_instantiate))      #line 649#line 650
    register_component ( reg,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 651
    register_component ( reg,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 652#line 653
    register_component ( reg,Template ( "syncfilewrite", None, syncfilewrite_instantiate))#line 654
    register_component ( reg,Template ( "stringconcat", None, stringconcat_instantiate))#line 655
    # for fakepipe                                                              #line 656
    register_component ( reg,Template ( "fakepipename", None, fakepipename_instantiate))#line 657#line 658#line 659

def argv ():                                                                    #line 660
    sys.argv                                                                    #line 661#line 662#line 663

def initialize ():                                                              #line 664
    root_of_project =  sys.argv[ 1]                                             #line 665
    root_of_0D =  sys.argv[ 2]                                                  #line 666
    arg =  sys.argv[ 3]                                                         #line 667
    main_container_name =  sys.argv[ 4]                                         #line 668
    diagram_names =  sys.argv[ 5:]                                              #line 669
    palette = initialize_component_palette ( root_project, root_0D, diagram_names)#line 670
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 671#line 672#line 673

def start (palette,env):
    start_with_debug ( palette, env, False, False, False, False)                #line 674

def start_with_debug (palette,env,show_hierarchy,show_connections,show_traces,show_all_outputs):#line 675
    # show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥   #line 676
    root_of_project =  env [ 0]                                                 #line 677
    root_of_0D =  env [ 1]                                                      #line 678
    main_container_name =  env [ 2]                                             #line 679
    diagram_names =  env [ 3]                                                   #line 680
    arg =  env [ 4]                                                             #line 681
    set_environment ( root_of_project, root_of_0D)                              #line 682
    # get entrypoint container                                                  #line 683
    main_container = get_component_instance ( palette, main_container_name, None)#line 684
    if  None ==  main_container:                                                #line 685
        load_error ( str( "Couldn't find container with page name ") +  str( main_container_name) +  str( " in files ") +  str( diagram_names) +  "(check tab names, or disable compression?)"    )#line 689#line 690
    if  show_hierarchy:                                                         #line 691
        dump_hierarchy ( main_container)                                        #line 692#line 693
    if  show_connections:                                                       #line 694
        dump_connections ( main_container)                                      #line 695#line 696
    if not  load_errors:                                                        #line 697
        arg = new_datum_string ( arg)                                           #line 698
        msg = make_message ( "", arg)                                           #line 699
        inject ( main_container, msg)                                           #line 700
        if  show_all_outputs:                                                   #line 701
            dump_outputs ( main_container)                                      #line 702
        else:                                                                   #line 703
            print_error_maybe ( main_container)                                 #line 704
            print_specific_output ( main_container, "")                         #line 705
            if  show_traces:                                                    #line 706
                print ( "--- routing traces ---")                               #line 707
                print (routing_trace_all ( main_container))                     #line 708#line 709#line 710
        if  show_all_outputs:                                                   #line 711
            print ( "--- done ---")                                             #line 712#line 713#line 714#line 715#line 716
                                                                                #line 717#line 718
# utility functions                                                             #line 719
def send_int (eh,port,i,causing_message):                                       #line 720
    datum = new_datum_int ( i)                                                  #line 721
    send ( eh, port, datum, causing_message)                                    #line 722#line 723#line 724

def send_bang (eh,port,causing_message):                                        #line 725
    datum = new_datum_bang ()                                                   #line 726
    send ( eh, port, datum, causing_message)                                    #line 727#line 728#line 729





