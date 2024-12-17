

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
    } else {
    jstr = fs.readFileSync (`${pathname}/${filename}`);
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
          instance_name =  `${ owner_name}${ `${ "."}${ template_name}` }` ;/* line 66 */}
        else {                /* line 67 */
          instance_name =  template_name;/* line 68 */}
        let instance =  template.instantiator ( reg, owner, instance_name, template.template_data)/* line 69 */;
        return  instance;}    /* line 70 */}
    else {                    /* line 71 */
      load_error ( `${ "Registry Error (B): Can't find component /"}${ `${ template_name}${ "/"}` }` )/* line 72 */
      return  null;           /* line 73 */}/* line 74 *//* line 75 */
}

function dump_registry (reg) {/* line 76 */
    nl ()                     /* line 77 */
    console.log ( "*** PALETTE ***");/* line 78 */
    for (let c of  reg.templates) {/* line 79 */
      print ( c.name)         /* line 80 */}
    console.log ( "***************");/* line 81 */
    nl ()                     /* line 82 *//* line 83 *//* line 84 */
}

function print_stats (reg) {  /* line 85 */
    console.log ( `${ "registry statistics: "}${ reg.stats}` );/* line 86 *//* line 87 *//* line 88 */
}

function mangle_name (s) {    /* line 89 */
    /*  trim name to remove code from Container component names _ deferred until later (or never) *//* line 90 */
    return  s;                /* line 91 *//* line 92 *//* line 93 */
}

function generate_shell_components (reg,container_list) {/* line 94 */
    /*  [ */                  /* line 95 */
    /*      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 96 */
    /*      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} *//* line 97 */
    /*  ] */                  /* line 98 */
    if ( null!= container_list) {/* line 99 */
      for (let diagram of  container_list) {/* line 100 */
        /*  loop through every component in the diagram and look for names that start with “$“ or “'“  *//* line 101 */
        /*  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 102 */
        for (let child_descriptor of  diagram [ "children"]) {/* line 103 */
          if (first_char_is ( child_descriptor [ "name"], "$")) {/* line 104 */
            let name =  child_descriptor [ "name"];/* line 105 */
            let cmd =   name.substring (1) .strip ();/* line 106 */
            let generated_leaf = mkTemplate ( name, cmd, shell_out_instantiate)/* line 107 */;
            register_component ( reg, generated_leaf)/* line 108 */}
          else if (first_char_is ( child_descriptor [ "name"], "'")) {/* line 109 */
            let name =  child_descriptor [ "name"];/* line 110 */
            let s =   name.substring (1) /* line 111 */;
            let generated_leaf = mkTemplate ( name, s, string_constant_instantiate)/* line 112 */;
            register_component_allow_overwriting ( reg, generated_leaf)/* line 113 *//* line 114 */}/* line 115 */}/* line 116 */}/* line 117 */}
    return  reg;              /* line 118 *//* line 119 *//* line 120 */
}

function first_char (s) {     /* line 121 */
    return   s[0]             /* line 122 */;/* line 123 *//* line 124 */
}

function first_char_is (s,c) {/* line 125 */
    return  c == first_char ( s)/* line 126 */;/* line 127 *//* line 128 */
}
                              /* line 129 */
/*  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here *//* line 130 */
/*  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped *//* line 131 *//* line 132 *//* line 133 */
/*  Data for an asyncronous component _ effectively, a function with input *//* line 134 */
/*  and output queues of messages. *//* line 135 */
/*  */                        /* line 136 */
/*  Components can either be a user_supplied function (“lea“), or a “container“ *//* line 137 */
/*  that routes messages to child components according to a list of connections *//* line 138 */
/*  that serve as a message routing table. *//* line 139 */
/*  */                        /* line 140 */
/*  Child components themselves can be leaves or other containers. *//* line 141 */
/*  */                        /* line 142 */
/*  `handler` invokes the code that is attached to this component. *//* line 143 */
/*  */                        /* line 144 */
/*  `instance_data` is a pointer to instance data that the `leaf_handler` *//* line 145 */
/*  function may want whenever it is invoked again. *//* line 146 */
/*  */                        /* line 147 *//* line 148 */
/*  Eh_States :: enum { idle, active } *//* line 149 */
class Eh {
  constructor () {            /* line 150 */

    this.name =  "";          /* line 151 */
    this.inq =  []            /* line 152 */;
    this.outq =  []           /* line 153 */;
    this.owner =  null;       /* line 154 */
    this.children = [];       /* line 155 */
    this.visit_ordering =  [] /* line 156 */;
    this.connections = [];    /* line 157 */
    this.routings =  []       /* line 158 */;
    this.handler =  null;     /* line 159 */
    this.finject =  null;     /* line 160 */
    this.instance_data =  null;/* line 161 */
    this.state =  "idle";     /* line 162 *//*  bootstrap debugging *//* line 163 */
    this.kind =  null;/*  enum { container, leaf, } *//* line 164 *//* line 165 */
  }
}
                              /* line 166 */
