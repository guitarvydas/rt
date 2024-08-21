
'use strict'

import {_} from './support.mjs';
import * as ohm from 'ohm-js';

let return_value_stack = [];
let rule_name_stack = [];


const grammar = String.raw`
namedparam {


main = pattern+

pattern =
  | defnwithmutate -- defn
  | any -- default

defnwithmutate = "defn" spaces ident spaces "(" stuff* ")"

stuff =
  | "(" stuff* ")" -- nested
  | "=" -- eq
  | ~")" any -- default
  
ident = firstc restc*
firstc = letter | "_"
restc = alnum | "_"



}
`;

const rewrite_code = {
main : function (_p, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=p
let p = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "main");
p = _p.rwr ().join ('')

_.set_top (return_value_stack, `${p}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
pattern_defn : function (_d, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=d
let d = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "pattern_defn");
d = _d.rwr ()

_.set_top (return_value_stack, `${d}`);

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
defnwithmutate : function (__defn, __ws1, _id, __ws2, _lp, _stuff, _rp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_defn,_ws1,id,_ws2,lp,stuff,rp
let _defn = undefined;
let _ws1 = undefined;
let id = undefined;
let _ws2 = undefined;
let lp = undefined;
let stuff = undefined;
let rp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "defnwithmutate");
_defn = __defn.rwr ()
_ws1 = __ws1.rwr ()
id = _id.rwr ()
_ws2 = __ws2.rwr ()
lp = _lp.rwr ()
stuff = _stuff.rwr ().join ('')
rp = _rp.rwr ()

_.set_top (return_value_stack, `${_defn}${_ws1}${id}${_ws2}${lp}${stuff}${rp}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
stuff_nested : function (_lp, _s, _rp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=lp,s,rp
let lp = undefined;
let s = undefined;
let rp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "stuff_nested");
lp = _lp.rwr ()
s = _s.rwr ().join ('')
rp = _rp.rwr ()

_.set_top (return_value_stack, `${lp}${s}${rp}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
stuff_eq : function (_x, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=x
let x = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "stuff_eq");
x = _x.rwr ()

_.set_top (return_value_stack, ` ∷ `);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
stuff_default : function (_x, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=x
let x = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "stuff_default");
x = _x.rwr ()

_.set_top (return_value_stack, `${x}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ident : function (_f, _r, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=f,r
let f = undefined;
let r = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ident");
f = _f.rwr ()
r = _r.rwr ().join ('')

_.set_top (return_value_stack, `${f}${r}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
firstc : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "firstc");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
restc : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "restc");
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
	return parser.trace (src).toString ();
    }
}

import * as fs from 'fs';
let src = fs.readFileSync(0, 'utf-8');
var result = main (src);
console.log (result);

