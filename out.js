import * as fs from 'fs';
import path from 'path';
import execSync from 'child_process';
                                                       /* line 1 *//* line 2 */
let  counter =  0;                                     /* line 3 */
let  ticktime =  0;                                    /* line 4 *//* line 5 */
let  digits = [ "₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀", "₂₁", "₂₂", "₂₃", "₂₄", "₂₅", "₂₆", "₂₇", "₂₈", "₂₉"];/* line 12 *//* line 13 *//* line 14 */
function gensymbol (s) {                               /* line 15 *//* line 16 */
    let name_with_id =  ( s.toString ()+ subscripted_digit ( counter).toString ()) /* line 17 */;
    counter =  counter+ 1;                             /* line 18 */
    return  name_with_id;                              /* line 19 *//* line 20 *//* line 21 */
}

function subscripted_digit (n) {                       /* line 22 *//* line 23 */
    if (((( n >=  0) && ( n <=  29)))) {               /* line 24 */
      return  digits [ n];                             /* line 25 */
    }
    else {                                             /* line 26 */
      return  ( "₊".toString ()+ `${ n}`.toString ())  /* line 27 */;/* line 28 */
    }                                                  /* line 29 *//* line 30 */
}

class Datum {
  constructor () {                                     /* line 31 */

    this.v =  null;                                    /* line 32 */
    this.clone =  null;                                /* line 33 */
    this.reclaim =  null;                              /* line 34 */
    this.other =  null;/*  reserved for use on per-project basis  *//* line 35 *//* line 36 */
  }
}
                                                       /* line 37 *//* line 38 */
/*  Mevent passed to a leaf component. */              /* line 39 */
/*  */                                                 /* line 40 */
/*  `port` refers to the name of the incoming or outgoing port of this component. *//* line 41 */
/*  `payload` is the data attached to this mevent. */  /* line 42 */
class Mevent {
  constructor () {                                     /* line 43 */

    this.port =  null;                                 /* line 44 */
    this.datum =  null;                                /* line 45 *//* line 46 */
  }
}
                                                       /* line 47 */
function clone_port (s) {                              /* line 48 */
    return clone_string ( s)                           /* line 49 */;/* line 50 *//* line 51 */
}

/*  Utility for making a `Mevent`. Used to safely "seed“ mevents *//* line 52 */
/*  entering the very top of a network. */             /* line 53 */
function make_mevent (port,datum) {                    /* line 54 */
    let p = clone_string ( port)                       /* line 55 */;
    let  m =  new Mevent ();                           /* line 56 */;
    m.port =  p;                                       /* line 57 */
    m.datum =  datum.clone ();                         /* line 58 */
    return  m;                                         /* line 59 *//* line 60 *//* line 61 */
}

/*  Clones a mevent. Primarily used internally for “fanning out“ a mevent to multiple destinations. *//* line 62 */
function mevent_clone (mev) {                          /* line 63 */
    let  m =  new Mevent ();                           /* line 64 */;
    m.port = clone_port ( mev.port)                    /* line 65 */;
    m.datum =  mev.datum.clone ();                     /* line 66 */
    return  m;                                         /* line 67 *//* line 68 *//* line 69 */
}

/*  Frees a mevent. */                                 /* line 70 */
function destroy_mevent (mev) {                        /* line 71 */
    /*  during debug, dont destroy any mevent, since we want to trace mevents, thus, we need to persist ancestor mevents *//* line 72 *//* line 73 *//* line 74 *//* line 75 */
}

function destroy_datum (mev) {                         /* line 76 *//* line 77 *//* line 78 *//* line 79 */
}

function destroy_port (mev) {                          /* line 80 *//* line 81 *//* line 82 *//* line 83 */
}

/*  */                                                 /* line 84 */
function format_mevent (m) {                           /* line 85 */
    if ( m ==  null) {                                 /* line 86 */
      return  "{}";                                    /* line 87 */
    }
    else {                                             /* line 88 */
      return  ( "{%5C”".toString ()+  ( m.port.toString ()+  ( "%5C”:%5C”".toString ()+  ( m.datum.v.toString ()+  "%5C”}".toString ()) .toString ()) .toString ()) .toString ()) /* line 89 */;/* line 90 */
    }                                                  /* line 91 */
}

function format_mevent_raw (m) {                       /* line 92 */
    if ( m ==  null) {                                 /* line 93 */
      return  "";                                      /* line 94 */
    }
    else {                                             /* line 95 */
      return  m.datum.v;                               /* line 96 *//* line 97 */
    }                                                  /* line 98 *//* line 99 */
}

const  enumDown =  0                                   /* line 100 */;
const  enumAcross =  1                                 /* line 101 */;
const  enumUp =  2                                     /* line 102 */;
const  enumThrough =  3                                /* line 103 */;/* line 104 */
function create_down_connector (container,proto_conn,connectors,children_by_id) {/* line 105 */
    /*  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, *//* line 106 */
    let  connector =  new Connector ();                /* line 107 */;
    connector.direction =  "down";                     /* line 108 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 109 */;
    let target_proto =  proto_conn [ "target"];        /* line 110 */
    let id_proto =  target_proto [ "id"];              /* line 111 */
    let target_component =  children_by_id [id_proto]; /* line 112 */
    if (( target_component ==  null)) {                /* line 113 */
      load_error ( ( "internal error: .Down connection target internal error ".toString ()+ ( proto_conn [ "target"]) [ "name"].toString ()) )/* line 114 */
    }
    else {                                             /* line 115 */
      connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 116 */;/* line 117 */
    }
    return  connector;                                 /* line 118 *//* line 119 *//* line 120 */
}

function create_across_connector (container,proto_conn,connectors,children_by_id) {/* line 121 */
    let  connector =  new Connector ();                /* line 122 */;
    connector.direction =  "across";                   /* line 123 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 124 */
    let target_component =  children_by_id [(( proto_conn [ "target"]) [ "id"])];/* line 125 */
    if ( source_component ==  null) {                  /* line 126 */
      load_error ( ( "internal error: .Across connection source not ok ".toString ()+ ( proto_conn [ "source"]) [ "name"].toString ()) )/* line 127 */
    }
    else {                                             /* line 128 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 129 */;
      if ( target_component ==  null) {                /* line 130 */
        load_error ( ( "internal error: .Across connection target not ok ".toString ()+ ( proto_conn [ "target"]) [ "name"].toString ()) )/* line 131 */
      }
      else {                                           /* line 132 */
        connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 133 */;/* line 134 */
      }                                                /* line 135 */
    }
    return  connector;                                 /* line 136 *//* line 137 *//* line 138 */
}

function create_up_connector (container,proto_conn,connectors,children_by_id) {/* line 139 */
    let  connector =  new Connector ();                /* line 140 */;
    connector.direction =  "up";                       /* line 141 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 142 */
    if ( source_component ==  null) {                  /* line 143 */
      load_error ( ( "internal error: .Up connection source not ok ".toString ()+ ( proto_conn [ "source"]) [ "name"].toString ()) )/* line 144 */
    }
    else {                                             /* line 145 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 146 */;
      connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 147 */;/* line 148 */
    }
    return  connector;                                 /* line 149 *//* line 150 *//* line 151 */
}

function create_through_connector (container,proto_conn,connectors,children_by_id) {/* line 152 */
    let  connector =  new Connector ();                /* line 153 */;
    connector.direction =  "through";                  /* line 154 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 155 */;
    connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 156 */;
    return  connector;                                 /* line 157 *//* line 158 *//* line 159 */
}
                                                       /* line 160 */
function container_instantiator (reg,owner,container_name,desc) {/* line 161 *//* line 162 */
    let container = make_container ( container_name, owner)/* line 163 */;
    let children = [];                                 /* line 164 */
    let children_by_id = {};
    /*  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here *//* line 165 */
    /*  collect children */                            /* line 166 */
    for (let child_desc of  desc [ "children"]) {      /* line 167 */
      let child_instance = get_component_instance ( reg, child_desc [ "name"], container)/* line 168 */;
      children.push ( child_instance)                  /* line 169 */
      let id =  child_desc [ "id"];                    /* line 170 */
      children_by_id [id] =  child_instance;           /* line 171 *//* line 172 *//* line 173 */
    }
    container.children =  children;                    /* line 174 *//* line 175 */
    let connectors = [];                               /* line 176 */
    for (let proto_conn of  desc [ "connections"]) {   /* line 177 */
      let  connector =  new Connector ();              /* line 178 */;
      if ( proto_conn [ "dir"] ==  enumDown) {         /* line 179 */
        connectors.push (create_down_connector ( container, proto_conn, connectors, children_by_id)) /* line 180 */
      }
      else if ( proto_conn [ "dir"] ==  enumAcross) {  /* line 181 */
        connectors.push (create_across_connector ( container, proto_conn, connectors, children_by_id)) /* line 182 */
      }
      else if ( proto_conn [ "dir"] ==  enumUp) {      /* line 183 */
        connectors.push (create_up_connector ( container, proto_conn, connectors, children_by_id)) /* line 184 */
      }
      else if ( proto_conn [ "dir"] ==  enumThrough) { /* line 185 */
        connectors.push (create_through_connector ( container, proto_conn, connectors, children_by_id)) /* line 186 *//* line 187 */
      }                                                /* line 188 */
    }
    container.connections =  connectors;               /* line 189 */
    return  container;                                 /* line 190 *//* line 191 *//* line 192 */
}

/*  The default handler for container components. */   /* line 193 */
function container_handler (container,mevent) {        /* line 194 */
    route ( container, container, mevent)
    /*  references to 'self' are replaced by the container during instantiation *//* line 195 */
    while (any_child_ready ( container)) {             /* line 196 */
      step_children ( container, mevent)               /* line 197 */
    }                                                  /* line 198 *//* line 199 */
}

/*  Frees the given container and associated data. */  /* line 200 */
function destroy_container (eh) {                      /* line 201 *//* line 202 *//* line 203 *//* line 204 */
}

/*  Routing connection for a container component. The `direction` field has *//* line 205 */
/*  no affect on the default mevent routing system _ it is there for debugging *//* line 206 */
/*  purposes, or for reading by other tools. */        /* line 207 *//* line 208 */
class Connector {
  constructor () {                                     /* line 209 */

    this.direction =  null;/*  down, across, up, through *//* line 210 */
    this.sender =  null;                               /* line 211 */
    this.receiver =  null;                             /* line 212 *//* line 213 */
  }
}
                                                       /* line 214 */
/*  `Sender` is used to “pattern match“ which `Receiver` a mevent should go to, *//* line 215 */
/*  based on component ID (pointer) and port name. */  /* line 216 *//* line 217 */
class Sender {
  constructor () {                                     /* line 218 */

    this.name =  null;                                 /* line 219 */
    this.component =  null;                            /* line 220 */
    this.port =  null;                                 /* line 221 *//* line 222 */
  }
}
                                                       /* line 223 *//* line 224 *//* line 225 */
/*  `Receiver` is a handle to a destination queue, and a `port` name to assign *//* line 226 */
/*  to incoming mevents to this queue. */              /* line 227 *//* line 228 */
class Receiver {
  constructor () {                                     /* line 229 */

    this.name =  null;                                 /* line 230 */
    this.queue =  null;                                /* line 231 */
    this.port =  null;                                 /* line 232 */
    this.component =  null;                            /* line 233 *//* line 234 */
  }
}
                                                       /* line 235 */
function mkSender (name,component,port) {              /* line 236 */
    let  s =  new Sender ();                           /* line 237 */;
    s.name =  name;                                    /* line 238 */
    s.component =  component;                          /* line 239 */
    s.port =  port;                                    /* line 240 */
    return  s;                                         /* line 241 *//* line 242 *//* line 243 */
}

function mkReceiver (name,component,port,q) {          /* line 244 */
    let  r =  new Receiver ();                         /* line 245 */;
    r.name =  name;                                    /* line 246 */
    r.component =  component;                          /* line 247 */
    r.port =  port;                                    /* line 248 */
    /*  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. *//* line 249 */
    r.queue =  q;                                      /* line 250 */
    return  r;                                         /* line 251 *//* line 252 *//* line 253 */
}

/*  Checks if two senders match, by pointer equality and port name matching. *//* line 254 */
function sender_eq (s1,s2) {                           /* line 255 */
    let same_components = ( s1.component ==  s2.component);/* line 256 */
    let same_ports = ( s1.port ==  s2.port);           /* line 257 */
    return (( same_components) && ( same_ports));      /* line 258 *//* line 259 *//* line 260 */
}

/*  Delivers the given mevent to the receiver of this connector. *//* line 261 *//* line 262 */
function deposit (parent,conn,mevent) {                /* line 263 */
    let new_mevent = make_mevent ( conn.receiver.port, mevent.datum)/* line 264 */;
    push_mevent ( parent, conn.receiver.component, conn.receiver.queue, new_mevent)/* line 265 *//* line 266 *//* line 267 */
}

function force_tick (parent,eh) {                      /* line 268 */
    let tick_mev = make_mevent ( ".",new_datum_bang ())/* line 269 */;
    push_mevent ( parent, eh, eh.inq, tick_mev)        /* line 270 */
    return  tick_mev;                                  /* line 271 *//* line 272 *//* line 273 */
}

function push_mevent (parent,receiver,inq,m) {         /* line 274 */
    inq.push ( m)                                      /* line 275 */
    parent.visit_ordering.push ( receiver)             /* line 276 *//* line 277 *//* line 278 */
}

function is_self (child,container) {                   /* line 279 */
    /*  in an earlier version “self“ was denoted as ϕ *//* line 280 */
    return  child ==  container;                       /* line 281 *//* line 282 *//* line 283 */
}

