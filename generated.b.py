

import os                                                                       #line 1

import json                                                                     #line 2

import sys                                                                      #line 3
                                                                                #line 4
                                                                                #line 5

class Component_Registry:
    def __init__ (self):                                                        #line 6

        self.templates = {}                                                     #line 7
                                                                                #line 8

                                                                                #line 9

class Template:
    def __init__ (selfname,template_data,instantiator):                         #line 10

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

def register_component (reg,template,ok_to_overwrite= False):                   #line 34

    name = mangle_name ( template. name)                                        #line 35

    if  name in  reg. templates and not  ok_to_overwrite:                       #line 36

        load_error ( str( "Component ") +  str( template. name) +  " already declared"  )#line 37


    reg. templates [ name] =  template                                          #line 38

    return  reg                                                                 #line 39
                                                                                #line 40

                                                                                #line 41

def register_multiple_components (reg,templates):                               #line 42

    for template in  templates:                                                 #line 43

        register_component ( reg, template)                                     #line 44

                                                                                #line 45

                                                                                #line 46

def get_component_instance (reg,full_name,owner):                               #line 47

    template_name = mangle_name ( full_name)                                    #line 48

    if  template_name in  reg. templates:                                       #line 49

        template =  reg. templates [ template_name]                             #line 50

        if ( template ==  None):                                                #line 51

            load_error ( str( "Registry Error: Can;t find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )#line 52

            return  None                                                        #line 53

        else:                                                                   #line 54

            owner_name =  ""                                                    #line 55

            instance_name =  template_name                                      #line 56

            if  None!= owner:                                                   #line 57

                owner_name =  owner. name                                       #line 58

                instance_name =  str( owner_name) +  str( ".") +  template_name  #line 59

            else:                                                               #line 60

                instance_name =  template_name                                  #line 61


            instance =  template.instantiator ( reg, owner, instance_name, template. template_data)#line 62

            instance. depth = calculate_depth ( instance)                       #line 63

            return  instance
                                                                                #line 64

    else:                                                                       #line 65

        load_error ( str( "Registry Error: Can't find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )#line 66

        return  None                                                            #line 67

                                                                                #line 68


def calculate_depth (eh):                                                       #line 69

    if  eh. owner ==  None:                                                     #line 70

        return  0                                                               #line 71

    else:                                                                       #line 72

        return  1+calculate_depth ( eh. owner)                                  #line 73

                                                                                #line 74

                                                                                #line 75

def dump_registry (reg):                                                        #line 76

    print ()                                                                    #line 77

    print ( "*** PALETTE ***")                                                  #line 78

    for c in  reg. templates:                                                   #line 79

        print ( c. name)                                                        #line 80


    print ( "***************")                                                  #line 81

    print ()                                                                    #line 82
                                                                                #line 83

                                                                                #line 84

def print_stats (reg):                                                          #line 85

    print ( str( "registry statistics: ") +  reg. stats )                       #line 86
                                                                                #line 87

                                                                                #line 88

def mangle_name (s):                                                            #line 89

    # trim name to remove code from Container component names _ deferred until later (or never)#line 90

    return  s                                                                   #line 91
                                                                                #line 92

                                                                                #line 93

import subprocess                                                               #line 94

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

                    generated_leaf = Template (name= name,instantiator= shell_out_instantiate,template_data= cmd)#line 108

                    register_component ( reg, generated_leaf)                   #line 109

                elif first_char_is ( child_descriptor ["name"], "'"):           #line 110

                    name =  child_descriptor ["name"]                           #line 111

                    s =   name[1:]                                              #line 112

                    generated_leaf = Template (name= name,instantiator= string_constant_instantiate,template_data= s)#line 113

                    register_component ( reg, generated_leaf,ok_to_overwrite= True)


                                                                                #line 114

                                                                                #line 115

                                                                                #line 116

def first_char (s):                                                             #line 117

    return   s[0]                                                               #line 118
                                                                                #line 119

                                                                                #line 120

def first_char_is (s,c):                                                        #line 121

    return  c == first_char ( s)                                                #line 122
                                                                                #line 123

                                                                                #line 124
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 125
# I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped#line 126

def run_command (eh,cmd,s):                                                     #line 127

    ret =  subprocess.run ( cmd,capture_output= True,input= s,encoding= "UTF_8")#line 128

    if not ( ret. returncode ==  0):                                            #line 129

        if  ret. stderr!= None:                                                 #line 130

            return [ "", ret. stderr]                                           #line 131

        else:                                                                   #line 132

            return [ "", str( "error in shell_out ") +  ret. returncode ]
                                                                                #line 133

    else:                                                                       #line 134

        return [ ret. stdout, None]                                             #line 135

                                                                                #line 136

                                                                                #line 137
# Data for an asyncronous component _ effectively, a function with input        #line 138
# and output queues of messages.                                                #line 139
#                                                                               #line 140
# Components can either be a user_supplied function (“lea“), or a “container“   #line 141
# that routes messages to child components according to a list of connections   #line 142
# that serve as a message routing table.                                        #line 143
#                                                                               #line 144
# Child components themselves can be leaves or other containers.                #line 145
#                                                                               #line 146
# `handler` invokes the code that is attached to this component.                #line 147
#                                                                               #line 148
# `instance_data` is a pointer to instance data that the `leaf_handler`         #line 149
# function may want whenever it is invoked again.                               #line 150
#                                                                               #line 151
                                                                                #line 152

import queue                                                                    #line 153

import sys                                                                      #line 154
                                                                                #line 155
                                                                                #line 156
# Eh_States :: enum { idle, active }                                            #line 157

class Eh:
    def __init__ (self):                                                        #line 158

        self.name =  ""                                                         #line 159

        self.inq =  queue.Queue ()                                              #line 160

        self.outq =  queue.Queue ()                                             #line 161

        self.owner =  None                                                      #line 162

        self.saved_messages =  queue.LifoQueue () # stack of saved message(s)   #line 163

        self.inject =  injector_NIY                                             #line 164

        self.children = []                                                      #line 165

        self.visit_ordering =  queue.Queue ()                                   #line 166

        self.connections = []                                                   #line 167

        self.routings =  queue.Queue ()                                         #line 168

        self.handler =  None                                                    #line 169

        self.instance_data =  None                                              #line 170

        self.state =  "idle"                                                    #line 171
        # bootstrap debugging                                                   #line 172

        self.kind =  None # enum { container, leaf, }                           #line 173

        self.trace =  False # set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component)#line 174

        self.depth =  0 # hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc.#line 175
                                                                                #line 176

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

    return  eh                                                                  #line 188
                                                                                #line 189

                                                                                #line 190
# Creates a new leaf component out of a handler function, and a data parameter  #line 191
# that will be passed back to your handler when called.                         #line 192
                                                                                #line 193

def make_leaf (name,owner,instance_data,handler):                               #line 194

    eh = Eh ()                                                                  #line 195

    eh. name =  str( owner. name) +  str( ".") +  name                          #line 196

    eh. owner =  owner                                                          #line 197

    eh. handler =  handler                                                      #line 198

    eh. instance_data =  instance_data                                          #line 199

    eh. state =  "idle"                                                         #line 200

    eh. kind =  "leaf"                                                          #line 201

    return  eh                                                                  #line 202
                                                                                #line 203

                                                                                #line 204
# Sends a message on the given `port` with `data`, placing it on the output     #line 205
# of the given component.                                                       #line 206
                                                                                #line 207

def send (eh,port,datum,causingMessage):                                        #line 208

    msg = make_message ( port, datum)                                           #line 209

    log_send (sender= eh,sender_port= port,msg= msg,cause_msg= causingMessage)  #line 210

    put_output ( eh, msg)                                                       #line 211
                                                                                #line 212

                                                                                #line 213

def send_string (eh,port,s,causingMessage):                                     #line 214

    datum = new_datum_string ( s)                                               #line 215

    msg = make_message (port= port,datum= datum)                                #line 216

    log_send_string (sender= eh,sender_port= port,msg= msg,cause_msg= causingMessage)#line 217

    put_output ( eh, msg)                                                       #line 218
                                                                                #line 219

                                                                                #line 220

def forward (eh,port,msg):                                                      #line 221

    fwdmsg = make_message ( port, msg. datum)                                   #line 222

    log_forward (sender= eh,sender_port= port,msg= msg,cause_msg= msg)          #line 223

    put_output ( eh, msg)                                                       #line 224
                                                                                #line 225

                                                                                #line 226

def inject (eh,msg):                                                            #line 227

    eh.inject ( eh, msg)                                                        #line 228
                                                                                #line 229

                                                                                #line 230
# Returns a list of all output messages on a container.                         #line 231
# For testing / debugging purposes.                                             #line 232
                                                                                #line 233

def output_list (eh):                                                           #line 234

    return  eh. outq                                                            #line 235
                                                                                #line 236

                                                                                #line 237
# Utility for printing an array of messages.                                    #line 238

def print_output_list (eh):                                                     #line 239

    for m in list ( eh. outq. queue):                                           #line 240

        print (format_message ( m))                                             #line 241

                                                                                #line 242

                                                                                #line 243

def spaces (n):                                                                 #line 244

    s =  ""                                                                     #line 245

    for i in range( n):                                                         #line 246

        s =  s+ " "                                                             #line 247


    return  s                                                                   #line 248
                                                                                #line 249

                                                                                #line 250

def set_active (eh):                                                            #line 251

    eh. state =  "active"                                                       #line 252
                                                                                #line 253

                                                                                #line 254

def set_idle (eh):                                                              #line 255

    eh. state =  "idle"                                                         #line 256
                                                                                #line 257

                                                                                #line 258
# Utility for printing a specific output message.                               #line 259
                                                                                #line 260

def fetch_first_output (eh,port):                                               #line 261

    for msg in list ( eh. outq. queue):                                         #line 262

        if ( msg. port ==  port):                                               #line 263

            return  msg. datum
                                                                                #line 264


    return  None                                                                #line 265
                                                                                #line 266

                                                                                #line 267

def print_specific_output (eh,port= "",stderr= False):                          #line 268

    datum = fetch_first_output ( eh, port)                                      #line 269

    outf =  None                                                                #line 270

    if  datum!= None:                                                           #line 271

        if  stderr:
            # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 272

            outf =  sys. stderr                                                 #line 273

        else:                                                                   #line 274

            outf =  sys. stdout                                                 #line 275


        print ( datum.srepr (),file= outf)                                      #line 276

                                                                                #line 277

                                                                                #line 278

def put_output (eh,msg):                                                        #line 279

    eh. outq.put ( msg)                                                         #line 280
                                                                                #line 281

                                                                                #line 282

def injector_NIY (eh,msg):                                                      #line 283

    # print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“')#line 284

    print ( str( "Injector not implemented for this component ") +  str( eh. name) +  str( " kind ∷ ") +  str( eh. kind) +  str( ",  port ∷ ") +  msg. port     )#line 289

    exit ()                                                                     #line 290
                                                                                #line 291

                                                                                #line 292

import sys                                                                      #line 293

import re                                                                       #line 294

import subprocess                                                               #line 295

import shlex                                                                    #line 296
                                                                                #line 297

root_project =  ""                                                              #line 298

root_0D =  ""                                                                   #line 299
                                                                                #line 300

def set_environment (rproject,r0D):                                             #line 301

    global root_project                                                         #line 302

    global root_0D                                                              #line 303

    root_project =  rproject                                                    #line 304

    root_0D =  r0D                                                              #line 305
                                                                                #line 306

                                                                                #line 307

def probe_instantiate (reg,owner,name,template_data):                           #line 308

    name_with_id = gensymbol ( "?")                                             #line 309

    return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= probe_handler)#line 310
                                                                                #line 311


def probeA_instantiate (reg,owner,name,template_data):                          #line 312

    name_with_id = gensymbol ( "?A")                                            #line 313

    return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= probe_handler)#line 314
                                                                                #line 315

                                                                                #line 316

def probeB_instantiate (reg,owner,name,template_data):                          #line 317

    name_with_id = gensymbol ( "?B")                                            #line 318

    return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= probe_handler)#line 319
                                                                                #line 320

                                                                                #line 321

def probeC_instantiate (reg,owner,name,template_data):                          #line 322

    name_with_id = gensymbol ( "?C")                                            #line 323

    return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= probe_handler)#line 324
                                                                                #line 325

                                                                                #line 326

