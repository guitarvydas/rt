

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
        self.v =  None                                      #line 31
        self.clone =  None                                  #line 32
        self.reclaim =  None                                #line 33
        self.other =  None # reserved for use on per-project basis #line 34#line 35
                                                            #line 36
def new_datum_string (s):                                   #line 37
    d =  Datum ()                                           #line 38
    d.v =  s                                                #line 39
    d.clone =  lambda : clone_datum_string ( d)             #line 40
    d.reclaim =  lambda : reclaim_datum_string ( d)         #line 41
    return  d                                               #line 42#line 43#line 44

def clone_datum_string (d):                                 #line 45
    newd = new_datum_string ( d.v)                          #line 46
    return  newd                                            #line 47#line 48#line 49

def reclaim_datum_string (src):                             #line 50
    pass                                                    #line 51#line 52#line 53

def new_datum_bang ():                                      #line 54
    p =  Datum ()                                           #line 55
    p.v =  ""                                               #line 56
    p.clone =  lambda : clone_datum_bang ( p)               #line 57
    p.reclaim =  lambda : reclaim_datum_bang ( p)           #line 58
    return  p                                               #line 59#line 60#line 61

def clone_datum_bang (d):                                   #line 62
    return new_datum_bang ()                                #line 63#line 64#line 65

def reclaim_datum_bang (d):                                 #line 66
    pass                                                    #line 67#line 68#line 69

# Message passed to a leaf component.                       #line 70
#                                                           #line 71
# `port` refers to the name of the incoming or outgoing port of this component.#line 72
# `datum` is the data attached to this message.             #line 73
class Message:
    def __init__ (self,):                                   #line 74
        self.port =  None                                   #line 75
        self.datum =  None                                  #line 76#line 77
                                                            #line 78
def clone_port (s):                                         #line 79
    return clone_string ( s)                                #line 80#line 81#line 82

# Utility for making a `Message`. Used to safely “seed“ messages#line 83
# entering the very top of a network.                       #line 84
def make_message (port,datum):                              #line 85
    p = clone_string ( port)                                #line 86
    m =  Message ()                                         #line 87
    m.port =  p                                             #line 88
    m.datum =  datum.clone ()                               #line 89
    return  m                                               #line 90#line 91#line 92

# Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations.#line 93
def message_clone (msg):                                    #line 94
    m =  Message ()                                         #line 95
    m.port = clone_port ( msg.port)                         #line 96
    m.datum =  msg.datum.clone ()                           #line 97
    return  m                                               #line 98#line 99#line 100

# Frees a message.                                          #line 101
def destroy_message (msg):                                  #line 102
    # during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages#line 103
    pass                                                    #line 104#line 105#line 106

def destroy_datum (msg):                                    #line 107
    pass                                                    #line 108#line 109#line 110

def destroy_port (msg):                                     #line 111
    pass                                                    #line 112#line 113#line 114

#                                                           #line 115
def format_message (m):                                     #line 116
    if  m ==  None:                                         #line 117
        return  str( "‹") +  str( m.port) +  str( "›:‹") +  str( "ϕ") +  "›,"    #line 118
    else:                                                   #line 119
        return  str( "‹") +  str( m.port) +  str( "›:‹") +  str( m.datum.v) +  "›,"    #line 120#line 121#line 122#line 123

enumDown =  0                                               #line 124
enumAcross =  1                                             #line 125
enumUp =  2                                                 #line 126
enumThrough =  3                                            #line 127#line 128
def create_down_connector (container,proto_conn,connectors,children_by_id):#line 129
    # JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 130
    connector =  Connector ()                               #line 131
    connector.direction =  "down"                           #line 132
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])#line 133
    target_proto =  proto_conn [ "target"]                  #line 134
    id_proto =  target_proto [ "id"]                        #line 135
    target_component =  children_by_id [id_proto]           #line 136
    if ( target_component ==  None):                        #line 137
        load_error ( str( "internal error: .Down connection target internal error ") + ( proto_conn [ "target"]) [ "name"] )#line 138
    else:                                                   #line 139
        connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)#line 140#line 141
    return  connector                                       #line 142#line 143#line 144

def create_across_connector (container,proto_conn,connectors,children_by_id):#line 145
    connector =  Connector ()                               #line 146
    connector.direction =  "across"                         #line 147
    source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])]#line 148
    target_component =  children_by_id [(( proto_conn [ "target"]) [ "id"])]#line 149
    if  source_component ==  None:                          #line 150
        load_error ( str( "internal error: .Across connection source not ok ") + ( proto_conn [ "source"]) [ "name"] )#line 151
    else:                                                   #line 152
        connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])#line 153
        if  target_component ==  None:                      #line 154
            load_error ( str( "internal error: .Across connection target not ok ") + ( proto_conn [ "target"]) [ "name"] )#line 155
        else:                                               #line 156
            connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)#line 157#line 158#line 159
    return  connector                                       #line 160#line 161#line 162

def create_up_connector (container,proto_conn,connectors,children_by_id):#line 163
    connector =  Connector ()                               #line 164
    connector.direction =  "up"                             #line 165
    source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])]#line 166
    if  source_component ==  None:                          #line 167
        load_error ( str( "internal error: .Up connection source not ok ") + ( proto_conn [ "source"]) [ "name"] )#line 168
    else:                                                   #line 169
        connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])#line 170
        connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)#line 171#line 172
    return  connector                                       #line 173#line 174#line 175

def create_through_connector (container,proto_conn,connectors,children_by_id):#line 176
    connector =  Connector ()                               #line 177
    connector.direction =  "through"                        #line 178
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])#line 179
    connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)#line 180
    return  connector                                       #line 181#line 182#line 183
                                                            #line 184
