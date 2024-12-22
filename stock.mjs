

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

function probe_handler (eh,msg) {                      /* line 16 */
    let s =  msg.datum.v;                              /* line 17 */
    console.error ( `${ "... probe "}${ `${ eh.name}${ `${ ": "}${ s}` }` }` );/* line 18 *//* line 19 *//* line 20 */
}

function trash_instantiate (reg,owner,name,template_data) {/* line 21 */
    let name_with_id = gensymbol ( "trash")            /* line 22 */;
    return make_leaf ( name_with_id, owner, null, trash_handler)/* line 23 */;/* line 24 *//* line 25 */
}

function trash_handler (eh,msg) {                      /* line 26 */
    /*  to appease dumped_on_floor checker */          /* line 27 *//* line 28 *//* line 29 */
}

class TwoMessages {
  constructor () {                                     /* line 30 */

    this.firstmsg =  null;                             /* line 31 */
    this.secondmsg =  null;                            /* line 32 *//* line 33 */
  }
}
                                                       /* line 34 */
/*  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } *//* line 35 */
class Deracer_Instance_Data {
  constructor () {                                     /* line 36 */

    this.state =  null;                                /* line 37 */
    this.buffer =  null;                               /* line 38 *//* line 39 */
  }
}
                                                       /* line 40 */
function reclaim_Buffers_from_heap (inst) {            /* line 41 *//* line 42 *//* line 43 *//* line 44 */
}

function deracer_instantiate (reg,owner,name,template_data) {/* line 45 */
    let name_with_id = gensymbol ( "deracer")          /* line 46 */;
    let  inst =  new Deracer_Instance_Data ();         /* line 47 */;
    inst.state =  "idle";                              /* line 48 */
    inst.buffer =  new TwoMessages ();                 /* line 49 */;
    let eh = make_leaf ( name_with_id, owner, inst, deracer_handler)/* line 50 */;
    return  eh;                                        /* line 51 *//* line 52 *//* line 53 */
}

function send_firstmsg_then_secondmsg (eh,inst) {      /* line 54 */
    forward ( eh, "1", inst.buffer.firstmsg)           /* line 55 */
    forward ( eh, "2", inst.buffer.secondmsg)          /* line 56 */
    reclaim_Buffers_from_heap ( inst)                  /* line 57 *//* line 58 *//* line 59 */
}

function deracer_handler (eh,msg) {                    /* line 60 */
    let  inst =  eh.instance_data;                     /* line 61 */
    if ( inst.state ==  "idle") {                      /* line 62 */
      if ( "1" ==  msg.port) {                         /* line 63 */
        inst.buffer.firstmsg =  msg;                   /* line 64 */
        inst.state =  "waitingForSecondmsg";           /* line 65 */}
      else if ( "2" ==  msg.port) {                    /* line 66 */
        inst.buffer.secondmsg =  msg;                  /* line 67 */
        inst.state =  "waitingForFirstmsg";            /* line 68 */}
      else {                                           /* line 69 */
        runtime_error ( `${ "bad msg.port (case A) for deracer "}${ msg.port}` )/* line 70 *//* line 71 */}}
    else if ( inst.state ==  "waitingForFirstmsg") {   /* line 72 */
      if ( "1" ==  msg.port) {                         /* line 73 */
        inst.buffer.firstmsg =  msg;                   /* line 74 */
        send_firstmsg_then_secondmsg ( eh, inst)       /* line 75 */
        inst.state =  "idle";                          /* line 76 */}
      else {                                           /* line 77 */
        runtime_error ( `${ "bad msg.port (case B) for deracer "}${ msg.port}` )/* line 78 *//* line 79 */}}
    else if ( inst.state ==  "waitingForSecondmsg") {  /* line 80 */
      if ( "2" ==  msg.port) {                         /* line 81 */
        inst.buffer.secondmsg =  msg;                  /* line 82 */
        send_firstmsg_then_secondmsg ( eh, inst)       /* line 83 */
        inst.state =  "idle";                          /* line 84 */}
      else {                                           /* line 85 */
        runtime_error ( `${ "bad msg.port (case C) for deracer "}${ msg.port}` )/* line 86 *//* line 87 */}}
    else {                                             /* line 88 */
      runtime_error ( "bad state for deracer {eh.state}")/* line 89 *//* line 90 */}/* line 91 *//* line 92 */
}

function low_level_read_text_file_instantiate (reg,owner,name,template_data) {/* line 93 */
    let name_with_id = gensymbol ( "Low Level Read Text File")/* line 94 */;
    return make_leaf ( name_with_id, owner, null, low_level_read_text_file_handler)/* line 95 */;/* line 96 *//* line 97 */
}

function low_level_read_text_file_handler (eh,msg) {   /* line 98 */
    let fname =  msg.datum.v;                          /* line 99 */

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
                                                       /* line 100 *//* line 101 *//* line 102 */
}

function ensure_string_datum_instantiate (reg,owner,name,template_data) {/* line 103 */
    let name_with_id = gensymbol ( "Ensure String Datum")/* line 104 */;
    return make_leaf ( name_with_id, owner, null, ensure_string_datum_handler)/* line 105 */;/* line 106 *//* line 107 */
}

