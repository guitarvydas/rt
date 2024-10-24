

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

    p. clone =  clone_datum_bytes                                               #line 112

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
# dynamic routing descriptors                                                   #line 223
                                                                                #line 224

drInject =  "inject"                                                            #line 225

drSend =  "send"                                                                #line 226

drInOut =  "inout"                                                              #line 227

drForward =  "forward"                                                          #line 228

drDown =  "down"                                                                #line 229

drUp =  "up"                                                                    #line 230

drAcross =  "across"                                                            #line 231

drThrough =  "through"                                                          #line 232
                                                                                #line 233
# See “class_free programming“ starting at 45:01 of https://www.youtube.com/watch?v=XFTOG895C7c#line 234
                                                                                #line 235
                                                                                #line 236

def make_Routing_Descriptor (action,component,port,message):                    #line 237

    return {                                                                    #line 238
    "action": action,                                                           #line 239
    "component": component,                                                     #line 240
    "port": port,                                                               #line 241
    "message": message                                                          #line 242
    }                                                                           #line 243
                                                                                #line 244

                                                                                #line 245
#                                                                               #line 246

def make_Send_Descriptor (component,port,message,cause_port,cause_message):     #line 247

    rdesc = make_Routing_Descriptor ( drSend, component, port, message)         #line 248

    return {                                                                    #line 249
    "action": drSend,                                                           #line 250
    "component": rdesc ["component"],                                           #line 251
    "port": rdesc ["port"],                                                     #line 252
    "message": rdesc ["message"],                                               #line 253
    "cause_port": cause_port,                                                   #line 254
    "cause_message": cause_message,                                             #line 255
    "fmt": fmt_send                                                             #line 256
    }                                                                           #line 257
                                                                                #line 258

                                                                                #line 259

def log_send (sender,sender_port,msg,cause_msg):                                #line 260

    send_desc = make_Send_Descriptor ( sender, sender_port, msg, cause_cause_msg. port, cause_cause_msg)#line 261

    append_routing_descriptor ( sender. owner, send_desc)                       #line 262
                                                                                #line 263

                                                                                #line 264

def log_send_string (sender,sender_port,msg,cause_msg):                         #line 265

    send_desc = make_Send_Descriptor ( sender, sender_port, msg, cause_msg. port, cause_msg)#line 266

    append_routing_descriptor ( sender. owner, send_desc)                       #line 267
                                                                                #line 268

                                                                                #line 269

def fmt_send (desc,indent):                                                     #line 270

    return  ""                                                                  #line 271

    #return f;\n{indent}⋯ {desc@component.name}.“{desc@cause_port}“ ∴ {desc@component.name}.“{desc@port}“ {format_message (desc@message)}'#line 272
                                                                                #line 273

                                                                                #line 274

def fmt_send_string (desc,indent):                                              #line 275

    return fmt_send ( desc, indent)                                             #line 276
                                                                                #line 277

                                                                                #line 278
#                                                                               #line 279

def make_Forward_Descriptor (component,port,message,cause_port,cause_message):  #line 280

    rdesc = make_Routing_Descriptor ( drSend, component, port, message)         #line 281

    fmt_forward =  lambda desc:  ""                                             #line 282

    return {                                                                    #line 283
    "action": drForward,                                                        #line 284
    "component": rdesc ["component"],                                           #line 285
    "port": rdesc ["port"],                                                     #line 286
    "message": rdesc ["message"],                                               #line 287
    "cause_port": cause_port,                                                   #line 288
    "cause_message": cause_message,                                             #line 289
    "fmt": fmt_forward                                                          #line 290
    }                                                                           #line 291
                                                                                #line 292

                                                                                #line 293

def log_forward (sender,sender_port,msg,cause_msg):                             #line 294

    pass
    # when needed, it is too frequent to bother logging                         #line 295
                                                                                #line 296

                                                                                #line 297

