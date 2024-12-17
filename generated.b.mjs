
                              /* line 1 *//* line 2 *//* line 3 */
class Component_Registry {
  constructor () {            /* line 4 */

    this.templates = {};      /* line 5 *//* line 6 */
  }
}
                              /* line 7 */
class Template {
  constructor () {            /* line 8 */

    this.name =  null;        /* line 9 */
    this.template_data =  null;/* line 10 */
    this.instantiator =  null;/* line 11 *//* line 12 */
  }
}
                              /* line 13 */
function mkTemplate (name,template_data,instantiator) {/* line 14 */
    let  templ =  new Template ();/* line 15 */;
    templ.name =  name;       /* line 16 */
    templ.template_data =  template_data;/* line 17 */
    templ.instantiator =  instantiator;/* line 18 */
    return  templ;            /* line 19 *//* line 20 *//* line 21 */
}

function read_and_convert_json_file (pathname,filename) {/* line 22 */

    console.log (filename);
    let jstr = undefined;
    if (filename == "0") {
    jstr = fs.readFileSync (0);
    } else if (pathname) {
    jstr = fs.readFileSync (`${pathname}/${filename}`);
    } else {
    jstr = fs.readFileSync (`${filename}`);
    }
    if (jstr) {
    return JSON.parse (jstr);
    } else {
    return undefined;
    }
                              /* line 23 *//* line 24 *//* line 25 */
}

function json2internal (pathname,container_xml) {/* line 26 */
    let fname =   container_xml/* line 27 */;
    let routings = read_and_convert_json_file ( pathname, fname)/* line 28 */;
    return  routings;         /* line 29 *//* line 30 *//* line 31 */
}

function delete_decls (d) {   /* line 32 *//* line 33 *//* line 34 *//* line 35 */
}

function make_component_registry () {/* line 36 */
    return  new Component_Registry ();/* line 37 */;/* line 38 *//* line 39 */
}

function register_component (reg,template) {
    return abstracted_register_component ( reg, template, false);/* line 40 */
}

function register_component_allow_overwriting (reg,template) {
    return abstracted_register_component ( reg, template, true);/* line 41 *//* line 42 */
}

function abstracted_register_component (reg,template,ok_to_overwrite) {/* line 43 */
    let name = mangle_name ( template.name)/* line 44 */;
    if ((((((( reg!= null) && ( name))) in ( reg.templates))) && ((!  ok_to_overwrite)))) {/* line 45 */
      load_error ( `${ "Component /"}${ `${ template.name}${ "/ already declared"}` }` )/* line 46 */
      return  reg;            /* line 47 */}
    else {                    /* line 48 */
      reg.templates [name] =  template;/* line 49 */
      return  reg;            /* line 50 *//* line 51 */}/* line 52 *//* line 53 */
}

function get_component_instance (reg,full_name,owner) {/* line 54 */
    let template_name = mangle_name ( full_name)/* line 55 */;
    if ((( template_name) in ( reg.templates))) {/* line 56 */
      let template =  reg.templates [template_name];/* line 57 */
      if (( template ==  null)) {/* line 58 */
        load_error ( `${ "Registry Error (A): Can;t find component /"}${ `${ template_name}${ "/"}` }` )/* line 59 */
        return  null;         /* line 60 */}
      else {                  /* line 61 */
        let owner_name =  ""; /* line 62 */
        let instance_name =  template_name;/* line 63 */
        if ( null!= owner) {  /* line 64 */
          owner_name =  owner.name;/* line 65 */
          instance_name =  `${ owner_name}${ `${ "."}${ template_name}` }` /* line 66 */;}
        else {                /* line 67 */
          instance_name =  template_name;/* line 68 *//* line 69 */}
        let instance =  template.instantiator ( reg, owner, instance_name, template.template_data)/* line 70 */;
        return  instance;     /* line 71 *//* line 72 */}}
    else {                    /* line 73 */
      load_error ( `${ "Registry Error (B): Can't find component /"}${ `${ template_name}${ "/"}` }` )/* line 74 */
      return  null;           /* line 75 *//* line 76 */}/* line 77 *//* line 78 */
}

