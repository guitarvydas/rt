

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

    nl ()                                                                       #line 80

    print ( "*** PALETTE ***")                                                  #line 81

    for c in  reg. templates:                                                   #line 82

        print ( c. name)                                                        #line 83


    print ( "***************")                                                  #line 84

    nl ()                                                                       #line 85
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

    put_output ( eh, msg)                                                       #line 218
                                                                                #line 219

                                                                                #line 220

def send_string (eh,port,s,causingMessage):                                     #line 221

    datum = new_datum_string ( s)                                               #line 222

    msg = make_message ( port, datum)                                           #line 223

    put_output ( eh, msg)                                                       #line 224
                                                                                #line 225

                                                                                #line 226

def forward (eh,port,msg):                                                      #line 227

    fwdmsg = make_message ( port, msg. datum)                                   #line 228

    put_output ( eh, msg)                                                       #line 229
                                                                                #line 230

                                                                                #line 231

def inject (eh,msg):                                                            #line 232

    eh.inject ( eh, msg)                                                        #line 233
                                                                                #line 234

                                                                                #line 235
# Returns a list of all output messages on a container.                         #line 236
# For testing / debugging purposes.                                             #line 237
                                                                                #line 238

def output_list (eh):                                                           #line 239

    return  eh. outq                                                            #line 240
                                                                                #line 241

                                                                                #line 242
# Utility for printing an array of messages.                                    #line 243

def print_output_list (eh):                                                     #line 244

    for m in list ( eh. outq. queue):                                           #line 245

        print (format_message ( m))                                             #line 246

                                                                                #line 247

                                                                                #line 248

def spaces (n):                                                                 #line 249

    s =  ""                                                                     #line 250

    for i in range( n):                                                         #line 251

        s =  s+ " "                                                             #line 252


    return  s                                                                   #line 253
                                                                                #line 254

                                                                                #line 255

def set_active (eh):                                                            #line 256

    eh. state =  "active"                                                       #line 257
                                                                                #line 258

                                                                                #line 259

def set_idle (eh):                                                              #line 260

    eh. state =  "idle"                                                         #line 261
                                                                                #line 262

                                                                                #line 263
# Utility for printing a specific output message.                               #line 264
                                                                                #line 265

def fetch_first_output (eh,port):                                               #line 266

    for msg in list ( eh. outq. queue):                                         #line 267

        if ( msg. port ==  port):                                               #line 268

            return  msg. datum
                                                                                #line 269


    return  None                                                                #line 270
                                                                                #line 271

                                                                                #line 272

def print_specific_output (eh,port):                                            #line 273

    # port ∷ “”                                                                 #line 274

    datum = fetch_first_output ( eh, port)                                      #line 275

    outf =  None                                                                #line 276

    if  datum!= None:                                                           #line 277

        outf =  sys. stdout                                                     #line 278

        print ( datum.srepr (), outf)                                           #line 279

                                                                                #line 280


def print_specific_output_to_stderr (eh,port):                                  #line 281

    # port ∷ “”                                                                 #line 282

    datum = fetch_first_output ( eh, port)                                      #line 283

    outf =  None                                                                #line 284

    if  datum!= None:                                                           #line 285

        # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 286

        outf =  sys. stderr                                                     #line 287

        print ( datum.srepr (), outf)                                           #line 288

                                                                                #line 289

                                                                                #line 290

def put_output (eh,msg):                                                        #line 291

    eh. outq.put ( msg)                                                         #line 292
                                                                                #line 293

                                                                                #line 294

def injector_NIY (eh,msg):                                                      #line 295

    # print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“')#line 296

    print ( str( "Injector not implemented for this component ") +  str( eh. name) +  str( " kind ∷ ") +  str( eh. kind) +  str( ",  port ∷ ") +  msg. port     )#line 301

    exit ()                                                                     #line 302
                                                                                #line 303

                                                                                #line 304

import sys                                                                      #line 305

import re                                                                       #line 306

import subprocess                                                               #line 307

import shlex                                                                    #line 308
                                                                                #line 309

root_project =  ""                                                              #line 310

