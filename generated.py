

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







import os                                                                       #line 1

import json                                                                     #line 2

import sys                                                                      #line 3
                                                                                #line 4
                                                                                #line 5

class Component_Registry:
    def __init__ (self,):                                                       #line 6

        self.templates = {}                                                     #line 7
                                                                                #line 8

                                                                                #line 9

class Template:
    def __init__ (self,name,template_data,instantiator):                        #line 10

        self.name =  name                                                       #line 11

        self.template_data =  template_data                                     #line 12

        self.instantiator =  instantiator                                       #line 13
                                                                                #line 14

                                                                                #line 15

def read_and_convert_json_file (filename):                                      #line 16

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
                                                                                #line 17
                                                                                #line 18

                                                                                #line 19

def json2internal (container_xml):                                              #line 20

    fname =  os. path.basename ( container_xml)                                 #line 21

    routings = read_and_convert_json_file ( fname)                              #line 22

    return  routings                                                            #line 23
                                                                                #line 24

                                                                                #line 25

def delete_decls (d):                                                           #line 26

    pass                                                                        #line 27
                                                                                #line 28

                                                                                #line 29

def make_component_registry ():                                                 #line 30

    return Component_Registry ()                                                #line 31
                                                                                #line 32

                                                                                #line 33

def register_component (reg,template):
    return abstracted_register_component ( reg, template, False)                #line 34


def register_component_allow_overwriting (reg,template):
    return abstracted_register_component ( reg, template, True)                 #line 35

                                                                                #line 36

def abstracted_register_component (reg,template,ok_to_overwrite):               #line 37

    name = mangle_name ( template. name)                                        #line 38

    if  name in  reg. templates and not  ok_to_overwrite:                       #line 39

        load_error ( str( "Component ") +  str( template. name) +  " already declared"  )#line 40


    reg. templates [ name] =  template                                          #line 41

    return  reg                                                                 #line 42
                                                                                #line 43

                                                                                #line 44

def register_multiple_components (reg,templates):                               #line 45

    for template in  templates:                                                 #line 46

        register_component ( reg, template)                                     #line 47

                                                                                #line 48

                                                                                #line 49

