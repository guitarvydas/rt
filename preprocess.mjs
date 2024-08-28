
'use strict'

import {_} from './support.mjs';
import * as ohm from 'ohm-js';

let return_value_stack = [];
let rule_name_stack = [];


const grammar = String.raw`
fmtstring {

main = pattern+

pattern =
  | fmtstring -- fmtstring
  | any -- default

fmtstring =
  | "f" dq innard dq -- f
  | "f" sq sqinnard sq -- fsq
  | lq innard rq -- u

dq = ("\\\"" | rawdq)
rawdq = "\""
sq = ("\\'" | rawsq)
rawsq = "'"
lq = "“"
rq = "”"

innard =
  | "{" interpolation "}" innard -- rec_interpolation
  | "{" interpolation "}" -- bottom_interpolation
  | ~"}" ~rawdq ~lq ~rq char innard -- rec_default
  | ~"}" ~rawdq ~lq ~rq char -- bottom_default

sqinnard =
  | "{" interpolation "}" sqinnard -- rec_interpolation
  | "{" interpolation "}" -- bottom_interpolation
  | ~"}" ~rawsq ~lq ~rq char sqinnard -- rec_default
  | ~"}" ~rawsq ~lq ~rq char -- bottom_default

interpolation =
  | "{" interpolation "}" -- nested
  | ~"{" ~"}" any interpolation? -- default

char =
  | "\\" any -- escaped
  | "'" -- sq
  | "\"" -- dq
  | any -- default
  
ident = first rest*
first = letter | "_"
rest = alnum | "_"



}
`;

const rewrite_code = {
main : function (_pattern, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=pattern
let pattern = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "main");
pattern = _pattern.rwr ().join ('')

_.set_top (return_value_stack, `${pattern}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
pattern_fmtstring : function (_s, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=s
let s = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "pattern_fmtstring");
s = _s.rwr ()

_.set_top (return_value_stack, `${s}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
pattern_default : function (_x, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=x
let x = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "pattern_default");
x = _x.rwr ()

_.set_top (return_value_stack, `${x}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
fmtstring_f : function (__f, _ldq, _innard, _rdq, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_f,ldq,innard,rdq
let _f = undefined;
let ldq = undefined;
let innard = undefined;
let rdq = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "fmtstring_f");
_f = __f.rwr ()
ldq = _ldq.rwr ()
innard = _innard.rwr ()
rdq = _rdq.rwr ()

_.set_top (return_value_stack, `“${innard}”`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
fmtstring_fsq : function (__f, _lsq, _innard, _rsq, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_f,lsq,innard,rsq
let _f = undefined;
let lsq = undefined;
let innard = undefined;
let rsq = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "fmtstring_fsq");
_f = __f.rwr ()
lsq = _lsq.rwr ()
innard = _innard.rwr ()
rsq = _rsq.rwr ()

_.set_top (return_value_stack, `“${innard}”`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
fmtstring_u : function (_luq, _innard, _ruq, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=luq,innard,ruq
let luq = undefined;
let innard = undefined;
let ruq = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "fmtstring_u");
luq = _luq.rwr ()
innard = _innard.rwr ()
ruq = _ruq.rwr ()

_.set_top (return_value_stack, `“${innard}”`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
dq : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "dq");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
sq : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "sq");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
lq : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "lq");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
rq : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "rq");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
innard_rec_interpolation : function (_lb, _v, _rb, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=lb,v,rb,rec
let lb = undefined;
let v = undefined;
let rb = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "innard_rec_interpolation");
lb = _lb.rwr ()
v = _v.rwr ()
rb = _rb.rwr ()
rec = _rec.rwr ()

_.set_top (return_value_stack, `⎨${v}⎬${rec}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
innard_bottom_interpolation : function (_lb, _v, _rb, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=lb,v,rb
let lb = undefined;
let v = undefined;
let rb = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "innard_bottom_interpolation");
lb = _lb.rwr ()
v = _v.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `⎨${v}⎬`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
innard_rec_default : function (_c, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c,rec
let c = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "innard_rec_default");
c = _c.rwr ()
rec = _rec.rwr ()

_.set_top (return_value_stack, `◦${c}${rec}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
innard_bottom_default : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "innard_bottom_default");
c = _c.rwr ()

_.set_top (return_value_stack, `◦${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
sqinnard_rec_interpolation : function (_lb, _v, _rb, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=lb,v,rb,rec
let lb = undefined;
let v = undefined;
let rb = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "sqinnard_rec_interpolation");
lb = _lb.rwr ()
v = _v.rwr ()
rb = _rb.rwr ()
rec = _rec.rwr ()

_.set_top (return_value_stack, `⎨${v}⎬${rec}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
sqinnard_bottom_interpolation : function (_lb, _v, _rb, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=lb,v,rb
let lb = undefined;
let v = undefined;
let rb = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "sqinnard_bottom_interpolation");
lb = _lb.rwr ()
v = _v.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `⎨${v}⎬`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
sqinnard_rec_default : function (_c, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c,rec
let c = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "sqinnard_rec_default");
c = _c.rwr ()
rec = _rec.rwr ()

_.set_top (return_value_stack, `◦${c}${rec}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
sqinnard_bottom_default : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "sqinnard_bottom_default");
c = _c.rwr ()

_.set_top (return_value_stack, `◦${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
interpolation_nested : function (_lb, _i, _rb, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=lb,i,rb
let lb = undefined;
let i = undefined;
let rb = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "interpolation_nested");
lb = _lb.rwr ()
i = _i.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `${lb}${i}${rb}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
interpolation_default : function (_i, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=i,rec
let i = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "interpolation_default");
i = _i.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `${i}${rec}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
char_escaped : function (__bs, _c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_bs,c
let _bs = undefined;
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "char_escaped");
_bs = __bs.rwr ()
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
char_sq : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "char_sq");
c = _c.rwr ()

_.set_top (return_value_stack, `'`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
char_dq : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "char_dq");
c = _c.rwr ()

_.set_top (return_value_stack, `"`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
char_default : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "char_default");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ident : function (_first, _rest, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=first,rest
let first = undefined;
let rest = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ident");
first = _first.rwr ()
rest = _rest.rwr ().join ('')

_.set_top (return_value_stack, `${first}${rest}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
first : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "first");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
rest : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "rest");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
    _terminal: function () { return this.sourceString; },
    _iter: function (...children) { return children.map(c => c.rwr ()); }
};


function main (src) {
    let parser = ohm.grammar (grammar);
    let cst = parser.match (src);
    if (cst.succeeded ()) {
	let cstSemantics = parser.createSemantics ();
	cstSemantics.addOperation ('rwr', rewrite_code);
	var generated_code = cstSemantics (cst).rwr ();
	return generated_code;
    } else {
        return cst.message;	
    }
}

import * as fs from 'fs';
let src = fs.readFileSync(0, 'utf-8');
var result = main (src);
console.log (result);

