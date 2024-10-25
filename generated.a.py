

counter =  0                                                                    #line 1
                                                                                #line 2

digits = [                                                                      #line 3
"₀", "₁", "₂", "₃", "₄", "₅",                                                   #line 4
"₆", "₇", "₈", "₉",                                                             #line 5
"₁₀", "₁₁", "₁₂", "₁₃", "₁₄",                                                   #line 6
"₁₅", "₁₆", "₁₇", "₁₈", "₁₉",                                                   #line 7
"₂₀", "₂₁", "₂₂", "₂₃", "₂₄",                                                   #line 8
"₂₅", "₂₆", "₂₇", "₂₈", "₂₉"]                                                   #line 9
                                                                                #line 10
                                                                                #line 11

def gensymbol (s):                                                              #line 12

    global counter                                                              #line 13

    name_with_id =  str( s) + subscripted_digit ( counter)                      #line 14

    counter =  counter+ 1                                                       #line 15

    return  name_with_id                                                        #line 16
                                                                                #line 17

                                                                                #line 18

def subscripted_digit (n):                                                      #line 19

    global digits                                                               #line 20

    if ( n >=  0 and  n <=  29):                                                #line 21

        return  digits [ n]                                                     #line 22

    else:                                                                       #line 23

        return  str( "₊") +  n                                                  #line 24
                                                                                #line 25

                                                                                #line 26

                                                                                #line 27

class Datum:
    def __init__ (self,):                                                       #line 28

        self.data =  None                                                       #line 29

        self.clone =  None                                                      #line 30

        self.reclaim =  None                                                    #line 31

        self.srepr =  None                                                      #line 32

        self.kind =  None                                                       #line 33

        self.raw =  None                                                        #line 34
                                                                                #line 35

                                                                                #line 36

def new_datum_string (s):                                                       #line 37

    d =  Datum ()                                                               #line 38

    d. data =  s                                                                #line 39

    d. clone =  lambda : clone_datum_string ( d)                                #line 40

    d. reclaim =  lambda : reclaim_datum_string ( d)                            #line 41

    d. srepr =  lambda : srepr_datum_string ( d)                                #line 42

    d. raw =  lambda : raw_datum_string ( d)                                    #line 43

    d. kind =  lambda :  "string"                                               #line 44

    return  d                                                                   #line 45
                                                                                #line 46

                                                                                #line 47

def clone_datum_string (d):                                                     #line 48

    d = new_datum_string ( d. data)                                             #line 49

    return  d                                                                   #line 50
                                                                                #line 51

                                                                                #line 52

def reclaim_datum_string (src):                                                 #line 53

    pass                                                                        #line 54
                                                                                #line 55

                                                                                #line 56

def srepr_datum_string (d):                                                     #line 57

    return  d. data                                                             #line 58
                                                                                #line 59

                                                                                #line 60

def raw_datum_string (d):                                                       #line 61

    return bytearray ( d. data, "UTF_8")                                        #line 62
                                                                                #line 63

                                                                                #line 64

def new_datum_bang ():                                                          #line 65

    p = Datum ()                                                                #line 66

    p. data =  True                                                             #line 67

    p. clone =  lambda : clone_datum_bang ( p)                                  #line 68

    p. reclaim =  lambda : reclaim_datum_bang ( p)                              #line 69

    p. srepr =  lambda : srepr_datum_bang ()                                    #line 70

    p. raw =  lambda : raw_datum_bang ()                                        #line 71

    p. kind =  lambda :  "bang"                                                 #line 72

    return  p                                                                   #line 73
                                                                                #line 74

                                                                                #line 75

def clone_datum_bang (d):                                                       #line 76

    return new_datum_bang ()                                                    #line 77
                                                                                #line 78

                                                                                #line 79

def reclaim_datum_bang (d):                                                     #line 80

    pass                                                                        #line 81
                                                                                #line 82

                                                                                #line 83

def srepr_datum_bang ():                                                        #line 84

    return  "!"                                                                 #line 85
                                                                                #line 86

                                                                                #line 87

def raw_datum_bang ():                                                          #line 88

    return []                                                                   #line 89
                                                                                #line 90

                                                                                #line 91

