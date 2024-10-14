# goal
- rewrite 0D in a higher level notation
- use higher level notation to generate Python and CL code 
- test generated code against ../rtscanner - an implementation of a Larson scanner in 0D
- hand-written Larson scanner is already working using Python-based 0D (py0d.py)
  - use that existing implementatation to regression-test the generated code
  - Python generator creates a version of 0D that can replace py0d.py and run the Larson scanner
  - working on generating CL version of 0D
	- step 1: generate cl0d
	- step 2: generate all ancilliary code required for the scanner in CL, e.g. the various Leaf components
- when that is working, generate Javascript code

- status: 
  - found bug in t2t wrt setting up parameters for passing information down into the parse tree
  - bug manifests itself as "undefined" in the output code
  - action: 
	- revamped t2t and t2t build process (https://github.com/guitarvydas/t2t)
