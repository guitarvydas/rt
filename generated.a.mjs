

import * as fs from 'fs';
import path from 'path';
const argv = process.argv.slice(1);
import execSync from 'child_process';
                              /* line 1 *//* line 2 */
let  counter =  0;            /* line 3 *//* line 4 */
let  digits = [ "₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀", "₂₁", "₂₂", "₂₃", "₂₄", "₂₅", "₂₆", "₂₇", "₂₈", "₂₉"];/* line 11 *//* line 12 *//* line 13 */
function gensymbol (s) {      /* line 14 *//* line 15 */
    let name_with_id =  `${ s}${subscripted_digit ( counter)}` /* line 16 */;
    counter =  counter+ 1;    /* line 17 */
    return  name_with_id;     /* line 18 *//* line 19 *//* line 20 */
}

function subscripted_digit (n) {/* line 21 *//* line 22 */
    if (((( n >=  0) && ( n <=  29)))) {/* line 23 */
      return  digits [ n];    /* line 24 */}
    else {                    /* line 25 */
      return  `${ "₊"}${ n}`  /* line 26 */;/* line 27 */}/* line 28 *//* line 29 */
}

class Datum {
  constructor () {            /* line 30 */

    this.data =  null;        /* line 31 */
    this.clone =  null;       /* line 32 */
    this.reclaim =  null;     /* line 33 */
    this.srepr =  null;       /* line 34 */
    this.kind =  null;        /* line 35 */
    this.raw =  null;         /* line 36 *//* line 37 */
  }
}
                              /* line 38 */
function new_datum_string (s) {/* line 39 */
    let d =  new Datum ();    /* line 40 */;
    d.data =  s;              /* line 41 */
    d.clone =  function () {return clone_datum_string ( d)/* line 42 */;};
    d.reclaim =  function () {return reclaim_datum_string ( d)/* line 43 */;};
    d.srepr =  function () {return srepr_datum_string ( d)/* line 44 */;};
    d.raw = new TextEncoder().encode( d.data)/* line 45 */;
    d.kind =  function () {return  "string";};/* line 46 */
    return  d;                /* line 47 *//* line 48 *//* line 49 */
}

function clone_datum_string (d) {/* line 50 */
    let newd = new_datum_string ( d.data)/* line 51 */;
    return  newd;             /* line 52 *//* line 53 *//* line 54 */
}

function reclaim_datum_string (src) {/* line 55 *//* line 56 *//* line 57 *//* line 58 */
}

function srepr_datum_string (d) {/* line 59 */
    return  d.data;           /* line 60 *//* line 61 *//* line 62 */
}

function new_datum_bang () {  /* line 63 */
    let p =  new Datum ();    /* line 64 */;
    p.data =  true;           /* line 65 */
    p.clone =  function () {return clone_datum_bang ( p)/* line 66 */;};
    p.reclaim =  function () {return reclaim_datum_bang ( p)/* line 67 */;};
    p.srepr =  function () {return srepr_datum_bang ();};/* line 68 */
    p.raw =  function () {return raw_datum_bang ();};/* line 69 */
    p.kind =  function () {return  "bang";};/* line 70 */
    return  p;                /* line 71 *//* line 72 *//* line 73 */
}

function clone_datum_bang (d) {/* line 74 */
    return new_datum_bang (); /* line 75 *//* line 76 *//* line 77 */
}

function reclaim_datum_bang (d) {/* line 78 *//* line 79 *//* line 80 *//* line 81 */
}

function srepr_datum_bang () {/* line 82 */
    return  "!";              /* line 83 *//* line 84 *//* line 85 */
}

function raw_datum_bang () {  /* line 86 */
    return [];                /* line 87 *//* line 88 *//* line 89 */
}

function new_datum_tick () {  /* line 90 */
    let p = new_datum_bang ();/* line 91 */
    p.kind =  function () {return  "tick";};/* line 92 */
    p.clone =  function () {return new_datum_tick ();};/* line 93 */
    p.srepr =  function () {return srepr_datum_tick ();};/* line 94 */
    p.raw =  function () {return raw_datum_tick ();};/* line 95 */
    return  p;                /* line 96 *//* line 97 *//* line 98 */
}

function srepr_datum_tick () {/* line 99 */
    return  ".";              /* line 100 *//* line 101 *//* line 102 */
}

function raw_datum_tick () {  /* line 103 */
    return [];                /* line 104 *//* line 105 *//* line 106 */
}

