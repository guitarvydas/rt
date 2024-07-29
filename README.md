Experiment in Software Architectural Languages.

# Introduction
I had to reverse-engineer this piece of code:

```
(define (resolve x e)
  (cond ((not (pair? x)) x)
        ((var? x)
          (let ((v (value x e)))
            (if (var? v)
                v
                (resolve v e))))
        (else
          (cons
            (resolve (car x) e)
            (resolve (cdr x) e)))))
```

---

I rewrote it as:

```
⨍ resolve «x» in «env» ⎨
   if «x» is a var then ⎨
       if 𝑖𝑡 is a var then ⎨
           ✓ 𝑏𝑒𝑐𝑎𝑢𝑠𝑒 «x» is already saved as 𝑖𝑡
       ⎬ else ⎨
           resolve 𝑖𝑡 again 𝑖𝑛 env 𝑏𝑒𝑐𝑎𝑢𝑠𝑒 𝑖𝑡 might, again, be compound
       ⎬
  ⎬
  if «x» is not compound then ⎨
       𝓈𝒶𝓋ℯ «x» 
       ✓ 𝑏𝑒𝑐𝑎𝑢𝑠𝑒 we're done
  ⎬
  if «x» is compound then ⎨
      break 𝑖𝑡 down into parts and return a compound with each element deeply resolved 𝑖𝑛 env
  ⎬
⎬
```

which I think is more descriptive of the Design Intent (DI). [You don't have to agree with me, just observe that my rewritten code can be converted to Scheme code]

# How To Transpile the DI Code to Scheme
- I use OhmJS to parse the DI Code.
- I use RWR to rewrite the code after parsing.

The details are in this repository. `Fraze.ohm` is the grammar for OhmJS. `Fraze.rwr` is the rewrite specification.

To make this easy on me, I use the 0D tool. It joins the `fraze.ohm` with `fraze.rwr` and spits out the result. The backbone for this is written in a (very) simple DPL using the draw.io editor in the file `t2t.drawio`. To build the whole thing, run `make`. The support code is found in the `0D/` sub-directory and in the file `main.py`.


# Asides
- The original piece of code is written in Scheme and comes from Nils Holm's "Prolog Control in Six Slides".
- The original version of 0D was written in Odin. Now, though, the Python version has surpassed the Odin version. Only the Python version is included in this repository. [The Odin version can be found in https://github.com/guitarvydas/0D, if you care].
- The app `0D/das2json/das2json` converts `t2t.drawio` into a `.json` file. The `.json` file is inhaled and run by the Python 0D tool.
- `scrubber.js` cleans up the output, by replacing characters that are illegal in the target language (this is needed for the Python version of this stuff, but no needed by the Common Lisp version, since CL is more lenient about which characters are legal)
- `indenter.js` cleans up the ouput when we want to emit Python code. Python code needs to be carefully indented, but OhmJS+RWR is easier to work with if you emit structured, not indented, code. I insert indents and outdents along the way, then let `indenter.js` perform the final indentation. This process hurts my brain less.
- The transpiler needs to be provided with a support library of functions in some cases. In this case, as with most cases, we don't really need extra support functions, so we simply supply `null.js` to the transpiler. 
- The detailed implementation of the transpiler can be found in `0D/python/std/transpiler.drawio`. You don't need to understand these details to make all of this work, but, you can look at it if you want to understand how this works in excrutiating detail.
- Note that the use of ASCII has stunted our growth in language design. I go out of my way to include Unicode characters in `fraze` to show that it can be done. Unicode has a zillion characters available, so I don't need to suffer with making some characters do double-duty. I simply hard-wire a single meaning for each character into the parser.  I'm not sure if the source file reads better because of this (maybe it's just that I've been indoctrinated with ASCII-based programming languages?), but, at least, this shows that we can use more characters when it makes visual sense to do so.