def container_instantiator (reg,owner,container_name,desc): #line 185
    global enumDown, enumUp, enumAcross, enumThrough        #line 186
    container = make_container ( container_name, owner)     #line 187
    children = []                                           #line 188
    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here#line 189
    # collect children                                      #line 190
    for child_desc in  desc [ "children"]:                  #line 191
        child_instance = get_component_instance ( reg, child_desc [ "name"], container)#line 192
        children.append ( child_instance)                   #line 193
        id =  child_desc [ "id"]                            #line 194
        children_by_id [id] =  child_instance               #line 195#line 196#line 197
    container.children =  children                          #line 198#line 199
    connectors = []                                         #line 200
    for proto_conn in  desc [ "connections"]:               #line 201
        connector =  Connector ()                           #line 202
        if  proto_conn [ "dir"] ==  enumDown:               #line 203
            connectors.append (create_down_connector ( container, proto_conn, connectors, children_by_id)) #line 204
        elif  proto_conn [ "dir"] ==  enumAcross:           #line 205
            connectors.append (create_across_connector ( container, proto_conn, connectors, children_by_id)) #line 206
        elif  proto_conn [ "dir"] ==  enumUp:               #line 207
            connectors.append (create_up_connector ( container, proto_conn, connectors, children_by_id)) #line 208
        elif  proto_conn [ "dir"] ==  enumThrough:          #line 209
            connectors.append (create_through_connector ( container, proto_conn, connectors, children_by_id)) #line 210#line 211#line 212
    container.connections =  connectors                     #line 213
    return  container                                       #line 214#line 215#line 216

# The default handler for container components.             #line 217
def container_handler (container,message):                  #line 218
    route ( container, container, message)
    # references to 'self' are replaced by the container during instantiation#line 219
    while any_child_ready ( container):                     #line 220
        step_children ( container, message)                 #line 221#line 222#line 223

# Frees the given container and associated data.            #line 224
def destroy_container (eh):                                 #line 225
    pass                                                    #line 226#line 227#line 228

# Routing connection for a container component. The `direction` field has#line 229
# no affect on the default message routing system _ it is there for debugging#line 230
# purposes, or for reading by other tools.                  #line 231#line 232
class Connector:
    def __init__ (self,):                                   #line 233
        self.direction =  None # down, across, up, through  #line 234
        self.sender =  None                                 #line 235
        self.receiver =  None                               #line 236#line 237
                                                            #line 238
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,#line 239
# based on component ID (pointer) and port name.            #line 240#line 241
class Sender:
    def __init__ (self,):                                   #line 242
        self.name =  None                                   #line 243
        self.component =  None                              #line 244
        self.port =  None                                   #line 245#line 246
                                                            #line 247#line 248#line 249
# `Receiver` is a handle to a destination queue, and a `port` name to assign#line 250
# to incoming messages to this queue.                       #line 251#line 252
class Receiver:
    def __init__ (self,):                                   #line 253
        self.name =  None                                   #line 254
        self.queue =  None                                  #line 255
        self.port =  None                                   #line 256
        self.component =  None                              #line 257#line 258
                                                            #line 259
def mkSender (name,component,port):                         #line 260
    s =  Sender ()                                          #line 261
    s.name =  name                                          #line 262
    s.component =  component                                #line 263
    s.port =  port                                          #line 264
    return  s                                               #line 265#line 266#line 267

def mkReceiver (name,component,port,q):                     #line 268
    r =  Receiver ()                                        #line 269
    r.name =  name                                          #line 270
    r.component =  component                                #line 271
    r.port =  port                                          #line 272
    # We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq.#line 273
    r.queue =  q                                            #line 274
    return  r                                               #line 275#line 276#line 277

# Checks if two senders match, by pointer equality and port name matching.#line 278
def sender_eq (s1,s2):                                      #line 279
    same_components = ( s1.component ==  s2.component)      #line 280
    same_ports = ( s1.port ==  s2.port)                     #line 281
    return  same_components and  same_ports                 #line 282#line 283#line 284

# Delivers the given message to the receiver of this connector.#line 285#line 286
def deposit (parent,conn,message):                          #line 287
    new_message = make_message ( conn.receiver.port, message.datum)#line 288
    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)#line 289#line 290#line 291

def force_tick (parent,eh):                                 #line 292
    tick_msg = make_message ( ".",new_datum_bang ())        #line 293
    push_message ( parent, eh, eh.inq, tick_msg)            #line 294
    return  tick_msg                                        #line 295#line 296#line 297

def push_message (parent,receiver,inq,m):                   #line 298
    inq.append ( m)                                         #line 299
    parent.visit_ordering.append ( receiver)                #line 300#line 301#line 302

def is_self (child,container):                              #line 303
    # in an earlier version “self“ was denoted as ϕ         #line 304
    return  child ==  container                             #line 305#line 306#line 307

def step_child (child,msg):                                 #line 308
    before_state =  child.state                             #line 309
    child.handler ( child, msg)                             #line 310
    after_state =  child.state                              #line 311
    return [ before_state ==  "idle" and  after_state!= "idle", before_state!= "idle" and  after_state!= "idle", before_state!= "idle" and  after_state ==  "idle"]#line 314#line 315#line 316

def step_children (container,causingMessage):               #line 317
    container.state =  "idle"                               #line 318
    for child in  list ( container.visit_ordering):         #line 319
        # child = container represents self, skip it        #line 320
        if (not (is_self ( child, container))):             #line 321
            if (not ((0==len( child.inq)))):                #line 322
                msg =  child.inq.popleft ()                 #line 323
                began_long_run =  None                      #line 324
                continued_long_run =  None                  #line 325
                ended_long_run =  None                      #line 326
                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 327
                if  began_long_run:                         #line 328
                    pass                                    #line 329
                elif  continued_long_run:                   #line 330
                    pass                                    #line 331
                elif  ended_long_run:                       #line 332
                    pass                                    #line 333#line 334
                destroy_message ( msg)                      #line 335
            else:                                           #line 336
                if  child.state!= "idle":                   #line 337
                    msg = force_tick ( container, child)    #line 338
                    child.handler ( child, msg)             #line 339
                    destroy_message ( msg)                  #line 340#line 341#line 342#line 343
            if  child.state ==  "active":                   #line 344
                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 345
                container.state =  "active"                 #line 346#line 347#line 348
            while (not ((0==len( child.outq)))):            #line 349
                msg =  child.outq.popleft ()                #line 350
                route ( container, child, msg)              #line 351
                destroy_message ( msg)                      #line 352#line 353#line 354#line 355#line 356#line 357

