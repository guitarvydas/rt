--- !!! ERRORS !!! ---
defvar⋅cou ✗ main
defvar⋅cou   ✗ grammarDef applySyntactic<ParameterDef>* rewriteDef
defvar⋅cou     ✗ grammarDef
defvar⋅cou       ✗ "% grammar" spaces name rule+
defvar⋅cou         ✗ "% grammar"


/Users/paultarvydas/projects/rt/scrubber.js:6
    return decodeURI (s.replace (/❲/g, '').replace (/\?❳/g, '_Q').replace (/❳/g, ''))
           ^

URIError: URI malformed
    at decodeURI (<anonymous>)
    at scrubber (/Users/paultarvydas/projects/rt/scrubber.js:6:12)
    at Object.<anonymous> (/Users/paultarvydas/projects/rt/scrubber.js:29:12)
    at Module._compile (node:internal/modules/cjs/loader:1368:14)
    at Module._extensions..js (node:internal/modules/cjs/loader:1426:10)
    at Module.load (node:internal/modules/cjs/loader:1205:32)
    at Module._load (node:internal/modules/cjs/loader:1021:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:142:12)
    at node:internal/main/run_main_module:28:49

Node.js v21.7.3