def fmt_forward (desc):                                                         #line 298

    print ( str( "*** Error fmt_forward ") +  desc )                            #line 299

    quit ()                                                                     #line 300
                                                                                #line 301

                                                                                #line 302
#                                                                               #line 303

def make_Inject_Descriptor (receiver,port,message):                             #line 304

    rdesc = make_Routing_Descriptor ( drInject, receiver, port, message)        #line 305

    return {                                                                    #line 306
    "action": drInject,                                                         #line 307
    "component": rdesc ["component"],                                           #line 308
    "port": rdesc ["port"],                                                     #line 309
    "message": rdesc ["message"],                                               #line 310
    "fmt": fmt_inject                                                           #line 311
    }                                                                           #line 312
                                                                                #line 313

                                                                                #line 314

def log_inject (receiver,port,msg):                                             #line 315

    inject_desc = make_Inject_Descriptor ( receiver, port, msg)                 #line 316

    append_routing_descriptor ( receiver, inject_desc)                          #line 317
                                                                                #line 318

                                                                                #line 319

def fmt_inject (desc,indent):                                                   #line 320

    #return f'\n{indent}⟹  {desc@component.name}.“{desc@port}“ {format_message (desc@message)}'#line 321

    return  str( "\n") +  str( indent) +  str( "⟹  ") +  str( desc ["component"]. name) +  str( ".") +  str( desc ["port"]) +  str( " ") + format_message ( desc ["message"])       #line 328
                                                                                #line 329

                                                                                #line 330
#                                                                               #line 331

def make_Down_Descriptor (container,source_port,source_message,target,target_port,target_message):#line 332

    return {                                                                    #line 333
    "action": drDown,                                                           #line 334
    "container": container,                                                     #line 335
    "source_port": source_port,                                                 #line 336
    "source_message": source_message,                                           #line 337
    "target": target,                                                           #line 338
    "target_port": target_port,                                                 #line 339
    "target_message": target_message,                                           #line 340
    "fmt": fmt_down                                                             #line 341
    }                                                                           #line 342
                                                                                #line 343

                                                                                #line 344

def log_down (container,source_port,source_message,target,target_port,target_message):#line 345

    rdesc = make_Down_Descriptor ( container, source_port, source_message, target, target_port, target_message)#line 346

    append_routing_descriptor ( container, rdesc)                               #line 347
                                                                                #line 348

                                                                                #line 349