root_0D =  ""                                                                   #line 311
                                                                                #line 312

def set_environment (rproject,r0D):                                             #line 313

    global root_project                                                         #line 314

    global root_0D                                                              #line 315

    root_project =  rproject                                                    #line 316

    root_0D =  r0D                                                              #line 317
                                                                                #line 318

                                                                                #line 319

def probe_instantiate (reg,owner,name,template_data):                           #line 320

    name_with_id = gensymbol ( "?")                                             #line 321

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 322
                                                                                #line 323


def probeA_instantiate (reg,owner,name,template_data):                          #line 324

    name_with_id = gensymbol ( "?A")                                            #line 325

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 326
                                                                                #line 327

                                                                                #line 328

def probeB_instantiate (reg,owner,name,template_data):                          #line 329

    name_with_id = gensymbol ( "?B")                                            #line 330

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 331
                                                                                #line 332

                                                                                #line 333

def probeC_instantiate (reg,owner,name,template_data):                          #line 334

    name_with_id = gensymbol ( "?C")                                            #line 335

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 336
                                                                                #line 337

                                                                                #line 338

def probe_handler (eh,msg):                                                     #line 339

    s =  msg. datum.srepr ()                                                    #line 340

    print ( str( "... probe ") +  str( eh. name) +  str( ": ") +  s   , sys. stderr)#line 341
                                                                                #line 342

                                                                                #line 343

def trash_instantiate (reg,owner,name,template_data):                           #line 344

    name_with_id = gensymbol ( "trash")                                         #line 345

    return make_leaf ( name_with_id, owner, None, trash_handler)                #line 346
                                                                                #line 347

                                                                                #line 348

def trash_handler (eh,msg):                                                     #line 349

    # to appease dumped_on_floor checker                                        #line 350

    pass                                                                        #line 351
                                                                                #line 352


class TwoMessages:
    def __init__ (self,first,second):                                           #line 353

        self.first =  first                                                     #line 354

        self.second =  second                                                   #line 355
                                                                                #line 356

                                                                                #line 357
# Deracer_States :: enum { idle, waitingForFirst, waitingForSecond }            #line 358

class Deracer_Instance_Data:
    def __init__ (self,state,buffer):                                           #line 359

        self.state =  state                                                     #line 360

        self.buffer =  buffer                                                   #line 361
                                                                                #line 362

                                                                                #line 363

def reclaim_Buffers_from_heap (inst):                                           #line 364

    pass                                                                        #line 365
                                                                                #line 366

                                                                                #line 367

def deracer_instantiate (reg,owner,name,template_data):                         #line 368

    name_with_id = gensymbol ( "deracer")                                       #line 369

    inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))            #line 370

    inst. state =  "idle"                                                       #line 371

    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)                #line 372

    return  eh                                                                  #line 373
                                                                                #line 374

                                                                                #line 375

def send_first_then_second (eh,inst):                                           #line 376

    forward ( eh, "1", inst. buffer. first)                                     #line 377

    forward ( eh, "2", inst. buffer. second)                                    #line 378

    reclaim_Buffers_from_heap ( inst)                                           #line 379
                                                                                #line 380

                                                                                #line 381

def deracer_handler (eh,msg):                                                   #line 382

    inst =  eh. instance_data                                                   #line 383

    if  inst. state ==  "idle":                                                 #line 384

        if  "1" ==  msg. port:                                                  #line 385

            inst. buffer. first =  msg                                          #line 386

            inst. state =  "waitingForSecond"                                   #line 387

        elif  "2" ==  msg. port:                                                #line 388

            inst. buffer. second =  msg                                         #line 389

            inst. state =  "waitingForFirst"                                    #line 390

        else:                                                                   #line 391

            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg. port )
                                                                                #line 392

    elif  inst. state ==  "waitingForFirst":                                    #line 393

        if  "1" ==  msg. port:                                                  #line 394

            inst. buffer. first =  msg                                          #line 395

            send_first_then_second ( eh, inst)                                  #line 396

            inst. state =  "idle"                                               #line 397

        else:                                                                   #line 398

            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg. port )
                                                                                #line 399

    elif  inst. state ==  "waitingForSecond":                                   #line 400

        if  "2" ==  msg. port:                                                  #line 401

            inst. buffer. second =  msg                                         #line 402

            send_first_then_second ( eh, inst)                                  #line 403

            inst. state =  "idle"                                               #line 404

        else:                                                                   #line 405

            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg. port )
                                                                                #line 406

    else:                                                                       #line 407

        runtime_error ( "bad state for deracer {eh.state}")                     #line 408

                                                                                #line 409

                                                                                #line 410