function dump_registry (reg) {/* line 79 */
    nl ()                     /* line 80 */
    console.log ( "*** PALETTE ***");/* line 81 */
    for (let c of  reg.templates) {/* line 82 */
      print ( c.name)         /* line 83 */}
    console.log ( "***************");/* line 84 */
    nl ()                     /* line 85 *//* line 86 *//* line 87 */
}

function print_stats (reg) {  /* line 88 */
    console.log ( `${ "registry statistics: "}${ reg.stats}` );/* line 89 *//* line 90 *//* line 91 */
}

function mangle_name (s) {    /* line 92 */
    /*  trim name to remove code from Container component names _ deferred until later (or never) *//* line 93 */
    return  s;                /* line 94 *//* line 95 *//* line 96 */
}

function generate_shell_components (reg,container_list) {/* line 97 */
    /*  [ */                  /* line 98 */
    /*      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 99 */
    /*      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} *//* line 100 */
    /*  ] */                  /* line 101 */
    if ( null!= container_list) {/* line 102 */
      for (let diagram of  container_list) {/* line 103 */
        /*  loop through every component in the diagram and look for names that start with “$“ or “'“  *//* line 104 */
        /*  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 105 */
        for (let child_descriptor of  diagram [ "children"]) {/* line 106 */
          if (first_char_is ( child_descriptor [ "name"], "$")) {/* line 107 */
            let name =  child_descriptor [ "name"];/* line 108 */
            let cmd =   name.substring (1) .strip ();/* line 109 */
            let generated_leaf = mkTemplate ( name, cmd, shell_out_instantiate)/* line 110 */;
            register_component ( reg, generated_leaf)/* line 111 */}
          else if (first_char_is ( child_descriptor [ "name"], "'")) {/* line 112 */
            let name =  child_descriptor [ "name"];/* line 113 */
            let s =   name.substring (1) /* line 114 */;
            let generated_leaf = mkTemplate ( name, s, string_constant_instantiate)/* line 115 */;
            register_component_allow_overwriting ( reg, generated_leaf)/* line 116 *//* line 117 */}/* line 118 */}/* line 119 */}/* line 120 */}
    return  reg;              /* line 121 *//* line 122 *//* line 123 */
}

function first_char (s) {     /* line 124 */
    return   s[0]             /* line 125 */;/* line 126 *//* line 127 */
}

function first_char_is (s,c) {/* line 128 */
    return  c == first_char ( s)/* line 129 */;/* line 130 *//* line 131 */
}
                              /* line 132 */
/*  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here *//* line 133 */
/*  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped *//* line 134 *//* line 135 *//* line 136 */
/*  Data for an asyncronous component _ effectively, a function with input *//* line 137 */
/*  and output queues of messages. *//* line 138 */
/*  */                        /* line 139 */
/*  Components can either be a user_supplied function (“lea“), or a “container“ *//* line 140 */
/*  that routes messages to child components according to a list of connections *//* line 141 */
/*  that serve as a message routing table. *//* line 142 */
/*  */                        /* line 143 */
/*  Child components themselves can be leaves or other containers. *//* line 144 */
/*  */                        /* line 145 */
/*  `handler` invokes the code that is attached to this component. *//* line 146 */
/*  */                        /* line 147 */
/*  `instance_data` is a pointer to instance data that the `leaf_handler` *//* line 148 */
/*  function may want whenever it is invoked again. *//* line 149 */
/*  */                        /* line 150 *//* line 151 */
/*  Eh_States :: enum { idle, active } *//* line 152 */
class Eh {
  constructor () {            /* line 153 */

    this.name =  "";          /* line 154 */
    this.inq =  []            /* line 155 */;
    this.outq =  []           /* line 156 */;
    this.owner =  null;       /* line 157 */
    this.children = [];       /* line 158 */
    this.visit_ordering =  [] /* line 159 */;
    this.connections = [];    /* line 160 */
    this.routings =  []       /* line 161 */;
    this.handler =  null;     /* line 162 */
    this.finject =  null;     /* line 163 */
    this.instance_data =  null;/* line 164 */
    this.state =  "idle";     /* line 165 *//*  bootstrap debugging *//* line 166 */
    this.kind =  null;/*  enum { container, leaf, } *//* line 167 *//* line 168 */
  }
}
                              /* line 169 */