def probe_handler (eh,msg):                                                     #line 327

    s =  msg. datum.srepr ()                                                    #line 328

    print ( str( "... probe ") +  str( eh. name) +  str( ": ") +  s   ,file= sys. stderr)#line 329
                                                                                #line 330

                                                                                #line 331

def trash_instantiate (reg,owner,name,template_data):                           #line 332

    name_with_id = gensymbol ( "trash")                                         #line 333

    return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= trash_handler)#line 334
                                                                                #line 335

                                                                                #line 336

def trash_handler (eh,msg):                                                     #line 337

    # to appease dumped_on_floor checker                                        #line 338

    pass                                                                        #line 339
                                                                                #line 340


class TwoMessages:
    def __init__ (selffirst,second):                                            #line 341

        self.first =  first                                                     #line 342

        self.second =  second                                                   #line 343
                                                                                #line 344

                                                                                #line 345
# Deracer_States :: enum { idle, waitingForFirst, waitingForSecond }            #line 346

class Deracer_Instance_Data:
    def __init__ (selfstate,buffer):                                            #line 347

        self.state =  state                                                     #line 348

        self.buffer =  buffer                                                   #line 349
                                                                                #line 350

                                                                                #line 351

def reclaim_Buffers_from_heap (inst):                                           #line 352

    pass                                                                        #line 353
                                                                                #line 354

                                                                                #line 355