def attempt_tick (parent,eh):                               #line 358
    if  eh.state!= "idle":                                  #line 359
        force_tick ( parent, eh)                            #line 360#line 361#line 362#line 363

def is_tick (msg):                                          #line 364
    return  "." ==  msg.port
    # assume that any message that is sent to port "." is a tick #line 365#line 366#line 367

# Routes a single message to all matching destinations, according to#line 368
# the container's connection network.                       #line 369#line 370
def route (container,from_component,message):               #line 371
    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)#line 372
    fromname =  ""                                          #line 373
    if is_tick ( message):                                  #line 374
        for child in  container.children:                   #line 375
            attempt_tick ( container, child)                #line 376
        was_sent =  True                                    #line 377
    else:                                                   #line 378
        if (not (is_self ( from_component, container))):    #line 379
            fromname =  from_component.name                 #line 380#line 381
        from_sender = mkSender ( fromname, from_component, message.port)#line 382#line 383
        for connector in  container.connections:            #line 384
            if sender_eq ( from_sender, connector.sender):  #line 385
                deposit ( container, connector, message)    #line 386
                was_sent =  True                            #line 387#line 388#line 389#line 390
    if not ( was_sent):                                     #line 391
        print ( "\n\n*** Error: ***")                       #line 392
        print ( "***")                                      #line 393
        print ( str( container.name) +  str( ": message '") +  str( message.port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 394
        print ( "***")                                      #line 395
        exit ()                                             #line 396#line 397#line 398#line 399

def any_child_ready (container):                            #line 400
    for child in  container.children:                       #line 401
        if child_is_ready ( child):                         #line 402
            return  True                                    #line 403#line 404#line 405
    return  False                                           #line 406#line 407#line 408

def child_is_ready (eh):                                    #line 409
    return (not ((0==len( eh.outq)))) or (not ((0==len( eh.inq)))) or ( eh.state!= "idle") or (any_child_ready ( eh))#line 410#line 411#line 412

def append_routing_descriptor (container,desc):             #line 413
    container.routings.append ( desc)                       #line 414#line 415#line 416

def container_injector (container,message):                 #line 417
    container_handler ( container, message)                 #line 418#line 419#line 420
                                                            #line 421#line 422#line 423
class Component_Registry:
    def __init__ (self,):                                   #line 424
        self.templates = {}                                 #line 425#line 426
                                                            #line 427
class Template:
    def __init__ (self,):                                   #line 428
        self.name =  None                                   #line 429
        self.template_data =  None                          #line 430
        self.instantiator =  None                           #line 431#line 432
                                                            #line 433
def mkTemplate (name,template_data,instantiator):           #line 434
    templ =  Template ()                                    #line 435
    templ.name =  name                                      #line 436
    templ.template_data =  template_data                    #line 437
    templ.instantiator =  instantiator                      #line 438
    return  templ                                           #line 439#line 440#line 441

def read_and_convert_json_file (pathname,filename):         #line 442

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
                                                            #line 443#line 444#line 445

def json2internal (pathname,container_xml):                 #line 446
    fname =  os.path.basename ( container_xml)              #line 447
    routings = read_and_convert_json_file ( pathname, fname)#line 448
    return  routings                                        #line 449#line 450#line 451

def delete_decls (d):                                       #line 452
    pass                                                    #line 453#line 454#line 455

def make_component_registry ():                             #line 456
    return  Component_Registry ()                           #line 457#line 458#line 459

def register_component (reg,template):
    return abstracted_register_component ( reg, template, False)#line 460

def register_component_allow_overwriting (reg,template):
    return abstracted_register_component ( reg, template, True)#line 461#line 462

def abstracted_register_component (reg,template,ok_to_overwrite):#line 463
    name = mangle_name ( template.name)                     #line 464
    if  reg!= None and  name in  reg.templates and not  ok_to_overwrite:#line 465
        load_error ( str( "Component /") +  str( template.name) +  "/ already declared"  )#line 466
        return  reg                                         #line 467
    else:                                                   #line 468
        reg.templates [name] =  template                    #line 469
        return  reg                                         #line 470#line 471#line 472#line 473

def get_component_instance (reg,full_name,owner):           #line 474
    template_name = mangle_name ( full_name)                #line 475
    if  template_name in  reg.templates:                    #line 476
        template =  reg.templates [template_name]           #line 477
        if ( template ==  None):                            #line 478
            load_error ( str( "Registry Error (A): Can't find component /") +  str( template_name) +  "/"  )#line 479
            return  None                                    #line 480
        else:                                               #line 481
            owner_name =  ""                                #line 482
            instance_name =  template_name                  #line 483
            if  None!= owner:                               #line 484
                owner_name =  owner.name                    #line 485
                instance_name =  str( owner_name) +  str( ".") +  template_name  #line 486
            else:                                           #line 487
                instance_name =  template_name              #line 488#line 489
            instance =  template.instantiator ( reg, owner, instance_name, template.template_data)#line 490
            return  instance                                #line 491#line 492
    else:                                                   #line 493
        load_error ( str( "Registry Error (B): Can't find component /") +  str( template_name) +  "/"  )#line 494
        return  None                                        #line 495#line 496#line 497#line 498

def dump_registry (reg):                                    #line 499
    nl ()                                                   #line 500
    print ( "*** PALETTE ***")                              #line 501
    for c in  reg.templates:                                #line 502
        print ( c.name)                                     #line 503
    print ( "***************")                              #line 504
    nl ()                                                   #line 505#line 506#line 507

def print_stats (reg):                                      #line 508
    print ( str( "registry statistics: ") +  reg.stats )    #line 509#line 510#line 511

def mangle_name (s):                                        #line 512
    # trim name to remove code from Container component names _ deferred until later (or never)#line 513
    return  s                                               #line 514#line 515#line 516
                                                            #line 517
# Data for an asyncronous component _ effectively, a function with input#line 518
# and output queues of messages.                            #line 519
#                                                           #line 520
# Components can either be a user_supplied function (“lea“), or a “container“#line 521
# that routes messages to child components according to a list of connections#line 522
# that serve as a message routing table.                    #line 523
#                                                           #line 524
# Child components themselves can be leaves or other containers.#line 525
#                                                           #line 526
# `handler` invokes the code that is attached to this component.#line 527
#                                                           #line 528
# `instance_data` is a pointer to instance data that the `leaf_handler`#line 529
# function may want whenever it is invoked again.           #line 530
#                                                           #line 531#line 532
# Eh_States :: enum { idle, active }                        #line 533
class Eh:
    def __init__ (self,):                                   #line 534
        self.name =  ""                                     #line 535
        self.inq =  deque ([])                              #line 536
        self.outq =  deque ([])                             #line 537
        self.owner =  None                                  #line 538
        self.children = []                                  #line 539
        self.visit_ordering =  deque ([])                   #line 540
        self.connections = []                               #line 541
        self.routings =  deque ([])                         #line 542
        self.handler =  None                                #line 543
        self.finject =  None                                #line 544
        self.instance_data =  None                          #line 545
        self.state =  "idle"                                #line 546# bootstrap debugging#line 547
        self.kind =  None # enum { container, leaf, }       #line 548#line 549
                                                            #line 550
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 551
# whose handler function is `container_handler`.            #line 552
def make_container (name,owner):                            #line 553
    eh =  Eh ()                                             #line 554
    eh.name =  name                                         #line 555
    eh.owner =  owner                                       #line 556
    eh.handler =  container_handler                         #line 557
    eh.finject =  container_injector                        #line 558
    eh.state =  "idle"                                      #line 559
    eh.kind =  "container"                                  #line 560
    return  eh                                              #line 561#line 562#line 563

# Creates a new leaf component out of a handler function, and a data parameter#line 564
# that will be passed back to your handler when called.     #line 565#line 566
def make_leaf (name,owner,instance_data,handler):           #line 567
    eh =  Eh ()                                             #line 568
    eh.name =  str( owner.name) +  str( ".") +  name        #line 569
    eh.owner =  owner                                       #line 570
    eh.handler =  handler                                   #line 571
    eh.instance_data =  instance_data                       #line 572
    eh.state =  "idle"                                      #line 573
    eh.kind =  "leaf"                                       #line 574
    return  eh                                              #line 575#line 576#line 577

# Sends a message on the given `port` with `data`, placing it on the output#line 578
# of the given component.                                   #line 579#line 580
def send (eh,port,datum,causingMessage):                    #line 581
    msg = make_message ( port, datum)                       #line 582
    put_output ( eh, msg)                                   #line 583#line 584#line 585

def send_string (eh,port,s,causingMessage):                 #line 586
    datum = new_datum_string ( s)                           #line 587
    msg = make_message ( port, datum)                       #line 588
    put_output ( eh, msg)                                   #line 589#line 590#line 591

def forward (eh,port,msg):                                  #line 592
    fwdmsg = make_message ( port, msg.datum)                #line 593
    put_output ( eh, fwdmsg)                                #line 594#line 595#line 596

def inject (eh,msg):                                        #line 597
    eh.finject ( eh, msg)                                   #line 598#line 599#line 600

# Returns a list of all output messages on a container.     #line 601
# For testing / debugging purposes.                         #line 602#line 603
def output_list (eh):                                       #line 604
    return  eh.outq                                         #line 605#line 606#line 607

# Utility for printing an array of messages.                #line 608
def print_output_list (eh):                                 #line 609
    print ( "{")                                            #line 610
    for m in  list ( eh.outq):                              #line 611
        print (format_message ( m))                         #line 612#line 613
    print ( "}")                                            #line 614#line 615#line 616

def spaces (n):                                             #line 617
    s =  ""                                                 #line 618
    for i in range( n):                                     #line 619
        s =  s+ " "                                         #line 620
    return  s                                               #line 621#line 622#line 623

def set_active (eh):                                        #line 624
    eh.state =  "active"                                    #line 625#line 626#line 627

def set_idle (eh):                                          #line 628
    eh.state =  "idle"                                      #line 629#line 630#line 631

# Utility for printing a specific output message.           #line 632#line 633
def fetch_first_output (eh,port):                           #line 634
    for msg in  list ( eh.outq):                            #line 635
        if ( msg.port ==  port):                            #line 636
            return  msg.datum                               #line 637
    return  None                                            #line 638#line 639#line 640

def print_specific_output (eh,port):                        #line 641
    # port ∷ “”                                             #line 642
    datum = fetch_first_output ( eh, port)                  #line 643
    print ( datum.v)                                        #line 644#line 645

def print_specific_output_to_stderr (eh,port):              #line 646
    # port ∷ “”                                             #line 647
    datum = fetch_first_output ( eh, port)                  #line 648
    # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 649
    print ( datum.v, file=sys.stderr)                       #line 650#line 651#line 652

def put_output (eh,msg):                                    #line 653
    eh.outq.append ( msg)                                   #line 654#line 655#line 656

root_project =  ""                                          #line 657
root_0D =  ""                                               #line 658#line 659
def set_environment (rproject,r0D):                         #line 660
    global root_project                                     #line 661
    global root_0D                                          #line 662
    root_project =  rproject                                #line 663
    root_0D =  r0D                                          #line 664#line 665#line 666
                                                            #line 667
def string_make_persistent (s):                             #line 668
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 669
    return  s                                               #line 670#line 671#line 672

def string_clone (s):                                       #line 673
    return  s                                               #line 674#line 675#line 676

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...#line 677
# where ${_00_} is the root directory for the project       #line 678
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)#line 679#line 680
def initialize_component_palette (root_project,root_0D,diagram_source_files):#line 681
    reg = make_component_registry ()                        #line 682
    for diagram_source in  diagram_source_files:            #line 683
        all_containers_within_single_file = json2internal ( root_project, diagram_source)#line 684
        reg = generate_shell_components ( reg, all_containers_within_single_file)#line 685
        for container in  all_containers_within_single_file:#line 686
            register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))#line 687#line 688#line 689
    initialize_stock_components ( reg)                      #line 690
    return  reg                                             #line 691#line 692#line 693