function step_child (child,mev) {                      /* line 284 */
    let before_state =  child.state;                   /* line 285 */
    child.handler ( child, mev)                        /* line 286 */
    let after_state =  child.state;                    /* line 287 */
    return [(( before_state ==  "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state ==  "idle"))];/* line 290 *//* line 291 *//* line 292 */
}

function step_children (container,causingMevent) {     /* line 293 */
    container.state =  "idle";                         /* line 294 */
    for (let child of   container.visit_ordering) {    /* line 295 */
      /*  child = container represents self, skip it *//* line 296 */
      if (((! (is_self ( child, container))))) {       /* line 297 */
        if (((! ((0=== child.inq.length))))) {         /* line 298 */
          let mev =  child.inq.shift ()                /* line 299 */;
          let  began_long_run =  null;                 /* line 300 */
          let  continued_long_run =  null;             /* line 301 */
          let  ended_long_run =  null;                 /* line 302 */
          [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, mev)/* line 303 */;
          if ( began_long_run) {                       /* line 304 *//* line 305 */
          }
          else if ( continued_long_run) {              /* line 306 *//* line 307 */
          }
          else if ( ended_long_run) {                  /* line 308 *//* line 309 *//* line 310 */
          }
          destroy_mevent ( mev)                        /* line 311 */
        }
        else {                                         /* line 312 */
          if ( child.state!= "idle") {                 /* line 313 */
            let mev = force_tick ( container, child)   /* line 314 */;
            child.handler ( child, mev)                /* line 315 */
            destroy_mevent ( mev)                      /* line 316 *//* line 317 */
          }                                            /* line 318 */
        }                                              /* line 319 */
        if ( child.state ==  "active") {               /* line 320 */
          /*  if child remains active, then the container must remain active and must propagate “ticks“ to child *//* line 321 */
          container.state =  "active";                 /* line 322 *//* line 323 */
        }                                              /* line 324 */
        while (((! ((0=== child.outq.length))))) {     /* line 325 */
          let mev =  child.outq.shift ()               /* line 326 */;
          route ( container, child, mev)               /* line 327 */
          destroy_mevent ( mev)                        /* line 328 *//* line 329 */
        }                                              /* line 330 */
      }                                                /* line 331 */
    }                                                  /* line 332 *//* line 333 */
}

function attempt_tick (parent,eh) {                    /* line 334 */
    if ( eh.state!= "idle") {                          /* line 335 */
      force_tick ( parent, eh)                         /* line 336 *//* line 337 */
    }                                                  /* line 338 *//* line 339 */
}

function is_tick (mev) {                               /* line 340 */
    return  "." ==  mev.port
    /*  assume that any mevent that is sent to port "." is a tick  *//* line 341 */;/* line 342 *//* line 343 */
}

/*  Routes a single mevent to all matching destinations, according to *//* line 344 */
/*  the container's connection network. */             /* line 345 *//* line 346 */
function route (container,from_component,mevent) {     /* line 347 */
    let  was_sent =  false;
    /*  for checking that output went somewhere (at least during bootstrap) *//* line 348 */
    let  fromname =  "";                               /* line 349 *//* line 350 */
    ticktime =  ticktime+ 1;                           /* line 351 */
    if (is_tick ( mevent)) {                           /* line 352 */
      for (let child of  container.children) {         /* line 353 */
        attempt_tick ( container, child)               /* line 354 */
      }
      was_sent =  true;                                /* line 355 */
    }
    else {                                             /* line 356 */
      if (((! (is_self ( from_component, container))))) {/* line 357 */
        fromname =  from_component.name;               /* line 358 *//* line 359 */
      }
      let from_sender = mkSender ( fromname, from_component, mevent.port)/* line 360 */;/* line 361 */
      for (let connector of  container.connections) {  /* line 362 */
        if (sender_eq ( from_sender, connector.sender)) {/* line 363 */
          deposit ( container, connector, mevent)      /* line 364 */
          was_sent =  true;                            /* line 365 *//* line 366 */
        }                                              /* line 367 */
      }                                                /* line 368 */
    }
    if ((! ( was_sent))) {                             /* line 369 */
      live_update ( "✗",  ( container.name.toString ()+  ( ": mevent '".toString ()+  ( mevent.port.toString ()+  ( "' from ".toString ()+  ( fromname.toString ()+  " dropped on floor...".toString ()) .toString ()) .toString ()) .toString ()) .toString ()) )/* line 370 *//* line 371 */
    }                                                  /* line 372 *//* line 373 */
}

function any_child_ready (container) {                 /* line 374 */
    for (let child of  container.children) {           /* line 375 */
      if (child_is_ready ( child)) {                   /* line 376 */
        return  true;                                  /* line 377 *//* line 378 */
      }                                                /* line 379 */
    }
    return  false;                                     /* line 380 *//* line 381 *//* line 382 */
}

function child_is_ready (eh) {                         /* line 383 */
    return ((((((((! ((0=== eh.outq.length))))) || (((! ((0=== eh.inq.length))))))) || (( eh.state!= "idle")))) || ((any_child_ready ( eh))));/* line 384 *//* line 385 *//* line 386 */
}

function append_routing_descriptor (container,desc) {  /* line 387 */
    container.routings.push ( desc)                    /* line 388 *//* line 389 *//* line 390 */
}

function injector (eh,mevent) {                        /* line 391 */
    eh.handler ( eh, mevent)                           /* line 392 *//* line 393 *//* line 394 */
}
                                                       /* line 395 *//* line 396 *//* line 397 */
class Component_Registry {
  constructor () {                                     /* line 398 */

    this.templates = {};                               /* line 399 *//* line 400 */
  }
}
                                                       /* line 401 */
class Template {
  constructor () {                                     /* line 402 */

    this.name =  null;                                 /* line 403 */
    this.template_data =  null;                        /* line 404 */
    this.instantiator =  null;                         /* line 405 *//* line 406 */
  }
}
                                                       /* line 407 */
function mkTemplate (name,template_data,instantiator) {/* line 408 */
    let  templ =  new Template ();                     /* line 409 */;
    templ.name =  name;                                /* line 410 */
    templ.template_data =  template_data;              /* line 411 */
    templ.instantiator =  instantiator;                /* line 412 */
    return  templ;                                     /* line 413 *//* line 414 *//* line 415 */
}
                                                       /* line 416 */
function lnet2internal_from_file (pathname,container_xml) {/* line 417 */
    let filename =   container_xml                     /* line 418 */;

    let jstr = undefined;
    if (filename == "0") {
    jstr = fs.readFileSync (0, { encoding: 'utf8'});
    } else if (pathname) {
    jstr = fs.readFileSync (`${pathname}/${filename}`, { encoding: 'utf8'});
    } else {
    jstr = fs.readFileSync (`${filename}`, { encoding: 'utf8'});
    }
    if (jstr) {
    return JSON.parse (jstr);
    } else {
    return undefined;
    }
                                                       /* line 419 *//* line 420 *//* line 421 */
}

function lnet2internal_from_string () {                /* line 422 */

    return JSON.parse (lnet);
                                                       /* line 423 *//* line 424 *//* line 425 */
}

function delete_decls (d) {                            /* line 426 *//* line 427 *//* line 428 *//* line 429 */
}

function make_component_registry () {                  /* line 430 */
    return  new Component_Registry ();                 /* line 431 */;/* line 432 *//* line 433 */
}

function register_component (reg,template) {
    return abstracted_register_component ( reg, template, false);/* line 434 */
}

function register_component_allow_overwriting (reg,template) {
    return abstracted_register_component ( reg, template, true);/* line 435 *//* line 436 */
}

function abstracted_register_component (reg,template,ok_to_overwrite) {/* line 437 */
    let name = mangle_name ( template.name)            /* line 438 */;
    if ((((((( reg!= null) && ( name))) in ( reg.templates))) && ((!  ok_to_overwrite)))) {/* line 439 */
      load_error ( ( "Component /".toString ()+  ( template.name.toString ()+  "/ already declared".toString ()) .toString ()) )/* line 440 */
      return  reg;                                     /* line 441 */
    }
    else {                                             /* line 442 */
      reg.templates [name] =  template;                /* line 443 */
      return  reg;                                     /* line 444 *//* line 445 */
    }                                                  /* line 446 *//* line 447 */
}

function get_component_instance (reg,full_name,owner) {/* line 448 */
    let template_name = mangle_name ( full_name)       /* line 449 */;
    if ((( template_name) in ( reg.templates))) {      /* line 450 */
      let template =  reg.templates [template_name];   /* line 451 */
      if (( template ==  null)) {                      /* line 452 */
        load_error ( ( "Registry Error (A): Can't find component /".toString ()+  ( template_name.toString ()+  "/".toString ()) .toString ()) )/* line 453 */
        return  null;                                  /* line 454 */
      }
      else {                                           /* line 455 */
        let owner_name =  "";                          /* line 456 */
        let instance_name =  template_name;            /* line 457 */
        if ( null!= owner) {                           /* line 458 */
          owner_name =  owner.name;                    /* line 459 */
          instance_name =  ( owner_name.toString ()+  ( "▹".toString ()+  template_name.toString ()) .toString ()) /* line 460 */;
        }
        else {                                         /* line 461 */
          instance_name =  template_name;              /* line 462 *//* line 463 */
        }
        let instance =  template.instantiator ( reg, owner, instance_name, template.template_data)/* line 464 */;
        return  instance;                              /* line 465 *//* line 466 */
      }
    }
    else {                                             /* line 467 */
      load_error ( ( "Registry Error (B): Can't find component /".toString ()+  ( template_name.toString ()+  "/".toString ()) .toString ()) )/* line 468 */
      return  null;                                    /* line 469 *//* line 470 */
    }                                                  /* line 471 *//* line 472 */
}

function mangle_name (s) {                             /* line 473 */
    /*  trim name to remove code from Container component names _ deferred until later (or never) *//* line 474 */
    return  s;                                         /* line 475 *//* line 476 *//* line 477 */
}
                                                       /* line 478 */
/*  Data for an asyncronous component _ effectively, a function with input *//* line 479 */
/*  and output queues of mevents. */                   /* line 480 */
/*  */                                                 /* line 481 */
/*  Components can either be a user_supplied function (“lea“), or a “container“ *//* line 482 */
/*  that routes mevents to child components according to a list of connections *//* line 483 */
/*  that serve as a mevent routing table. */           /* line 484 */
/*  */                                                 /* line 485 */
/*  Child components themselves can be leaves or other containers. *//* line 486 */
/*  */                                                 /* line 487 */
/*  `handler` invokes the code that is attached to this component. *//* line 488 */
/*  */                                                 /* line 489 */
/*  `instance_data` is a pointer to instance data that the `leaf_handler` *//* line 490 */
/*  function may want whenever it is invoked again. */ /* line 491 */
/*  */                                                 /* line 492 *//* line 493 */
/*  Eh_States :: enum { idle, active } */              /* line 494 */
class Eh {
  constructor () {                                     /* line 495 */

    this.name =  "";                                   /* line 496 */
    this.inq =  []                                     /* line 497 */;
    this.outq =  []                                    /* line 498 */;
    this.owner =  null;                                /* line 499 */
    this.children = [];                                /* line 500 */
    this.visit_ordering =  []                          /* line 501 */;
    this.connections = [];                             /* line 502 */
    this.routings =  []                                /* line 503 */;
    this.handler =  null;                              /* line 504 */
    this.finject =  null;                              /* line 505 */
    this.instance_data =  null;                        /* line 506 */
    this.state =  "idle";                              /* line 507 *//*  bootstrap debugging *//* line 508 */
    this.kind =  null;/*  enum { container, leaf, } */ /* line 509 *//* line 510 */
  }
}
                                                       /* line 511 */
/*  Creates a component that acts as a container. It is the same as a `Eh` instance *//* line 512 */
/*  whose handler function is `container_handler`. */  /* line 513 */
function make_container (name,owner) {                 /* line 514 */
    let  eh =  new Eh ();                              /* line 515 */;
    eh.name =  name;                                   /* line 516 */
    eh.owner =  owner;                                 /* line 517 */
    eh.handler =  container_handler;                   /* line 518 */
    eh.finject =  injector;                            /* line 519 */
    eh.state =  "idle";                                /* line 520 */
    eh.kind =  "container";                            /* line 521 */
    return  eh;                                        /* line 522 *//* line 523 *//* line 524 */
}

/*  Creates a new leaf component out of a handler function, and a data parameter *//* line 525 */
/*  that will be passed back to your handler when called. *//* line 526 *//* line 527 */
function make_leaf (name,owner,instance_data,handler) {/* line 528 */
    let  eh =  new Eh ();                              /* line 529 */;
    let  nm =  "";                                     /* line 530 */
    if ( null!= owner) {                               /* line 531 */
      nm =  owner.name;                                /* line 532 *//* line 533 */
    }
    eh.name =  ( nm.toString ()+  ( "▹".toString ()+  name.toString ()) .toString ()) /* line 534 */;
    eh.owner =  owner;                                 /* line 535 */
    eh.handler =  handler;                             /* line 536 */
    eh.finject =  injector;                            /* line 537 */
    eh.instance_data =  instance_data;                 /* line 538 */
    eh.state =  "idle";                                /* line 539 */
    eh.kind =  "leaf";                                 /* line 540 */
    return  eh;                                        /* line 541 *//* line 542 *//* line 543 */
}

/*  Sends a mevent on the given `port` with `data`, placing it on the output *//* line 544 */
/*  of the given component. */                         /* line 545 *//* line 546 */
function send (eh,port,obj,causingMevent) {            /* line 547 */
    let  d = Datum ();                                 /* line 548 */
    d.v =  obj;                                        /* line 549 */
    d.clone =  function () {return obj_clone ( d)      /* line 550 */;};
    d.reclaim =  None;                                 /* line 551 */
    let mev = make_mevent ( port, d)                   /* line 552 */;
    put_output ( eh, mev)                              /* line 553 *//* line 554 *//* line 555 */
}

function forward (eh,port,mev) {                       /* line 556 */
    let fwdmev = make_mevent ( port, mev.datum)        /* line 557 */;
    put_output ( eh, fwdmev)                           /* line 558 *//* line 559 *//* line 560 */
}

function inject (eh,mev) {                             /* line 561 */
    eh.finject ( eh, mev)                              /* line 562 *//* line 563 *//* line 564 */
}

function set_active (eh) {                             /* line 565 */
    eh.state =  "active";                              /* line 566 *//* line 567 *//* line 568 */
}

function set_idle (eh) {                               /* line 569 */
    eh.state =  "idle";                                /* line 570 *//* line 571 *//* line 572 */
}

function put_output (eh,mev) {                         /* line 573 */
    eh.outq.push ( mev)                                /* line 574 *//* line 575 *//* line 576 */
}

let  projectRoot =  "";                                /* line 577 *//* line 578 */
function set_environment (project_root) {              /* line 579 *//* line 580 */
    projectRoot =  project_root;                       /* line 581 *//* line 582 *//* line 583 */
}

function obj_clone (obj) {                             /* line 584 */
    return  obj;                                       /* line 585 *//* line 586 *//* line 587 */
}

/*  usage: app ${_00_} diagram_filename1 diagram_filename2 ... *//* line 588 */
/*  where ${_00_} is the root directory for the project *//* line 589 *//* line 590 */
function initialize_component_palette_from_files (project_root,diagram_source_files) {/* line 591 */
    let  reg = make_component_registry ();             /* line 592 */
    for (let diagram_source of  diagram_source_files) {/* line 593 */
      let all_containers_within_single_file = lnet2internal_from_file ( project_root, diagram_source)/* line 594 */;
      reg = generate_shell_components ( reg, all_containers_within_single_file)/* line 595 */;
      for (let container of  all_containers_within_single_file) {/* line 596 */
        register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 597 *//* line 598 */
      }                                                /* line 599 */
    }
    initialize_stock_components ( reg)                 /* line 600 */
    return  reg;                                       /* line 601 *//* line 602 *//* line 603 */
}

function initialize_component_palette_from_string (project_root) {/* line 604 */
    /*  this version ignores project_root  */          /* line 605 */
    let  reg = make_component_registry ();             /* line 606 */
    let all_containers = lnet2internal_from_string (); /* line 607 */
    reg = generate_shell_components ( reg, all_containers)/* line 608 */;
    for (let container of  all_containers) {           /* line 609 */
      register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 610 *//* line 611 */
    }
    initialize_stock_components ( reg)                 /* line 612 */
    return  reg;                                       /* line 613 *//* line 614 *//* line 615 */
}
                                                       /* line 616 */
function clone_string (s) {                            /* line 617 */
    return  s                                          /* line 618 *//* line 619 */;/* line 620 */
}

let  load_errors =  false;                             /* line 621 */
let  runtime_errors =  false;                          /* line 622 *//* line 623 */
function load_error (s) {                              /* line 624 *//* line 625 */
    console.error ( s);                                /* line 626 */
                                                       /* line 627 */
    load_errors =  true;                               /* line 628 *//* line 629 *//* line 630 */
}

function runtime_error (s) {                           /* line 631 *//* line 632 */
    console.error ( s);                                /* line 633 */
    runtime_errors =  true;                            /* line 634 *//* line 635 *//* line 636 */
}
                                                       /* line 637 */
function initialize_from_files (project_root,diagram_names) {/* line 638 */
    let arg =  null;                                   /* line 639 */
    let palette = initialize_component_palette_from_files ( project_root, diagram_names)/* line 640 */;
    return [ palette,[ project_root, diagram_names, arg]];/* line 641 *//* line 642 *//* line 643 */
}

function initialize_from_string (project_root) {       /* line 644 */
    let arg =  null;                                   /* line 645 */
    let palette = initialize_component_palette_from_string ( project_root)/* line 646 */;
    return [ palette,[ project_root, null, arg]];      /* line 647 *//* line 648 *//* line 649 */
}

function start (arg,Part_name,palette,env) {           /* line 650 */
    let project_root =  env [ 0];                      /* line 651 */
    let diagram_names =  env [ 1];                     /* line 652 */
    set_environment ( project_root)                    /* line 653 */
    /*  get entrypoint container */                    /* line 654 */
    let  Part = get_component_instance ( palette, Part_name, null)/* line 655 */;
    if ( null ==  Part) {                              /* line 656 */
      load_error ( ( "Couldn't find container with page name /".toString ()+  ( Part_name.toString ()+  ( "/ in files ".toString ()+  (`${ diagram_names}`.toString ()+  " (check tab names, or disable compression?)".toString ()) .toString ()) .toString ()) .toString ()) )/* line 660 *//* line 661 */
    }
    if ((!  load_errors)) {                            /* line 662 */
      let  d = Datum ();                               /* line 663 */
      d.v =  arg;                                      /* line 664 */
      d.clone =  function () {return obj_clone ( d)    /* line 665 */;};
      d.reclaim =  None;                               /* line 666 */
      let  mev = make_mevent ( "", d)                  /* line 667 */;
      inject ( Part, mev)                              /* line 668 *//* line 669 */
    }                                                  /* line 670 *//* line 671 */
}
                                                       /* line 672 */

/*  this needs to be rewritten to use the low_level "shell_out“ component, this can be done solely as a diagram without using python code here *//* line 1 */
function shell_out_instantiate (reg,owner,name,template_data) {/* line 2 */
    let name_with_id = gensymbol ( "shell_out")        /* line 3 */;
    let cmd =  template_data.split (" ")               /* line 4 */;
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)/* line 5 */;/* line 6 *//* line 7 */
}

function shell_out_handler (eh,msg) {                  /* line 8 */
    let cmd =  eh.instance_data;                       /* line 9 */
    let s =  msg.datum.v;                              /* line 10 */
    let  ret =  null;                                  /* line 11 */
    let  rc =  null;                                   /* line 12 */
    let  stdout =  null;                               /* line 13 */
    let  stderr =  null;                               /* line 14 */

    stdout = execSync(`${ cmd} ${ s}`, { encoding: 'utf-8' });
    ret = true;
                                                       /* line 15 */
    if ( rc ==  0) {                                   /* line 16 */
      send ( eh, "", ( stdout.toString ()+  stderr.toString ()) , msg)/* line 17 */
    }
    else {                                             /* line 18 */
      send ( eh, "✗", ( stdout.toString ()+  stderr.toString ()) , msg)/* line 19 *//* line 20 */
    }                                                  /* line 21 *//* line 22 */
}

function generate_shell_components (reg,container_list) {/* line 23 */
    /*  [ */                                           /* line 24 */
    /*      {;file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 25 */
    /*      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} *//* line 26 */
    /*  ] */                                           /* line 27 */
    if ( null!= container_list) {                      /* line 28 */
      for (let diagram of  container_list) {           /* line 29 */
        /*  loop through every component in the diagram and look for names that start with “$“ or “'“  *//* line 30 */
        /*  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 31 */
        for (let child_descriptor of  diagram [ "children"]) {/* line 32 */
          if (first_char_is ( child_descriptor [ "name"], "$")) {/* line 33 */
            let name =  child_descriptor [ "name"];    /* line 34 */
            let cmd =   name.substring (1) .strip ();  /* line 35 */
            let generated_leaf = mkTemplate ( name, cmd, shell_out_instantiate)/* line 36 */;
            register_component ( reg, generated_leaf)  /* line 37 */
          }
          else if (first_char_is ( child_descriptor [ "name"], "'")) {/* line 38 */
            let name =  child_descriptor [ "name"];    /* line 39 */
            let s =   name.substring (1)               /* line 40 */;
            let generated_leaf = mkTemplate ( name, s, string_constant_instantiate)/* line 41 */;
            register_component_allow_overwriting ( reg, generated_leaf)/* line 42 *//* line 43 */
          }                                            /* line 44 */
        }                                              /* line 45 */
      }                                                /* line 46 */
    }
    return  reg;                                       /* line 47 *//* line 48 *//* line 49 */
}

function first_char (s) {                              /* line 50 */
    return   s[0]                                      /* line 51 */;/* line 52 *//* line 53 */
}

function first_char_is (s,c) {                         /* line 54 */
    return  c == first_char ( s)                       /* line 55 */;/* line 56 *//* line 57 */
}
                                                       /* line 58 */
/*  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here *//* line 59 */
/*  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped *//* line 60 *//* line 61 */

function probeA_instantiate (reg,owner,name,template_data) {/* line 1 */
    let name_with_id = gensymbol ( "?A")               /* line 2 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 3 */;/* line 4 *//* line 5 */
}

function probeB_instantiate (reg,owner,name,template_data) {/* line 6 */
    let name_with_id = gensymbol ( "?B")               /* line 7 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 8 */;/* line 9 *//* line 10 */
}

function probeC_instantiate (reg,owner,name,template_data) {/* line 11 */
    let name_with_id = gensymbol ( "?C")               /* line 12 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 13 */;/* line 14 *//* line 15 */
}

function probe_handler (eh,mev) {                      /* line 16 *//* line 17 */
    let s =  mev.datum.v;                              /* line 18 */
    live_update ( "Info",  ( "  @".toString ()+  (`${ ticktime}`.toString ()+  ( "  ".toString ()+  ( "probe ".toString ()+  ( eh.name.toString ()+  ( ": ".toString ()+   s.toString ()) .toString ()) .toString ()) .toString ()) .toString ()) .toString ()) )/* line 26 *//* line 27 *//* line 28 */
}

function trash_instantiate (reg,owner,name,template_data) {/* line 29 */
    let name_with_id = gensymbol ( "trash")            /* line 30 */;
    return make_leaf ( name_with_id, owner, null, trash_handler)/* line 31 */;/* line 32 *//* line 33 */
}

function trash_handler (eh,mev) {                      /* line 34 */
    /*  to appease dumped_on_floor checker */          /* line 35 *//* line 36 *//* line 37 */
}

class TwoMevents {
  constructor () {                                     /* line 38 */

    this.firstmev =  null;                             /* line 39 */
    this.secondmev =  null;                            /* line 40 *//* line 41 */
  }
}
                                                       /* line 42 */
/*  Deracer_States :: enum { idle, waitingForFirstmev, waitingForSecondmev } *//* line 43 */
class Deracer_Instance_Data {
  constructor () {                                     /* line 44 */

    this.state =  null;                                /* line 45 */
    this.buffer =  null;                               /* line 46 *//* line 47 */
  }
}
                                                       /* line 48 */
function reclaim_Buffers_from_heap (inst) {            /* line 49 *//* line 50 *//* line 51 *//* line 52 */
}

function deracer_instantiate (reg,owner,name,template_data) {/* line 53 */
    let name_with_id = gensymbol ( "deracer")          /* line 54 */;
    let  inst =  new Deracer_Instance_Data ();         /* line 55 */;
    inst.state =  "idle";                              /* line 56 */
    inst.buffer =  new TwoMevents ();                  /* line 57 */;
    let eh = make_leaf ( name_with_id, owner, inst, deracer_handler)/* line 58 */;
    return  eh;                                        /* line 59 *//* line 60 *//* line 61 */
}

function send_firstmev_then_secondmev (eh,inst) {      /* line 62 */
    forward ( eh, "1", inst.buffer.firstmev)           /* line 63 */
    forward ( eh, "2", inst.buffer.secondmev)          /* line 64 */
    reclaim_Buffers_from_heap ( inst)                  /* line 65 *//* line 66 *//* line 67 */
}

function deracer_handler (eh,mev) {                    /* line 68 */
    let  inst =  eh.instance_data;                     /* line 69 */
    if ( inst.state ==  "idle") {                      /* line 70 */
      if ( "1" ==  mev.port) {                         /* line 71 */
        inst.buffer.firstmev =  mev;                   /* line 72 */
        inst.state =  "waitingForSecondmev";           /* line 73 */
      }
      else if ( "2" ==  mev.port) {                    /* line 74 */
        inst.buffer.secondmev =  mev;                  /* line 75 */
        inst.state =  "waitingForFirstmev";            /* line 76 */
      }
      else {                                           /* line 77 */
        runtime_error ( ( "bad mev.port (case A) for deracer ".toString ()+  mev.port.toString ()) )/* line 78 *//* line 79 */
      }
    }
    else if ( inst.state ==  "waitingForFirstmev") {   /* line 80 */
      if ( "1" ==  mev.port) {                         /* line 81 */
        inst.buffer.firstmev =  mev;                   /* line 82 */
        send_firstmev_then_secondmev ( eh, inst)       /* line 83 */
        inst.state =  "idle";                          /* line 84 */
      }
      else {                                           /* line 85 */
        runtime_error ( ( "bad mev.port (case B) for deracer ".toString ()+  mev.port.toString ()) )/* line 86 *//* line 87 */
      }
    }
    else if ( inst.state ==  "waitingForSecondmev") {  /* line 88 */
      if ( "2" ==  mev.port) {                         /* line 89 */
        inst.buffer.secondmev =  mev;                  /* line 90 */
        send_firstmev_then_secondmev ( eh, inst)       /* line 91 */
        inst.state =  "idle";                          /* line 92 */
      }
      else {                                           /* line 93 */
        runtime_error ( ( "bad mev.port (case C) for deracer ".toString ()+  mev.port.toString ()) )/* line 94 *//* line 95 */
      }
    }
    else {                                             /* line 96 */
      runtime_error ( "bad state for deracer {eh.state}")/* line 97 *//* line 98 */
    }                                                  /* line 99 *//* line 100 */
}

function low_level_read_text_file_instantiate (reg,owner,name,template_data) {/* line 101 */
    let name_with_id = gensymbol ( "Low Level Read Text File")/* line 102 */;
    return make_leaf ( name_with_id, owner, null, low_level_read_text_file_handler)/* line 103 */;/* line 104 *//* line 105 */
}

function low_level_read_text_file_handler (eh,mev) {   /* line 106 */
    let fname =  mev.datum.v;                          /* line 107 */

    if (fname == "0") {
    data = fs.readFileSync (0, { encoding: 'utf8'});
    } else {
    data = fs.readFileSync (fname, { encoding: 'utf8'});
    }
    if (data) {
      send_string (eh, "", data, mev);
    } else {
      send_string (eh, "✗", `read error on file '${fname}'`, mev);
    }
                                                       /* line 108 *//* line 109 *//* line 110 */
}

function ensure_string_datum_instantiate (reg,owner,name,template_data) {/* line 111 */
    let name_with_id = gensymbol ( "Ensure String Datum")/* line 112 */;
    return make_leaf ( name_with_id, owner, null, ensure_string_datum_handler)/* line 113 */;/* line 114 *//* line 115 */
}

function ensure_string_datum_handler (eh,mev) {        /* line 116 */
    if ( "string" ==  mev.datum.kind ()) {             /* line 117 */
      forward ( eh, "", mev)                           /* line 118 */
    }
    else {                                             /* line 119 */
      let emev =  ( "*** ensure: type error (expected a string datum) but got ".toString ()+  mev.datum.toString ()) /* line 120 */;
      send ( eh, "✗", emev, mev)                       /* line 121 *//* line 122 */
    }                                                  /* line 123 *//* line 124 */
}

class Syncfilewrite_Data {
  constructor () {                                     /* line 125 */

    this.filename =  "";                               /* line 126 *//* line 127 */
  }
}
                                                       /* line 128 */
/*  temp copy for bootstrap, sends "done“ (error during bootstrap if not wired) *//* line 129 */
function syncfilewrite_instantiate (reg,owner,name,template_data) {/* line 130 */
    let name_with_id = gensymbol ( "syncfilewrite")    /* line 131 */;
    let inst =  new Syncfilewrite_Data ();             /* line 132 */;
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)/* line 133 */;/* line 134 *//* line 135 */
}

function syncfilewrite_handler (eh,mev) {              /* line 136 */
    let  inst =  eh.instance_data;                     /* line 137 */
    if ( "filename" ==  mev.port) {                    /* line 138 */
      inst.filename =  mev.datum.v;                    /* line 139 */
    }
    else if ( "input" ==  mev.port) {                  /* line 140 */
      let contents =  mev.datum.v;                     /* line 141 */
      let  f = open ( inst.filename, "w")              /* line 142 */;
      if ( f!= null) {                                 /* line 143 */
        f.write ( mev.datum.v)                         /* line 144 */
        f.close ()                                     /* line 145 */
        send ( eh, "done",new_datum_bang (), mev)      /* line 146 */
      }
      else {                                           /* line 147 */
        send ( eh, "✗", ( "open error on file ".toString ()+  inst.filename.toString ()) , mev)/* line 148 *//* line 149 */
      }                                                /* line 150 */
    }                                                  /* line 151 *//* line 152 */
}

class StringConcat_Instance_Data {
  constructor () {                                     /* line 153 */

    this.buffer1 =  null;                              /* line 154 */
    this.buffer2 =  null;                              /* line 155 *//* line 156 */
  }
}
                                                       /* line 157 */
function stringconcat_instantiate (reg,owner,name,template_data) {/* line 158 */
    let name_with_id = gensymbol ( "stringconcat")     /* line 159 */;
    let instp =  new StringConcat_Instance_Data ();    /* line 160 */;
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)/* line 161 */;/* line 162 *//* line 163 */
}

