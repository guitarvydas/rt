--- !!! ERRORS !!! ---
file:///Users/paultarvydas/projects/rt/node_modules/ohm-js/src/Grammar.js:141
      const error = new Error(
                    ^

Error: Found errors in the action dictionary of the 'rwr' operation:
- Semantic action 'Definit' has the wrong arity: expected 1, got 10
- Semantic action 'InitStatement' has the wrong arity: expected 4, got 5
    at Grammar._checkTopDownActionDict (file:///Users/paultarvydas/projects/rt/node_modules/ohm-js/src/Grammar.js:141:21)
    at Operation.checkActionDict (file:///Users/paultarvydas/projects/rt/node_modules/ohm-js/src/Semantics.js:620:13)
    at Semantics.addOperationOrAttribute (file:///Users/paultarvydas/projects/rt/node_modules/ohm-js/src/Semantics.js:334:11)
    at proxy.addOperation (file:///Users/paultarvydas/projects/rt/node_modules/ohm-js/src/Semantics.js:538:7)
    at main (file:///Users/paultarvydas/projects/rt/0D2py.mjs:2230:15)
    at file:///Users/paultarvydas/projects/rt/0D2py.mjs:2240:14
    at ModuleJob.run (node:internal/modules/esm/module_job:222:25)
    at async ModuleLoader.import (node:internal/modules/esm/loader:323:24)
    at async loadESM (node:internal/process/esm_loader:28:7)
    at async handleMainPromise (node:internal/modules/run_main:120:12) {
  problems: [
    "Semantic action 'Definit' has the wrong arity: expected 1, got 10",
    "Semantic action 'InitStatement' has the wrong arity: expected 4, got 5"
  ]
}

Node.js v21.7.3

