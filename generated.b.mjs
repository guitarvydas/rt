
                                                       /* line 1 *//* line 2 *//* line 3 */
class Component_Registry {
  constructor () {                                     /* line 4 */

    this.templates = {};                               /* line 5 *//* line 6 */
  }
}
                                                       /* line 7 */
class Template {
  constructor () {                                     /* line 8 */

    this.name =  null;                                 /* line 9 */
    this.template_data =  null;                        /* line 10 */
    this.instantiator =  null;                         /* line 11 *//* line 12 */
  }
}
                                                       /* line 13 */
function mkTemplate (name,template_data,instantiator) {/* line 14 */
    let  templ =  new Template ();                     /* line 15 */;
    templ.name =  name;                                /* line 16 */
    templ.template_data =  template_data;              /* line 17 */
    templ.instantiator =  instantiator;                /* line 18 */
    return  templ;                                     /* line 19 *//* line 20 *//* line 21 */
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

function json2internal (pathname,container_xml) {      /* line 26 */
    let fname =   container_xml                        /* line 27 */;
    let routings = read_and_convert_json_file ( pathname, fname)/* line 28 */;
    return  routings;                                  /* line 29 *//* line 30 *//* line 31 */
}

function delete_decls (d) {                            /* line 32 *//* line 33 *//* line 34 *//* line 35 */
}

function make_component_registry () {                  /* line 36 */
    return  new Component_Registry ();                 /* line 37 */;/* line 38 *//* line 39 */
}

function register_component (reg,template) {
    return abstracted_register_component ( reg, template, false);/* line 40 */
}

function register_component_allow_overwriting (reg,template) {
    return abstracted_register_component ( reg, template, true);/* line 41 *//* line 42 */
}

function abstracted_register_component (reg,template,ok_to_overwrite) {/* line 43 */
    let name = mangle_name ( template.name)            /* line 44 */;
    if ((((((( reg!= null) && ( name))) in ( reg.templates))) && ((!  ok_to_overwrite)))) {/* line 45 */
      load_error ( `${ "Component /"}${ `${ template.name}${ "/ already declared"}` }` )/* line 46 */
      return  reg;                                     /* line 47 */}
    else {                                             /* line 48 */
      reg.templates [name] =  template;                /* line 49 */
      return  reg;                                     /* line 50 *//* line 51 */}/* line 52 *//* line 53 */
}

function get_component_instance (reg,full_name,owner) {/* line 54 */
    let template_name = mangle_name ( full_name)       /* line 55 */;
    if ((( template_name) in ( reg.templates))) {      /* line 56 */
      let template =  reg.templates [template_name];   /* line 57 */
      if (( template ==  null)) {                      /* line 58 */
        load_error ( `${ "Registry Error (A): Can;t find component /"}${ `${ template_name}${ "/"}` }` )/* line 59 */
        return  null;                                  /* line 60 */}
      else {                                           /* line 61 */
        let owner_name =  "";                          /* line 62 */
        let instance_name =  template_name;            /* line 63 */
        if ( null!= owner) {                           /* line 64 */
          owner_name =  owner.name;                    /* line 65 */
          instance_name =  `${ owner_name}${ `${ "."}${ template_name}` }` /* line 66 */;}
        else {                                         /* line 67 */
          instance_name =  template_name;              /* line 68 *//* line 69 */}
        let instance =  template.instantiator ( reg, owner, instance_name, template.template_data)/* line 70 */;
        return  instance;                              /* line 71 *//* line 72 */}}
    else {                                             /* line 73 */
      load_error ( `${ "Registry Error (B): Can't find component /"}${ `${ template_name}${ "/"}` }` )/* line 74 */
      return  null;                                    /* line 75 *//* line 76 */}/* line 77 *//* line 78 */
}

function dump_registry (reg) {                         /* line 79 */
    nl ()                                              /* line 80 */
    console.log ( "*** PALETTE ***");                  /* line 81 */
    for (let c of  reg.templates) {                    /* line 82 */
      print ( c.name)                                  /* line 83 */}
    console.log ( "***************");                  /* line 84 */
    nl ()                                              /* line 85 *//* line 86 *//* line 87 */
}

function print_stats (reg) {                           /* line 88 */
    console.log ( `${ "registry statistics: "}${ reg.stats}` );/* line 89 *//* line 90 *//* line 91 */
}

function mangle_name (s) {                             /* line 92 */
    /*  trim name to remove code from Container component names _ deferred until later (or never) *//* line 93 */
    return  s;                                         /* line 94 *//* line 95 *//* line 96 */
}
                                                       /* line 97 */
/*  Data for an asyncronous component _ effectively, a function with input *//* line 98 */
/*  and output queues of messages. */                  /* line 99 */
/*  */                                                 /* line 100 */
/*  Components can either be a user_supplied function (“lea“), or a “container“ *//* line 101 */
/*  that routes messages to child components according to a list of connections *//* line 102 */
/*  that serve as a message routing table. */          /* line 103 */
/*  */                                                 /* line 104 */
/*  Child components themselves can be leaves or other containers. *//* line 105 */
/*  */                                                 /* line 106 */
/*  `handler` invokes the code that is attached to this component. *//* line 107 */
/*  */                                                 /* line 108 */
/*  `instance_data` is a pointer to instance data that the `leaf_handler` *//* line 109 */
/*  function may want whenever it is invoked again. */ /* line 110 */
/*  */                                                 /* line 111 *//* line 112 */
/*  Eh_States :: enum { idle, active } */              /* line 113 */
class Eh {
  constructor () {                                     /* line 114 */

    this.name =  "";                                   /* line 115 */
    this.inq =  []                                     /* line 116 */;
    this.outq =  []                                    /* line 117 */;
    this.owner =  null;                                /* line 118 */
    this.children = [];                                /* line 119 */
    this.visit_ordering =  []                          /* line 120 */;
    this.connections = [];                             /* line 121 */
    this.routings =  []                                /* line 122 */;
    this.handler =  null;                              /* line 123 */
    this.finject =  null;                              /* line 124 */
    this.instance_data =  null;                        /* line 125 */
    this.state =  "idle";                              /* line 126 *//*  bootstrap debugging *//* line 127 */
    this.kind =  null;/*  enum { container, leaf, } */ /* line 128 *//* line 129 */
  }
}
                                                       /* line 130 */
/*  Creates a component that acts as a container. It is the same as a `Eh` instance *//* line 131 */
/*  whose handler function is `container_handler`. */  /* line 132 */
function make_container (name,owner) {                 /* line 133 */
    let  eh =  new Eh ();                              /* line 134 */;
    eh.name =  name;                                   /* line 135 */
    eh.owner =  owner;                                 /* line 136 */
    eh.handler =  container_handler;                   /* line 137 */
    eh.finject =  container_injector;                  /* line 138 */
    eh.state =  "idle";                                /* line 139 */
    eh.kind =  "container";                            /* line 140 */
    return  eh;                                        /* line 141 *//* line 142 *//* line 143 */
}

/*  Creates a new leaf component out of a handler function, and a data parameter *//* line 144 */
/*  that will be passed back to your handler when called. *//* line 145 *//* line 146 */
function make_leaf (name,owner,instance_data,handler) {/* line 147 */
    let  eh =  new Eh ();                              /* line 148 */;
    eh.name =  `${ owner.name}${ `${ "."}${ name}` }`  /* line 149 */;
    eh.owner =  owner;                                 /* line 150 */
    eh.handler =  handler;                             /* line 151 */
    eh.instance_data =  instance_data;                 /* line 152 */
    eh.state =  "idle";                                /* line 153 */
    eh.kind =  "leaf";                                 /* line 154 */
    return  eh;                                        /* line 155 *//* line 156 *//* line 157 */
}

/*  Sends a message on the given `port` with `data`, placing it on the output *//* line 158 */
/*  of the given component. */                         /* line 159 *//* line 160 */
function send (eh,port,datum,causingMessage) {         /* line 161 */
    let msg = make_message ( port, datum)              /* line 162 */;
    put_output ( eh, msg)                              /* line 163 *//* line 164 *//* line 165 */
}

function send_string (eh,port,s,causingMessage) {      /* line 166 */
    let datum = new_datum_string ( s)                  /* line 167 */;
    let msg = make_message ( port, datum)              /* line 168 */;
    put_output ( eh, msg)                              /* line 169 *//* line 170 *//* line 171 */
}

function forward (eh,port,msg) {                       /* line 172 */
    let fwdmsg = make_message ( port, msg.datum)       /* line 173 */;
    put_output ( eh, fwdmsg)                           /* line 174 *//* line 175 *//* line 176 */
}

function inject (eh,msg) {                             /* line 177 */
    eh.finject ( eh, msg)                              /* line 178 *//* line 179 *//* line 180 */
}

/*  Returns a list of all output messages on a container. *//* line 181 */
/*  For testing / debugging purposes. */               /* line 182 *//* line 183 */
function output_list (eh) {                            /* line 184 */
    return  eh.outq;                                   /* line 185 *//* line 186 *//* line 187 */
}

/*  Utility for printing an array of messages. */      /* line 188 */
function print_output_list (eh) {                      /* line 189 */
    console.log ( "{");                                /* line 190 */
    for (let m of   eh.outq) {                         /* line 191 */
      console.log (format_message ( m));               /* line 192 *//* line 193 */}
    console.log ( "}");                                /* line 194 *//* line 195 *//* line 196 */
}

function spaces (n) {                                  /* line 197 */
    let  s =  "";                                      /* line 198 */
    for (let i of range( n)) {                         /* line 199 */
      s =  s+ " ";                                     /* line 200 */}
    return  s;                                         /* line 201 *//* line 202 *//* line 203 */
}

function set_active (eh) {                             /* line 204 */
    eh.state =  "active";                              /* line 205 *//* line 206 *//* line 207 */
}

function set_idle (eh) {                               /* line 208 */
    eh.state =  "idle";                                /* line 209 *//* line 210 *//* line 211 */
}

/*  Utility for printing a specific output message. */ /* line 212 *//* line 213 */
function fetch_first_output (eh,port) {                /* line 214 */
    for (let msg of   eh.outq) {                       /* line 215 */
      if (( msg.port ==  port)) {                      /* line 216 */
        return  msg.datum;}                            /* line 217 */}
    return  null;                                      /* line 218 *//* line 219 *//* line 220 */
}

function print_specific_output (eh,port) {             /* line 221 */
    /*  port ∷ “” */                                   /* line 222 */
    let  datum = fetch_first_output ( eh, port)        /* line 223 */;
    console.log ( datum.v);                            /* line 224 *//* line 225 */
}

function print_specific_output_to_stderr (eh,port) {   /* line 226 */
    /*  port ∷ “” */                                   /* line 227 */
    let  datum = fetch_first_output ( eh, port)        /* line 228 */;
    /*  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... *//* line 229 */
    console.error ( datum.v);                          /* line 230 *//* line 231 *//* line 232 */
}

function put_output (eh,msg) {                         /* line 233 */
    eh.outq.push ( msg)                                /* line 234 *//* line 235 *//* line 236 */
}

let  root_project =  "";                               /* line 237 */
let  root_0D =  "";                                    /* line 238 *//* line 239 */
function set_environment (rproject,r0D) {              /* line 240 *//* line 241 *//* line 242 */
    root_project =  rproject;                          /* line 243 */
    root_0D =  r0D;                                    /* line 244 *//* line 245 *//* line 246 */
}
                                                       /* line 247 */
function string_make_persistent (s) {                  /* line 248 */
    /*  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python *//* line 249 */
    return  s;                                         /* line 250 *//* line 251 *//* line 252 */
}

function string_clone (s) {                            /* line 253 */
    return  s;                                         /* line 254 *//* line 255 *//* line 256 */
}

/*  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... *//* line 257 */
/*  where ${_00_} is the root directory for the project *//* line 258 */
/*  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) *//* line 259 *//* line 260 */
function initialize_component_palette (root_project,root_0D,diagram_source_files) {/* line 261 */
    let  reg = make_component_registry ();             /* line 262 */
    for (let diagram_source of  diagram_source_files) {/* line 263 */
      let all_containers_within_single_file = json2internal ( root_project, diagram_source)/* line 264 */;
      reg = generate_shell_components ( reg, all_containers_within_single_file)/* line 265 */;
      for (let container of  all_containers_within_single_file) {/* line 266 */
        register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 267 *//* line 268 */}/* line 269 */}
    initialize_stock_components ( reg)                 /* line 270 */
    return  reg;                                       /* line 271 *//* line 272 *//* line 273 */
}

function print_error_maybe (main_container) {          /* line 274 */
    let error_port =  "✗";                             /* line 275 */
    let err = fetch_first_output ( main_container, error_port)/* line 276 */;
    if (((( err!= null)) && (( 0 < (trimws ( err.v).length))))) {/* line 277 */
      console.log ( "___ !!! ERRORS !!! ___");         /* line 278 */
      print_specific_output ( main_container, error_port)/* line 279 *//* line 280 */}/* line 281 *//* line 282 */
}

/*  debugging helpers */                               /* line 283 *//* line 284 */
function nl () {                                       /* line 285 */
    console.log ( "");                                 /* line 286 *//* line 287 *//* line 288 */
}

function dump_outputs (main_container) {               /* line 289 */
    nl ()                                              /* line 290 */
    console.log ( "___ Outputs ___");                  /* line 291 */
    print_output_list ( main_container)                /* line 292 *//* line 293 *//* line 294 */
}

function trimws (s) {                                  /* line 295 */
    /*  remove whitespace from front and back of string *//* line 296 */
    return  s.strip ();                                /* line 297 *//* line 298 *//* line 299 */
}

function clone_string (s) {                            /* line 300 */
    return  s                                          /* line 301 *//* line 302 */;/* line 303 */
}

let  load_errors =  false;                             /* line 304 */
let  runtime_errors =  false;                          /* line 305 *//* line 306 */
function load_error (s) {                              /* line 307 *//* line 308 */
    console.log ( s);                                  /* line 309 */
    console.log ();                                    /* line 310 */
    load_errors =  true;                               /* line 311 *//* line 312 *//* line 313 */
}

function runtime_error (s) {                           /* line 314 *//* line 315 */
    console.log ( s);                                  /* line 316 */
    runtime_errors =  true;                            /* line 317 *//* line 318 *//* line 319 */
}

function fakepipename_instantiate (reg,owner,name,template_data) {/* line 320 */
    let instance_name = gensymbol ( "fakepipe")        /* line 321 */;
    return make_leaf ( instance_name, owner, null, fakepipename_handler)/* line 322 */;/* line 323 *//* line 324 */
}

let  rand =  0;                                        /* line 325 *//* line 326 */
function fakepipename_handler (eh,msg) {               /* line 327 *//* line 328 */
    rand =  rand+ 1;
    /*  not very random, but good enough _ 'rand' must be unique within a single run *//* line 329 */
    send_string ( eh, "", `${ "/tmp/fakepipe"}${ rand}` , msg)/* line 330 *//* line 331 *//* line 332 */
}
                                                       /* line 333 */
class Switch1star_Instance_Data {
  constructor () {                                     /* line 334 */

    this.state =  "1";                                 /* line 335 *//* line 336 */
  }
}
                                                       /* line 337 */
function switch1star_instantiate (reg,owner,name,template_data) {/* line 338 */
    let name_with_id = gensymbol ( "switch1*")         /* line 339 */;
    let instp =  new Switch1star_Instance_Data ();     /* line 340 */;
    return make_leaf ( name_with_id, owner, instp, switch1star_handler)/* line 341 */;/* line 342 *//* line 343 */
}

function switch1star_handler (eh,msg) {                /* line 344 */
    let  inst =  eh.instance_data;                     /* line 345 */
    let whichOutput =  inst.state;                     /* line 346 */
    if ( "" ==  msg.port) {                            /* line 347 */
      if ( "1" ==  whichOutput) {                      /* line 348 */
        forward ( eh, "1", msg)                        /* line 349 */
        inst.state =  "*";                             /* line 350 */}
      else if ( "*" ==  whichOutput) {                 /* line 351 */
        forward ( eh, "*", msg)                        /* line 352 */}
      else {                                           /* line 353 */
        send ( eh, "✗", "internal error bad state in switch1*", msg)/* line 354 *//* line 355 */}}
    else if ( "reset" ==  msg.port) {                  /* line 356 */
      inst.state =  "1";                               /* line 357 */}
    else {                                             /* line 358 */
      send ( eh, "✗", "internal error bad message for switch1*", msg)/* line 359 *//* line 360 */}/* line 361 *//* line 362 */
}

class Latch_Instance_Data {
  constructor () {                                     /* line 363 */

    this.datum =  null;                                /* line 364 *//* line 365 */
  }
}
                                                       /* line 366 */
function latch_instantiate (reg,owner,name,template_data) {/* line 367 */
    let name_with_id = gensymbol ( "latch")            /* line 368 */;
    let instp =  new Latch_Instance_Data ();           /* line 369 */;
    return make_leaf ( name_with_id, owner, instp, latch_handler)/* line 370 */;/* line 371 *//* line 372 */
}

function latch_handler (eh,msg) {                      /* line 373 */
    let  inst =  eh.instance_data;                     /* line 374 */
    if ( "" ==  msg.port) {                            /* line 375 */
      inst.datum =  msg.datum;                         /* line 376 */}
    else if ( "release" ==  msg.port) {                /* line 377 */
      let  d =  inst.datum;                            /* line 378 */
      send ( eh, "", d, msg)                           /* line 379 */
      inst.datum =  null;                              /* line 380 */}
    else {                                             /* line 381 */
      send ( eh, "✗", "internal error bad message for latch", msg)/* line 382 *//* line 383 */}/* line 384 *//* line 385 */
}

/*  all of the the built_in leaves are listed here */  /* line 386 */
/*  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project *//* line 387 *//* line 388 */
function initialize_stock_components (reg) {           /* line 389 */
    register_component ( reg,mkTemplate ( "1then2", null, deracer_instantiate))/* line 390 */
    register_component ( reg,mkTemplate ( "?A", null, probeA_instantiate))/* line 391 */
    register_component ( reg,mkTemplate ( "?B", null, probeB_instantiate))/* line 392 */
    register_component ( reg,mkTemplate ( "?C", null, probeC_instantiate))/* line 393 */
    register_component ( reg,mkTemplate ( "trash", null, trash_instantiate))/* line 394 *//* line 395 */
    register_component ( reg,mkTemplate ( "Low Level Read Text File", null, low_level_read_text_file_instantiate))/* line 396 */
    register_component ( reg,mkTemplate ( "Ensure String Datum", null, ensure_string_datum_instantiate))/* line 397 *//* line 398 */
    register_component ( reg,mkTemplate ( "syncfilewrite", null, syncfilewrite_instantiate))/* line 399 */
    register_component ( reg,mkTemplate ( "stringconcat", null, stringconcat_instantiate))/* line 400 */
    register_component ( reg,mkTemplate ( "switch1*", null, switch1star_instantiate))/* line 401 */
    register_component ( reg,mkTemplate ( "latch", null, latch_instantiate))/* line 402 */
    /*  for fakepipe */                                /* line 403 */
    register_component ( reg,mkTemplate ( "fakepipename", null, fakepipename_instantiate))/* line 404 *//* line 405 *//* line 406 */
}

function argv () {                                     /* line 407 */
    return  command_line_argv                          /* line 408 */;/* line 409 *//* line 410 */
}

function initialize () {                               /* line 411 */
    let root_of_project =  command_line_argv[ 1]       /* line 412 */;
    let root_of_0D =  command_line_argv[ 2]            /* line 413 */;
    let arg =  command_line_argv[ 3]                   /* line 414 */;
    let main_container_name =  command_line_argv[ 4]   /* line 415 */;
    let diagram_names =  command_line_argv.splice ( 5) /* line 416 */;
    let palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)/* line 417 */;
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]];/* line 418 *//* line 419 *//* line 420 */
}