/*  Creates a component that acts as a container. It is the same as a `Eh` instance *//* line 170 */
/*  whose handler function is `container_handler`. *//* line 171 */
function make_container (name,owner) {/* line 172 */
    let  eh =  new Eh ();     /* line 173 */;
    eh.name =  name;          /* line 174 */
    eh.owner =  owner;        /* line 175 */
    eh.handler =  container_handler;/* line 176 */
    eh.finject =  container_injector;/* line 177 */
    eh.state =  "idle";       /* line 178 */
    eh.kind =  "container";   /* line 179 */
    return  eh;               /* line 180 *//* line 181 *//* line 182 */
}

/*  Creates a new leaf component out of a handler function, and a data parameter *//* line 183 */
/*  that will be passed back to your handler when called. *//* line 184 *//* line 185 */
function make_leaf (name,owner,instance_data,handler) {/* line 186 */
    let  eh =  new Eh ();     /* line 187 */;
    eh.name =  `${ owner.name}${ `${ "."}${ name}` }` /* line 188 */;
    eh.owner =  owner;        /* line 189 */
    eh.handler =  handler;    /* line 190 */
    eh.instance_data =  instance_data;/* line 191 */
    eh.state =  "idle";       /* line 192 */
    eh.kind =  "leaf";        /* line 193 */
    return  eh;               /* line 194 *//* line 195 *//* line 196 */
}

/*  Sends a message on the given `port` with `data`, placing it on the output *//* line 197 */
/*  of the given component. *//* line 198 *//* line 199 */
function send (eh,port,datum,causingMessage) {/* line 200 */
    let msg = make_message ( port, datum)/* line 201 */;
    put_output ( eh, msg)     /* line 202 *//* line 203 *//* line 204 */
}

function send_string (eh,port,s,causingMessage) {/* line 205 */
    let datum = new_datum_string ( s)/* line 206 */;
    let msg = make_message ( port, datum)/* line 207 */;
    put_output ( eh, msg)     /* line 208 *//* line 209 *//* line 210 */
}

function forward (eh,port,msg) {/* line 211 */
    let fwdmsg = make_message ( port, msg.datum)/* line 212 */;
    put_output ( eh, msg)     /* line 213 *//* line 214 *//* line 215 */
}

function inject (eh,msg) {    /* line 216 */
    eh.finject ( eh, msg)     /* line 217 *//* line 218 *//* line 219 */
}

/*  Returns a list of all output messages on a container. *//* line 220 */
/*  For testing / debugging purposes. *//* line 221 *//* line 222 */
function output_list (eh) {   /* line 223 */
    return  eh.outq;          /* line 224 *//* line 225 *//* line 226 */
}

/*  Utility for printing an array of messages. *//* line 227 */
function print_output_list (eh) {/* line 228 */
    console.log ( "{");       /* line 229 */
    for (let m of   eh.outq) {/* line 230 */
      console.log (format_message ( m));/* line 231 *//* line 232 */}
    console.log ( "}");       /* line 233 *//* line 234 *//* line 235 */
}

function spaces (n) {         /* line 236 */
    let  s =  "";             /* line 237 */
    for (let i of range( n)) {/* line 238 */
      s =  s+ " ";            /* line 239 */}
    return  s;                /* line 240 *//* line 241 *//* line 242 */
}

function set_active (eh) {    /* line 243 */
    eh.state =  "active";     /* line 244 *//* line 245 *//* line 246 */
}

function set_idle (eh) {      /* line 247 */
    eh.state =  "idle";       /* line 248 *//* line 249 *//* line 250 */
}

/*  Utility for printing a specific output message. *//* line 251 *//* line 252 */
function fetch_first_output (eh,port) {/* line 253 */
    for (let msg of   eh.outq) {/* line 254 */
      if (( msg.port ==  port)) {/* line 255 */
        return  msg.datum;}   /* line 256 */}
    return  null;             /* line 257 *//* line 258 *//* line 259 */
}

function print_specific_output (eh,port) {/* line 260 */
    /*  port ∷ “” */          /* line 261 */
    let  datum = fetch_first_output ( eh, port)/* line 262 */;
    console.log ( datum.srepr ());/* line 263 *//* line 264 */
}

