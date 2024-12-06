# goal
- "compile" (transpile) a VHLL called "rt" so that it generates executable code in Python and in Common Lisp 
- test generated code against ../rtlarson/python - an implementation of a Larson scanner in 0D
  
# usage:
0. clone the `rt` and `rtlarson` repositories 
1. in a command-line window, type `python3 choreographer.py`
   - it should display `WebSocket server started on ws://localhost:8765`
2. in a browser, open plwb.html
   - it should display `-- opened --` in the CommonLisp window and the Errors window
3. touch/edit `0d.rt.b`
   - the command line should display 
```
File 0d.rt.b has changed
watch_and_rebuild: clear
rebuild
```
	and, the "Errors" windows should display `begin...`, while a `-` appears in the CommonLisp and Python windows
	- [this runs the `./rebuild.bash` script]
4. when the rebuild is finished, the command prompt will display several `generate chunk...` messages with the final line being `watch_and-rebuild: 0`. The CommonLisp window will display the contents of the `generated.lisp` file and the Python window will display the contents of the `generated.py` file
5. run the results...
   - start a common lisp session, load `generated.lisp` and `larsonmain.lisp`, run `(larson)` and you should see 

```
" 1" 
"  2" 
"   3" 
"    4" 
"     5" 
"      6" 
"       7" 
"        8" 
"         9" 
"        8" 
"       7" 
"      6" 
"     5" 
"    4" 
"   3" 
"  2" 
" 1" 
"0" 
" 1" 
"  2" ...

```

		in the REPL, which is the output of the Larson Scanner in printed form
		- for example
			- `sbcl`
			- `(load "generated.lisp")` ;; ignore warnings
			- `(load "larsonmain.lisp")`
			- `(larson)`
	- cd `../rtlarson/python`
		- run `make`
		- you should see something like 
```
0
 1
  2
   3
    4
     5
      6
       7
        8
         9
        8
       7
      6
     5
    4
   3
  2
 1
0
 1
  2 ...
```
	        but, much faster 
			- [the speed can be changed by changing the value of `DELAYDELAY` in `delay.rt` and rebuilding]
	
# details

- The 0D kernel, plus stock library parts, is split across two files `0d.rt.a` and `0d.rt.b` (this split appeases memory restrictions on my 16Gb machine)
- The code files for the Larson Scanner are in `count.rt`, `decode.rt`, `delay.rt`, `monitor.rt`, `reverser.rt`
- The code for the transpiler is in `rt2py.drawio` and in `rt2cl.drawio`. These files are almost the same, but, include minor nuances required to generate code for each target language (Python, Common Lisp).
- repo rt https://github.com/guitarvydas/rt
- The code the Larson Scanner is in 
  - repo rtlarson https://github.com/guitarvydas/rtlarson
- OK if no das2json
  - the current version of das2json is built for Mac (M3 and Intel)
  - das2json is used only to generate `rt2py.drawio.json`, `rt2cp.drawio.json` and `scanner.drawio.json` from the corresponding `.drawio` files, a fairly trivial operation
  - if you don't find a compatible version of das2json, you can use the supplied `...drawio.json` files, but, might need to modify the `rebuild.bash` script to skip the `das2json` step
  - the original `das2json` was written in the Odin programming language and its source can be found in the 0D repository ; `das2json` is a simple application of an XML parser plus some code to preen out graphics-only information
- startup code for the Python version is in `../rlarson/python/main.py`
- startup code for the Common Lisp version is in `./larsonmain.lisp`
- this project uses various other technologies and includes them directly, but, for the record, they can be found at
  - repo t2t https://github.com/guitarvydas/t2t
  - repo 0D https://github.com/guitarvydas/0D
