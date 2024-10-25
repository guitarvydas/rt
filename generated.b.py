

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
# Eh_States :: enum { idle, active }                                            #line 164

class Eh:
    def __init__ (self,):                                                       #line 165

        self.name =  ""                                                         #line 166

        self.inq =  queue.Queue ()                                              #line 167

        self.outq =  queue.Queue ()                                             #line 168

        self.owner =  None                                                      #line 169

        self.saved_messages =  queue.LifoQueue () # stack of saved message(s)   #line 170

        self.inject =  injector_NIY                                             #line 171

        self.children = []                                                      #line 172

        self.visit_ordering =  queue.Queue ()                                   #line 173

        self.connections = []                                                   #line 174

        self.routings =  queue.Queue ()                                         #line 175

        self.handler =  None                                                    #line 176

        self.instance_data =  None                                              #line 177

        self.state =  "idle"                                                    #line 178
        # bootstrap debugging                                                   #line 179

        self.kind =  None # enum { container, leaf, }                           #line 180

        self.trace =  False # set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component)#line 181

        self.depth =  0 # hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc.#line 182
                                                                                #line 183

                                                                                #line 184
# Creates a component that acts as a container. It is the same as a `Eh` instance#line 185
# whose handler function is `container_handler`.                                #line 186

def make_container (name,owner):                                                #line 187

    eh = Eh ()                                                                  #line 188

    eh. name =  name                                                            #line 189

    eh. owner =  owner                                                          #line 190

    eh. handler =  container_handler                                            #line 191

    eh. inject =  container_injector                                            #line 192

    eh. state =  "idle"                                                         #line 193

    eh. kind =  "container"                                                     #line 194

    return  eh                                                                  #line 195
                                                                                #line 196

                                                                                #line 197
# Creates a new leaf component out of a handler function, and a data parameter  #line 198
# that will be passed back to your handler when called.                         #line 199
                                                                                #line 200

def make_leaf (name,owner,instance_data,handler):                               #line 201

    eh = Eh ()                                                                  #line 202

    eh. name =  str( owner. name) +  str( ".") +  name                          #line 203

    eh. owner =  owner                                                          #line 204

    eh. handler =  handler                                                      #line 205

    eh. instance_data =  instance_data                                          #line 206

    eh. state =  "idle"                                                         #line 207

    eh. kind =  "leaf"                                                          #line 208

    return  eh                                                                  #line 209
                                                                                #line 210

                                                                                #line 211
# Sends a message on the given `port` with `data`, placing it on the output     #line 212
# of the given component.                                                       #line 213
                                                                                #line 214

def send (eh,port,datum,causingMessage):                                        #line 215

    msg = make_message ( port, datum)                                           #line 216

    put_output ( eh, msg)                                                       #line 217
                                                                                #line 218

                                                                                #line 219

def send_string (eh,port,s,causingMessage):                                     #line 220

    datum = new_datum_string ( s)                                               #line 221

    msg = make_message ( port, datum)                                           #line 222

    put_output ( eh, msg)                                                       #line 223
                                                                                #line 224

                                                                                #line 225

def forward (eh,port,msg):                                                      #line 226

    fwdmsg = make_message ( port, msg. datum)                                   #line 227

    put_output ( eh, msg)                                                       #line 228
                                                                                #line 229

                                                                                #line 230

def inject (eh,msg):                                                            #line 231

    eh.inject ( eh, msg)                                                        #line 232
                                                                                #line 233

                                                                                #line 234
# Returns a list of all output messages on a container.                         #line 235
# For testing / debugging purposes.                                             #line 236
                                                                                #line 237

def output_list (eh):                                                           #line 238

    return  eh. outq                                                            #line 239
                                                                                #line 240

                                                                                #line 241
# Utility for printing an array of messages.                                    #line 242

def print_output_list (eh):                                                     #line 243

    for m in list ( eh. outq. queue):                                           #line 244

        print (format_message ( m))                                             #line 245

                                                                                #line 246

                                                                                #line 247

