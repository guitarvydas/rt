

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
      return  `${ "⟪"}${ `${ m.port}${ `${ "⦂"}${ `${ m.datum.srepr ()}${ "⟫"}` }` }` }` /* line 225 */;/* line 226 */}/* line 227 *//* line 228 */
}
                              /* line 229 */
const  enumDown =  0          /* line 230 */;
const  enumAcross =  1        /* line 231 */;
const  enumUp =  2            /* line 232 */;
const  enumThrough =  3       /* line 233 */;/* line 234 */
function create_down_connector (container,proto_conn,connectors,children_by_id) {/* line 235 */
    /*  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, *//* line 236 */
    let  connector =  new Connector ();/* line 237 */;
    connector.direction =  "down";/* line 238 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 239 */;
    let target_proto =  proto_conn [ "target"];/* line 240 */
    let id_proto =  target_proto [ "id"];/* line 241 */
    let target_component =  children_by_id [id_proto];/* line 242 */
    if (( target_component ==  null)) {/* line 243 */
      load_error ( `${ "internal error: .Down connection target internal error "}${ proto_conn [ "target"]}` )/* line 244 */}
    else {                    /* line 245 */
      connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 246 */;/* line 247 */}
    return  connector;        /* line 248 *//* line 249 *//* line 250 */
}

function create_across_connector (container,proto_conn,connectors,children_by_id) {/* line 251 */
    let  connector =  new Connector ();/* line 252 */;
    connector.direction =  "across";/* line 253 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 254 */
    let target_component =  children_by_id [(( proto_conn [ "target"]) [ "id"])];/* line 255 */
    if ( source_component ==  null) {/* line 256 */
      load_error ( `${ "internal error: .Across connection source not ok "}${ proto_conn [ "source"]}` )/* line 257 */}
    else {                    /* line 258 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 259 */;
      if ( target_component ==  null) {/* line 260 */
        load_error ( `${ "internal error: .Across connection target not ok "}${ proto_conn.target}` )/* line 261 */}
      else {                  /* line 262 */
        connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 263 */;/* line 264 */}/* line 265 */}
    return  connector;        /* line 266 *//* line 267 *//* line 268 */
}

function create_up_connector (container,proto_conn,connectors,children_by_id) {/* line 269 */
    let  connector =  new Connector ();/* line 270 */;
    connector.direction =  "up";/* line 271 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 272 */
    if ( source_component ==  null) {/* line 273 */
      print ( `${ "internal error: .Up connection source not ok "}${ proto_conn [ "source"]}` )/* line 274 */}
    else {                    /* line 275 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 276 */;
      connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 277 */;/* line 278 */}
    return  connector;        /* line 279 *//* line 280 *//* line 281 */
}

function create_through_connector (container,proto_conn,connectors,children_by_id) {/* line 282 */
    let  connector =  new Connector ();/* line 283 */;
    connector.direction =  "through";/* line 284 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 285 */;
    connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 286 */;
    return  connector;        /* line 287 *//* line 288 *//* line 289 */
}
                              /* line 290 */
function container_instantiator (reg,owner,container_name,desc) {/* line 291 *//* line 292 */
    let container = make_container ( container_name, owner)/* line 293 */;
    let children = [];        /* line 294 */
    let children_by_id = {};
    /*  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here *//* line 295 */
    /*  collect children */   /* line 296 */
    for (let child_desc of  desc [ "children"]) {/* line 297 */
      let child_instance = get_component_instance ( reg, child_desc [ "name"], container)/* line 298 */;
      children.push ( child_instance) /* line 299 */
      let id =  child_desc [ "id"];/* line 300 */
      children_by_id [id] =  child_instance;/* line 301 *//* line 302 *//* line 303 */}
    container.children =  children;/* line 304 *//* line 305 */
    let connectors = [];      /* line 306 */
    for (let proto_conn of  desc [ "connections"]) {/* line 307 */
      let  connector =  new Connector ();/* line 308 */;
      if ( proto_conn [ "dir"] ==  enumDown) {/* line 309 */
        connectors.push (create_down_connector ( container, proto_conn, connectors, children_by_id)) /* line 310 */}
      else if ( proto_conn [ "dir"] ==  enumAcross) {/* line 311 */
        connectors.push (create_across_connector ( container, proto_conn, connectors, children_by_id)) /* line 312 */}
      else if ( proto_conn [ "dir"] ==  enumUp) {/* line 313 */
        connectors.push (create_up_connector ( container, proto_conn, connectors, children_by_id)) /* line 314 */}
      else if ( proto_conn [ "dir"] ==  enumThrough) {/* line 315 */
        connectors.push (create_through_connector ( container, proto_conn, connectors, children_by_id)) /* line 316 *//* line 317 */}/* line 318 */}
    container.connections =  connectors;/* line 319 */
    return  container;        /* line 320 *//* line 321 *//* line 322 */
}