def low_level_read_text_file_instantiate (reg,owner,name,template_data):        #line 411

    name_with_id = gensymbol ( "Low Level Read Text File")                      #line 412

    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 413
                                                                                #line 414

                                                                                #line 415

def low_level_read_text_file_handler (eh,msg):                                  #line 416

    fname =  msg. datum.srepr ()                                                #line 417

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
                                                                                #line 418
                                                                                #line 419

                                                                                #line 420

def ensure_string_datum_instantiate (reg,owner,name,template_data):             #line 421

    name_with_id = gensymbol ( "Ensure String Datum")                           #line 422

    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)  #line 423
                                                                                #line 424

                                                                                #line 425

def ensure_string_datum_handler (eh,msg):                                       #line 426

    if  "string" ==  msg. datum.kind ():                                        #line 427

        forward ( eh, "", msg)                                                  #line 428

    else:                                                                       #line 429

        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg. datum #line 430

        send_string ( eh, "✗", emsg, msg)                                       #line 431

                                                                                #line 432

                                                                                #line 433

class Syncfilewrite_Data:
    def __init__ (self,):                                                       #line 434

        self.filename =  ""                                                     #line 435
                                                                                #line 436

                                                                                #line 437
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)   #line 438

def syncfilewrite_instantiate (reg,owner,name,template_data):                   #line 439

    name_with_id = gensymbol ( "syncfilewrite")                                 #line 440

    inst = Syncfilewrite_Data ()                                                #line 441

    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)        #line 442
                                                                                #line 443

                                                                                #line 444

def syncfilewrite_handler (eh,msg):                                             #line 445

    inst =  eh. instance_data                                                   #line 446

    if  "filename" ==  msg. port:                                               #line 447

        inst. filename =  msg. datum.srepr ()                                   #line 448

    elif  "input" ==  msg. port:                                                #line 449

        contents =  msg. datum.srepr ()                                         #line 450

        f = open ( inst. filename, "w")                                         #line 451

        if  f!= None:                                                           #line 452

            f.write ( msg. datum.srepr ())                                      #line 453

            f.close ()                                                          #line 454

            send ( eh, "done",new_datum_bang (), msg)                           #line 455

        else:                                                                   #line 456

            send_string ( eh, "✗", str( "open error on file ") +  inst. filename , msg)
                                                                                #line 457

                                                                                #line 458

                                                                                #line 459

class StringConcat_Instance_Data:
    def __init__ (self,):                                                       #line 460

        self.buffer1 =  None                                                    #line 461

        self.buffer2 =  None                                                    #line 462

        self.count =  0                                                         #line 463
                                                                                #line 464

                                                                                #line 465

def stringconcat_instantiate (reg,owner,name,template_data):                    #line 466

    name_with_id = gensymbol ( "stringconcat")                                  #line 467

    instp = StringConcat_Instance_Data ()                                       #line 468

    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)        #line 469
                                                                                #line 470

                                                                                #line 471

def stringconcat_handler (eh,msg):                                              #line 472

    inst =  eh. instance_data                                                   #line 473

    if  "1" ==  msg. port:                                                      #line 474

        inst. buffer1 = clone_string ( msg. datum.srepr ())                     #line 475

        inst. count =  inst. count+ 1                                           #line 476

        maybe_stringconcat ( eh, inst, msg)                                     #line 477

    elif  "2" ==  msg. port:                                                    #line 478

        inst. buffer2 = clone_string ( msg. datum.srepr ())                     #line 479

        inst. count =  inst. count+ 1                                           #line 480

        maybe_stringconcat ( eh, inst, msg)                                     #line 481

    else:                                                                       #line 482

        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg. port )  #line 483
                                                                                #line 484

                                                                                #line 485

                                                                                #line 486