function stringconcat_handler (eh,mev) {               /* line 164 */
    let  inst =  eh.instance_data;                     /* line 165 */
    if ( "1" ==  mev.port) {                           /* line 166 */
      inst.buffer1 = clone_string ( mev.datum.v)       /* line 167 */;
      maybe_stringconcat ( eh, inst, mev)              /* line 168 */
    }
    else if ( "2" ==  mev.port) {                      /* line 169 */
      inst.buffer2 = clone_string ( mev.datum.v)       /* line 170 */;
      maybe_stringconcat ( eh, inst, mev)              /* line 171 */
    }
    else if ( "reset" ==  mev.port) {                  /* line 172 */
      inst.buffer1 =  null;                            /* line 173 */
      inst.buffer2 =  null;                            /* line 174 */
    }
    else {                                             /* line 175 */
      runtime_error ( ( "bad mev.port for stringconcat: ".toString ()+  mev.port.toString ()) )/* line 176 *//* line 177 */
    }                                                  /* line 178 *//* line 179 */
}

function maybe_stringconcat (eh,inst,mev) {            /* line 180 */
    if ((( inst.buffer1!= null) && ( inst.buffer2!= null))) {/* line 181 */
      let  concatenated_string =  "";                  /* line 182 */
      if ( 0 == ( inst.buffer1.length)) {              /* line 183 */
        concatenated_string =  inst.buffer2;           /* line 184 */
      }
      else if ( 0 == ( inst.buffer2.length)) {         /* line 185 */
        concatenated_string =  inst.buffer1;           /* line 186 */
      }
      else {                                           /* line 187 */
        concatenated_string =  inst.buffer1+ inst.buffer2;/* line 188 *//* line 189 */
      }
      send ( eh, "", concatenated_string, mev)         /* line 190 */
      inst.buffer1 =  null;                            /* line 191 */
      inst.buffer2 =  null;                            /* line 192 *//* line 193 */
    }                                                  /* line 194 *//* line 195 */
}

/*  */                                                 /* line 196 *//* line 197 */
function string_constant_instantiate (reg,owner,name,template_data) {/* line 198 *//* line 199 */
    let name_with_id = gensymbol ( "strconst")         /* line 200 */;
    let  s =  template_data;                           /* line 201 */
    if ( projectRoot!= "") {                           /* line 202 */
      s =  s.replaceAll ( "_00_",  projectRoot)        /* line 203 */;/* line 204 */
    }
    return make_leaf ( name_with_id, owner, s, string_constant_handler)/* line 205 */;/* line 206 *//* line 207 */
}

function string_constant_handler (eh,mev) {            /* line 208 */
    let s =  eh.instance_data;                         /* line 209 */
    send ( eh, "", s, mev)                             /* line 210 *//* line 211 *//* line 212 */
}

function fakepipename_instantiate (reg,owner,name,template_data) {/* line 213 */
    let instance_name = gensymbol ( "fakepipe")        /* line 214 */;
    return make_leaf ( instance_name, owner, null, fakepipename_handler)/* line 215 */;/* line 216 *//* line 217 */
}

let  rand =  0;                                        /* line 218 *//* line 219 */
function fakepipename_handler (eh,mev) {               /* line 220 *//* line 221 */
    rand =  rand+ 1;
    /*  not very random, but good enough _ ;rand' must be unique within a single run *//* line 222 */
    send ( eh, "", ( "/tmp/fakepipe".toString ()+  rand.toString ()) , mev)/* line 223 *//* line 224 *//* line 225 */
}
                                                       /* line 226 */
class Switch1star_Instance_Data {
  constructor () {                                     /* line 227 */

    this.state =  "1";                                 /* line 228 *//* line 229 */
  }
}
                                                       /* line 230 */
function switch1star_instantiate (reg,owner,name,template_data) {/* line 231 */
    let name_with_id = gensymbol ( "switch1*")         /* line 232 */;
    let instp =  new Switch1star_Instance_Data ();     /* line 233 */;
    return make_leaf ( name_with_id, owner, instp, switch1star_handler)/* line 234 */;/* line 235 *//* line 236 */
}

function switch1star_handler (eh,mev) {                /* line 237 */
    let  inst =  eh.instance_data;                     /* line 238 */
    let whichOutput =  inst.state;                     /* line 239 */
    if ( "" ==  mev.port) {                            /* line 240 */
      if ( "1" ==  whichOutput) {                      /* line 241 */
        forward ( eh, "1", mev)                        /* line 242 */
        inst.state =  "*";                             /* line 243 */
      }
      else if ( "*" ==  whichOutput) {                 /* line 244 */
        forward ( eh, "*", mev)                        /* line 245 */
      }
      else {                                           /* line 246 */
        send ( eh, "✗", "internal error bad state in switch1*", mev)/* line 247 *//* line 248 */
      }
    }
    else if ( "reset" ==  mev.port) {                  /* line 249 */
      inst.state =  "1";                               /* line 250 */
    }
    else {                                             /* line 251 */
      send ( eh, "✗", "internal error bad mevent for switch1*", mev)/* line 252 *//* line 253 */
    }                                                  /* line 254 *//* line 255 */
}

class StringAccumulator {
  constructor () {                                     /* line 256 */

    this.s =  "";                                      /* line 257 *//* line 258 */
  }
}
                                                       /* line 259 */
function strcatstar_instantiate (reg,owner,name,template_data) {/* line 260 */
    let name_with_id = gensymbol ( "String Concat *")  /* line 261 */;
    let instp =  new StringAccumulator ();             /* line 262 */;
    return make_leaf ( name_with_id, owner, instp, strcatstar_handler)/* line 263 */;/* line 264 *//* line 265 */
}

function strcatstar_handler (eh,mev) {                 /* line 266 */
    let  accum =  eh.instance_data;                    /* line 267 */
    if ( "" ==  mev.port) {                            /* line 268 */
      accum.s =  ( accum.s.toString ()+  mev.datum.v.toString ()) /* line 269 */;
    }
    else if ( "fini" ==  mev.port) {                   /* line 270 */
      send ( eh, "", accum.s, mev)                     /* line 271 */
    }
    else {                                             /* line 272 */
      send ( eh, "✗", "internal error bad mevent for String Concat *", mev)/* line 273 *//* line 274 */
    }                                                  /* line 275 *//* line 276 */
}

/*  all of the the built_in leaves are listed here */  /* line 277 */
/*  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project *//* line 278 *//* line 279 */
function initialize_stock_components (reg) {           /* line 280 */
    register_component ( reg,mkTemplate ( "1then2", null, deracer_instantiate))/* line 281 */
    register_component ( reg,mkTemplate ( "?A", null, probeA_instantiate))/* line 282 */
    register_component ( reg,mkTemplate ( "?B", null, probeB_instantiate))/* line 283 */
    register_component ( reg,mkTemplate ( "?C", null, probeC_instantiate))/* line 284 */
    register_component ( reg,mkTemplate ( "trash", null, trash_instantiate))/* line 285 *//* line 286 *//* line 287 */
    register_component ( reg,mkTemplate ( "Read Text File", null, low_level_read_text_file_instantiate))/* line 288 */
    register_component ( reg,mkTemplate ( "Ensure String Datum", null, ensure_string_datum_instantiate))/* line 289 *//* line 290 */
    register_component ( reg,mkTemplate ( "syncfilewrite", null, syncfilewrite_instantiate))/* line 291 */
    register_component ( reg,mkTemplate ( "stringconcat", null, stringconcat_instantiate))/* line 292 */
    register_component ( reg,mkTemplate ( "switch1*", null, switch1star_instantiate))/* line 293 */
    register_component ( reg,mkTemplate ( "String Concat *", null, strcatstar_instantiate))/* line 294 */
    /*  for fakepipe */                                /* line 295 */
    register_component ( reg,mkTemplate ( "fakepipename", null, fakepipename_instantiate))/* line 296 *//* line 297 *//* line 298 */
}import * as fs from 'fs';
import path from 'path';
import execSync from 'child_process';
                                                       /* line 1 *//* line 2 */
let  counter =  0;                                     /* line 3 */
let  ticktime =  0;                                    /* line 4 *//* line 5 */
let  digits = [ "₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀", "₂₁", "₂₂", "₂₃", "₂₄", "₂₅", "₂₆", "₂₇", "₂₈", "₂₉"];/* line 12 *//* line 13 *//* line 14 */
function gensymbol (s) {                               /* line 15 *//* line 16 */
    let name_with_id =  ( s.toString ()+ subscripted_digit ( counter).toString ()) /* line 17 */;
    counter =  counter+ 1;                             /* line 18 */
    return  name_with_id;                              /* line 19 *//* line 20 *//* line 21 */
}

function subscripted_digit (n) {                       /* line 22 *//* line 23 */
    if (((( n >=  0) && ( n <=  29)))) {               /* line 24 */
      return  digits [ n];                             /* line 25 */
    }
    else {                                             /* line 26 */
      return  ( "₊".toString ()+ `${ n}`.toString ())  /* line 27 */;/* line 28 */
    }                                                  /* line 29 *//* line 30 */
}

class Datum {
  constructor () {                                     /* line 31 */

    this.v =  null;                                    /* line 32 */
    this.clone =  null;                                /* line 33 */
    this.reclaim =  null;                              /* line 34 */
    this.other =  null;/*  reserved for use on per-project basis  *//* line 35 *//* line 36 */
  }
}
                                                       /* line 37 *//* line 38 */
/*  Mevent passed to a leaf component. */              /* line 39 */
/*  */                                                 /* line 40 */
/*  `port` refers to the name of the incoming or outgoing port of this component. *//* line 41 */
/*  `payload` is the data attached to this mevent. */  /* line 42 */
class Mevent {
  constructor () {                                     /* line 43 */

    this.port =  null;                                 /* line 44 */
    this.datum =  null;                                /* line 45 *//* line 46 */
  }
}
                                                       /* line 47 */
function clone_port (s) {                              /* line 48 */
    return clone_string ( s)                           /* line 49 */;/* line 50 *//* line 51 */
}

/*  Utility for making a `Mevent`. Used to safely "seed“ mevents *//* line 52 */
/*  entering the very top of a network. */             /* line 53 */
function make_mevent (port,datum) {                    /* line 54 */
    let p = clone_string ( port)                       /* line 55 */;
    let  m =  new Mevent ();                           /* line 56 */;
    m.port =  p;                                       /* line 57 */
    m.datum =  datum.clone ();                         /* line 58 */
    return  m;                                         /* line 59 *//* line 60 *//* line 61 */
}

/*  Clones a mevent. Primarily used internally for “fanning out“ a mevent to multiple destinations. *//* line 62 */
function mevent_clone (mev) {                          /* line 63 */
    let  m =  new Mevent ();                           /* line 64 */;
    m.port = clone_port ( mev.port)                    /* line 65 */;
    m.datum =  mev.datum.clone ();                     /* line 66 */
    return  m;                                         /* line 67 *//* line 68 *//* line 69 */
}

/*  Frees a mevent. */                                 /* line 70 */
function destroy_mevent (mev) {                        /* line 71 */
    /*  during debug, dont destroy any mevent, since we want to trace mevents, thus, we need to persist ancestor mevents *//* line 72 *//* line 73 *//* line 74 *//* line 75 */
}

function destroy_datum (mev) {                         /* line 76 *//* line 77 *//* line 78 *//* line 79 */
}

function destroy_port (mev) {                          /* line 80 *//* line 81 *//* line 82 *//* line 83 */
}

/*  */                                                 /* line 84 */
function format_mevent (m) {                           /* line 85 */
    if ( m ==  null) {                                 /* line 86 */
      return  "{}";                                    /* line 87 */
    }
    else {                                             /* line 88 */
      return  ( "{%5C”".toString ()+  ( m.port.toString ()+  ( "%5C”:%5C”".toString ()+  ( m.datum.v.toString ()+  "%5C”}".toString ()) .toString ()) .toString ()) .toString ()) /* line 89 */;/* line 90 */
    }                                                  /* line 91 */
}

function format_mevent_raw (m) {                       /* line 92 */
    if ( m ==  null) {                                 /* line 93 */
      return  "";                                      /* line 94 */
    }
    else {                                             /* line 95 */
      return  m.datum.v;                               /* line 96 *//* line 97 */
    }                                                  /* line 98 *//* line 99 */
}

const  enumDown =  0                                   /* line 100 */;
const  enumAcross =  1                                 /* line 101 */;
const  enumUp =  2                                     /* line 102 */;
const  enumThrough =  3                                /* line 103 */;/* line 104 */
function create_down_connector (container,proto_conn,connectors,children_by_id) {/* line 105 */
    /*  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, *//* line 106 */
    let  connector =  new Connector ();                /* line 107 */;
    connector.direction =  "down";                     /* line 108 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 109 */;
    let target_proto =  proto_conn [ "target"];        /* line 110 */
    let id_proto =  target_proto [ "id"];              /* line 111 */
    let target_component =  children_by_id [id_proto]; /* line 112 */
    if (( target_component ==  null)) {                /* line 113 */
      load_error ( ( "internal error: .Down connection target internal error ".toString ()+ ( proto_conn [ "target"]) [ "name"].toString ()) )/* line 114 */
    }
    else {                                             /* line 115 */
      connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 116 */;/* line 117 */
    }
    return  connector;                                 /* line 118 *//* line 119 *//* line 120 */
}

function create_across_connector (container,proto_conn,connectors,children_by_id) {/* line 121 */
    let  connector =  new Connector ();                /* line 122 */;
    connector.direction =  "across";                   /* line 123 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 124 */
    let target_component =  children_by_id [(( proto_conn [ "target"]) [ "id"])];/* line 125 */
    if ( source_component ==  null) {                  /* line 126 */
      load_error ( ( "internal error: .Across connection source not ok ".toString ()+ ( proto_conn [ "source"]) [ "name"].toString ()) )/* line 127 */
    }
    else {                                             /* line 128 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 129 */;
      if ( target_component ==  null) {                /* line 130 */
        load_error ( ( "internal error: .Across connection target not ok ".toString ()+ ( proto_conn [ "target"]) [ "name"].toString ()) )/* line 131 */
      }
      else {                                           /* line 132 */
        connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 133 */;/* line 134 */
      }                                                /* line 135 */
    }
    return  connector;                                 /* line 136 *//* line 137 *//* line 138 */
}