/*  The default handler for container components. *//* line 323 */
function container_handler (container,message) {/* line 324 */
    route ( container, container, message)
    /*  references to 'self' are replaced by the container during instantiation *//* line 325 */
    while (any_child_ready ( container)) {/* line 326 */
      step_children ( container, message)/* line 327 */}/* line 328 *//* line 329 */
}

/*  Frees the given container and associated data. *//* line 330 */
function destroy_container (eh) {/* line 331 *//* line 332 *//* line 333 *//* line 334 */
}

/*  Routing connection for a container component. The `direction` field has *//* line 335 */
/*  no affect on the default message routing system _ it is there for debugging *//* line 336 */
/*  purposes, or for reading by other tools. *//* line 337 *//* line 338 */
class Connector {
  constructor () {            /* line 339 */

    this.direction =  null;/*  down, across, up, through *//* line 340 */
    this.sender =  null;      /* line 341 */
    this.receiver =  null;    /* line 342 *//* line 343 */
  }
}
                              /* line 344 */
/*  `Sender` is used to “pattern match“ which `Receiver` a message should go to, *//* line 345 */
/*  based on component ID (pointer) and port name. *//* line 346 *//* line 347 */
class Sender {
  constructor () {            /* line 348 */

    this.name =  null;        /* line 349 */
    this.component =  null;   /* line 350 */
    this.port =  null;        /* line 351 *//* line 352 */
  }
}
                              /* line 353 *//* line 354 *//* line 355 */
/*  `Receiver` is a handle to a destination queue, and a `port` name to assign *//* line 356 */
/*  to incoming messages to this queue. *//* line 357 *//* line 358 */
class Receiver {
  constructor () {            /* line 359 */

    this.name =  null;        /* line 360 */
    this.queue =  null;       /* line 361 */
    this.port =  null;        /* line 362 */
    this.component =  null;   /* line 363 *//* line 364 */
  }
}
                              /* line 365 */
function mkSender (name,component,port) {/* line 366 */
    let  s =  new Sender ();  /* line 367 */;
    s.name =  name;           /* line 368 */
    s.component =  component; /* line 369 */
    s.port =  port;           /* line 370 */
    return  s;                /* line 371 *//* line 372 *//* line 373 */
}

function mkReceiver (name,component,port,q) {/* line 374 */
    let  r =  new Receiver ();/* line 375 */;
    r.name =  name;           /* line 376 */
    r.component =  component; /* line 377 */
    r.port =  port;           /* line 378 */
    /*  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. *//* line 379 */
    r.queue =  q;             /* line 380 */
    return  r;                /* line 381 *//* line 382 *//* line 383 */
}

/*  Checks if two senders match, by pointer equality and port name matching. *//* line 384 */
function sender_eq (s1,s2) {  /* line 385 */
    let same_components = ( s1.component ==  s2.component);/* line 386 */
    let same_ports = ( s1.port ==  s2.port);/* line 387 */
    return (( same_components) && ( same_ports));/* line 388 *//* line 389 *//* line 390 */
}

/*  Delivers the given message to the receiver of this connector. *//* line 391 *//* line 392 */
function deposit (parent,conn,message) {/* line 393 */
    let new_message = make_message ( conn.receiver.port, message.datum)/* line 394 */;
    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)/* line 395 *//* line 396 *//* line 397 */
}

function force_tick (parent,eh) {/* line 398 */
    let tick_msg = make_message ( ".",new_datum_tick ())/* line 399 */;
    push_message ( parent, eh, eh.inq, tick_msg)/* line 400 */
    return  tick_msg;         /* line 401 *//* line 402 *//* line 403 */
}

function push_message (parent,receiver,inq,m) {/* line 404 */
    inq.push ( m)             /* line 405 */
    parent.visit_ordering.push ( receiver)/* line 406 *//* line 407 *//* line 408 */
}

function is_self (child,container) {/* line 409 */
    /*  in an earlier version “self“ was denoted as ϕ *//* line 410 */
    return  child ==  container;/* line 411 *//* line 412 *//* line 413 */
}

