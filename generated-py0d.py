

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
    def __init__ (self):                                                        #line 28

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

    d.data =  s                                                                 #line 39

    d.clone =  lambda : clone_datum_string ( d)                                 #line 40

    d.reclaim =  lambda : reclaim_datum_string ( d)                             #line 41

    d.srepr =  lambda : srepr_datum_string ( d)                                 #line 42

    d.raw =  lambda : raw_datum_string ( d)                                     #line 43

    d.kind =  lambda :  "string"                                                #line 44

    return  d                                                                   #line 45
                                                                                #line 46

                                                                                #line 47

def clone_datum_string (d):                                                     #line 48

    d = new_datum_string ( d.data)                                              #line 49

    return  d                                                                   #line 50
                                                                                #line 51

                                                                                #line 52

def reclaim_datum_string (src):                                                 #line 53

    pass                                                                        #line 54
                                                                                #line 55

                                                                                #line 56

def srepr_datum_string (d):                                                     #line 57

    return  d.data                                                              #line 58
                                                                                #line 59

                                                                                #line 60

def raw_datum_string (d):                                                       #line 61

    return bytearray ( d.data, "UTF_8")                                         #line 62
                                                                                #line 63

                                                                                #line 64

def new_datum_bang ():                                                          #line 65

    p = Datum ()                                                                #line 66

    p.data =  True                                                              #line 67

    p.clone =  lambda : clone_datum_bang ( p)                                   #line 68

    p.reclaim =  lambda : reclaim_datum_bang ( p)                               #line 69

    p.srepr =  lambda : srepr_datum_bang ()                                     #line 70

    p.raw =  lambda : raw_datum_bang ()                                         #line 71

    p.kind =  lambda :  "bang"                                                  #line 72

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

    p.kind =  lambda :  "tick"                                                  #line 94

    p.clone =  lambda : new_datum_tick ()                                       #line 95

    p.srepr =  lambda : srepr_datum_tick ()                                     #line 96

    p.raw =  lambda : raw_datum_tick ()                                         #line 97

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

    p.data =  b                                                                 #line 111

    p.clone =  clone_datum_bytes                                                #line 112

    p.reclaim =  lambda : reclaim_datum_bytes ( p)                              #line 113

    p.srepr =  lambda : srepr_datum_bytes ( b)                                  #line 114

    p.raw =  lambda : raw_datum_bytes ( b)                                      #line 115

    p.kind =  lambda :  "bytes"                                                 #line 116

    return  p                                                                   #line 117
                                                                                #line 118

                                                                                #line 119

def clone_datum_bytes (src):                                                    #line 120

    p = Datum ()                                                                #line 121

    p =  src                                                                    #line 122

    p.data =  src.clone ()                                                      #line 123

    return  p                                                                   #line 124
                                                                                #line 125

                                                                                #line 126

def reclaim_datum_bytes (src):                                                  #line 127

    pass                                                                        #line 128
                                                                                #line 129

                                                                                #line 130

def srepr_datum_bytes (d):                                                      #line 131

    return  d.data.decode ( "UTF_8")                                            #line 132
                                                                                #line 133


def raw_datum_bytes (d):                                                        #line 134

    return  d.data                                                              #line 135
                                                                                #line 136

                                                                                #line 137

def new_datum_handle (h):                                                       #line 138

    return new_datum_int ( h)                                                   #line 139
                                                                                #line 140

                                                                                #line 141

def new_datum_int (i):                                                          #line 142

    p = Datum ()                                                                #line 143

    p.data =  i                                                                 #line 144

    p.clone =  lambda : clone_int ( i)                                          #line 145

    p.reclaim =  lambda : reclaim_int ( i)                                      #line 146

    p.srepr =  lambda : srepr_datum_int ( i)                                    #line 147

    p.raw =  lambda : raw_datum_int ( i)                                        #line 148

    p.kind =  lambda :  "int"                                                   #line 149

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
    def __init__ (selfport,datum):                                              #line 174

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

    m = Message (port= p,datum= datum.clone ())                                 #line 187

    return  m                                                                   #line 188
                                                                                #line 189

                                                                                #line 190
# Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations.#line 191

def message_clone (message):                                                    #line 192

    m = Message (port=clone_port ( message.port),datum= message.datum.clone ()) #line 193

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

        return  str( "⟪") +  str( m.port) +  str( "⦂") +  str( m.datum.srepr ()) +  "⟫"    #line 219
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

    rdesc = make_Routing_Descriptor (action= drSend,component= component,port= port,message= message)#line 248

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

    send_desc = make_Send_Descriptor (component= sender,port= sender_port,message= msg,cause_port= cause_msg.port,cause_message= cause_msg)#line 261

    append_routing_descriptor (container= sender.owner,desc= send_desc)         #line 262
                                                                                #line 263

                                                                                #line 264

def log_send_string (sender,sender_port,msg,cause_msg):                         #line 265

    send_desc = make_Send_Descriptor ( sender, sender_port, msg, cause_msg.port, cause_msg)#line 266

    append_routing_descriptor (container= sender.owner,desc= send_desc)         #line 267
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

    rdesc = make_Routing_Descriptor (action= drSend,component= component,port= port,message= message)#line 281

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

    rdesc = make_Routing_Descriptor (action= drInject,component= receiver,port= port,message= message)#line 305

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

    inject_desc = make_Inject_Descriptor (receiver= receiver,port= port,message= msg)#line 316

    append_routing_descriptor (container= receiver,desc= inject_desc)           #line 317
                                                                                #line 318

                                                                                #line 319