def new_datum_tick ():                                                          #line 92

    p = new_datum_bang ()                                                       #line 93

    p. kind =  lambda :  "tick"                                                 #line 94

    p. clone =  lambda : new_datum_tick ()                                      #line 95

    p. srepr =  lambda : srepr_datum_tick ()                                    #line 96

    p. raw =  lambda : raw_datum_tick ()                                        #line 97

    return  p                                                                   #line 98
                                                                                #line 99

                                                                                #line 100

def srepr_datum_tick ():                                                        #line 101

    return  "."                                                                 #line 102
                                                                                #line 103

                                                                                #line 104

def raw_datum_tick ():                                                          #line 105

    return []                                                                   #line 106
                                                                                #line 107

                                                                                #line 108

def new_datum_bytes (b):                                                        #line 109

    p = Datum ()                                                                #line 110

    p. data =  b                                                                #line 111

    p. clone =  lambda : clone_datum_bytes ( p)                                 #line 112

    p. reclaim =  lambda : reclaim_datum_bytes ( p)                             #line 113

    p. srepr =  lambda : srepr_datum_bytes ( b)                                 #line 114

    p. raw =  lambda : raw_datum_bytes ( b)                                     #line 115

    p. kind =  lambda :  "bytes"                                                #line 116

    return  p                                                                   #line 117
                                                                                #line 118

                                                                                #line 119

def clone_datum_bytes (src):                                                    #line 120

    p = Datum ()                                                                #line 121

    p. clone =  src. clone                                                      #line 122

    p. reclaim =  src. reclaim                                                  #line 123

    p. srepr =  src. srepr                                                      #line 124

    p. raw =  src. raw                                                          #line 125

    p. kind =  src. kind                                                        #line 126

    p. data =  src.clone ()                                                     #line 127

    return  p                                                                   #line 128
                                                                                #line 129

                                                                                #line 130

def reclaim_datum_bytes (src):                                                  #line 131

    pass                                                                        #line 132
                                                                                #line 133

                                                                                #line 134

def srepr_datum_bytes (d):                                                      #line 135

    return  d. data.decode ( "UTF_8")                                           #line 136
                                                                                #line 137


def raw_datum_bytes (d):                                                        #line 138

    return  d. data                                                             #line 139
                                                                                #line 140

                                                                                #line 141

def new_datum_handle (h):                                                       #line 142

    return new_datum_int ( h)                                                   #line 143
                                                                                #line 144

                                                                                #line 145

def new_datum_int (i):                                                          #line 146

    p = Datum ()                                                                #line 147

    p. data =  i                                                                #line 148

    p. clone =  lambda : clone_int ( i)                                         #line 149

    p. reclaim =  lambda : reclaim_int ( i)                                     #line 150

    p. srepr =  lambda : srepr_datum_int ( i)                                   #line 151

    p. raw =  lambda : raw_datum_int ( i)                                       #line 152

    p. kind =  lambda :  "int"                                                  #line 153

    return  p                                                                   #line 154
                                                                                #line 155

                                                                                #line 156

def clone_int (i):                                                              #line 157

    p = new_datum_int ( i)                                                      #line 158

    return  p                                                                   #line 159
                                                                                #line 160

                                                                                #line 161

def reclaim_int (src):                                                          #line 162

    pass                                                                        #line 163
                                                                                #line 164

                                                                                #line 165

def srepr_datum_int (i):                                                        #line 166

    return str ( i)                                                             #line 167
                                                                                #line 168

                                                                                #line 169

def raw_datum_int (i):                                                          #line 170

    return  i                                                                   #line 171
                                                                                #line 172

                                                                                #line 173
# Message passed to a leaf component.                                           #line 174
#                                                                               #line 175
# `port` refers to the name of the incoming or outgoing port of this component. #line 176
# `datum` is the data attached to this message.                                 #line 177

class Message:
    def __init__ (self,port,datum):                                             #line 178

        self.port =  port                                                       #line 179

        self.datum =  datum                                                     #line 180
                                                                                #line 181

                                                                                #line 182

def clone_port (s):                                                             #line 183

    return clone_string ( s)                                                    #line 184
                                                                                #line 185

                                                                                #line 186
# Utility for making a `Message`. Used to safely “seed“ messages                #line 187
# entering the very top of a network.                                           #line 188

def make_message (port,datum):                                                  #line 189

    p = clone_string ( port)                                                    #line 190

    m = Message ( p, datum.clone ())                                            #line 191

    return  m                                                                   #line 192
                                                                                #line 193

                                                                                #line 194
# Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations.#line 195

def message_clone (message):                                                    #line 196

    m = Message (clone_port ( message. port), message. datum.clone ())          #line 197

    return  m                                                                   #line 198
                                                                                #line 199

                                                                                #line 200
# Frees a message.                                                              #line 201

def destroy_message (msg):                                                      #line 202

    # during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages#line 203

    pass                                                                        #line 204
                                                                                #line 205

                                                                                #line 206

def destroy_datum (msg):                                                        #line 207

    pass                                                                        #line 208
                                                                                #line 209

                                                                                #line 210

def destroy_port (msg):                                                         #line 211

    pass                                                                        #line 212
                                                                                #line 213

                                                                                #line 214
#                                                                               #line 215

def format_message (m):                                                         #line 216

    if  m ==  None:                                                             #line 217

        return  "ϕ"                                                             #line 218

    else:                                                                       #line 219

        return  str( "⟪") +  str( m. port) +  str( "⦂") +  str( m. datum.srepr ()) +  "⟫"    #line 223
                                                                                #line 224

                                                                                #line 225

                                                                                #line 226
                                                                                #line 227

enumDown =  0                                                                   #line 228

enumAcross =  1                                                                 #line 229

enumUp =  2                                                                     #line 230

enumThrough =  3                                                                #line 231
                                                                                #line 232

def container_instantiator (reg,owner,container_name,desc):                     #line 233

    global enumDown, enumUp, enumAcross, enumThrough                            #line 234

    container = make_container ( container_name, owner)                         #line 235

    children = []                                                               #line 236

    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here#line 237

    # collect children                                                          #line 238

    for child_desc in  desc ["children"]:                                       #line 239

        child_instance = get_component_instance ( reg, child_desc ["name"], container)#line 240

        children.append ( child_instance)                                       #line 241

        children_by_id [ child_desc ["id"]] =  child_instance                   #line 242


    container. children =  children                                             #line 243

    me =  container                                                             #line 244
                                                                                #line 245

    connectors = []                                                             #line 246

    for proto_conn in  desc ["connections"]:                                    #line 247

        connector = Connector ()                                                #line 248

        if  proto_conn ["dir"] ==  enumDown:                                    #line 249

            # JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 250

            connector. direction =  "down"                                      #line 251

            connector. sender = Sender ( me. name, me, proto_conn ["source_port"])#line 252

            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 253

            if ( target_component ==  None):                                    #line 254

                load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn ["target"] )#line 255

            else:                                                               #line 256

                connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)#line 257

                connectors.append ( connector)
                                                                                #line 258

        elif  proto_conn ["dir"] ==  enumAcross:                                #line 259

            connector. direction =  "across"                                    #line 260

            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 261

            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 262

            if  source_component ==  None:                                      #line 263

                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn ["source"] )#line 264

            else:                                                               #line 265

                connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])#line 266

                if  target_component ==  None:                                  #line 267

                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn. target )#line 268

                else:                                                           #line 269

                    connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)#line 270

                    connectors.append ( connector)

                                                                                #line 271

        elif  proto_conn ["dir"] ==  enumUp:                                    #line 272

            connector. direction =  "up"                                        #line 273

            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 274

            if  source_component ==  None:                                      #line 275

                print ( str( "internal error: .Up connection source not ok ") +  proto_conn ["source"] )#line 276

            else:                                                               #line 277

                connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])#line 278

                connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)#line 279

                connectors.append ( connector)
                                                                                #line 280

        elif  proto_conn ["dir"] ==  enumThrough:                               #line 281

            connector. direction =  "through"                                   #line 282

            connector. sender = Sender ( me. name, me, proto_conn ["source_port"])#line 283

            connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)#line 284

            connectors.append ( connector)
                                                                                #line 285

                                                                                #line 286

    container. connections =  connectors                                        #line 287

    return  container                                                           #line 288
                                                                                #line 289

                                                                                #line 290
# The default handler for container components.                                 #line 291

def container_handler (container,message):                                      #line 292

    route ( container, container, message)
    # references to 'self' are replaced by the container during instantiation   #line 293

    while any_child_ready ( container):                                         #line 294

        step_children ( container, message)                                     #line 295

                                                                                #line 296

                                                                                #line 297