function start (palette,env) {
    start_helper ( palette, env, false)                /* line 421 */
}

function start_show_all (palette,env) {
    start_helper ( palette, env, true)                 /* line 422 */
}

function start_helper (palette,env,show_all_outputs) { /* line 423 */
    let root_of_project =  env [ 0];                   /* line 424 */
    let root_of_0D =  env [ 1];                        /* line 425 */
    let main_container_name =  env [ 2];               /* line 426 */
    let diagram_names =  env [ 3];                     /* line 427 */
    let arg =  env [ 4];                               /* line 428 */
    set_environment ( root_of_project, root_of_0D)     /* line 429 */
    /*  get entrypoint container */                    /* line 430 */
    let  main_container = get_component_instance ( palette, main_container_name, null)/* line 431 */;
    if ( null ==  main_container) {                    /* line 432 */
      load_error ( `${ "Couldn't find container with page name /"}${ `${ main_container_name}${ `${ "/ in files "}${ `${`${ diagram_names}`}${ " (check tab names, or disable compression?)"}` }` }` }` )/* line 436 *//* line 437 */}
    if ((!  load_errors)) {                            /* line 438 */
      let  marg = new_datum_string ( arg)              /* line 439 */;
      let  msg = make_message ( "", marg)              /* line 440 */;
      inject ( main_container, msg)                    /* line 441 */
      if ( show_all_outputs) {                         /* line 442 */
        dump_outputs ( main_container)                 /* line 443 */}
      else {                                           /* line 444 */
        print_error_maybe ( main_container)            /* line 445 */
        let outp = fetch_first_output ( main_container, "")/* line 446 */;
        if ( null ==  outp) {                          /* line 447 */
          console.log ( "«««no outputs»»»)");          /* line 448 */}
        else {                                         /* line 449 */
          print_specific_output ( main_container, "")  /* line 450 *//* line 451 */}/* line 452 */}
      if ( show_all_outputs) {                         /* line 453 */
        console.log ( "--- done ---");                 /* line 454 *//* line 455 */}/* line 456 */}/* line 457 *//* line 458 */
}
                                                       /* line 459 */
/*  utility functions  */                              /* line 460 */
function send_int (eh,port,i,causing_message) {        /* line 461 */
    let datum = new_datum_string (`${ i}`)             /* line 462 */;
    send ( eh, port, datum, causing_message)           /* line 463 *//* line 464 *//* line 465 */
}

function send_bang (eh,port,causing_message) {         /* line 466 */
    let datum = new_datum_bang ();                     /* line 467 */
    send ( eh, port, datum, causing_message)           /* line 468 *//* line 469 */
}