def print_error_maybe (main_container):                     #line 694
    error_port =  "✗"                                       #line 695
    err = fetch_first_output ( main_container, error_port)  #line 696
    if ( err!= None) and ( 0 < len (trimws ( err.v))):      #line 697
        print ( "___ !!! ERRORS !!! ___")                   #line 698
        print_specific_output ( main_container, error_port) #line 699#line 700#line 701#line 702

# debugging helpers                                         #line 703#line 704
def nl ():                                                  #line 705
    print ( "")                                             #line 706#line 707#line 708

def dump_outputs (main_container):                          #line 709
    nl ()                                                   #line 710
    print ( "___ Outputs ___")                              #line 711
    print_output_list ( main_container)                     #line 712#line 713#line 714

def trimws (s):                                             #line 715
    # remove whitespace from front and back of string       #line 716
    return  s.strip ()                                      #line 717#line 718#line 719

def clone_string (s):                                       #line 720
    return  s                                               #line 721#line 722#line 723

load_errors =  False                                        #line 724
runtime_errors =  False                                     #line 725#line 726
def load_error (s):                                         #line 727
    global load_errors                                      #line 728
    print ( s)                                              #line 729
    print ()                                                #line 730
    load_errors =  True                                     #line 731#line 732#line 733

def runtime_error (s):                                      #line 734
    global runtime_errors                                   #line 735
    print ( s)                                              #line 736
    runtime_errors =  True                                  #line 737#line 738#line 739