function create_up_connector (container,proto_conn,connectors,children_by_id) {/* line 139 */
    let  connector =  new Connector ();                /* line 140 */;
    connector.direction =  "up";                       /* line 141 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 142 */
    if ( source_component ==  null) {                  /* line 143 */
      load_error ( ( "internal error: .Up connection source not ok ".toString ()+ ( proto_conn [ "source"]) [ "name"].toString ()) )/* line 144 */
    }
    else {                                             /* line 145 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 146 */;
      connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 147 */;/* line 148 */
    }
    return  connector;                                 /* line 149 *//* line 150 *//* line 151 */
}

function create_through_connector (container,proto_conn,connectors,children_by_id) {/* line 152 */
    let  connector =  new Connector ();                /* line 153 */;
    connector.direction =  "through";                  /* line 154 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 155 */;
    connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 156 */;
    return  connector;                                 /* line 157 *//* line 158 *//* line 159 */
}
                                                       /* line 160 */
function container_instantiator (reg,owner,container_name,desc) {/* line 161 *//* line 162 */
    let container = make_container ( container_name, owner)/* line 163 */;
    let children = [];                                 /* line 164 */
    let children_by_id = {};
    /*  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here *//* line 165 */
    /*  collect children */                            /* line 166 */
    for (let child_desc of  desc [ "children"]) {      /* line 167 */
      let child_instance = get_component_instance ( reg, child_desc [ "name"], container)/* line 168 */;
      children.push ( child_instance)                  /* line 169 */
      let id =  child_desc [ "id"];                    /* line 170 */
      children_by_id [id] =  child_instance;           /* line 171 *//* line 172 *//* line 173 */
    }
    container.children =  children;                    /* line 174 *//* line 175 */
    let connectors = [];                               /* line 176 */
    for (let proto_conn of  desc [ "connections"]) {   /* line 177 */
      let  connector =  new Connector ();              /* line 178 */;
      if ( proto_conn [ "dir"] ==  enumDown) {         /* line 179 */
        connectors.push (create_down_connector ( container, proto_conn, connectors, children_by_id)) /* line 180 */
      }
      else if ( proto_conn [ "dir"] ==  enumAcross) {  /* line 181 */
        connectors.push (create_across_connector ( container, proto_conn, connectors, children_by_id)) /* line 182 */
      }
      else if ( proto_conn [ "dir"] ==  enumUp) {      /* line 183 */
        connectors.push (create_up_connector ( container, proto_conn, connectors, children_by_id)) /* line 184 */
      }
      else if ( proto_conn [ "dir"] ==  enumThrough) { /* line 185 */
        connectors.push (create_through_connector ( container, proto_conn, connectors, children_by_id)) /* line 186 *//* line 187 */
      }                                                /* line 188 */
    }
    container.connections =  connectors;               /* line 189 */
    return  container;                                 /* line 190 *//* line 191 *//* line 192 */
}

/*  The default handler for container components. */   /* line 193 */
function container_handler (container,mevent) {        /* line 194 */
    route ( container, container, mevent)
    /*  references to 'self' are replaced by the container during instantiation *//* line 195 */
    while (any_child_ready ( container)) {             /* line 196 */
      step_children ( container, mevent)               /* line 197 */
    }                                                  /* line 198 *//* line 199 */
}

/*  Frees the given container and associated data. */  /* line 200 */
function destroy_container (eh) {                      /* line 201 *//* line 202 *//* line 203 *//* line 204 */
}

/*  Routing connection for a container component. The `direction` field has *//* line 205 */
/*  no affect on the default mevent routing system _ it is there for debugging *//* line 206 */
/*  purposes, or for reading by other tools. */        /* line 207 *//* line 208 */
class Connector {
  constructor () {                                     /* line 209 */

    this.direction =  null;/*  down, across, up, through *//* line 210 */
    this.sender =  null;                               /* line 211 */
    this.receiver =  null;                             /* line 212 *//* line 213 */
  }
}
                                                       /* line 214 */
/*  `Sender` is used to “pattern match“ which `Receiver` a mevent should go to, *//* line 215 */
/*  based on component ID (pointer) and port name. */  /* line 216 *//* line 217 */
class Sender {
  constructor () {                                     /* line 218 */

    this.name =  null;                                 /* line 219 */
    this.component =  null;                            /* line 220 */
    this.port =  null;                                 /* line 221 *//* line 222 */
  }
}
                                                       /* line 223 *//* line 224 *//* line 225 */
/*  `Receiver` is a handle to a destination queue, and a `port` name to assign *//* line 226 */
/*  to incoming mevents to this queue. */              /* line 227 *//* line 228 */
class Receiver {
  constructor () {                                     /* line 229 */

    this.name =  null;                                 /* line 230 */
    this.queue =  null;                                /* line 231 */
    this.port =  null;                                 /* line 232 */
    this.component =  null;                            /* line 233 *//* line 234 */
  }
}
                                                       /* line 235 */
function mkSender (name,component,port) {              /* line 236 */
    let  s =  new Sender ();                           /* line 237 */;
    s.name =  name;                                    /* line 238 */
    s.component =  component;                          /* line 239 */
    s.port =  port;                                    /* line 240 */
    return  s;                                         /* line 241 *//* line 242 *//* line 243 */
}

function mkReceiver (name,component,port,q) {          /* line 244 */
    let  r =  new Receiver ();                         /* line 245 */;
    r.name =  name;                                    /* line 246 */
    r.component =  component;                          /* line 247 */
    r.port =  port;                                    /* line 248 */
    /*  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. *//* line 249 */
    r.queue =  q;                                      /* line 250 */
    return  r;                                         /* line 251 *//* line 252 *//* line 253 */
}

/*  Checks if two senders match, by pointer equality and port name matching. *//* line 254 */
function sender_eq (s1,s2) {                           /* line 255 */
    let same_components = ( s1.component ==  s2.component);/* line 256 */
    let same_ports = ( s1.port ==  s2.port);           /* line 257 */
    return (( same_components) && ( same_ports));      /* line 258 *//* line 259 *//* line 260 */
}

/*  Delivers the given mevent to the receiver of this connector. *//* line 261 *//* line 262 */
function deposit (parent,conn,mevent) {                /* line 263 */
    let new_mevent = make_mevent ( conn.receiver.port, mevent.datum)/* line 264 */;
    push_mevent ( parent, conn.receiver.component, conn.receiver.queue, new_mevent)/* line 265 *//* line 266 *//* line 267 */
}

function force_tick (parent,eh) {                      /* line 268 */
    let tick_mev = make_mevent ( ".",new_datum_bang ())/* line 269 */;
    push_mevent ( parent, eh, eh.inq, tick_mev)        /* line 270 */
    return  tick_mev;                                  /* line 271 *//* line 272 *//* line 273 */
}

function push_mevent (parent,receiver,inq,m) {         /* line 274 */
    inq.push ( m)                                      /* line 275 */
    parent.visit_ordering.push ( receiver)             /* line 276 *//* line 277 *//* line 278 */
}

function is_self (child,container) {                   /* line 279 */
    /*  in an earlier version “self“ was denoted as ϕ *//* line 280 */
    return  child ==  container;                       /* line 281 *//* line 282 *//* line 283 */
}