function print_specific_output_to_stderr (eh,port) {/* line 265 */
    /*  port ∷ “” */          /* line 266 */
    let  datum = fetch_first_output ( eh, port)/* line 267 */;
    /*  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... *//* line 268 */
    console.error ( datum.srepr ());/* line 269 *//* line 270 *//* line 271 */
}

function put_output (eh,msg) {/* line 272 */
    eh.outq.push ( msg)       /* line 273 *//* line 274 *//* line 275 */
}

let  root_project =  "";      /* line 276 */
let  root_0D =  "";           /* line 277 *//* line 278 */
function set_environment (rproject,r0D) {/* line 279 *//* line 280 *//* line 281 */
    root_project =  rproject; /* line 282 */
    root_0D =  r0D;           /* line 283 *//* line 284 *//* line 285 */
}

function probeA_instantiate (reg,owner,name,template_data) {/* line 286 */
    let name_with_id = gensymbol ( "?A")/* line 287 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 288 */;/* line 289 *//* line 290 */
}

function probeB_instantiate (reg,owner,name,template_data) {/* line 291 */
    let name_with_id = gensymbol ( "?B")/* line 292 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 293 */;/* line 294 *//* line 295 */
}

function probeC_instantiate (reg,owner,name,template_data) {/* line 296 */
    let name_with_id = gensymbol ( "?C")/* line 297 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 298 */;/* line 299 *//* line 300 */
}

function probe_handler (eh,msg) {/* line 301 */
    let s =  msg.datum.srepr ();/* line 302 */
    console.error ( `${ "... probe "}${ `${ eh.name}${ `${ ": "}${ s}` }` }` );/* line 303 *//* line 304 *//* line 305 */
}

function trash_instantiate (reg,owner,name,template_data) {/* line 306 */
    let name_with_id = gensymbol ( "trash")/* line 307 */;
    return make_leaf ( name_with_id, owner, null, trash_handler)/* line 308 */;/* line 309 *//* line 310 */
}

function trash_handler (eh,msg) {/* line 311 */
    /*  to appease dumped_on_floor checker *//* line 312 *//* line 313 *//* line 314 */
}

class TwoMessages {
  constructor () {            /* line 315 */

    this.firstmsg =  null;    /* line 316 */
    this.secondmsg =  null;   /* line 317 *//* line 318 */
  }
}
                              /* line 319 */
/*  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } *//* line 320 */
class Deracer_Instance_Data {
  constructor () {            /* line 321 */

    this.state =  null;       /* line 322 */
    this.buffer =  null;      /* line 323 *//* line 324 */
  }
}
                              /* line 325 */
function reclaim_Buffers_from_heap (inst) {/* line 326 *//* line 327 *//* line 328 *//* line 329 */
}

function deracer_instantiate (reg,owner,name,template_data) {/* line 330 */
    let name_with_id = gensymbol ( "deracer")/* line 331 */;
    let  inst =  new Deracer_Instance_Data ();/* line 332 */;
    inst.state =  "idle";     /* line 333 */
    inst.buffer =  new TwoMessages ();/* line 334 */;
    let eh = make_leaf ( name_with_id, owner, inst, deracer_handler)/* line 335 */;
    return  eh;               /* line 336 *//* line 337 *//* line 338 */
}

function send_firstmsg_then_secondmsg (eh,inst) {/* line 339 */
    forward ( eh, "1", inst.buffer.firstmsg)/* line 340 */
    forward ( eh, "2", inst.buffer.secondmsg)/* line 341 */
    reclaim_Buffers_from_heap ( inst)/* line 342 *//* line 343 *//* line 344 */
}