def get_component_instance (reg,full_name,owner):                               #line 50

    template_name = mangle_name ( full_name)                                    #line 51

    if  template_name in  reg. templates:                                       #line 52

        template =  reg. templates [ template_name]                             #line 53

        if ( template ==  None):                                                #line 54

            load_error ( str( "Registry Error: Can;t find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )#line 55

            return  None                                                        #line 56

        else:                                                                   #line 57

            owner_name =  ""                                                    #line 58

            instance_name =  template_name                                      #line 59

            if  None!= owner:                                                   #line 60

                owner_name =  owner. name                                       #line 61

                instance_name =  str( owner_name) +  str( ".") +  template_name  #line 62

            else:                                                               #line 63

                instance_name =  template_name                                  #line 64


            instance =  template.instantiator ( reg, owner, instance_name, template. template_data)#line 65

            instance. depth = calculate_depth ( instance)                       #line 66

            return  instance
                                                                                #line 67

    else:                                                                       #line 68

        load_error ( str( "Registry Error: Can't find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )#line 69

        return  None                                                            #line 70

                                                                                #line 71


def calculate_depth (eh):                                                       #line 72

    if  eh. owner ==  None:                                                     #line 73

        return  0                                                               #line 74

    else:                                                                       #line 75

        return  1+calculate_depth ( eh. owner)                                  #line 76

                                                                                #line 77

                                                                                #line 78

def dump_registry (reg):                                                        #line 79

    print ()                                                                    #line 80

    print ( "*** PALETTE ***")                                                  #line 81

    for c in  reg. templates:                                                   #line 82

        print ( c. name)                                                        #line 83


    print ( "***************")                                                  #line 84

    print ()                                                                    #line 85
                                                                                #line 86

                                                                                #line 87

def print_stats (reg):                                                          #line 88

    print ( str( "registry statistics: ") +  reg. stats )                       #line 89
                                                                                #line 90

                                                                                #line 91

def mangle_name (s):                                                            #line 92

    # trim name to remove code from Container component names _ deferred until later (or never)#line 93

    return  s                                                                   #line 94
                                                                                #line 95

                                                                                #line 96

import subprocess                                                               #line 97

def generate_shell_components (reg,container_list):                             #line 98

    # [                                                                         #line 99

    #     {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 100

    #     {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []}#line 101

    # ]                                                                         #line 102

    if  None!= container_list:                                                  #line 103

        for diagram in  container_list:                                         #line 104

            # loop through every component in the diagram and look for names that start with “$“#line 105

            # {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},#line 106

            for child_descriptor in  diagram ["children"]:                      #line 107

                if first_char_is ( child_descriptor ["name"], "$"):             #line 108

                    name =  child_descriptor ["name"]                           #line 109

                    cmd =   name[1:] .strip ()                                  #line 110

                    generated_leaf = Template ( name, shell_out_instantiate, cmd)#line 111

                    register_component ( reg, generated_leaf)                   #line 112

                elif first_char_is ( child_descriptor ["name"], "'"):           #line 113

                    name =  child_descriptor ["name"]                           #line 114

                    s =   name[1:]                                              #line 115

                    generated_leaf = Template ( name, string_constant_instantiate, s)#line 116

                    register_component_allow_overwriting ( reg, generated_leaf) #line 117
                                                                                #line 118

                                                                                #line 119

                                                                                #line 120

                                                                                #line 121

                                                                                #line 122

                                                                                #line 123

def first_char (s):                                                             #line 124

    return   s[0]                                                               #line 125
                                                                                #line 126

                                                                                #line 127

def first_char_is (s,c):                                                        #line 128

    return  c == first_char ( s)                                                #line 129
                                                                                #line 130

                                                                                #line 131
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 132
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 133

def run_command (eh,cmd,s):                                                     #line 134

    # capture_output ∷ ⊤                                                        #line 135

    ret =  subprocess.run ( cmd, s, "UTF_8")                                    #line 136

    if not ( ret. returncode ==  0):                                            #line 137

        if  ret. stderr!= None:                                                 #line 138

            return [ "", ret. stderr]                                           #line 139

        else:                                                                   #line 140

            return [ "", str( "error in shell_out ") +  ret. returncode ]
                                                                                #line 141

    else:                                                                       #line 142

        return [ ret. stdout, None]                                             #line 143

                                                                                #line 144

                                                                                #line 145
# Data for an asyncronous component _ effectively, a function with input        #line 146
# and output queues of messages.                                                #line 147
#                                                                               #line 148
# Components can either be a user_supplied function (“lea“), or a “container“   #line 149
# that routes messages to child components according to a list of connections   #line 150
# that serve as a message routing table.                                        #line 151
#                                                                               #line 152
# Child components themselves can be leaves or other containers.                #line 153
#                                                                               #line 154
# `handler` invokes the code that is attached to this component.                #line 155
#                                                                               #line 156
# `instance_data` is a pointer to instance data that the `leaf_handler`         #line 157
# function may want whenever it is invoked again.                               #line 158
#                                                                               #line 159
                                                                                #line 160

import queue                                                                    #line 161

import sys                                                                      #line 162
                                                                                #line 163
                                                                                #line 164
# Eh_States :: enum { idle, active }                                            #line 165

class Eh:
    def __init__ (self,):                                                       #line 166

        self.name =  ""                                                         #line 167

        self.inq =  queue.Queue ()                                              #line 168

        self.outq =  queue.Queue ()                                             #line 169

        self.owner =  None                                                      #line 170

        self.saved_messages =  queue.LifoQueue () # stack of saved message(s)   #line 171

        self.inject =  injector_NIY                                             #line 172

        self.children = []                                                      #line 173

        self.visit_ordering =  queue.Queue ()                                   #line 174

        self.connections = []                                                   #line 175

        self.routings =  queue.Queue ()                                         #line 176

        self.handler =  None                                                    #line 177

        self.instance_data =  None                                              #line 178

        self.state =  "idle"                                                    #line 179
        # bootstrap debugging                                                   #line 180

        self.kind =  None # enum { container, leaf, }                           #line 181

        self.trace =  False # set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component)#line 182

        self.depth =  0 # hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc.#line 183
                                                                                #line 184

                                                                                #line 185
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 186
# whose handler function is `container_handler`.                                #line 187

def make_container (name,owner):                                                #line 188

    eh = Eh ()                                                                  #line 189

    eh. name =  name                                                            #line 190

    eh. owner =  owner                                                          #line 191

    eh. handler =  container_handler                                            #line 192

    eh. inject =  container_injector                                            #line 193

    eh. state =  "idle"                                                         #line 194

    eh. kind =  "container"                                                     #line 195

    return  eh                                                                  #line 196
                                                                                #line 197

                                                                                #line 198
# Creates a new leaf component out of a handler function, and a data parameter  #line 199
# that will be passed back to your handler when called.                         #line 200
                                                                                #line 201

def make_leaf (name,owner,instance_data,handler):                               #line 202

    eh = Eh ()                                                                  #line 203

    eh. name =  str( owner. name) +  str( ".") +  name                          #line 204

    eh. owner =  owner                                                          #line 205

    eh. handler =  handler                                                      #line 206

    eh. instance_data =  instance_data                                          #line 207

    eh. state =  "idle"                                                         #line 208

    eh. kind =  "leaf"                                                          #line 209

    return  eh                                                                  #line 210
                                                                                #line 211

                                                                                #line 212
# Sends a message on the given `port` with `data`, placing it on the output     #line 213
# of the given component.                                                       #line 214
                                                                                #line 215

def send (eh,port,datum,causingMessage):                                        #line 216

    msg = make_message ( port, datum)                                           #line 217

    log_send ( eh, port, msg, causingMessage)                                   #line 218

    put_output ( eh, msg)                                                       #line 219
                                                                                #line 220

                                                                                #line 221

def send_string (eh,port,s,causingMessage):                                     #line 222

    datum = new_datum_string ( s)                                               #line 223

    msg = make_message ( port, datum)                                           #line 224

    log_send_string ( eh, sender_port, msg, cause_causingMessage)               #line 225

    put_output ( eh, msg)                                                       #line 226
                                                                                #line 227

                                                                                #line 228

def forward (eh,port,msg):                                                      #line 229

    fwdmsg = make_message ( port, msg. datum)                                   #line 230

    log_forward ( eh, sender_port, msg, cause_msg)                              #line 231

    put_output ( eh, msg)                                                       #line 232
                                                                                #line 233

                                                                                #line 234

def inject (eh,msg):                                                            #line 235

    eh.inject ( eh, msg)                                                        #line 236
                                                                                #line 237

                                                                                #line 238
# Returns a list of all output messages on a container.                         #line 239
# For testing / debugging purposes.                                             #line 240
                                                                                #line 241

def output_list (eh):                                                           #line 242

    return  eh. outq                                                            #line 243
                                                                                #line 244

                                                                                #line 245
# Utility for printing an array of messages.                                    #line 246

def print_output_list (eh):                                                     #line 247

    for m in list ( eh. outq. queue):                                           #line 248

        print (format_message ( m))                                             #line 249

                                                                                #line 250

                                                                                #line 251

def spaces (n):                                                                 #line 252

    s =  ""                                                                     #line 253

    for i in range( n):                                                         #line 254

        s =  s+ " "                                                             #line 255


    return  s                                                                   #line 256
                                                                                #line 257

                                                                                #line 258

def set_active (eh):                                                            #line 259

    eh. state =  "active"                                                       #line 260
                                                                                #line 261

                                                                                #line 262

def set_idle (eh):                                                              #line 263

    eh. state =  "idle"                                                         #line 264
                                                                                #line 265

                                                                                #line 266
# Utility for printing a specific output message.                               #line 267
                                                                                #line 268

def fetch_first_output (eh,port):                                               #line 269

    for msg in list ( eh. outq. queue):                                         #line 270

        if ( msg. port ==  port):                                               #line 271

            return  msg. datum
                                                                                #line 272


    return  None                                                                #line 273
                                                                                #line 274

                                                                                #line 275

def print_specific_output (eh,port):                                            #line 276

    # port ∷ “”                                                                 #line 277

    datum = fetch_first_output ( eh, port)                                      #line 278

    outf =  None                                                                #line 279

    if  datum!= None:                                                           #line 280

        outf =  sys. stdout                                                     #line 281

        print ( datum.srepr (), outf)                                           #line 282

                                                                                #line 283


def print_specific_output_to_stderr (eh,port):                                  #line 284

    # port ∷ “”                                                                 #line 285

    datum = fetch_first_output ( eh, port)                                      #line 286

    outf =  None                                                                #line 287

    if  datum!= None:                                                           #line 288

        # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 289

        outf =  sys. stderr                                                     #line 290

        print ( datum.srepr (), outf)                                           #line 291

                                                                                #line 292

                                                                                #line 293

def put_output (eh,msg):                                                        #line 294

    eh. outq.put ( msg)                                                         #line 295
                                                                                #line 296

                                                                                #line 297

def injector_NIY (eh,msg):                                                      #line 298

    # print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“')#line 299

    print ( str( "Injector not implemented for this component ") +  str( eh. name) +  str( " kind ∷ ") +  str( eh. kind) +  str( ",  port ∷ ") +  msg. port     )#line 304

    exit ()                                                                     #line 305
                                                                                #line 306

                                                                                #line 307

import sys                                                                      #line 308

import re                                                                       #line 309

import subprocess                                                               #line 310

import shlex                                                                    #line 311
                                                                                #line 312

root_project =  ""                                                              #line 313

root_0D =  ""                                                                   #line 314
                                                                                #line 315

def set_environment (rproject,r0D):                                             #line 316

    global root_project                                                         #line 317

    global root_0D                                                              #line 318

    root_project =  rproject                                                    #line 319

    root_0D =  r0D                                                              #line 320
                                                                                #line 321

                                                                                #line 322

def probe_instantiate (reg,owner,name,template_data):                           #line 323

    name_with_id = gensymbol ( "?")                                             #line 324

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 325
                                                                                #line 326


def probeA_instantiate (reg,owner,name,template_data):                          #line 327

    name_with_id = gensymbol ( "?A")                                            #line 328

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 329
                                                                                #line 330

                                                                                #line 331

def probeB_instantiate (reg,owner,name,template_data):                          #line 332

    name_with_id = gensymbol ( "?B")                                            #line 333

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 334
                                                                                #line 335

                                                                                #line 336

def probeC_instantiate (reg,owner,name,template_data):                          #line 337

    name_with_id = gensymbol ( "?C")                                            #line 338

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 339
                                                                                #line 340

                                                                                #line 341

def probe_handler (eh,msg):                                                     #line 342

    s =  msg. datum.srepr ()                                                    #line 343

    print ( str( "... probe ") +  str( eh. name) +  str( ": ") +  s   , sys. stderr)#line 344
                                                                                #line 345

                                                                                #line 346

def trash_instantiate (reg,owner,name,template_data):                           #line 347

    name_with_id = gensymbol ( "trash")                                         #line 348

    return make_leaf ( name_with_id, owner, None, trash_handler)                #line 349
                                                                                #line 350

                                                                                #line 351

def trash_handler (eh,msg):                                                     #line 352

    # to appease dumped_on_floor checker                                        #line 353

    pass                                                                        #line 354
                                                                                #line 355


class TwoMessages:
    def __init__ (self,first,second):                                           #line 356

        self.first =  first                                                     #line 357

        self.second =  second                                                   #line 358
                                                                                #line 359

                                                                                #line 360
# Deracer_States :: enum { idle, waitingForFirst, waitingForSecond }            #line 361

class Deracer_Instance_Data:
    def __init__ (self,state,buffer):                                           #line 362

        self.state =  state                                                     #line 363

        self.buffer =  buffer                                                   #line 364
                                                                                #line 365

                                                                                #line 366

def reclaim_Buffers_from_heap (inst):                                           #line 367

    pass                                                                        #line 368
                                                                                #line 369

                                                                                #line 370

def deracer_instantiate (reg,owner,name,template_data):                         #line 371

    name_with_id = gensymbol ( "deracer")                                       #line 372

    inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))            #line 373

    inst. state =  "idle"                                                       #line 374

    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)                #line 375

    return  eh                                                                  #line 376
                                                                                #line 377

                                                                                #line 378

def send_first_then_second (eh,inst):                                           #line 379

    forward ( eh, "1", inst. buffer. first)                                     #line 380

    forward ( eh, "2", inst. buffer. second)                                    #line 381

    reclaim_Buffers_from_heap ( inst)                                           #line 382
                                                                                #line 383

                                                                                #line 384

def deracer_handler (eh,msg):                                                   #line 385

    inst =  eh. instance_data                                                   #line 386

    if  inst. state ==  "idle":                                                 #line 387

        if  "1" ==  msg. port:                                                  #line 388

            inst. buffer. first =  msg                                          #line 389

            inst. state =  "waitingForSecond"                                   #line 390

        elif  "2" ==  msg. port:                                                #line 391

            inst. buffer. second =  msg                                         #line 392

            inst. state =  "waitingForFirst"                                    #line 393

        else:                                                                   #line 394

            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg. port )
                                                                                #line 395

    elif  inst. state ==  "waitingForFirst":                                    #line 396

        if  "1" ==  msg. port:                                                  #line 397

            inst. buffer. first =  msg                                          #line 398

            send_first_then_second ( eh, inst)                                  #line 399

            inst. state =  "idle"                                               #line 400

        else:                                                                   #line 401

            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg. port )
                                                                                #line 402

    elif  inst. state ==  "waitingForSecond":                                   #line 403

        if  "2" ==  msg. port:                                                  #line 404

            inst. buffer. second =  msg                                         #line 405

            send_first_then_second ( eh, inst)                                  #line 406

            inst. state =  "idle"                                               #line 407

        else:                                                                   #line 408

            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg. port )
                                                                                #line 409

    else:                                                                       #line 410

        runtime_error ( "bad state for deracer {eh.state}")                     #line 411

                                                                                #line 412

                                                                                #line 413