def maybe_stringconcat (eh,inst,msg):                                           #line 487

    if ( 0 == len ( inst. buffer1)) and ( 0 == len ( inst. buffer2)):           #line 488

        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 489


    if  inst. count >=  2:                                                      #line 490

        concatenated_string =  ""                                               #line 491

        if  0 == len ( inst. buffer1):                                          #line 492

            concatenated_string =  inst. buffer2                                #line 493

        elif  0 == len ( inst. buffer2):                                        #line 494

            concatenated_string =  inst. buffer1                                #line 495

        else:                                                                   #line 496

            concatenated_string =  inst. buffer1+ inst. buffer2                 #line 497


        send_string ( eh, "", concatenated_string, msg)                         #line 498

        inst. buffer1 =  None                                                   #line 499

        inst. buffer2 =  None                                                   #line 500

        inst. count =  0                                                        #line 501

                                                                                #line 502

                                                                                #line 503
#                                                                               #line 504
                                                                                #line 505
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 506

def shell_out_instantiate (reg,owner,name,template_data):                       #line 507

    name_with_id = gensymbol ( "shell_out")                                     #line 508

    cmd =  shlex.split ( template_data)                                         #line 509

    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)             #line 510
                                                                                #line 511

                                                                                #line 512

def shell_out_handler (eh,msg):                                                 #line 513

    cmd =  eh. instance_data                                                    #line 514

    s =  msg. datum.srepr ()                                                    #line 515

    [ stdout, stderr] = run_command ( eh, cmd, s)                               #line 516

    if  stderr!= None:                                                          #line 517

        send_string ( eh, "✗", stderr, msg)                                     #line 518

    else:                                                                       #line 519

        send_string ( eh, "", stdout, msg)                                      #line 520

                                                                                #line 521

                                                                                #line 522

def string_constant_instantiate (reg,owner,name,template_data):                 #line 523

    global root_project                                                         #line 524

    global root_0D                                                              #line 525

    name_with_id = gensymbol ( "strconst")                                      #line 526

    s =  template_data                                                          #line 527

    if  root_project!= "":                                                      #line 528

        s =  re.sub ( "_00_", root_project, s)                                  #line 529


    if  root_0D!= "":                                                           #line 530

        s =  re.sub ( "_0D_", root_0D, s)                                       #line 531


    return make_leaf ( name_with_id, owner, s, string_constant_handler)         #line 532
                                                                                #line 533

                                                                                #line 534

def string_constant_handler (eh,msg):                                           #line 535

    s =  eh. instance_data                                                      #line 536

    send_string ( eh, "", s, msg)                                               #line 537
                                                                                #line 538

                                                                                #line 539

def string_make_persistent (s):                                                 #line 540

    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 541

    return  s                                                                   #line 542
                                                                                #line 543

                                                                                #line 544

def string_clone (s):                                                           #line 545

    return  s                                                                   #line 546
                                                                                #line 547

                                                                                #line 548

import sys                                                                      #line 549
                                                                                #line 550
# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...   #line 551
# where ${_00_} is the root directory for the project                           #line 552
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)        #line 553
                                                                                #line 554
                                                                                #line 555
                                                                                #line 556

def initialize_component_palette (root_project,root_0D,diagram_source_files):   #line 557

    reg = make_component_registry ()                                            #line 558

    for diagram_source in  diagram_source_files:                                #line 559

        all_containers_within_single_file = json2internal ( diagram_source)     #line 560

        generate_shell_components ( reg, all_containers_within_single_file)     #line 561

        for container in  all_containers_within_single_file:                    #line 562

            register_component ( reg,Template ( container ["name"], container, container_instantiator))
                                                                                #line 563


    initialize_stock_components ( reg)                                          #line 564

    return  reg                                                                 #line 565
                                                                                #line 566

                                                                                #line 567

