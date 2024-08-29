# Description
I think that this is related to input size. Maybe a resource depletion issue? 

I'm using a Mac mini M2 Pro, 16M, Sonoma 14.6.1.

This is a text-to-text transpiler, based on OhmJS.

I've been using this kind of thing for several years, but, this is the first time that I've had an input file as large as 1,547 LOC.

(See "The Problem" below).

# How to recreate the problem: 
- git clone https://github.com/guitarvydas/rt/tree/bugreport
- Run `bug.bash` and it creates files `a` and `b`. It uses the bash script `editstring.bash`. It uses `rt0d.rt` as input and is supposed to transpile all `"..."` strings into `‛...’` strings (i.e. convert all ASCII double-quotes to Unicode matched-pair quotes).
- examine line 535 and 605 in `a` and `b` as described below

# Background
This tool is supposed to convert the meta-code in `rt0d.rt` into `edit5.mjs`. The purpose of `edit5.mjs` is to convert all ASCII double-quoted strings to Unicode quoted strings `‛...’` in `stdin` (it parses and transpiles a bit more, I'm trying to simplify by skipping details)

The conversion is currently done in two steps on the command line:
1. Read the grammar and the rewrite specification (`string.t2t`) and generate a converter program `edit5.mjs`.
2. Run `node edit5.mjs <rt0d.rt`, which performs the actual conversion.

The generated code, `edit.mjs`, is just a Javascript program that uses OhmJS. You might need to re-indent `edit.mjs`, though. The generated code is machine readable as is, but is less human readable until re-indented.

Normally, one would manually write the JS code `edit5.mjs` using a text editor and using OhmJS, then run the code.

I'm trying to automate the generation of `edit5.mjs`.  I've been doing something like this for years, but, this is the first time that I've had a really big input (1,547 LOC).

# The Problem

I would expect an error message, but, instead the code generator appears to work, silently fails, and continues to produce reasonable-looking output.

The first time (the first line of `bug.bash`) it produces file `a` but seems to fail to convert strings in line 605 and later.

If I re-run the same edit script on file `a` to produce file `b` (second line of `bug.bash`), the rest of the strings are correctly converted. 

line 535 "through" -> ‛through’	...in both, file `a` and file `b`, all strings before line 535 appear to be correctly converted, but, that's the last correctly converted string.
line 605 "." -> "."				...in file `a`
line 605 "." -> ‛.’				...in file `b`

# Other
I'm not heavily experienced in HTML+Javascript. I *should* delete the .bash script and just do everything in Javascript. I'm not sure how best to do this. The first pass generates Javascript code. The second pass runs the generated Javascript code. Maybe I could do both passes in the same JS program, say by capturing the generated code into a string variable, then `eval()`ing the generated code and running the evaled code. Ultimately, I want to run this in a browser, but, I'm using .bash to run node.js twice (node.js won't run in the browser). If you have suggestions, do let me know. 