function deracer_handler (eh,msg) {/* line 345 */
    let  inst =  eh.instance_data;/* line 346 */
    if ( inst.state ==  "idle") {/* line 347 */
      if ( "1" ==  msg.port) {/* line 348 */
        inst.buffer.firstmsg =  msg;/* line 349 */
        inst.state =  "waitingForSecondmsg";/* line 350 */}
      else if ( "2" ==  msg.port) {/* line 351 */
        inst.buffer.secondmsg =  msg;/* line 352 */
        inst.state =  "waitingForFirstmsg";/* line 353 */}
      else {                  /* line 354 */
        runtime_error ( `${ "bad msg.port (case A) for deracer "}${ msg.port}` )/* line 355 *//* line 356 */}}
    else if ( inst.state ==  "waitingForFirstmsg") {/* line 357 */
      if ( "1" ==  msg.port) {/* line 358 */
        inst.buffer.firstmsg =  msg;/* line 359 */
        send_firstmsg_then_secondmsg ( eh, inst)/* line 360 */
        inst.state =  "idle"; /* line 361 */}
      else {                  /* line 362 */
        runtime_error ( `${ "bad msg.port (case B) for deracer "}${ msg.port}` )/* line 363 *//* line 364 */}}
    else if ( inst.state ==  "waitingForSecondmsg") {/* line 365 */
      if ( "2" ==  msg.port) {/* line 366 */
        inst.buffer.secondmsg =  msg;/* line 367 */
        send_firstmsg_then_secondmsg ( eh, inst)/* line 368 */
        inst.state =  "idle"; /* line 369 */}
      else {                  /* line 370 */
        runtime_error ( `${ "bad msg.port (case C) for deracer "}${ msg.port}` )/* line 371 *//* line 372 */}}
    else {                    /* line 373 */
      runtime_error ( "bad state for deracer {eh.state}")/* line 374 *//* line 375 */}/* line 376 *//* line 377 */
}

function low_level_read_text_file_instantiate (reg,owner,name,template_data) {/* line 378 */
    let name_with_id = gensymbol ( "Low Level Read Text File")/* line 379 */;
    return make_leaf ( name_with_id, owner, null, low_level_read_text_file_handler)/* line 380 */;/* line 381 *//* line 382 */
}

function low_level_read_text_file_handler (eh,msg) {/* line 383 */
    let fname =  msg.datum.srepr ();/* line 384 */

    if (fname == "0") {
    data = fs.readFileSync (0);
    } else {
    data = fs.readFileSync (fname);
    }
    if (data) {
      send_string (eh, "", data, msg);
    } else {
      send_string (eh, "✗", `read error on file '${fname}'`, msg);
    }
                              /* line 385 *//* line 386 *//* line 387 */
}

function ensure_string_datum_instantiate (reg,owner,name,template_data) {/* line 388 */
    let name_with_id = gensymbol ( "Ensure String Datum")/* line 389 */;
    return make_leaf ( name_with_id, owner, null, ensure_string_datum_handler)/* line 390 */;/* line 391 *//* line 392 */
}

function ensure_string_datum_handler (eh,msg) {/* line 393 */
    if ( "string" ==  msg.datum.kind ()) {/* line 394 */
      forward ( eh, "", msg)  /* line 395 */}
    else {                    /* line 396 */
      let emsg =  `${ "*** ensure: type error (expected a string datum) but got "}${ msg.datum}` /* line 397 */;
      send_string ( eh, "✗", emsg, msg)/* line 398 *//* line 399 */}/* line 400 *//* line 401 */
}

class Syncfilewrite_Data {
  constructor () {            /* line 402 */

    this.filename =  "";      /* line 403 *//* line 404 */
  }
}
                              /* line 405 */
/*  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) *//* line 406 */
function syncfilewrite_instantiate (reg,owner,name,template_data) {/* line 407 */
    let name_with_id = gensymbol ( "syncfilewrite")/* line 408 */;
    let inst =  new Syncfilewrite_Data ();/* line 409 */;
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)/* line 410 */;/* line 411 *//* line 412 */
}

function syncfilewrite_handler (eh,msg) {/* line 413 */
    let  inst =  eh.instance_data;/* line 414 */
    if ( "filename" ==  msg.port) {/* line 415 */
      inst.filename =  msg.datum.srepr ();/* line 416 */}
    else if ( "input" ==  msg.port) {/* line 417 */
      let contents =  msg.datum.srepr ();/* line 418 */
      let  f = open ( inst.filename, "w")/* line 419 */;
      if ( f!= null) {        /* line 420 */
        f.write ( msg.datum.srepr ())/* line 421 */
        f.close ()            /* line 422 */
        send ( eh, "done",new_datum_bang (), msg)/* line 423 */}
      else {                  /* line 424 */
        send_string ( eh, "✗", `${ "open error on file "}${ inst.filename}` , msg)/* line 425 *//* line 426 */}/* line 427 */}/* line 428 *//* line 429 */
}