def deracer_instantiate (reg,owner,name,template_data):                         #line 356

    name_with_id = gensymbol ( "deracer")                                       #line 357

    inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))            #line 358

    inst. state =  "idle"                                                       #line 359

    eh = make_leaf (name= name_with_id,owner= owner,instance_data= inst,handler= deracer_handler)#line 360

    return  eh                                                                  #line 361
                                                                                #line 362

                                                                                #line 363

def send_first_then_second (eh,inst):                                           #line 364

    forward ( eh, "1", inst. buffer. first)                                     #line 365

    forward ( eh, "2", inst. buffer. second)                                    #line 366

    reclaim_Buffers_from_heap ( inst)                                           #line 367
                                                                                #line 368

                                                                                #line 369

def deracer_handler (eh,msg):                                                   #line 370

    inst =  eh. instance_data                                                   #line 371

    if  inst. state ==  "idle":                                                 #line 372

        if  "1" ==  msg. port:                                                  #line 373

            inst. buffer. first =  msg                                          #line 374

            inst. state =  "waitingForSecond"                                   #line 375

        elif  "2" ==  msg. port:                                                #line 376

            inst. buffer. second =  msg                                         #line 377

            inst. state =  "waitingForFirst"                                    #line 378

        else:                                                                   #line 379

            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg. port )
                                                                                #line 380

    elif  inst. state ==  "waitingForFirst":                                    #line 381

        if  "1" ==  msg. port:                                                  #line 382

            inst. buffer. first =  msg                                          #line 383

            send_first_then_second ( eh, inst)                                  #line 384

            inst. state =  "idle"                                               #line 385

        else:                                                                   #line 386

            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg. port )
                                                                                #line 387

    elif  inst. state ==  "waitingForSecond":                                   #line 388

        if  "2" ==  msg. port:                                                  #line 389

            inst. buffer. second =  msg                                         #line 390

            send_first_then_second ( eh, inst)                                  #line 391

            inst. state =  "idle"                                               #line 392

        else:                                                                   #line 393

            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg. port )
                                                                                #line 394

    else:                                                                       #line 395

        runtime_error ( "bad state for deracer {eh.state}")                     #line 396

                                                                                #line 397

                                                                                #line 398