function new_datum_bytes (b) {/* line 107 */
    let p =  new Datum ();    /* line 108 */;
    p.data =  b;              /* line 109 */
    p.clone =  function () {return clone_datum_bytes ( p)/* line 110 */;};
    p.reclaim =  function () {return reclaim_datum_bytes ( p)/* line 111 */;};
    p.srepr =  function () {return srepr_datum_bytes ( b)/* line 112 */;};
    p.raw =  function () {return raw_datum_bytes ( b)/* line 113 */;};
    p.kind =  function () {return  "bytes";};/* line 114 */
    return  p;                /* line 115 *//* line 116 *//* line 117 */
}

function clone_datum_bytes (src) {/* line 118 */
    let p =  new Datum ();    /* line 119 */;
    p.clone =  src.clone;     /* line 120 */
    p.reclaim =  src.reclaim; /* line 121 */
    p.srepr =  src.srepr;     /* line 122 */
    p.raw =  src.raw;         /* line 123 */
    p.kind =  src.kind;       /* line 124 */
    p.data =  src.clone ();   /* line 125 */
    return  p;                /* line 126 *//* line 127 *//* line 128 */
}

function reclaim_datum_bytes (src) {/* line 129 *//* line 130 *//* line 131 *//* line 132 */
}

function srepr_datum_bytes (d) {/* line 133 */
    return  d.data.decode ( "UTF_8")/* line 134 */;/* line 135 */
}

function raw_datum_bytes (d) {/* line 136 */
    return  d.data;           /* line 137 *//* line 138 *//* line 139 */
}

function new_datum_handle (h) {/* line 140 */
    return new_datum_int ( h) /* line 141 */;/* line 142 *//* line 143 */
}

function new_datum_int (i) {  /* line 144 */
    let p =  new Datum ();    /* line 145 */;
    p.data =  i;              /* line 146 */
    p.clone =  function () {return clone_int ( i)/* line 147 */;};
    p.reclaim =  function () {return reclaim_int ( i)/* line 148 */;};
    p.srepr =  function () {return srepr_datum_int ( i)/* line 149 */;};
    p.raw =  function () {return raw_datum_int ( i)/* line 150 */;};
    p.kind =  function () {return  "int";};/* line 151 */
    return  p;                /* line 152 *//* line 153 *//* line 154 */
}

function clone_int (i) {      /* line 155 */
    let p = new_datum_int ( i)/* line 156 */;
    return  p;                /* line 157 *//* line 158 *//* line 159 */
}

function reclaim_int (src) {  /* line 160 *//* line 161 *//* line 162 *//* line 163 */
}

function srepr_datum_int (i) {/* line 164 */
    return `${ i}`            /* line 165 */;/* line 166 *//* line 167 */
}

function raw_datum_int (i) {  /* line 168 */
    return  i;                /* line 169 *//* line 170 *//* line 171 */
}

/*  Message passed to a leaf component. *//* line 172 */
/*  */                        /* line 173 */
/*  `port` refers to the name of the incoming or outgoing port of this component. *//* line 174 */
/*  `datum` is the data attached to this message. *//* line 175 */
class Message {
  constructor () {            /* line 176 */

    this.port =  null;        /* line 177 */
    this.datum =  null;       /* line 178 *//* line 179 */
  }
}
                              /* line 180 */
function clone_port (s) {     /* line 181 */
    return clone_string ( s)  /* line 182 */;/* line 183 *//* line 184 */
}

/*  Utility for making a `Message`. Used to safely “seed“ messages *//* line 185 */
/*  entering the very top of a network. *//* line 186 */
function make_message (port,datum) {/* line 187 */
    let p = clone_string ( port)/* line 188 */;
    let  m =  new Message (); /* line 189 */;
    m.port =  p;              /* line 190 */
    m.datum =  datum.clone ();/* line 191 */
    return  m;                /* line 192 *//* line 193 *//* line 194 */
}

/*  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. *//* line 195 */
function message_clone (msg) {/* line 196 */
    let  m =  new Message (); /* line 197 */;
    m.port = clone_port ( msg.port)/* line 198 */;
    m.datum =  msg.datum.clone ();/* line 199 */
    return  m;                /* line 200 *//* line 201 *//* line 202 */
}

/*  Frees a message. */       /* line 203 */
function destroy_message (msg) {/* line 204 */
    /*  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages *//* line 205 *//* line 206 *//* line 207 *//* line 208 */
}

function destroy_datum (msg) {/* line 209 *//* line 210 *//* line 211 *//* line 212 */
}

function destroy_port (msg) { /* line 213 *//* line 214 *//* line 215 *//* line 216 */
}