def fakepipename_instantiate (reg,owner,name,template_data):#line 740
    instance_name = gensymbol ( "fakepipe")                 #line 741
    return make_leaf ( instance_name, owner, None, fakepipename_handler)#line 742#line 743#line 744

rand =  0                                                   #line 745#line 746
def fakepipename_handler (eh,msg):                          #line 747
    global rand                                             #line 748
    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 749
    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)#line 750#line 751#line 752
                                                            #line 753
class Switch1star_Instance_Data:
    def __init__ (self,):                                   #line 754
        self.state =  "1"                                   #line 755#line 756
                                                            #line 757
def switch1star_instantiate (reg,owner,name,template_data): #line 758
    name_with_id = gensymbol ( "switch1*")                  #line 759
    instp =  Switch1star_Instance_Data ()                   #line 760
    return make_leaf ( name_with_id, owner, instp, switch1star_handler)#line 761#line 762#line 763

def switch1star_handler (eh,msg):                           #line 764
    inst =  eh.instance_data                                #line 765
    whichOutput =  inst.state                               #line 766
    if  "" ==  msg.port:                                    #line 767
        if  "1" ==  whichOutput:                            #line 768
            forward ( eh, "1", msg)                         #line 769
            inst.state =  "*"                               #line 770
        elif  "*" ==  whichOutput:                          #line 771
            forward ( eh, "*", msg)                         #line 772
        else:                                               #line 773
            send ( eh, "✗", "internal error bad state in switch1*", msg)#line 774#line 775
    elif  "reset" ==  msg.port:                             #line 776
        inst.state =  "1"                                   #line 777
    else:                                                   #line 778
        send ( eh, "✗", "internal error bad message for switch1*", msg)#line 779#line 780#line 781#line 782

class Latch_Instance_Data:
    def __init__ (self,):                                   #line 783
        self.datum =  None                                  #line 784#line 785
                                                            #line 786
def latch_instantiate (reg,owner,name,template_data):       #line 787
    name_with_id = gensymbol ( "latch")                     #line 788
    instp =  Latch_Instance_Data ()                         #line 789
    return make_leaf ( name_with_id, owner, instp, latch_handler)#line 790#line 791#line 792

def latch_handler (eh,msg):                                 #line 793
    inst =  eh.instance_data                                #line 794
    if  "" ==  msg.port:                                    #line 795
        inst.datum =  msg.datum                             #line 796
    elif  "release" ==  msg.port:                           #line 797
        d =  inst.datum                                     #line 798
        send ( eh, "", d, msg)                              #line 799
        inst.datum =  None                                  #line 800
    else:                                                   #line 801
        send ( eh, "✗", "internal error bad message for latch", msg)#line 802#line 803#line 804#line 805