def low_level_read_text_file_instantiate (reg,owner,name,template_data):        #line 399

    name_with_id = gensymbol ( "Low Level Read Text File")                      #line 400

    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 401
                                                                                #line 402

                                                                                #line 403

def low_level_read_text_file_handler (eh,msg):                                  #line 404

    fname =  msg. datum.srepr ()                                                #line 405

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
                                                                                #line 406
                                                                                #line 407

                                                                                #line 408

def ensure_string_datum_instantiate (reg,owner,name,template_data):             #line 409

    name_with_id = gensymbol ( "Ensure String Datum")                           #line 410

    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)  #line 411
                                                                                #line 412

                                                                                #line 413

def ensure_string_datum_handler (eh,msg):                                       #line 414

    if  "string" ==  msg. datum.kind ():                                        #line 415

        forward ( eh, "", msg)                                                  #line 416

    else:                                                                       #line 417

        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg. datum #line 418

        send_string ( eh, "✗", emsg, msg)                                       #line 419

                                                                                #line 420

                                                                                #line 421

class Syncfilewrite_Data:
    def __init__ (self):                                                        #line 422

        self.filename =  ""                                                     #line 423
                                                                                #line 424

                                                                                #line 425
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)   #line 426

def syncfilewrite_instantiate (reg,owner,name,template_data):                   #line 427

    name_with_id = gensymbol ( "syncfilewrite")                                 #line 428

    inst = Syncfilewrite_Data ()                                                #line 429

    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)        #line 430
                                                                                #line 431

                                                                                #line 432