/*  Creates a component that acts as a container. It is the same as a `Eh` instance *//* line 167 */
/*  whose handler function is `container_handler`. *//* line 168 */
function make_container (name,owner) {/* line 169 */
    let  eh =  new Eh ();     /* line 170 */;
    eh.name =  name;          /* line 171 */
    eh.owner =  owner;        /* line 172 */
    eh.handler =  container_handler;/* line 173 */
    eh.finject =  container_injector;/* line 174 */
    eh.state =  "idle";       /* line 175 */
    eh.kind =  "container";   /* line 176 */
    return  eh;               /* line 177 *//* line 178 *//* line 179 */
}

/*  Creates a new leaf component out of a handler function, and a data parameter *//* line 180 */
/*  that will be passed back to your handler when called. *//* line 181 *//* line 182 */
function make_leaf (name,owner,instance_data,handler) {/* line 183 */
    let  eh =  new Eh ();     /* line 184 */;
    eh.name =  `${ owner.name}${ `${ "."}${ name}` }` /* line 185 */;
    eh.owner =  owner;        /* line 186 */
    eh.handler =  handler;    /* line 187 */
    eh.instance_data =  instance_data;/* line 188 */
    eh.state =  "idle";       /* line 189 */
    eh.kind =  "leaf";        /* line 190 */
    return  eh;               /* line 191 *//* line 192 *//* line 193 */
}

/*  Sends a message on the given `port` with `data`, placing it on the output *//* line 194 */
/*  of the given component. *//* line 195 *//* line 196 */
function send (eh,port,datum,causingMessage) {/* line 197 */
    let msg = make_message ( port, datum)/* line 198 */;
    put_output ( eh, msg)     /* line 199 *//* line 200 *//* line 201 */
}

function send_string (eh,port,s,causingMessage) {/* line 202 */
    let datum = new_datum_string ( s)/* line 203 */;
    let msg = make_message ( port, datum)/* line 204 */;
    put_output ( eh, msg)     /* line 205 *//* line 206 *//* line 207 */
}

function forward (eh,port,msg) {/* line 208 */
    let fwdmsg = make_message ( port, msg.datum)/* line 209 */;
    put_output ( eh, msg)     /* line 210 *//* line 211 *//* line 212 */
}

function inject (eh,msg) {    /* line 213 */
    eh.finject ( eh, msg)     /* line 214 *//* line 215 *//* line 216 */
}

/*  Returns a list of all output messages on a container. *//* line 217 */
/*  For testing / debugging purposes. *//* line 218 *//* line 219 */
function output_list (eh) {   /* line 220 */
    return  eh.outq;          /* line 221 *//* line 222 *//* line 223 */
}

/*  Utility for printing an array of messages. *//* line 224 */
function print_output_list (eh) {/* line 225 */
    console.log ( "{");       /* line 226 */
    for (let m of   eh.outq) {/* line 227 */
      console.log (format_message ( m));/* line 228 *//* line 229 */}
    console.log ( "}");       /* line 230 *//* line 231 *//* line 232 */
}

function spaces (n) {         /* line 233 */
    let  s =  "";             /* line 234 */
    for (let i of range( n)) {/* line 235 */
      s =  s+ " ";            /* line 236 */}
    return  s;                /* line 237 *//* line 238 *//* line 239 */
}

function set_active (eh) {    /* line 240 */
    eh.state =  "active";     /* line 241 *//* line 242 *//* line 243 */
}

function set_idle (eh) {      /* line 244 */
    eh.state =  "idle";       /* line 245 *//* line 246 *//* line 247 */
}

/*  Utility for printing a specific output message. *//* line 248 *//* line 249 */
function fetch_first_output (eh,port) {/* line 250 */
    for (let msg of   eh.outq) {/* line 251 */
      if (( msg.port ==  port)) {/* line 252 */
        return  msg.datum;}   /* line 253 */}
    return  null;             /* line 254 *//* line 255 *//* line 256 */
}

