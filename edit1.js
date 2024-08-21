
'use strict'

import {_} from './support.mjs';
import * as ohm from 'ohm-js';

let return_value_stack = [];
let rule_name_stack = [];


const grammar = String.raw`
main {
 =
  | applySyntactic<defnwithphi> -- withphi
  | any -- default

defnwithphi = "defn" spaces "(" stuff* ")"

stuff =
  | "⇐ϕ" -- eqphi
  | any -- default


}
`;

const rewrite_code = {
main_withphi : function (_d, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=d
let d = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "main_withphi");
d = _d.rwr ()

_.set_top (return_value_stack, `${x}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
main_default : function (_x, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=x
let x = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "main_default");
x = _x.rwr ()

_.set_top (return_value_stack, `${x}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
defnwithphi : function (__defn, __ws, _lp, _stuff, _rp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_defn,_ws,lp,stuff,rp
let _defn = undefined;
let _ws = undefined;
let lp = undefined;
let stuff = undefined;
let rp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "defnwithphi");
_defn = __defn.rwr ()
_ws = __ws.rwr ()
lp = _lp.rwr ()
stuff = _stuff.rwr ().join ('')
rp = _rp.rwr ()

_.set_top (return_value_stack, `${_defn}${_ws}${lp}${stuff}${rp}`);

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