class StringConcat_Instance_Data {
  constructor () {            /* line 430 */

    this.buffer1 =  null;     /* line 431 */
    this.buffer2 =  null;     /* line 432 */
    this.scount =  0;         /* line 433 *//* line 434 */
  }
}
                              /* line 435 */
function stringconcat_instantiate (reg,owner,name,template_data) {/* line 436 */
    let name_with_id = gensymbol ( "stringconcat")/* line 437 */;
    let instp =  new StringConcat_Instance_Data ();/* line 438 */;
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)/* line 439 */;/* line 440 *//* line 441 */
}

function stringconcat_handler (eh,msg) {/* line 442 */
    let  inst =  eh.instance_data;/* line 443 */
    if ( "1" ==  msg.port) {  /* line 444 */
      inst.buffer1 = clone_string ( msg.datum.srepr ())/* line 445 */;
      inst.scount =  inst.scount+ 1;/* line 446 */
      maybe_stringconcat ( eh, inst, msg)/* line 447 */}
    else if ( "2" ==  msg.port) {/* line 448 */
      inst.buffer2 = clone_string ( msg.datum.srepr ())/* line 449 */;
      inst.scount =  inst.scount+ 1;/* line 450 */
      maybe_stringconcat ( eh, inst, msg)/* line 451 */}
    else {                    /* line 452 */
      runtime_error ( `${ "bad msg.port for stringconcat: "}${ msg.port}` )/* line 453 *//* line 454 */}/* line 455 *//* line 456 */
}

function maybe_stringconcat (eh,inst,msg) {/* line 457 */
    if (((( 0 == ( inst.buffer1.length))) && (( 0 == ( inst.buffer2.length))))) {/* line 458 */
      runtime_error ( "something is wrong in stringconcat, both strings are 0 length")/* line 459 *//* line 460 */}
    if ( inst.scount >=  2) { /* line 461 */
      let  concatenated_string =  "";/* line 462 */
      if ( 0 == ( inst.buffer1.length)) {/* line 463 */
        concatenated_string =  inst.buffer2;/* line 464 */}
      else if ( 0 == ( inst.buffer2.length)) {/* line 465 */
        concatenated_string =  inst.buffer1;/* line 466 */}
      else {                  /* line 467 */
        concatenated_string =  inst.buffer1+ inst.buffer2;/* line 468 *//* line 469 */}
      send_string ( eh, "", concatenated_string, msg)/* line 470 */
      inst.buffer1 =  null;   /* line 471 */
      inst.buffer2 =  null;   /* line 472 */
      inst.scount =  0;       /* line 473 */}/* line 474 *//* line 475 */
}

/*  */                        /* line 476 *//* line 477 */
/*  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here *//* line 478 */
function shell_out_instantiate (reg,owner,name,template_data) {/* line 479 */
    let name_with_id = gensymbol ( "shell_out")/* line 480 */;
    let cmd =  template_data.split (" ")/* line 481 */;
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)/* line 482 */;/* line 483 *//* line 484 */
}

function shell_out_handler (eh,msg) {/* line 485 */
    let cmd =  eh.instance_data;/* line 486 */
    let s =  msg.datum.srepr ();/* line 487 */
    let  ret =  null;         /* line 488 */
    let  rc =  null;          /* line 489 */
    let  stdout =  null;      /* line 490 */
    let  stderr =  null;      /* line 491 */

    stdout = execSync(`${ cmd} ${ s}`, { encoding: 'utf-8' });
    ret = true;
                              /* line 492 */
    if ( rc!= 0) {            /* line 493 */
      send_string ( eh, "✗", stderr, msg)/* line 494 */}
    else {                    /* line 495 */
      send_string ( eh, "", stdout, msg)/* line 496 *//* line 497 */}/* line 498 *//* line 499 */
}

function string_constant_instantiate (reg,owner,name,template_data) {/* line 500 *//* line 501 *//* line 502 */
    let name_with_id = gensymbol ( "strconst")/* line 503 */;
    let  s =  template_data;  /* line 504 */
    if ( root_project!= "") { /* line 505 */
      s =  s.replaceAll ( "_00_",  root_project)/* line 506 */;/* line 507 */}
    if ( root_0D!= "") {      /* line 508 */
      s =  s.replaceAll ( "_0D_",  root_0D)/* line 509 */;/* line 510 */}
    return make_leaf ( name_with_id, owner, s, string_constant_handler)/* line 511 */;/* line 512 *//* line 513 */
}