def syncfilewrite_handler (eh,msg):                                             #line 433

    inst =  eh. instance_data                                                   #line 434

    if  "filename" ==  msg. port:                                               #line 435

        inst. filename =  msg. datum.srepr ()                                   #line 436

    elif  "input" ==  msg. port:                                                #line 437

        contents =  msg. datum.srepr ()                                         #line 438

        f = open ( inst. filename, "w")                                         #line 439

        if  f!= None:                                                           #line 440

            f.write ( msg. datum.srepr ())                                      #line 441

            f.close ()                                                          #line 442

            send ( eh, "done",new_datum_bang (), msg)                           #line 443

        else:                                                                   #line 444

            send_string ( eh, "✗", str( "open error on file ") +  inst. filename , msg)
                                                                                #line 445

                                                                                #line 446

                                                                                #line 447

class StringConcat_Instance_Data:
    def __init__ (self):                                                        #line 448

        self.buffer1 =  None                                                    #line 449

        self.buffer2 =  None                                                    #line 450

        self.count =  0                                                         #line 451
                                                                                #line 452

                                                                                #line 453

def stringconcat_instantiate (reg,owner,name,template_data):                    #line 454

    name_with_id = gensymbol ( "stringconcat")                                  #line 455

    instp = StringConcat_Instance_Data ()                                       #line 456

    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)        #line 457
                                                                                #line 458

                                                                                #line 459

def stringconcat_handler (eh,msg):                                              #line 460

    inst =  eh. instance_data                                                   #line 461

    if  "1" ==  msg. port:                                                      #line 462

        inst. buffer1 = clone_string ( msg. datum.srepr ())                     #line 463

        inst. count =  inst. count+ 1                                           #line 464

        maybe_stringconcat ( eh, inst, msg)                                     #line 465

    elif  "2" ==  msg. port:                                                    #line 466

        inst. buffer2 = clone_string ( msg. datum.srepr ())                     #line 467

        inst. count =  inst. count+ 1                                           #line 468

        maybe_stringconcat ( eh, inst, msg)                                     #line 469

    else:                                                                       #line 470

        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg. port )  #line 471
                                                                                #line 472

                                                                                #line 473

                                                                                #line 474

