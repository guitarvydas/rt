
'use strict'

import {_} from './support.mjs';
import * as ohm from 'ohm-js';

let return_value_stack = [];
let rule_name_stack = [];


const grammar = String.raw`
string {


main = pattern+

pattern =
  | "\"" (~"\"" any)* "\"" -- dqstring
  | any -- default


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
pattern_dqstring : function (_dq1, _cs, _dq2, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=dq1,cs,dq2
let dq1 = undefined;
let cs = undefined;
let dq2 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "pattern_dqstring");
dq1 = _dq1.rwr ()
cs = _cs.rwr ().join ('')
dq2 = _dq2.rwr ()

_.set_top (return_value_stack, `\‛${cs}\’`);

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

