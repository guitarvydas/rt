

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

    p =  src                                                                    #line 122

    p. data =  src.clone ()                                                     #line 123

    return  p                                                                   #line 124
                                                                                #line 125

                                                                                #line 126

def reclaim_datum_bytes (src):                                                  #line 127

    pass                                                                        #line 128
                                                                                #line 129

                                                                                #line 130

def srepr_datum_bytes (d):                                                      #line 131

    return  d. data.decode ( "UTF_8")                                           #line 132
                                                                                #line 133


def raw_datum_bytes (d):                                                        #line 134

    return  d. data                                                             #line 135
                                                                                #line 136

                                                                                #line 137

def new_datum_handle (h):                                                       #line 138

    return new_datum_int ( h)                                                   #line 139
                                                                                #line 140

                                                                                #line 141

def new_datum_int (i):                                                          #line 142

    p = Datum ()                                                                #line 143

    p. data =  i                                                                #line 144

    p. clone =  lambda : clone_int ( i)                                         #line 145

    p. reclaim =  lambda : reclaim_int ( i)                                     #line 146

    p. srepr =  lambda : srepr_datum_int ( i)                                   #line 147

    p. raw =  lambda : raw_datum_int ( i)                                       #line 148

    p. kind =  lambda :  "int"                                                  #line 149

    return  p                                                                   #line 150
                                                                                #line 151

                                                                                #line 152

def clone_int (i):                                                              #line 153

    p = new_datum_int ( i)                                                      #line 154

    return  p                                                                   #line 155
                                                                                #line 156

                                                                                #line 157

def reclaim_int (src):                                                          #line 158

    pass                                                                        #line 159
                                                                                #line 160

                                                                                #line 161

def srepr_datum_int (i):                                                        #line 162

    return str ( i)                                                             #line 163
                                                                                #line 164

                                                                                #line 165

def raw_datum_int (i):                                                          #line 166

    return  i                                                                   #line 167
                                                                                #line 168

                                                                                #line 169
# Message passed to a leaf component.                                           #line 170
#                                                                               #line 171
# `port` refers to the name of the incoming or outgoing port of this component. #line 172
# `datum` is the data attached to this message.                                 #line 173

class Message:
    def __init__ (self,port,datum):                                             #line 174

        self.port =  port                                                       #line 175

        self.datum =  datum                                                     #line 176
                                                                                #line 177

                                                                                #line 178

def clone_port (s):                                                             #line 179

    return clone_string ( s)                                                    #line 180
                                                                                #line 181

                                                                                #line 182
# Utility for making a `Message`. Used to safely “seed“ messages                #line 183
# entering the very top of a network.                                           #line 184

def make_message (port,datum):                                                  #line 185

    p = clone_string ( port)                                                    #line 186

    m = Message ( p, datum.clone ())                                            #line 187

    return  m                                                                   #line 188
                                                                                #line 189

                                                                                #line 190
# Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations.#line 191

def message_clone (message):                                                    #line 192

    m = Message (clone_port ( message. port), message. datum.clone ())          #line 193

    return  m                                                                   #line 194
                                                                                #line 195

                                                                                #line 196
# Frees a message.                                                              #line 197

def destroy_message (msg):                                                      #line 198

    # during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages#line 199

    pass                                                                        #line 200
                                                                                #line 201

                                                                                #line 202

def destroy_datum (msg):                                                        #line 203

    pass                                                                        #line 204
                                                                                #line 205

                                                                                #line 206

def destroy_port (msg):                                                         #line 207

    pass                                                                        #line 208
                                                                                #line 209

                                                                                #line 210
#                                                                               #line 211

def format_message (m):                                                         #line 212

    if  m ==  None:                                                             #line 213

        return  "ϕ"                                                             #line 214

    else:                                                                       #line 215

        return  str( "⟪") +  str( m. port) +  str( "⦂") +  str( m. datum.srepr ()) +  "⟫"    #line 219
                                                                                #line 220

                                                                                #line 221

                                                                                #line 222
                                                                                #line 223

