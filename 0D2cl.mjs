
'use strict'

import {_} from './support.mjs';
import * as ohm from 'ohm-js';

let return_value_stack = [];
let rule_name_stack = [];

let DummyName1_stack = [];
let DummyName2_stack = [];
let FunctionName_stack = [];

const grammar = String.raw`
rt {
 

  Main = TopLevel+
  TopLevel =
    | Defvar -- defvar
    | Defconst -- defconst
    | Defn -- defn
    | Defclass -- defclass
    | Import -- import

   kw<s> = s ~identTail

   Defvar = kw<"defvar"> Lval "=" Exp
   Defconst = kw<"defconst"> Lval "=" Exp
   Defn = kw<"defn"> ident Formals StatementBlock
   Defclass = kw<"defclass"> ident "{" Definit "}"
   Import = kw<"import"> ident

   StatementBlock = "{" Rec_Statement "}"

   Definit = kw<"definit"> "(" kw<"self"> ":" ident CommaFormal* ")" "{" InitStatement+ "}"

   Rec_Statement =
     | kw<"global"> ident CommaIdent* Rec_Statement? -- globals
     | IfStatement  -- if
     | kw<"pass"> Rec_Statement? -- pass
     | kw<"return"> ReturnExp -- return
     | ForStatement -- for
     | WhileStatement  -- while
     | TryStatement -- try
     | Assignment -- assignment
     | Lval Rec_Statement? -- call
   CommaIdent = "," ident

   InitStatement = kw<"self"> "." ident "=" Exp

   IfStatement = kw<"if"> Exp StatementBlock ElifStatement* ElseStatement? Rec_Statement?
   ElifStatement = kw<"elif"> Exp StatementBlock
   ElseStatement = kw<"else"> StatementBlock

   ForStatement = kw<"for"> ident kw<"in"> Exp StatementBlock Rec_Statement?
   WhileStatement = kw<"while"> Exp StatementBlock Rec_Statement?

   TryStatement = kw<"try"> StatementBlock ExceptBlock+ Rec_Statement?
   ExceptBlock =
     | kw<"except"> Exp kw<"as"> ident StatementBlock -- as
     | kw<"except"> ident StatementBlock -- basic
   
   Assignment = 
     | Lval "+=" Exp Rec_Statement? -- pluseq
     | "[" Lval CommaLval+ "]" "=" Exp Rec_Statement? -- multiple
     | Lval "=" Exp Rec_Statement? -- single

   CommaLval = "," Lval

    ReturnExp =
      | "[" Exp CommaExp+ "]" Rec_Statement? -- multiple
      | Exp Rec_Statement? -- single

    CommaExp = "," Exp
    
    Exp =  BooleanExp

    BooleanExp =
      | BooleanExp boolOp BooleanNot -- boolop
      | BooleanNot -- basic

    BooleanNot =
      | kw<"not"> BooleanExp -- not
      | AddExp -- basic

    AddExp =
      | AddExp "+" MulExp  -- plus
      | AddExp "-" MulExp  -- minus
      | MulExp -- basic

    MulExp =
      | MulExp "*" ExpExp  -- times
      | MulExp "/" ExpExp  -- divide
      | ExpExp -- basic

    ExpExp =
      | Primary "^" ExpExp  -- power
      | Primary -- basic

    Primary =
      | Primary "@" ident -- lookupident
      | Primary "@" Primary -- lookup
      | Primary "." Primary Actuals -- methodcall
      | Primary "." Primary -- field
      | Primary "[" Exp "]" -- index
      | Primary "[" digit+ ":" "]" -- nthslice
      | Primary Actuals -- call
      | "(" Exp ")" -- paren
      | "[" "]" -- emptylistconst
      | "[" PrimaryComma+ "]" -- listconst
      | "{" "}" -- emptydict
      | "{" PairComma+ "}" -- dict
      | "λ" LambdaFormals? ":" Exp -- lambda
      | kw<"fresh"> "(" ident ")" -- fresh
      | kw<"car"> "(" Exp ")" -- car
      | kw<"cdr"> "(" Exp ")" -- cdr
      | kw<"argvcdr"> "(" digit ")" -- nthargvcdr
      | kw<"nthargv"> "(" digit ")" -- nthargv
      | kw<"stringcdr"> "(" Exp ")" -- stringcdr
      | "+" Primary -- pos
      | "-" Primary -- neg
      | phi -- phi
      | "⊤" -- true
      | "⊥" -- false
      | kw<"range"> "(" Exp ")" -- range
      | string -- string
      | number -- number
      | ident -- ident



    PrimaryComma = Primary ","?
    PairComma = Pair ","?
    
    Lval = Exp





    keyword = (
        kw<"fresh">
      | kw<"defvar">
      | kw<"defconst">
      | kw<"defn">
      | kw<"defclass">
      | kw<"definit">
      | kw<"self">
      | kw<"useglobal">
      | kw<"pass">
      | kw<"return">
      | kw<"if">
      | kw<"elif">
      | kw<"else">
      | kw<"and">
      | kw<"or">
      | kw<"in">
      | kw<"not">
      | kw<"range">
      | kw<"while">
      | kw<"f\"">
      | kw<"f'">
      | kw<"import">
      | kw<"try">
      | kw<"except">
      | kw<"as">
      | kw<"λ">
      | kw<"car">
      | kw<"cdr">
      | kw<"stringcdr">
      | kw<"argvcdr">
      | kw<"nthargv">
      )
      
    ident  = ~keyword identHead identTail*

    identHead = ( "_" | letter )
    identTail = ( alnum | identHead )

    Formals =
      | "(" ")" -- noformals
      | "(" Formal CommaFormal* ")" -- withformals
    LambdaFormals =
      | "(" ")" -- noformals
      | "(" Formal CommaFormal* ")" -- withformals

    Formal = ident ("=" Exp)?
    CommaFormal = "," Formal
    
    Actuals = 
      | "(" ")" -- noactuals
      | "(" Actual CommaActual* ")" -- actuals

   Actual = ParamName? Exp
   CommaActual = "," Actual

   ParamName = ident "="

    number =
      | digit* "." digit+  -- fract
      | digit+             -- whole

    Pair = string ":" Exp ","?
  

  boolOp = ("==" | "!=" | "<=" | ">=" | ">" | "<" | kw<"and"> | kw<"or"> | kw<"in">) 
  phi = "ϕ"
  string =
    | "f\"" notdq* "\"" -- fdqstring
    | "f'" notsq* "'" -- fsqstring
    | "\"" notdq* "\"" -- dqstring
    | "'" notsq* "'" -- sqstring
  notdq = ~"\"" any
  notsq = ~"'" any


  comment = "#" notnl* nl
  nl = "\n"
  notnl = ~nl any
  space += comment

}
`;