def print_error_maybe (main_container):                                         #line 568

    error_port =  "✗"                                                           #line 569

    err = fetch_first_output ( main_container, error_port)                      #line 570

    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):                   #line 571

        print ( "___ !!! ERRORS !!! ___")                                       #line 572

        print_specific_output ( main_container, error_port, False)              #line 573

                                                                                #line 574

                                                                                #line 575
# debugging helpers                                                             #line 576
                                                                                #line 577

def nl ():                                                                      #line 578

    print ( "")                                                                 #line 579
                                                                                #line 580

                                                                                #line 581

def dump_outputs (main_container):                                              #line 582

    nl ()                                                                       #line 583

    print ( "___ Outputs ___")                                                  #line 584

    print_output_list ( main_container)                                         #line 585
                                                                                #line 586

                                                                                #line 587

def trace_outputs (main_container):                                             #line 588

    nl ()                                                                       #line 589

    print ( "___ Message Traces ___")                                           #line 590

    print_routing_trace ( main_container)                                       #line 591
                                                                                #line 592

                                                                                #line 593

def dump_hierarchy (main_container):                                            #line 594

    nl ()                                                                       #line 595

    print ( str( "___ Hierarchy ___") + (build_hierarchy ( main_container)) )   #line 596
                                                                                #line 597

                                                                                #line 598

def build_hierarchy (c):                                                        #line 599

    s =  ""                                                                     #line 600

    for child in  c. children:                                                  #line 601

        s =  str( s) + build_hierarchy ( child)                                 #line 602


    indent =  ""                                                                #line 603

    for i in range( c. depth):                                                  #line 604

        indent =  indent+ "  "                                                  #line 605


    return  str( "\n") +  str( indent) +  str( "(") +  str( c. name) +  str( s) +  ")"     #line 606
                                                                                #line 607

                                                                                #line 608

def dump_connections (c):                                                       #line 609

    nl ()                                                                       #line 610

    print ( "___ connections ___")                                              #line 611

    dump_possible_connections ( c)                                              #line 612

    for child in  c. children:                                                  #line 613

        nl ()                                                                   #line 614

        dump_possible_connections ( child)                                      #line 615

                                                                                #line 616

                                                                                #line 617

def trimws (s):                                                                 #line 618

    # remove whitespace from front and back of string                           #line 619

    return  s.strip ()                                                          #line 620
                                                                                #line 621

                                                                                #line 622

def clone_string (s):                                                           #line 623

    return  s                                                                   #line 624
                                                                                #line 625
                                                                                #line 626


load_errors =  False                                                            #line 627

runtime_errors =  False                                                         #line 628
                                                                                #line 629

def load_error (s):                                                             #line 630

    global load_errors                                                          #line 631

    print ( s)                                                                  #line 632

    quit ()                                                                     #line 633

    load_errors =  True                                                         #line 634
                                                                                #line 635

                                                                                #line 636

def runtime_error (s):                                                          #line 637

    global runtime_errors                                                       #line 638

    print ( s)                                                                  #line 639

    quit ()                                                                     #line 640

    runtime_errors =  True                                                      #line 641
                                                                                #line 642

                                                                                #line 643

def fakepipename_instantiate (reg,owner,name,template_data):                    #line 644

    instance_name = gensymbol ( "fakepipe")                                     #line 645

    return make_leaf ( instance_name, owner, None, fakepipename_handler)        #line 646
                                                                                #line 647

                                                                                #line 648

rand =  0                                                                       #line 649
                                                                                #line 650

def fakepipename_handler (eh,msg):                                              #line 651

    global rand                                                                 #line 652

    rand =  rand+ 1
    # not very random, but good enough _ 'rand' must be unique within a single run#line 653

    send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)                  #line 654
                                                                                #line 655

                                                                                #line 656
                                                                                #line 657
# all of the the built_in leaves are listed here                                #line 658
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project#line 659
                                                                                #line 660
                                                                                #line 661