def low_level_read_text_file_instantiate (reg,owner,name,template_data):        #line 414

    name_with_id = gensymbol ( "Low Level Read Text File")                      #line 415

    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 416
                                                                                #line 417

                                                                                #line 418

def low_level_read_text_file_handler (eh,msg):                                  #line 419

    fname =  msg. datum.srepr ()                                                #line 420

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
                                                                                #line 421
                                                                                #line 422

                                                                                #line 423

def ensure_string_datum_instantiate (reg,owner,name,template_data):             #line 424

    name_with_id = gensymbol ( "Ensure String Datum")                           #line 425

    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)  #line 426
                                                                                #line 427

                                                                                #line 428

def ensure_string_datum_handler (eh,msg):                                       #line 429

    if  "string" ==  msg. datum.kind ():                                        #line 430

        forward ( eh, "", msg)                                                  #line 431

    else:                                                                       #line 432

        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg. datum #line 433

        send_string ( eh, "✗", emsg, msg)                                       #line 434

                                                                                #line 435

                                                                                #line 436

class Syncfilewrite_Data:
    def __init__ (self,):                                                       #line 437

        self.filename =  ""                                                     #line 438
                                                                                #line 439

                                                                                #line 440
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)   #line 441

def syncfilewrite_instantiate (reg,owner,name,template_data):                   #line 442

    name_with_id = gensymbol ( "syncfilewrite")                                 #line 443

    inst = Syncfilewrite_Data ()                                                #line 444

    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)        #line 445
                                                                                #line 446

                                                                                #line 447