# all of the the built_in leaves are listed here            #line 806
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 807#line 808
def initialize_stock_components (reg):                      #line 809
    register_component ( reg,mkTemplate ( "1then2", None, deracer_instantiate))#line 810
    register_component ( reg,mkTemplate ( "?A", None, probeA_instantiate))#line 811
    register_component ( reg,mkTemplate ( "?B", None, probeB_instantiate))#line 812
    register_component ( reg,mkTemplate ( "?C", None, probeC_instantiate))#line 813
    register_component ( reg,mkTemplate ( "trash", None, trash_instantiate))#line 814#line 815
    register_component ( reg,mkTemplate ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 816
    register_component ( reg,mkTemplate ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 817#line 818
    register_component ( reg,mkTemplate ( "syncfilewrite", None, syncfilewrite_instantiate))#line 819
    register_component ( reg,mkTemplate ( "stringconcat", None, stringconcat_instantiate))#line 820
    register_component ( reg,mkTemplate ( "switch1*", None, switch1star_instantiate))#line 821
    register_component ( reg,mkTemplate ( "latch", None, latch_instantiate))#line 822
    # for fakepipe                                          #line 823
    register_component ( reg,mkTemplate ( "fakepipename", None, fakepipename_instantiate))#line 824#line 825#line 826

def argv ():                                                #line 827
    return  sys.argv                                        #line 828#line 829#line 830

def initialize ():                                          #line 831
    root_of_project =  sys.argv[ 1]                         #line 832
    root_of_0D =  sys.argv[ 2]                              #line 833
    arg =  sys.argv[ 3]                                     #line 834
    main_container_name =  sys.argv[ 4]                     #line 835
    diagram_names =  sys.argv[ 5:]                          #line 836
    palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)#line 837
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 838#line 839#line 840

def start (palette,env):
    start_helper ( palette, env, False)                     #line 841

def start_show_all (palette,env):
    start_helper ( palette, env, True)                      #line 842

def start_helper (palette,env,show_all_outputs):            #line 843
    root_of_project =  env [ 0]                             #line 844
    root_of_0D =  env [ 1]                                  #line 845
    main_container_name =  env [ 2]                         #line 846
    diagram_names =  env [ 3]                               #line 847
    arg =  env [ 4]                                         #line 848
    set_environment ( root_of_project, root_of_0D)          #line 849
    # get entrypoint container                              #line 850
    main_container = get_component_instance ( palette, main_container_name, None)#line 851
    if  None ==  main_container:                            #line 852
        load_error ( str( "Couldn't find container with page name /") +  str( main_container_name) +  str( "/ in files ") +  str(str ( diagram_names)) +  " (check tab names, or disable compression?)"    )#line 856#line 857
    if not  load_errors:                                    #line 858
        marg = new_datum_string ( arg)                      #line 859
        msg = make_message ( "", marg)                      #line 860
        inject ( main_container, msg)                       #line 861
        if  show_all_outputs:                               #line 862
            dump_outputs ( main_container)                  #line 863
        else:                                               #line 864
            print_error_maybe ( main_container)             #line 865
            outp = fetch_first_output ( main_container, "") #line 866
            if  None ==  outp:                              #line 867
                print ( "«««no outputs»»»)")                #line 868
            else:                                           #line 869
                print_specific_output ( main_container, "") #line 870#line 871#line 872
        if  show_all_outputs:                               #line 873
            print ( "--- done ---")                         #line 874#line 875#line 876#line 877#line 878
                                                            #line 879
# utility functions                                         #line 880
def send_int (eh,port,i,causing_message):                   #line 881
    datum = new_datum_string (str ( i))                     #line 882
    send ( eh, port, datum, causing_message)                #line 883#line 884#line 885

def send_bang (eh,port,causing_message):                    #line 886
    datum = new_datum_bang ()                               #line 887
    send ( eh, port, datum, causing_message)                #line 888#line 889







def probeA_instantiate (reg,owner,name,template_data):      #line 1
    name_with_id = gensymbol ( "?A")                        #line 2
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 3#line 4#line 5

def probeB_instantiate (reg,owner,name,template_data):      #line 6
    name_with_id = gensymbol ( "?B")                        #line 7
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 8#line 9#line 10

def probeC_instantiate (reg,owner,name,template_data):      #line 11
    name_with_id = gensymbol ( "?C")                        #line 12
    return make_leaf ( name_with_id, owner, None, probe_handler)#line 13#line 14#line 15

def probe_handler (eh,msg):                                 #line 16
    s =  msg.datum.v                                        #line 17
    print ( str( "... probe ") +  str( eh.name) +  str( ": ") +  s   , file=sys.stderr)#line 18#line 19#line 20

def trash_instantiate (reg,owner,name,template_data):       #line 21
    name_with_id = gensymbol ( "trash")                     #line 22
    return make_leaf ( name_with_id, owner, None, trash_handler)#line 23#line 24#line 25

def trash_handler (eh,msg):                                 #line 26
    # to appease dumped_on_floor checker                    #line 27
    pass                                                    #line 28#line 29

class TwoMessages:
    def __init__ (self,):                                   #line 30
        self.firstmsg =  None                               #line 31
        self.secondmsg =  None                              #line 32#line 33
                                                            #line 34
# Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg }#line 35
class Deracer_Instance_Data:
    def __init__ (self,):                                   #line 36
        self.state =  None                                  #line 37
        self.buffer =  None                                 #line 38#line 39
                                                            #line 40
def reclaim_Buffers_from_heap (inst):                       #line 41
    pass                                                    #line 42#line 43#line 44

def deracer_instantiate (reg,owner,name,template_data):     #line 45
    name_with_id = gensymbol ( "deracer")                   #line 46
    inst =  Deracer_Instance_Data ()                        #line 47
    inst.state =  "idle"                                    #line 48
    inst.buffer =  TwoMessages ()                           #line 49
    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)#line 50
    return  eh                                              #line 51#line 52#line 53

def send_firstmsg_then_secondmsg (eh,inst):                 #line 54
    forward ( eh, "1", inst.buffer.firstmsg)                #line 55
    forward ( eh, "2", inst.buffer.secondmsg)               #line 56
    reclaim_Buffers_from_heap ( inst)                       #line 57#line 58#line 59

def deracer_handler (eh,msg):                               #line 60
    inst =  eh.instance_data                                #line 61
    if  inst.state ==  "idle":                              #line 62
        if  "1" ==  msg.port:                               #line 63
            inst.buffer.firstmsg =  msg                     #line 64
            inst.state =  "waitingForSecondmsg"             #line 65
        elif  "2" ==  msg.port:                             #line 66
            inst.buffer.secondmsg =  msg                    #line 67
            inst.state =  "waitingForFirstmsg"              #line 68
        else:                                               #line 69
            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg.port )#line 70#line 71
    elif  inst.state ==  "waitingForFirstmsg":              #line 72
        if  "1" ==  msg.port:                               #line 73
            inst.buffer.firstmsg =  msg                     #line 74
            send_firstmsg_then_secondmsg ( eh, inst)        #line 75
            inst.state =  "idle"                            #line 76
        else:                                               #line 77
            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg.port )#line 78#line 79
    elif  inst.state ==  "waitingForSecondmsg":             #line 80
        if  "2" ==  msg.port:                               #line 81
            inst.buffer.secondmsg =  msg                    #line 82
            send_firstmsg_then_secondmsg ( eh, inst)        #line 83
            inst.state =  "idle"                            #line 84
        else:                                               #line 85
            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg.port )#line 86#line 87
    else:                                                   #line 88
        runtime_error ( "bad state for deracer {eh.state}") #line 89#line 90#line 91#line 92

