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
}/*  this needs to be rewritten to use the low_level "shell_out“ component, this can be done solely as a diagram without using python code here *//* line 1 */
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
}/*  this needs to be rewritten to use the low_level "shell_out“ component, this can be done solely as a diagram without using python code here *//* line 1 */
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