def syncfilewrite_handler (eh,msg):                                             #line 448

    inst =  eh. instance_data                                                   #line 449

    if  "filename" ==  msg. port:                                               #line 450

        inst. filename =  msg. datum.srepr ()                                   #line 451

    elif  "input" ==  msg. port:                                                #line 452

        contents =  msg. datum.srepr ()                                         #line 453

        f = open ( inst. filename, "w")                                         #line 454

        if  f!= None:                                                           #line 455

            f.write ( msg. datum.srepr ())                                      #line 456

            f.close ()                                                          #line 457

            send ( eh, "done",new_datum_bang (), msg)                           #line 458

        else:                                                                   #line 459

            send_string ( eh, "✗", str( "open error on file ") +  inst. filename , msg)
                                                                                #line 460

                                                                                #line 461

                                                                                #line 462

class StringConcat_Instance_Data:
    def __init__ (self,):                                                       #line 463

        self.buffer1 =  None                                                    #line 464

        self.buffer2 =  None                                                    #line 465

        self.count =  0                                                         #line 466
                                                                                #line 467

                                                                                #line 468

def stringconcat_instantiate (reg,owner,name,template_data):                    #line 469

    name_with_id = gensymbol ( "stringconcat")                                  #line 470

    instp = StringConcat_Instance_Data ()                                       #line 471

    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)        #line 472
                                                                                #line 473

                                                                                #line 474