def maybe_stringconcat (eh,inst,msg):                                           #line 475

    if ( 0 == len ( inst. buffer1)) and ( 0 == len ( inst. buffer2)):           #line 476

        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 477


    if  inst. count >=  2:                                                      #line 478

        concatenated_string =  ""                                               #line 479

        if  0 == len ( inst. buffer1):                                          #line 480

            concatenated_string =  inst. buffer2                                #line 481

        elif  0 == len ( inst. buffer2):                                        #line 482

            concatenated_string =  inst. buffer1                                #line 483

        else:                                                                   #line 484

            concatenated_string =  inst. buffer1+ inst. buffer2                 #line 485


        send_string ( eh, "", concatenated_string, msg)                         #line 486

        inst. buffer1 =  None                                                   #line 487

        inst. buffer2 =  None                                                   #line 488

        inst. count =  0                                                        #line 489

                                                                                #line 490

                                                                                #line 491
#                                                                               #line 492
                                                                                #line 493
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 494

def shell_out_instantiate (reg,owner,name,template_data):                       #line 495

    name_with_id = gensymbol ( "shell_out")                                     #line 496

    cmd =  shlex.split ( template_data)                                         #line 497

    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)             #line 498
                                                                                #line 499

                                                                                #line 500

def shell_out_handler (eh,msg):                                                 #line 501

    cmd =  eh. instance_data                                                    #line 502

    s =  msg. datum.srepr ()                                                    #line 503

    [ stdout, stderr] = run_command ( eh, cmd, s)                               #line 504

    if  stderr!= None:                                                          #line 505

        send_string ( eh, "✗", stderr, msg)                                     #line 506

    else:                                                                       #line 507

        send_string ( eh, "", stdout, msg)                                      #line 508

                                                                                #line 509

                                                                                #line 510

def string_constant_instantiate (reg,owner,name,template_data):                 #line 511

    global root_project                                                         #line 512

    global root_0D                                                              #line 513

    name_with_id = gensymbol ( "strconst")                                      #line 514

    s =  template_data                                                          #line 515

    if  root_project!= "":                                                      #line 516

        s =  re.sub ( "_00_", root_project, s)                                  #line 517


    if  root_0D!= "":                                                           #line 518

        s =  re.sub ( "_0D_", root_0D, s)                                       #line 519


    return make_leaf ( name_with_id, owner, s, string_constant_handler)         #line 520
                                                                                #line 521

                                                                                #line 522

def string_constant_handler (eh,msg):                                           #line 523

    s =  eh. instance_data                                                      #line 524

    send_string ( eh, "", s, msg)                                               #line 525
                                                                                #line 526

                                                                                #line 527

def string_make_persistent (s):                                                 #line 528

    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 529

    return  s                                                                   #line 530
                                                                                #line 531

                                                                                #line 532

def string_clone (s):                                                           #line 533

    return  s                                                                   #line 534
                                                                                #line 535

                                                                                #line 536

import sys                                                                      #line 537
                                                                                #line 538
# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...   #line 539
# where ${_00_} is the root directory for the project                           #line 540
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)        #line 541
                                                                                #line 542
                                                                                #line 543
                                                                                #line 544

def initialize_component_palette (root_project,root_0D,diagram_source_files):   #line 545

    reg = make_component_registry ()                                            #line 546

    for diagram_source in  diagram_source_files:                                #line 547

        all_containers_within_single_file = json2internal ( diagram_source)     #line 548

        generate_shell_components ( reg, all_containers_within_single_file)     #line 549

        for container in  all_containers_within_single_file:                    #line 550

            register_component ( reg,Template (name= container ["name"],template_data= container,instantiator= container_instantiator))
                                                                                #line 551


    initialize_stock_components ( reg)                                          #line 552

    return  reg                                                                 #line 553
                                                                                #line 554

                                                                                #line 555

