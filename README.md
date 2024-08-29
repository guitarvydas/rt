# Description
I'm using a Mac mini M2 Pro, 16M, Sonoma 14.6.1.

This is a simple text-to-text transpiler, that uses OhmJS.

It seems to fail part-way through, but, doesn't report an error and appears to finish.

line 535 "through" -> ‛through’	...in both, file `a` and file `b`, all strings before line 535 appear to be correctly converted, but, that's the last correctly converted string.
line 605 "." -> "."				...in file `a`
line 605 "." -> ‛.’				...in file `b`


I expect all strings to be converted, i.e. line 605 should be

line 605 "." -> ‛.’				...in file `a` but is only correctly converted in file `b`


Most of the time, when I hit something that looks like an OhmJS bug, it turns out to be an error on my part. This time, though, I run the partly converted output through the same program a second time and it seems to pick up where it left off, producing all of the conversions that I expect to see. Note that the partly converted output has no double-quoted strings until line 605. The second run starts with the partly converted file (not the original source) and so doesn't match any ASCII strings until it hits line 605.

I've been using this kind of thing for several years, but, this is the first time that I've had an input file as large as 1,547 LOC. This makes me think that I'm hitting some sort of silent resource depletion issue.

# How to recreate the problem: 
- git clone https://github.com/guitarvydas/rt/tree/bugreport
- Run `bug.bash` and it creates files `a` and `b`. It uses the Javascript program `edit5.mjs`. It uses `rt0d.rt` as input and is supposed to transpile all `"..."` strings into `‛...’` strings (i.e. convert all ASCII double-quotes to Unicode matched-pair quotes). It seems to fail to convert strings found after line 535, as seen in the first output in `a`. The second run begins with the partly-converted file `a` and finishes the job (output in `b`)
- examine line 535 and 605 in `a` and `b`

# Background

`edit5.mjs` should be a simple application of OhmJS that parses out all ASCII double-quoted strings  `"..."` into strings that use Unicode quote pairs `‛...’`.

For background, I'm trying to automate the generation of `edit5.mjs`. The code in `edit5.mjs` might not look like human-written code, but it is Javascript nonetheless. 

# Other
I'm not heavily experienced in HTML+Javascript. I *should* delete the .bash script and just do everything in Javascript. I'm not sure how best to do this. The first pass generates Javascript code. The second pass runs the generated Javascript code. Maybe I could do both passes in the same JS program, say by capturing the generated code into a string variable, then `eval()`ing the generated code and running the evaled code. Ultimately, I want to run this in a browser, but, I'm using .bash to run node.js twice (node.js won't run in the browser). If you have suggestions, do let me know. 