function step_child (child,mev) {                      /* line 284 */
    let before_state =  child.state;                   /* line 285 */
    child.handler ( child, mev)                        /* line 286 */
    let after_state =  child.state;                    /* line 287 */
    return [(( before_state ==  "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state ==  "idle"))];/* line 290 *//* line 291 *//* line 292 */
}

function step_children (container,causingMevent) {     /* line 293 */
    container.state =  "idle";                         /* line 294 */
    for (let child of   container.visit_ordering) {    /* line 295 */
      /*  child = container represents self, skip it *//* line 296 */
      if (((! (is_self ( child, container))))) {       /* line 297 */
        if (((! ((0=== child.inq.length))))) {         /* line 298 */
          let mev =  child.inq.shift ()                /* line 299 */;
          let  began_long_run =  null;                 /* line 300 */
          let  continued_long_run =  null;             /* line 301 */
          let  ended_long_run =  null;                 /* line 302 */
          [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, mev)/* line 303 */;
          if ( began_long_run) {                       /* line 304 *//* line 305 */
          }
          else if ( continued_long_run) {              /* line 306 *//* line 307 */
          }
          else if ( ended_long_run) {                  /* line 308 *//* line 309 *//* line 310 */
          }
          destroy_mevent ( mev)                        /* line 311 */
        }
        else {                                         /* line 312 */
          if ( child.state!= "idle") {                 /* line 313 */
            let mev = force_tick ( container, child)   /* line 314 */;
            child.handler ( child, mev)                /* line 315 */
            destroy_mevent ( mev)                      /* line 316 *//* line 317 */
          }                                            /* line 318 */
        }                                              /* line 319 */
        if ( child.state ==  "active") {               /* line 320 */
          /*  if child remains active, then the container must remain active and must propagate “ticks“ to child *//* line 321 */
          container.state =  "active";                 /* line 322 *//* line 323 */
        }                                              /* line 324 */
        while (((! ((0=== child.outq.length))))) {     /* line 325 */
          let mev =  child.outq.shift ()               /* line 326 */;
          route ( container, child, mev)               /* line 327 */
          destroy_mevent ( mev)                        /* line 328 *//* line 329 */
        }                                              /* line 330 */
      }                                                /* line 331 */
    }                                                  /* line 332 *//* line 333 */
}

function attempt_tick (parent,eh) {                    /* line 334 */
    if ( eh.state!= "idle") {                          /* line 335 */
      force_tick ( parent, eh)                         /* line 336 *//* line 337 */
    }                                                  /* line 338 *//* line 339 */
}

function is_tick (mev) {                               /* line 340 */
    return  "." ==  mev.port
    /*  assume that any mevent that is sent to port "." is a tick  *//* line 341 */;/* line 342 *//* line 343 */
}

/*  Routes a single mevent to all matching destinations, according to *//* line 344 */
/*  the container's connection network. */             /* line 345 *//* line 346 */
function route (container,from_component,mevent) {     /* line 347 */
    let  was_sent =  false;
    /*  for checking that output went somewhere (at least during bootstrap) *//* line 348 */
    let  fromname =  "";                               /* line 349 *//* line 350 */
    ticktime =  ticktime+ 1;                           /* line 351 */
    if (is_tick ( mevent)) {                           /* line 352 */
      for (let child of  container.children) {         /* line 353 */
        attempt_tick ( container, child)               /* line 354 */
      }
      was_sent =  true;                                /* line 355 */
    }
    else {                                             /* line 356 */
      if (((! (is_self ( from_component, container))))) {/* line 357 */
        fromname =  from_component.name;               /* line 358 *//* line 359 */
      }
      let from_sender = mkSender ( fromname, from_component, mevent.port)/* line 360 */;/* line 361 */
      for (let connector of  container.connections) {  /* line 362 */
        if (sender_eq ( from_sender, connector.sender)) {/* line 363 */
          deposit ( container, connector, mevent)      /* line 364 */
          was_sent =  true;                            /* line 365 *//* line 366 */
        }                                              /* line 367 */
      }                                                /* line 368 */
    }
    if ((! ( was_sent))) {                             /* line 369 */
      live_update ( "✗",  ( container.name.toString ()+  ( ": mevent '".toString ()+  ( mevent.port.toString ()+  ( "' from ".toString ()+  ( fromname.toString ()+  " dropped on floor...".toString ()) .toString ()) .toString ()) .toString ()) .toString ()) )/* line 370 *//* line 371 */
    }                                                  /* line 372 *//* line 373 */
}

function any_child_ready (container) {                 /* line 374 */
    for (let child of  container.children) {           /* line 375 */
      if (child_is_ready ( child)) {                   /* line 376 */
        return  true;                                  /* line 377 *//* line 378 */
      }                                                /* line 379 */
    }
    return  false;                                     /* line 380 *//* line 381 *//* line 382 */
}

function child_is_ready (eh) {                         /* line 383 */
    return ((((((((! ((0=== eh.outq.length))))) || (((! ((0=== eh.inq.length))))))) || (( eh.state!= "idle")))) || ((any_child_ready ( eh))));/* line 384 *//* line 385 *//* line 386 */
}

function append_routing_descriptor (container,desc) {  /* line 387 */
    container.routings.push ( desc)                    /* line 388 *//* line 389 *//* line 390 */
}

function injector (eh,mevent) {                        /* line 391 */
    eh.handler ( eh, mevent)                           /* line 392 *//* line 393 *//* line 394 */
}
                                                       /* line 395 *//* line 396 *//* line 397 */
class Component_Registry {
  constructor () {                                     /* line 398 */

    this.templates = {};                               /* line 399 *//* line 400 */
  }
}
                                                       /* line 401 */
class Template {
  constructor () {                                     /* line 402 */

    this.name =  null;                                 /* line 403 */
    this.template_data =  null;                        /* line 404 */
    this.instantiator =  null;                         /* line 405 *//* line 406 */
  }
}
                                                       /* line 407 */
function mkTemplate (name,template_data,instantiator) {/* line 408 */
    let  templ =  new Template ();                     /* line 409 */;
    templ.name =  name;                                /* line 410 */
    templ.template_data =  template_data;              /* line 411 */
    templ.instantiator =  instantiator;                /* line 412 */
    return  templ;                                     /* line 413 *//* line 414 *//* line 415 */
}
                                                       /* line 416 */
function lnet2internal_from_file (pathname,container_xml) {/* line 417 */
    let filename =   container_xml                     /* line 418 */;

    let jstr = undefined;
    if (filename == "0") {
    jstr = fs.readFileSync (0, { encoding: 'utf8'});
    } else if (pathname) {
    jstr = fs.readFileSync (`${pathname}/${filename}`, { encoding: 'utf8'});
    } else {
    jstr = fs.readFileSync (`${filename}`, { encoding: 'utf8'});
    }
    if (jstr) {
    return JSON.parse (jstr);
    } else {
    return undefined;
    }
                                                       /* line 419 *//* line 420 *//* line 421 */
}

function lnet2internal_from_string () {                /* line 422 */

    return JSON.parse (lnet);
                                                       /* line 423 *//* line 424 *//* line 425 */
}

function delete_decls (d) {                            /* line 426 *//* line 427 *//* line 428 *//* line 429 */
}

function make_component_registry () {                  /* line 430 */
    return  new Component_Registry ();                 /* line 431 */;/* line 432 *//* line 433 */
}

function register_component (reg,template) {
    return abstracted_register_component ( reg, template, false);/* line 434 */
}

function register_component_allow_overwriting (reg,template) {
    return abstracted_register_component ( reg, template, true);/* line 435 *//* line 436 */
}

function abstracted_register_component (reg,template,ok_to_overwrite) {/* line 437 */
    let name = mangle_name ( template.name)            /* line 438 */;
    if ((((((( reg!= null) && ( name))) in ( reg.templates))) && ((!  ok_to_overwrite)))) {/* line 439 */
      load_error ( ( "Component /".toString ()+  ( template.name.toString ()+  "/ already declared".toString ()) .toString ()) )/* line 440 */
      return  reg;                                     /* line 441 */
    }
    else {                                             /* line 442 */
      reg.templates [name] =  template;                /* line 443 */
      return  reg;                                     /* line 444 *//* line 445 */
    }                                                  /* line 446 *//* line 447 */
}

function get_component_instance (reg,full_name,owner) {/* line 448 */
    let template_name = mangle_name ( full_name)       /* line 449 */;
    if ((( template_name) in ( reg.templates))) {      /* line 450 */
      let template =  reg.templates [template_name];   /* line 451 */
      if (( template ==  null)) {                      /* line 452 */
        load_error ( ( "Registry Error (A): Can't find component /".toString ()+  ( template_name.toString ()+  "/".toString ()) .toString ()) )/* line 453 */
        return  null;                                  /* line 454 */
      }
      else {                                           /* line 455 */
        let owner_name =  "";                          /* line 456 */
        let instance_name =  template_name;            /* line 457 */
        if ( null!= owner) {                           /* line 458 */
          owner_name =  owner.name;                    /* line 459 */
          instance_name =  ( owner_name.toString ()+  ( "▹".toString ()+  template_name.toString ()) .toString ()) /* line 460 */;
        }
        else {                                         /* line 461 */
          instance_name =  template_name;              /* line 462 *//* line 463 */
        }
        let instance =  template.instantiator ( reg, owner, instance_name, template.template_data)/* line 464 */;
        return  instance;                              /* line 465 *//* line 466 */
      }
    }
    else {                                             /* line 467 */
      load_error ( ( "Registry Error (B): Can't find component /".toString ()+  ( template_name.toString ()+  "/".toString ()) .toString ()) )/* line 468 */
      return  null;                                    /* line 469 *//* line 470 */
    }                                                  /* line 471 *//* line 472 */
}

function mangle_name (s) {                             /* line 473 */
    /*  trim name to remove code from Container component names _ deferred until later (or never) *//* line 474 */
    return  s;                                         /* line 475 *//* line 476 *//* line 477 */
}
                                                       /* line 478 */
/*  Data for an asyncronous component _ effectively, a function with input *//* line 479 */
/*  and output queues of mevents. */                   /* line 480 */
/*  */                                                 /* line 481 */
/*  Components can either be a user_supplied function (“lea“), or a “container“ *//* line 482 */
/*  that routes mevents to child components according to a list of connections *//* line 483 */
/*  that serve as a mevent routing table. */           /* line 484 */
/*  */                                                 /* line 485 */
/*  Child components themselves can be leaves or other containers. *//* line 486 */
/*  */                                                 /* line 487 */
/*  `handler` invokes the code that is attached to this component. *//* line 488 */
/*  */                                                 /* line 489 */
/*  `instance_data` is a pointer to instance data that the `leaf_handler` *//* line 490 */
/*  function may want whenever it is invoked again. */ /* line 491 */
/*  */                                                 /* line 492 *//* line 493 */
/*  Eh_States :: enum { idle, active } */              /* line 494 */
class Eh {
  constructor () {                                     /* line 495 */

    this.name =  "";                                   /* line 496 */
    this.inq =  []                                     /* line 497 */;
    this.outq =  []                                    /* line 498 */;
    this.owner =  null;                                /* line 499 */
    this.children = [];                                /* line 500 */
    this.visit_ordering =  []                          /* line 501 */;
    this.connections = [];                             /* line 502 */
    this.routings =  []                                /* line 503 */;
    this.handler =  null;                              /* line 504 */
    this.finject =  null;                              /* line 505 */
    this.instance_data =  null;                        /* line 506 */
    this.state =  "idle";                              /* line 507 *//*  bootstrap debugging *//* line 508 */
    this.kind =  null;/*  enum { container, leaf, } */ /* line 509 *//* line 510 */
  }
}
                                                       /* line 511 */
/*  Creates a component that acts as a container. It is the same as a `Eh` instance *//* line 512 */
/*  whose handler function is `container_handler`. */  /* line 513 */
function make_container (name,owner) {                 /* line 514 */
    let  eh =  new Eh ();                              /* line 515 */;
    eh.name =  name;                                   /* line 516 */
    eh.owner =  owner;                                 /* line 517 */
    eh.handler =  container_handler;                   /* line 518 */
    eh.finject =  injector;                            /* line 519 */
    eh.state =  "idle";                                /* line 520 */
    eh.kind =  "container";                            /* line 521 */
    return  eh;                                        /* line 522 *//* line 523 *//* line 524 */
}

/*  Creates a new leaf component out of a handler function, and a data parameter *//* line 525 */
/*  that will be passed back to your handler when called. *//* line 526 *//* line 527 */
function make_leaf (name,owner,instance_data,handler) {/* line 528 */
    let  eh =  new Eh ();                              /* line 529 */;
    let  nm =  "";                                     /* line 530 */
    if ( null!= owner) {                               /* line 531 */
      nm =  owner.name;                                /* line 532 *//* line 533 */
    }
    eh.name =  ( nm.toString ()+  ( "▹".toString ()+  name.toString ()) .toString ()) /* line 534 */;
    eh.owner =  owner;                                 /* line 535 */
    eh.handler =  handler;                             /* line 536 */
    eh.finject =  injector;                            /* line 537 */
    eh.instance_data =  instance_data;                 /* line 538 */
    eh.state =  "idle";                                /* line 539 */
    eh.kind =  "leaf";                                 /* line 540 */
    return  eh;                                        /* line 541 *//* line 542 *//* line 543 */
}

/*  Sends a mevent on the given `port` with `data`, placing it on the output *//* line 544 */
/*  of the given component. */                         /* line 545 *//* line 546 */
function send (eh,port,obj,causingMevent) {            /* line 547 */
    let  d = Datum ();                                 /* line 548 */
    d.v =  obj;                                        /* line 549 */
    d.clone =  function () {return obj_clone ( d)      /* line 550 */;};
    d.reclaim =  None;                                 /* line 551 */
    let mev = make_mevent ( port, d)                   /* line 552 */;
    put_output ( eh, mev)                              /* line 553 *//* line 554 *//* line 555 */
}

function forward (eh,port,mev) {                       /* line 556 */
    let fwdmev = make_mevent ( port, mev.datum)        /* line 557 */;
    put_output ( eh, fwdmev)                           /* line 558 *//* line 559 *//* line 560 */
}

function inject (eh,mev) {                             /* line 561 */
    eh.finject ( eh, mev)                              /* line 562 *//* line 563 *//* line 564 */
}

function set_active (eh) {                             /* line 565 */
    eh.state =  "active";                              /* line 566 *//* line 567 *//* line 568 */
}

function set_idle (eh) {                               /* line 569 */
    eh.state =  "idle";                                /* line 570 *//* line 571 *//* line 572 */
}

function put_output (eh,mev) {                         /* line 573 */
    eh.outq.push ( mev)                                /* line 574 *//* line 575 *//* line 576 */
}

let  projectRoot =  "";                                /* line 577 *//* line 578 */
function set_environment (project_root) {              /* line 579 *//* line 580 */
    projectRoot =  project_root;                       /* line 581 *//* line 582 *//* line 583 */
}

function obj_clone (obj) {                             /* line 584 */
    return  obj;                                       /* line 585 *//* line 586 *//* line 587 */
}

/*  usage: app ${_00_} diagram_filename1 diagram_filename2 ... *//* line 588 */
/*  where ${_00_} is the root directory for the project *//* line 589 *//* line 590 */
function initialize_component_palette_from_files (project_root,diagram_source_files) {/* line 591 */
    let  reg = make_component_registry ();             /* line 592 */
    for (let diagram_source of  diagram_source_files) {/* line 593 */
      let all_containers_within_single_file = lnet2internal_from_file ( project_root, diagram_source)/* line 594 */;
      reg = generate_shell_components ( reg, all_containers_within_single_file)/* line 595 */;
      for (let container of  all_containers_within_single_file) {/* line 596 */
        register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 597 *//* line 598 */
      }                                                /* line 599 */
    }
    initialize_stock_components ( reg)                 /* line 600 */
    return  reg;                                       /* line 601 *//* line 602 *//* line 603 */
}

function initialize_component_palette_from_string (project_root) {/* line 604 */
    /*  this version ignores project_root  */          /* line 605 */
    let  reg = make_component_registry ();             /* line 606 */
    let all_containers = lnet2internal_from_string (); /* line 607 */
    reg = generate_shell_components ( reg, all_containers)/* line 608 */;
    for (let container of  all_containers) {           /* line 609 */
      register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 610 *//* line 611 */
    }
    initialize_stock_components ( reg)                 /* line 612 */
    return  reg;                                       /* line 613 *//* line 614 *//* line 615 */
}
                                                       /* line 616 */
function clone_string (s) {                            /* line 617 */
    return  s                                          /* line 618 *//* line 619 */;/* line 620 */
}

let  load_errors =  false;                             /* line 621 */
let  runtime_errors =  false;                          /* line 622 *//* line 623 */
function load_error (s) {                              /* line 624 *//* line 625 */
    console.error ( s);                                /* line 626 */
                                                       /* line 627 */
    load_errors =  true;                               /* line 628 *//* line 629 *//* line 630 */
}

function runtime_error (s) {                           /* line 631 *//* line 632 */
    console.error ( s);                                /* line 633 */
    runtime_errors =  true;                            /* line 634 *//* line 635 *//* line 636 */
}
                                                       /* line 637 */
function initialize_from_files (project_root,diagram_names) {/* line 638 */
    let arg =  null;                                   /* line 639 */
    let palette = initialize_component_palette_from_files ( project_root, diagram_names)/* line 640 */;
    return [ palette,[ project_root, diagram_names, arg]];/* line 641 *//* line 642 *//* line 643 */
}

function initialize_from_string (project_root) {       /* line 644 */
    let arg =  null;                                   /* line 645 */
    let palette = initialize_component_palette_from_string ( project_root)/* line 646 */;
    return [ palette,[ project_root, null, arg]];      /* line 647 *//* line 648 *//* line 649 */
}

function start (arg,Part_name,palette,env) {           /* line 650 */
    let project_root =  env [ 0];                      /* line 651 */
    let diagram_names =  env [ 1];                     /* line 652 */
    set_environment ( project_root)                    /* line 653 */
    /*  get entrypoint container */                    /* line 654 */
    let  Part = get_component_instance ( palette, Part_name, null)/* line 655 */;
    if ( null ==  Part) {                              /* line 656 */
      load_error ( ( "Couldn't find container with page name /".toString ()+  ( Part_name.toString ()+  ( "/ in files ".toString ()+  (`${ diagram_names}`.toString ()+  " (check tab names, or disable compression?)".toString ()) .toString ()) .toString ()) .toString ()) )/* line 660 *//* line 661 */
    }
    if ((!  load_errors)) {                            /* line 662 */
      let  d = Datum ();                               /* line 663 */
      d.v =  arg;                                      /* line 664 */
      d.clone =  function () {return obj_clone ( d)    /* line 665 */;};
      d.reclaim =  None;                               /* line 666 */
      let  mev = make_mevent ( "", d)                  /* line 667 */;
      inject ( Part, mev)                              /* line 668 *//* line 669 */
    }                                                  /* line 670 *//* line 671 */
}
                                                       /* line 672 */

/*  this needs to be rewritten to use the low_level "shell_out“ component, this can be done solely as a diagram without using python code here *//* line 1 */
function shell_out_instantiate (reg,owner,name,template_data) {/* line 2 */
    let name_with_id = gensymbol ( "shell_out")        /* line 3 */;
    let cmd =  template_data.split (" ")               /* line 4 */;
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)/* line 5 */;/* line 6 *//* line 7 */
}

function shell_out_handler (eh,msg) {                  /* line 8 */
    let cmd =  eh.instance_data;                       /* line 9 */
    let s =  msg.datum.v;                              /* line 10 */
    let  ret =  null;                                  /* line 11 */
    let  rc =  null;                                   /* line 12 */
    let  stdout =  null;                               /* line 13 */
    let  stderr =  null;                               /* line 14 */

    stdout = execSync(`${ cmd} ${ s}`, { encoding: 'utf-8' });
    ret = true;
                                                       /* line 15 */
    if ( rc ==  0) {                                   /* line 16 */
      send ( eh, "", ( stdout.toString ()+  stderr.toString ()) , msg)/* line 17 */
    }
    else {                                             /* line 18 */
      send ( eh, "✗", ( stdout.toString ()+  stderr.toString ()) , msg)/* line 19 *//* line 20 */
    }                                                  /* line 21 *//* line 22 */
}

function generate_shell_components (reg,container_list) {/* line 23 */
    /*  [ */                                           /* line 24 */
    /*      {;file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 25 */
    /*      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} *//* line 26 */
    /*  ] */                                           /* line 27 */
    if ( null!= container_list) {                      /* line 28 */
      for (let diagram of  container_list) {           /* line 29 */
        /*  loop through every component in the diagram and look for names that start with “$“ or “'“  *//* line 30 */
        /*  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 31 */
        for (let child_descriptor of  diagram [ "children"]) {/* line 32 */
          if (first_char_is ( child_descriptor [ "name"], "$")) {/* line 33 */
            let name =  child_descriptor [ "name"];    /* line 34 */
            let cmd =   name.substring (1) .strip ();  /* line 35 */
            let generated_leaf = mkTemplate ( name, cmd, shell_out_instantiate)/* line 36 */;
            register_component ( reg, generated_leaf)  /* line 37 */
          }
          else if (first_char_is ( child_descriptor [ "name"], "'")) {/* line 38 */
            let name =  child_descriptor [ "name"];    /* line 39 */
            let s =   name.substring (1)               /* line 40 */;
            let generated_leaf = mkTemplate ( name, s, string_constant_instantiate)/* line 41 */;
            register_component_allow_overwriting ( reg, generated_leaf)/* line 42 *//* line 43 */
          }                                            /* line 44 */
        }                                              /* line 45 */
      }                                                /* line 46 */
    }
    return  reg;                                       /* line 47 *//* line 48 *//* line 49 */
}

function first_char (s) {                              /* line 50 */
    return   s[0]                                      /* line 51 */;/* line 52 *//* line 53 */
}

function first_char_is (s,c) {                         /* line 54 */
    return  c == first_char ( s)                       /* line 55 */;/* line 56 *//* line 57 */
}
                                                       /* line 58 */
/*  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here *//* line 59 */
/*  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped *//* line 60 *//* line 61 */

function probeA_instantiate (reg,owner,name,template_data) {/* line 1 */
    let name_with_id = gensymbol ( "?A")               /* line 2 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 3 */;/* line 4 *//* line 5 */
}

function probeB_instantiate (reg,owner,name,template_data) {/* line 6 */
    let name_with_id = gensymbol ( "?B")               /* line 7 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 8 */;/* line 9 *//* line 10 */
}

function probeC_instantiate (reg,owner,name,template_data) {/* line 11 */
    let name_with_id = gensymbol ( "?C")               /* line 12 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 13 */;/* line 14 *//* line 15 */
}

function probe_handler (eh,mev) {                      /* line 16 *//* line 17 */
    let s =  mev.datum.v;                              /* line 18 */
    live_update ( "Info",  ( "  @".toString ()+  (`${ ticktime}`.toString ()+  ( "  ".toString ()+  ( "probe ".toString ()+  ( eh.name.toString ()+  ( ": ".toString ()+   s.toString ()) .toString ()) .toString ()) .toString ()) .toString ()) .toString ()) )/* line 26 *//* line 27 *//* line 28 */
}

function trash_instantiate (reg,owner,name,template_data) {/* line 29 */
    let name_with_id = gensymbol ( "trash")            /* line 30 */;
    return make_leaf ( name_with_id, owner, null, trash_handler)/* line 31 */;/* line 32 *//* line 33 */
}

function trash_handler (eh,mev) {                      /* line 34 */
    /*  to appease dumped_on_floor checker */          /* line 35 *//* line 36 *//* line 37 */
}

class TwoMevents {
  constructor () {                                     /* line 38 */

    this.firstmev =  null;                             /* line 39 */
    this.secondmev =  null;                            /* line 40 *//* line 41 */
  }
}
                                                       /* line 42 */
/*  Deracer_States :: enum { idle, waitingForFirstmev, waitingForSecondmev } *//* line 43 */
class Deracer_Instance_Data {
  constructor () {                                     /* line 44 */

    this.state =  null;                                /* line 45 */
    this.buffer =  null;                               /* line 46 *//* line 47 */
  }
}
                                                       /* line 48 */
function reclaim_Buffers_from_heap (inst) {            /* line 49 *//* line 50 *//* line 51 *//* line 52 */
}

function deracer_instantiate (reg,owner,name,template_data) {/* line 53 */
    let name_with_id = gensymbol ( "deracer")          /* line 54 */;
    let  inst =  new Deracer_Instance_Data ();         /* line 55 */;
    inst.state =  "idle";                              /* line 56 */
    inst.buffer =  new TwoMevents ();                  /* line 57 */;
    let eh = make_leaf ( name_with_id, owner, inst, deracer_handler)/* line 58 */;
    return  eh;                                        /* line 59 *//* line 60 *//* line 61 */
}

function send_firstmev_then_secondmev (eh,inst) {      /* line 62 */
    forward ( eh, "1", inst.buffer.firstmev)           /* line 63 */
    forward ( eh, "2", inst.buffer.secondmev)          /* line 64 */
    reclaim_Buffers_from_heap ( inst)                  /* line 65 *//* line 66 *//* line 67 */
}

function deracer_handler (eh,mev) {                    /* line 68 */
    let  inst =  eh.instance_data;                     /* line 69 */
    if ( inst.state ==  "idle") {                      /* line 70 */
      if ( "1" ==  mev.port) {                         /* line 71 */
        inst.buffer.firstmev =  mev;                   /* line 72 */
        inst.state =  "waitingForSecondmev";           /* line 73 */
      }
      else if ( "2" ==  mev.port) {                    /* line 74 */
        inst.buffer.secondmev =  mev;                  /* line 75 */
        inst.state =  "waitingForFirstmev";            /* line 76 */
      }
      else {                                           /* line 77 */
        runtime_error ( ( "bad mev.port (case A) for deracer ".toString ()+  mev.port.toString ()) )/* line 78 *//* line 79 */
      }
    }
    else if ( inst.state ==  "waitingForFirstmev") {   /* line 80 */
      if ( "1" ==  mev.port) {                         /* line 81 */
        inst.buffer.firstmev =  mev;                   /* line 82 */
        send_firstmev_then_secondmev ( eh, inst)       /* line 83 */
        inst.state =  "idle";                          /* line 84 */
      }
      else {                                           /* line 85 */
        runtime_error ( ( "bad mev.port (case B) for deracer ".toString ()+  mev.port.toString ()) )/* line 86 *//* line 87 */
      }
    }
    else if ( inst.state ==  "waitingForSecondmev") {  /* line 88 */
      if ( "2" ==  mev.port) {                         /* line 89 */
        inst.buffer.secondmev =  mev;                  /* line 90 */
        send_firstmev_then_secondmev ( eh, inst)       /* line 91 */
        inst.state =  "idle";                          /* line 92 */
      }
      else {                                           /* line 93 */
        runtime_error ( ( "bad mev.port (case C) for deracer ".toString ()+  mev.port.toString ()) )/* line 94 *//* line 95 */
      }
    }
    else {                                             /* line 96 */
      runtime_error ( "bad state for deracer {eh.state}")/* line 97 *//* line 98 */
    }                                                  /* line 99 *//* line 100 */
}

function low_level_read_text_file_instantiate (reg,owner,name,template_data) {/* line 101 */
    let name_with_id = gensymbol ( "Low Level Read Text File")/* line 102 */;
    return make_leaf ( name_with_id, owner, null, low_level_read_text_file_handler)/* line 103 */;/* line 104 *//* line 105 */
}

function low_level_read_text_file_handler (eh,mev) {   /* line 106 */
    let fname =  mev.datum.v;                          /* line 107 */

    if (fname == "0") {
    data = fs.readFileSync (0, { encoding: 'utf8'});
    } else {
    data = fs.readFileSync (fname, { encoding: 'utf8'});
    }
    if (data) {
      send_string (eh, "", data, mev);
    } else {
      send_string (eh, "✗", `read error on file '${fname}'`, mev);
    }
                                                       /* line 108 *//* line 109 *//* line 110 */
}

function ensure_string_datum_instantiate (reg,owner,name,template_data) {/* line 111 */
    let name_with_id = gensymbol ( "Ensure String Datum")/* line 112 */;
    return make_leaf ( name_with_id, owner, null, ensure_string_datum_handler)/* line 113 */;/* line 114 *//* line 115 */
}

function ensure_string_datum_handler (eh,mev) {        /* line 116 */
    if ( "string" ==  mev.datum.kind ()) {             /* line 117 */
      forward ( eh, "", mev)                           /* line 118 */
    }
    else {                                             /* line 119 */
      let emev =  ( "*** ensure: type error (expected a string datum) but got ".toString ()+  mev.datum.toString ()) /* line 120 */;
      send ( eh, "✗", emev, mev)                       /* line 121 *//* line 122 */
    }                                                  /* line 123 *//* line 124 */
}

class Syncfilewrite_Data {
  constructor () {                                     /* line 125 */

    this.filename =  "";                               /* line 126 *//* line 127 */
  }
}
                                                       /* line 128 */
/*  temp copy for bootstrap, sends "done“ (error during bootstrap if not wired) *//* line 129 */
function syncfilewrite_instantiate (reg,owner,name,template_data) {/* line 130 */
    let name_with_id = gensymbol ( "syncfilewrite")    /* line 131 */;
    let inst =  new Syncfilewrite_Data ();             /* line 132 */;
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)/* line 133 */;/* line 134 *//* line 135 */
}

function syncfilewrite_handler (eh,mev) {              /* line 136 */
    let  inst =  eh.instance_data;                     /* line 137 */
    if ( "filename" ==  mev.port) {                    /* line 138 */
      inst.filename =  mev.datum.v;                    /* line 139 */
    }
    else if ( "input" ==  mev.port) {                  /* line 140 */
      let contents =  mev.datum.v;                     /* line 141 */
      let  f = open ( inst.filename, "w")              /* line 142 */;
      if ( f!= null) {                                 /* line 143 */
        f.write ( mev.datum.v)                         /* line 144 */
        f.close ()                                     /* line 145 */
        send ( eh, "done",new_datum_bang (), mev)      /* line 146 */
      }
      else {                                           /* line 147 */
        send ( eh, "✗", ( "open error on file ".toString ()+  inst.filename.toString ()) , mev)/* line 148 *//* line 149 */
      }                                                /* line 150 */
    }                                                  /* line 151 *//* line 152 */
}

class StringConcat_Instance_Data {
  constructor () {                                     /* line 153 */

    this.buffer1 =  null;                              /* line 154 */
    this.buffer2 =  null;                              /* line 155 *//* line 156 */
  }
}
                                                       /* line 157 */
function stringconcat_instantiate (reg,owner,name,template_data) {/* line 158 */
    let name_with_id = gensymbol ( "stringconcat")     /* line 159 */;
    let instp =  new StringConcat_Instance_Data ();    /* line 160 */;
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)/* line 161 */;/* line 162 *//* line 163 */
}

function stringconcat_handler (eh,mev) {               /* line 164 */
    let  inst =  eh.instance_data;                     /* line 165 */
    if ( "1" ==  mev.port) {                           /* line 166 */
      inst.buffer1 = clone_string ( mev.datum.v)       /* line 167 */;
      maybe_stringconcat ( eh, inst, mev)              /* line 168 */
    }
    else if ( "2" ==  mev.port) {                      /* line 169 */
      inst.buffer2 = clone_string ( mev.datum.v)       /* line 170 */;
      maybe_stringconcat ( eh, inst, mev)              /* line 171 */
    }
    else if ( "reset" ==  mev.port) {                  /* line 172 */
      inst.buffer1 =  null;                            /* line 173 */
      inst.buffer2 =  null;                            /* line 174 */
    }
    else {                                             /* line 175 */
      runtime_error ( ( "bad mev.port for stringconcat: ".toString ()+  mev.port.toString ()) )/* line 176 *//* line 177 */
    }                                                  /* line 178 *//* line 179 */
}