def fmt_down (desc,indent):                                                     #line 350

    #return f'\n{indent}↓ {desc@container.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“ {format_message (desc@target_message)}'#line 351

    return  str( "\n") +  str( indent) +  str( " ↓ ") +  str( desc ["container"]. name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"]. name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + format_message ( desc ["target_message"])           #line 362
                                                                                #line 363

                                                                                #line 364
#                                                                               #line 365

def make_Up_Descriptor (source,source_port,source_message,container,container_port,container_message):#line 366

    return {                                                                    #line 367
    "action": drUp,                                                             #line 368
    "source": source,                                                           #line 369
    "source_port": source_port,                                                 #line 370
    "source_message": source_message,                                           #line 371
    "container": container,                                                     #line 372
    "container_port": container_port,                                           #line 373
    "container_message": container_message,                                     #line 374
    "fmt": fmt_up                                                               #line 375
    }                                                                           #line 376
                                                                                #line 377

                                                                                #line 378

def log_up (source,source_port,source_message,container,target_port,target_message):#line 379

    rdesc = make_Up_Descriptor ( source, source_port, source_message, container, target_port, target_message)#line 380

    append_routing_descriptor ( container, rdesc)                               #line 381
                                                                                #line 382

                                                                                #line 383

def fmt_up (desc,indent):                                                       #line 384

    #return f'\n{indent}↑ {desc@source.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@container_port}“ {format_message (desc@container_message)}'#line 385

    return  str( "\n") +  str( indent) +  str( "↑ ") +  str( desc ["source"]. name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"]. name) +  str( ".") +  str( desc ["container_port"]) +  str( " ") + format_message ( desc ["container_message"])           #line 396
                                                                                #line 397

                                                                                #line 398

def make_Across_Descriptor (container,source,source_port,source_message,target,target_port,target_message):#line 399

    return {                                                                    #line 400
    "action": drAcross,                                                         #line 401
    "container": container,                                                     #line 402
    "source": source,                                                           #line 403
    "source_port": source_port,                                                 #line 404
    "source_message": source_message,                                           #line 405
    "target": target,                                                           #line 406
    "target_port": target_port,                                                 #line 407
    "target_message": target_message,                                           #line 408
    "fmt": fmt_across                                                           #line 409
    }                                                                           #line 410
                                                                                #line 411

                                                                                #line 412

def log_across (container,source,source_port,source_message,target,target_port,target_message):#line 413

    rdesc = make_Across_Descriptor ( container, source, source_port, source_message, target, target_port, target_message)#line 414

    append_routing_descriptor ( container, rdesc)                               #line 415
                                                                                #line 416

                                                                                #line 417

def fmt_across (desc,indent):                                                   #line 418

    #return f'\n{indent}→ {desc@source.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“  {format_message (desc@target_message)}'#line 419

    return  str( "\n") +  str( indent) +  str( "→ ") +  str( desc ["source"]. name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"]. name) +  str( ".") +  str( desc ["target_port"]) +  str( "  ") + format_message ( desc ["target_message"])           #line 430
                                                                                #line 431

                                                                                #line 432
#                                                                               #line 433

def make_Through_Descriptor (container,source_port,source_message,target_port,message):#line 434

    return {                                                                    #line 435
    "action": drThrough,                                                        #line 436
    "container": container,                                                     #line 437
    "source_port": source_port,                                                 #line 438
    "source_message": source_message,                                           #line 439
    "target_port": target_port,                                                 #line 440
    "message": message,                                                         #line 441
    "fmt": fmt_through                                                          #line 442
    }                                                                           #line 443
                                                                                #line 444

                                                                                #line 445

def log_through (container,source_port,source_message,target_port,message):     #line 446

    rdesc = make_Through_Descriptor ( container, source_port, source_message, target_port, message)#line 447

    append_routing_descriptor ( container, rdesc)                               #line 448
                                                                                #line 449

                                                                                #line 450

def fmt_through (desc,indent):                                                  #line 451

    #return f'\n{indent}⇶ {desc @container.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@target_port}“ {format_message (desc@message)}'#line 452

    return  str( "\n") +  str( indent) +  str( "⇶ ") +  str( desc ["container"]. name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"]. name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + format_message ( desc ["message"])           #line 463
                                                                                #line 464

                                                                                #line 465
#                                                                               #line 466

def make_InOut_Descriptor (container,component,in_message,out_port,out_message):#line 467

    return {                                                                    #line 468
    "action": drInOut,                                                          #line 469
    "container": container,                                                     #line 470
    "component": component,                                                     #line 471
    "in_message": in_message,                                                   #line 472
    "out_message": out_message,                                                 #line 473
    "fmt": fmt_inout                                                            #line 474
    }                                                                           #line 475
                                                                                #line 476

                                                                                #line 477

def log_inout (container,component,in_message):                                 #line 478

    if  component. outq.empty ():                                               #line 479

        log_inout_no_output ( container, component, in_in_message)              #line 480

    else:                                                                       #line 481

        log_inout_recursively ( container, component, in_in_message,out_list ( component. outq. queue))#line 482

                                                                                #line 483

                                                                                #line 484

def log_inout_no_output (container,component,in_message):                       #line 485

    rdesc = make_InOut_Descriptor ( container, component, in_in_message, None, None)#line 486

    append_routing_descriptor ( container, rdesc)                               #line 487
                                                                                #line 488

                                                                                #line 489

def log_inout_single (container,component,in_message,out_message):              #line 490

    rdesc = make_InOut_Descriptor ( container, component, in_message, None, out_message)#line 491

    append_routing_descriptor ( container, rdesc)                               #line 492
                                                                                #line 493

                                                                                #line 494

def log_inout_recursively (container,component,in_message,out_messages):        #line 495

    if [] ==  out_messages:                                                     #line 496

        pass                                                                    #line 497

    else:                                                                       #line 498

        m =   out_messages[0]                                                   #line 499

        rest =   out_messages[1:]                                               #line 500

        log_inout_single ( container, component, in_message, m)                 #line 501

        log_inout_recursively ( container, component, in_in_message, out_rest)  #line 502

                                                                                #line 503

                                                                                #line 504

def fmt_inout (desc,indent):                                                    #line 505

    outm =  desc ["out_message"]                                                #line 506

    if  None ==  outm:                                                          #line 507

        return  str( "\n") +  str( indent) +  "  ⊥"                             #line 508

    else:                                                                       #line 509

        return  str( "\n") +  str( indent) +  str( "  ∴ ") +  str( desc ["component"]. name) +  str( " ") + format_message ( outm)     #line 514
                                                                                #line 515

                                                                                #line 516

                                                                                #line 517

def log_tick (container,component,in_message):                                  #line 518

    pass                                                                        #line 519
                                                                                #line 520

                                                                                #line 521
#                                                                               #line 522

def routing_trace_all (container):                                              #line 523

    indent =  ""                                                                #line 524

    lis = list ( container. routings. queue)                                    #line 525

    return recursive_routing_trace ( container, lis, indent)                    #line 526
                                                                                #line 527

                                                                                #line 528

def recursive_routing_trace (container,lis,indent):                             #line 529

    if [] ==  lis:                                                              #line 530

        return  ""                                                              #line 531

    else:                                                                       #line 532

        desc = first ( lis)                                                     #line 533

        formatted =  desc ["fmt"] ( desc, indent)                               #line 534

        return  formatted+recursive_routing_trace ( container,rest ( lis), indent+ "  ")#line 535

                                                                                #line 536

                                                                                #line 537

enumDown =  0                                                                   #line 538

enumAcross =  1                                                                 #line 539

enumUp =  2                                                                     #line 540

enumThrough =  3                                                                #line 541
                                                                                #line 542

def container_instantiator (reg,owner,container_name,desc):                     #line 543

    global enumDown, enumUp, enumAcross, enumThrough                            #line 544

    container = make_container ( container_name, owner)                         #line 545

    children = []                                                               #line 546

    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here#line 547

    # collect children                                                          #line 548

    for child_desc in  desc ["children"]:                                       #line 549

        child_instance = get_component_instance ( reg, child_desc ["name"], container)#line 550

        children.append ( child_instance)                                       #line 551

        children_by_id [ child_desc ["id"]] =  child_instance                   #line 552


    container. children =  children                                             #line 553

    me =  container                                                             #line 554
                                                                                #line 555

    connectors = []                                                             #line 556

    for proto_conn in  desc ["connections"]:                                    #line 557

        source_component =  None                                                #line 558

        target_component =  None                                                #line 559

        connector = Connector ()                                                #line 560

        if  proto_conn ["dir"] ==  enumDown:                                    #line 561

            # JSON: {'dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 562

            connector. direction =  "down"                                      #line 563

            connector. sender = Sender ( me. name, me, proto_conn ["source_port"])#line 564

            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 565

            if ( target_component ==  None):                                    #line 566

                load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn ["target"] )#line 567

            else:                                                               #line 568

                connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)#line 569

                connectors.append ( connector)
                                                                                #line 570

        elif  proto_conn ["dir"] ==  enumAcross:                                #line 571

            connector. direction =  "across"                                    #line 572

            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 573

            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 574

            if  source_component ==  None:                                      #line 575

                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn ["source"] )#line 576

            else:                                                               #line 577

                connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])#line 578

                if  target_component ==  None:                                  #line 579

                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn. target )#line 580

                else:                                                           #line 581

                    connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)#line 582

                    connectors.append ( connector)

                                                                                #line 583

        elif  proto_conn ["dir"] ==  enumUp:                                    #line 584

            connector. direction =  "up"                                        #line 585

            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 586

            if  source_component ==  None:                                      #line 587

                print ( str( "internal error: .Up connection source not ok ") +  proto_conn ["source"] )#line 588

            else:                                                               #line 589

                connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])#line 590

                connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)#line 591

                connectors.append ( connector)
                                                                                #line 592

        elif  proto_conn ["dir"] ==  enumThrough:                               #line 593

            connector. direction =  "through"                                   #line 594

            connector. sender = Sender ( me. name, me, proto_conn ["source_port"])#line 595

            connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)#line 596

            connectors.append ( connector)
                                                                                #line 597

                                                                                #line 598

    container. connections =  connectors                                        #line 599

    return  container                                                           #line 600
                                                                                #line 601

                                                                                #line 602