function step_child (child,msg) {/* line 414 */
    let before_state =  child.state;/* line 415 */
    child.handler ( child, msg)/* line 416 */
    let after_state =  child.state;/* line 417 */
    return [(( before_state ==  "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state ==  "idle"))];/* line 420 *//* line 421 *//* line 422 */
}

function step_children (container,causingMessage) {/* line 423 */
    container.state =  "idle";/* line 424 */
    for (let child of   container.visit_ordering) {/* line 425 */
      /*  child = container represents self, skip it *//* line 426 */
      if (((! (is_self ( child, container))))) {/* line 427 */
        if (((! ((0=== child.inq.length))))) {/* line 428 */
          let msg =  child.inq.shift ()/* line 429 */;
          let  began_long_run =  null;/* line 430 */
          let  continued_long_run =  null;/* line 431 */
          let  ended_long_run =  null;/* line 432 */
          [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)/* line 433 */;
          if ( began_long_run) {/* line 434 *//* line 435 */}
          else if ( continued_long_run) {/* line 436 *//* line 437 */}
          else if ( ended_long_run) {/* line 438 *//* line 439 *//* line 440 */}
          destroy_message ( msg)/* line 441 */}
        else {                /* line 442 */
          if ( child.state!= "idle") {/* line 443 */
            let msg = force_tick ( container, child)/* line 444 */;
            child.handler ( child, msg)/* line 445 */
            destroy_message ( msg)}/* line 446 */}/* line 447 */
        if ( child.state ==  "active") {/* line 448 */
          /*  if child remains active, then the container must remain active and must propagate “ticks“ to child *//* line 449 */
          container.state =  "active";/* line 450 */}/* line 451 */
        while (((! ((0=== child.outq.length))))) {/* line 452 */
          let msg =  child.outq.shift ()/* line 453 */;
          route ( container, child, msg)/* line 454 */
          destroy_message ( msg)}}/* line 455 */}/* line 456 *//* line 457 *//* line 458 *//* line 459 */
}

function attempt_tick (parent,eh) {/* line 460 */
    if ( eh.state!= "idle") { /* line 461 */
      force_tick ( parent, eh)/* line 462 */}/* line 463 *//* line 464 */
}

function is_tick (msg) {      /* line 465 */
    return  "tick" ==  msg.datum.kind ();/* line 466 *//* line 467 *//* line 468 */
}

/*  Routes a single message to all matching destinations, according to *//* line 469 */
/*  the container's connection network. *//* line 470 *//* line 471 */
function route (container,from_component,message) {/* line 472 */
    let  was_sent =  false;
    /*  for checking that output went somewhere (at least during bootstrap) *//* line 473 */
    let  fromname =  "";      /* line 474 */
    if (is_tick ( message)) { /* line 475 */
      for (let child of  container.children) {/* line 476 */
        attempt_tick ( container, child)/* line 477 */}
      was_sent =  true;       /* line 478 */}
    else {                    /* line 479 */
      if (((! (is_self ( from_component, container))))) {/* line 480 */
        fromname =  from_component.name;/* line 481 */}
      let from_sender = mkSender ( fromname, from_component, message.port)/* line 482 */;/* line 483 */
      for (let connector of  container.connections) {/* line 484 */
        if (sender_eq ( from_sender, connector.sender)) {/* line 485 */
          deposit ( container, connector, message)/* line 486 */
          was_sent =  true;}} /* line 487 */}
    if ((! ( was_sent))) {    /* line 488 */
      print ( "\n\n*** Error: ***")/* line 489 */
      print ( "***")          /* line 490 */
      print ( `${ container.name}${ `${ ": message '"}${ `${ message.port}${ `${ "' from "}${ `${ fromname}${ " dropped on floor..."}` }` }` }` }` )/* line 491 */
      print ( "***")          /* line 492 */
      process.exit (1)        /* line 493 *//* line 494 */}/* line 495 *//* line 496 */
}

function any_child_ready (container) {/* line 497 */
    for (let child of  container.children) {/* line 498 */
      if (child_is_ready ( child)) {/* line 499 */
        return  true;}        /* line 500 */}
    return  false;            /* line 501 *//* line 502 *//* line 503 */
}

function child_is_ready (eh) {/* line 504 */
    return ((((((((! ((0=== eh.outq.length))))) || (((! ((0=== eh.inq.length))))))) || (( eh.state!= "idle")))) || ((any_child_ready ( eh))));/* line 505 *//* line 506 *//* line 507 */
}

function append_routing_descriptor (container,desc) {/* line 508 */
    container.routings.push ( desc)/* line 509 *//* line 510 *//* line 511 */
}

function container_injector (container,message) {/* line 512 */
    container_handler ( container, message)/* line 513 *//* line 514 *//* line 515 */
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
        /*  loop through every component in the diagram and look for names that start with “$“ *//* line 101 */
        /*  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, *//* line 102 */
        for (let child_descriptor of  diagram [ "children"]) {/* line 103 */
          if (first_char_is ( child_descriptor [ "name"], "$")) {/* line 104 */
            let name =  child_descriptor [ "name"];/* line 105 */
            let cmd =   name.substring (1) .strip ();/* line 106 */
            let generated_leaf = mkTemplate ( name, shell_out_instantiate, cmd)/* line 107 */;
            register_component ( reg, generated_leaf)/* line 108 */}
          else if (first_char_is ( child_descriptor [ "name"], "'")) {/* line 109 */
            let name =  child_descriptor [ "name"];/* line 110 */
            let s =   name.substring (1) /* line 111 */;
            let generated_leaf = mkTemplate ( name, string_constant_instantiate, s)/* line 112 */;
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
    for (let m of   eh.outq) {/* line 226 */
      console.log (format_message ( m));/* line 227 */}/* line 228 *//* line 229 */
}

function spaces (n) {         /* line 230 */
    let  s =  "";             /* line 231 */
    for (let i of range( n)) {/* line 232 */
      s =  s+ " ";            /* line 233 */}
    return  s;                /* line 234 *//* line 235 *//* line 236 */
}

function set_active (eh) {    /* line 237 */
    eh.state =  "active";     /* line 238 *//* line 239 *//* line 240 */
}

function set_idle (eh) {      /* line 241 */
    eh.state =  "idle";       /* line 242 *//* line 243 *//* line 244 */
}

/*  Utility for printing a specific output message. *//* line 245 *//* line 246 */
function fetch_first_output (eh,port) {/* line 247 */
    for (let msg of   eh.outq) {/* line 248 */
      if (( msg.port ==  port)) {/* line 249 */
        return  msg.datum;}   /* line 250 */}
    return  null;             /* line 251 *//* line 252 *//* line 253 */
}

function print_specific_output (eh,port) {/* line 254 */
    /*  port ∷ “” */          /* line 255 */
    let  datum = fetch_first_output ( eh, port)/* line 256 */;
    console.log ( datum.srepr ());/* line 257 *//* line 258 */
}

function print_specific_output_to_stderr (eh,port) {/* line 259 */
    /*  port ∷ “” */          /* line 260 */
    let  datum = fetch_first_output ( eh, port)/* line 261 */;
    /*  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... *//* line 262 */
    console.error ( datum.srepr ());/* line 263 *//* line 264 *//* line 265 */
}

function put_output (eh,msg) {/* line 266 */
    eh.outq.push ( msg)       /* line 267 *//* line 268 *//* line 269 */
}

let  root_project =  "";      /* line 270 */
let  root_0D =  "";           /* line 271 *//* line 272 */
function set_environment (rproject,r0D) {/* line 273 *//* line 274 *//* line 275 */
    root_project =  rproject; /* line 276 */
    root_0D =  r0D;           /* line 277 *//* line 278 *//* line 279 */
}

function probe_instantiate (reg,owner,name,template_data) {/* line 280 */
    let name_with_id = gensymbol ( "?")/* line 281 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 282 */;/* line 283 */
}

function probeA_instantiate (reg,owner,name,template_data) {/* line 284 */
    let name_with_id = gensymbol ( "?A")/* line 285 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 286 */;/* line 287 *//* line 288 */
}

function probeB_instantiate (reg,owner,name,template_data) {/* line 289 */
    let name_with_id = gensymbol ( "?B")/* line 290 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 291 */;/* line 292 *//* line 293 */
}

function probeC_instantiate (reg,owner,name,template_data) {/* line 294 */
    let name_with_id = gensymbol ( "?C")/* line 295 */;
    return make_leaf ( name_with_id, owner, null, probe_handler)/* line 296 */;/* line 297 *//* line 298 */
}

function probe_handler (eh,msg) {/* line 299 */
    let s =  msg.datum.srepr ();/* line 300 */
    console.error ( `${ "... probe "}${ `${ eh.name}${ `${ ": "}${ s}` }` }` );/* line 301 *//* line 302 *//* line 303 */
}

function trash_instantiate (reg,owner,name,template_data) {/* line 304 */
    let name_with_id = gensymbol ( "trash")/* line 305 */;
    return make_leaf ( name_with_id, owner, null, trash_handler)/* line 306 */;/* line 307 *//* line 308 */
}

function trash_handler (eh,msg) {/* line 309 */
    /*  to appease dumped_on_floor checker *//* line 310 *//* line 311 *//* line 312 */
}

class TwoMessages {
  constructor () {            /* line 313 */

    this.firstmsg =  null;    /* line 314 */
    this.secondmsg =  null;   /* line 315 *//* line 316 */
  }
}
                              /* line 317 */
/*  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } *//* line 318 */
class Deracer_Instance_Data {
  constructor () {            /* line 319 */

    this.state =  null;       /* line 320 */
    this.buffer =  null;      /* line 321 *//* line 322 */
  }
}
                              /* line 323 */
function reclaim_Buffers_from_heap (inst) {/* line 324 *//* line 325 *//* line 326 *//* line 327 */
}

function deracer_instantiate (reg,owner,name,template_data) {/* line 328 */
    let name_with_id = gensymbol ( "deracer")/* line 329 */;
    let  inst =  new Deracer_Instance_Data ();/* line 330 */;
    inst.state =  "idle";     /* line 331 */
    inst.buffer =  new TwoMessages ();/* line 332 */;
    let eh = make_leaf ( name_with_id, owner, inst, deracer_handler)/* line 333 */;
    return  eh;               /* line 334 *//* line 335 *//* line 336 */
}

function send_firstmsg_then_secondmsg (eh,inst) {/* line 337 */
    forward ( eh, "1", inst.buffer.firstmsg)/* line 338 */
    forward ( eh, "2", inst.buffer.secondmsg)/* line 339 */
    reclaim_Buffers_from_heap ( inst)/* line 340 *//* line 341 *//* line 342 */
}

function deracer_handler (eh,msg) {/* line 343 */
    let  inst =  eh.instance_data;/* line 344 */
    if ( inst.state ==  "idle") {/* line 345 */
      if ( "1" ==  msg.port) {/* line 346 */
        inst.buffer.firstmsg =  msg;/* line 347 */
        inst.state =  "waitingForSecondmsg";/* line 348 */}
      else if ( "2" ==  msg.port) {/* line 349 */
        inst.buffer.secondmsg =  msg;/* line 350 */
        inst.state =  "waitingForFirstmsg";/* line 351 */}
      else {                  /* line 352 */
        runtime_error ( `${ "bad msg.port (case A) for deracer "}${ msg.port}` )}/* line 353 */}
    else if ( inst.state ==  "waitingForFirstmsg") {/* line 354 */
      if ( "1" ==  msg.port) {/* line 355 */
        inst.buffer.firstmsg =  msg;/* line 356 */
        send_firstmsg_then_secondmsg ( eh, inst)/* line 357 */
        inst.state =  "idle"; /* line 358 */}
      else {                  /* line 359 */
        runtime_error ( `${ "bad msg.port (case B) for deracer "}${ msg.port}` )}/* line 360 */}
    else if ( inst.state ==  "waitingForSecondmsg") {/* line 361 */
      if ( "2" ==  msg.port) {/* line 362 */
        inst.buffer.secondmsg =  msg;/* line 363 */
        send_firstmsg_then_secondmsg ( eh, inst)/* line 364 */
        inst.state =  "idle"; /* line 365 */}
      else {                  /* line 366 */
        runtime_error ( `${ "bad msg.port (case C) for deracer "}${ msg.port}` )}/* line 367 */}
    else {                    /* line 368 */
      runtime_error ( "bad state for deracer {eh.state}")/* line 369 */}/* line 370 *//* line 371 */
}

function low_level_read_text_file_instantiate (reg,owner,name,template_data) {/* line 372 */
    let name_with_id = gensymbol ( "Low Level Read Text File")/* line 373 */;
    return make_leaf ( name_with_id, owner, null, low_level_read_text_file_handler)/* line 374 */;/* line 375 *//* line 376 */
}

function low_level_read_text_file_handler (eh,msg) {/* line 377 */
    let fname =  msg.datum.srepr ();/* line 378 */

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
                              /* line 379 *//* line 380 *//* line 381 */
}

function ensure_string_datum_instantiate (reg,owner,name,template_data) {/* line 382 */
    let name_with_id = gensymbol ( "Ensure String Datum")/* line 383 */;
    return make_leaf ( name_with_id, owner, null, ensure_string_datum_handler)/* line 384 */;/* line 385 *//* line 386 */
}

function ensure_string_datum_handler (eh,msg) {/* line 387 */
    if ( "string" ==  msg.datum.kind ()) {/* line 388 */
      forward ( eh, "", msg)  /* line 389 */}
    else {                    /* line 390 */
      let emsg =  `${ "*** ensure: type error (expected a string datum) but got "}${ msg.datum}` /* line 391 */;
      send_string ( eh, "✗", emsg, msg)/* line 392 */}/* line 393 *//* line 394 */
}

class Syncfilewrite_Data {
  constructor () {            /* line 395 */

    this.filename =  "";      /* line 396 *//* line 397 */
  }
}
                              /* line 398 */
/*  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) *//* line 399 */
function syncfilewrite_instantiate (reg,owner,name,template_data) {/* line 400 */
    let name_with_id = gensymbol ( "syncfilewrite")/* line 401 */;
    let inst =  new Syncfilewrite_Data ();/* line 402 */;
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)/* line 403 */;/* line 404 *//* line 405 */
}

function syncfilewrite_handler (eh,msg) {/* line 406 */
    let  inst =  eh.instance_data;/* line 407 */
    if ( "filename" ==  msg.port) {/* line 408 */
      inst.filename =  msg.datum.srepr ();/* line 409 */}
    else if ( "input" ==  msg.port) {/* line 410 */
      let contents =  msg.datum.srepr ();/* line 411 */
      let  f = open ( inst.filename, "w")/* line 412 */;
      if ( f!= null) {        /* line 413 */
        f.write ( msg.datum.srepr ())/* line 414 */
        f.close ()            /* line 415 */
        send ( eh, "done",new_datum_bang (), msg)/* line 416 */}
      else {                  /* line 417 */
        send_string ( eh, "✗", `${ "open error on file "}${ inst.filename}` , msg)}/* line 418 */}/* line 419 *//* line 420 */
}

class StringConcat_Instance_Data {
  constructor () {            /* line 421 */

    this.buffer1 =  null;     /* line 422 */
    this.buffer2 =  null;     /* line 423 */
    this.scount =  0;         /* line 424 *//* line 425 */
  }
}
                              /* line 426 */
function stringconcat_instantiate (reg,owner,name,template_data) {/* line 427 */
    let name_with_id = gensymbol ( "stringconcat")/* line 428 */;
    let instp =  new StringConcat_Instance_Data ();/* line 429 */;
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)/* line 430 */;/* line 431 *//* line 432 */
}

function stringconcat_handler (eh,msg) {/* line 433 */
    let  inst =  eh.instance_data;/* line 434 */
    if ( "1" ==  msg.port) {  /* line 435 */
      inst.buffer1 = clone_string ( msg.datum.srepr ())/* line 436 */;
      inst.scount =  inst.scount+ 1;/* line 437 */
      maybe_stringconcat ( eh, inst, msg)/* line 438 */}
    else if ( "2" ==  msg.port) {/* line 439 */
      inst.buffer2 = clone_string ( msg.datum.srepr ())/* line 440 */;
      inst.scount =  inst.scount+ 1;/* line 441 */
      maybe_stringconcat ( eh, inst, msg)/* line 442 */}
    else {                    /* line 443 */
      runtime_error ( `${ "bad msg.port for stringconcat: "}${ msg.port}` )/* line 444 *//* line 445 */}/* line 446 *//* line 447 */
}

function maybe_stringconcat (eh,inst,msg) {/* line 448 */
    if (((( 0 == ( inst.buffer1.length))) && (( 0 == ( inst.buffer2.length))))) {/* line 449 */
      runtime_error ( "something is wrong in stringconcat, both strings are 0 length")/* line 450 */}
    if ( inst.scount >=  2) { /* line 451 */
      let  concatenated_string =  "";/* line 452 */
      if ( 0 == ( inst.buffer1.length)) {/* line 453 */
        concatenated_string =  inst.buffer2;/* line 454 */}
      else if ( 0 == ( inst.buffer2.length)) {/* line 455 */
        concatenated_string =  inst.buffer1;/* line 456 */}
      else {                  /* line 457 */
        concatenated_string =  inst.buffer1+ inst.buffer2;/* line 458 */}
      send_string ( eh, "", concatenated_string, msg)/* line 459 */
      inst.buffer1 =  null;   /* line 460 */
      inst.buffer2 =  null;   /* line 461 */
      inst.scount =  0;       /* line 462 */}/* line 463 *//* line 464 */
}

/*  */                        /* line 465 *//* line 466 */
/*  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here *//* line 467 */
function shell_out_instantiate (reg,owner,name,template_data) {/* line 468 */
    let name_with_id = gensymbol ( "shell_out")/* line 469 */;
    let cmd =  template_data.split (" ")/* line 470 */;
    return make_leaf ( name_with_id, owner, cmd, shell_out_handler)/* line 471 */;/* line 472 *//* line 473 */
}

function shell_out_handler (eh,msg) {/* line 474 */
    let cmd =  eh.instance_data;/* line 475 */
    let s =  msg.datum.srepr ();/* line 476 */
    let  ret =  null;         /* line 477 */
    let  rc =  null;          /* line 478 */
    let  stdout =  null;      /* line 479 */
    let  stderr =  null;      /* line 480 */

    stdout = execSync(`${ cmd} ${ s}`, { encoding: 'utf-8' });
    ret = true;
                              /* line 481 */
    if ( rc!= 0) {            /* line 482 */
      send_string ( eh, "✗", stderr, msg)/* line 483 */}
    else {                    /* line 484 */
      send_string ( eh, "", stdout, msg)/* line 485 *//* line 486 */}/* line 487 *//* line 488 */
}

function string_constant_instantiate (reg,owner,name,template_data) {/* line 489 *//* line 490 *//* line 491 */
    let name_with_id = gensymbol ( "strconst")/* line 492 */;
    let  s =  template_data;  /* line 493 */
    if ( root_project!= "") { /* line 494 */
      s =  s.replaceAll ( "_00_",  root_project)/* line 495 */;/* line 496 */}
    if ( root_0D!= "") {      /* line 497 */
      s =  s.replaceAll ( "_0D_",  root_0D)/* line 498 */;/* line 499 */}
    return make_leaf ( name_with_id, owner, s, string_constant_handler)/* line 500 */;/* line 501 *//* line 502 */
}

function string_constant_handler (eh,msg) {/* line 503 */
    let s =  eh.instance_data;/* line 504 */
    send_string ( eh, "", s, msg)/* line 505 *//* line 506 *//* line 507 */
}

function string_make_persistent (s) {/* line 508 */
    /*  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python *//* line 509 */
    return  s;                /* line 510 *//* line 511 *//* line 512 */
}

function string_clone (s) {   /* line 513 */
    return  s;                /* line 514 *//* line 515 *//* line 516 */
}

/*  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... *//* line 517 */
/*  where ${_00_} is the root directory for the project *//* line 518 */
/*  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) *//* line 519 *//* line 520 */
function initialize_component_palette (root_project,root_0D,diagram_source_files) {/* line 521 */
    let  reg = make_component_registry ();/* line 522 */
    for (let diagram_source of  diagram_source_files) {/* line 523 */
      let all_containers_within_single_file = json2internal ( root_project, diagram_source)/* line 524 */;
      reg = generate_shell_components ( reg, all_containers_within_single_file)/* line 525 */;
      for (let container of  all_containers_within_single_file) {/* line 526 */
        register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 527 *//* line 528 */}/* line 529 */}
    initialize_stock_components ( reg)/* line 530 */
    return  reg;              /* line 531 *//* line 532 *//* line 533 */
}

function print_error_maybe (main_container) {/* line 534 */
    let error_port =  "✗";    /* line 535 */
    let err = fetch_first_output ( main_container, error_port)/* line 536 */;
    if (((( err!= null)) && (( 0 < (trimws ( err.srepr ()).length))))) {/* line 537 */
      console.log ( "___ !!! ERRORS !!! ___");/* line 538 */
      print_specific_output ( main_container, error_port)/* line 539 */}/* line 540 *//* line 541 */
}

/*  debugging helpers */      /* line 542 *//* line 543 */
function nl () {              /* line 544 */
    console.log ( "");        /* line 545 *//* line 546 *//* line 547 */
}

function dump_outputs (main_container) {/* line 548 */
    nl ()                     /* line 549 */
    console.log ( "___ Outputs ___");/* line 550 */
    print_output_list ( main_container)/* line 551 *//* line 552 *//* line 553 */
}

function trimws (s) {         /* line 554 */
    /*  remove whitespace from front and back of string *//* line 555 */
    return  s.strip ();       /* line 556 *//* line 557 *//* line 558 */
}

function clone_string (s) {   /* line 559 */
    return  s                 /* line 560 *//* line 561 */;/* line 562 */
}

let  load_errors =  false;    /* line 563 */
let  runtime_errors =  false; /* line 564 *//* line 565 */
function load_error (s) {     /* line 566 *//* line 567 */
    console.log ( s);         /* line 568 */
    console.log ();           /* line 569 */
    load_errors =  true;      /* line 570 *//* line 571 *//* line 572 */
}

function runtime_error (s) {  /* line 573 *//* line 574 */
    console.log ( s);         /* line 575 */
    runtime_errors =  true;   /* line 576 *//* line 577 *//* line 578 */
}

function fakepipename_instantiate (reg,owner,name,template_data) {/* line 579 */
    let instance_name = gensymbol ( "fakepipe")/* line 580 */;
    return make_leaf ( instance_name, owner, null, fakepipename_handler)/* line 581 */;/* line 582 *//* line 583 */
}

let  rand =  0;               /* line 584 *//* line 585 */
function fakepipename_handler (eh,msg) {/* line 586 *//* line 587 */
    rand =  rand+ 1;
    /*  not very random, but good enough _ 'rand' must be unique within a single run *//* line 588 */
    send_string ( eh, "", `${ "/tmp/fakepipe"}${ rand}` , msg)/* line 589 *//* line 590 *//* line 591 */
}
                              /* line 592 */
/*  all of the the built_in leaves are listed here *//* line 593 */
/*  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project *//* line 594 *//* line 595 */
function initialize_stock_components (reg) {/* line 596 */
    register_component ( reg,mkTemplate ( "1then2", null, deracer_instantiate))/* line 597 */
    register_component ( reg,mkTemplate ( "?", null, probe_instantiate))/* line 598 */
    register_component ( reg,mkTemplate ( "?A", null, probeA_instantiate))/* line 599 */
    register_component ( reg,mkTemplate ( "?B", null, probeB_instantiate))/* line 600 */
    register_component ( reg,mkTemplate ( "?C", null, probeC_instantiate))/* line 601 */
    register_component ( reg,mkTemplate ( "trash", null, trash_instantiate))/* line 602 *//* line 603 */
    register_component ( reg,mkTemplate ( "Low Level Read Text File", null, low_level_read_text_file_instantiate))/* line 604 */
    register_component ( reg,mkTemplate ( "Ensure String Datum", null, ensure_string_datum_instantiate))/* line 605 *//* line 606 */
    register_component ( reg,mkTemplate ( "syncfilewrite", null, syncfilewrite_instantiate))/* line 607 */
    register_component ( reg,mkTemplate ( "stringconcat", null, stringconcat_instantiate))/* line 608 */
    /*  for fakepipe */       /* line 609 */
    register_component ( reg,mkTemplate ( "fakepipename", null, fakepipename_instantiate))/* line 610 *//* line 611 *//* line 612 */
}

function initialize () {      /* line 613 */
    let root_of_project =  argv[ 1] /* line 614 */;
    let root_of_0D =  argv[ 2] /* line 615 */;
    let arg =  argv[ 3]       /* line 616 */;
    let main_container_name =  argv[ 4] /* line 617 */;
    let diagram_names =  argv.splice ( 5) /* line 618 */;
    let palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)/* line 619 */;
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]];/* line 620 *//* line 621 *//* line 622 */
}

function start (palette,env) {
    start_helper ( palette, env, false)/* line 623 */
}

function start_show_all (palette,env) {
    start_helper ( palette, env, true)/* line 624 */
}

function start_helper (palette,env,show_all_outputs) {/* line 625 */
    let root_of_project =  env [ 0];/* line 626 */
    let root_of_0D =  env [ 1];/* line 627 */
    let main_container_name =  env [ 2];/* line 628 */
    let diagram_names =  env [ 3];/* line 629 */
    let arg =  env [ 4];      /* line 630 */
    set_environment ( root_of_project, root_of_0D)/* line 631 */
    /*  get entrypoint container *//* line 632 */
    let  main_container = get_component_instance ( palette, main_container_name, null)/* line 633 */;
    if ( null ==  main_container) {/* line 634 */
      load_error ( `${ "Couldn't find container with page name /"}${ `${ main_container_name}${ `${ "/ in files "}${ `${`${ diagram_names}`}${ " (check tab names, or disable compression?)"}` }` }` }` )/* line 638 *//* line 639 */}
    if ((!  load_errors)) {   /* line 640 */
      let  marg = new_datum_string ( arg)/* line 641 */;
      let  msg = make_message ( "", marg)/* line 642 */;
      inject ( main_container, msg)/* line 643 */
      if ( show_all_outputs) {/* line 644 */
        dump_outputs ( main_container)/* line 645 */}
      else {                  /* line 646 */
        print_error_maybe ( main_container)/* line 647 */
        let outp = fetch_first_output ( main_container, "")/* line 648 */;
        if ( null ==  outp) { /* line 649 */
          console.log ( "(no outputs)");/* line 650 */}
        else {                /* line 651 */
          print_specific_output ( main_container, "")/* line 652 *//* line 653 */}/* line 654 */}
      if ( show_all_outputs) {/* line 655 */
        console.log ( "--- done ---");/* line 656 *//* line 657 */}/* line 658 */}/* line 659 *//* line 660 */
}
                              /* line 661 *//* line 662 */
/*  utility functions  */     /* line 663 */
function send_int (eh,port,i,causing_message) {/* line 664 */
    let datum = new_datum_int ( i)/* line 665 */;
    send ( eh, port, datum, causing_message)/* line 666 *//* line 667 *//* line 668 */
}

function send_bang (eh,port,causing_message) {/* line 669 */
    let datum = new_datum_bang ();/* line 670 */
    send ( eh, port, datum, causing_message)/* line 671 *//* line 672 *//* line 673 */
}