def spaces (n):                                                                 #line 248

    s =  ""                                                                     #line 249

    for i in range( n):                                                         #line 250

        s =  s+ " "                                                             #line 251


    return  s                                                                   #line 252
                                                                                #line 253

                                                                                #line 254

def set_active (eh):                                                            #line 255

    eh. state =  "active"                                                       #line 256
                                                                                #line 257

                                                                                #line 258

def set_idle (eh):                                                              #line 259

    eh. state =  "idle"                                                         #line 260
                                                                                #line 261

                                                                                #line 262
# Utility for printing a specific output message.                               #line 263
                                                                                #line 264

def fetch_first_output (eh,port):                                               #line 265

    for msg in list ( eh. outq. queue):                                         #line 266

        if ( msg. port ==  port):                                               #line 267

            return  msg. datum
                                                                                #line 268


    return  None                                                                #line 269
                                                                                #line 270

                                                                                #line 271

def print_specific_output (eh,port):                                            #line 272

    # port ∷ “”                                                                 #line 273

    datum = fetch_first_output ( eh, port)                                      #line 274

    outf =  None                                                                #line 275

    if  datum!= None:                                                           #line 276

        outf =  sys. stdout                                                     #line 277

        print ( datum.srepr (), outf)                                           #line 278

                                                                                #line 279


def print_specific_output_to_stderr (eh,port):                                  #line 280

    # port ∷ “”                                                                 #line 281

    datum = fetch_first_output ( eh, port)                                      #line 282

    outf =  None                                                                #line 283

    if  datum!= None:                                                           #line 284

        # I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...#line 285

        outf =  sys. stderr                                                     #line 286

        print ( datum.srepr (), outf)                                           #line 287

                                                                                #line 288

                                                                                #line 289

def put_output (eh,msg):                                                        #line 290

    eh. outq.put ( msg)                                                         #line 291
                                                                                #line 292

                                                                                #line 293

def injector_NIY (eh,msg):                                                      #line 294

    # print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“')#line 295

    print ( str( "Injector not implemented for this component ") +  str( eh. name) +  str( " kind ∷ ") +  str( eh. kind) +  str( ",  port ∷ ") +  msg. port     )#line 300

    exit ()                                                                     #line 301
                                                                                #line 302

                                                                                #line 303

import sys                                                                      #line 304

import re                                                                       #line 305

import subprocess                                                               #line 306

import shlex                                                                    #line 307
                                                                                #line 308

root_project =  ""                                                              #line 309

root_0D =  ""                                                                   #line 310
                                                                                #line 311

def set_environment (rproject,r0D):                                             #line 312

    global root_project                                                         #line 313

    global root_0D                                                              #line 314

    root_project =  rproject                                                    #line 315

    root_0D =  r0D                                                              #line 316
                                                                                #line 317

                                                                                #line 318

def probe_instantiate (reg,owner,name,template_data):                           #line 319

    name_with_id = gensymbol ( "?")                                             #line 320

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 321
                                                                                #line 322


def probeA_instantiate (reg,owner,name,template_data):                          #line 323

    name_with_id = gensymbol ( "?A")                                            #line 324

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 325
                                                                                #line 326

                                                                                #line 327

def probeB_instantiate (reg,owner,name,template_data):                          #line 328

    name_with_id = gensymbol ( "?B")                                            #line 329

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 330
                                                                                #line 331

                                                                                #line 332

def probeC_instantiate (reg,owner,name,template_data):                          #line 333

    name_with_id = gensymbol ( "?C")                                            #line 334

    return make_leaf ( name_with_id, owner, None, probe_handler)                #line 335
                                                                                #line 336

                                                                                #line 337

def probe_handler (eh,msg):                                                     #line 338

    s =  msg. datum.srepr ()                                                    #line 339

    print ( str( "... probe ") +  str( eh. name) +  str( ": ") +  s   , sys. stderr)#line 340
                                                                                #line 341

                                                                                #line 342