# The default handler for container components.                                 #line 603

def container_handler (container,message):                                      #line 604

    route ( container, from_container, message)
    # references to 'self' are replaced by the container during instantiation   #line 605

    while any_child_ready ( container):                                         #line 606

        step_children ( container, message)                                     #line 607

                                                                                #line 608

                                                                                #line 609
# Frees the given container and associated data.                                #line 610

def destroy_container (eh):                                                     #line 611

    pass                                                                        #line 612
                                                                                #line 613

                                                                                #line 614

def fifo_is_empty (fifo):                                                       #line 615

    return  fifo.empty ()                                                       #line 616
                                                                                #line 617

                                                                                #line 618
# Routing connection for a container component. The `direction` field has       #line 619
# no affect on the default message routing system _ it is there for debugging   #line 620
# purposes, or for reading by other tools.                                      #line 621
                                                                                #line 622

class Connector:
    def __init__ (self,):                                                       #line 623

        self.direction =  None # down, across, up, through                      #line 624

        self.sender =  None                                                     #line 625

        self.receiver =  None                                                   #line 626
                                                                                #line 627

                                                                                #line 628
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,  #line 629
# based on component ID (pointer) and port name.                                #line 630
                                                                                #line 631

class Sender:
    def __init__ (self,name,component,port):                                    #line 632

        self.name =  name                                                       #line 633

        self.component =  component # from                                      #line 634

        self.port =  port # from's port                                         #line 635
                                                                                #line 636

                                                                                #line 637