def low_level_read_text_file_instantiate (reg,owner,name,template_data):#line 93
    name_with_id = gensymbol ( "Low Level Read Text File")  #line 94
    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 95#line 96#line 97

def low_level_read_text_file_handler (eh,msg):              #line 98
    fname =  msg.datum.v                                    #line 99

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
                                                            #line 100#line 101#line 102

def ensure_string_datum_instantiate (reg,owner,name,template_data):#line 103
    name_with_id = gensymbol ( "Ensure String Datum")       #line 104
    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)#line 105#line 106#line 107

def ensure_string_datum_handler (eh,msg):                   #line 108
    if  "string" ==  msg.datum.kind ():                     #line 109
        forward ( eh, "", msg)                              #line 110
    else:                                                   #line 111
        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum #line 112
        send_string ( eh, "✗", emsg, msg)                   #line 113#line 114#line 115#line 116

class Syncfilewrite_Data:
    def __init__ (self,):                                   #line 117
        self.filename =  ""                                 #line 118#line 119
                                                            #line 120
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)#line 121
def syncfilewrite_instantiate (reg,owner,name,template_data):#line 122
    name_with_id = gensymbol ( "syncfilewrite")             #line 123
    inst =  Syncfilewrite_Data ()                           #line 124
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)#line 125#line 126#line 127

def syncfilewrite_handler (eh,msg):                         #line 128
    inst =  eh.instance_data                                #line 129
    if  "filename" ==  msg.port:                            #line 130
        inst.filename =  msg.datum.v                        #line 131
    elif  "input" ==  msg.port:                             #line 132
        contents =  msg.datum.v                             #line 133
        f = open ( inst.filename, "w")                      #line 134
        if  f!= None:                                       #line 135
            f.write ( msg.datum.v)                          #line 136
            f.close ()                                      #line 137
            send ( eh, "done",new_datum_bang (), msg)       #line 138
        else:                                               #line 139
            send_string ( eh, "✗", str( "open error on file ") +  inst.filename , msg)#line 140#line 141#line 142#line 143#line 144

class StringConcat_Instance_Data:
    def __init__ (self,):                                   #line 145
        self.buffer1 =  ""                                  #line 146
        self.buffer2 =  ""                                  #line 147
        self.scount =  0                                    #line 148#line 149
                                                            #line 150
def stringconcat_instantiate (reg,owner,name,template_data):#line 151
    name_with_id = gensymbol ( "stringconcat")              #line 152
    instp =  StringConcat_Instance_Data ()                  #line 153
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)#line 154#line 155#line 156

def stringconcat_handler (eh,msg):                          #line 157
    inst =  eh.instance_data                                #line 158
    if  "1" ==  msg.port:                                   #line 159
        inst.buffer1 = clone_string ( msg.datum.v)          #line 160
        inst.scount =  inst.scount+ 1                       #line 161
        maybe_stringconcat ( eh, inst, msg)                 #line 162
    elif  "2" ==  msg.port:                                 #line 163
        inst.buffer2 = clone_string ( msg.datum.v)          #line 164
        inst.scount =  inst.scount+ 1                       #line 165
        maybe_stringconcat ( eh, inst, msg)                 #line 166
    else:                                                   #line 167
        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg.port )#line 168#line 169#line 170#line 171

def maybe_stringconcat (eh,inst,msg):                       #line 172
    if  inst.scount >=  2:                                  #line 173
        concatenated_string =  ""                           #line 174
        if  0 == len ( inst.buffer1):                       #line 175
            concatenated_string =  inst.buffer2             #line 176
        elif  0 == len ( inst.buffer2):                     #line 177
            concatenated_string =  inst.buffer1             #line 178
        else:                                               #line 179
            concatenated_string =  inst.buffer1+ inst.buffer2#line 180#line 181
        send_string ( eh, "", concatenated_string, msg)     #line 182
        inst.buffer1 =  ""                                  #line 183
        inst.buffer2 =  ""                                  #line 184
        inst.scount =  0                                    #line 185#line 186#line 187#line 188

#                                                           #line 189#line 190
def string_constant_instantiate (reg,owner,name,template_data):#line 191
    global root_project                                     #line 192
    global root_0D                                          #line 193
    name_with_id = gensymbol ( "strconst")                  #line 194
    s =  template_data                                      #line 195
    if  root_project!= "":                                  #line 196
        s = re.sub ( "_00_",  root_project,  s)             #line 197#line 198
    if  root_0D!= "":                                       #line 199
        s = re.sub ( "_0D_",  root_0D,  s)                  #line 200#line 201
    return make_leaf ( name_with_id, owner, s, string_constant_handler)#line 202#line 203#line 204

def string_constant_handler (eh,msg):                       #line 205
    s =  eh.instance_data                                   #line 206
    send_string ( eh, "", s, msg)                           #line 207#line 208







# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 1
def shell_out_instantiate (reg,owner,name,template_data):   #line 2
    name_with_id = gensymbol ( "shell_out")                 #line 3
    cmd = shlex.split ( template_data)                      #line 4
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)#line 5#line 6#line 7

def shell_out_handler (eh,msg):                             #line 8
    cmd =  eh.instance_data                                 #line 9
    s =  msg.datum.v                                        #line 10
    ret =  None                                             #line 11
    rc =  None                                              #line 12
    stdout =  None                                          #line 13
    stderr =  None                                          #line 14

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
                                                            #line 15
    if  rc!= 0:                                             #line 16
        send_string ( eh, "✗", stderr, msg)                 #line 17
    else:                                                   #line 18
        send_string ( eh, "", stdout, msg)                  #line 19#line 20#line 21#line 22