function maybe_stringconcat (eh,inst,mev) {            /* line 180 */
    if ((( inst.buffer1!= null) && ( inst.buffer2!= null))) {/* line 181 */
      let  concatenated_string =  "";                  /* line 182 */
      if ( 0 == ( inst.buffer1.length)) {              /* line 183 */
        concatenated_string =  inst.buffer2;           /* line 184 */
      }
      else if ( 0 == ( inst.buffer2.length)) {         /* line 185 */
        concatenated_string =  inst.buffer1;           /* line 186 */
      }
      else {                                           /* line 187 */
        concatenated_string =  inst.buffer1+ inst.buffer2;/* line 188 *//* line 189 */
      }
      send ( eh, "", concatenated_string, mev)         /* line 190 */
      inst.buffer1 =  null;                            /* line 191 */
      inst.buffer2 =  null;                            /* line 192 *//* line 193 */
    }                                                  /* line 194 *//* line 195 */
}

/*  */                                                 /* line 196 *//* line 197 */
function string_constant_instantiate (reg,owner,name,template_data) {/* line 198 *//* line 199 */
    let name_with_id = gensymbol ( "strconst")         /* line 200 */;
    let  s =  template_data;                           /* line 201 */
    if ( projectRoot!= "") {                           /* line 202 */
      s =  s.replaceAll ( "_00_",  projectRoot)        /* line 203 */;/* line 204 */
    }
    return make_leaf ( name_with_id, owner, s, string_constant_handler)/* line 205 */;/* line 206 *//* line 207 */
}

function string_constant_handler (eh,mev) {            /* line 208 */
    let s =  eh.instance_data;                         /* line 209 */
    send ( eh, "", s, mev)                             /* line 210 *//* line 211 *//* line 212 */
}

function fakepipename_instantiate (reg,owner,name,template_data) {/* line 213 */
    let instance_name = gensymbol ( "fakepipe")        /* line 214 */;
    return make_leaf ( instance_name, owner, null, fakepipename_handler)/* line 215 */;/* line 216 *//* line 217 */
}

let  rand =  0;                                        /* line 218 *//* line 219 */
function fakepipename_handler (eh,mev) {               /* line 220 *//* line 221 */
    rand =  rand+ 1;
    /*  not very random, but good enough _ ;rand' must be unique within a single run *//* line 222 */
    send ( eh, "", ( "/tmp/fakepipe".toString ()+  rand.toString ()) , mev)/* line 223 *//* line 224 *//* line 225 */
}
                                                       /* line 226 */
class Switch1star_Instance_Data {
  constructor () {                                     /* line 227 */

    this.state =  "1";                                 /* line 228 *//* line 229 */
  }
}
                                                       /* line 230 */
function switch1star_instantiate (reg,owner,name,template_data) {/* line 231 */
    let name_with_id = gensymbol ( "switch1*")         /* line 232 */;
    let instp =  new Switch1star_Instance_Data ();     /* line 233 */;
    return make_leaf ( name_with_id, owner, instp, switch1star_handler)/* line 234 */;/* line 235 *//* line 236 */
}

function switch1star_handler (eh,mev) {                /* line 237 */
    let  inst =  eh.instance_data;                     /* line 238 */
    let whichOutput =  inst.state;                     /* line 239 */
    if ( "" ==  mev.port) {                            /* line 240 */
      if ( "1" ==  whichOutput) {                      /* line 241 */
        forward ( eh, "1", mev)                        /* line 242 */
        inst.state =  "*";                             /* line 243 */
      }
      else if ( "*" ==  whichOutput) {                 /* line 244 */
        forward ( eh, "*", mev)                        /* line 245 */
      }
      else {                                           /* line 246 */
        send ( eh, "✗", "internal error bad state in switch1*", mev)/* line 247 *//* line 248 */
      }
    }
    else if ( "reset" ==  mev.port) {                  /* line 249 */
      inst.state =  "1";                               /* line 250 */
    }
    else {                                             /* line 251 */
      send ( eh, "✗", "internal error bad mevent for switch1*", mev)/* line 252 *//* line 253 */
    }                                                  /* line 254 *//* line 255 */
}

class StringAccumulator {
  constructor () {                                     /* line 256 */

    this.s =  "";                                      /* line 257 *//* line 258 */
  }
}
                                                       /* line 259 */
function strcatstar_instantiate (reg,owner,name,template_data) {/* line 260 */
    let name_with_id = gensymbol ( "String Concat *")  /* line 261 */;
    let instp =  new StringAccumulator ();             /* line 262 */;
    return make_leaf ( name_with_id, owner, instp, strcatstar_handler)/* line 263 */;/* line 264 *//* line 265 */
}

function strcatstar_handler (eh,mev) {                 /* line 266 */
    let  accum =  eh.instance_data;                    /* line 267 */
    if ( "" ==  mev.port) {                            /* line 268 */
      accum.s =  ( accum.s.toString ()+  mev.datum.v.toString ()) /* line 269 */;
    }
    else if ( "fini" ==  mev.port) {                   /* line 270 */
      send ( eh, "", accum.s, mev)                     /* line 271 */
    }
    else {                                             /* line 272 */
      send ( eh, "✗", "internal error bad mevent for String Concat *", mev)/* line 273 *//* line 274 */
    }                                                  /* line 275 *//* line 276 */
}

/*  all of the the built_in leaves are listed here */  /* line 277 */
/*  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project *//* line 278 *//* line 279 */
function initialize_stock_components (reg) {           /* line 280 */
    register_component ( reg,mkTemplate ( "1then2", null, deracer_instantiate))/* line 281 */
    register_component ( reg,mkTemplate ( "?A", null, probeA_instantiate))/* line 282 */
    register_component ( reg,mkTemplate ( "?B", null, probeB_instantiate))/* line 283 */
    register_component ( reg,mkTemplate ( "?C", null, probeC_instantiate))/* line 284 */
    register_component ( reg,mkTemplate ( "trash", null, trash_instantiate))/* line 285 *//* line 286 *//* line 287 */
    register_component ( reg,mkTemplate ( "Read Text File", null, low_level_read_text_file_instantiate))/* line 288 */
    register_component ( reg,mkTemplate ( "Ensure String Datum", null, ensure_string_datum_instantiate))/* line 289 *//* line 290 */
    register_component ( reg,mkTemplate ( "syncfilewrite", null, syncfilewrite_instantiate))/* line 291 */
    register_component ( reg,mkTemplate ( "stringconcat", null, stringconcat_instantiate))/* line 292 */
    register_component ( reg,mkTemplate ( "switch1*", null, switch1star_instantiate))/* line 293 */
    register_component ( reg,mkTemplate ( "String Concat *", null, strcatstar_instantiate))/* line 294 */
    /*  for fakepipe */                                /* line 295 */
    register_component ( reg,mkTemplate ( "fakepipename", null, fakepipename_instantiate))/* line 296 *//* line 297 *//* line 298 */
}import * as fs from 'fs';
import path from 'path';
import execSync from 'child_process';
                                                       /* line 1 *//* line 2 */
let  counter =  0;                                     /* line 3 */
let  ticktime =  0;                                    /* line 4 *//* line 5 */
let  digits = [ "₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀", "₂₁", "₂₂", "₂₃", "₂₄", "₂₅", "₂₆", "₂₇", "₂₈", "₂₉"];/* line 12 *//* line 13 *//* line 14 */
function gensymbol (s) {                               /* line 15 *//* line 16 */
    let name_with_id =  ( s.toString ()+ subscripted_digit ( counter).toString ()) /* line 17 */;
    counter =  counter+ 1;                             /* line 18 */
    return  name_with_id;                              /* line 19 *//* line 20 *//* line 21 */
}

function subscripted_digit (n) {                       /* line 22 *//* line 23 */
    if (((( n >=  0) && ( n <=  29)))) {               /* line 24 */
      return  digits [ n];                             /* line 25 */
    }
    else {                                             /* line 26 */
      return  ( "₊".toString ()+ `${ n}`.toString ())  /* line 27 */;/* line 28 */
    }                                                  /* line 29 *//* line 30 */
}

class Datum {
  constructor () {                                     /* line 31 */

    this.v =  null;                                    /* line 32 */
    this.clone =  null;                                /* line 33 */
    this.reclaim =  null;                              /* line 34 */
    this.other =  null;/*  reserved for use on per-project basis  *//* line 35 *//* line 36 */
  }
}
                                                       /* line 37 *//* line 38 */
/*  Mevent passed to a leaf component. */              /* line 39 */
/*  */                                                 /* line 40 */
/*  `port` refers to the name of the incoming or outgoing port of this component. *//* line 41 */
/*  `payload` is the data attached to this mevent. */  /* line 42 */
class Mevent {
  constructor () {                                     /* line 43 */

    this.port =  null;                                 /* line 44 */
    this.datum =  null;                                /* line 45 *//* line 46 */
  }
}
                                                       /* line 47 */
function clone_port (s) {                              /* line 48 */
    return clone_string ( s)                           /* line 49 */;/* line 50 *//* line 51 */
}

/*  Utility for making a `Mevent`. Used to safely "seed“ mevents *//* line 52 */
/*  entering the very top of a network. */             /* line 53 */
function make_mevent (port,datum) {                    /* line 54 */
    let p = clone_string ( port)                       /* line 55 */;
    let  m =  new Mevent ();                           /* line 56 */;
    m.port =  p;                                       /* line 57 */
    m.datum =  datum.clone ();                         /* line 58 */
    return  m;                                         /* line 59 *//* line 60 *//* line 61 */
}

/*  Clones a mevent. Primarily used internally for “fanning out“ a mevent to multiple destinations. *//* line 62 */
function mevent_clone (mev) {                          /* line 63 */
    let  m =  new Mevent ();                           /* line 64 */;
    m.port = clone_port ( mev.port)                    /* line 65 */;
    m.datum =  mev.datum.clone ();                     /* line 66 */
    return  m;                                         /* line 67 *//* line 68 *//* line 69 */
}

/*  Frees a mevent. */                                 /* line 70 */
function destroy_mevent (mev) {                        /* line 71 */
    /*  during debug, dont destroy any mevent, since we want to trace mevents, thus, we need to persist ancestor mevents *//* line 72 *//* line 73 *//* line 74 *//* line 75 */
}

function destroy_datum (mev) {                         /* line 76 *//* line 77 *//* line 78 *//* line 79 */
}

function destroy_port (mev) {                          /* line 80 *//* line 81 *//* line 82 *//* line 83 */
}

/*  */                                                 /* line 84 */
function format_mevent (m) {                           /* line 85 */
    if ( m ==  null) {                                 /* line 86 */
      return  "{}";                                    /* line 87 */
    }
    else {                                             /* line 88 */
      return  ( "{%5C”".toString ()+  ( m.port.toString ()+  ( "%5C”:%5C”".toString ()+  ( m.datum.v.toString ()+  "%5C”}".toString ()) .toString ()) .toString ()) .toString ()) /* line 89 */;/* line 90 */
    }                                                  /* line 91 */
}

function format_mevent_raw (m) {                       /* line 92 */
    if ( m ==  null) {                                 /* line 93 */
      return  "";                                      /* line 94 */
    }
    else {                                             /* line 95 */
      return  m.datum.v;                               /* line 96 *//* line 97 */
    }                                                  /* line 98 *//* line 99 */
}

const  enumDown =  0                                   /* line 100 */;
const  enumAcross =  1                                 /* line 101 */;
const  enumUp =  2                                     /* line 102 */;
const  enumThrough =  3                                /* line 103 */;/* line 104 */
function create_down_connector (container,proto_conn,connectors,children_by_id) {/* line 105 */
    /*  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, *//* line 106 */
    let  connector =  new Connector ();                /* line 107 */;
    connector.direction =  "down";                     /* line 108 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 109 */;
    let target_proto =  proto_conn [ "target"];        /* line 110 */
    let id_proto =  target_proto [ "id"];              /* line 111 */
    let target_component =  children_by_id [id_proto]; /* line 112 */
    if (( target_component ==  null)) {                /* line 113 */
      load_error ( ( "internal error: .Down connection target internal error ".toString ()+ ( proto_conn [ "target"]) [ "name"].toString ()) )/* line 114 */
    }
    else {                                             /* line 115 */
      connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 116 */;/* line 117 */
    }
    return  connector;                                 /* line 118 *//* line 119 *//* line 120 */
}

function create_across_connector (container,proto_conn,connectors,children_by_id) {/* line 121 */
    let  connector =  new Connector ();                /* line 122 */;
    connector.direction =  "across";                   /* line 123 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 124 */
    let target_component =  children_by_id [(( proto_conn [ "target"]) [ "id"])];/* line 125 */
    if ( source_component ==  null) {                  /* line 126 */
      load_error ( ( "internal error: .Across connection source not ok ".toString ()+ ( proto_conn [ "source"]) [ "name"].toString ()) )/* line 127 */
    }
    else {                                             /* line 128 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 129 */;
      if ( target_component ==  null) {                /* line 130 */
        load_error ( ( "internal error: .Across connection target not ok ".toString ()+ ( proto_conn [ "target"]) [ "name"].toString ()) )/* line 131 */
      }
      else {                                           /* line 132 */
        connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 133 */;/* line 134 */
      }                                                /* line 135 */
    }
    return  connector;                                 /* line 136 *//* line 137 *//* line 138 */
}

function create_up_connector (container,proto_conn,connectors,children_by_id) {/* line 139 */
    let  connector =  new Connector ();                /* line 140 */;
    connector.direction =  "up";                       /* line 141 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 142 */
    if ( source_component ==  null) {                  /* line 143 */
      load_error ( ( "internal error: .Up connection source not ok ".toString ()+ ( proto_conn [ "source"]) [ "name"].toString ()) )/* line 144 */
    }
    else {                                             /* line 145 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 146 */;
      connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 147 */;/* line 148 */
    }
    return  connector;                                 /* line 149 *//* line 150 *//* line 151 */
}

function create_through_connector (container,proto_conn,connectors,children_by_id) {/* line 152 */
    let  connector =  new Connector ();                /* line 153 */;
    connector.direction =  "through";                  /* line 154 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 155 */;
    connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 156 */;
    return  connector;                                 /* line 157 *//* line 158 *//* line 159 */
}
                                                       /* line 160 */
function container_instantiator (reg,owner,container_name,desc) {/* line 161 *//* line 162 */
    let container = make_container ( container_name, owner)/* line 163 */;
    let children = [];                                 /* line 164 */
    let children_by_id = {};
    /*  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here *//* line 165 */
    /*  collect children */                            /* line 166 */
    for (let child_desc of  desc [ "children"]) {      /* line 167 */
      let child_instance = get_component_instance ( reg, child_desc [ "name"], container)/* line 168 */;
      children.push ( child_instance)                  /* line 169 */
      let id =  child_desc [ "id"];                    /* line 170 */
      children_by_id [id] =  child_instance;           /* line 171 *//* line 172 *//* line 173 */
    }
    container.children =  children;                    /* line 174 *//* line 175 */
    let connectors = [];                               /* line 176 */
    for (let proto_conn of  desc [ "connections"]) {   /* line 177 */
      let  connector =  new Connector ();              /* line 178 */;
      if ( proto_conn [ "dir"] ==  enumDown) {         /* line 179 */
        connectors.push (create_down_connector ( container, proto_conn, connectors, children_by_id)) /* line 180 */
      }
      else if ( proto_conn [ "dir"] ==  enumAcross) {  /* line 181 */
        connectors.push (create_across_connector ( container, proto_conn, connectors, children_by_id)) /* line 182 */
      }
      else if ( proto_conn [ "dir"] ==  enumUp) {      /* line 183 */
        connectors.push (create_up_connector ( container, proto_conn, connectors, children_by_id)) /* line 184 */
      }
      else if ( proto_conn [ "dir"] ==  enumThrough) { /* line 185 */
        connectors.push (create_through_connector ( container, proto_conn, connectors, children_by_id)) /* line 186 *//* line 187 */
      }                                                /* line 188 */
    }
    container.connections =  connectors;               /* line 189 */
    return  container;                                 /* line 190 *//* line 191 *//* line 192 */
}

/*  The default handler for container components. */   /* line 193 */
function container_handler (container,mevent) {        /* line 194 */
    route ( container, container, mevent)
    /*  references to 'self' are replaced by the container during instantiation *//* line 195 */
    while (any_child_ready ( container)) {             /* line 196 */
      step_children ( container, mevent)               /* line 197 */
    }                                                  /* line 198 *//* line 199 */
}

/*  Frees the given container and associated data. */  /* line 200 */
function destroy_container (eh) {                      /* line 201 *//* line 202 *//* line 203 *//* line 204 */
}

/*  Routing connection for a container component. The `direction` field has *//* line 205 */
/*  no affect on the default mevent routing system _ it is there for debugging *//* line 206 */
/*  purposes, or for reading by other tools. */        /* line 207 *//* line 208 */
class Connector {
  constructor () {                                     /* line 209 */

    this.direction =  null;/*  down, across, up, through *//* line 210 */
    this.sender =  null;                               /* line 211 */
    this.receiver =  null;                             /* line 212 *//* line 213 */
  }
}
                                                       /* line 214 */
/*  `Sender` is used to “pattern match“ which `Receiver` a mevent should go to, *//* line 215 */
/*  based on component ID (pointer) and port name. */  /* line 216 *//* line 217 */
class Sender {
  constructor () {                                     /* line 218 */

    this.name =  null;                                 /* line 219 */
    this.component =  null;                            /* line 220 */
    this.port =  null;                                 /* line 221 *//* line 222 */
  }
}
                                                       /* line 223 *//* line 224 *//* line 225 */
/*  `Receiver` is a handle to a destination queue, and a `port` name to assign *//* line 226 */
/*  to incoming mevents to this queue. */              /* line 227 *//* line 228 */
class Receiver {
  constructor () {                                     /* line 229 */

    this.name =  null;                                 /* line 230 */
    this.queue =  null;                                /* line 231 */
    this.port =  null;                                 /* line 232 */
    this.component =  null;                            /* line 233 *//* line 234 */
  }
}
                                                       /* line 235 */
function mkSender (name,component,port) {              /* line 236 */
    let  s =  new Sender ();                           /* line 237 */;
    s.name =  name;                                    /* line 238 */
    s.component =  component;                          /* line 239 */
    s.port =  port;                                    /* line 240 */
    return  s;                                         /* line 241 *//* line 242 *//* line 243 */
}

function mkReceiver (name,component,port,q) {          /* line 244 */
    let  r =  new Receiver ();                         /* line 245 */;
    r.name =  name;                                    /* line 246 */
    r.component =  component;                          /* line 247 */
    r.port =  port;                                    /* line 248 */
    /*  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. *//* line 249 */
    r.queue =  q;                                      /* line 250 */
    return  r;                                         /* line 251 *//* line 252 *//* line 253 */
}

/*  Checks if two senders match, by pointer equality and port name matching. *//* line 254 */
function sender_eq (s1,s2) {                           /* line 255 */
    let same_components = ( s1.component ==  s2.component);/* line 256 */
    let same_ports = ( s1.port ==  s2.port);           /* line 257 */
    return (( same_components) && ( same_ports));      /* line 258 *//* line 259 *//* line 260 */
}

/*  Delivers the given mevent to the receiver of this connector. *//* line 261 *//* line 262 */
function deposit (parent,conn,mevent) {                /* line 263 */
    let new_mevent = make_mevent ( conn.receiver.port, mevent.datum)/* line 264 */;
    push_mevent ( parent, conn.receiver.component, conn.receiver.queue, new_mevent)/* line 265 *//* line 266 *//* line 267 */
}

function force_tick (parent,eh) {                      /* line 268 */
    let tick_mev = make_mevent ( ".",new_datum_bang ())/* line 269 */;
    push_mevent ( parent, eh, eh.inq, tick_mev)        /* line 270 */
    return  tick_mev;                                  /* line 271 *//* line 272 *//* line 273 */
}