def fmt_inject (desc,indent):                                                   #line 320

    #return f'\n{indent}⟹  {desc@component.name}.“{desc@port}“ {format_message (desc@message)}'#line 321

    return  str( "\n") +  str( indent) +  str( "⟹  ") +  str( desc ["component"].name) +  str( ".") +  str( desc ["port"]) +  str( " ") + format_message ( desc ["message"])       #line 328
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

    return  str( "\n") +  str( indent) +  str( " ↓ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"].name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + format_message ( desc ["target_message"])           #line 362
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

    return  str( "\n") +  str( indent) +  str( "↑ ") +  str( desc ["source"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["container_port"]) +  str( " ") + format_message ( desc ["container_message"])           #line 396
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

    return  str( "\n") +  str( indent) +  str( "→ ") +  str( desc ["source"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"].name) +  str( ".") +  str( desc ["target_port"]) +  str( "  ") + format_message ( desc ["target_message"])           #line 430
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

    return  str( "\n") +  str( indent) +  str( "⇶ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + format_message ( desc ["message"])           #line 463
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

    if  component.outq.empty ():                                                #line 479

        log_inout_no_output (container= container,component= component,in_message= in_message)#line 480

    else:                                                                       #line 481

        log_inout_recursively (container= container,component= component,in_message= in_message,out_messages=list ( component.outq.queue))#line 482

                                                                                #line 483

                                                                                #line 484

def log_inout_no_output (container,component,in_message):                       #line 485

    rdesc = make_InOut_Descriptor (container= container,component= component,in_message= in_message,#line 486
    out_port= None,out_message= None)                                           #line 487

    append_routing_descriptor ( container, rdesc)                               #line 488
                                                                                #line 489

                                                                                #line 490

def log_inout_single (container,component,in_message,out_message):              #line 491

    rdesc = make_InOut_Descriptor (container= container,component= component,in_message= in_message,#line 492
    out_port= None,out_message= out_message)                                    #line 493

    append_routing_descriptor ( container, rdesc)                               #line 494
                                                                                #line 495

                                                                                #line 496

def log_inout_recursively (container,component,in_message,out_messages=[]):     #line 497

    if [] ==  out_messages:                                                     #line 498

        pass                                                                    #line 499

    else:                                                                       #line 500

        m =   out_messages[0]                                                   #line 501

        rest =   out_messages[1:]                                               #line 502

        log_inout_single (container= container,component= component,in_message= in_message,out_message= m)#line 503

        log_inout_recursively (container= container,component= component,in_message= in_message,out_messages= rest)#line 504

                                                                                #line 505

                                                                                #line 506

def fmt_inout (desc,indent):                                                    #line 507

    outm =  desc ["out_message"]                                                #line 508

    if  None ==  outm:                                                          #line 509

        return  str( "\n") +  str( indent) +  "  ⊥"                             #line 510

    else:                                                                       #line 511

        return  str( "\n") +  str( indent) +  str( "  ∴ ") +  str( desc ["component"].name) +  str( " ") + format_message ( outm)     #line 516
                                                                                #line 517

                                                                                #line 518

                                                                                #line 519

def log_tick (container,component,in_message):                                  #line 520

    pass                                                                        #line 521
                                                                                #line 522

                                                                                #line 523
#                                                                               #line 524

def routing_trace_all (container):                                              #line 525

    indent =  ""                                                                #line 526

    lis = list ( container.routings.queue)                                      #line 527

    return recursive_routing_trace ( container, lis, indent)                    #line 528
                                                                                #line 529

                                                                                #line 530

def recursive_routing_trace (container,lis,indent):                             #line 531

    if [] ==  lis:                                                              #line 532

        return  ""                                                              #line 533

    else:                                                                       #line 534

        desc = first ( lis)                                                     #line 535

        formatted =  desc ["fmt"] ( desc, indent)                               #line 536

        return  formatted+recursive_routing_trace ( container,rest ( lis), indent+ "  ")#line 537

                                                                                #line 538

                                                                                #line 539

enumDown =  0                                                                   #line 540

enumAcross =  1                                                                 #line 541

enumUp =  2                                                                     #line 542

enumThrough =  3                                                                #line 543
                                                                                #line 544

def container_instantiator (reg,owner,container_name,desc):                     #line 545

    global enumDown, enumUp, enumAcross, enumThrough                            #line 546

    container = make_container ( container_name, owner)                         #line 547

    children = []                                                               #line 548

    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here#line 549

    # collect children                                                          #line 550

    for child_desc in  desc ["children"]:                                       #line 551

        child_instance = get_component_instance ( reg, child_desc ["name"], container)#line 552

        children.append ( child_instance)                                       #line 553

        children_by_id [ child_desc ["id"]] =  child_instance                   #line 554


    container.children =  children                                              #line 555

    me =  container                                                             #line 556
                                                                                #line 557

    connectors = []                                                             #line 558

    for proto_conn in  desc ["connections"]:                                    #line 559

        source_component =  None                                                #line 560

        target_component =  None                                                #line 561

        connector = Connector ()                                                #line 562

        if  proto_conn ["dir"] ==  enumDown:                                    #line 563

            # JSON: {'dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},#line 564

            connector.direction =  "down"                                       #line 565

            connector.sender = Sender ( me.name, me, proto_conn ["source_port"])#line 566

            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 567

            if ( target_component ==  None):                                    #line 568

                load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn ["target"] )#line 569

            else:                                                               #line 570

                connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn ["target_port"], target_component)#line 571

                connectors.append ( connector)
                                                                                #line 572

        elif  proto_conn ["dir"] ==  enumAcross:                                #line 573

            connector.direction =  "across"                                     #line 574

            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 575

            target_component =  children_by_id [ proto_conn ["target"] ["id"]]  #line 576

            if  source_component ==  None:                                      #line 577

                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn ["source"] )#line 578

            else:                                                               #line 579

                connector.sender = Sender ( source_component.name, source_component, proto_conn ["source_port"])#line 580

                if  target_component ==  None:                                  #line 581

                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn.target )#line 582

                else:                                                           #line 583

                    connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn ["target_port"], target_component)#line 584

                    connectors.append ( connector)

                                                                                #line 585

        elif  proto_conn ["dir"] ==  enumUp:                                    #line 586

            connector.direction =  "up"                                         #line 587

            source_component =  children_by_id [ proto_conn ["source"] ["id"]]  #line 588

            if  source_component ==  None:                                      #line 589

                print ( str( "internal error: .Up connection source not ok ") +  proto_conn ["source"] )#line 590

            else:                                                               #line 591

                connector.sender = Sender ( source_component.name, source_component, proto_conn ["source_port"])#line 592

                connector.receiver = Receiver ( me.name, container.outq, proto_conn ["target_port"], me)#line 593

                connectors.append ( connector)
                                                                                #line 594

        elif  proto_conn ["dir"] ==  enumThrough:                               #line 595

            connector.direction =  "through"                                    #line 596

            connector.sender = Sender ( me.name, me, proto_conn ["source_port"])#line 597

            connector.receiver = Receiver ( me.name, container.outq, proto_conn ["target_port"], me)#line 598

            connectors.append ( connector)
                                                                                #line 599

                                                                                #line 600

    container.connections =  connectors                                         #line 601

    return  container                                                           #line 602
                                                                                #line 603

                                                                                #line 604