# `Receiver` is a handle to a destination queue, and a `port` name to assign    #line 638
# to incoming messages to this queue.                                           #line 639
                                                                                #line 640

class Receiver:
    def __init__ (self,name,queue,port,component):                              #line 641

        self.name =  name                                                       #line 642

        self.queue =  queue # queue (input | output) of receiver                #line 643

        self.port =  port # destination port                                    #line 644

        self.component =  component # to (for bootstrap debug)                  #line 645
                                                                                #line 646

                                                                                #line 647
# Checks if two senders match, by pointer equality and port name matching.      #line 648

def sender_eq (s1,s2):                                                          #line 649

    same_components = ( s1. component ==  s2. component)                        #line 650

    same_ports = ( s1. port ==  s2. port)                                       #line 651

    return  same_components and  same_ports                                     #line 652
                                                                                #line 653

                                                                                #line 654
# Delivers the given message to the receiver of this connector.                 #line 655
                                                                                #line 656

def deposit (parent,conn,message):                                              #line 657

    new_message = make_message ( conn. receiver. port, message. datum)          #line 658

    log_connection ( parent, conn, new_message)                                 #line 659

    push_message ( parent, conn. receiver. component, conn. receiver. queue, new_message)#line 660
                                                                                #line 661

                                                                                #line 662