function ensure_string_datum_handler (eh,msg) {        /* line 108 */
    if ( "string" ==  msg.datum.kind ()) {             /* line 109 */
      forward ( eh, "", msg)                           /* line 110 */}
    else {                                             /* line 111 */
      let emsg =  `${ "*** ensure: type error (expected a string datum) but got "}${ msg.datum}` /* line 112 */;
      send_string ( eh, "✗", emsg, msg)                /* line 113 *//* line 114 */}/* line 115 *//* line 116 */
}

class Syncfilewrite_Data {
  constructor () {                                     /* line 117 */

    this.filename =  "";                               /* line 118 *//* line 119 */
  }
}
                                                       /* line 120 */
/*  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) *//* line 121 */
function syncfilewrite_instantiate (reg,owner,name,template_data) {/* line 122 */
    let name_with_id = gensymbol ( "syncfilewrite")    /* line 123 */;
    let inst =  new Syncfilewrite_Data ();             /* line 124 */;
    return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)/* line 125 */;/* line 126 *//* line 127 */
}

function syncfilewrite_handler (eh,msg) {              /* line 128 */
    let  inst =  eh.instance_data;                     /* line 129 */
    if ( "filename" ==  msg.port) {                    /* line 130 */
      inst.filename =  msg.datum.v;                    /* line 131 */}
    else if ( "input" ==  msg.port) {                  /* line 132 */
      let contents =  msg.datum.v;                     /* line 133 */
      let  f = open ( inst.filename, "w")              /* line 134 */;
      if ( f!= null) {                                 /* line 135 */
        f.write ( msg.datum.v)                         /* line 136 */
        f.close ()                                     /* line 137 */
        send ( eh, "done",new_datum_bang (), msg)      /* line 138 */}
      else {                                           /* line 139 */
        send_string ( eh, "✗", `${ "open error on file "}${ inst.filename}` , msg)/* line 140 *//* line 141 */}/* line 142 */}/* line 143 *//* line 144 */
}

class StringConcat_Instance_Data {
  constructor () {                                     /* line 145 */

    this.buffer1 =  "";                                /* line 146 */
    this.buffer2 =  "";                                /* line 147 */
    this.scount =  0;                                  /* line 148 *//* line 149 */
  }
}
                                                       /* line 150 */
function stringconcat_instantiate (reg,owner,name,template_data) {/* line 151 */
    let name_with_id = gensymbol ( "stringconcat")     /* line 152 */;
    let instp =  new StringConcat_Instance_Data ();    /* line 153 */;
    return make_leaf ( name_with_id, owner, instp, stringconcat_handler)/* line 154 */;/* line 155 *//* line 156 */
}

function stringconcat_handler (eh,msg) {               /* line 157 */
    let  inst =  eh.instance_data;                     /* line 158 */
    if ( "1" ==  msg.port) {                           /* line 159 */
      inst.buffer1 = clone_string ( msg.datum.v)       /* line 160 */;
      inst.scount =  inst.scount+ 1;                   /* line 161 */
      maybe_stringconcat ( eh, inst, msg)              /* line 162 */}
    else if ( "2" ==  msg.port) {                      /* line 163 */
      inst.buffer2 = clone_string ( msg.datum.v)       /* line 164 */;
      inst.scount =  inst.scount+ 1;                   /* line 165 */
      maybe_stringconcat ( eh, inst, msg)              /* line 166 */}
    else {                                             /* line 167 */
      runtime_error ( `${ "bad msg.port for stringconcat: "}${ msg.port}` )/* line 168 *//* line 169 */}/* line 170 *//* line 171 */
}

function maybe_stringconcat (eh,inst,msg) {            /* line 172 */
    if ( inst.scount >=  2) {                          /* line 173 */
      let  concatenated_string =  "";                  /* line 174 */
      if ( 0 == ( inst.buffer1.length)) {              /* line 175 */
        concatenated_string =  inst.buffer2;           /* line 176 */}
      else if ( 0 == ( inst.buffer2.length)) {         /* line 177 */
        concatenated_string =  inst.buffer1;           /* line 178 */}
      else {                                           /* line 179 */
        concatenated_string =  inst.buffer1+ inst.buffer2;/* line 180 *//* line 181 */}
      send_string ( eh, "", concatenated_string, msg)  /* line 182 */
      inst.buffer1 =  "";                              /* line 183 */
      inst.buffer2 =  "";                              /* line 184 */
      inst.scount =  0;                                /* line 185 *//* line 186 */}/* line 187 *//* line 188 */
}

/*  */                                                 /* line 189 *//* line 190 */
function string_constant_instantiate (reg,owner,name,template_data) {/* line 191 *//* line 192 *//* line 193 */
    let name_with_id = gensymbol ( "strconst")         /* line 194 */;
    let  s =  template_data;                           /* line 195 */
    if ( root_project!= "") {                          /* line 196 */
      s =  s.replaceAll ( "_00_",  root_project)       /* line 197 */;/* line 198 */}
    if ( root_0D!= "") {                               /* line 199 */
      s =  s.replaceAll ( "_0D_",  root_0D)            /* line 200 */;/* line 201 */}
    return make_leaf ( name_with_id, owner, s, string_constant_handler)/* line 202 */;/* line 203 *//* line 204 */
}

function string_constant_handler (eh,msg) {            /* line 205 */
    let s =  eh.instance_data;                         /* line 206 */
    send_string ( eh, "", s, msg)                      /* line 207 *//* line 208 */
}