# Frees the given container and associated data.                                #line 298

def destroy_container (eh):                                                     #line 299

    pass                                                                        #line 300
                                                                                #line 301

                                                                                #line 302

def fifo_is_empty (fifo):                                                       #line 303

    return  fifo.empty ()                                                       #line 304
                                                                                #line 305

                                                                                #line 306
# Routing connection for a container component. The `direction` field has       #line 307
# no affect on the default message routing system _ it is there for debugging   #line 308
# purposes, or for reading by other tools.                                      #line 309
                                                                                #line 310

class Connector:
    def __init__ (self,):                                                       #line 311

        self.direction =  None # down, across, up, through                      #line 312

        self.sender =  None                                                     #line 313

        self.receiver =  None                                                   #line 314
                                                                                #line 315

                                                                                #line 316
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,  #line 317
# based on component ID (pointer) and port name.                                #line 318
                                                                                #line 319

class Sender:
    def __init__ (self,name,component,port):                                    #line 320

        self.name =  name                                                       #line 321

        self.component =  component # from                                      #line 322

        self.port =  port # from's port                                         #line 323
                                                                                #line 324

                                                                                #line 325
# `Receiver` is a handle to a destination queue, and a `port` name to assign    #line 326
# to incoming messages to this queue.                                           #line 327
                                                                                #line 328

class Receiver:
    def __init__ (self,name,queue,port,component):                              #line 329

        self.name =  name                                                       #line 330

        self.queue =  queue # queue (input | output) of receiver                #line 331

        self.port =  port # destination port                                    #line 332

        self.component =  component # to (for bootstrap debug)                  #line 333
                                                                                #line 334

                                                                                #line 335
# Checks if two senders match, by pointer equality and port name matching.      #line 336

def sender_eq (s1,s2):                                                          #line 337

    same_components = ( s1. component ==  s2. component)                        #line 338

    same_ports = ( s1. port ==  s2. port)                                       #line 339

    return  same_components and  same_ports                                     #line 340
                                                                                #line 341

                                                                                #line 342
# Delivers the given message to the receiver of this connector.                 #line 343
                                                                                #line 344

def deposit (parent,conn,message):                                              #line 345

    new_message = make_message ( conn. receiver. port, message. datum)          #line 346

    push_message ( parent, conn. receiver. component, conn. receiver. queue, new_message)#line 347
                                                                                #line 348

                                                                                #line 349

def force_tick (parent,eh):                                                     #line 350

    tick_msg = make_message ( ".",new_datum_tick ())                            #line 351

    push_message ( parent, eh, eh. inq, tick_msg)                               #line 352

    return  tick_msg                                                            #line 353
                                                                                #line 354

                                                                                #line 355

def push_message (parent,receiver,inq,m):                                       #line 356

    inq.put ( m)                                                                #line 357

    parent. visit_ordering.put ( receiver)                                      #line 358
                                                                                #line 359

                                                                                #line 360

def is_self (child,container):                                                  #line 361

    # in an earlier version “self“ was denoted as ϕ                             #line 362

    return  child ==  container                                                 #line 363
                                                                                #line 364

                                                                                #line 365

def step_child (child,msg):                                                     #line 366

    before_state =  child. state                                                #line 367

    child.handler ( child, msg)                                                 #line 368

    after_state =  child. state                                                 #line 369

    return [ before_state ==  "idle" and  after_state!= "idle",                 #line 370
    before_state!= "idle" and  after_state!= "idle",                            #line 371
    before_state!= "idle" and  after_state ==  "idle"]                          #line 372
                                                                                #line 373

                                                                                #line 374

def save_message (eh,msg):                                                      #line 375

    eh. saved_messages.put ( msg)                                               #line 376
                                                                                #line 377

                                                                                #line 378

def fetch_saved_message_and_clear (eh):                                         #line 379

    return  eh. saved_messages.get ()                                           #line 380
                                                                                #line 381

                                                                                #line 382

