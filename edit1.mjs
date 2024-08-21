
'use strict'

import {_} from './support.mjs';
import * as ohm from 'ohm-js';

let return_value_stack = [];
let rule_name_stack = [];


const grammar = String.raw`
remphi {


main = pattern+

pattern =
  | applySyntactic<Defnwithphi> -- withphi
  | any -- default

Defnwithphi = "defn " ident "(" stuff* ")"

stuff =
  | "⇐ϕ" -- eqphi
  | "(" stuff* ")" -- nested
  | ~")" any -- default
  
ident = ~"defn " firstc restc*
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
pattern_withphi : function (_d, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=d
let d = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "pattern_withphi");
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
Defnwithphi : function (__defn, _id, _lp, _stuff, _rp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_defn,id,lp,stuff,rp
let _defn = undefined;
let id = undefined;
let lp = undefined;
let stuff = undefined;
let rp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defnwithphi");
_defn = __defn.rwr ()
id = _id.rwr ()
lp = _lp.rwr ()
stuff = _stuff.rwr ().join ('')
rp = _rp.rwr ()

_.set_top (return_value_stack, `defn ${id} ${lp}${stuff}${rp}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
stuff_eqphi : function (_x, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=x
let x = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "stuff_eqphi");
x = _x.rwr ()

_.set_top (return_value_stack, ``);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
stuff_nested : function (_lp, _x, _rp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=lp,x,rp
let lp = undefined;
let x = undefined;
let rp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "stuff_nested");
lp = _lp.rwr ()
x = _x.rwr ().join ('')
rp = _rp.rwr ()

_.set_top (return_value_stack, `(${x})`);

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