def stringconcat_handler (eh,msg):                                              #line 475

    inst =  eh. instance_data                                                   #line 476

    if  "1" ==  msg. port:                                                      #line 477

        inst. buffer1 = clone_string ( msg. datum.srepr ())                     #line 478

        inst. count =  inst. count+ 1                                           #line 479

        maybe_stringconcat ( eh, inst, msg)                                     #line 480

    elif  "2" ==  msg. port:                                                    #line 481

        inst. buffer2 = clone_string ( msg. datum.srepr ())                     #line 482

        inst. count =  inst. count+ 1                                           #line 483

        maybe_stringconcat ( eh, inst, msg)                                     #line 484

    else:                                                                       #line 485

        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg. port )  #line 486
                                                                                #line 487

                                                                                #line 488

                                                                                #line 489

def maybe_stringconcat (eh,inst,msg):                                           #line 490

    if ( 0 == len ( inst. buffer1)) and ( 0 == len ( inst. buffer2)):           #line 491

        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 492


    if  inst. count >=  2:                                                      #line 493

        concatenated_string =  ""                                               #line 494

        if  0 == len ( inst. buffer1):                                          #line 495

            concatenated_string =  inst. buffer2                                #line 496

        elif  0 == len ( inst. buffer2):                                        #line 497

            concatenated_string =  inst. buffer1                                #line 498

        else:                                                                   #line 499

            concatenated_string =  inst. buffer1+ inst. buffer2                 #line 500


        send_string ( eh, "", concatenated_string, msg)                         #line 501

        inst. buffer1 =  None                                                   #line 502

        inst. buffer2 =  None                                                   #line 503

        inst. count =  0                                                        #line 504

                                                                                #line 505

                                                                                #line 506