# The default handler for container components.                                 #line 605

def container_handler (container,message):                                      #line 606

    route (container= container,from_component= container,message= message)
    # references to 'self' are replaced by the container during instantiation   #line 607

    while any_child_ready ( container):                                         #line 608

        step_children ( container, message)                                     #line 609

                                                                                #line 610

                                                                                #line 611
# Frees the given container and associated data.                                #line 612

def destroy_container (eh):                                                     #line 613

    pass                                                                        #line 614
                                                                                #line 615

                                                                                #line 616

def fifo_is_empty (fifo):                                                       #line 617

    return  fifo.empty ()                                                       #line 618
                                                                                #line 619

                                                                                #line 620
# Routing connection for a container component. The `direction` field has       #line 621
# no affect on the default message routing system _ it is there for debugging   #line 622
# purposes, or for reading by other tools.                                      #line 623
                                                                                #line 624

class Connector:
    def __init__ (self):                                                        #line 625

        self.direction =  None # down, across, up, through                      #line 626

        self.sender =  None                                                     #line 627

        self.receiver =  None                                                   #line 628
                                                                                #line 629

                                                                                #line 630
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,  #line 631
# based on component ID (pointer) and port name.                                #line 632
                                                                                #line 633

class Sender:
    def __init__ (selfname,component,port):                                     #line 634

        self.name =  name                                                       #line 635

        self.component =  component # from                                      #line 636

        self.port =  port # from's port                                         #line 637
                                                                                #line 638

                                                                                #line 639
# `Receiver` is a handle to a destination queue, and a `port` name to assign    #line 640
# to incoming messages to this queue.                                           #line 641
                                                                                #line 642

class Receiver:
    def __init__ (selfname,queue,port,component):                               #line 643

        self.name =  name                                                       #line 644

        self.queue =  queue # queue (input | output) of receiver                #line 645

        self.port =  port # destination port                                    #line 646

        self.component =  component # to (for bootstrap debug)                  #line 647
                                                                                #line 648

                                                                                #line 649
# Checks if two senders match, by pointer equality and port name matching.      #line 650

def sender_eq (s1,s2):                                                          #line 651

    same_components = ( s1.component ==  s2.component)                          #line 652

    same_ports = ( s1.port ==  s2.port)                                         #line 653

    return  same_components and  same_ports                                     #line 654
                                                                                #line 655

                                                                                #line 656
# Delivers the given message to the receiver of this connector.                 #line 657
                                                                                #line 658

def deposit (parent,conn,message):                                              #line 659

    new_message = make_message (port= conn.receiver.port,datum= message.datum)  #line 660

    log_connection ( parent, conn, new_message)                                 #line 661

    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)#line 662
                                                                                #line 663

                                                                                #line 664

