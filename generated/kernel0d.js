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
      send_string ( eh, "", `${ stdout}${ stderr}` , msg)/* line 17 */
    }
    else {                                             /* line 18 */
      send_string ( eh, "✗", `${ stdout}${ stderr}` , msg)/* line 19 *//* line 20 */
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

import * as fs from 'fs';
import path from 'path';
const command_line_argv = process.argv.slice(1);
import execSync from 'child_process';
                                                       /* line 1 *//* line 2 */
let  counter =  0;                                     /* line 3 */
let  ticktime =  0;                                    /* line 4 *//* line 5 */
let  digits = [ "₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀", "₂₁", "₂₂", "₂₃", "₂₄", "₂₅", "₂₆", "₂₇", "₂₈", "₂₉"];/* line 12 *//* line 13 *//* line 14 */
function gensymbol (s) {                               /* line 15 *//* line 16 */
    let name_with_id =  `${ s}${subscripted_digit ( counter)}` /* line 17 */;
    counter =  counter+ 1;                             /* line 18 */
    return  name_with_id;                              /* line 19 *//* line 20 *//* line 21 */
}

function subscripted_digit (n) {                       /* line 22 *//* line 23 */
    if (((( n >=  0) && ( n <=  29)))) {               /* line 24 */
      return  digits [ n];                             /* line 25 */
    }
    else {                                             /* line 26 */
      return  `${ "₊"}${`${ n}`}`                      /* line 27 */;/* line 28 */
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
                                                       /* line 37 */
function new_datum_string (s) {                        /* line 38 */
    let d =  new Datum ();                             /* line 39 */;
    d.v =  s;                                          /* line 40 */
    d.clone =  function () {return clone_datum_string ( d)/* line 41 */;};
    d.reclaim =  function () {return reclaim_datum_string ( d)/* line 42 */;};
    return  d;                                         /* line 43 *//* line 44 *//* line 45 */
}

function clone_datum_string (d) {                      /* line 46 */
    let newd = new_datum_string ( d.v)                 /* line 47 */;
    return  newd;                                      /* line 48 *//* line 49 *//* line 50 */
}

function reclaim_datum_string (src) {                  /* line 51 *//* line 52 *//* line 53 *//* line 54 */
}

function new_datum_bang () {                           /* line 55 */
    let p =  new Datum ();                             /* line 56 */;
    p.v =  "";                                         /* line 57 */
    p.clone =  function () {return clone_datum_bang ( p)/* line 58 */;};
    p.reclaim =  function () {return reclaim_datum_bang ( p)/* line 59 */;};
    return  p;                                         /* line 60 *//* line 61 *//* line 62 */
}

function clone_datum_bang (d) {                        /* line 63 */
    return new_datum_bang ();                          /* line 64 *//* line 65 *//* line 66 */
}

function reclaim_datum_bang (d) {                      /* line 67 *//* line 68 *//* line 69 *//* line 70 */
}

/*  Mevent passed to a leaf component. */              /* line 71 */
/*  */                                                 /* line 72 */
/*  `port` refers to the name of the incoming or outgoing port of this component. *//* line 73 */
/*  `payload` is the data attached to this mevent. */  /* line 74 */
class Mevent {
  constructor () {                                     /* line 75 */

    this.port =  null;                                 /* line 76 */
    this.datum =  null;                                /* line 77 *//* line 78 */
  }
}
                                                       /* line 79 */
function clone_port (s) {                              /* line 80 */
    return clone_string ( s)                           /* line 81 */;/* line 82 *//* line 83 */
}

/*  Utility for making a `Mevent`. Used to safely "seed“ mevents *//* line 84 */
/*  entering the very top of a network. */             /* line 85 */
function make_mevent (port,datum) {                    /* line 86 */
    let p = clone_string ( port)                       /* line 87 */;
    let  m =  new Mevent ();                           /* line 88 */;
    m.port =  p;                                       /* line 89 */
    m.datum =  datum.clone ();                         /* line 90 */
    return  m;                                         /* line 91 *//* line 92 *//* line 93 */
}

/*  Clones a mevent. Primarily used internally for “fanning out“ a mevent to multiple destinations. *//* line 94 */
function mevent_clone (mev) {                          /* line 95 */
    let  m =  new Mevent ();                           /* line 96 */;
    m.port = clone_port ( mev.port)                    /* line 97 */;
    m.datum =  mev.datum.clone ();                     /* line 98 */
    return  m;                                         /* line 99 *//* line 100 *//* line 101 */
}

/*  Frees a mevent. */                                 /* line 102 */
function destroy_mevent (mev) {                        /* line 103 */
    /*  during debug, dont destroy any mevent, since we want to trace mevents, thus, we need to persist ancestor mevents *//* line 104 *//* line 105 *//* line 106 *//* line 107 */
}

function destroy_datum (mev) {                         /* line 108 *//* line 109 *//* line 110 *//* line 111 */
}

function destroy_port (mev) {                          /* line 112 *//* line 113 *//* line 114 *//* line 115 */
}

/*  */                                                 /* line 116 */
function format_mevent (m) {                           /* line 117 */
    if ( m ==  null) {                                 /* line 118 */
      return  "{}";                                    /* line 119 */
    }
    else {                                             /* line 120 */
      return  `${ "{\""}${ `${ m.port}${ `${ "\":\""}${ `${ m.datum.v}${ "\"}"}` }` }` }` /* line 121 */;/* line 122 */
    }                                                  /* line 123 */
}

function format_mevent_raw (m) {                       /* line 124 */
    if ( m ==  null) {                                 /* line 125 */
      return  "";                                      /* line 126 */
    }
    else {                                             /* line 127 */
      return  m.datum.v;                               /* line 128 *//* line 129 */
    }                                                  /* line 130 *//* line 131 */
}

const  enumDown =  0                                   /* line 132 */;
const  enumAcross =  1                                 /* line 133 */;
const  enumUp =  2                                     /* line 134 */;
const  enumThrough =  3                                /* line 135 */;/* line 136 */
function create_down_connector (container,proto_conn,connectors,children_by_id) {/* line 137 */
    /*  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, *//* line 138 */
    let  connector =  new Connector ();                /* line 139 */;
    connector.direction =  "down";                     /* line 140 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 141 */;
    let target_proto =  proto_conn [ "target"];        /* line 142 */
    let id_proto =  target_proto [ "id"];              /* line 143 */
    let target_component =  children_by_id [id_proto]; /* line 144 */
    if (( target_component ==  null)) {                /* line 145 */
      load_error ( `${ "internal error: .Down connection target internal error "}${( proto_conn [ "target"]) [ "name"]}` )/* line 146 */
    }
    else {                                             /* line 147 */
      connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 148 */;/* line 149 */
    }
    return  connector;                                 /* line 150 *//* line 151 *//* line 152 */
}

function create_across_connector (container,proto_conn,connectors,children_by_id) {/* line 153 */
    let  connector =  new Connector ();                /* line 154 */;
    connector.direction =  "across";                   /* line 155 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 156 */
    let target_component =  children_by_id [(( proto_conn [ "target"]) [ "id"])];/* line 157 */
    if ( source_component ==  null) {                  /* line 158 */
      load_error ( `${ "internal error: .Across connection source not ok "}${( proto_conn [ "source"]) [ "name"]}` )/* line 159 */
    }
    else {                                             /* line 160 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 161 */;
      if ( target_component ==  null) {                /* line 162 */
        load_error ( `${ "internal error: .Across connection target not ok "}${( proto_conn [ "target"]) [ "name"]}` )/* line 163 */
      }
      else {                                           /* line 164 */
        connector.receiver = mkReceiver ( target_component.name, target_component, proto_conn [ "target_port"], target_component.inq)/* line 165 */;/* line 166 */
      }                                                /* line 167 */
    }
    return  connector;                                 /* line 168 *//* line 169 *//* line 170 */
}

function create_up_connector (container,proto_conn,connectors,children_by_id) {/* line 171 */
    let  connector =  new Connector ();                /* line 172 */;
    connector.direction =  "up";                       /* line 173 */
    let source_component =  children_by_id [(( proto_conn [ "source"]) [ "id"])];/* line 174 */
    if ( source_component ==  null) {                  /* line 175 */
      load_error ( `${ "internal error: .Up connection source not ok "}${( proto_conn [ "source"]) [ "name"]}` )/* line 176 */
    }
    else {                                             /* line 177 */
      connector.sender = mkSender ( source_component.name, source_component, proto_conn [ "source_port"])/* line 178 */;
      connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 179 */;/* line 180 */
    }
    return  connector;                                 /* line 181 *//* line 182 *//* line 183 */
}

function create_through_connector (container,proto_conn,connectors,children_by_id) {/* line 184 */
    let  connector =  new Connector ();                /* line 185 */;
    connector.direction =  "through";                  /* line 186 */
    connector.sender = mkSender ( container.name, container, proto_conn [ "source_port"])/* line 187 */;
    connector.receiver = mkReceiver ( container.name, container, proto_conn [ "target_port"], container.outq)/* line 188 */;
    return  connector;                                 /* line 189 *//* line 190 *//* line 191 */
}
                                                       /* line 192 */
function container_instantiator (reg,owner,container_name,desc) {/* line 193 *//* line 194 */
    let container = make_container ( container_name, owner)/* line 195 */;
    let children = [];                                 /* line 196 */
    let children_by_id = {};
    /*  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here *//* line 197 */
    /*  collect children */                            /* line 198 */
    for (let child_desc of  desc [ "children"]) {      /* line 199 */
      let child_instance = get_component_instance ( reg, child_desc [ "name"], container)/* line 200 */;
      children.push ( child_instance)                  /* line 201 */
      let id =  child_desc [ "id"];                    /* line 202 */
      children_by_id [id] =  child_instance;           /* line 203 *//* line 204 *//* line 205 */
    }
    container.children =  children;                    /* line 206 *//* line 207 */
    let connectors = [];                               /* line 208 */
    for (let proto_conn of  desc [ "connections"]) {   /* line 209 */
      let  connector =  new Connector ();              /* line 210 */;
      if ( proto_conn [ "dir"] ==  enumDown) {         /* line 211 */
        connectors.push (create_down_connector ( container, proto_conn, connectors, children_by_id)) /* line 212 */
      }
      else if ( proto_conn [ "dir"] ==  enumAcross) {  /* line 213 */
        connectors.push (create_across_connector ( container, proto_conn, connectors, children_by_id)) /* line 214 */
      }
      else if ( proto_conn [ "dir"] ==  enumUp) {      /* line 215 */
        connectors.push (create_up_connector ( container, proto_conn, connectors, children_by_id)) /* line 216 */
      }
      else if ( proto_conn [ "dir"] ==  enumThrough) { /* line 217 */
        connectors.push (create_through_connector ( container, proto_conn, connectors, children_by_id)) /* line 218 *//* line 219 */
      }                                                /* line 220 */
    }
    container.connections =  connectors;               /* line 221 */
    return  container;                                 /* line 222 *//* line 223 *//* line 224 */
}

/*  The default handler for container components. */   /* line 225 */
function container_handler (container,mevent) {        /* line 226 */
    route ( container, container, mevent)
    /*  references to 'self' are replaced by the container during instantiation *//* line 227 */
    while (any_child_ready ( container)) {             /* line 228 */
      step_children ( container, mevent)               /* line 229 */
    }                                                  /* line 230 *//* line 231 */
}

/*  Frees the given container and associated data. */  /* line 232 */
function destroy_container (eh) {                      /* line 233 *//* line 234 *//* line 235 *//* line 236 */
}

/*  Routing connection for a container component. The `direction` field has *//* line 237 */
/*  no affect on the default mevent routing system _ it is there for debugging *//* line 238 */
/*  purposes, or for reading by other tools. */        /* line 239 *//* line 240 */
class Connector {
  constructor () {                                     /* line 241 */

    this.direction =  null;/*  down, across, up, through *//* line 242 */
    this.sender =  null;                               /* line 243 */
    this.receiver =  null;                             /* line 244 *//* line 245 */
  }
}
                                                       /* line 246 */
/*  `Sender` is used to “pattern match“ which `Receiver` a mevent should go to, *//* line 247 */
/*  based on component ID (pointer) and port name. */  /* line 248 *//* line 249 */
class Sender {
  constructor () {                                     /* line 250 */

    this.name =  null;                                 /* line 251 */
    this.component =  null;                            /* line 252 */
    this.port =  null;                                 /* line 253 *//* line 254 */
  }
}
                                                       /* line 255 *//* line 256 *//* line 257 */
/*  `Receiver` is a handle to a destination queue, and a `port` name to assign *//* line 258 */
/*  to incoming mevents to this queue. */              /* line 259 *//* line 260 */
class Receiver {
  constructor () {                                     /* line 261 */

    this.name =  null;                                 /* line 262 */
    this.queue =  null;                                /* line 263 */
    this.port =  null;                                 /* line 264 */
    this.component =  null;                            /* line 265 *//* line 266 */
  }
}
                                                       /* line 267 */
function mkSender (name,component,port) {              /* line 268 */
    let  s =  new Sender ();                           /* line 269 */;
    s.name =  name;                                    /* line 270 */
    s.component =  component;                          /* line 271 */
    s.port =  port;                                    /* line 272 */
    return  s;                                         /* line 273 *//* line 274 *//* line 275 */
}

function mkReceiver (name,component,port,q) {          /* line 276 */
    let  r =  new Receiver ();                         /* line 277 */;
    r.name =  name;                                    /* line 278 */
    r.component =  component;                          /* line 279 */
    r.port =  port;                                    /* line 280 */
    /*  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. *//* line 281 */
    r.queue =  q;                                      /* line 282 */
    return  r;                                         /* line 283 *//* line 284 *//* line 285 */
}

/*  Checks if two senders match, by pointer equality and port name matching. *//* line 286 */
function sender_eq (s1,s2) {                           /* line 287 */
    let same_components = ( s1.component ==  s2.component);/* line 288 */
    let same_ports = ( s1.port ==  s2.port);           /* line 289 */
    return (( same_components) && ( same_ports));      /* line 290 *//* line 291 *//* line 292 */
}

/*  Delivers the given mevent to the receiver of this connector. *//* line 293 *//* line 294 */
function deposit (parent,conn,mevent) {                /* line 295 */
    let new_mevent = make_mevent ( conn.receiver.port, mevent.datum)/* line 296 */;
    push_mevent ( parent, conn.receiver.component, conn.receiver.queue, new_mevent)/* line 297 *//* line 298 *//* line 299 */
}

function force_tick (parent,eh) {                      /* line 300 */
    let tick_mev = make_mevent ( ".",new_datum_bang ())/* line 301 */;
    push_mevent ( parent, eh, eh.inq, tick_mev)        /* line 302 */
    return  tick_mev;                                  /* line 303 *//* line 304 *//* line 305 */
}

function push_mevent (parent,receiver,inq,m) {         /* line 306 */
    inq.push ( m)                                      /* line 307 */
    parent.visit_ordering.push ( receiver)             /* line 308 *//* line 309 *//* line 310 */
}

function is_self (child,container) {                   /* line 311 */
    /*  in an earlier version “self“ was denoted as ϕ *//* line 312 */
    return  child ==  container;                       /* line 313 *//* line 314 *//* line 315 */
}

function step_child (child,mev) {                      /* line 316 */
    let before_state =  child.state;                   /* line 317 */
    child.handler ( child, mev)                        /* line 318 */
    let after_state =  child.state;                    /* line 319 */
    return [(( before_state ==  "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state!= "idle")),(( before_state!= "idle") && ( after_state ==  "idle"))];/* line 322 *//* line 323 *//* line 324 */
}

function step_children (container,causingMevent) {     /* line 325 */
    container.state =  "idle";                         /* line 326 */
    for (let child of   container.visit_ordering) {    /* line 327 */
      /*  child = container represents self, skip it *//* line 328 */
      if (((! (is_self ( child, container))))) {       /* line 329 */
        if (((! ((0=== child.inq.length))))) {         /* line 330 */
          let mev =  child.inq.shift ()                /* line 331 */;
          let  began_long_run =  null;                 /* line 332 */
          let  continued_long_run =  null;             /* line 333 */
          let  ended_long_run =  null;                 /* line 334 */
          [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, mev)/* line 335 */;
          if ( began_long_run) {                       /* line 336 *//* line 337 */
          }
          else if ( continued_long_run) {              /* line 338 *//* line 339 */
          }
          else if ( ended_long_run) {                  /* line 340 *//* line 341 *//* line 342 */
          }
          destroy_mevent ( mev)                        /* line 343 */
        }
        else {                                         /* line 344 */
          if ( child.state!= "idle") {                 /* line 345 */
            let mev = force_tick ( container, child)   /* line 346 */;
            child.handler ( child, mev)                /* line 347 */
            destroy_mevent ( mev)                      /* line 348 *//* line 349 */
          }                                            /* line 350 */
        }                                              /* line 351 */
        if ( child.state ==  "active") {               /* line 352 */
          /*  if child remains active, then the container must remain active and must propagate “ticks“ to child *//* line 353 */
          container.state =  "active";                 /* line 354 *//* line 355 */
        }                                              /* line 356 */
        while (((! ((0=== child.outq.length))))) {     /* line 357 */
          let mev =  child.outq.shift ()               /* line 358 */;
          route ( container, child, mev)               /* line 359 */
          destroy_mevent ( mev)                        /* line 360 *//* line 361 */
        }                                              /* line 362 */
      }                                                /* line 363 */
    }                                                  /* line 364 *//* line 365 */
}

function attempt_tick (parent,eh) {                    /* line 366 */
    if ( eh.state!= "idle") {                          /* line 367 */
      force_tick ( parent, eh)                         /* line 368 *//* line 369 */
    }                                                  /* line 370 *//* line 371 */
}

function is_tick (mev) {                               /* line 372 */
    return  "." ==  mev.port
    /*  assume that any mevent that is sent to port "." is a tick  *//* line 373 */;/* line 374 *//* line 375 */
}

/*  Routes a single mevent to all matching destinations, according to *//* line 376 */
/*  the container's connection network. */             /* line 377 *//* line 378 */
function route (container,from_component,mevent) {     /* line 379 */
    let  was_sent =  false;
    /*  for checking that output went somewhere (at least during bootstrap) *//* line 380 */
    let  fromname =  "";                               /* line 381 *//* line 382 */
    ticktime =  ticktime+ 1;                           /* line 383 */
    if (is_tick ( mevent)) {                           /* line 384 */
      for (let child of  container.children) {         /* line 385 */
        attempt_tick ( container, child)               /* line 386 */
      }
      was_sent =  true;                                /* line 387 */
    }
    else {                                             /* line 388 */
      if (((! (is_self ( from_component, container))))) {/* line 389 */
        fromname =  from_component.name;               /* line 390 *//* line 391 */
      }
      let from_sender = mkSender ( fromname, from_component, mevent.port)/* line 392 */;/* line 393 */
      for (let connector of  container.connections) {  /* line 394 */
        if (sender_eq ( from_sender, connector.sender)) {/* line 395 */
          deposit ( container, connector, mevent)      /* line 396 */
          was_sent =  true;                            /* line 397 *//* line 398 */
        }                                              /* line 399 */
      }                                                /* line 400 */
    }
    if ((! ( was_sent))) {                             /* line 401 */
      live_update ( "Error",  `${ container.name}${ `${ ": mevent '"}${ `${ mevent.port}${ `${ "' from "}${ `${ fromname}${ " dropped on floor..."}` }` }` }` }` )/* line 402 *//* line 403 */
    }                                                  /* line 404 *//* line 405 */
}

function any_child_ready (container) {                 /* line 406 */
    for (let child of  container.children) {           /* line 407 */
      if (child_is_ready ( child)) {                   /* line 408 */
        return  true;                                  /* line 409 *//* line 410 */
      }                                                /* line 411 */
    }
    return  false;                                     /* line 412 *//* line 413 *//* line 414 */
}

function child_is_ready (eh) {                         /* line 415 */
    return ((((((((! ((0=== eh.outq.length))))) || (((! ((0=== eh.inq.length))))))) || (( eh.state!= "idle")))) || ((any_child_ready ( eh))));/* line 416 *//* line 417 *//* line 418 */
}

function append_routing_descriptor (container,desc) {  /* line 419 */
    container.routings.push ( desc)                    /* line 420 *//* line 421 *//* line 422 */
}

function container_injector (container,mevent) {       /* line 423 */
    container_handler ( container, mevent)             /* line 424 *//* line 425 *//* line 426 */
}
                                                       /* line 427 *//* line 428 *//* line 429 */
class Component_Registry {
  constructor () {                                     /* line 430 */

    this.templates = {};                               /* line 431 *//* line 432 */
  }
}
                                                       /* line 433 */
class Template {
  constructor () {                                     /* line 434 */

    this.name =  null;                                 /* line 435 */
    this.template_data =  null;                        /* line 436 */
    this.instantiator =  null;                         /* line 437 *//* line 438 */
  }
}
                                                       /* line 439 */
function mkTemplate (name,template_data,instantiator) {/* line 440 */
    let  templ =  new Template ();                     /* line 441 */;
    templ.name =  name;                                /* line 442 */
    templ.template_data =  template_data;              /* line 443 */
    templ.instantiator =  instantiator;                /* line 444 */
    return  templ;                                     /* line 445 *//* line 446 *//* line 447 */
}

function read_and_convert_json_file (pathname,filename) {/* line 448 */

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
                                                       /* line 449 *//* line 450 *//* line 451 */
}

function json2internal (pathname,container_xml) {      /* line 452 */
    let fname =   container_xml                        /* line 453 */;
    let routings = read_and_convert_json_file ( pathname, fname)/* line 454 */;
    return  routings;                                  /* line 455 *//* line 456 *//* line 457 */
}

function delete_decls (d) {                            /* line 458 *//* line 459 *//* line 460 *//* line 461 */
}

function make_component_registry () {                  /* line 462 */
    return  new Component_Registry ();                 /* line 463 */;/* line 464 *//* line 465 */
}

function register_component (reg,template) {
    return abstracted_register_component ( reg, template, false);/* line 466 */
}

function register_component_allow_overwriting (reg,template) {
    return abstracted_register_component ( reg, template, true);/* line 467 *//* line 468 */
}

function abstracted_register_component (reg,template,ok_to_overwrite) {/* line 469 */
    let name = mangle_name ( template.name)            /* line 470 */;
    if ((((((( reg!= null) && ( name))) in ( reg.templates))) && ((!  ok_to_overwrite)))) {/* line 471 */
      load_error ( `${ "Component /"}${ `${ template.name}${ "/ already declared"}` }` )/* line 472 */
      return  reg;                                     /* line 473 */
    }
    else {                                             /* line 474 */
      reg.templates [name] =  template;                /* line 475 */
      return  reg;                                     /* line 476 *//* line 477 */
    }                                                  /* line 478 *//* line 479 */
}

function get_component_instance (reg,full_name,owner) {/* line 480 */
    let template_name = mangle_name ( full_name)       /* line 481 */;
    if ((( template_name) in ( reg.templates))) {      /* line 482 */
      let template =  reg.templates [template_name];   /* line 483 */
      if (( template ==  null)) {                      /* line 484 */
        load_error ( `${ "Registry Error (A): Can't find component /"}${ `${ template_name}${ "/"}` }` )/* line 485 */
        return  null;                                  /* line 486 */
      }
      else {                                           /* line 487 */
        let owner_name =  "";                          /* line 488 */
        let instance_name =  template_name;            /* line 489 */
        if ( null!= owner) {                           /* line 490 */
          owner_name =  owner.name;                    /* line 491 */
          instance_name =  `${ owner_name}${ `${ "▹"}${ template_name}` }` /* line 492 */;
        }
        else {                                         /* line 493 */
          instance_name =  template_name;              /* line 494 *//* line 495 */
        }
        let instance =  template.instantiator ( reg, owner, instance_name, template.template_data)/* line 496 */;
        return  instance;                              /* line 497 *//* line 498 */
      }
    }
    else {                                             /* line 499 */
      load_error ( `${ "Registry Error (B): Can't find component /"}${ `${ template_name}${ "/"}` }` )/* line 500 */
      return  null;                                    /* line 501 *//* line 502 */
    }                                                  /* line 503 *//* line 504 */
}

function dump_registry (reg) {                         /* line 505 */
    nl ()                                              /* line 506 */
    console.log ( "*** PALETTE ***");                  /* line 507 */
    for (let c of  reg.templates) {                    /* line 508 */
      print ( c.name)                                  /* line 509 */
    }
    console.log ( "***************");                  /* line 510 */
    nl ()                                              /* line 511 *//* line 512 *//* line 513 */
}

function print_stats (reg) {                           /* line 514 */
    console.log ( `${ "registry statistics: "}${ reg.stats}` );/* line 515 *//* line 516 *//* line 517 */
}

function mangle_name (s) {                             /* line 518 */
    /*  trim name to remove code from Container component names _ deferred until later (or never) *//* line 519 */
    return  s;                                         /* line 520 *//* line 521 *//* line 522 */
}
                                                       /* line 523 */
/*  Data for an asyncronous component _ effectively, a function with input *//* line 524 */
/*  and output queues of mevents. */                   /* line 525 */
/*  */                                                 /* line 526 */
/*  Components can either be a user_supplied function (“lea“), or a “container“ *//* line 527 */
/*  that routes mevents to child components according to a list of connections *//* line 528 */
/*  that serve as a mevent routing table. */           /* line 529 */
/*  */                                                 /* line 530 */
/*  Child components themselves can be leaves or other containers. *//* line 531 */
/*  */                                                 /* line 532 */
/*  `handler` invokes the code that is attached to this component. *//* line 533 */
/*  */                                                 /* line 534 */
/*  `instance_data` is a pointer to instance data that the `leaf_handler` *//* line 535 */
/*  function may want whenever it is invoked again. */ /* line 536 */
/*  */                                                 /* line 537 *//* line 538 */
/*  Eh_States :: enum { idle, active } */              /* line 539 */
class Eh {
  constructor () {                                     /* line 540 */

    this.name =  "";                                   /* line 541 */
    this.inq =  []                                     /* line 542 */;
    this.outq =  []                                    /* line 543 */;
    this.owner =  null;                                /* line 544 */
    this.children = [];                                /* line 545 */
    this.visit_ordering =  []                          /* line 546 */;
    this.connections = [];                             /* line 547 */
    this.routings =  []                                /* line 548 */;
    this.handler =  null;                              /* line 549 */
    this.finject =  null;                              /* line 550 */
    this.instance_data =  null;                        /* line 551 */
    this.state =  "idle";                              /* line 552 *//*  bootstrap debugging *//* line 553 */
    this.kind =  null;/*  enum { container, leaf, } */ /* line 554 *//* line 555 */
  }
}
                                                       /* line 556 */
/*  Creates a component that acts as a container. It is the same as a `Eh` instance *//* line 557 */
/*  whose handler function is `container_handler`. */  /* line 558 */
function make_container (name,owner) {                 /* line 559 */
    let  eh =  new Eh ();                              /* line 560 */;
    eh.name =  name;                                   /* line 561 */
    eh.owner =  owner;                                 /* line 562 */
    eh.handler =  container_handler;                   /* line 563 */
    eh.finject =  container_injector;                  /* line 564 */
    eh.state =  "idle";                                /* line 565 */
    eh.kind =  "container";                            /* line 566 */
    return  eh;                                        /* line 567 *//* line 568 *//* line 569 */
}

/*  Creates a new leaf component out of a handler function, and a data parameter *//* line 570 */
/*  that will be passed back to your handler when called. *//* line 571 *//* line 572 */
function make_leaf (name,owner,instance_data,handler) {/* line 573 */
    let  eh =  new Eh ();                              /* line 574 */;
    eh.name =  `${ owner.name}${ `${ "▹"}${ name}` }`  /* line 575 */;
    eh.owner =  owner;                                 /* line 576 */
    eh.handler =  handler;                             /* line 577 */
    eh.instance_data =  instance_data;                 /* line 578 */
    eh.state =  "idle";                                /* line 579 */
    eh.kind =  "leaf";                                 /* line 580 */
    return  eh;                                        /* line 581 *//* line 582 *//* line 583 */
}

/*  Sends a mevent on the given `port` with `data`, placing it on the output *//* line 584 */
/*  of the given component. */                         /* line 585 *//* line 586 */
function send (eh,port,datum,causingMevent) {          /* line 587 */
    let mev = make_mevent ( port, datum)               /* line 588 */;
    put_output ( eh, mev)                              /* line 589 *//* line 590 *//* line 591 */
}

function send_string (eh,port,s,causingMevent) {       /* line 592 */
    let datum = new_datum_string ( s)                  /* line 593 */;
    let mev = make_mevent ( port, datum)               /* line 594 */;
    put_output ( eh, mev)                              /* line 595 *//* line 596 *//* line 597 */
}

function forward (eh,port,mev) {                       /* line 598 */
    let fwdmev = make_mevent ( port, mev.datum)        /* line 599 */;
    put_output ( eh, fwdmev)                           /* line 600 *//* line 601 *//* line 602 */
}

function inject (eh,mev) {                             /* line 603 */
    eh.finject ( eh, mev)                              /* line 604 *//* line 605 *//* line 606 */
}

function set_active (eh) {                             /* line 607 */
    eh.state =  "active";                              /* line 608 *//* line 609 *//* line 610 */
}

function set_idle (eh) {                               /* line 611 */
    eh.state =  "idle";                                /* line 612 *//* line 613 *//* line 614 */
}

function put_output (eh,mev) {                         /* line 615 */
    eh.outq.push ( mev)                                /* line 616 *//* line 617 *//* line 618 */
}

let  root_project =  "";                               /* line 619 */
let  root_0D =  "";                                    /* line 620 *//* line 621 */
function set_environment (rproject,r0D) {              /* line 622 *//* line 623 *//* line 624 */
    root_project =  rproject;                          /* line 625 */
    root_0D =  r0D;                                    /* line 626 *//* line 627 *//* line 628 */
}
                                                       /* line 629 */
function string_make_persistent (s) {                  /* line 630 */
    /*  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python *//* line 631 */
    return  s;                                         /* line 632 *//* line 633 *//* line 634 */
}

function string_clone (s) {                            /* line 635 */
    return  s;                                         /* line 636 *//* line 637 *//* line 638 */
}

/*  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... *//* line 639 */
/*  where ${_00_} is the root directory for the project *//* line 640 */
/*  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) *//* line 641 *//* line 642 */
function initialize_component_palette (root_project,root_0D,diagram_source_files) {/* line 643 */
    let  reg = make_component_registry ();             /* line 644 */
    for (let diagram_source of  diagram_source_files) {/* line 645 */
      let all_containers_within_single_file = json2internal ( root_project, diagram_source)/* line 646 */;
      reg = generate_shell_components ( reg, all_containers_within_single_file)/* line 647 */;
      for (let container of  all_containers_within_single_file) {/* line 648 */
        register_component ( reg,mkTemplate ( container [ "name"], container, container_instantiator))/* line 649 *//* line 650 */
      }                                                /* line 651 */
    }
    initialize_stock_components ( reg)                 /* line 652 */
    return  reg;                                       /* line 653 *//* line 654 *//* line 655 */
}
                                                       /* line 656 */
function clone_string (s) {                            /* line 657 */
    return  s                                          /* line 658 *//* line 659 */;/* line 660 */
}

let  load_errors =  false;                             /* line 661 */
let  runtime_errors =  false;                          /* line 662 *//* line 663 */
function load_error (s) {                              /* line 664 *//* line 665 */
    console.error ( s);                                /* line 666 */
                                                       /* line 667 */
    load_errors =  true;                               /* line 668 *//* line 669 *//* line 670 */
}

function runtime_error (s) {                           /* line 671 *//* line 672 */
    console.error ( s);                                /* line 673 */
    runtime_errors =  true;                            /* line 674 *//* line 675 *//* line 676 */
}
                                                       /* line 677 */
function argv () {                                     /* line 678 */
    return  command_line_argv                          /* line 679 */;/* line 680 *//* line 681 */
}

function initialize () {                               /* line 682 */
    let root_of_project =  command_line_argv[ 1]       /* line 683 */;
    let root_of_0D =  command_line_argv[ 2]            /* line 684 */;
    let arg =  command_line_argv[ 3]                   /* line 685 */;
    let main_container_name =  command_line_argv[ 4]   /* line 686 */;
    let diagram_names =  command_line_argv.splice ( 5) /* line 687 */;
    let palette = initialize_component_palette ( root_of_project, root_of_0D, diagram_names)/* line 688 */;
    return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]];/* line 689 *//* line 690 *//* line 691 */
}

function start (palette,env) {                         /* line 692 */
    live_update ( "",  "reset")                        /* line 693 */
    live_update ( "Live",  "begin...")                 /* line 694 */
    let root_of_project =  env [ 0];                   /* line 695 */
    let root_of_0D =  env [ 1];                        /* line 696 */
    let main_container_name =  env [ 2];               /* line 697 */
    let diagram_names =  env [ 3];                     /* line 698 */
    let arg =  env [ 4];                               /* line 699 */
    set_environment ( root_of_project, root_of_0D)     /* line 700 */
    /*  get entrypoint container */                    /* line 701 */
    let  main_container = get_component_instance ( palette, main_container_name, null)/* line 702 */;
    if ( null ==  main_container) {                    /* line 703 */
      load_error ( `${ "Couldn't find container with page name /"}${ `${ main_container_name}${ `${ "/ in files "}${ `${`${ diagram_names}`}${ " (check tab names, or disable compression?)"}` }` }` }` )/* line 707 *//* line 708 */
    }
    if ((!  load_errors)) {                            /* line 709 */
      let  marg = new_datum_string ( arg)              /* line 710 */;
      let  mev = make_mevent ( "", marg)               /* line 711 */;
      inject ( main_container, mev)                    /* line 712 *//* line 713 */
    }
    live_update ( "Live",  "...end")                   /* line 714 *//* line 715 *//* line 716 */
}
                                                       /* line 717 */
/*  utility functions  */                              /* line 718 */
function send_int (eh,port,i,causing_mevent) {         /* line 719 */
    let datum = new_datum_string (`${ i}`)             /* line 720 */;
    send ( eh, port, datum, causing_mevent)            /* line 721 *//* line 722 *//* line 723 */
}

function send_bang (eh,port,causing_mevent) {          /* line 724 */
    let datum = new_datum_bang ();                     /* line 725 */
    send ( eh, port, datum, causing_mevent)            /* line 726 *//* line 727 */
}

/*   intentionally left empty  */                      /* line 1 */