#                                                                               #line 507
                                                                                #line 508
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 509

def shell_out_instantiate (reg,owner,name,template_data):                       #line 510

    name_with_id = gensymbol ( "shell_out")                                     #line 511

    cmd =  shlex.split ( template_data)                                         #line 512

    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)             #line 513
                                                                                #line 514

                                                                                #line 515

def shell_out_handler (eh,msg):                                                 #line 516

    cmd =  eh. instance_data                                                    #line 517

    s =  msg. datum.srepr ()                                                    #line 518

    [ stdout, stderr] = run_command ( eh, cmd, s)                               #line 519

    if  stderr!= None:                                                          #line 520

        send_string ( eh, "✗", stderr, msg)                                     #line 521

    else:                                                                       #line 522

        send_string ( eh, "", stdout, msg)                                      #line 523

                                                                                #line 524

                                                                                #line 525

def string_constant_instantiate (reg,owner,name,template_data):                 #line 526

    global root_project                                                         #line 527

    global root_0D                                                              #line 528

    name_with_id = gensymbol ( "strconst")                                      #line 529

    s =  template_data                                                          #line 530

    if  root_project!= "":                                                      #line 531

        s =  re.sub ( "_00_", root_project, s)                                  #line 532


    if  root_0D!= "":                                                           #line 533

        s =  re.sub ( "_0D_", root_0D, s)                                       #line 534


    return make_leaf ( name_with_id, owner, s, string_constant_handler)         #line 535
                                                                                #line 536

                                                                                #line 537

def string_constant_handler (eh,msg):                                           #line 538

    s =  eh. instance_data                                                      #line 539

    send_string ( eh, "", s, msg)                                               #line 540
                                                                                #line 541

                                                                                #line 542

def string_make_persistent (s):                                                 #line 543

    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 544

    return  s                                                                   #line 545
                                                                                #line 546

                                                                                #line 547

def string_clone (s):                                                           #line 548

    return  s                                                                   #line 549
                                                                                #line 550

                                                                                #line 551

import sys                                                                      #line 552
                                                                                #line 553
# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...   #line 554
# where ${_00_} is the root directory for the project                           #line 555
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)        #line 556
                                                                                #line 557
                                                                                #line 558
                                                                                #line 559

