
Line 93, col 1:
92 |
> 93 | ****
^
94 |
Expected "}"

function t2t_phase2 (grammr, sem, scn) {
let parser = ohm.grammar (grammr);
let cst = parser.match (src);
if (cst.succeeded ()) {
let cstSemantics = parser.createSemantics ();
cstSemantics.addOperation ('rwr', sem);
var generated_code = cstSemantics (cst).rwr ();
return generated_code;
} else {
return cst.message;
}
}

t2t_phase2 (dslGrammar, rewrite_js, src);

SyntaxError: Unexpected number
at file:///Users/paultarvydas/projects/rt/t2t.mjs:832:21
at ModuleJob.run (node:internal/modules/esm/module_job:222:25)
at async ModuleLoader.import (node:internal/modules/esm/loader:323:24)
at async loadESM (node:internal/process/esm_loader:28:7)
at async handleMainPromise (node:internal/modules/run_main:120:12)