def trash_instantiate (reg,owner,name,template_data):                           #line 343

    name_with_id = gensymbol ( "trash")                                         #line 344

    return make_leaf ( name_with_id, owner, None, trash_handler)                #line 345
                                                                                #line 346

                                                                                #line 347

def trash_handler (eh,msg):                                                     #line 348

    # to appease dumped_on_floor checker                                        #line 349

    pass                                                                        #line 350
                                                                                #line 351


class TwoMessages:
    def __init__ (self,first,second):                                           #line 352

        self.first =  first                                                     #line 353

        self.second =  second                                                   #line 354
                                                                                #line 355

                                                                                #line 356
# Deracer_States :: enum { idle, waitingForFirst, waitingForSecond }            #line 357

class Deracer_Instance_Data:
    def __init__ (self,state,buffer):                                           #line 358

        self.state =  state                                                     #line 359

        self.buffer =  buffer                                                   #line 360
                                                                                #line 361

                                                                                #line 362

def reclaim_Buffers_from_heap (inst):                                           #line 363

    pass                                                                        #line 364
                                                                                #line 365

                                                                                #line 366

def deracer_instantiate (reg,owner,name,template_data):                         #line 367

    name_with_id = gensymbol ( "deracer")                                       #line 368

    inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))            #line 369

    inst. state =  "idle"                                                       #line 370

    eh = make_leaf ( name_with_id, owner, inst, deracer_handler)                #line 371

    return  eh                                                                  #line 372
                                                                                #line 373

                                                                                #line 374

def send_first_then_second (eh,inst):                                           #line 375

    forward ( eh, "1", inst. buffer. first)                                     #line 376

    forward ( eh, "2", inst. buffer. second)                                    #line 377

    reclaim_Buffers_from_heap ( inst)                                           #line 378
                                                                                #line 379

                                                                                #line 380

def deracer_handler (eh,msg):                                                   #line 381

    inst =  eh. instance_data                                                   #line 382

    if  inst. state ==  "idle":                                                 #line 383

        if  "1" ==  msg. port:                                                  #line 384

            inst. buffer. first =  msg                                          #line 385

            inst. state =  "waitingForSecond"                                   #line 386

        elif  "2" ==  msg. port:                                                #line 387

            inst. buffer. second =  msg                                         #line 388

            inst. state =  "waitingForFirst"                                    #line 389

        else:                                                                   #line 390

            runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg. port )
                                                                                #line 391

    elif  inst. state ==  "waitingForFirst":                                    #line 392

        if  "1" ==  msg. port:                                                  #line 393

            inst. buffer. first =  msg                                          #line 394

            send_first_then_second ( eh, inst)                                  #line 395

            inst. state =  "idle"                                               #line 396

        else:                                                                   #line 397

            runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg. port )
                                                                                #line 398

    elif  inst. state ==  "waitingForSecond":                                   #line 399

        if  "2" ==  msg. port:                                                  #line 400

            inst. buffer. second =  msg                                         #line 401

            send_first_then_second ( eh, inst)                                  #line 402

            inst. state =  "idle"                                               #line 403

        else:                                                                   #line 404

            runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg. port )
                                                                                #line 405

    else:                                                                       #line 406

        runtime_error ( "bad state for deracer {eh.state}")                     #line 407

                                                                                #line 408

                                                                                #line 409

def low_level_read_text_file_instantiate (reg,owner,name,template_data):        #line 410

    name_with_id = gensymbol ( "Low Level Read Text File")                      #line 411

    return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)#line 412
                                                                                #line 413

                                                                                #line 414

def low_level_read_text_file_handler (eh,msg):                                  #line 415

    fname =  msg. datum.srepr ()                                                #line 416

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
                                                                                #line 417
                                                                                #line 418

                                                                                #line 419

def ensure_string_datum_instantiate (reg,owner,name,template_data):             #line 420

    name_with_id = gensymbol ( "Ensure String Datum")                           #line 421

    return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)  #line 422
                                                                                #line 423

                                                                                #line 424