enumDown =  0                                                                   #line 224

enumAcross =  1                                                                 #line 225

enumUp =  2                                                                     #line 226

enumThrough =  3                                                                #line 227
                                                                                #line 228

def container_instantiator (reg,owner,container_name,desc):                     #line 229

    global enumDown, enumUp, enumAcross, enumThrough                            #line 230

    container = make_container ( container_name, owner)                         #line 231

    children = []                                                               #line 232

    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here#line 233

    # collect children                                                          #line 234

    for child_desc in  desc ["children"]:                                       #line 235

        child_instance = get_component_instance ( reg, child_desc ["name"], container)#line 236

        children.append ( child_instance)                                       #line 237

        children_by_id [ child_desc ["id"]] =  child_instance                   #line 238


    container. children =  children                                             #line 239

    me =  container                                                             #line 240
                                                                                #line 241

    connectors = []                                                             #line 242

    for proto_conn in  desc ["connections"]:                                    #line 243

        source_component =  None                                                #line 244

        target_component =  None                                                #line 245

        connector = Connector ()                                                #line 246

        if  proto_conn ["dir"] ==  enumDown:                                    #line 247

            # JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 248

            connector. direction =  "down"                                      #line 249

            connector. sender = Sender ( me. name, me, proto_conn ["source_port"])#line 250

            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 251

            if ( target_component ==  None):                                    #line 252

                load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn ["target"] )#line 253

            else:                                                               #line 254

                connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)#line 255

                connectors.append ( connector)
                                                                                #line 256

        elif  proto_conn ["dir"] ==  enumAcross:                                #line 257

            connector. direction =  "across"                                    #line 258

            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 259

            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 260

            if  source_component ==  None:                                      #line 261

                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn ["source"] )#line 262

            else:                                                               #line 263

                connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])#line 264

                if  target_component ==  None:                                  #line 265

                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn. target )#line 266

                else:                                                           #line 267

                    connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)#line 268

                    connectors.append ( connector)

                                                                                #line 269

        elif  proto_conn ["dir"] ==  enumUp:                                    #line 270

            connector. direction =  "up"                                        #line 271

            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 272

            if  source_component ==  None:                                      #line 273

                print ( str( "internal error: .Up connection source not ok ") +  proto_conn ["source"] )#line 274

            else:                                                               #line 275

                connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])#line 276

                connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)#line 277

                connectors.append ( connector)
                                                                                #line 278

        elif  proto_conn ["dir"] ==  enumThrough:                               #line 279

            connector. direction =  "through"                                   #line 280

            connector. sender = Sender ( me. name, me, proto_conn ["source_port"])#line 281

            connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)#line 282

            connectors.append ( connector)
                                                                                #line 283

                                                                                #line 284

    container. connections =  connectors                                        #line 285

    return  container                                                           #line 286
                                                                                #line 287

                                                                                #line 288
# The default handler for container components.                                 #line 289

def container_handler (container,message):                                      #line 290

    route ( container, container, message)
    # references to 'self' are replaced by the container during instantiation   #line 291

    while any_child_ready ( container):                                         #line 292

        step_children ( container, message)                                     #line 293

                                                                                #line 294

                                                                                #line 295
# Frees the given container and associated data.                                #line 296

def destroy_container (eh):                                                     #line 297

    pass                                                                        #line 298
                                                                                #line 299

                                                                                #line 300

def fifo_is_empty (fifo):                                                       #line 301

    return  fifo.empty ()                                                       #line 302
                                                                                #line 303

                                                                                #line 304
# Routing connection for a container component. The `direction` field has       #line 305
# no affect on the default message routing system _ it is there for debugging   #line 306
# purposes, or for reading by other tools.                                      #line 307
                                                                                #line 308