/*  */                        /* line 217 */
function format_message (m) { /* line 218 */
    if ( m ==  null) {        /* line 219 */
      return  "ϕ";            /* line 220 */}
    else {                    /* line 221 */
      return  `${ m.port}${ `${ ":"}${ `${ m.datum.srepr ()}${ ","}` }` }` /* line 224 */;/* line 225 */}/* line 226 *//* line 227 */
}

const  enumDown =  0          /* line 228 */;
const  enumAcross =  1        /* line 229 */;
const  enumUp =  2            /* line 230 */;
const  enumThrough =  3       /* line 231 */;/* line 232 */
function create_down_connector (container,proto_conn,connectors,children_by_id) {/* line 233 */
    /*  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, *//* line 234 */
    let  connector =  new Connector ();/* line 235 */;
    connector.direction =  "down";/* line 236 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 237 */;
    let target_proto =  proto_conn [ "target"];/* line 238 */
    let id_proto =  target_proto [ "id"];/* line 239 */
    let target_component =  children_by_id [id_proto];/* line 240 */
    if (( target_component ==  null)) {/* line 241 */
      load_error ( `${ "internal error: .Down connection target internal error "}${( proto_conn [ "target"]) [ "name"]}` )/* line 242 */}
    else {                    /* line 243 */
      connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 244 */;/* line 245 */}
    return  connector;        /* line 246 *//* line 247 *//* line 248 */
}

function create_across_connector (container,proto_conn,connectors,children_by_id) {/* line 249 */
    let  connector =  new Connector ();/* line 250 */;
    connector.direction =  "across";/* line 251 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 252 */
    let target_component =  children_by_id [(( proto_conn [ "target"]) [ "id"])];/* line 253 */
    if ( source_component ==  null) {/* line 254 */
      load_error ( `${ "internal error: .Across connection source not ok "}${( proto_conn [ "source"]) [ "name"]}` )/* line 255 */}
    else {                    /* line 256 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 257 */;
      if ( target_component ==  null) {/* line 258 */
        load_error ( `${ "internal error: .Across connection target not ok "}${( proto_conn [ "target"]) [ "name"]}` )/* line 259 */}
      else {                  /* line 260 */
        connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 261 */;/* line 262 */}/* line 263 */}
    return  connector;        /* line 264 *//* line 265 *//* line 266 */
}

function create_up_connector (container,proto_conn,connectors,children_by_id) {/* line 267 */
    let  connector =  new Connector ();/* line 268 */;
    connector.direction =  "up";/* line 269 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 270 */
    if ( source_component ==  null) {/* line 271 */
      print ( `${ "internal error: .Up connection source not ok "}${( proto_conn [ "source"]) [ "name"]}` )/* line 272 */}
    else {                    /* line 273 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 274 */;
      connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 275 */;/* line 276 */}
    return  connector;        /* line 277 *//* line 278 *//* line 279 */
}

function create_through_connector (container,proto_conn,connectors,children_by_id) {/* line 280 */
    let  connector =  new Connector ();/* line 281 */;
    connector.direction =  "through";/* line 282 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 283 */;
    connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 284 */;
    return  connector;        /* line 285 *//* line 286 *//* line 287 */
}
                              /* line 288 */
function container_instantiator (reg,owner,container_name,desc) {/* line 289 *//* line 290 */
    let container = make_container ( container_name, owner)/* line 291 */;
    let children = [];        /* line 292 */
    let children_by_id = {};
    /*  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here *//* line 293 */
    /*  collect children */   /* line 294 */
    for (let child_desc of  desc [ "children"]) {/* line 295 */
      let child_instance = get_component_instance ( reg, child_desc [ "name"], container)/* line 296 */;
      children.push ( child_instance) /* line 297 */
      let id =  child_desc [ "id"];/* line 298 */
      children_by_id [id] =  child_instance;/* line 299 *//* line 300 *//* line 301 */}
    container.children =  children;/* line 302 *//* line 303 */
    let connectors = [];      /* line 304 */
    for (let proto_conn of  desc [ "connections"]) {/* line 305 */
      let  connector =  new Connector ();/* line 306 */;
      if ( proto_conn [ "dir"] ==  enumDown) {/* line 307 */
        connectors.push (create_down_connector ( container, proto_conn, connectors, children_by_id)) /* line 308 */}
      else if ( proto_conn [ "dir"] ==  enumAcross) {/* line 309 */
        connectors.push (create_across_connector ( container, proto_conn, connectors, children_by_id)) /* line 310 */}
      else if ( proto_conn [ "dir"] ==  enumUp) {/* line 311 */
        connectors.push (create_up_connector ( container, proto_conn, connectors, children_by_id)) /* line 312 */}
      else if ( proto_conn [ "dir"] ==  enumThrough) {/* line 313 */
        connectors.push (create_through_connector ( container, proto_conn, connectors, children_by_id)) /* line 314 *//* line 315 */}/* line 316 */}
    container.connections =  connectors;/* line 317 */
    return  container;        /* line 318 *//* line 319 *//* line 320 */
}