def force_tick (parent,eh):                                                     #line 665

    tick_msg = make_message ( ".",new_datum_tick ())                            #line 666

    push_message ( parent, eh, eh.inq, tick_msg)                                #line 667

    return  tick_msg                                                            #line 668
                                                                                #line 669

                                                                                #line 670

def push_message (parent,receiver,inq,m):                                       #line 671

    inq.put ( m)                                                                #line 672

    parent.visit_ordering.put ( receiver)                                       #line 673
                                                                                #line 674

                                                                                #line 675

def is_self (child,container):                                                  #line 676

    # in an earlier version “self“ was denoted as ϕ                             #line 677

    return  child ==  container                                                 #line 678
                                                                                #line 679

                                                                                #line 680

def step_child (child,msg):                                                     #line 681

    before_state =  child.state                                                 #line 682

    child.handler ( child, msg)                                                 #line 683

    after_state =  child.state                                                  #line 684

    return [ before_state ==  "idle" and  after_state!= "idle",                 #line 685
    before_state!= "idle" and  after_state!= "idle",                            #line 686
    before_state!= "idle" and  after_state ==  "idle"]                          #line 687
                                                                                #line 688

                                                                                #line 689

def save_message (eh,msg):                                                      #line 690

    eh.saved_messages.put ( msg)                                                #line 691
                                                                                #line 692

                                                                                #line 693

def fetch_saved_message_and_clear (eh):                                         #line 694

    return  eh.saved_messages.get ()                                            #line 695
                                                                                #line 696

                                                                                #line 697

def step_children (container,causingMessage):                                   #line 698

    container.state =  "idle"                                                   #line 699

    for child in list ( container.visit_ordering.queue):                        #line 700

        # child = container represents self, skip it                            #line 701

        if (not (is_self ( child, container))):                                 #line 702

            if (not ( child.inq.empty ())):                                     #line 703

                msg =  child.inq.get ()                                         #line 704

                [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)#line 705

                if  began_long_run:                                             #line 706

                    save_message ( child, msg)                                  #line 707

                elif  continued_long_run:                                       #line 708

                    pass                                                        #line 709

                elif  ended_long_run:                                           #line 710

                    log_inout (container= container,component= child,in_message=fetch_saved_message_and_clear ( child))#line 711

                else:                                                           #line 712

                    log_inout (container= container,component= child,in_message= msg)#line 713


                destroy_message ( msg)                                          #line 714

            else:                                                               #line 715

                if  child.state!= "idle":                                       #line 716

                    msg = force_tick ( container, child)                        #line 717

                    child.handler ( child, msg)                                 #line 718

                    log_tick (container= container,component= child,in_message= msg)#line 719

                    destroy_message ( msg)
                                                                                #line 720

                                                                                #line 721

            if  child.state ==  "active":                                       #line 722

                # if child remains active, then the container must remain active and must propagate “ticks“ to child#line 723

                container.state =  "active"                                     #line 724

                                                                                #line 725

            while (not ( child.outq.empty ())):                                 #line 726

                msg =  child.outq.get ()                                        #line 727

                route ( container, child, msg)                                  #line 728

                destroy_message ( msg)

                                                                                #line 729

                                                                                #line 730
                                                                                #line 731
                                                                                #line 732

                                                                                #line 733

def attempt_tick (parent,eh):                                                   #line 734

    if  eh.state!= "idle":                                                      #line 735

        force_tick ( parent, eh)                                                #line 736

                                                                                #line 737

                                                                                #line 738

def is_tick (msg):                                                              #line 739

    return  "tick" ==  msg.datum.kind ()                                        #line 740
                                                                                #line 741

                                                                                #line 742
# Routes a single message to all matching destinations, according to            #line 743
# the container's connection network.                                           #line 744
                                                                                #line 745