function print_specific_output (eh,port) {/* line 257 */
    /*  port ∷ “” */          /* line 258 */
    let  datum = fetch_first_output ( eh, port)/* line 259 */;
    console.log ( datum.srepr ());/* line 260 *//* line 261 */
}

function print_specific_output_to_stderr (eh,port) {/* line 262 */
    /*  port ∷ “” */          /* line 263 */
    let  datum = fetch_first_output ( eh, port)/* line 264 */;
    /*  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... *//* line 265 */
    console.error ( datum.srepr ());/* line 266 *//* line 267 *//* line 268 */
}

function put_output (eh,msg) {/* line 269 */
    eh.outq.push ( msg)       /* line 270 *//* line 271 *//* line 272 */
}

let  root_project =  "";      /* line 273 */
let  root_0D =  "";           /* line 274 *//* line 275 */
function set_environment (rproject,r0D) {/* line 276 *//* line 277 *//* line 278 */
    root_project =  rproject; /* line 279 */
    root_0D =  r0D;           /* line 280 *//* line 281 *//* line 282 */
}

function probe_instantiate (reg,owner,name,template_data) {/* line 283 */
    let name_with_id = gensymbol ( "?")/* line 284 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 285 */;/* line 286 */
}

function probeA_instantiate (reg,owner,name,template_data) {/* line 287 */
    let name_with_id = gensymbol ( "?A")/* line 288 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 289 */;/* line 290 *//* line 291 */
}

function probeB_instantiate (reg,owner,name,template_data) {/* line 292 */
    let name_with_id = gensymbol ( "?B")/* line 293 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 294 */;/* line 295 *//* line 296 */
}

function probeC_instantiate (reg,owner,name,template_data) {/* line 297 */
    let name_with_id = gensymbol ( "?C")/* line 298 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 299 */;/* line 300 *//* line 301 */
}

function probe_handler (eh,msg) {/* line 302 */
    let s =  msg.datum.srepr ();/* line 303 */
    console.error ( `${ "... probe "}${ `${ eh.name}${ `${ ": "}${ s}` }` }` );/* line 304 *//* line 305 *//* line 306 */
}

function trash_instantiate (reg,owner,name,template_data) {/* line 307 */
    let name_with_id = gensymbol ( "trash")/* line 308 */;
    return make_leaf ( name_with_id, owner, null, trash_handler)/* line 309 */;/* line 310 *//* line 311 */
}

function trash_handler (eh,msg) {/* line 312 */
    /*  to appease dumped_on_floor checker *//* line 313 *//* line 314 *//* line 315 */
}

class TwoMessages {
  constructor () {            /* line 316 */

    this.firstmsg =  null;    /* line 317 */
    this.secondmsg =  null;   /* line 318 *//* line 319 */
  }
}
                              /* line 320 */
/*  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } *//* line 321 */
class Deracer_Instance_Data {
  constructor () {            /* line 322 */

    this.state =  null;       /* line 323 */
    this.buffer =  null;      /* line 324 *//* line 325 */
  }
}
                              /* line 326 */
function reclaim_Buffers_from_heap (inst) {/* line 327 *//* line 328 *//* line 329 *//* line 330 */
}

function deracer_instantiate (reg,owner,name,template_data) {/* line 331 */
    let name_with_id = gensymbol ( "deracer")/* line 332 */;
    let  inst =  new Deracer_Instance_Data ();/* line 333 */;
    inst.state =  "idle";     /* line 334 */
    inst.buffer =  new TwoMessages ();/* line 335 */;
    let eh = make_leaf ( name_with_id, owner, inst, deracer_handler)/* line 336 */;
    return  eh;               /* line 337 *//* line 338 *//* line 339 */
}

function send_firstmsg_then_secondmsg (eh,inst) {/* line 340 */
    forward ( eh, "1", inst.buffer.firstmsg)/* line 341 */
    forward ( eh, "2", inst.buffer.secondmsg)/* line 342 */
    reclaim_Buffers_from_heap ( inst)/* line 343 *//* line 344 *//* line 345 */
}