function string_constant_handler (eh,msg) {/* line 514 */
    let s =  eh.instance_data;/* line 515 */
    send_string ( eh, "", s, msg)/* line 516 *//* line 517 *//* line 518 */
}

function string_make_persistent (s) {/* line 519 */
    /*  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python *//* line 520 */
    return  s;                /* line 521 *//* line 522 *//* line 523 */
}

function string_clone (s) {   /* line 524 */
    return  s;                /* line 525 *//* line 526 *//* line 527 */
}

/*  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... *//* line 528 */
/*  where ${_00_} is the root directory for the project *//* line 529 */
/*  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) *//* line 530 *//* line 531 */
function initialize_component_palette (root_project,root_0D,diagram_source_files) {/* line 532 */
    let  reg = make_component_registry ();/* line 533 */
    for (let diagram_source of  diagram_source_files) {/* line 534 */
      let all_containers_within_single_file = json2internal ( root_project, diagram_source)/* line 535 */;
      reg = generate_shell_components ( reg, all_containers_within_single_file)/* line 536 */;
      for (let container of  all_containers_within_single_file) {/* line 537 */
        register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 538 *//* line 539 */}/* line 540 */}
    initialize_stock_components ( reg)/* line 541 */
    return  reg;              /* line 542 *//* line 543 *//* line 544 */
}

function print_error_maybe (main_container) {/* line 545 */
    let error_port =  "✗";    /* line 546 */
    let err = fetch_first_output ( main_container, error_port)/* line 547 */;
    if (((( err!= null)) && (( 0 < (trimws ( err.srepr ()).length))))) {/* line 548 */
      console.log ( "___ !!! ERRORS !!! ___");/* line 549 */
      print_specific_output ( main_container, error_port)/* line 550 *//* line 551 */}/* line 552 *//* line 553 */
}

/*  debugging helpers */      /* line 554 *//* line 555 */
function nl () {              /* line 556 */
    console.log ( "");        /* line 557 *//* line 558 *//* line 559 */
}

function dump_outputs (main_container) {/* line 560 */
    nl ()                     /* line 561 */
    console.log ( "___ Outputs ___");/* line 562 */
    print_output_list ( main_container)/* line 563 *//* line 564 *//* line 565 */
}

function trimws (s) {         /* line 566 */
    /*  remove whitespace from front and back of string *//* line 567 */
    return  s.strip ();       /* line 568 *//* line 569 *//* line 570 */
}

function clone_string (s) {   /* line 571 */
    return  s                 /* line 572 *//* line 573 */;/* line 574 */
}

let  load_errors =  false;    /* line 575 */
let  runtime_errors =  false; /* line 576 *//* line 577 */
function load_error (s) {     /* line 578 *//* line 579 */
    console.log ( s);         /* line 580 */
    console.log ();           /* line 581 */
    load_errors =  true;      /* line 582 *//* line 583 *//* line 584 */
}

function runtime_error (s) {  /* line 585 *//* line 586 */
    console.log ( s);         /* line 587 */
    runtime_errors =  true;   /* line 588 *//* line 589 *//* line 590 */
}

function fakepipename_instantiate (reg,owner,name,template_data) {/* line 591 */
    let instance_name = gensymbol ( "fakepipe")/* line 592 */;
    return make_leaf ( instance_name, owner, null, fakepipename_handler)/* line 593 */;/* line 594 *//* line 595 */
}

let  rand =  0;               /* line 596 *//* line 597 */
function fakepipename_handler (eh,msg) {/* line 598 *//* line 599 */
    rand =  rand+ 1;
    /*  not very random, but good enough _ 'rand' must be unique within a single run *//* line 600 */
    send_string ( eh, "", `${ "/tmp/fakepipe"}${ rand}` , msg)/* line 601 *//* line 602 *//* line 603 */
}
                              /* line 604 */
/*  all of the the built_in leaves are listed here *//* line 605 */
/*  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project *//* line 606 *//* line 607 */
function initialize_stock_components (reg) {/* line 608 */
    register_component ( reg,mkTemplate ( "1then2", null, deracer_instantiate))/* line 609 */
    register_component ( reg,mkTemplate ( "?A", null, probeA_instantiate))/* line 610 */
    register_component ( reg,mkTemplate ( "?B", null, probeB_instantiate))/* line 611 */
    register_component ( reg,mkTemplate ( "?C", null, probeC_instantiate))/* line 612 */
    register_component ( reg,mkTemplate ( "trash", null, trash_instantiate))/* line 613 *//* line 614 */
    register_component ( reg,mkTemplate ( "Low Level Read Text File", null, low_level_read_text_file_instantiate))/* line 615 */
    register_component ( reg,mkTemplate ( "Ensure String Datum", null, ensure_string_datum_instantiate))/* line 616 *//* line 617 */
    register_component ( reg,mkTemplate ( "syncfilewrite", null, syncfilewrite_instantiate))/* line 618 */
    register_component ( reg,mkTemplate ( "stringconcat", null, stringconcat_instantiate))/* line 619 */
    /*  for fakepipe */       /* line 620 */
    register_component ( reg,mkTemplate ( "fakepipename", null, fakepipename_instantiate))/* line 621 *//* line 622 *//* line 623 */
}

function argv () {            /* line 624 */
    return  command_line_argv /* line 625 */;/* line 626 *//* line 627 */
}

function initialize () {      /* line 628 */
    let root_of_project =  command_line_argv[ 1] /* line 629 */;
    let root_of_0D =  command_line_argv[ 2] /* line 630 */;
    let arg =  command_line_argv[ 3] /* line 631 */;
    let main_container_name =  command_line_argv[ 4] /* line 632 */;
    let diagram_names =  command_line_argv.splice ( 5) /* line 633 */;
    let palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)/* line 634 */;
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]];/* line 635 *//* line 636 *//* line 637 */
}