class Connector:
    def __init__ (self,):                                                       #line 309

        self.direction =  None # down, across, up, through                      #line 310

        self.sender =  None                                                     #line 311

        self.receiver =  None                                                   #line 312
                                                                                #line 313

                                                                                #line 314
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,  #line 315
# based on component ID (pointer) and port name.                                #line 316
                                                                                #line 317

class Sender:
    def __init__ (self,name,component,port):                                    #line 318

        self.name =  name                                                       #line 319

        self.component =  component # from                                      #line 320

        self.port =  port # from's port                                         #line 321
                                                                                #line 322

                                                                                #line 323
# `Receiver` is a handle to a destination queue, and a `port` name to assign    #line 324
# to incoming messages to this queue.                                           #line 325
                                                                                #line 326

class Receiver:
    def __init__ (self,name,queue,port,component):                              #line 327

        self.name =  name                                                       #line 328

        self.queue =  queue # queue (input | output) of receiver                #line 329

        self.port =  port # destination port                                    #line 330

        self.component =  component # to (for bootstrap debug)                  #line 331
                                                                                #line 332

                                                                                #line 333
# Checks if two senders match, by pointer equality and port name matching.      #line 334

def sender_eq (s1,s2):                                                          #line 335

    same_components = ( s1. component ==  s2. component)                        #line 336

    same_ports = ( s1. port ==  s2. port)                                       #line 337

    return  same_components and  same_ports                                     #line 338
                                                                                #line 339

                                                                                #line 340
# Delivers the given message to the receiver of this connector.                 #line 341
                                                                                #line 342

def deposit (parent,conn,message):                                              #line 343

    new_message = make_message ( conn. receiver. port, message. datum)          #line 344

    push_message ( parent, conn. receiver. component, conn. receiver. queue, new_message)#line 345
                                                                                #line 346

                                                                                #line 347

def force_tick (parent,eh):                                                     #line 348

    tick_msg = make_message ( ".",new_datum_tick ())                            #line 349

    push_message ( parent, eh, eh. inq, tick_msg)                               #line 350

    return  tick_msg                                                            #line 351
                                                                                #line 352

                                                                                #line 353

def push_message (parent,receiver,inq,m):                                       #line 354

    inq.put ( m)                                                                #line 355

    parent. visit_ordering.put ( receiver)                                      #line 356
                                                                                #line 357

                                                                                #line 358

def is_self (child,container):                                                  #line 359

    # in an earlier version “self“ was denoted as ϕ                             #line 360

    return  child ==  container                                                 #line 361
                                                                                #line 362

                                                                                #line 363

def step_child (child,msg):                                                     #line 364

    before_state =  child. state                                                #line 365

    child.handler ( child, msg)                                                 #line 366

    after_state =  child. state                                                 #line 367

    return [ before_state ==  "idle" and  after_state!= "idle",                 #line 368
    before_state!= "idle" and  after_state!= "idle",                            #line 369
    before_state!= "idle" and  after_state ==  "idle"]                          #line 370
                                                                                #line 371

                                                                                #line 372

def save_message (eh,msg):                                                      #line 373

    eh. saved_messages.put ( msg)                                               #line 374
                                                                                #line 375

                                                                                #line 376

def fetch_saved_message_and_clear (eh):                                         #line 377

    return  eh. saved_messages.get ()                                           #line 378
                                                                                #line 379

                                                                                #line 380