function deracer_handler (eh,msg) {/* line 346 */
    let  inst =  eh.instance_data;/* line 347 */
    if ( inst.state ==  "idle") {/* line 348 */
      if ( "1" ==  msg.port) {/* line 349 */
        inst.buffer.firstmsg =  msg;/* line 350 */
        inst.state =  "waitingForSecondmsg";/* line 351 */}
      else if ( "2" ==  msg.port) {/* line 352 */
        inst.buffer.secondmsg =  msg;/* line 353 */
        inst.state =  "waitingForFirstmsg";/* line 354 */}
      else {                  /* line 355 */
        runtime_error ( `${ "bad msg.port (case A) for deracer "}${ msg.port}` )}/* line 356 */}
    else if ( inst.state ==  "waitingForFirstmsg") {/* line 357 */
      if ( "1" ==  msg.port) {/* line 358 */
        inst.buffer.firstmsg =  msg;/* line 359 */
        send_firstmsg_then_secondmsg ( eh, inst)/* line 360 */
        inst.state =  "idle"; /* line 361 */}
      else {                  /* line 362 */
        runtime_error ( `${ "bad msg.port (case B) for deracer "}${ msg.port}` )}/* line 363 */}
    else if ( inst.state ==  "waitingForSecondmsg") {/* line 364 */
      if ( "2" ==  msg.port) {/* line 365 */
        inst.buffer.secondmsg =  msg;/* line 366 */
        send_firstmsg_then_secondmsg ( eh, inst)/* line 367 */
        inst.state =  "idle"; /* line 368 */}
      else {                  /* line 369 */
        runtime_error ( `${ "bad msg.port (case C) for deracer "}${ msg.port}` )}/* line 370 */}
    else {                    /* line 371 */
      runtime_error ( "bad state for deracer {eh.state}")/* line 372 */}/* line 373 *//* line 374 */
}

function low_level_read_text_file_instantiate (reg,owner,name,template_data) {/* line 375 */
    let name_with_id = gensymbol ( "Low Level Read Text File")/* line 376 */;
    return make_leaf ( name_with_id, owner, null, low_level_read_text_file_handler)/* line 377 */;/* line 378 *//* line 379 */
}

function low_level_read_text_file_handler (eh,msg) {/* line 380 */
    let fname =  msg.datum.srepr ();/* line 381 */

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
                              /* line 382 *//* line 383 *//* line 384 */
}

function ensure_string_datum_instantiate (reg,owner,name,template_data) {/* line 385 */
    let name_with_id = gensymbol ( "Ensure String Datum")/* line 386 */;
    return make_leaf ( name_with_id, owner, null, ensure_string_datum_handler)/* line 387 */;/* line 388 *//* line 389 */
}

function ensure_string_datum_handler (eh,msg) {/* line 390 */
    if ( "string" ==  msg.datum.kind ()) {/* line 391 */
      forward ( eh, "", msg)  /* line 392 */}
    else {                    /* line 393 */
      let emsg =  `${ "*** ensure: type error (expected a string datum) but got "}${ msg.datum}` /* line 394 */;
      send_string ( eh, "✗", emsg, msg)/* line 395 */}/* line 396 *//* line 397 */
}

class Syncfilewrite_Data {
  constructor () {            /* line 398 */

    this.filename =  "";      /* line 399 *//* line 400 */
  }
}
                              /* line 401 */
/*  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) *//* line 402 */
function syncfilewrite_instantiate (reg,owner,name,template_data) {/* line 403 */
    let name_with_id = gensymbol ( "syncfilewrite")/* line 404 */;
    let inst =  new Syncfilewrite_Data ();/* line 405 */;
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)/* line 406 */;/* line 407 *//* line 408 */
}

function syncfilewrite_handler (eh,msg) {/* line 409 */
    let  inst =  eh.instance_data;/* line 410 */
    if ( "filename" ==  msg.port) {/* line 411 */
      inst.filename =  msg.datum.srepr ();/* line 412 */}
    else if ( "input" ==  msg.port) {/* line 413 */
      let contents =  msg.datum.srepr ();/* line 414 */
      let  f = open ( inst.filename, "w")/* line 415 */;
      if ( f!= null) {        /* line 416 */
        f.write ( msg.datum.srepr ())/* line 417 */
        f.close ()            /* line 418 */
        send ( eh, "done",new_datum_bang (), msg)/* line 419 */}
      else {                  /* line 420 */
        send_string ( eh, "✗", `${ "open error on file "}${ inst.filename}` , msg)}/* line 421 */}/* line 422 *//* line 423 */
}

class StringConcat_Instance_Data {
  constructor () {            /* line 424 */

    this.buffer1 =  null;     /* line 425 */
    this.buffer2 =  null;     /* line 426 */
    this.scount =  0;         /* line 427 *//* line 428 */
  }
}
                              /* line 429 */
function stringconcat_instantiate (reg,owner,name,template_data) {/* line 430 */
    let name_with_id = gensymbol ( "stringconcat")/* line 431 */;
    let instp =  new StringConcat_Instance_Data ();/* line 432 */;
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)/* line 433 */;/* line 434 *//* line 435 */
}

