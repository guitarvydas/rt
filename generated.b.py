

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