/*  The default handler for container components. *//* line 321 */
function container_handler (container,message) {/* line 322 */
    route ( container, container, message)
    /*  references to 'self' are replaced by the container during instantiation *//* line 323 */
    while (any_child_ready ( container)) {/* line 324 */
      step_children ( container, message)/* line 325 */}/* line 326 *//* line 327 */
}

/*  Frees the given container and associated data. *//* line 328 */
function destroy_container (eh) {/* line 329 *//* line 330 *//* line 331 *//* line 332 */
}

/*  Routing connection for a container component. The `direction` field has *//* line 333 */
/*  no affect on the default message routing system _ it is there for debugging *//* line 334 */
/*  purposes, or for reading by other tools. *//* line 335 *//* line 336 */
class Connector {
  constructor () {            /* line 337 */

    this.direction =  null;/*  down, across, up, through *//* line 338 */
    this.sender =  null;      /* line 339 */
    this.receiver =  null;    /* line 340 *//* line 341 */
  }
}
                              /* line 342 */
/*  `Sender` is used to “pattern match“ which `Receiver` a message should go to, *//* line 343 */
/*  based on component ID (pointer) and port name. *//* line 344 *//* line 345 */
class Sender {
  constructor () {            /* line 346 */

    this.name =  null;        /* line 347 */
    this.component =  null;   /* line 348 */
    this.port =  null;        /* line 349 *//* line 350 */
  }
}
                              /* line 351 *//* line 352 *//* line 353 */
/*  `Receiver` is a handle to a destination queue, and a `port` name to assign *//* line 354 */
/*  to incoming messages to this queue. *//* line 355 *//* line 356 */
class Receiver {
  constructor () {            /* line 357 */

    this.name =  null;        /* line 358 */
    this.queue =  null;       /* line 359 */
    this.port =  null;        /* line 360 */
    this.component =  null;   /* line 361 *//* line 362 */
  }
}
                              /* line 363 */
function mkSender (name,component,port) {/* line 364 */
    let  s =  new Sender ();  /* line 365 */;
    s.name =  name;           /* line 366 */
    s.component =  component; /* line 367 */
    s.port =  port;           /* line 368 */
    return  s;                /* line 369 *//* line 370 *//* line 371 */
}

function mkReceiver (name,component,port,q) {/* line 372 */
    let  r =  new Receiver ();/* line 373 */;
    r.name =  name;           /* line 374 */
    r.component =  component; /* line 375 */
    r.port =  port;           /* line 376 */
    /*  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. *//* line 377 */
    r.queue =  q;             /* line 378 */
    return  r;                /* line 379 *//* line 380 *//* line 381 */
}

/*  Checks if two senders match, by pointer equality and port name matching. *//* line 382 */
function sender_eq (s1,s2) {  /* line 383 */
    let same_components = ( s1.component ==  s2.component);/* line 384 */
    let same_ports = ( s1.port ==  s2.port);/* line 385 */
    return (( same_components) && ( same_ports));/* line 386 *//* line 387 *//* line 388 */
}

/*  Delivers the given message to the receiver of this connector. *//* line 389 *//* line 390 */
function deposit (parent,conn,message) {/* line 391 */
    let new_message = make_message ( conn.receiver.port, message.datum)/* line 392 */;
    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)/* line 393 *//* line 394 *//* line 395 */
}

function force_tick (parent,eh) {/* line 396 */
    let tick_msg = make_message ( ".",new_datum_tick ())/* line 397 */;
    push_message ( parent, eh, eh.inq, tick_msg)/* line 398 */
    return  tick_msg;         /* line 399 *//* line 400 *//* line 401 */
}

function push_message (parent,receiver,inq,m) {/* line 402 */
    inq.push ( m)             /* line 403 */
    parent.visit_ordering.push ( receiver)/* line 404 *//* line 405 *//* line 406 */
}

function is_self (child,container) {/* line 407 */
    /*  in an earlier version “self“ was denoted as ϕ *//* line 408 */
    return  child ==  container;/* line 409 *//* line 410 *//* line 411 */
}