def force_tick (parent,eh):                                                     #line 663

    tick_msg = make_message ( ".",new_datum_tick ())                            #line 664

    push_message ( parent, eh, eh. inq, tick_msg)                               #line 665

    return  tick_msg                                                            #line 666
                                                                                #line 667

                                                                                #line 668

def push_message (parent,receiver,inq,m):                                       #line 669

    inq.put ( m)                                                                #line 670

    parent. visit_ordering.put ( receiver)                                      #line 671
                                                                                #line 672

                                                                                #line 673

def is_self (child,container):                                                  #line 674

    # in an earlier version “self“ was denoted as ϕ                             #line 675

    return  child ==  container                                                 #line 676
                                                                                #line 677

                                                                                #line 678

def step_child (child,msg):                                                     #line 679

    before_state =  child. state                                                #line 680

    child.handler ( child, msg)                                                 #line 681

    after_state =  child. state                                                 #line 682

    return [ before_state ==  "idle" and  after_state!= "idle",                 #line 683
    before_state!= "idle" and  after_state!= "idle",                            #line 684
    before_state!= "idle" and  after_state ==  "idle"]                          #line 685
                                                                                #line 686

                                                                                #line 687

def save_message (eh,msg):                                                      #line 688

    eh. saved_messages.put ( msg)                                               #line 689
                                                                                #line 690

                                                                                #line 691

def fetch_saved_message_and_clear (eh):                                         #line 692

    return  eh. saved_messages.get ()                                           #line 693
                                                                                #line 694

                                                                                #line 695

def step_children (container,causingMessage):                                   #line 696

    container. state =  "idle"                                                  #line 697

    for child in list ( container. visit_ordering. queue):                      #line 698

        # child = container represents self, skip it                            #line 699

        if (not (is_self ( child, container))):                                 #line 700

            if (not ( child. inq.empty ())):                                    #line 701

                msg =  child. inq.get ()                                        #line 702

                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 703

                if  began_long_run:                                             #line 704

                    save_message ( child, msg)                                  #line 705

                elif  continued_long_run:                                       #line 706

                    pass                                                        #line 707

                elif  ended_long_run:                                           #line 708

                    log_inout ( container, child,in_fetch_saved_message_and_clear ( child))#line 709

                else:                                                           #line 710

                    log_inout ( container, child, in_msg)                       #line 711


                destroy_message ( msg)                                          #line 712

            else:                                                               #line 713

                if  child. state!= "idle":                                      #line 714

                    msg = force_tick ( container, child)                        #line 715

                    child.handler ( child, msg)                                 #line 716

                    log_tick ( container, child, in_msg)                        #line 717

                    destroy_message ( msg)
                                                                                #line 718

                                                                                #line 719

            if  child. state ==  "active":                                      #line 720

                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 721

                container. state =  "active"                                    #line 722

                                                                                #line 723

            while (not ( child. outq.empty ())):                                #line 724

                msg =  child. outq.get ()                                       #line 725

                route ( container, child, msg)                                  #line 726

                destroy_message ( msg)

                                                                                #line 727

                                                                                #line 728
                                                                                #line 729
                                                                                #line 730

                                                                                #line 731

def attempt_tick (parent,eh):                                                   #line 732

    if  eh. state!= "idle":                                                     #line 733

        force_tick ( parent, eh)                                                #line 734

                                                                                #line 735

                                                                                #line 736

def is_tick (msg):                                                              #line 737

    return  "tick" ==  msg. datum.kind ()                                       #line 738
                                                                                #line 739

                                                                                #line 740
# Routes a single message to all matching destinations, according to            #line 741
# the container's connection network.                                           #line 742
                                                                                #line 743