def print_error_maybe (main_container):                                         #line 556

    error_port =  "✗"                                                           #line 557

    err = fetch_first_output ( main_container, error_port)                      #line 558

    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):                   #line 559

        print ( "___ !!! ERRORS !!! ___")                                       #line 560

        print_specific_output ( main_container, error_port, False)              #line 561

                                                                                #line 562

                                                                                #line 563
# debugging helpers                                                             #line 564
                                                                                #line 565

def dump_outputs (main_container):                                              #line 566

    print ()                                                                    #line 567

    print ( "___ Outputs ___")                                                  #line 568

    print_output_list ( main_container)                                         #line 569
                                                                                #line 570

                                                                                #line 571

def trace_outputs (main_container):                                             #line 572

    print ()                                                                    #line 573

    print ( "___ Message Traces ___")                                           #line 574

    print_routing_trace ( main_container)                                       #line 575
                                                                                #line 576

                                                                                #line 577

def dump_hierarchy (main_container):                                            #line 578

    print ()                                                                    #line 579

    print ( str( "___ Hierarchy ___") + (build_hierarchy ( main_container)) )   #line 580
                                                                                #line 581

                                                                                #line 582

def build_hierarchy (c):                                                        #line 583

    s =  ""                                                                     #line 584

    for child in  c. children:                                                  #line 585

        s =  str( s) + build_hierarchy ( child)                                 #line 586


    indent =  ""                                                                #line 587

    for i in range( c. depth):                                                  #line 588

        indent =  indent+ "  "                                                  #line 589


    return  str( "\n") +  str( indent) +  str( "(") +  str( c. name) +  str( s) +  ")"     #line 590
                                                                                #line 591

                                                                                #line 592

def dump_connections (c):                                                       #line 593

    print ()                                                                    #line 594

    print ( "___ connections ___")                                              #line 595

    dump_possible_connections ( c)                                              #line 596

    for child in  c. children:                                                  #line 597

        print ()                                                                #line 598

        dump_possible_connections ( child)                                      #line 599

                                                                                #line 600

                                                                                #line 601

def trimws (s):                                                                 #line 602

    # remove whitespace from front and back of string                           #line 603

    return  s.strip ()                                                          #line 604
                                                                                #line 605

                                                                                #line 606

def clone_string (s):                                                           #line 607

    return  s                                                                   #line 608
                                                                                #line 609
                                                                                #line 610


load_errors =  False                                                            #line 611

runtime_errors =  False                                                         #line 612
                                                                                #line 613

def load_error (s):                                                             #line 614

    global load_errors                                                          #line 615

    print ( s)                                                                  #line 616

    quit ()                                                                     #line 617

    load_errors =  True                                                         #line 618
                                                                                #line 619

                                                                                #line 620

def runtime_error (s):                                                          #line 621

    global runtime_errors                                                       #line 622

    print ( s)                                                                  #line 623

    quit ()                                                                     #line 624

    runtime_errors =  True                                                      #line 625
                                                                                #line 626

                                                                                #line 627

def fakepipename_instantiate (reg,owner,name,template_data):                    #line 628

    instance_name = gensymbol ( "fakepipe")                                     #line 629

    return make_leaf ( instance_name, owner, None, fakepipename_handler)        #line 630
                                                                                #line 631

                                                                                #line 632

rand =  0                                                                       #line 633
                                                                                #line 634

def fakepipename_handler (eh,msg):                                              #line 635

    global rand                                                                 #line 636

    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 637

    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)                  #line 638
                                                                                #line 639

                                                                                #line 640
                                                                                #line 641
# all of the the built_in leaves are listed here                                #line 642
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 643
                                                                                #line 644
                                                                                #line 645

