
'use strict'

import {_} from './support.mjs';
import * as ohm from 'ohm-js';

let return_value_stack = [];
let rule_name_stack = [];


const grammar = String.raw`
fmtpeephole {


main = pattern+

pattern =
  | applySyntactic<Strtop> -- str
  | any -- default

Strtop =
  | CharRun Strtop -- charrunrec
  | CharRun -- charrunsingle
  | interpolation Strtop -- interpolationrec
  | interpolation -- interpolationsingle
  
CharRun =
  | char CharRun -- run
  | char -- single

char = q (~reserved any)

interpolation = "⎨" ident "⎬"

q = "◦"
reserved = q | "⎨" | "⎬"

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
pattern_str : function (_p, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=p
let p = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "pattern_str");
p = _p.rwr ()

_.set_top (return_value_stack, `${p}`);

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
Strtop_charrunrec : function (_run, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=run,rec
let run = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Strtop_charrunrec");
run = _run.rwr ()
rec = _rec.rwr ()

_.set_top (return_value_stack, `strcons ("${run}", ${rec})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Strtop_charrunsingle : function (_run, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=run
let run = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Strtop_charrunsingle");
run = _run.rwr ()

_.set_top (return_value_stack, `"${run}"`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Strtop_interpolationrec : function (_i, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=i,rec
let i = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Strtop_interpolationrec");
i = _i.rwr ()
rec = _rec.rwr ()

_.set_top (return_value_stack, `strcons (${i}, ${rec})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Strtop_interpolationsingle : function (_i, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=i
let i = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Strtop_interpolationsingle");
i = _i.rwr ()

_.set_top (return_value_stack, `${i}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
CharRun_run : function (_c, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c,rec
let c = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CharRun_run");
c = _c.rwr ()
rec = _rec.rwr ()

_.set_top (return_value_stack, `${c}${rec}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
CharRun_single : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CharRun_single");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
char : function (__q, _c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_q,c
let _q = undefined;
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "char");
_q = __q.rwr ()
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
interpolation : function (_lb, _ident, _rb, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=lb,ident,rb
let lb = undefined;
let ident = undefined;
let rb = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "interpolation");
lb = _lb.rwr ()
ident = _ident.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `${ident}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
q : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "q");
c = _c.rwr ()

_.set_top (return_value_stack, `${c}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
reserved : function (_c, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=c
let c = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "reserved");
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
	return parser.trace (src).toString ();
    }
}

import * as fs from 'fs';
let src = fs.readFileSync(0, 'utf-8');
var result = main (src);
console.log (result);