def ensure_string_datum_handler (eh,msg):                                       #line 425

    if  "string" ==  msg. datum.kind ():                                        #line 426

        forward ( eh, "", msg)                                                  #line 427

    else:                                                                       #line 428

        emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg. datum #line 429

        send_string ( eh, "✗", emsg, msg)                                       #line 430

                                                                                #line 431

                                                                                #line 432

class Syncfilewrite_Data:
    def __init__ (self,):                                                       #line 433

        self.filename =  ""                                                     #line 434
                                                                                #line 435

                                                                                #line 436
# temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)   #line 437

def syncfilewrite_instantiate (reg,owner,name,template_data):                   #line 438

    name_with_id = gensymbol ( "syncfilewrite")                                 #line 439

    inst = Syncfilewrite_Data ()                                                #line 440

    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)        #line 441
                                                                                #line 442

                                                                                #line 443

def syncfilewrite_handler (eh,msg):                                             #line 444

    inst =  eh. instance_data                                                   #line 445

    if  "filename" ==  msg. port:                                               #line 446

        inst. filename =  msg. datum.srepr ()                                   #line 447

    elif  "input" ==  msg. port:                                                #line 448

        contents =  msg. datum.srepr ()                                         #line 449

        f = open ( inst. filename, "w")                                         #line 450

        if  f!= None:                                                           #line 451

            f.write ( msg. datum.srepr ())                                      #line 452

            f.close ()                                                          #line 453

            send ( eh, "done",new_datum_bang (), msg)                           #line 454

        else:                                                                   #line 455

            send_string ( eh, "✗", str( "open error on file ") +  inst. filename , msg)
                                                                                #line 456

                                                                                #line 457

                                                                                #line 458

class StringConcat_Instance_Data:
    def __init__ (self,):                                                       #line 459

        self.buffer1 =  None                                                    #line 460

        self.buffer2 =  None                                                    #line 461

        self.count =  0                                                         #line 462
                                                                                #line 463

                                                                                #line 464

def stringconcat_instantiate (reg,owner,name,template_data):                    #line 465

    name_with_id = gensymbol ( "stringconcat")                                  #line 466

    instp = StringConcat_Instance_Data ()                                       #line 467

    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)        #line 468
                                                                                #line 469

                                                                                #line 470

def stringconcat_handler (eh,msg):                                              #line 471

    inst =  eh. instance_data                                                   #line 472

    if  "1" ==  msg. port:                                                      #line 473

        inst. buffer1 = clone_string ( msg. datum.srepr ())                     #line 474

        inst. count =  inst. count+ 1                                           #line 475

        maybe_stringconcat ( eh, inst, msg)                                     #line 476

    elif  "2" ==  msg. port:                                                    #line 477

        inst. buffer2 = clone_string ( msg. datum.srepr ())                     #line 478

        inst. count =  inst. count+ 1                                           #line 479

        maybe_stringconcat ( eh, inst, msg)                                     #line 480

    else:                                                                       #line 481

        runtime_error ( str( "bad msg.port for stringconcat: ") +  msg. port )  #line 482
                                                                                #line 483

                                                                                #line 484

                                                                                #line 485

def maybe_stringconcat (eh,inst,msg):                                           #line 486

    if ( 0 == len ( inst. buffer1)) and ( 0 == len ( inst. buffer2)):           #line 487

        runtime_error ( "something is wrong in stringconcat, both strings are 0 length")#line 488


    if  inst. count >=  2:                                                      #line 489

        concatenated_string =  ""                                               #line 490

        if  0 == len ( inst. buffer1):                                          #line 491

            concatenated_string =  inst. buffer2                                #line 492

        elif  0 == len ( inst. buffer2):                                        #line 493

            concatenated_string =  inst. buffer1                                #line 494

        else:                                                                   #line 495

            concatenated_string =  inst. buffer1+ inst. buffer2                 #line 496


        send_string ( eh, "", concatenated_string, msg)                         #line 497

        inst. buffer1 =  None                                                   #line 498

        inst. buffer2 =  None                                                   #line 499

        inst. count =  0                                                        #line 500

                                                                                #line 501

                                                                                #line 502