const rewrite_code = {
Main : function (_TopLevel, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=TopLevel
let TopLevel = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Main");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

TopLevel = _TopLevel.rwr ().join ('')

TopLevel = _TopLevel.rwr ().join ('')

_.set_top (return_value_stack, `${TopLevel}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_defvar : function (_Defvar, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Defvar
let Defvar = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_defvar");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Defvar = _Defvar.rwr ()

Defvar = _Defvar.rwr ()

_.set_top (return_value_stack, `${Defvar}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_defconst : function (_Defconst, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Defconst
let Defconst = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_defconst");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Defconst = _Defconst.rwr ()

Defconst = _Defconst.rwr ()

_.set_top (return_value_stack, `${Defconst}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_defn : function (_Defn, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Defn
let Defn = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_defn");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Defn = _Defn.rwr ()

Defn = _Defn.rwr ()

_.set_top (return_value_stack, `${Defn}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_defclass : function (_Defclass, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Defclass
let Defclass = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_defclass");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Defclass = _Defclass.rwr ()

Defclass = _Defclass.rwr ()

_.set_top (return_value_stack, `${Defclass}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_import : function (_Import, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Import
let Import = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_import");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Import = _Import.rwr ()

Import = _Import.rwr ()

_.set_top (return_value_stack, `${Import}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
kw : function (_s, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=s
let s = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "kw");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

s = _s.rwr ()

s = _s.rwr ()

_.set_top (return_value_stack, `${s}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Defvar : function (___, _lval, __eq, _e, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=__,lval,_eq,e
let __ = undefined;
let lval = undefined;
let _eq = undefined;
let e = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defvar");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

__ = ___.rwr ()
lval = _lval.rwr ()
_eq = __eq.rwr ()
e = _e.rwr ()

__ = ___.rwr ()
lval = _lval.rwr ()
_eq = __eq.rwr ()
e = _e.rwr ()

_.set_top (return_value_stack, `\n(defparameter ${lval} ${e})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Defconst : function (___, _lval, __eq, _e, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=__,lval,_eq,e
let __ = undefined;
let lval = undefined;
let _eq = undefined;
let e = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defconst");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

__ = ___.rwr ()
lval = _lval.rwr ()
_eq = __eq.rwr ()
e = _e.rwr ()

__ = ___.rwr ()
lval = _lval.rwr ()
_eq = __eq.rwr ()
e = _e.rwr ()

_.set_top (return_value_stack, `\n(defconstant ${lval} ${e})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Defn : function (__4, _ident, _Formals, _StatementBlock, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_4,ident,Formals,StatementBlock
let _4 = undefined;
let ident = undefined;
let Formals = undefined;
let StatementBlock = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defn");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_4 = __4.rwr ()
ident = _ident.rwr ()
Formals = _Formals.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (FunctionName_stack, `${ident}`);
_4 = __4.rwr ()
ident = _ident.rwr ()
Formals = _Formals.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (return_value_stack, `\n(defun ${ident} ${Formals}${StatementBlock})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Defclass : function (__6, _ident, __7, _Definit, __8, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_6,ident,_7,Definit,_8
let _6 = undefined;
let ident = undefined;
let _7 = undefined;
let Definit = undefined;
let _8 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defclass");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_6 = __6.rwr ()
ident = _ident.rwr ()
_7 = __7.rwr ()
Definit = _Definit.rwr ()
_8 = __8.rwr ()

_6 = __6.rwr ()
ident = _ident.rwr ()
_7 = __7.rwr ()
Definit = _Definit.rwr ()
_8 = __8.rwr ()

_.set_top (return_value_stack, `\n(defclass ${ident}:⤷\n${Definit})⤶\n`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Import : function (__10, _ident, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_10,ident
let _10 = undefined;
let ident = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Import");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_10 = __10.rwr ()
ident = _ident.rwr ()

_10 = __10.rwr ()
ident = _ident.rwr ()

_.set_top (return_value_stack, `\nimport ${ident}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
StatementBlock : function (__11, _Statement, __12, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_11,Statement,_12
let _11 = undefined;
let Statement = undefined;
let _12 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "StatementBlock");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_11 = __11.rwr ()
Statement = _Statement.rwr ()
_12 = __12.rwr ()

_11 = __11.rwr ()
Statement = _Statement.rwr ()
_12 = __12.rwr ()

_.set_top (return_value_stack, `⤷\n(progn⤷${Statement})⤶⤶\n`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Definit : function (__14, __15, __17, __18, _ident, _formals, __20, __21, _InitStatement, __22, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_14,_15,_17,_18,ident,formals,_20,_21,InitStatement,_22
let _14 = undefined;
let _15 = undefined;
let _17 = undefined;
let _18 = undefined;
let ident = undefined;
let formals = undefined;
let _20 = undefined;
let _21 = undefined;
let InitStatement = undefined;
let _22 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Definit");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_14 = __14.rwr ()
_15 = __15.rwr ()
_17 = __17.rwr ()
_18 = __18.rwr ()
ident = _ident.rwr ()
formals = _formals.rwr ().join ('')
_20 = __20.rwr ()
_21 = __21.rwr ()
InitStatement = _InitStatement.rwr ().join ('')
_22 = __22.rwr ()

_14 = __14.rwr ()
_15 = __15.rwr ()
_17 = __17.rwr ()
_18 = __18.rwr ()
ident = _ident.rwr ()
formals = _formals.rwr ().join ('')
_20 = __20.rwr ()
_21 = __21.rwr ()
InitStatement = _InitStatement.rwr ().join ('')
_22 = __22.rwr ()

_.set_top (return_value_stack, `(defun __init__ ${formals}⤷\n${InitStatement})⤶\n`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_globals : function (__24, _ident1, _cidents, _scope, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_24,ident1,cidents,scope
let _24 = undefined;
let ident1 = undefined;
let cidents = undefined;
let scope = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_globals");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_24 = __24.rwr ()
ident1 = _ident1.rwr ()
cidents = _cidents.rwr ().join ('')
scope = _scope.rwr ().join ('')

_24 = __24.rwr ()
ident1 = _ident1.rwr ()
cidents = _cidents.rwr ().join ('')
scope = _scope.rwr ().join ('')

_.set_top (return_value_stack, `\nglobal ${ident1}${cidents}${scope}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaIdent : function (__comma, _ident, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_comma,ident
let _comma = undefined;
let ident = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaIdent");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_comma = __comma.rwr ()
ident = _ident.rwr ()

_comma = __comma.rwr ()
ident = _ident.rwr ()

_.set_top (return_value_stack, `, ${ident}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_if : function (_IfStatement, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=IfStatement
let IfStatement = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_if");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

IfStatement = _IfStatement.rwr ()

IfStatement = _IfStatement.rwr ()

_.set_top (return_value_stack, `${IfStatement}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_pass : function (__27, _scope, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_27,scope
let _27 = undefined;
let scope = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_pass");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_27 = __27.rwr ()
scope = _scope.rwr ().join ('')

_27 = __27.rwr ()
scope = _scope.rwr ().join ('')

_.set_top (return_value_stack, `\npass${scope}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_return : function (__29, _ReturnExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_29,ReturnExp
let _29 = undefined;
let ReturnExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_return");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_29 = __29.rwr ()
ReturnExp = _ReturnExp.rwr ()

_29 = __29.rwr ()
ReturnExp = _ReturnExp.rwr ()

_.set_top (return_value_stack, `\n${ReturnExp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_for : function (_ForStatement, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=ForStatement
let ForStatement = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_for");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

ForStatement = _ForStatement.rwr ()

ForStatement = _ForStatement.rwr ()

_.set_top (return_value_stack, `${ForStatement}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_while : function (_WhileStatement, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=WhileStatement
let WhileStatement = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_while");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

WhileStatement = _WhileStatement.rwr ()

WhileStatement = _WhileStatement.rwr ()

_.set_top (return_value_stack, `${WhileStatement}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_try : function (_TryStatement, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=TryStatement
let TryStatement = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_try");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

TryStatement = _TryStatement.rwr ()

TryStatement = _TryStatement.rwr ()

_.set_top (return_value_stack, `${TryStatement}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_assignment : function (_Assignment, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Assignment
let Assignment = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_assignment");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Assignment = _Assignment.rwr ()

Assignment = _Assignment.rwr ()

_.set_top (return_value_stack, `${Assignment}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_call : function (_Lval, _scope, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Lval,scope
let Lval = undefined;
let scope = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_call");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Lval = _Lval.rwr ()
scope = _scope.rwr ().join ('')

Lval = _Lval.rwr ()
scope = _scope.rwr ().join ('')

_.set_top (return_value_stack, `\n${Lval}${scope}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_globals : function (__24, _ident1, _cidents, _scope, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_24,ident1,cidents,scope
let _24 = undefined;
let ident1 = undefined;
let cidents = undefined;
let scope = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_globals");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_24 = __24.rwr ()
ident1 = _ident1.rwr ()
cidents = _cidents.rwr ().join ('')
scope = _scope.rwr ().join ('')

_24 = __24.rwr ()
ident1 = _ident1.rwr ()
cidents = _cidents.rwr ().join ('')
scope = _scope.rwr ().join ('')

_.set_top (return_value_stack, `${scope}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaIdent : function (__comma, _ident, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_comma,ident
let _comma = undefined;
let ident = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaIdent");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_comma = __comma.rwr ()
ident = _ident.rwr ()

_comma = __comma.rwr ()
ident = _ident.rwr ()

_.set_top (return_value_stack, ` ${ident}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
InitStatement : function (__31, __32, _ident, __33, _Exp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_31,_32,ident,_33,Exp
let _31 = undefined;
let _32 = undefined;
let ident = undefined;
let _33 = undefined;
let Exp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "InitStatement");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_31 = __31.rwr ()
_32 = __32.rwr ()
ident = _ident.rwr ()
_33 = __33.rwr ()
Exp = _Exp.rwr ()

_31 = __31.rwr ()
_32 = __32.rwr ()
ident = _ident.rwr ()
_33 = __33.rwr ()
Exp = _Exp.rwr ()

_.set_top (return_value_stack, `\nself.${ident} = ${Exp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
IfStatement : function (__35, _Exp, _StatementBlock, _ElifStatement, _ElseStatement, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_35,Exp,StatementBlock,ElifStatement,ElseStatement,rec
let _35 = undefined;
let Exp = undefined;
let StatementBlock = undefined;
let ElifStatement = undefined;
let ElseStatement = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "IfStatement");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_35 = __35.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()
ElifStatement = _ElifStatement.rwr ().join ('')
ElseStatement = _ElseStatement.rwr ().join ('')
rec = _rec.rwr ().join ('')

_35 = __35.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()
ElifStatement = _ElifStatement.rwr ().join ('')
ElseStatement = _ElseStatement.rwr ().join ('')
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\nif ${Exp}:${StatementBlock}${ElifStatement}${ElseStatement}${rec}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ElifStatement : function (__37, _Exp, _StatementBlock, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_37,Exp,StatementBlock
let _37 = undefined;
let Exp = undefined;
let StatementBlock = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ElifStatement");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_37 = __37.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()

_37 = __37.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (return_value_stack, `elif ${Exp}:${StatementBlock}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ElseStatement : function (__39, _StatementBlock, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_39,StatementBlock
let _39 = undefined;
let StatementBlock = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ElseStatement");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_39 = __39.rwr ()
StatementBlock = _StatementBlock.rwr ()

_39 = __39.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (return_value_stack, `else:${StatementBlock}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ForStatement : function (__41, _ident, __43, _Exp, _StatementBlock, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_41,ident,_43,Exp,StatementBlock,rec
let _41 = undefined;
let ident = undefined;
let _43 = undefined;
let Exp = undefined;
let StatementBlock = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ForStatement");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_41 = __41.rwr ()
ident = _ident.rwr ()
_43 = __43.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()
rec = _rec.rwr ().join ('')

_41 = __41.rwr ()
ident = _ident.rwr ()
_43 = __43.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\nfor ${ident} in ${Exp}:${StatementBlock}${rec}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
WhileStatement : function (__45, _Exp, _StatementBlock, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_45,Exp,StatementBlock,rec
let _45 = undefined;
let Exp = undefined;
let StatementBlock = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "WhileStatement");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_45 = __45.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()
rec = _rec.rwr ().join ('')

_45 = __45.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\nwhile ${Exp}:${StatementBlock}${rec}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
TryStatement : function (__47, _StatementBlock, _ExceptBlock, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_47,StatementBlock,ExceptBlock,rec
let _47 = undefined;
let StatementBlock = undefined;
let ExceptBlock = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TryStatement");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_47 = __47.rwr ()
StatementBlock = _StatementBlock.rwr ()
ExceptBlock = _ExceptBlock.rwr ().join ('')
rec = _rec.rwr ().join ('')

_47 = __47.rwr ()
StatementBlock = _StatementBlock.rwr ()
ExceptBlock = _ExceptBlock.rwr ().join ('')
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\ntry:\n${StatementBlock}${ExceptBlock}${rec}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ExceptBlock_as : function (__49, _Exp, __51, _ident, _StatementBlock, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_49,Exp,_51,ident,StatementBlock
let _49 = undefined;
let Exp = undefined;
let _51 = undefined;
let ident = undefined;
let StatementBlock = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ExceptBlock_as");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_49 = __49.rwr ()
Exp = _Exp.rwr ()
_51 = __51.rwr ()
ident = _ident.rwr ()
StatementBlock = _StatementBlock.rwr ()

_49 = __49.rwr ()
Exp = _Exp.rwr ()
_51 = __51.rwr ()
ident = _ident.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (return_value_stack, `except ${Exp} as ${ident}:${StatementBlock}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ExceptBlock_basic : function (__53, _ident, _StatementBlock, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_53,ident,StatementBlock
let _53 = undefined;
let ident = undefined;
let StatementBlock = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ExceptBlock_basic");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_53 = __53.rwr ()
ident = _ident.rwr ()
StatementBlock = _StatementBlock.rwr ()

_53 = __53.rwr ()
ident = _ident.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (return_value_stack, `except ${ident}:${StatementBlock}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Assignment_pluseq : function (_Lval, __54, _Exp, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Lval,_54,Exp,rec
let Lval = undefined;
let _54 = undefined;
let Exp = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Assignment_pluseq");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Lval = _Lval.rwr ()
_54 = __54.rwr ()
Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

Lval = _Lval.rwr ()
_54 = __54.rwr ()
Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(inc ${Lval} ${Exp})${rec}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Assignment_multiple : function (__55, _Lval1, _Lval2, __57, __58, _Exp, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_55,Lval1,Lval2,_57,_58,Exp,rec
let _55 = undefined;
let Lval1 = undefined;
let Lval2 = undefined;
let _57 = undefined;
let _58 = undefined;
let Exp = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Assignment_multiple");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_55 = __55.rwr ()
Lval1 = _Lval1.rwr ()
Lval2 = _Lval2.rwr ().join ('')
_57 = __57.rwr ()
_58 = __58.rwr ()
Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

_55 = __55.rwr ()
Lval1 = _Lval1.rwr ()
Lval2 = _Lval2.rwr ().join ('')
_57 = __57.rwr ()
_58 = __58.rwr ()
Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(multiple-value-bind (${Lval1} ${Lval2})⤷⤷\n${Exp}⤶${rec}⤶)`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Assignment_single : function (_Lval, __59, _Exp, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Lval,_59,Exp,rec
let Lval = undefined;
let _59 = undefined;
let Exp = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Assignment_single");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Lval = _Lval.rwr ()
_59 = __59.rwr ()
Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

Lval = _Lval.rwr ()
_59 = __59.rwr ()
Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(let (${Lval} ${Exp})⤷${rec}⤶)`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaLval : function (__comma, _Lval, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_comma,Lval
let _comma = undefined;
let Lval = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaLval");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_comma = __comma.rwr ()
Lval = _Lval.rwr ()

_comma = __comma.rwr ()
Lval = _Lval.rwr ()

_.set_top (return_value_stack, `, ${Lval}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ReturnExp_multiple : function (__60, _Exp1, _Exp2, __62, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_60,Exp1,Exp2,_62,rec
let _60 = undefined;
let Exp1 = undefined;
let Exp2 = undefined;
let _62 = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ReturnExp_multiple");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_60 = __60.rwr ()
Exp1 = _Exp1.rwr ()
Exp2 = _Exp2.rwr ().join ('')
_62 = __62.rwr ()
rec = _rec.rwr ().join ('')

_60 = __60.rwr ()
Exp1 = _Exp1.rwr ()
Exp2 = _Exp2.rwr ().join ('')
_62 = __62.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(return-from ${_.top (FunctionName_stack)} (values ${Exp1} ${Exp2}))${rec}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ReturnExp_single : function (_Exp, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Exp,rec
let Exp = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ReturnExp_single");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(return-from ${_.top (FunctionName_stack)} ${Exp})${rec}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaExp : function (__comma, _e, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_comma,e
let _comma = undefined;
let e = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaExp");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_comma = __comma.rwr ()
e = _e.rwr ()

_comma = __comma.rwr ()
e = _e.rwr ()

_.set_top (return_value_stack, ` ${e}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Exp : function (_BooleanExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=BooleanExp
let BooleanExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Exp");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

BooleanExp = _BooleanExp.rwr ()

BooleanExp = _BooleanExp.rwr ()

_.set_top (return_value_stack, `${BooleanExp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
BooleanExp_boolop : function (_BooleanExp, _boolOp, _BooleanNot, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=BooleanExp,boolOp,BooleanNot
let BooleanExp = undefined;
let boolOp = undefined;
let BooleanNot = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "BooleanExp_boolop");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

BooleanExp = _BooleanExp.rwr ()
boolOp = _boolOp.rwr ()
BooleanNot = _BooleanNot.rwr ()

BooleanExp = _BooleanExp.rwr ()
boolOp = _boolOp.rwr ()
BooleanNot = _BooleanNot.rwr ()

_.set_top (return_value_stack, `(${boolOp} ${BooleanExp} ${BooleanNot})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
BooleanExp_basic : function (_BooleanNot, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=BooleanNot
let BooleanNot = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "BooleanExp_basic");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

BooleanNot = _BooleanNot.rwr ()

BooleanNot = _BooleanNot.rwr ()

_.set_top (return_value_stack, `${BooleanNot}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
BooleanNot_not : function (__64, _BooleanExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_64,BooleanExp
let _64 = undefined;
let BooleanExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "BooleanNot_not");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_64 = __64.rwr ()
BooleanExp = _BooleanExp.rwr ()

_64 = __64.rwr ()
BooleanExp = _BooleanExp.rwr ()

_.set_top (return_value_stack, `(not ${BooleanExp})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
BooleanNot_basic : function (_AddExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=AddExp
let AddExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "BooleanNot_basic");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

AddExp = _AddExp.rwr ()

AddExp = _AddExp.rwr ()

_.set_top (return_value_stack, `${AddExp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
AddExp_plus : function (_AddExp, __65, _MulExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=AddExp,_65,MulExp
let AddExp = undefined;
let _65 = undefined;
let MulExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "AddExp_plus");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

AddExp = _AddExp.rwr ()
_65 = __65.rwr ()
MulExp = _MulExp.rwr ()

AddExp = _AddExp.rwr ()
_65 = __65.rwr ()
MulExp = _MulExp.rwr ()

_.set_top (return_value_stack, `(+ ${AddExp} ${MulExp})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
AddExp_minus : function (_AddExp, __66, _MulExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=AddExp,_66,MulExp
let AddExp = undefined;
let _66 = undefined;
let MulExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "AddExp_minus");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

AddExp = _AddExp.rwr ()
_66 = __66.rwr ()
MulExp = _MulExp.rwr ()

AddExp = _AddExp.rwr ()
_66 = __66.rwr ()
MulExp = _MulExp.rwr ()

_.set_top (return_value_stack, `(- ${AddExp} ${MulExp})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
AddExp_basic : function (_MulExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=MulExp
let MulExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "AddExp_basic");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

MulExp = _MulExp.rwr ()

MulExp = _MulExp.rwr ()

_.set_top (return_value_stack, `${MulExp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
MulExp_times : function (_MulExp, __67, _ExpExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=MulExp,_67,ExpExp
let MulExp = undefined;
let _67 = undefined;
let ExpExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "MulExp_times");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

MulExp = _MulExp.rwr ()
_67 = __67.rwr ()
ExpExp = _ExpExp.rwr ()

MulExp = _MulExp.rwr ()
_67 = __67.rwr ()
ExpExp = _ExpExp.rwr ()

_.set_top (return_value_stack, `(* ${MulExp} ${ExpExp})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
MulExp_divide : function (_MulExp, __68, _ExpExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=MulExp,_68,ExpExp
let MulExp = undefined;
let _68 = undefined;
let ExpExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "MulExp_divide");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

MulExp = _MulExp.rwr ()
_68 = __68.rwr ()
ExpExp = _ExpExp.rwr ()

MulExp = _MulExp.rwr ()
_68 = __68.rwr ()
ExpExp = _ExpExp.rwr ()

_.set_top (return_value_stack, `(/ ${MulExp} ${ExpExp})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
MulExp_basic : function (_ExpExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=ExpExp
let ExpExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "MulExp_basic");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

ExpExp = _ExpExp.rwr ()

ExpExp = _ExpExp.rwr ()

_.set_top (return_value_stack, `${ExpExp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ExpExp_power : function (_Primary, __69, _ExpExp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Primary,_69,ExpExp
let Primary = undefined;
let _69 = undefined;
let ExpExp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ExpExp_power");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Primary = _Primary.rwr ()
_69 = __69.rwr ()
ExpExp = _ExpExp.rwr ()

Primary = _Primary.rwr ()
_69 = __69.rwr ()
ExpExp = _ExpExp.rwr ()

_.set_top (return_value_stack, `(expt ${Primary} ${ExpExp})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ExpExp_basic : function (_Primary, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Primary
let Primary = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ExpExp_basic");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Primary = _Primary.rwr ()

Primary = _Primary.rwr ()

_.set_top (return_value_stack, `${Primary}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_lookupident : function (_p, __at, _key, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=p,_at,key
let p = undefined;
let _at = undefined;
let key = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_lookupident");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

p = _p.rwr ()
_at = __at.rwr ()
key = _key.rwr ()

p = _p.rwr ()
_at = __at.rwr ()
key = _key.rwr ()

_.set_top (return_value_stack, `(gethash '${key} ${p})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_lookup : function (_p, __at, _key, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=p,_at,key
let p = undefined;
let _at = undefined;
let key = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_lookup");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

p = _p.rwr ()
_at = __at.rwr ()
key = _key.rwr ()

p = _p.rwr ()
_at = __at.rwr ()
key = _key.rwr ()

_.set_top (return_value_stack, `(gethash ${key} ${p})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_methodcall : function (_p, __dot, _f, _actuals, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=p,_dot,f,actuals
let p = undefined;
let _dot = undefined;
let f = undefined;
let actuals = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_methodcall");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

p = _p.rwr ()
_dot = __dot.rwr ()
f = _f.rwr ()
actuals = _actuals.rwr ()

p = _p.rwr ()
_dot = __dot.rwr ()
f = _f.rwr ()
actuals = _actuals.rwr ()

_.set_top (return_value_stack, `(funcall (slot-value '${f} ${p}) ${actuals})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_field : function (_p, __dot, _key, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=p,_dot,key
let p = undefined;
let _dot = undefined;
let key = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_field");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

p = _p.rwr ()
_dot = __dot.rwr ()
key = _key.rwr ()

p = _p.rwr ()
_dot = __dot.rwr ()
key = _key.rwr ()

_.set_top (return_value_stack, `(slot-value ${key} ${p})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_index : function (_p, _lb, _e, _rb, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=p,lb,e,rb
let p = undefined;
let lb = undefined;
let e = undefined;
let rb = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_index");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

p = _p.rwr ()
lb = _lb.rwr ()
e = _e.rwr ()
rb = _rb.rwr ()

p = _p.rwr ()
lb = _lb.rwr ()
e = _e.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `(aref ${p} ${e})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_nthslice : function (_p, _lb, _ds, __colon, _rb, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=p,lb,ds,_colon,rb
let p = undefined;
let lb = undefined;
let ds = undefined;
let _colon = undefined;
let rb = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_nthslice");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

p = _p.rwr ()
lb = _lb.rwr ()
ds = _ds.rwr ().join ('')
_colon = __colon.rwr ()
rb = _rb.rwr ()

p = _p.rwr ()
lb = _lb.rwr ()
ds = _ds.rwr ().join ('')
_colon = __colon.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `(nthcdr ${ds} ${p})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_call : function (_p, _actuals, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=p,actuals
let p = undefined;
let actuals = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_call");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

p = _p.rwr ()
actuals = _actuals.rwr ()

p = _p.rwr ()
actuals = _actuals.rwr ()

_.set_top (return_value_stack, `(${p} ${actuals})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_paren : function (__70, _Exp, __71, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_70,Exp,_71
let _70 = undefined;
let Exp = undefined;
let _71 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_paren");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_70 = __70.rwr ()
Exp = _Exp.rwr ()
_71 = __71.rwr ()

_70 = __70.rwr ()
Exp = _Exp.rwr ()
_71 = __71.rwr ()

_.set_top (return_value_stack, ` ${Exp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_emptylistconst : function (__72, __73, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_72,_73
let _72 = undefined;
let _73 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_emptylistconst");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_72 = __72.rwr ()
_73 = __73.rwr ()

_72 = __72.rwr ()
_73 = __73.rwr ()

_.set_top (return_value_stack, ` nil`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_listconst : function (__74, _PrimaryComma, __75, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_74,PrimaryComma,_75
let _74 = undefined;
let PrimaryComma = undefined;
let _75 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_listconst");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_74 = __74.rwr ()
PrimaryComma = _PrimaryComma.rwr ().join ('')
_75 = __75.rwr ()

_74 = __74.rwr ()
PrimaryComma = _PrimaryComma.rwr ().join ('')
_75 = __75.rwr ()

_.set_top (return_value_stack, `(list ${PrimaryComma})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_emptydict : function (__76, __77, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_76,_77
let _76 = undefined;
let _77 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_emptydict");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_76 = __76.rwr ()
_77 = __77.rwr ()

_76 = __76.rwr ()
_77 = __77.rwr ()

_.set_top (return_value_stack, `(make-hash-table :test :equal)`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_dict : function (__78, _PairComma, __79, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_78,PairComma,_79
let _78 = undefined;
let PairComma = undefined;
let _79 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_dict");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_78 = __78.rwr ()
PairComma = _PairComma.rwr ().join ('')
_79 = __79.rwr ()

_78 = __78.rwr ()
PairComma = _PairComma.rwr ().join ('')
_79 = __79.rwr ()

_.set_top (return_value_stack, `(fresh-hash (list ${PairComma}))`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_lambda : function (__80, _Formals, __81, _Exp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_80,Formals,_81,Exp
let _80 = undefined;
let Formals = undefined;
let _81 = undefined;
let Exp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_lambda");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_80 = __80.rwr ()
Formals = _Formals.rwr ().join ('')
_81 = __81.rwr ()
Exp = _Exp.rwr ()

_80 = __80.rwr ()
Formals = _Formals.rwr ().join ('')
_81 = __81.rwr ()
Exp = _Exp.rwr ()

_.set_top (return_value_stack, `#'(lambda ${Formals} ${Exp})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_fresh : function (__83, __84, _ident, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,ident,_85
let _83 = undefined;
let _84 = undefined;
let ident = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_fresh");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_83 = __83.rwr ()
_84 = __84.rwr ()
ident = _ident.rwr ()
_85 = __85.rwr ()

_83 = __83.rwr ()
_84 = __84.rwr ()
ident = _ident.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(fresh-${ident})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_car : function (__83, __84, _e, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,e,_85
let _83 = undefined;
let _84 = undefined;
let e = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_car");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_83 = __83.rwr ()
_84 = __84.rwr ()
e = _e.rwr ()
_85 = __85.rwr ()

_83 = __83.rwr ()
_84 = __84.rwr ()
e = _e.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(car ${e})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_cdr : function (__83, __84, _e, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,e,_85
let _83 = undefined;
let _84 = undefined;
let e = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_cdr");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_83 = __83.rwr ()
_84 = __84.rwr ()
e = _e.rwr ()
_85 = __85.rwr ()

_83 = __83.rwr ()
_84 = __84.rwr ()
e = _e.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(cdr ${e})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_stringcdr : function (__83, __84, _e, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,e,_85
let _83 = undefined;
let _84 = undefined;
let e = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_stringcdr");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_83 = __83.rwr ()
_84 = __84.rwr ()
e = _e.rwr ()
_85 = __85.rwr ()

_83 = __83.rwr ()
_84 = __84.rwr ()
e = _e.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(subseq ${e} 1)`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_nthargvcdr : function (__83, _lb, _n, _rb, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,lb,n,rb
let _83 = undefined;
let lb = undefined;
let n = undefined;
let rb = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_nthargvcdr");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_83 = __83.rwr ()
lb = _lb.rwr ()
n = _n.rwr ()
rb = _rb.rwr ()

_83 = __83.rwr ()
lb = _lb.rwr ()
n = _n.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `(nthcdr *argv* ${n})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_nthargv : function (__83, __84, _n, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,n,_85
let _83 = undefined;
let _84 = undefined;
let n = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_nthargv");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_83 = __83.rwr ()
_84 = __84.rwr ()
n = _n.rwr ()
_85 = __85.rwr ()

_83 = __83.rwr ()
_84 = __84.rwr ()
n = _n.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(nth *argv* ${n})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_pos : function (__86, _Primary, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_86,Primary
let _86 = undefined;
let Primary = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_pos");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_86 = __86.rwr ()
Primary = _Primary.rwr ()

_86 = __86.rwr ()
Primary = _Primary.rwr ()

_.set_top (return_value_stack, `(+ ${Primary} 0)`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_neg : function (__87, _Primary, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_87,Primary
let _87 = undefined;
let Primary = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_neg");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_87 = __87.rwr ()
Primary = _Primary.rwr ()

_87 = __87.rwr ()
Primary = _Primary.rwr ()

_.set_top (return_value_stack, `(- 0 ${Primary})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_phi : function (_phi, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=phi
let phi = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_phi");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

phi = _phi.rwr ()

phi = _phi.rwr ()

_.set_top (return_value_stack, ` nil`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_true : function (__88, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_88
let _88 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_true");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_88 = __88.rwr ()

_88 = __88.rwr ()

_.set_top (return_value_stack, ` t`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_false : function (__89, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_89
let _89 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_false");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_89 = __89.rwr ()

_89 = __89.rwr ()

_.set_top (return_value_stack, ` nil`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_range : function (__91, __92, _Exp, __93, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_91,_92,Exp,_93
let _91 = undefined;
let _92 = undefined;
let Exp = undefined;
let _93 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_range");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_91 = __91.rwr ()
_92 = __92.rwr ()
Exp = _Exp.rwr ()
_93 = __93.rwr ()

_91 = __91.rwr ()
_92 = __92.rwr ()
Exp = _Exp.rwr ()
_93 = __93.rwr ()

_.set_top (return_value_stack, `(loop for n from 0 below ${Exp} by 1 collect n)`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_string : function (_string, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=string
let string = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_string");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

string = _string.rwr ()

string = _string.rwr ()

_.set_top (return_value_stack, `${string}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_number : function (_number, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=number
let number = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_number");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

number = _number.rwr ()

number = _number.rwr ()

_.set_top (return_value_stack, `${number}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_ident : function (_ident, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=ident
let ident = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_ident");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

ident = _ident.rwr ()

ident = _ident.rwr ()

_.set_top (return_value_stack, `${ident}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
PrimaryComma : function (_Primary, __94, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Primary,_94
let Primary = undefined;
let _94 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "PrimaryComma");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Primary = _Primary.rwr ()
_94 = __94.rwr ().join ('')

Primary = _Primary.rwr ()
_94 = __94.rwr ().join ('')

_.set_top (return_value_stack, ` ${Primary}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
PairComma : function (_Pair, __95, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Pair,_95
let Pair = undefined;
let _95 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "PairComma");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Pair = _Pair.rwr ()
_95 = __95.rwr ().join ('')

Pair = _Pair.rwr ()
_95 = __95.rwr ().join ('')

_.set_top (return_value_stack, ` ${Pair}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Lval : function (_Exp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Exp
let Exp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Lval");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

Exp = _Exp.rwr ()

Exp = _Exp.rwr ()

_.set_top (return_value_stack, `${Exp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
keyword : function (__144, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_144
let _144 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "keyword");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_144 = __144.rwr ()

_144 = __144.rwr ()

_.set_top (return_value_stack, `${_144}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ident : function (_identHead, _identTail, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=identHead,identTail
let identHead = undefined;
let identTail = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ident");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

identHead = _identHead.rwr ()
identTail = _identTail.rwr ().join ('')

identHead = _identHead.rwr ()
identTail = _identTail.rwr ().join ('')

_.set_top (return_value_stack, `${identHead}${identTail}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
identHead : function (__146, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_146
let _146 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "identHead");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_146 = __146.rwr ()

_146 = __146.rwr ()

_.set_top (return_value_stack, `${_146}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
identTail : function (__147, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_147
let _147 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "identTail");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_147 = __147.rwr ()

_147 = __147.rwr ()

_.set_top (return_value_stack, `${_147}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Formals_noformals : function (__148, __149, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_148,_149
let _148 = undefined;
let _149 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Formals_noformals");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_148 = __148.rwr ()
_149 = __149.rwr ()

_148 = __148.rwr ()
_149 = __149.rwr ()

_.set_top (return_value_stack, `()`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Formals_withformals : function (__150, _Formal, _CommaFormal, __151, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_150,Formal,CommaFormal,_151
let _150 = undefined;
let Formal = undefined;
let CommaFormal = undefined;
let _151 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Formals_withformals");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_150 = __150.rwr ()
Formal = _Formal.rwr ()
CommaFormal = _CommaFormal.rwr ().join ('')
_151 = __151.rwr ()

_150 = __150.rwr ()
Formal = _Formal.rwr ()
CommaFormal = _CommaFormal.rwr ().join ('')
_151 = __151.rwr ()

_.set_top (return_value_stack, `(${Formal}${CommaFormal})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
LambdaFormals_noformals : function (__148, __149, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_148,_149
let _148 = undefined;
let _149 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "LambdaFormals_noformals");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_148 = __148.rwr ()
_149 = __149.rwr ()

_148 = __148.rwr ()
_149 = __149.rwr ()

_.set_top (return_value_stack, `()`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
LambdaFormals_withformals : function (__150, _Formal, _CommaFormal, __151, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_150,Formal,CommaFormal,_151
let _150 = undefined;
let Formal = undefined;
let CommaFormal = undefined;
let _151 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "LambdaFormals_withformals");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_150 = __150.rwr ()
Formal = _Formal.rwr ()
CommaFormal = _CommaFormal.rwr ().join ('')
_151 = __151.rwr ()

_150 = __150.rwr ()
Formal = _Formal.rwr ()
CommaFormal = _CommaFormal.rwr ().join ('')
_151 = __151.rwr ()

_.set_top (return_value_stack, `(${Formal}${CommaFormal})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Formal : function (_ident, __152, _Exp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=ident,_152,Exp
let ident = undefined;
let _152 = undefined;
let Exp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Formal");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

ident = _ident.rwr ()
_152 = __152.rwr ()
Exp = _Exp.rwr ().join ('')

ident = _ident.rwr ()
_152 = __152.rwr ()
Exp = _Exp.rwr ().join ('')

_.set_top (return_value_stack, `${ident}${_152}${Exp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaFormal : function (__153, _Formal, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_153,Formal
let _153 = undefined;
let Formal = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaFormal");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_153 = __153.rwr ()
Formal = _Formal.rwr ()

_153 = __153.rwr ()
Formal = _Formal.rwr ()

_.set_top (return_value_stack, ` ${Formal}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Actuals_noactuals : function (__154, __155, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_154,_155
let _154 = undefined;
let _155 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Actuals_noactuals");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_154 = __154.rwr ()
_155 = __155.rwr ()

_154 = __154.rwr ()
_155 = __155.rwr ()

_.set_top (return_value_stack, ``);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Actuals_actuals : function (__156, _Actual, _CommaActual, __157, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_156,Actual,CommaActual,_157
let _156 = undefined;
let Actual = undefined;
let CommaActual = undefined;
let _157 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Actuals_actuals");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_156 = __156.rwr ()
Actual = _Actual.rwr ()
CommaActual = _CommaActual.rwr ().join ('')
_157 = __157.rwr ()

_156 = __156.rwr ()
Actual = _Actual.rwr ()
CommaActual = _CommaActual.rwr ().join ('')
_157 = __157.rwr ()

_.set_top (return_value_stack, `${Actual}${CommaActual}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Actual : function (_ParamName, _Exp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=ParamName,Exp
let ParamName = undefined;
let Exp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Actual");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

ParamName = _ParamName.rwr ().join ('')
Exp = _Exp.rwr ()

ParamName = _ParamName.rwr ().join ('')
Exp = _Exp.rwr ()

_.set_top (return_value_stack, ` ${ParamName}${Exp}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaActual : function (__158, _Actual, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_158,Actual
let _158 = undefined;
let Actual = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaActual");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_158 = __158.rwr ()
Actual = _Actual.rwr ()

_158 = __158.rwr ()
Actual = _Actual.rwr ()

_.set_top (return_value_stack, ` ${Actual}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ParamName : function (_ident, __159, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=ident,_159
let ident = undefined;
let _159 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ParamName");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

ident = _ident.rwr ()
_159 = __159.rwr ()

ident = _ident.rwr ()
_159 = __159.rwr ()

_.set_top (return_value_stack, ``);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
number_fract : function (_num, __160, _den, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=num,_160,den
let num = undefined;
let _160 = undefined;
let den = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "number_fract");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

num = _num.rwr ().join ('')
_160 = __160.rwr ()
den = _den.rwr ().join ('')

num = _num.rwr ().join ('')
_160 = __160.rwr ()
den = _den.rwr ().join ('')

_.set_top (return_value_stack, `${num}.${den}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
number_whole : function (_digit, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=digit
let digit = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "number_whole");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

digit = _digit.rwr ().join ('')

digit = _digit.rwr ().join ('')

_.set_top (return_value_stack, `${digit}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Pair : function (_string, __161, _Exp, __162, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=string,_161,Exp,_162
let string = undefined;
let _161 = undefined;
let Exp = undefined;
let _162 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Pair");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

string = _string.rwr ()
_161 = __161.rwr ()
Exp = _Exp.rwr ()
_162 = __162.rwr ().join ('')

string = _string.rwr ()
_161 = __161.rwr ()
Exp = _Exp.rwr ()
_162 = __162.rwr ().join ('')

_.set_top (return_value_stack, `(${string} . ${Exp})`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
boolOp : function (__191, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_191
let _191 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "boolOp");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_191 = __191.rwr ()

_191 = __191.rwr ()

_.set_top (return_value_stack, ` ${_191} `);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
phi : function (__192, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_192
let _192 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "phi");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_192 = __192.rwr ()

_192 = __192.rwr ()

_.set_top (return_value_stack, ` nil`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
string_fdqstring : function (__193, _notdq, __194, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_193,notdq,_194
let _193 = undefined;
let notdq = undefined;
let _194 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "string_fdqstring");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_193 = __193.rwr ()
notdq = _notdq.rwr ().join ('')
_194 = __194.rwr ()

_193 = __193.rwr ()
notdq = _notdq.rwr ().join ('')
_194 = __194.rwr ()

_.set_top (return_value_stack, `${_193}${notdq}${_194}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
string_fsqstring : function (__195, _notsq, __196, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_195,notsq,_196
let _195 = undefined;
let notsq = undefined;
let _196 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "string_fsqstring");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_195 = __195.rwr ()
notsq = _notsq.rwr ().join ('')
_196 = __196.rwr ()

_195 = __195.rwr ()
notsq = _notsq.rwr ().join ('')
_196 = __196.rwr ()

_.set_top (return_value_stack, `${_195}${notsq}${_196}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
string_dqstring : function (__197, _notdq, __198, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_197,notdq,_198
let _197 = undefined;
let notdq = undefined;
let _198 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "string_dqstring");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_197 = __197.rwr ()
notdq = _notdq.rwr ().join ('')
_198 = __198.rwr ()

_197 = __197.rwr ()
notdq = _notdq.rwr ().join ('')
_198 = __198.rwr ()

_.set_top (return_value_stack, `${_197}${notdq}${_198}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
string_sqstring : function (__199, _notsq, __200, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_199,notsq,_200
let _199 = undefined;
let notsq = undefined;
let _200 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "string_sqstring");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_199 = __199.rwr ()
notsq = _notsq.rwr ().join ('')
_200 = __200.rwr ()

_199 = __199.rwr ()
notsq = _notsq.rwr ().join ('')
_200 = __200.rwr ()

_.set_top (return_value_stack, `${_199}${notsq}${_200}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
notdq : function (_any, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=any
let any = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "notdq");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

any = _any.rwr ()

any = _any.rwr ()

_.set_top (return_value_stack, `${any}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
notsq : function (_any, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=any
let any = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "notsq");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

any = _any.rwr ()

any = _any.rwr ()

_.set_top (return_value_stack, `${any}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
comment : function (__203, _notnl, _nl, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_203,notnl,nl
let _203 = undefined;
let notnl = undefined;
let nl = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "comment");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_203 = __203.rwr ()
notnl = _notnl.rwr ().join ('')
nl = _nl.rwr ()

_203 = __203.rwr ()
notnl = _notnl.rwr ().join ('')
nl = _nl.rwr ()

_.set_top (return_value_stack, `; ${notnl}${nl}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
nl : function (__204, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_204
let _204 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "nl");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

_204 = __204.rwr ()

_204 = __204.rwr ()

_.set_top (return_value_stack, `${_204}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
notnl : function (_any, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=any
let any = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "notnl");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

any = _any.rwr ()

any = _any.rwr ()

_.set_top (return_value_stack, `${any}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
space : function (_comment, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=comment
let comment = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "space");
DummyName1_stack.push (DummyName1_stack [DummyName1_stack.length-1]);
DummyName2_stack.push (DummyName2_stack [DummyName2_stack.length-1]);
FunctionName_stack.push (FunctionName_stack [FunctionName_stack.length-1]);

comment = _comment.rwr ()

comment = _comment.rwr ()

_.set_top (return_value_stack, `${comment}`);

DummyName1_stack.pop ();
DummyName2_stack.pop ();
FunctionName_stack.pop ();

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