def initialize_stock_components (reg):                                          #line 662

    register_component ( reg,Template ( "1then2", None, deracer_instantiate))   #line 663

    register_component ( reg,Template ( "?", None, probe_instantiate))          #line 664

    register_component ( reg,Template ( "?A", None, probeA_instantiate))        #line 665

    register_component ( reg,Template ( "?B", None, probeB_instantiate))        #line 666

    register_component ( reg,Template ( "?C", None, probeC_instantiate))        #line 667

    register_component ( reg,Template ( "trash", None, trash_instantiate))      #line 668
                                                                                #line 669

    register_component ( reg,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))#line 670

    register_component ( reg,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate))#line 671
                                                                                #line 672

    register_component ( reg,Template ( "syncfilewrite", None, syncfilewrite_instantiate))#line 673

    register_component ( reg,Template ( "stringconcat", None, stringconcat_instantiate))#line 674

    # for fakepipe                                                              #line 675

    register_component ( reg,Template ( "fakepipename", None, fakepipename_instantiate))#line 676
                                                                                #line 677

                                                                                #line 678

def argv ():                                                                    #line 679

    return sys.argv
                                                                                #line 680
                                                                                #line 681

                                                                                #line 682

def initialize ():                                                              #line 683

    root_of_project =  sys.argv[ 1]                                             #line 684

    root_of_0D =  sys.argv[ 2]                                                  #line 685

    arg =  sys.argv[ 3]                                                         #line 686

    main_container_name =  sys.argv[ 4]                                         #line 687

    diagram_names =  sys.argv[ 5:]                                              #line 688

    palette = initialize_component_palette ( root_project, root_0D, diagram_names)#line 689

    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 690
                                                                                #line 691

                                                                                #line 692

def start (palette,env):
    start_with_debug ( palette, env, False, False, False, False)                #line 693


def start_with_debug (palette,env,show_hierarchy,show_connections,show_traces,show_all_outputs):#line 694

    # show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥   #line 695

    root_of_project =  env [ 0]                                                 #line 696

    root_of_0D =  env [ 1]                                                      #line 697

    main_container_name =  env [ 2]                                             #line 698

    diagram_names =  env [ 3]                                                   #line 699

    arg =  env [ 4]                                                             #line 700

    set_environment ( root_of_project, root_of_0D)                              #line 701

    # get entrypoint container                                                  #line 702

    main_container = get_component_instance ( palette, main_container_name, None)#line 703

    if  None ==  main_container:                                                #line 704

        load_error ( str( "Couldn't find container with page name ") +  str( main_container_name) +  str( " in files ") +  str( diagram_names) +  "(check tab names, or disable compression?)"    )#line 708
                                                                                #line 709


    if  show_hierarchy:                                                         #line 710

        dump_hierarchy ( main_container)                                        #line 711
                                                                                #line 712


    if  show_connections:                                                       #line 713

        dump_connections ( main_container)                                      #line 714
                                                                                #line 715


    if not  load_errors:                                                        #line 716

        arg = new_datum_string ( arg)                                           #line 717

        msg = make_message ( "", arg)                                           #line 718

        inject ( main_container, msg)                                           #line 719

        if  show_all_outputs:                                                   #line 720

            dump_outputs ( main_container)                                      #line 721

        else:                                                                   #line 722

            print_error_maybe ( main_container)                                 #line 723

            print_specific_output ( main_container, "")                         #line 724

            if  show_traces:                                                    #line 725

                print ( "--- routing traces ---")                               #line 726

                print (routing_trace_all ( main_container))                     #line 727
                                                                                #line 728

                                                                                #line 729


        if  show_all_outputs:                                                   #line 730

            print ( "--- done ---")                                             #line 731
                                                                                #line 732

                                                                                #line 733

                                                                                #line 734

                                                                                #line 735
                                                                                #line 736
                                                                                #line 737
# utility functions                                                             #line 738

def send_int (eh,port,i,causing_message):                                       #line 739

    datum = new_datum_int ( i)                                                  #line 740

    send ( eh, port, datum, causing_message)                                    #line 741
                                                                                #line 742

                                                                                #line 743

def send_bang (eh,port,causing_message):                                        #line 744

    datum = new_datum_bang ()                                                   #line 745

    send ( eh, port, datum, causing_message)                                    #line 746
                                                                                #line 747

                                                                                #line 748