function stringconcat_handler (eh,msg) {/* line 436 */
    let  inst =  eh.instance_data;/* line 437 */
    if ( "1" ==  msg.port) {  /* line 438 */
      inst.buffer1 = clone_string ( msg.datum.srepr ())/* line 439 */;
      inst.scount =  inst.scount+ 1;/* line 440 */
      maybe_stringconcat ( eh, inst, msg)/* line 441 */}
    else if ( "2" ==  msg.port) {/* line 442 */
      inst.buffer2 = clone_string ( msg.datum.srepr ())/* line 443 */;
      inst.scount =  inst.scount+ 1;/* line 444 */
      maybe_stringconcat ( eh, inst, msg)/* line 445 */}
    else {                    /* line 446 */
      runtime_error ( `${ "bad msg.port for stringconcat: "}${ msg.port}` )/* line 447 *//* line 448 */}/* line 449 *//* line 450 */
}

function maybe_stringconcat (eh,inst,msg) {/* line 451 */
    if (((( 0 == ( inst.buffer1.length))) && (( 0 == ( inst.buffer2.length))))) {/* line 452 */
      runtime_error ( "something is wrong in stringconcat, both strings are 0 length")/* line 453 */}
    if ( inst.scount >=  2) { /* line 454 */
      let  concatenated_string =  "";/* line 455 */
      if ( 0 == ( inst.buffer1.length)) {/* line 456 */
        concatenated_string =  inst.buffer2;/* line 457 */}
      else if ( 0 == ( inst.buffer2.length)) {/* line 458 */
        concatenated_string =  inst.buffer1;/* line 459 */}
      else {                  /* line 460 */
        concatenated_string =  inst.buffer1+ inst.buffer2;/* line 461 */}
      send_string ( eh, "", concatenated_string, msg)/* line 462 */
      inst.buffer1 =  null;   /* line 463 */
      inst.buffer2 =  null;   /* line 464 */
      inst.scount =  0;       /* line 465 */}/* line 466 *//* line 467 */
}

/*  */                        /* line 468 *//* line 469 */
/*  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here *//* line 470 */
function shell_out_instantiate (reg,owner,name,template_data) {/* line 471 */
    let name_with_id = gensymbol ( "shell_out")/* line 472 */;
    let cmd =  template_data.split (" ")/* line 473 */;
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)/* line 474 */;/* line 475 *//* line 476 */
}

function shell_out_handler (eh,msg) {/* line 477 */
    let cmd =  eh.instance_data;/* line 478 */
    let s =  msg.datum.srepr ();/* line 479 */
    let  ret =  null;         /* line 480 */
    let  rc =  null;          /* line 481 */
    let  stdout =  null;      /* line 482 */
    let  stderr =  null;      /* line 483 */

    stdout = execSync(`${ cmd} ${ s}`, { encoding: 'utf-8' });
    ret = true;
                              /* line 484 */
    if ( rc!= 0) {            /* line 485 */
      send_string ( eh, "✗", stderr, msg)/* line 486 */}
    else {                    /* line 487 */
      send_string ( eh, "", stdout, msg)/* line 488 *//* line 489 */}/* line 490 *//* line 491 */
}

function string_constant_instantiate (reg,owner,name,template_data) {/* line 492 *//* line 493 *//* line 494 */
    let name_with_id = gensymbol ( "strconst")/* line 495 */;
    let  s =  template_data;  /* line 496 */
    if ( root_project!= "") { /* line 497 */
      s =  s.replaceAll ( "_00_",  root_project)/* line 498 */;/* line 499 */}
    if ( root_0D!= "") {      /* line 500 */
      s =  s.replaceAll ( "_0D_",  root_0D)/* line 501 */;/* line 502 */}
    return make_leaf ( name_with_id, owner, s, string_constant_handler)/* line 503 */;/* line 504 *//* line 505 */
}

function string_constant_handler (eh,msg) {/* line 506 */
    let s =  eh.instance_data;/* line 507 */
    send_string ( eh, "", s, msg)/* line 508 *//* line 509 *//* line 510 */
}

function string_make_persistent (s) {/* line 511 */
    /*  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python *//* line 512 */
    return  s;                /* line 513 *//* line 514 *//* line 515 */
}

function string_clone (s) {   /* line 516 */
    return  s;                /* line 517 *//* line 518 *//* line 519 */
}