def route (container,from_component,message):                                   #line 744

    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)       #line 745

    fromname =  ""                                                              #line 746

    if is_tick ( message):                                                      #line 747

        for child in  container. children:                                      #line 748

            attempt_tick ( container, child, message)                           #line 749


        was_sent =  True                                                        #line 750

    else:                                                                       #line 751

        if (not (is_self ( from_component, container))):                        #line 752

            fromname =  from_component. name                                    #line 753


        from_sender = Sender ( fromname, from_component, message. port)         #line 754
                                                                                #line 755

        for connector in  container. connections:                               #line 756

            if sender_eq ( from_sender, connector. sender):                     #line 757

                deposit ( container, connector, message)                        #line 758

                was_sent =  True

                                                                                #line 759


    if not ( was_sent):                                                         #line 760

        print ( "\n\n*** Error: ***")                                           #line 761

        dump_possible_connections ( container)                                  #line 762

        print_routing_trace ( container)                                        #line 763

        print ( "***")                                                          #line 764

        print ( str( container. name) +  str( ": message '") +  str( message. port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 765

        print ( "***")                                                          #line 766

        exit ()                                                                 #line 767

                                                                                #line 768

                                                                                #line 769

def dump_possible_connections (container):                                      #line 770

    print ( str( "*** possible connections for ") +  str( container. name) +  ":"  )#line 771

    for connector in  container. connections:                                   #line 772

        print ( str( connector. direction) +  str( " ") +  str( connector. sender. name) +  str( ".") +  str( connector. sender. port) +  str( " -> ") +  str( connector. receiver. name) +  str( ".") +  connector. receiver. port        )#line 773

                                                                                #line 774

                                                                                #line 775

def any_child_ready (container):                                                #line 776

    for child in  container. children:                                          #line 777

        if child_is_ready ( child):                                             #line 778

            return  True
                                                                                #line 779


    return  False                                                               #line 780
                                                                                #line 781

                                                                                #line 782

def child_is_ready (eh):                                                        #line 783

    return (not ( eh. outq.empty ())) or (not ( eh. inq.empty ())) or ( eh. state!= "idle") or (any_child_ready ( eh))#line 784
                                                                                #line 785

                                                                                #line 786

def print_routing_trace (eh):                                                   #line 787

    print (routing_trace_all ( eh))                                             #line 788
                                                                                #line 789

                                                                                #line 790

def append_routing_descriptor (container,desc):                                 #line 791

    container. routings.put ( desc)                                             #line 792
                                                                                #line 793

                                                                                #line 794

def log_connection (container,connector,message):                               #line 795

    if  "down" ==  connector. direction:                                        #line 796

        log_down ( container,                                                   #line 797
        source_connector. sender. port,                                         #line 798
        None,                                                                   #line 799
        connector. receiver. component,                                         #line 800
        connector. receiver. port,                                              #line 801
        message)                                                                #line 802

    elif  "up" ==  connector. direction:                                        #line 803

        log_up ( connector. sender. component, connector. sender. port, None, container, connector. receiver. port, message)#line 804

    elif  "across" ==  connector. direction:                                    #line 805

        log_across ( container,                                                 #line 806
        connector. sender. component, connector. sender. port, None,            #line 807
        connector. receiver. component, connector. receiver. port, message)     #line 808

    elif  "through" ==  connector. direction:                                   #line 809

        log_through ( container, connector. sender. port, None,                 #line 810
        connector. receiver. port, message)                                     #line 811

    else:                                                                       #line 812

        print ( str( "*** FATAL error: in log_connection /") +  str( connector. direction) +  str( "/ /") +  str( message. port) +  str( "/ /") +  str( message. datum.srepr ()) +  "/"      )#line 813

        exit ()                                                                 #line 814

                                                                                #line 815

                                                                                #line 816

def container_injector (container,message):                                     #line 817

    log_inject ( container, message. port, message)                             #line 818

    container_handler ( container, message)                                     #line 819
                                                                                #line 820

                                                                                #line 821