def initialize_component_palette (root_project,root_0D,diagram_source_files):   #line 560

    reg = make_component_registry ()                                            #line 561

    for diagram_source in  diagram_source_files:                                #line 562

        all_containers_within_single_file = json2internal ( diagram_source)     #line 563

        generate_shell_components ( reg, all_containers_within_single_file)     #line 564

        for container in  all_containers_within_single_file:                    #line 565

            register_component ( reg,Template ( container ["name"], container, container_instantiator))
                                                                                #line 566


    initialize_stock_components ( reg)                                          #line 567

    return  reg                                                                 #line 568
                                                                                #line 569

                                                                                #line 570

def print_error_maybe (main_container):                                         #line 571

    error_port =  "✗"                                                           #line 572

    err = fetch_first_output ( main_container, error_port)                      #line 573

    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):                   #line 574

        print ( "___ !!! ERRORS !!! ___")                                       #line 575

        print_specific_output ( main_container, error_port, False)              #line 576

                                                                                #line 577

                                                                                #line 578
# debugging helpers                                                             #line 579
                                                                                #line 580

def dump_outputs (main_container):                                              #line 581

    print ()                                                                    #line 582

    print ( "___ Outputs ___")                                                  #line 583

    print_output_list ( main_container)                                         #line 584
                                                                                #line 585

                                                                                #line 586

def trace_outputs (main_container):                                             #line 587

    print ()                                                                    #line 588

    print ( "___ Message Traces ___")                                           #line 589

    print_routing_trace ( main_container)                                       #line 590
                                                                                #line 591

                                                                                #line 592

def dump_hierarchy (main_container):                                            #line 593

    print ()                                                                    #line 594

    print ( str( "___ Hierarchy ___") + (build_hierarchy ( main_container)) )   #line 595
                                                                                #line 596

                                                                                #line 597

def build_hierarchy (c):                                                        #line 598

    s =  ""                                                                     #line 599

    for child in  c. children:                                                  #line 600

        s =  str( s) + build_hierarchy ( child)                                 #line 601


    indent =  ""                                                                #line 602

    for i in range( c. depth):                                                  #line 603

        indent =  indent+ "  "                                                  #line 604


    return  str( "\n") +  str( indent) +  str( "(") +  str( c. name) +  str( s) +  ")"     #line 605
                                                                                #line 606

                                                                                #line 607

def dump_connections (c):                                                       #line 608

    print ()                                                                    #line 609

    print ( "___ connections ___")                                              #line 610

    dump_possible_connections ( c)                                              #line 611

    for child in  c. children:                                                  #line 612

        print ()                                                                #line 613

        dump_possible_connections ( child)                                      #line 614

                                                                                #line 615

                                                                                #line 616

def trimws (s):                                                                 #line 617

    # remove whitespace from front and back of string                           #line 618

    return  s.strip ()                                                          #line 619
                                                                                #line 620

                                                                                #line 621

def clone_string (s):                                                           #line 622

    return  s                                                                   #line 623
                                                                                #line 624
                                                                                #line 625


load_errors =  False                                                            #line 626

runtime_errors =  False                                                         #line 627
                                                                                #line 628

def load_error (s):                                                             #line 629

    global load_errors                                                          #line 630

    print ( s)                                                                  #line 631

    quit ()                                                                     #line 632

    load_errors =  True                                                         #line 633
                                                                                #line 634

                                                                                #line 635

def runtime_error (s):                                                          #line 636

    global runtime_errors                                                       #line 637

    print ( s)                                                                  #line 638

    quit ()                                                                     #line 639

    runtime_errors =  True                                                      #line 640
                                                                                #line 641

                                                                                #line 642

def fakepipename_instantiate (reg,owner,name,template_data):                    #line 643

    instance_name = gensymbol ( "fakepipe")                                     #line 644

    return make_leaf ( instance_name, owner, None, fakepipename_handler)        #line 645
                                                                                #line 646

                                                                                #line 647

rand =  0                                                                       #line 648
                                                                                #line 649

def fakepipename_handler (eh,msg):                                              #line 650

    global rand                                                                 #line 651

    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 652

    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)                  #line 653
                                                                                #line 654

                                                                                #line 655
                                                                                #line 656
# all of the the built_in leaves are listed here                                #line 657
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 658
                                                                                #line 659
                                                                                #line 660