/*  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... *//* line 520 */
/*  where ${_00_} is the root directory for the project *//* line 521 */
/*  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) *//* line 522 *//* line 523 */
function initialize_component_palette (root_project,root_0D,diagram_source_files) {/* line 524 */
    let  reg = make_component_registry ();/* line 525 */
    for (let diagram_source of  diagram_source_files) {/* line 526 */
      let all_containers_within_single_file = json2internal ( root_project, diagram_source)/* line 527 */;
      reg = generate_shell_components ( reg, all_containers_within_single_file)/* line 528 */;
      for (let container of  all_containers_within_single_file) {/* line 529 */
        register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 530 *//* line 531 */}/* line 532 */}
    initialize_stock_components ( reg)/* line 533 */
    return  reg;              /* line 534 *//* line 535 *//* line 536 */
}

function print_error_maybe (main_container) {/* line 537 */
    let error_port =  "✗";    /* line 538 */
    let err = fetch_first_output ( main_container, error_port)/* line 539 */;
    if (((( err!= null)) && (( 0 < (trimws ( err.srepr ()).length))))) {/* line 540 */
      console.log ( "___ !!! ERRORS !!! ___");/* line 541 */
      print_specific_output ( main_container, error_port)/* line 542 */}/* line 543 *//* line 544 */
}

/*  debugging helpers */      /* line 545 *//* line 546 */
function nl () {              /* line 547 */
    console.log ( "");        /* line 548 *//* line 549 *//* line 550 */
}

function dump_outputs (main_container) {/* line 551 */
    nl ()                     /* line 552 */
    console.log ( "___ Outputs ___");/* line 553 */
    print_output_list ( main_container)/* line 554 *//* line 555 *//* line 556 */
}

function trimws (s) {         /* line 557 */
    /*  remove whitespace from front and back of string *//* line 558 */
    return  s.strip ();       /* line 559 *//* line 560 *//* line 561 */
}

function clone_string (s) {   /* line 562 */
    return  s                 /* line 563 *//* line 564 */;/* line 565 */
}

let  load_errors =  false;    /* line 566 */
let  runtime_errors =  false; /* line 567 *//* line 568 */
function load_error (s) {     /* line 569 *//* line 570 */
    console.log ( s);         /* line 571 */
    console.log ();           /* line 572 */
    load_errors =  true;      /* line 573 *//* line 574 *//* line 575 */
}

function runtime_error (s) {  /* line 576 *//* line 577 */
    console.log ( s);         /* line 578 */
    runtime_errors =  true;   /* line 579 *//* line 580 *//* line 581 */
}

function fakepipename_instantiate (reg,owner,name,template_data) {/* line 582 */
    let instance_name = gensymbol ( "fakepipe")/* line 583 */;
    return make_leaf ( instance_name, owner, null, fakepipename_handler)/* line 584 */;/* line 585 *//* line 586 */
}

let  rand =  0;               /* line 587 *//* line 588 */
function fakepipename_handler (eh,msg) {/* line 589 *//* line 590 */
    rand =  rand+ 1;
    /*  not very random, but good enough _ 'rand' must be unique within a single run *//* line 591 */
    send_string ( eh, "", `${ "/tmp/fakepipe"}${ rand}` , msg)/* line 592 *//* line 593 *//* line 594 */
}
                              /* line 595 */
/*  all of the the built_in leaves are listed here *//* line 596 */
/*  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project *//* line 597 *//* line 598 */
function initialize_stock_components (reg) {/* line 599 */
    register_component ( reg,mkTemplate ( "1then2", null, deracer_instantiate))/* line 600 */
    register_component ( reg,mkTemplate ( "?", null, probe_instantiate))/* line 601 */
    register_component ( reg,mkTemplate ( "?A", null, probeA_instantiate))/* line 602 */
    register_component ( reg,mkTemplate ( "?B", null, probeB_instantiate))/* line 603 */
    register_component ( reg,mkTemplate ( "?C", null, probeC_instantiate))/* line 604 */
    register_component ( reg,mkTemplate ( "trash", null, trash_instantiate))/* line 605 *//* line 606 */
    register_component ( reg,mkTemplate ( "Low Level Read Text File", null, low_level_read_text_file_instantiate))/* line 607 */
    register_component ( reg,mkTemplate ( "Ensure String Datum", null, ensure_string_datum_instantiate))/* line 608 *//* line 609 */
    register_component ( reg,mkTemplate ( "syncfilewrite", null, syncfilewrite_instantiate))/* line 610 */
    register_component ( reg,mkTemplate ( "stringconcat", null, stringconcat_instantiate))/* line 611 */
    /*  for fakepipe */       /* line 612 */
    register_component ( reg,mkTemplate ( "fakepipename", null, fakepipename_instantiate))/* line 613 *//* line 614 *//* line 615 */
}

function argv () {            /* line 616 */
    return  argv              /* line 617 */;/* line 618 *//* line 619 */
}

function initialize () {      /* line 620 */
    let root_of_project =  argv[ 1] /* line 621 */;
    let root_of_0D =  argv[ 2] /* line 622 */;
    let arg =  argv[ 3]       /* line 623 */;
    let main_container_name =  argv[ 4] /* line 624 */;
    let diagram_names =  argv.splice ( 5) /* line 625 */;
    let palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)/* line 626 */;
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]];/* line 627 *//* line 628 *//* line 629 */
}