def route (container,from_component,message):                                   #line 746

    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)       #line 747

    fromname =  ""                                                              #line 748

    if is_tick ( message):                                                      #line 749

        for child in  container.children:                                       #line 750

            attempt_tick ( container, child, message)                           #line 751


        was_sent =  True                                                        #line 752

    else:                                                                       #line 753

        if (not (is_self ( from_component, container))):                        #line 754

            fromname =  from_component.name                                     #line 755


        from_sender = Sender (name= fromname,component= from_component,port= message.port)#line 756
                                                                                #line 757

        for connector in  container.connections:                                #line 758

            if sender_eq ( from_sender, connector.sender):                      #line 759

                deposit ( container, connector, message)                        #line 760

                was_sent =  True

                                                                                #line 761


    if not ( was_sent):                                                         #line 762

        print ( "\n\n*** Error: ***")                                           #line 763

        dump_possible_connections ( container)                                  #line 764

        print_routing_trace ( container)                                        #line 765

        print ( "***")                                                          #line 766

        print ( str( container.name) +  str( ": message '") +  str( message.port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )#line 767

        print ( "***")                                                          #line 768

        exit ()                                                                 #line 769

                                                                                #line 770

                                                                                #line 771

def dump_possible_connections (container):                                      #line 772

    print ( str( "*** possible connections for ") +  str( container.name) +  ":"  )#line 773

    for connector in  container.connections:                                    #line 774

        print ( str( connector.direction) +  str( " ") +  str( connector.sender.name) +  str( ".") +  str( connector.sender.port) +  str( " -> ") +  str( connector.receiver.name) +  str( ".") +  connector.receiver.port        )#line 775

                                                                                #line 776

                                                                                #line 777

def any_child_ready (container):                                                #line 778

    for child in  container.children:                                           #line 779

        if child_is_ready ( child):                                             #line 780

            return  True
                                                                                #line 781


    return  False                                                               #line 782
                                                                                #line 783

                                                                                #line 784

def child_is_ready (eh):                                                        #line 785

    return (not ( eh.outq.empty ())) or (not ( eh.inq.empty ())) or ( eh.state!= "idle") or (any_child_ready ( eh))#line 786
                                                                                #line 787

                                                                                #line 788

def print_routing_trace (eh):                                                   #line 789

    print (routing_trace_all ( eh))                                             #line 790
                                                                                #line 791

                                                                                #line 792

def append_routing_descriptor (container,desc):                                 #line 793

    container.routings.put ( desc)                                              #line 794
                                                                                #line 795

                                                                                #line 796

def log_connection (container,connector,message):                               #line 797

    if  "down" ==  connector.direction:                                         #line 798

        log_down (container= container,                                         #line 799
        source_port= connector.sender.port,                                     #line 800
        source_message= None,                                                   #line 801
        target= connector.receiver.component,                                   #line 802
        target_port= connector.receiver.port,                                   #line 803
        target_message= message)                                                #line 804

    elif  "up" ==  connector.direction:                                         #line 805

        log_up (source= connector.sender.component,source_port= connector.sender.port,source_message= None,container= container,target_port= connector.receiver.port,#line 806
        target_message= message)                                                #line 807

    elif  "across" ==  connector.direction:                                     #line 808

        log_across (container= container,                                       #line 809
        source= connector.sender.component,source_port= connector.sender.port,source_message= None,#line 810
        target= connector.receiver.component,target_port= connector.receiver.port,target_message= message)#line 811

    elif  "through" ==  connector.direction:                                    #line 812

        log_through (container= container,source_port= connector.sender.port,source_message= None,#line 813
        target_port= connector.receiver.port,message= message)                  #line 814

    else:                                                                       #line 815

        print ( str( "*** FATAL error: in log_connection /") +  str( connector.direction) +  str( "/ /") +  str( message.port) +  str( "/ /") +  str( message.datum.srepr ()) +  "/"      )#line 816

        exit ()                                                                 #line 817

                                                                                #line 818

                                                                                #line 819

def container_injector (container,message):                                     #line 820

    log_inject (receiver= container,port= message.port,msg= message)            #line 821

    container_handler ( container, message)                                     #line 822
                                                                                #line 823

                                                                                #line 824