def initialize_stock_components (reg):                                          #line 661

    register_component ( reg,Template ( "1then2", None, deracer_instantiate))   #line 662

    register_component ( reg,Template ( "?", None, probe_instantiate))          #line 663

    register_component ( reg,Template ( "?A", None, probeA_instantiate))        #line 664

    register_component ( reg,Template ( "?B", None, probeB_instantiate))        #line 665

    register_component ( reg,Template ( "?C", None, probeC_instantiate))        #line 666

    register_component ( reg,Template ( "trash", None, trash_instantiate))      #line 667
                                                                                #line 668

    register_component ( reg,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 669

    register_component ( reg,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 670
                                                                                #line 671

    register_component ( reg,Template ( "syncfilewrite", None, syncfilewrite_instantiate))#line 672

    register_component ( reg,Template ( "stringconcat", None, stringconcat_instantiate))#line 673

    # for fakepipe                                                              #line 674

    register_component ( reg,Template ( "fakepipename", None, fakepipename_instantiate))#line 675
                                                                                #line 676

                                                                                #line 677
                                                                                #line 678

def initialize ():                                                              #line 679

    root_of_project =  sys.argv[ 1]                                             #line 680

    root_of_0D =  sys.argv[ 2]                                                  #line 681

    arg =  sys.argv[ 3]                                                         #line 682

    main_container_name =  sys.argv[ 4]                                         #line 683

    diagram_names =  sys.argv[ 5:]                                              #line 684

    palette = initialize_component_palette ( root_project, root_0D, diagram_names)#line 685

    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 686
                                                                                #line 687

                                                                                #line 688

def start (palette,env):
    start_with_debug ( palette, env, False, False, False, False)                #line 689


def start_with_debug (palette,env,show_hierarchy,show_connections,show_traces,show_all_outputs):#line 690

    # show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥   #line 691

    root_of_project =  env [ 0]                                                 #line 692

    root_of_0D =  env [ 1]                                                      #line 693

    main_container_name =  env [ 2]                                             #line 694

    diagram_names =  env [ 3]                                                   #line 695

    arg =  env [ 4]                                                             #line 696

    set_environment ( root_of_project, root_of_0D)                              #line 697

    # get entrypoint container                                                  #line 698

    main_container = get_component_instance ( palette, main_container_name, None)#line 699

    if  None ==  main_container:                                                #line 700

        load_error ( str( "Couldn't find container with page name ") +  str( main_container_name) +  str( " in files ") +  str( diagram_names) +  "(check tab names, or disable compression?)"    )#line 704
                                                                                #line 705


    if  show_hierarchy:                                                         #line 706

        dump_hierarchy ( main_container)                                        #line 707
                                                                                #line 708


    if  show_connections:                                                       #line 709

        dump_connections ( main_container)                                      #line 710
                                                                                #line 711


    if not  load_errors:                                                        #line 712

        arg = new_datum_string ( arg)                                           #line 713

        msg = make_message ( "", arg)                                           #line 714

        inject ( main_container, msg)                                           #line 715

        if  show_all_outputs:                                                   #line 716

            dump_outputs ( main_container)                                      #line 717

        else:                                                                   #line 718

            print_error_maybe ( main_container)                                 #line 719

            print_specific_output ( main_container, "")                         #line 720

            if  show_traces:                                                    #line 721

                print ( "--- routing traces ---")                               #line 722

                print (routing_trace_all ( main_container))                     #line 723
                                                                                #line 724

                                                                                #line 725


        if  show_all_outputs:                                                   #line 726

            print ( "--- done ---")                                             #line 727
                                                                                #line 728

                                                                                #line 729

                                                                                #line 730

                                                                                #line 731
                                                                                #line 732
                                                                                #line 733
# utility functions                                                             #line 734

def send_int (eh,port,i,causing_message):                                       #line 735

    datum = new_datum_int ( i)                                                  #line 736

    send ( eh, port, datum, causing_message)                                    #line 737
                                                                                #line 738

                                                                                #line 739

def send_bang (eh,port,causing_message):                                        #line 740

    datum = new_datum_bang ()                                                   #line 741

    send ( eh, port, datum, causing_message)                                    #line 742
                                                                                #line 743

                                                                                #line 744