function start (palette,env) {
    start_helper ( palette, env, false)/* line 630 */
}

function start_show_all (palette,env) {
    start_helper ( palette, env, true)/* line 631 */
}

function start_helper (palette,env,show_all_outputs) {/* line 632 */
    let root_of_project =  env [ 0];/* line 633 */
    let root_of_0D =  env [ 1];/* line 634 */
    let main_container_name =  env [ 2];/* line 635 */
    let diagram_names =  env [ 3];/* line 636 */
    let arg =  env [ 4];      /* line 637 */
    set_environment ( root_of_project, root_of_0D)/* line 638 */
    /*  get entrypoint container *//* line 639 */
    let  main_container = get_component_instance ( palette, main_container_name, null)/* line 640 */;
    if ( null ==  main_container) {/* line 641 */
      load_error ( `${ "Couldn't find container with page name /"}${ `${ main_container_name}${ `${ "/ in files "}${ `${`${ diagram_names}`}${ " (check tab names, or disable compression?)"}` }` }` }` )/* line 645 *//* line 646 */}
    if ((!  load_errors)) {   /* line 647 */
      let  marg = new_datum_string ( arg)/* line 648 */;
      let  msg = make_message ( "", marg)/* line 649 */;
      inject ( main_container, msg)/* line 650 */
      if ( show_all_outputs) {/* line 651 */
        dump_outputs ( main_container)/* line 652 */}
      else {                  /* line 653 */
        print_error_maybe ( main_container)/* line 654 */
        let outp = fetch_first_output ( main_container, "")/* line 655 */;
        if ( null ==  outp) { /* line 656 */
          console.log ( "(no outputs)");/* line 657 */}
        else {                /* line 658 */
          print_specific_output ( main_container, "")/* line 659 *//* line 660 */}/* line 661 */}
      if ( show_all_outputs) {/* line 662 */
        console.log ( "--- done ---");/* line 663 *//* line 664 */}/* line 665 */}/* line 666 *//* line 667 */
}
                              /* line 668 *//* line 669 */
/*  utility functions  */     /* line 670 */
function send_int (eh,port,i,causing_message) {/* line 671 */
    let datum = new_datum_int ( i)/* line 672 */;
    send ( eh, port, datum, causing_message)/* line 673 *//* line 674 *//* line 675 */
}

function send_bang (eh,port,causing_message) {/* line 676 */
    let datum = new_datum_bang ();/* line 677 */
    send ( eh, port, datum, causing_message)/* line 678 *//* line 679 *//* line 680 */
}







let  count_counter =  0;      /* line 1 */
let  count_direction =  1;    /* line 2 *//* line 3 */
function count_handler (eh,msg) {/* line 4 *//* line 5 */
    if ( msg.port ==  "adv") {/* line 6 */
      count_counter =  count_counter+ count_direction;/* line 7 */
      send_int ( eh, "", count_counter, msg)/* line 8 */}
    else if ( msg.port ==  "rev") {/* line 9 */
      count_direction = (- count_direction)/* line 10 */;/* line 11 */}/* line 12 *//* line 13 */
}

function count_instantiator (reg,owner,name,template_data) {/* line 14 */
    let name_with_id = gensymbol ( "Count")/* line 15 */;
    return make_leaf ( name_with_id, owner, null, count_handler)/* line 16 */;/* line 17 *//* line 18 */
}

function count_install (reg) {/* line 19 */
    register_component ( reg,mkTemplate ( "Count", null, count_instantiator))/* line 20 *//* line 21 */
}







function decode_install (reg) {/* line 1 */
    register_component ( reg,mkTemplate ( "Decode", null, decode_instantiator))/* line 2 *//* line 3 *//* line 4 */
}