def generate_shell_components (reg,container_list):         #line 23
    # [                                                     #line 24
    #     {;file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 25
    #     {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []}#line 26
    # ]                                                     #line 27
    if  None!= container_list:                              #line 28
        for diagram in  container_list:                     #line 29
            # loop through every component in the diagram and look for names that start with “$“ or “'“ #line 30
            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 31
            for child_descriptor in  diagram [ "children"]: #line 32
                if first_char_is ( child_descriptor [ "name"], "$"):#line 33
                    name =  child_descriptor [ "name"]      #line 34
                    cmd =   name[1:] .strip ()              #line 35
                    generated_leaf = mkTemplate ( name, cmd, shell_out_instantiate)#line 36
                    register_component ( reg, generated_leaf)#line 37
                elif first_char_is ( child_descriptor [ "name"], "'"):#line 38
                    name =  child_descriptor [ "name"]      #line 39
                    s =   name[1:]                          #line 40
                    generated_leaf = mkTemplate ( name, s, string_constant_instantiate)#line 41
                    register_component_allow_overwriting ( reg, generated_leaf)#line 42#line 43#line 44#line 45#line 46
    return  reg                                             #line 47#line 48#line 49

def first_char (s):                                         #line 50
    return   s[0]                                           #line 51#line 52#line 53

def first_char_is (s,c):                                    #line 54
    return  c == first_char ( s)                            #line 55#line 56#line 57
                                                            #line 58
# TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 59
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 60#line 61






count_counter =  0                                          #line 1
count_direction =  1                                        #line 2#line 3
def count_handler (eh,msg):                                 #line 4
    global count_counter, count_direction                   #line 5
    if  msg.port ==  "adv":                                 #line 6
        count_counter =  count_counter+ count_direction     #line 7
        send_int ( eh, "", count_counter, msg)              #line 8
    elif  msg.port ==  "rev":                               #line 9
        count_direction = - count_direction                 #line 10#line 11#line 12#line 13

def count_instantiator (reg,owner,name,template_data):      #line 14
    name_with_id = gensymbol ( "Count")                     #line 15
    return make_leaf ( name_with_id, owner, None, count_handler)#line 16#line 17#line 18

def count_install (reg):                                    #line 19
    register_component ( reg,mkTemplate ( "Count", None, count_instantiator))#line 20#line 21







def decode_install (reg):                                   #line 1
    register_component ( reg,mkTemplate ( "Decode", None, decode_instantiator))#line 2#line 3#line 4

def decode_handler (eh,msg):                                #line 5
    global decode_digits                                    #line 6
    s =  msg.datum.v                                        #line 7
    i = int ( s)                                            #line 8
    if  i >=  0 and  i <=  9:                               #line 9
        send_string ( eh, s, s, msg)                        #line 10#line 11
    send_bang ( eh, "done", msg)                            #line 12#line 13#line 14

def decode_instantiator (reg,owner,name,template_data):     #line 15
    name_with_id = gensymbol ( "Decode")                    #line 16
    return make_leaf ( name_with_id, owner, None, decode_handler)#line 17







def reverser_install (reg):                                 #line 1
    register_component ( reg,mkTemplate ( "Reverser", None, reverser_instantiator))#line 2#line 3#line 4

reverser_state =  "J"                                       #line 5#line 6
def reverser_handler (eh,msg):                              #line 7
    global reverser_state                                   #line 8
    if  reverser_state ==  "K":                             #line 9
        if  msg.port ==  "J":                               #line 10
            send_bang ( eh, "", msg)                        #line 11
            reverser_state =  "J"                           #line 12
        else:                                               #line 13
            pass                                            #line 14#line 15
    elif  reverser_state ==  "J":                           #line 16
        if  msg.port ==  "K":                               #line 17
            send_bang ( eh, "", msg)                        #line 18
            reverser_state =  "K"                           #line 19
        else:                                               #line 20
            pass                                            #line 21#line 22#line 23#line 24#line 25

def reverser_instantiator (reg,owner,name,template_data):   #line 26
    name_with_id = gensymbol ( "Reverser")                  #line 27
    return make_leaf ( name_with_id, owner, None, reverser_handler)#line 28#line 29







def delay_install (reg):                                    #line 1
    register_component ( reg,mkTemplate ( "Delay", None, delay_instantiator))#line 2#line 3#line 4

class Delay_Info:
    def __init__ (self,):                                   #line 5
        self.counter =  0                                   #line 6
        self.saved_message =  None                          #line 7#line 8
                                                            #line 9
def delay_instantiator (reg,owner,name,template_data):      #line 10
    name_with_id = gensymbol ( "delay")                     #line 11
    info =  Delay_Info ()                                   #line 12
    return make_leaf ( name_with_id, owner, info, delay_handler)#line 13#line 14#line 15

DELAYDELAY =  5000                                          #line 16#line 17
def first_time (m):                                         #line 18
    return not is_tick ( m)                                 #line 19#line 20#line 21

def delay_handler (eh,msg):                                 #line 22
    info =  eh.instance_data                                #line 23
    if first_time ( msg):                                   #line 24
        info.saved_message =  msg                           #line 25
        set_active ( eh)
        # tell engine to keep running this component with ;ticks' #line 26#line 27#line 28
    count =  info.counter                                   #line 29
    next =  count+ 1                                        #line 30
    if  info.counter >=  DELAYDELAY:                        #line 31
        set_idle ( eh)
        # tell engine that we're finally done               #line 32
        forward ( eh, "", info.saved_message)               #line 33
        next =  0                                           #line 34#line 35
    info.counter =  next                                    #line 36#line 37#line 38







def monitor_install (reg):                                  #line 1
    register_component ( reg,mkTemplate ( "@", None, monitor_instantiator))#line 2#line 3#line 4

def monitor_instantiator (reg,owner,name,template_data):    #line 5
    name_with_id = gensymbol ( "@")                         #line 6
    return make_leaf ( name_with_id, owner, None, monitor_handler)#line 7#line 8#line 9

def monitor_handler (eh,msg):                               #line 10
    s =  msg.datum.v                                        #line 11
    i = int ( s)                                            #line 12
    while  i >  0:                                          #line 13
        s =  str( " ") +  s                                 #line 14
        i =  i- 1                                           #line 15#line 16
    print ( s)                                              #line 17#line 18





