# REPL IDE for DPLWB
- Diagrammatic Programming Language WorkBench
- a REPL for developing a new VHLL - Very High Level Language
- implements a multi-tasking (green-ish) kernel in a VHLL and emits code for Python, Javascript and Common Lisp
- the VHLL is textual, while the compiler for the VHLL is a DPL (there's 2 levels of development here)
- the compiler (transpiler, actually), is written as a diagram in `rt2all.drawio`, is compiled and executed by the multi-tasking kernel and the repl
- Parts can have multiple inputs, multiple outputs and feedback loops

# Usage:
(see REPL.drawio for a sketch of how this is set up)

- clone this `rt` repo
- CD to the target `rt` repo
- open rt2all.drawio in a window
- open a Terminal window 
  - `> source rt/bin/activate`
  - `> make`
- open a browser in a separate window
  - open file `plwb.html`
- mouse to drawio drawing window
- hit Save (meta-S) to save the drawing out as graphML (a variant of XML)
- observe that the "Live" textbox in the `plwb.html` browser displays "begin..."
- wait about 10sec (Mac mini M3), 
  - 10 seconds isn't that long to compile a compiler and a multi-tasking runtime from scratch, but, it could be faster with some clean-up
- observe that the "Live" textbox in `plwb.html` displays "...end"
	- see generated code in the "Javascript", "Python", "CommonLisp" textboxes
	- (the "WASM" textbox remains blank - no code generation for WASM yet)
	- "Errors" textbox should remain blank (it displays errors during the compilation process, there should be no errors in this example run)
	
# Mechanics
- the program `choreographer.py` (run by `make`) checks the file rt2all.drawio every 2 seconds
  - the name "choreographer.py" should not be confused with Choreographer Parts on the diagram, I just had this name floating around in my head
- when `rt2all.drawio` is saved (or modified), `choreographer.py` spawns another thread which runs `rebuild.bash`
  - first, the diagram is converted to JSON and image-only information is culled out - this is done by `node das2json.js rt2all.drawio`
  - creates `rt2all.drawio.json`
  - next, `python3 main.py . - '' main rt2all.drawio.json` is executed
	 - inhales rt2all.drawio.json
	 - builds various internal data structures
	 - runs the diagram, invoking Worker code, as necessary
		 - Worker code is written as .py and .js and .mjs, for example indenter.mjs, etc.
		 - examine rt2all.drawio 
			 - any rectangle that is not included as another tab in the diagram editor is assumed to be supplied in `stock.py` or `shellout.py`
			 - any rectangle that has a name with first character "$" shells out a bash command as given by the rest of the name
				 - for example, the editor tab `Syntax Check` contains a rectangle named `$ ./ndsl syntax.ohm syntax.rewrite` 
				 - this invokes the `ndsl` shell script with two command-line arguments `syntax.ohm` and `syntax.rewrite`
				 - the shellout part receives `stdout` and `stderr` from the shell script 
					 - and fires appropriate output pins (named "" and "✗" respectively) which are converted to Mevents that flow within
						 the diagram
					 - a Mevent is just a string message with a string "port" name (effetively a tag) attached to it.
- every Part (rectangle on the rt2all.drawio diagram) runs concurrently (green-ish)
- arrows on the diagram represent fixed wires along which data (Mevents) flow
- every part queues up incoming Mevents and executes the first one in the queue when invoked by the "dispatcher" (at "random", indeterminate times)
- Parts are of 2 kinds (1) Choreographer parts, that contain children Parts and wires between them, and, (2) Worker parts that are implemented in code (in this case Python code, since this version uses Python as the base language)
- in fact, each Choreographer Part is a mini-dispatcher that routes Mevents between its children (and itself)
- Choreographer Parts can be built up recursively - they can contain one or more other Parts, and those Parts can be Choreographers or Workers
- There are 4 kinds of arrows - down, across, up, through. Doing this allows composition of Parts (kind of like Bash scripts which call other Bash scripts or non-Bash lumps of executable code).

# Deeper
- [TBD]
- [TBD] how to manually check the self-compile
- lots of gedanken articles in [blogs](guitarvydas.github.io) and [substack articles](paultarvydas.substack.com)

- RT leans on OhmJS to do inhaling (parsing of text)
- RT uses a custom nano-dsl to do exhaling (rewriting) using .rewrite rules
	- the custom nano-dsl happens to be written in OhmJS and can be viewed in `../t2t/library/t2t.mjs`
	- you can view source code for the RT transpiler in `emit.ohm` and in `emitPython.rewrite`
- disclaimer: this is WIP, my goal isn't to package this stuff up neatly
- the emitted kernel for Python is lightly tested
- the emitted kernel for Javascript and Common Lisp not tested yet (they were tested in a previous version)
- the Parts for the Larson Scanner compile, but, have not been tested yet (they were tested in a previous version)

# Discuss With Me
- I've probably not said many details, feel free to contact me to discuss
- ps (Programming Simplicity) Discord: all welcome https://discord.gg/65YZUh6Jpq (did I generate this link correctly?)

# Status
- VHLL language: 
	- das2json is now written in javascript (formerly only Odin)
		- das2json is a small program which converts a .drawio file into JSON
		- this means that drawings can be reduced to JSON, a format which can be manipulated by just about any programming language
	- got "RT" ("recursive text") compiler (transpiler) to run, at least for Python, and to self-compile 
	- RT is a VHLL that uses Python, Javascript and Common Lisp as "assemblers"
	- `rt` pushed to [repo](https://github.com/guitarvydas/rt/tree/dev)
	- `t2t` pushed to [repo](https://github.com/guitarvydas/t2t)
	- next: test Javascript and Common Lisp self-compilation
	- next-next: implement Larson Scanner in Javascript in a browser
	- README.md expanded to include some discussion of the mechanics of this stuff.
	- of interest: this is all fast enough to look like a REPL, although it spawns several heavy-weight processes and uses a local browser and websockets
	
	