function push_mevent (parent,receiver,inq,m) {         /* line 274 */
    inq.push ( m)                                      /* line 275 */
    parent.visit_ordering.push ( receiver)             /* line 276 *//* line 277 *//* line 278 */
}

function is_self (child,container) {                   /* line 279 */
    /*  in an earlier version “self“ was denoted as ϕ *//* line 280 */
    return  child ==  container;                       /* line 281 *//* line 282 *//* line 283 */
}

function step_child (child,mev) {                      /* line 284 */
    let before_state =  child.state;                   /* line 285 */
    child.handler ( child, mev)                        /* line 286 */
    let after_state =  child.state;                    /* line 287 */
    return [(( before_state ==  "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state ==  "idle"))];/* line 290 *//* line 291 *//* line 292 */
}

function step_children (container,causingMevent) {     /* line 293 */
    container.state =  "idle";                         /* line 294 */
    for (let child of   container.visit_ordering) {    /* line 295 */
      /*  child = container represents self, skip it *//* line 296 */
      if (((! (is_self ( child, container))))) {       /* line 297 */
        if (((! ((0=== child.inq.length))))) {         /* line 298 */
          let mev =  child.inq.shift ()                /* line 299 */;
          let  began_long_run =  null;                 /* line 300 */
          let  continued_long_run =  null;             /* line 301 */
          let  ended_long_run =  null;                 /* line 302 */
          [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, mev)/* line 303 */;
          if ( began_long_run) {                       /* line 304 *//* line 305 */
          }
          else if ( continued_long_run) {              /* line 306 *//* line 307 */
          }
          else if ( ended_long_run) {                  /* line 308 *//* line 309 *//* line 310 */
          }
          destroy_mevent ( mev)                        /* line 311 */
        }
        else {                                         /* line 312 */
          if ( child.state!= "idle") {                 /* line 313 */
            let mev = force_tick ( container, child)   /* line 314 */;
            child.handler ( child, mev)                /* line 315 */
            destroy_mevent ( mev)                      /* line 316 *//* line 317 */
          }                                            /* line 318 */
        }                                              /* line 319 */
        if ( child.state ==  "active") {               /* line 320 */
          /*  if child remains active, then the container must remain active and must propagate “ticks“ to child *//* line 321 */
          container.state =  "active";                 /* line 322 *//* line 323 */
        }                                              /* line 324 */
        while (((! ((0=== child.outq.length))))) {     /* line 325 */
          let mev =  child.outq.shift ()               /* line 326 */;
          route ( container, child, mev)               /* line 327 */
          destroy_mevent ( mev)                        /* line 328 *//* line 329 */
        }                                              /* line 330 */
      }                                                /* line 331 */
    }                                                  /* line 332 *//* line 333 */
}

function attempt_tick (parent,eh) {                    /* line 334 */
    if ( eh.state!= "idle") {                          /* line 335 */
      force_tick ( parent, eh)                         /* line 336 *//* line 337 */
    }                                                  /* line 338 *//* line 339 */
}

function is_tick (mev) {                               /* line 340 */
    return  "." ==  mev.port
    /*  assume that any mevent that is sent to port "." is a tick  *//* line 341 */;/* line 342 *//* line 343 */
}

/*  Routes a single mevent to all matching destinations, according to *//* line 344 */
/*  the container's connection network. */             /* line 345 *//* line 346 */
function route (container,from_component,mevent) {     /* line 347 */
    let  was_sent =  false;
    /*  for checking that output went somewhere (at least during bootstrap) *//* line 348 */
    let  fromname =  "";                               /* line 349 *//* line 350 */
    ticktime =  ticktime+ 1;                           /* line 351 */
    if (is_tick ( mevent)) {                           /* line 352 */
      for (let child of  container.children) {         /* line 353 */
        attempt_tick ( container, child)               /* line 354 */
      }
      was_sent =  true;                                /* line 355 */
    }
    else {                                             /* line 356 */
      if (((! (is_self ( from_component, container))))) {/* line 357 */
        fromname =  from_component.name;               /* line 358 *//* line 359 */
      }
      let from_sender = mkSender ( fromname, from_component, mevent.port)/* line 360 */;/* line 361 */
      for (let connector of  container.connections) {  /* line 362 */
        if (sender_eq ( from_sender, connector.sender)) {/* line 363 */
          deposit ( container, connector, mevent)      /* line 364 */
          was_sent =  true;                            /* line 365 *//* line 366 */
        }                                              /* line 367 */
      }                                                /* line 368 */
    }
    if ((! ( was_sent))) {                             /* line 369 */
      live_update ( "✗",  ( container.name.toString ()+  ( ": mevent '".toString ()+  ( mevent.port.toString ()+  ( "' from ".toString ()+  ( fromname.toString ()+  " dropped on floor...".toString ()) .toString ()) .toString ()) .toString ()) .toString ()) )/* line 370 *//* line 371 */
    }                                                  /* line 372 *//* line 373 */
}

function any_child_ready (container) {                 /* line 374 */
    for (let child of  container.children) {           /* line 375 */
      if (child_is_ready ( child)) {                   /* line 376 */
        return  true;                                  /* line 377 *//* line 378 */
      }                                                /* line 379 */
    }
    return  false;                                     /* line 380 *//* line 381 *//* line 382 */
}

function child_is_ready (eh) {                         /* line 383 */
    return ((((((((! ((0=== eh.outq.length))))) || (((! ((0=== eh.inq.length))))))) || (( eh.state!= "idle")))) || ((any_child_ready ( eh))));/* line 384 *//* line 385 *//* line 386 */
}

function append_routing_descriptor (container,desc) {  /* line 387 */
    container.routings.push ( desc)                    /* line 388 *//* line 389 *//* line 390 */
}

function injector (eh,mevent) {                        /* line 391 */
    eh.handler ( eh, mevent)                           /* line 392 *//* line 393 *//* line 394 */
}
                                                       /* line 395 *//* line 396 *//* line 397 */
class Component_Registry {
  constructor () {                                     /* line 398 */

    this.templates = {};                               /* line 399 *//* line 400 */
  }
}
                                                       /* line 401 */
class Template {
  constructor () {                                     /* line 402 */

    this.name =  null;                                 /* line 403 */
    this.template_data =  null;                        /* line 404 */
    this.instantiator =  null;                         /* line 405 *//* line 406 */
  }
}
                                                       /* line 407 */
function mkTemplate (name,template_data,instantiator) {/* line 408 */
    let  templ =  new Template ();                     /* line 409 */;
    templ.name =  name;                                /* line 410 */
    templ.template_data =  template_data;              /* line 411 */
    templ.instantiator =  instantiator;                /* line 412 */
    return  templ;                                     /* line 413 *//* line 414 *//* line 415 */
}
                                                       /* line 416 */
function lnet2internal_from_file (pathname,container_xml) {/* line 417 */
    let filename =   container_xml                     /* line 418 */;

    let jstr = undefined;
    if (filename == "0") {
    jstr = fs.readFileSync (0, { encoding: 'utf8'});
    } else if (pathname) {
    jstr = fs.readFileSync (`${pathname}/${filename}`, { encoding: 'utf8'});
    } else {
    jstr = fs.readFileSync (`${filename}`, { encoding: 'utf8'});
    }
    if (jstr) {
    return JSON.parse (jstr);
    } else {
    return undefined;
    }
                                                       /* line 419 *//* line 420 *//* line 421 */
}

function lnet2internal_from_string () {                /* line 422 */

    return JSON.parse (lnet);
                                                       /* line 423 *//* line 424 *//* line 425 */
}

function delete_decls (d) {                            /* line 426 *//* line 427 *//* line 428 *//* line 429 */
}

function make_component_registry () {                  /* line 430 */
    return  new Component_Registry ();                 /* line 431 */;/* line 432 *//* line 433 */
}

function register_component (reg,template) {
    return abstracted_register_component ( reg, template, false);/* line 434 */
}

function register_component_allow_overwriting (reg,template) {
    return abstracted_register_component ( reg, template, true);/* line 435 *//* line 436 */
}

function abstracted_register_component (reg,template,ok_to_overwrite) {/* line 437 */
    let name = mangle_name ( template.name)            /* line 438 */;
    if ((((((( reg!= null) && ( name))) in ( reg.templates))) && ((!  ok_to_overwrite)))) {/* line 439 */
      load_error ( ( "Component /".toString ()+  ( template.name.toString ()+  "/ already declared".toString ()) .toString ()) )/* line 440 */
      return  reg;                                     /* line 441 */
    }
    else {                                             /* line 442 */
      reg.templates [name] =  template;                /* line 443 */
      return  reg;                                     /* line 444 *//* line 445 */
    }                                                  /* line 446 *//* line 447 */
}

function get_component_instance (reg,full_name,owner) {/* line 448 */
    let template_name = mangle_name ( full_name)       /* line 449 */;
    if ((( template_name) in ( reg.templates))) {      /* line 450 */
      let template =  reg.templates [template_name];   /* line 451 */
      if (( template ==  null)) {                      /* line 452 */
        load_error ( ( "Registry Error (A): Can't find component /".toString ()+  ( template_name.toString ()+  "/".toString ()) .toString ()) )/* line 453 */
        return  null;                                  /* line 454 */
      }
      else {                                           /* line 455 */
        let owner_name =  "";                          /* line 456 */
        let instance_name =  template_name;            /* line 457 */
        if ( null!= owner) {                           /* line 458 */
          owner_name =  owner.name;                    /* line 459 */
          instance_name =  ( owner_name.toString ()+  ( "▹".toString ()+  template_name.toString ()) .toString ()) /* line 460 */;
        }
        else {                                         /* line 461 */
          instance_name =  template_name;              /* line 462 *//* line 463 */
        }
        let instance =  template.instantiator ( reg, owner, instance_name, template.template_data)/* line 464 */;
        return  instance;                              /* line 465 *//* line 466 */
      }
    }
    else {                                             /* line 467 */
      load_error ( ( "Registry Error (B): Can't find component /".toString ()+  ( template_name.toString ()+  "/".toString ()) .toString ()) )/* line 468 */
      return  null;                                    /* line 469 *//* line 470 */
    }                                                  /* line 471 *//* line 472 */
}

function mangle_name (s) {                             /* line 473 */
    /*  trim name to remove code from Container component names _ deferred until later (or never) *//* line 474 */
    return  s;                                         /* line 475 *//* line 476 *//* line 477 */
}
                                                       /* line 478 */
/*  Data for an asyncronous component _ effectively, a function with input *//* line 479 */
/*  and output queues of mevents. */                   /* line 480 */
/*  */                                                 /* line 481 */
/*  Components can either be a user_supplied function (“lea“), or a “container“ *//* line 482 */
/*  that routes mevents to child components according to a list of connections *//* line 483 */
/*  that serve as a mevent routing table. */           /* line 484 */
/*  */                                                 /* line 485 */
/*  Child components themselves can be leaves or other containers. *//* line 486 */
/*  */                                                 /* line 487 */
/*  `handler` invokes the code that is attached to this component. *//* line 488 */
/*  */                                                 /* line 489 */
/*  `instance_data` is a pointer to instance data that the `leaf_handler` *//* line 490 */
/*  function may want whenever it is invoked again. */ /* line 491 */
/*  */                                                 /* line 492 *//* line 493 */
/*  Eh_States :: enum { idle, active } */              /* line 494 */
class Eh {
  constructor () {                                     /* line 495 */

    this.name =  "";                                   /* line 496 */
    this.inq =  []                                     /* line 497 */;
    this.outq =  []                                    /* line 498 */;
    this.owner =  null;                                /* line 499 */
    this.children = [];                                /* line 500 */
    this.visit_ordering =  []                          /* line 501 */;
    this.connections = [];                             /* line 502 */
    this.routings =  []                                /* line 503 */;
    this.handler =  null;                              /* line 504 */
    this.finject =  null;                              /* line 505 */
    this.instance_data =  null;                        /* line 506 */
    this.state =  "idle";                              /* line 507 *//*  bootstrap debugging *//* line 508 */
    this.kind =  null;/*  enum { container, leaf, } */ /* line 509 *//* line 510 */
  }
}
                                                       /* line 511 */
/*  Creates a component that acts as a container. It is the same as a `Eh` instance *//* line 512 */
/*  whose handler function is `container_handler`. */  /* line 513 */
function make_container (name,owner) {                 /* line 514 */
    let  eh =  new Eh ();                              /* line 515 */;
    eh.name =  name;                                   /* line 516 */
    eh.owner =  owner;                                 /* line 517 */
    eh.handler =  container_handler;                   /* line 518 */
    eh.finject =  injector;                            /* line 519 */
    eh.state =  "idle";                                /* line 520 */
    eh.kind =  "container";                            /* line 521 */
    return  eh;                                        /* line 522 *//* line 523 *//* line 524 */
}

/*  Creates a new leaf component out of a handler function, and a data parameter *//* line 525 */
/*  that will be passed back to your handler when called. *//* line 526 *//* line 527 */
function make_leaf (name,owner,instance_data,handler) {/* line 528 */
    let  eh =  new Eh ();                              /* line 529 */;
    let  nm =  "";                                     /* line 530 */
    if ( null!= owner) {                               /* line 531 */
      nm =  owner.name;                                /* line 532 *//* line 533 */
    }
    eh.name =  ( nm.toString ()+  ( "▹".toString ()+  name.toString ()) .toString ()) /* line 534 */;
    eh.owner =  owner;                                 /* line 535 */
    eh.handler =  handler;                             /* line 536 */
    eh.finject =  injector;                            /* line 537 */
    eh.instance_data =  instance_data;                 /* line 538 */
    eh.state =  "idle";                                /* line 539 */
    eh.kind =  "leaf";                                 /* line 540 */
    return  eh;                                        /* line 541 *//* line 542 *//* line 543 */
}

/*  Sends a mevent on the given `port` with `data`, placing it on the output *//* line 544 */
/*  of the given component. */                         /* line 545 *//* line 546 */
function send (eh,port,obj,causingMevent) {            /* line 547 */
    let  d = Datum ();                                 /* line 548 */
    d.v =  obj;                                        /* line 549 */
    d.clone =  function () {return obj_clone ( d)      /* line 550 */;};
    d.reclaim =  None;                                 /* line 551 */
    let mev = make_mevent ( port, d)                   /* line 552 */;
    put_output ( eh, mev)                              /* line 553 *//* line 554 *//* line 555 */
}

function forward (eh,port,mev) {                       /* line 556 */
    let fwdmev = make_mevent ( port, mev.datum)        /* line 557 */;
    put_output ( eh, fwdmev)                           /* line 558 *//* line 559 *//* line 560 */
}

function inject (eh,mev) {                             /* line 561 */
    eh.finject ( eh, mev)                              /* line 562 *//* line 563 *//* line 564 */
}

function set_active (eh) {                             /* line 565 */
    eh.state =  "active";                              /* line 566 *//* line 567 *//* line 568 */
}

function set_idle (eh) {                               /* line 569 */
    eh.state =  "idle";                                /* line 570 *//* line 571 *//* line 572 */
}

function put_output (eh,mev) {                         /* line 573 */
    eh.outq.push ( mev)                                /* line 574 *//* line 575 *//* line 576 */
}

let  projectRoot =  "";                                /* line 577 *//* line 578 */
function set_environment (project_root) {              /* line 579 *//* line 580 */
    projectRoot =  project_root;                       /* line 581 *//* line 582 *//* line 583 */
}

function obj_clone (obj) {                             /* line 584 */
    return  obj;                                       /* line 585 *//* line 586 *//* line 587 */
}

/*  usage: app ${_00_} diagram_filename1 diagram_filename2 ... *//* line 588 */
/*  where ${_00_} is the root directory for the project *//* line 589 *//* line 590 */
function initialize_component_palette_from_files (project_root,diagram_source_files) {/* line 591 */
    let  reg = make_component_registry ();             /* line 592 */
    for (let diagram_source of  diagram_source_files) {/* line 593 */
      let all_containers_within_single_file = lnet2internal_from_file ( project_root, diagram_source)/* line 594 */;
      reg = generate_shell_components ( reg, all_containers_within_single_file)/* line 595 */;
      for (let container of  all_containers_within_single_file) {/* line 596 */
        register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 597 *//* line 598 */
      }                                                /* line 599 */
    }
    initialize_stock_components ( reg)                 /* line 600 */
    return  reg;                                       /* line 601 *//* line 602 *//* line 603 */
}

function initialize_component_palette_from_string (project_root) {/* line 604 */
    /*  this version ignores project_root  */          /* line 605 */
    let  reg = make_component_registry ();             /* line 606 */
    let all_containers = lnet2internal_from_string (); /* line 607 */
    reg = generate_shell_components ( reg, all_containers)/* line 608 */;
    for (let container of  all_containers) {           /* line 609 */
      register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 610 *//* line 611 */
    }
    initialize_stock_components ( reg)                 /* line 612 */
    return  reg;                                       /* line 613 *//* line 614 *//* line 615 */
}
                                                       /* line 616 */
function clone_string (s) {                            /* line 617 */
    return  s                                          /* line 618 *//* line 619 */;/* line 620 */
}

let  load_errors =  false;                             /* line 621 */
let  runtime_errors =  false;                          /* line 622 *//* line 623 */
function load_error (s) {                              /* line 624 *//* line 625 */
    console.error ( s);                                /* line 626 */
                                                       /* line 627 */
    load_errors =  true;                               /* line 628 *//* line 629 *//* line 630 */
}

function runtime_error (s) {                           /* line 631 *//* line 632 */
    console.error ( s);                                /* line 633 */
    runtime_errors =  true;                            /* line 634 *//* line 635 *//* line 636 */
}
                                                       /* line 637 */
function initialize_from_files (project_root,diagram_names) {/* line 638 */
    let arg =  null;                                   /* line 639 */
    let palette = initialize_component_palette_from_files ( project_root, diagram_names)/* line 640 */;
    return [ palette,[ project_root, diagram_names, arg]];/* line 641 *//* line 642 *//* line 643 */
}

function initialize_from_string (project_root) {       /* line 644 */
    let arg =  null;                                   /* line 645 */
    let palette = initialize_component_palette_from_string ( project_root)/* line 646 */;
    return [ palette,[ project_root, null, arg]];      /* line 647 *//* line 648 *//* line 649 */
}

function start (arg,Part_name,palette,env) {           /* line 650 */
    let project_root =  env [ 0];                      /* line 651 */
    let diagram_names =  env [ 1];                     /* line 652 */
    set_environment ( project_root)                    /* line 653 */
    /*  get entrypoint container */                    /* line 654 */
    let  Part = get_component_instance ( palette, Part_name, null)/* line 655 */;
    if ( null ==  Part) {                              /* line 656 */
      load_error ( ( "Couldn't find container with page name /".toString ()+  ( Part_name.toString ()+  ( "/ in files ".toString ()+  (`${ diagram_names}`.toString ()+  " (check tab names, or disable compression?)".toString ()) .toString ()) .toString ()) .toString ()) )/* line 660 *//* line 661 */
    }
    if ((!  load_errors)) {                            /* line 662 */
      let  d = Datum ();                               /* line 663 */
      d.v =  arg;                                      /* line 664 */
      d.clone =  function () {return obj_clone ( d)    /* line 665 */;};
      d.reclaim =  None;                               /* line 666 */
      let  mev = make_mevent ( "", d)                  /* line 667 */;
      inject ( Part, mev)                              /* line 668 *//* line 669 */
    }                                                  /* line 670 *//* line 671 */
}
                                                       /* line 672 */

/*  this needs to be rewritten to use the low_level "shell_out“ component, this can be done solely as a diagram without using python code here *//* line 1 */
function shell_out_instantiate (reg,owner,name,template_data) {/* line 2 */
    let name_with_id = gensymbol ( "shell_out")        /* line 3 */;
    let cmd =  template_data.split (" ")               /* line 4 */;
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)/* line 5 */;/* line 6 *//* line 7 */
}

function shell_out_handler (eh,msg) {                  /* line 8 */
    let cmd =  eh.instance_data;                       /* line 9 */
    let s =  msg.datum.v;                              /* line 10 */
    let  ret =  null;                                  /* line 11 */
    let  rc =  null;                                   /* line 12 */
    let  stdout =  null;                               /* line 13 */
    let  stderr =  null;                               /* line 14 */

    stdout = execSync(`${ cmd} ${ s}`, { encoding: 'utf-8' });
    ret = true;
                                                       /* line 15 */
    if ( rc ==  0) {                                   /* line 16 */
      send ( eh, "", ( stdout.toString ()+  stderr.toString ()) , msg)/* line 17 */
    }
    else {                                             /* line 18 */
      send ( eh, "✗", ( stdout.toString ()+  stderr.toString ()) , msg)/* line 19 *//* line 20 */
    }                                                  /* line 21 *//* line 22 */
}

function generate_shell_components (reg,container_list) {/* line 23 */
    /*  [ */                                           /* line 24 */
    /*      {;file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 25 */
    /*      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} *//* line 26 */
    /*  ] */                                           /* line 27 */
    if ( null!= container_list) {                      /* line 28 */
      for (let diagram of  container_list) {           /* line 29 */
        /*  loop through every component in the diagram and look for names that start with “$“ or “'“  *//* line 30 */
        /*  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 31 */
        for (let child_descriptor of  diagram [ "children"]) {/* line 32 */
          if (first_char_is ( child_descriptor [ "name"], "$")) {/* line 33 */
            let name =  child_descriptor [ "name"];    /* line 34 */
            let cmd =   name.substring (1) .strip ();  /* line 35 */
            let generated_leaf = mkTemplate ( name, cmd, shell_out_instantiate)/* line 36 */;
            register_component ( reg, generated_leaf)  /* line 37 */
          }
          else if (first_char_is ( child_descriptor [ "name"], "'")) {/* line 38 */
            let name =  child_descriptor [ "name"];    /* line 39 */
            let s =   name.substring (1)               /* line 40 */;
            let generated_leaf = mkTemplate ( name, s, string_constant_instantiate)/* line 41 */;
            register_component_allow_overwriting ( reg, generated_leaf)/* line 42 *//* line 43 */
          }                                            /* line 44 */
        }                                              /* line 45 */
      }                                                /* line 46 */
    }
    return  reg;                                       /* line 47 *//* line 48 *//* line 49 */
}

function first_char (s) {                              /* line 50 */
    return   s[0]                                      /* line 51 */;/* line 52 *//* line 53 */
}

function first_char_is (s,c) {                         /* line 54 */
    return  c == first_char ( s)                       /* line 55 */;/* line 56 *//* line 57 */
}
                                                       /* line 58 */
/*  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here *//* line 59 */
/*  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped *//* line 60 *//* line 61 */

function probeA_instantiate (reg,owner,name,template_data) {/* line 1 */
    let name_with_id = gensymbol ( "?A")               /* line 2 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 3 */;/* line 4 *//* line 5 */
}

function probeB_instantiate (reg,owner,name,template_data) {/* line 6 */
    let name_with_id = gensymbol ( "?B")               /* line 7 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 8 */;/* line 9 *//* line 10 */
}

function probeC_instantiate (reg,owner,name,template_data) {/* line 11 */
    let name_with_id = gensymbol ( "?C")               /* line 12 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 13 */;/* line 14 *//* line 15 */
}

function probe_handler (eh,mev) {                      /* line 16 *//* line 17 */
    let s =  mev.datum.v;                              /* line 18 */
    live_update ( "Info",  ( "  @".toString ()+  (`${ ticktime}`.toString ()+  ( "  ".toString ()+  ( "probe ".toString ()+  ( eh.name.toString ()+  ( ": ".toString ()+   s.toString ()) .toString ()) .toString ()) .toString ()) .toString ()) .toString ()) )/* line 26 *//* line 27 *//* line 28 */
}

function trash_instantiate (reg,owner,name,template_data) {/* line 29 */
    let name_with_id = gensymbol ( "trash")            /* line 30 */;
    return make_leaf ( name_with_id, owner, null, trash_handler)/* line 31 */;/* line 32 *//* line 33 */
}

function trash_handler (eh,mev) {                      /* line 34 */
    /*  to appease dumped_on_floor checker */          /* line 35 *//* line 36 *//* line 37 */
}

class TwoMevents {
  constructor () {                                     /* line 38 */

    this.firstmev =  null;                             /* line 39 */
    this.secondmev =  null;                            /* line 40 *//* line 41 */
  }
}
                                                       /* line 42 */
/*  Deracer_States :: enum { idle, waitingForFirstmev, waitingForSecondmev } *//* line 43 */
class Deracer_Instance_Data {
  constructor () {                                     /* line 44 */

    this.state =  null;                                /* line 45 */
    this.buffer =  null;                               /* line 46 *//* line 47 */
  }
}
                                                       /* line 48 */
function reclaim_Buffers_from_heap (inst) {            /* line 49 *//* line 50 *//* line 51 *//* line 52 */
}

function deracer_instantiate (reg,owner,name,template_data) {/* line 53 */
    let name_with_id = gensymbol ( "deracer")          /* line 54 */;
    let  inst =  new Deracer_Instance_Data ();         /* line 55 */;
    inst.state =  "idle";                              /* line 56 */
    inst.buffer =  new TwoMevents ();                  /* line 57 */;
    let eh = make_leaf ( name_with_id, owner, inst, deracer_handler)/* line 58 */;
    return  eh;                                        /* line 59 *//* line 60 *//* line 61 */
}

function send_firstmev_then_secondmev (eh,inst) {      /* line 62 */
    forward ( eh, "1", inst.buffer.firstmev)           /* line 63 */
    forward ( eh, "2", inst.buffer.secondmev)          /* line 64 */
    reclaim_Buffers_from_heap ( inst)                  /* line 65 *//* line 66 *//* line 67 */
}

function deracer_handler (eh,mev) {                    /* line 68 */
    let  inst =  eh.instance_data;                     /* line 69 */
    if ( inst.state ==  "idle") {                      /* line 70 */
      if ( "1" ==  mev.port) {                         /* line 71 */
        inst.buffer.firstmev =  mev;                   /* line 72 */
        inst.state =  "waitingForSecondmev";           /* line 73 */
      }
      else if ( "2" ==  mev.port) {                    /* line 74 */
        inst.buffer.secondmev =  mev;                  /* line 75 */
        inst.state =  "waitingForFirstmev";            /* line 76 */
      }
      else {                                           /* line 77 */
        runtime_error ( ( "bad mev.port (case A) for deracer ".toString ()+  mev.port.toString ()) )/* line 78 *//* line 79 */
      }
    }
    else if ( inst.state ==  "waitingForFirstmev") {   /* line 80 */
      if ( "1" ==  mev.port) {                         /* line 81 */
        inst.buffer.firstmev =  mev;                   /* line 82 */
        send_firstmev_then_secondmev ( eh, inst)       /* line 83 */
        inst.state =  "idle";                          /* line 84 */
      }
      else {                                           /* line 85 */
        runtime_error ( ( "bad mev.port (case B) for deracer ".toString ()+  mev.port.toString ()) )/* line 86 *//* line 87 */
      }
    }
    else if ( inst.state ==  "waitingForSecondmev") {  /* line 88 */
      if ( "2" ==  mev.port) {                         /* line 89 */
        inst.buffer.secondmev =  mev;                  /* line 90 */
        send_firstmev_then_secondmev ( eh, inst)       /* line 91 */
        inst.state =  "idle";                          /* line 92 */
      }
      else {                                           /* line 93 */
        runtime_error ( ( "bad mev.port (case C) for deracer ".toString ()+  mev.port.toString ()) )/* line 94 *//* line 95 */
      }
    }
    else {                                             /* line 96 */
      runtime_error ( "bad state for deracer {eh.state}")/* line 97 *//* line 98 */
    }                                                  /* line 99 *//* line 100 */
}

function low_level_read_text_file_instantiate (reg,owner,name,template_data) {/* line 101 */
    let name_with_id = gensymbol ( "Low Level Read Text File")/* line 102 */;
    return make_leaf ( name_with_id, owner, null, low_level_read_text_file_handler)/* line 103 */;/* line 104 *//* line 105 */
}

function low_level_read_text_file_handler (eh,mev) {   /* line 106 */
    let fname =  mev.datum.v;                          /* line 107 */

    if (fname == "0") {
    data = fs.readFileSync (0, { encoding: 'utf8'});
    } else {
    data = fs.readFileSync (fname, { encoding: 'utf8'});
    }
    if (data) {
      send_string (eh, "", data, mev);
    } else {
      send_string (eh, "✗", `read error on file '${fname}'`, mev);
    }
                                                       /* line 108 *//* line 109 *//* line 110 */
}

function ensure_string_datum_instantiate (reg,owner,name,template_data) {/* line 111 */
    let name_with_id = gensymbol ( "Ensure String Datum")/* line 112 */;
    return make_leaf ( name_with_id, owner, null, ensure_string_datum_handler)/* line 113 */;/* line 114 *//* line 115 */
}

function ensure_string_datum_handler (eh,mev) {        /* line 116 */
    if ( "string" ==  mev.datum.kind ()) {             /* line 117 */
      forward ( eh, "", mev)                           /* line 118 */
    }
    else {                                             /* line 119 */
      let emev =  ( "*** ensure: type error (expected a string datum) but got ".toString ()+  mev.datum.toString ()) /* line 120 */;
      send ( eh, "✗", emev, mev)                       /* line 121 *//* line 122 */
    }                                                  /* line 123 *//* line 124 */
}

class Syncfilewrite_Data {
  constructor () {                                     /* line 125 */

    this.filename =  "";                               /* line 126 *//* line 127 */
  }
}
                                                       /* line 128 */
/*  temp copy for bootstrap, sends "done“ (error during bootstrap if not wired) *//* line 129 */
function syncfilewrite_instantiate (reg,owner,name,template_data) {/* line 130 */
    let name_with_id = gensymbol ( "syncfilewrite")    /* line 131 */;
    let inst =  new Syncfilewrite_Data ();             /* line 132 */;
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)/* line 133 */;/* line 134 *//* line 135 */
}

function syncfilewrite_handler (eh,mev) {              /* line 136 */
    let  inst =  eh.instance_data;                     /* line 137 */
    if ( "filename" ==  mev.port) {                    /* line 138 */
      inst.filename =  mev.datum.v;                    /* line 139 */
    }
    else if ( "input" ==  mev.port) {                  /* line 140 */
      let contents =  mev.datum.v;                     /* line 141 */
      let  f = open ( inst.filename, "w")              /* line 142 */;
      if ( f!= null) {                                 /* line 143 */
        f.write ( mev.datum.v)                         /* line 144 */
        f.close ()                                     /* line 145 */
        send ( eh, "done",new_datum_bang (), mev)      /* line 146 */
      }
      else {                                           /* line 147 */
        send ( eh, "✗", ( "open error on file ".toString ()+  inst.filename.toString ()) , mev)/* line 148 *//* line 149 */
      }                                                /* line 150 */
    }                                                  /* line 151 *//* line 152 */
}

class StringConcat_Instance_Data {
  constructor () {                                     /* line 153 */

    this.buffer1 =  null;                              /* line 154 */
    this.buffer2 =  null;                              /* line 155 *//* line 156 */
  }
}
                                                       /* line 157 */
function stringconcat_instantiate (reg,owner,name,template_data) {/* line 158 */
    let name_with_id = gensymbol ( "stringconcat")     /* line 159 */;
    let instp =  new StringConcat_Instance_Data ();    /* line 160 */;
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)/* line 161 */;/* line 162 *//* line 163 */
}