#                                                                               #line 503
                                                                                #line 504
# this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here#line 505

def shell_out_instantiate (reg,owner,name,template_data):                       #line 506

    name_with_id = gensymbol ( "shell_out")                                     #line 507

    cmd =  shlex.split ( template_data)                                         #line 508

    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)             #line 509
                                                                                #line 510

                                                                                #line 511

def shell_out_handler (eh,msg):                                                 #line 512

    cmd =  eh. instance_data                                                    #line 513

    s =  msg. datum.srepr ()                                                    #line 514

    [ stdout, stderr] = run_command ( eh, cmd, s)                               #line 515

    if  stderr!= None:                                                          #line 516

        send_string ( eh, "✗", stderr, msg)                                     #line 517

    else:                                                                       #line 518

        send_string ( eh, "", stdout, msg)                                      #line 519

                                                                                #line 520

                                                                                #line 521

def string_constant_instantiate (reg,owner,name,template_data):                 #line 522

    global root_project                                                         #line 523

    global root_0D                                                              #line 524

    name_with_id = gensymbol ( "strconst")                                      #line 525

    s =  template_data                                                          #line 526

    if  root_project!= "":                                                      #line 527

        s =  re.sub ( "_00_", root_project, s)                                  #line 528


    if  root_0D!= "":                                                           #line 529

        s =  re.sub ( "_0D_", root_0D, s)                                       #line 530


    return make_leaf ( name_with_id, owner, s, string_constant_handler)         #line 531
                                                                                #line 532

                                                                                #line 533

def string_constant_handler (eh,msg):                                           #line 534

    s =  eh. instance_data                                                      #line 535

    send_string ( eh, "", s, msg)                                               #line 536
                                                                                #line 537

                                                                                #line 538

def string_make_persistent (s):                                                 #line 539

    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python#line 540

    return  s                                                                   #line 541
                                                                                #line 542

                                                                                #line 543

def string_clone (s):                                                           #line 544

    return  s                                                                   #line 545
                                                                                #line 546

                                                                                #line 547

import sys                                                                      #line 548
                                                                                #line 549
# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...   #line 550
# where ${_00_} is the root directory for the project                           #line 551
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)        #line 552
                                                                                #line 553
                                                                                #line 554
                                                                                #line 555

def initialize_component_palette (root_project,root_0D,diagram_source_files):   #line 556

    reg = make_component_registry ()                                            #line 557

    for diagram_source in  diagram_source_files:                                #line 558

        all_containers_within_single_file = json2internal ( diagram_source)     #line 559

        generate_shell_components ( reg, all_containers_within_single_file)     #line 560

        for container in  all_containers_within_single_file:                    #line 561

            register_component ( reg,Template ( container ["name"], container, container_instantiator))
                                                                                #line 562


    initialize_stock_components ( reg)                                          #line 563

    return  reg                                                                 #line 564
                                                                                #line 565

                                                                                #line 566

def print_error_maybe (main_container):                                         #line 567

    error_port =  "✗"                                                           #line 568

    err = fetch_first_output ( main_container, error_port)                      #line 569

    if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):                   #line 570

        print ( "___ !!! ERRORS !!! ___")                                       #line 571

        print_specific_output ( main_container, error_port, False)              #line 572

                                                                                #line 573

                                                                                #line 574
# debugging helpers                                                             #line 575
                                                                                #line 576

def nl ():                                                                      #line 577

    print ( "")                                                                 #line 578
                                                                                #line 579

                                                                                #line 580

def dump_outputs (main_container):                                              #line 581

    nl ()                                                                       #line 582

    print ( "___ Outputs ___")                                                  #line 583

    print_output_list ( main_container)                                         #line 584
                                                                                #line 585

                                                                                #line 586