def initialize_stock_components (reg):                                          #line 646

    register_component ( reg,Template ( "1then2", None, deracer_instantiate))   #line 647

    register_component ( reg,Template ( "?", None, probe_instantiate))          #line 648

    register_component ( reg,Template ( "?A", None, probeA_instantiate))        #line 649

    register_component ( reg,Template ( "?B", None, probeB_instantiate))        #line 650

    register_component ( reg,Template ( "?C", None, probeC_instantiate))        #line 651

    register_component ( reg,Template ( "trash", None, trash_instantiate))      #line 652
                                                                                #line 653

    register_component ( reg,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 654

    register_component ( reg,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 655
                                                                                #line 656

    register_component ( reg,Template ( "syncfilewrite", None, syncfilewrite_instantiate))#line 657

    register_component ( reg,Template ( "stringconcat", None, stringconcat_instantiate))#line 658

    # for fakepipe                                                              #line 659

    register_component ( reg,Template ( "fakepipename", None, fakepipename_instantiate))#line 660
                                                                                #line 661

                                                                                #line 662
                                                                                #line 663

def initialize ():                                                              #line 664

    root_of_project =  sys.argv[ 1]                                             #line 665

    root_of_0D =  sys.argv[ 2]                                                  #line 666

    arg =  sys.argv[ 3]                                                         #line 667

    main_container_name =  sys.argv[ 4]                                         #line 668

    diagram_names =  sys.argv[ 5:]                                              #line 669

    palette = initialize_component_palette ( root_project, root_0D, diagram_names)#line 670

    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 671
                                                                                #line 672

                                                                                #line 673

def start (palette,env,show_hierarchy= False,show_connections= False,show_traces= False,show_all_outputs= False):#line 674

    root_of_project =  env [ 0]                                                 #line 675

    root_of_0D =  env [ 1]                                                      #line 676

    main_container_name =  env [ 2]                                             #line 677

    diagram_names =  env [ 3]                                                   #line 678

    arg =  env [ 4]                                                             #line 679

    set_environment ( root_of_project, root_of_0D)                              #line 680

    # get entrypoint container                                                  #line 681

    main_container = get_component_instance ( palette, main_container_name,owner= None)#line 682

    if  None ==  main_container:                                                #line 683

        load_error ( str( "Couldn't find container with page name ") +  str( main_container_name) +  str( " in files ") +  str( diagram_source_files) +  "(check tab names, or disable compression?)"    )#line 687
                                                                                #line 688


    if  show_hierarchy:                                                         #line 689

        dump_hierarchy ( main_container)                                        #line 690
                                                                                #line 691


    if  show_connections:                                                       #line 692

        dump_connections ( main_container)                                      #line 693
                                                                                #line 694


    if not  load_errors:                                                        #line 695

        arg = new_datum_string ( arg)                                           #line 696

        msg = make_message ( "", arg)                                           #line 697

        inject ( main_container, msg)                                           #line 698

        if  show_all_outputs:                                                   #line 699

            dump_outputs ( main_container)                                      #line 700

        else:                                                                   #line 701

            print_error_maybe ( main_container)                                 #line 702

            print_specific_output ( main_container,port= "",stderr= False)      #line 703

            if  show_traces:                                                    #line 704

                print ( "--- routing traces ---")                               #line 705

                print (routing_trace_all ( main_container))                     #line 706
                                                                                #line 707

                                                                                #line 708


        if  show_all_outputs:                                                   #line 709

            print ( "--- done ---")                                             #line 710
                                                                                #line 711

                                                                                #line 712

                                                                                #line 713

                                                                                #line 714
                                                                                #line 715
                                                                                #line 716
# utility functions                                                             #line 717

def send_int (eh,port,i,causing_message):                                       #line 718

    datum = new_datum_int ( i)                                                  #line 719

    send ( eh, port, datum, causing_message)                                    #line 720
                                                                                #line 721

                                                                                #line 722

def send_bang (eh,port,causing_message):                                        #line 723

    datum = new_datum_bang ()                                                   #line 724

    send ( eh, port, datum, causing_message)                                    #line 725
                                                                                #line 726

                                                                                #line 727





