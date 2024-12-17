

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
        return  str( "%5C“") +  str( m.port) +  str( "%5C”:%5C“") +  str( "ϕ") +  "%5C”,"    #line 118
    else:                                                   #line 119
        return  str( "%5C“") +  str( m.port) +  str( "%5C”:%5C“") +  str( m.datum.v) +  "%5C”,"    #line 120#line 121#line 122#line 123

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
        print ( str( "internal error: .Up connection source not ok ") + ( proto_conn [ "source"]) [ "name"] )#line 168
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