def step_children (container,causingMessage):                                   #line 381

    container. state =  "idle"                                                  #line 382

    for child in list ( container. visit_ordering. queue):                      #line 383

        # child = container represents self, skip it                            #line 384

        if (not (is_self ( child, container))):                                 #line 385

            if (not ( child. inq.empty ())):                                    #line 386

                msg =  child. inq.get ()                                        #line 387

                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 388

                if  began_long_run:                                             #line 389

                    save_message ( child, msg)                                  #line 390

                elif  continued_long_run:                                       #line 391

                    pass                                                        #line 392
                                                                                #line 393


                destroy_message ( msg)                                          #line 394

            else:                                                               #line 395

                if  child. state!= "idle":                                      #line 396

                    msg = force_tick ( container, child)                        #line 397

                    child.handler ( child, msg)                                 #line 398

                    destroy_message ( msg)
                                                                                #line 399

                                                                                #line 400

            if  child. state ==  "active":                                      #line 401

                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 402

                container. state =  "active"                                    #line 403

                                                                                #line 404

            while (not ( child. outq.empty ())):                                #line 405

                msg =  child. outq.get ()                                       #line 406

                route ( container, child, msg)                                  #line 407

                destroy_message ( msg)

                                                                                #line 408

                                                                                #line 409
                                                                                #line 410
                                                                                #line 411

                                                                                #line 412

def attempt_tick (parent,eh):                                                   #line 413

    if  eh. state!= "idle":                                                     #line 414

        force_tick ( parent, eh)                                                #line 415

                                                                                #line 416

                                                                                #line 417

def is_tick (msg):                                                              #line 418

    return  "tick" ==  msg. datum.kind ()                                       #line 419
                                                                                #line 420

                                                                                #line 421
# Routes a single message to all matching destinations, according to            #line 422
# the container's connection network.                                           #line 423
                                                                                #line 424

def route (container,from_component,message):                                   #line 425

    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)       #line 426

    fromname =  ""                                                              #line 427

    if is_tick ( message):                                                      #line 428

        for child in  container. children:                                      #line 429

            attempt_tick ( container, child, message)                           #line 430


        was_sent =  True                                                        #line 431

    else:                                                                       #line 432

        if (not (is_self ( from_component, container))):                        #line 433

            fromname =  from_component. name                                    #line 434


        from_sender = Sender ( fromname, from_component, message. port)         #line 435
                                                                                #line 436

        for connector in  container. connections:                               #line 437

            if sender_eq ( from_sender, connector. sender):                     #line 438

                deposit ( container, connector, message)                        #line 439

                was_sent =  True

                                                                                #line 440


    if not ( was_sent):                                                         #line 441

        print ( "\n\n*** Error: ***")                                           #line 442

        dump_possible_connections ( container)                                  #line 443

        print_routing_trace ( container)                                        #line 444

        print ( "***")                                                          #line 445

        print ( str( container. name) +  str( ": message '") +  str( message. port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 446

        print ( "***")                                                          #line 447

        exit ()                                                                 #line 448

                                                                                #line 449

                                                                                #line 450

def dump_possible_connections (container):                                      #line 451

    print ( str( "*** possible connections for ") +  str( container. name) +  ":"  )#line 452

    for connector in  container. connections:                                   #line 453

        print ( str( connector. direction) +  str( " ") +  str( connector. sender. name) +  str( ".") +  str( connector. sender. port) +  str( " -> ") +  str( connector. receiver. name) +  str( ".") +  connector. receiver. port        )#line 454

                                                                                #line 455

                                                                                #line 456

def any_child_ready (container):                                                #line 457

    for child in  container. children:                                          #line 458

        if child_is_ready ( child):                                             #line 459

            return  True
                                                                                #line 460


    return  False                                                               #line 461
                                                                                #line 462

                                                                                #line 463

def child_is_ready (eh):                                                        #line 464

    return (not ( eh. outq.empty ())) or (not ( eh. inq.empty ())) or ( eh. state!= "idle") or (any_child_ready ( eh))#line 465
                                                                                #line 466

                                                                                #line 467

def print_routing_trace (eh):                                                   #line 468

    print (routing_trace_all ( eh))                                             #line 469
                                                                                #line 470

                                                                                #line 471

def append_routing_descriptor (container,desc):                                 #line 472

    container. routings.put ( desc)                                             #line 473
                                                                                #line 474

                                                                                #line 475

def container_injector (container,message):                                     #line 476

    container_handler ( container, message)                                     #line 477
                                                                                #line 478

                                                                                #line 479