function start (palette,env) {
    start_helper ( palette, env, false)/* line 638 */
}

function start_show_all (palette,env) {
    start_helper ( palette, env, true)/* line 639 */
}

function start_helper (palette,env,show_all_outputs) {/* line 640 */
    let root_of_project =  env [ 0];/* line 641 */
    let root_of_0D =  env [ 1];/* line 642 */
    let main_container_name =  env [ 2];/* line 643 */
    let diagram_names =  env [ 3];/* line 644 */
    let arg =  env [ 4];      /* line 645 */
    set_environment ( root_of_project, root_of_0D)/* line 646 */
    /*  get entrypoint container *//* line 647 */
    let  main_container = get_component_instance ( palette, main_container_name, null)/* line 648 */;
    if ( null ==  main_container) {/* line 649 */
      load_error ( `${ "Couldn't find container with page name /"}${ `${ main_container_name}${ `${ "/ in files "}${ `${`${ diagram_names}`}${ " (check tab names, or disable compression?)"}` }` }` }` )/* line 653 *//* line 654 */}
    if ((!  load_errors)) {   /* line 655 */
      let  marg = new_datum_string ( arg)/* line 656 */;
      let  msg = make_message ( "", marg)/* line 657 */;
      inject ( main_container, msg)/* line 658 */
      if ( show_all_outputs) {/* line 659 */
        dump_outputs ( main_container)/* line 660 */}
      else {                  /* line 661 */
        print_error_maybe ( main_container)/* line 662 */
        let outp = fetch_first_output ( main_container, "")/* line 663 */;
        if ( null ==  outp) { /* line 664 */
          console.log ( "(no outputs)");/* line 665 */}
        else {                /* line 666 */
          print_specific_output ( main_container, "")/* line 667 *//* line 668 */}/* line 669 */}
      if ( show_all_outputs) {/* line 670 */
        console.log ( "--- done ---");/* line 671 *//* line 672 */}/* line 673 */}/* line 674 *//* line 675 */
}
                              /* line 676 *//* line 677 */
/*  utility functions  */     /* line 678 */
function send_int (eh,port,i,causing_message) {/* line 679 */
    let datum = new_datum_string (`${ i}`)/* line 680 */;
    send ( eh, port, datum, causing_message)/* line 681 *//* line 682 *//* line 683 */
}

function send_bang (eh,port,causing_message) {/* line 684 */
    let datum = new_datum_bang ();/* line 685 */
    send ( eh, port, datum, causing_message)/* line 686 *//* line 687 */
}