function stringconcat_handler (eh,mev) {               /* line 164 */
    let  inst =  eh.instance_data;                     /* line 165 */
    if ( "1" ==  mev.port) {                           /* line 166 */
      inst.buffer1 = clone_string ( mev.datum.v)       /* line 167 */;
      maybe_stringconcat ( eh, inst, mev)              /* line 168 */
    }
    else if ( "2" ==  mev.port) {                      /* line 169 */
      inst.buffer2 = clone_string ( mev.datum.v)       /* line 170 */;
      maybe_stringconcat ( eh, inst, mev)              /* line 171 */
    }
    else if ( "reset" ==  mev.port) {                  /* line 172 */
      inst.buffer1 =  null;                            /* line 173 */
      inst.buffer2 =  null;                            /* line 174 */
    }
    else {                                             /* line 175 */
      runtime_error ( ( "bad mev.port for stringconcat: ".toString ()+  mev.port.toString ()) )/* line 176 *//* line 177 */
    }                                                  /* line 178 *//* line 179 */
}

function maybe_stringconcat (eh,inst,mev) {            /* line 180 */
    if ((( inst.buffer1!= null) && ( inst.buffer2!= null))) {/* line 181 */
      let  concatenated_string =  "";                  /* line 182 */
      if ( 0 == ( inst.buffer1.length)) {              /* line 183 */
        concatenated_string =  inst.buffer2;           /* line 184 */
      }
      else if ( 0 == ( inst.buffer2.length)) {         /* line 185 */
        concatenated_string =  inst.buffer1;           /* line 186 */
      }
      else {                                           /* line 187 */
        concatenated_string =  inst.buffer1+ inst.buffer2;/* line 188 *//* line 189 */
      }
      send ( eh, "", concatenated_string, mev)         /* line 190 */
      inst.buffer1 =  null;                            /* line 191 */
      inst.buffer2 =  null;                            /* line 192 *//* line 193 */
    }                                                  /* line 194 *//* line 195 */
}

/*  */                                                 /* line 196 *//* line 197 */
function string_constant_instantiate (reg,owner,name,template_data) {/* line 198 *//* line 199 */
    let name_with_id = gensymbol ( "strconst")         /* line 200 */;
    let  s =  template_data;                           /* line 201 */
    if ( projectRoot!= "") {                           /* line 202 */
      s =  s.replaceAll ( "_00_",  projectRoot)        /* line 203 */;/* line 204 */
    }
    return make_leaf ( name_with_id, owner, s, string_constant_handler)/* line 205 */;/* line 206 *//* line 207 */
}

function string_constant_handler (eh,mev) {            /* line 208 */
    let s =  eh.instance_data;                         /* line 209 */
    send ( eh, "", s, mev)                             /* line 210 *//* line 211 *//* line 212 */
}

function fakepipename_instantiate (reg,owner,name,template_data) {/* line 213 */
    let instance_name = gensymbol ( "fakepipe")        /* line 214 */;
    return make_leaf ( instance_name, owner, null, fakepipename_handler)/* line 215 */;/* line 216 *//* line 217 */
}

let  rand =  0;                                        /* line 218 *//* line 219 */
function fakepipename_handler (eh,mev) {               /* line 220 *//* line 221 */
    rand =  rand+ 1;
    /*  not very random, but good enough _ ;rand' must be unique within a single run *//* line 222 */
    send ( eh, "", ( "/tmp/fakepipe".toString ()+  rand.toString ()) , mev)/* line 223 *//* line 224 *//* line 225 */
}
                                                       /* line 226 */
class Switch1star_Instance_Data {
  constructor () {                                     /* line 227 */

    this.state =  "1";                                 /* line 228 *//* line 229 */
  }
}
                                                       /* line 230 */
function switch1star_instantiate (reg,owner,name,template_data) {/* line 231 */
    let name_with_id = gensymbol ( "switch1*")         /* line 232 */;
    let instp =  new Switch1star_Instance_Data ();     /* line 233 */;
    return make_leaf ( name_with_id, owner, instp, switch1star_handler)/* line 234 */;/* line 235 *//* line 236 */
}

function switch1star_handler (eh,mev) {                /* line 237 */
    let  inst =  eh.instance_data;                     /* line 238 */
    let whichOutput =  inst.state;                     /* line 239 */
    if ( "" ==  mev.port) {                            /* line 240 */
      if ( "1" ==  whichOutput) {                      /* line 241 */
        forward ( eh, "1", mev)                        /* line 242 */
        inst.state =  "*";                             /* line 243 */
      }
      else if ( "*" ==  whichOutput) {                 /* line 244 */
        forward ( eh, "*", mev)                        /* line 245 */
      }
      else {                                           /* line 246 */
        send ( eh, "✗", "internal error bad state in switch1*", mev)/* line 247 *//* line 248 */
      }
    }
    else if ( "reset" ==  mev.port) {                  /* line 249 */
      inst.state =  "1";                               /* line 250 */
    }
    else {                                             /* line 251 */
      send ( eh, "✗", "internal error bad mevent for switch1*", mev)/* line 252 *//* line 253 */
    }                                                  /* line 254 *//* line 255 */
}

class StringAccumulator {
  constructor () {                                     /* line 256 */

    this.s =  "";                                      /* line 257 *//* line 258 */
  }
}
                                                       /* line 259 */
function strcatstar_instantiate (reg,owner,name,template_data) {/* line 260 */
    let name_with_id = gensymbol ( "String Concat *")  /* line 261 */;
    let instp =  new StringAccumulator ();             /* line 262 */;
    return make_leaf ( name_with_id, owner, instp, strcatstar_handler)/* line 263 */;/* line 264 *//* line 265 */
}

function strcatstar_handler (eh,mev) {                 /* line 266 */
    let  accum =  eh.instance_data;                    /* line 267 */
    if ( "" ==  mev.port) {                            /* line 268 */
      accum.s =  ( accum.s.toString ()+  mev.datum.v.toString ()) /* line 269 */;
    }
    else if ( "fini" ==  mev.port) {                   /* line 270 */
      send ( eh, "", accum.s, mev)                     /* line 271 */
    }
    else {                                             /* line 272 */
      send ( eh, "✗", "internal error bad mevent for String Concat *", mev)/* line 273 *//* line 274 */
    }                                                  /* line 275 *//* line 276 */
}

/*  all of the the built_in leaves are listed here */  /* line 277 */
/*  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project *//* line 278 *//* line 279 */
function initialize_stock_components (reg) {           /* line 280 */
    register_component ( reg,mkTemplate ( "1then2", null, deracer_instantiate))/* line 281 */
    register_component ( reg,mkTemplate ( "?A", null, probeA_instantiate))/* line 282 */
    register_component ( reg,mkTemplate ( "?B", null, probeB_instantiate))/* line 283 */
    register_component ( reg,mkTemplate ( "?C", null, probeC_instantiate))/* line 284 */
    register_component ( reg,mkTemplate ( "trash", null, trash_instantiate))/* line 285 *//* line 286 *//* line 287 */
    register_component ( reg,mkTemplate ( "Read Text File", null, low_level_read_text_file_instantiate))/* line 288 */
    register_component ( reg,mkTemplate ( "Ensure String Datum", null, ensure_string_datum_instantiate))/* line 289 *//* line 290 */
    register_component ( reg,mkTemplate ( "syncfilewrite", null, syncfilewrite_instantiate))/* line 291 */
    register_component ( reg,mkTemplate ( "stringconcat", null, stringconcat_instantiate))/* line 292 */
    register_component ( reg,mkTemplate ( "switch1*", null, switch1star_instantiate))/* line 293 */
    register_component ( reg,mkTemplate ( "String Concat *", null, strcatstar_instantiate))/* line 294 */
    /*  for fakepipe */                                /* line 295 */
    register_component ( reg,mkTemplate ( "fakepipename", null, fakepipename_instantiate))/* line 296 *//* line 297 *//* line 298 */
}