let  decode_digits = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];/* line 5 */
function decode_handler (eh,msg) {/* line 6 *//* line 7 */
    let  i = Number ( msg.datum.srepr ())/* line 8 */;
    if ((( i >=  0) && ( i <=  9))) {/* line 9 */
      send_string ( eh, decode_digits [ i], decode_digits [ i], msg)/* line 10 *//* line 11 */}
    send_bang ( eh, "done", msg)/* line 12 *//* line 13 *//* line 14 */
}

function decode_instantiator (reg,owner,name,template_data) {/* line 15 */
    let name_with_id = gensymbol ( "Decode")/* line 16 */;
    return make_leaf ( name_with_id, owner, null, decode_handler)/* line 17 */;
}







function reverser_install (reg) {/* line 1 */
    register_component ( reg,mkTemplate ( "Reverser", null, reverser_instantiator))/* line 2 *//* line 3 *//* line 4 */
}

let  reverser_state =  "J";   /* line 5 *//* line 6 */
function reverser_handler (eh,msg) {/* line 7 *//* line 8 */
    if ( reverser_state ==  "K") {/* line 9 */
      if ( msg.port ==  "J") {/* line 10 */
        send_bang ( eh, "", msg)/* line 11 */
        reverser_state =  "J";/* line 12 */}
      else {                  /* line 13 *//* line 14 *//* line 15 */}}
    else if ( reverser_state ==  "J") {/* line 16 */
      if ( msg.port ==  "K") {/* line 17 */
        send_bang ( eh, "", msg)/* line 18 */
        reverser_state =  "K";/* line 19 */}
      else {                  /* line 20 *//* line 21 *//* line 22 */}/* line 23 */}/* line 24 *//* line 25 */
}

function reverser_instantiator (reg,owner,name,template_data) {/* line 26 */
    let name_with_id = gensymbol ( "Reverser")/* line 27 */;
    return make_leaf ( name_with_id, owner, null, reverser_handler)/* line 28 */;/* line 29 */
}







function delay_install (reg) {/* line 1 */
    register_component ( reg,mkTemplate ( "Delay", null, delay_instantiator))/* line 2 *//* line 3 *//* line 4 */
}

class Delay_Info {
  constructor () {            /* line 5 */

    this.counter =  0;        /* line 6 */
    this.saved_message =  null;/* line 7 *//* line 8 */
  }
}
                              /* line 9 */
function delay_instantiator (reg,owner,name,template_data) {/* line 10 */
    let name_with_id = gensymbol ( "delay")/* line 11 */;
    let info =  new Delay_Info ();/* line 12 */;
    return make_leaf ( name_with_id, owner, info, delay_handler)/* line 13 */;/* line 14 *//* line 15 */
}

let  DELAYDELAY =  5000;      /* line 16 *//* line 17 */
function first_time (m) {     /* line 18 */
    return (! is_tick ( m)    /* line 19 */);/* line 20 *//* line 21 */
}

function delay_handler (eh,msg) {/* line 22 */
    let info =  eh.instance_data;/* line 23 */
    if (first_time ( msg)) {  /* line 24 */
      info.saved_message =  msg;/* line 25 */
      set_active ( eh)
      /*  tell engine to keep running this component with ;ticks'  *//* line 26 *//* line 27 */}/* line 28 */
    let count =  info.counter;/* line 29 */
    let  next =  count+ 1;    /* line 30 */
    if ( info.counter >=  DELAYDELAY) {/* line 31 */
      set_idle ( eh)
      /*  tell engine that we're finally done  *//* line 32 */
      forward ( eh, "", info.saved_message)/* line 33 */
      next =  0;              /* line 34 *//* line 35 */}
    info.counter =  next;     /* line 36 *//* line 37 *//* line 38 */
}







function monitor_install (reg) {/* line 1 */
    register_component ( reg,mkTemplate ( "@", null, monitor_instantiator))/* line 2 *//* line 3 *//* line 4 */
}

function monitor_instantiator (reg,owner,name,template_data) {/* line 5 */
    let name_with_id = gensymbol ( "@")/* line 6 */;
    return make_leaf ( name_with_id, owner, null, monitor_handler)/* line 7 */;/* line 8 *//* line 9 */
}

function monitor_handler (eh,msg) {/* line 10 */
    let  s =  msg.datum.srepr ();/* line 11 */
    let  i = Number ( s)      /* line 12 */;
    while ( i >  0) {         /* line 13 */
      s =  `${ " "}${ s}`     /* line 14 */;
      i =  i- 1;              /* line 15 *//* line 16 */}
    console.log ( s);         /* line 17 *//* line 18 */
}