def step_children (container,causingMessage):                                   #line 383

    container. state =  "idle"                                                  #line 384

    for child in list ( container. visit_ordering. queue):                      #line 385

        # child = container represents self, skip it                            #line 386

        if (not (is_self ( child, container))):                                 #line 387

            if (not ( child. inq.empty ())):                                    #line 388

                msg =  child. inq.get ()                                        #line 389

                began_long_run =  None                                          #line 390

                continued_long_run =  None                                      #line 391

                ended_long_run =  None                                          #line 392

                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 393

                if  began_long_run:                                             #line 394

                    save_message ( child, msg)                                  #line 395

                elif  continued_long_run:                                       #line 396

                    pass                                                        #line 397
                                                                                #line 398


                destroy_message ( msg)                                          #line 399

            else:                                                               #line 400

                if  child. state!= "idle":                                      #line 401

                    msg = force_tick ( container, child)                        #line 402

                    child.handler ( child, msg)                                 #line 403

                    destroy_message ( msg)
                                                                                #line 404

                                                                                #line 405

            if  child. state ==  "active":                                      #line 406

                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 407

                container. state =  "active"                                    #line 408

                                                                                #line 409

            while (not ( child. outq.empty ())):                                #line 410

                msg =  child. outq.get ()                                       #line 411

                route ( container, child, msg)                                  #line 412

                destroy_message ( msg)

                                                                                #line 413

                                                                                #line 414
                                                                                #line 415
                                                                                #line 416

                                                                                #line 417

def attempt_tick (parent,eh):                                                   #line 418

    if  eh. state!= "idle":                                                     #line 419

        force_tick ( parent, eh)                                                #line 420

                                                                                #line 421

                                                                                #line 422

def is_tick (msg):                                                              #line 423

    return  "tick" ==  msg. datum.kind ()                                       #line 424
                                                                                #line 425

                                                                                #line 426
# Routes a single message to all matching destinations, according to            #line 427
# the container's connection network.                                           #line 428
                                                                                #line 429

def route (container,from_component,message):                                   #line 430

    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)       #line 431

    fromname =  ""                                                              #line 432

    if is_tick ( message):                                                      #line 433

        for child in  container. children:                                      #line 434

            attempt_tick ( container, child)                                    #line 435


        was_sent =  True                                                        #line 436

    else:                                                                       #line 437

        if (not (is_self ( from_component, container))):                        #line 438

            fromname =  from_component. name                                    #line 439


        from_sender = Sender ( fromname, from_component, message. port)         #line 440
                                                                                #line 441

        for connector in  container. connections:                               #line 442

            if sender_eq ( from_sender, connector. sender):                     #line 443

                deposit ( container, connector, message)                        #line 444

                was_sent =  True

                                                                                #line 445


    if not ( was_sent):                                                         #line 446

        print ( "\n\n*** Error: ***")                                           #line 447

        dump_possible_connections ( container)                                  #line 448

        print_routing_trace ( container)                                        #line 449

        print ( "***")                                                          #line 450

        print ( str( container. name) +  str( ": message '") +  str( message. port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 451

        print ( "***")                                                          #line 452

        exit ()                                                                 #line 453

                                                                                #line 454

                                                                                #line 455

def dump_possible_connections (container):                                      #line 456

    print ( str( "*** possible connections for ") +  str( container. name) +  ":"  )#line 457

    for connector in  container. connections:                                   #line 458

        print ( str( connector. direction) +  str( " ") +  str( connector. sender. name) +  str( ".") +  str( connector. sender. port) +  str( " -> ") +  str( connector. receiver. name) +  str( ".") +  connector. receiver. port        )#line 459

                                                                                #line 460

                                                                                #line 461

def any_child_ready (container):                                                #line 462

    for child in  container. children:                                          #line 463

        if child_is_ready ( child):                                             #line 464

            return  True
                                                                                #line 465


    return  False                                                               #line 466
                                                                                #line 467

                                                                                #line 468

def child_is_ready (eh):                                                        #line 469

    return (not ( eh. outq.empty ())) or (not ( eh. inq.empty ())) or ( eh. state!= "idle") or (any_child_ready ( eh))#line 470
                                                                                #line 471

                                                                                #line 472

def print_routing_trace (eh):                                                   #line 473

    print (routing_trace_all ( eh))                                             #line 474
                                                                                #line 475

                                                                                #line 476

def append_routing_descriptor (container,desc):                                 #line 477

    container. routings.put ( desc)                                             #line 478
                                                                                #line 479

                                                                                #line 480

def container_injector (container,message):                                     #line 481

    container_handler ( container, message)                                     #line 482
                                                                                #line 483

                                                                                #line 484