function step_child (child,msg) {/* line 412 */
    let before_state =  child.state;/* line 413 */
    child.handler ( child, msg)/* line 414 */
    let after_state =  child.state;/* line 415 */
    return [(( before_state ==  "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state ==  "idle"))];/* line 418 *//* line 419 *//* line 420 */
}

function step_children (container,causingMessage) {/* line 421 */
    container.state =  "idle";/* line 422 */
    for (let child of   container.visit_ordering) {/* line 423 */
      /*  child = container represents self, skip it *//* line 424 */
      if (((! (is_self ( child, container))))) {/* line 425 */
        if (((! ((0=== child.inq.length))))) {/* line 426 */
          let msg =  child.inq.shift ()/* line 427 */;
          let  began_long_run =  null;/* line 428 */
          let  continued_long_run =  null;/* line 429 */
          let  ended_long_run =  null;/* line 430 */
          [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)/* line 431 */;
          if ( began_long_run) {/* line 432 *//* line 433 */}
          else if ( continued_long_run) {/* line 434 *//* line 435 */}
          else if ( ended_long_run) {/* line 436 *//* line 437 *//* line 438 */}
          destroy_message ( msg)/* line 439 */}
        else {                /* line 440 */
          if ( child.state!= "idle") {/* line 441 */
            let msg = force_tick ( container, child)/* line 442 */;
            child.handler ( child, msg)/* line 443 */
            destroy_message ( msg)}/* line 444 */}/* line 445 */
        if ( child.state ==  "active") {/* line 446 */
          /*  if child remains active, then the container must remain active and must propagate “ticks“ to child *//* line 447 */
          container.state =  "active";/* line 448 */}/* line 449 */
        while (((! ((0=== child.outq.length))))) {/* line 450 */
          let msg =  child.outq.shift ()/* line 451 */;
          route ( container, child, msg)/* line 452 */
          destroy_message ( msg)}}/* line 453 */}/* line 454 *//* line 455 *//* line 456 *//* line 457 */
}

function attempt_tick (parent,eh) {/* line 458 */
    if ( eh.state!= "idle") { /* line 459 */
      force_tick ( parent, eh)/* line 460 */}/* line 461 *//* line 462 */
}

function is_tick (msg) {      /* line 463 */
    return  "tick" ==  msg.datum.kind ();/* line 464 *//* line 465 *//* line 466 */
}

/*  Routes a single message to all matching destinations, according to *//* line 467 */
/*  the container's connection network. *//* line 468 *//* line 469 */
function route (container,from_component,message) {/* line 470 */
    let  was_sent =  false;
    /*  for checking that output went somewhere (at least during bootstrap) *//* line 471 */
    let  fromname =  "";      /* line 472 */
    if (is_tick ( message)) { /* line 473 */
      for (let child of  container.children) {/* line 474 */
        attempt_tick ( container, child)/* line 475 */}
      was_sent =  true;       /* line 476 */}
    else {                    /* line 477 */
      if (((! (is_self ( from_component, container))))) {/* line 478 */
        fromname =  from_component.name;/* line 479 */}
      let from_sender = mkSender ( fromname, from_component, message.port)/* line 480 */;/* line 481 */
      for (let connector of  container.connections) {/* line 482 */
        if (sender_eq ( from_sender, connector.sender)) {/* line 483 */
          deposit ( container, connector, message)/* line 484 */
          was_sent =  true;}} /* line 485 */}
    if ((! ( was_sent))) {    /* line 486 */
      print ( "\n\n*** Error: ***")/* line 487 */
      print ( "***")          /* line 488 */
      print ( `${ container.name}${ `${ ": message '"}${ `${ message.port}${ `${ "' from "}${ `${ fromname}${ " dropped on floor..."}` }` }` }` }` )/* line 489 */
      print ( "***")          /* line 490 */
      process.exit (1)        /* line 491 *//* line 492 */}/* line 493 *//* line 494 */
}

function any_child_ready (container) {/* line 495 */
    for (let child of  container.children) {/* line 496 */
      if (child_is_ready ( child)) {/* line 497 */
        return  true;}        /* line 498 */}
    return  false;            /* line 499 *//* line 500 *//* line 501 */
}

function child_is_ready (eh) {/* line 502 */
    return ((((((((! ((0=== eh.outq.length))))) || (((! ((0=== eh.inq.length))))))) || (( eh.state!= "idle")))) || ((any_child_ready ( eh))));/* line 503 *//* line 504 *//* line 505 */
}

function append_routing_descriptor (container,desc) {/* line 506 */
    container.routings.push ( desc)/* line 507 *//* line 508 *//* line 509 */
}

function container_injector (container,message) {/* line 510 */
    container_handler ( container, message)/* line 511 *//* line 512 *//* line 513 */
}