def trace_outputs (main_container):                                             #line 587

    nl ()                                                                       #line 588

    print ( "___ Message Traces ___")                                           #line 589

    print_routing_trace ( main_container)                                       #line 590
                                                                                #line 591

                                                                                #line 592

def dump_hierarchy (main_container):                                            #line 593

    nl ()                                                                       #line 594

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

    nl ()                                                                       #line 609

    print ( "___ connections ___")                                              #line 610

    dump_possible_connections ( c)                                              #line 611

    for child in  c. children:                                                  #line 612

        nl ()                                                                   #line 613

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

def argv ():                                                                    #line 678
 sys.argv                                                                       #line 679
                                                                                #line 680

                                                                                #line 681

def initialize ():                                                              #line 682

    root_of_project =  sys.argv[ 1]                                             #line 683

    root_of_0D =  sys.argv[ 2]                                                  #line 684

    arg =  sys.argv[ 3]                                                         #line 685

    main_container_name =  sys.argv[ 4]                                         #line 686

    diagram_names =  sys.argv[ 5:]                                              #line 687

    palette = initialize_component_palette ( root_project, root_0D, diagram_names)#line 688

    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]#line 689
                                                                                #line 690

                                                                                #line 691

def start (palette,env):
    start_with_debug ( palette, env, False, False, False, False)                #line 692


def start_with_debug (palette,env,show_hierarchy,show_connections,show_traces,show_all_outputs):#line 693

    # show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥   #line 694

    root_of_project =  env [ 0]                                                 #line 695

    root_of_0D =  env [ 1]                                                      #line 696

    main_container_name =  env [ 2]                                             #line 697

    diagram_names =  env [ 3]                                                   #line 698

    arg =  env [ 4]                                                             #line 699

    set_environment ( root_of_project, root_of_0D)                              #line 700

    # get entrypoint container                                                  #line 701

    main_container = get_component_instance ( palette, main_container_name, None)#line 702

    if  None ==  main_container:                                                #line 703

        load_error ( str( "Couldn't find container with page name ") +  str( main_container_name) +  str( " in files ") +  str( diagram_names) +  "(check tab names, or disable compression?)"    )#line 707
                                                                                #line 708


    if  show_hierarchy:                                                         #line 709

        dump_hierarchy ( main_container)                                        #line 710
                                                                                #line 711


    if  show_connections:                                                       #line 712

        dump_connections ( main_container)                                      #line 713
                                                                                #line 714


    if not  load_errors:                                                        #line 715

        arg = new_datum_string ( arg)                                           #line 716

        msg = make_message ( "", arg)                                           #line 717

        inject ( main_container, msg)                                           #line 718

        if  show_all_outputs:                                                   #line 719

            dump_outputs ( main_container)                                      #line 720

        else:                                                                   #line 721

            print_error_maybe ( main_container)                                 #line 722

            print_specific_output ( main_container, "")                         #line 723

            if  show_traces:                                                    #line 724

                print ( "--- routing traces ---")                               #line 725

                print (routing_trace_all ( main_container))                     #line 726
                                                                                #line 727

                                                                                #line 728


        if  show_all_outputs:                                                   #line 729

            print ( "--- done ---")                                             #line 730
                                                                                #line 731

                                                                                #line 732

                                                                                #line 733

                                                                                #line 734
                                                                                #line 735
                                                                                #line 736
# utility functions                                                             #line 737

def send_int (eh,port,i,causing_message):                                       #line 738

    datum = new_datum_int ( i)                                                  #line 739

    send ( eh, port, datum, causing_message)                                    #line 740
                                                                                #line 741

                                                                                #line 742

def send_bang (eh,port,causing_message):                                        #line 743

    datum = new_datum_bang ()                                                   #line 744

    send ( eh, port, datum, causing_message)                                    #line 745
                                                                                #line 746

                                                                                #line 747





