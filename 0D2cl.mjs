
'use strict'

import {_} from './support.mjs';
import * as ohm from 'ohm-js';

let return_value_stack = [];
let rule_name_stack = [];

let FunctionName_stack = [];

const grammar = String.raw`
rt {
 

  Main = TopLevel+
  TopLevel =
    | Defvar -- defvar
    | Defconst -- defconst
    | Defn -- defn
    | Defobj -- defobj
    | Import -- import

   kw<s> = s ~identTail

   Defvar = kw<"defvar"> Lval "⇐" Exp
   Defconst = kw<"defconst"> Lval "≡" Exp
   Defn = kw<"defn"> ident Formals StatementBlock
   Defobj = kw<"defobj"> ident ObjFormals "{" InitStatement+ "}"
   Import = kw<"import"> ident

   StatementBlock = "{" Rec_Statement "}"

   Rec_Statement =
     | Deftemp -- deftemp
     | Defsynonym -- defsynonym     
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

   Deftemp = kw<"deftemp"> Lval "⇐" Exp Rec_Statement?
   Defsynonym = Lval "≡" Exp Rec_Statement?

   InitStatement = "•" ident "⇐" Exp

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
     | "[" Lval CommaLval+ "]" "⇐" Exp Rec_Statement? -- multiple
     | Lval "⇐" Exp Rec_Statement? -- single

   CommaLval = "," Lval

    ReturnExp =
      | "[" Exp CommaExp+ "]" Rec_Statement? -- multiple
      | Exp Rec_Statement? -- single

    CommaExp = "," Exp
    
    Exp =  BooleanExp

    BooleanExp =
      | BooleanExp boolNeq BooleanNot -- boolopneq
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
      | Primary "." ident -- field
      | Primary "[" Exp "]" -- index
      | Primary "[" digit+ ":" "]" -- nthslice
      | ident Actuals -- identcall
      | Primary Actuals -- call
      | Atom -- atom

    Atom =
      | "[" "]" -- emptylistconst
      | "{" "}" -- emptydict
      | "(" Exp ")" -- paren
      | "[" PrimaryComma+ "]" -- listconst
      | "{" PairComma+ "}" -- dict
      | "λ" LambdaFormals? ":" Exp -- lambda
      | kw<"fresh"> "(" ident ")" -- fresh
      | kw<"car"> "(" Exp ")" -- car
      | kw<"cdr"> "(" Exp ")" -- cdr
      | kw<"argvcdr"> "(" digit ")" -- nthargvcdr
      | kw<"nthargv"> "(" digit ")" -- nthargv
      | kw<"stringcdr"> "(" Exp ")" -- stringcdr
      | kw<"strcons"> "(" Exp "," Exp ")" -- strcons
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
      | kw<"defconst">
      | kw<"deftemp">
      | kw<"defobj">
      | kw<"defvar">
      | kw<"defn">
      | "•"
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
      | kw<"strcons">
      )
      
    ident  = ~keyword identHead identTail*

    identHead = ( "_" | letter )
    identTail = ( alnum | identHead )

    Formals =
      | "(" ")" -- noformals
      | "(" Formal CommaFormal* ")" -- withformals
    ObjFormals =
      | "(" ")" -- noformals
      | "(" Formal CommaFormal* ")" -- withformals
    LambdaFormals =
      | "(" ")" -- noformals
      | "(" Formal CommaFormal* ")" -- withformals

    Formal = 
       | ident "∷" Exp -- defaultvalue
       | ident -- plain
       
    CommaFormal = "," Formal
    
    Actuals = 
      | "(" ")" -- noactuals
      | "(" Actual CommaActual* ")" -- actuals

   Actual = ParamName? Exp
   CommaActual = "," Actual

   ParamName = ident "∷"

    number =
      | digit* "." digit+  -- fract
      | digit+             -- whole

    Pair = string ":" Exp ","?
  

  boolOp = (boolEq | boolNeq | "<=" | ">=" | ">" | "<" | kw<"and"> | kw<"or"> | kw<"in">)
  boolEq = "="
  boolNeq = "!="

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
TopLevel = _TopLevel.rwr ().join ('')

_.set_top (return_value_stack, `${TopLevel}`);

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
Defvar = _Defvar.rwr ()

_.set_top (return_value_stack, `${Defvar}`);

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
Defconst = _Defconst.rwr ()

_.set_top (return_value_stack, `${Defconst}`);

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
Defn = _Defn.rwr ()

_.set_top (return_value_stack, `${Defn}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_defobj : function (_Defclass, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=Defclass
let Defclass = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_defobj");
Defclass = _Defclass.rwr ()

_.set_top (return_value_stack, `${Defclass}`);

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
Import = _Import.rwr ()

_.set_top (return_value_stack, `${Import}`);

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
s = _s.rwr ()

_.set_top (return_value_stack, `${s}`);

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
__ = ___.rwr ()
lval = _lval.rwr ()
_eq = __eq.rwr ()
e = _e.rwr ()

_.set_top (return_value_stack, `\n(defparameter ${lval} ${e})`);

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
__ = ___.rwr ()
lval = _lval.rwr ()
_eq = __eq.rwr ()
e = _e.rwr ()

_.set_top (return_value_stack, `\n(defconstant ${lval} ${e})`);

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

FunctionName_stack.pop ();

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Defobj : function (__defobj, _ident, _Formals, _lb, _init, _rb, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_defobj,ident,Formals,lb,init,rb
let _defobj = undefined;
let ident = undefined;
let Formals = undefined;
let lb = undefined;
let init = undefined;
let rb = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defobj");
_defobj = __defobj.rwr ()
ident = _ident.rwr ()
Formals = _Formals.rwr ()
lb = _lb.rwr ()
init = _init.rwr ().join ('')
rb = _rb.rwr ()

_.set_top (return_value_stack, `\n(defun new-${ident} ${Formals}⤷\n(list⤷${init}⤶)⤶)\n`);

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
_10 = __10.rwr ()
ident = _ident.rwr ()

_.set_top (return_value_stack, `\nimport ${ident}`);

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
_11 = __11.rwr ()
Statement = _Statement.rwr ()
_12 = __12.rwr ()

_.set_top (return_value_stack, `⤷\n(progn⤷${Statement})⤶⤶`);

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
_24 = __24.rwr ()
ident1 = _ident1.rwr ()
cidents = _cidents.rwr ().join ('')
scope = _scope.rwr ().join ('')

_.set_top (return_value_stack, `\nglobal ${ident1}${cidents}${scope}`);

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
_comma = __comma.rwr ()
ident = _ident.rwr ()

_.set_top (return_value_stack, `, ${ident}`);

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
IfStatement = _IfStatement.rwr ()

_.set_top (return_value_stack, `${IfStatement}`);

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
_27 = __27.rwr ()
scope = _scope.rwr ().join ('')

_.set_top (return_value_stack, `\npass${scope}`);

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
_29 = __29.rwr ()
ReturnExp = _ReturnExp.rwr ()

_.set_top (return_value_stack, `\n${ReturnExp}`);

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
ForStatement = _ForStatement.rwr ()

_.set_top (return_value_stack, `${ForStatement}`);

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
WhileStatement = _WhileStatement.rwr ()

_.set_top (return_value_stack, `${WhileStatement}`);

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
TryStatement = _TryStatement.rwr ()

_.set_top (return_value_stack, `${TryStatement}`);

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
Assignment = _Assignment.rwr ()

_.set_top (return_value_stack, `${Assignment}`);

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
Lval = _Lval.rwr ()
scope = _scope.rwr ().join ('')

_.set_top (return_value_stack, `\n${Lval}${scope}`);

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
_24 = __24.rwr ()
ident1 = _ident1.rwr ()
cidents = _cidents.rwr ().join ('')
scope = _scope.rwr ().join ('')

_.set_top (return_value_stack, `${scope}`);

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
_comma = __comma.rwr ()
ident = _ident.rwr ()

_.set_top (return_value_stack, ` ${ident}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Deftemp : function (__deftemp, _lval, __mutate, _e, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_deftemp,lval,_mutate,e,rec
let _deftemp = undefined;
let lval = undefined;
let _mutate = undefined;
let e = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Deftemp");
_deftemp = __deftemp.rwr ()
lval = _lval.rwr ()
_mutate = __mutate.rwr ()
e = _e.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(setf ${lval} ${e})${rec})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Defsynonym : function (_lval, __eqv, _e, _rec, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=lval,_eqv,e,rec
let lval = undefined;
let _eqv = undefined;
let e = undefined;
let rec = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defsynonym");
lval = _lval.rwr ()
_eqv = __eqv.rwr ()
e = _e.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(let ((${lval} ${e}))${rec})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
InitStatement : function (__mark, _ident, __33, _Exp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_mark,ident,_33,Exp
let _mark = undefined;
let ident = undefined;
let _33 = undefined;
let Exp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "InitStatement");
_mark = __mark.rwr ()
ident = _ident.rwr ()
_33 = __33.rwr ()
Exp = _Exp.rwr ()

_.set_top (return_value_stack, `\n(cons '${ident} ${Exp})`);

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
_35 = __35.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()
ElifStatement = _ElifStatement.rwr ().join ('')
ElseStatement = _ElseStatement.rwr ().join ('')
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(cond ⤷\n(${Exp} ${StatementBlock})${ElifStatement}${ElseStatement}⤶)${rec}`);

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
_37 = __37.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (return_value_stack, `\n(${Exp} ${StatementBlock})`);

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
_39 = __39.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (return_value_stack, `\n(t ${StatementBlock})`);

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
_41 = __41.rwr ()
ident = _ident.rwr ()
_43 = __43.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\nfor ${ident} in ${Exp}:${StatementBlock}${rec}`);

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
_45 = __45.rwr ()
Exp = _Exp.rwr ()
StatementBlock = _StatementBlock.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\nwhile ${Exp}:${StatementBlock}${rec}`);

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
_47 = __47.rwr ()
StatementBlock = _StatementBlock.rwr ()
ExceptBlock = _ExceptBlock.rwr ().join ('')
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\ntry:\n${StatementBlock}${ExceptBlock}${rec}`);

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
_49 = __49.rwr ()
Exp = _Exp.rwr ()
_51 = __51.rwr ()
ident = _ident.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (return_value_stack, `except ${Exp} as ${ident}:${StatementBlock}`);

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
_53 = __53.rwr ()
ident = _ident.rwr ()
StatementBlock = _StatementBlock.rwr ()

_.set_top (return_value_stack, `except ${ident}:${StatementBlock}`);

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
_55 = __55.rwr ()
Lval1 = _Lval1.rwr ()
Lval2 = _Lval2.rwr ().join ('')
_57 = __57.rwr ()
_58 = __58.rwr ()
Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(multiple-value-bind (${Lval1} ${Lval2})⤷⤷\n${Exp}⤶${rec}⤶)`);

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
Lval = _Lval.rwr ()
_59 = __59.rwr ()
Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(setf ${Lval} ${Exp})${rec})`);

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
_comma = __comma.rwr ()
Lval = _Lval.rwr ()

_.set_top (return_value_stack, `, ${Lval}`);

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
_60 = __60.rwr ()
Exp1 = _Exp1.rwr ()
Exp2 = _Exp2.rwr ().join ('')
_62 = __62.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(return-from ${_.top (FunctionName_stack)} (values ${Exp1} ${Exp2}))${rec}`);

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
Exp = _Exp.rwr ()
rec = _rec.rwr ().join ('')

_.set_top (return_value_stack, `\n(return-from ${_.top (FunctionName_stack)} ${Exp})${rec}`);

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
_comma = __comma.rwr ()
e = _e.rwr ()

_.set_top (return_value_stack, ` ${e}`);

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
BooleanExp = _BooleanExp.rwr ()

_.set_top (return_value_stack, `${BooleanExp}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
BooleanExp_boolopneq : function (_BooleanExp, _boolOp, _BooleanNot, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=BooleanExp,boolOp,BooleanNot
let BooleanExp = undefined;
let boolOp = undefined;
let BooleanNot = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "BooleanExp_boolopneq");
BooleanExp = _BooleanExp.rwr ()
boolOp = _boolOp.rwr ()
BooleanNot = _BooleanNot.rwr ()

_.set_top (return_value_stack, `(not (equal ${BooleanExp} ${BooleanNot}))`);

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
BooleanExp = _BooleanExp.rwr ()
boolOp = _boolOp.rwr ()
BooleanNot = _BooleanNot.rwr ()

_.set_top (return_value_stack, `(${boolOp} ${BooleanExp} ${BooleanNot})`);

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
BooleanNot = _BooleanNot.rwr ()

_.set_top (return_value_stack, `${BooleanNot}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
boolEq : function (__eq, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_eq
let _eq = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "boolEq");
_eq = __eq.rwr ()

_.set_top (return_value_stack, `equal`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
boolNeq : function (__neq, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_neq
let _neq = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "boolNeq");
_neq = __neq.rwr ()

_.set_top (return_value_stack, `nequal`);

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
_64 = __64.rwr ()
BooleanExp = _BooleanExp.rwr ()

_.set_top (return_value_stack, `(not ${BooleanExp})`);

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
AddExp = _AddExp.rwr ()

_.set_top (return_value_stack, `${AddExp}`);

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
AddExp = _AddExp.rwr ()
_65 = __65.rwr ()
MulExp = _MulExp.rwr ()

_.set_top (return_value_stack, `(+ ${AddExp} ${MulExp})`);

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
AddExp = _AddExp.rwr ()
_66 = __66.rwr ()
MulExp = _MulExp.rwr ()

_.set_top (return_value_stack, `(- ${AddExp} ${MulExp})`);

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
MulExp = _MulExp.rwr ()

_.set_top (return_value_stack, `${MulExp}`);

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
MulExp = _MulExp.rwr ()
_67 = __67.rwr ()
ExpExp = _ExpExp.rwr ()

_.set_top (return_value_stack, `(* ${MulExp} ${ExpExp})`);

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
MulExp = _MulExp.rwr ()
_68 = __68.rwr ()
ExpExp = _ExpExp.rwr ()

_.set_top (return_value_stack, `(/ ${MulExp} ${ExpExp})`);

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
ExpExp = _ExpExp.rwr ()

_.set_top (return_value_stack, `${ExpExp}`);

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
Primary = _Primary.rwr ()
_69 = __69.rwr ()
ExpExp = _ExpExp.rwr ()

_.set_top (return_value_stack, `(expt ${Primary} ${ExpExp})`);

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
Primary = _Primary.rwr ()

_.set_top (return_value_stack, `${Primary}`);

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
p = _p.rwr ()
_at = __at.rwr ()
key = _key.rwr ()

_.set_top (return_value_stack, `(gethash '${key} ${p})`);

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
p = _p.rwr ()
_at = __at.rwr ()
key = _key.rwr ()

_.set_top (return_value_stack, `(gethash ${key} ${p})`);

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
p = _p.rwr ()
_dot = __dot.rwr ()
key = _key.rwr ()

_.set_top (return_value_stack, `(cdr (assoc '${key} ${p}))`);

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
p = _p.rwr ()
lb = _lb.rwr ()
e = _e.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `(aref ${p} ${e})`);

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
p = _p.rwr ()
lb = _lb.rwr ()
ds = _ds.rwr ().join ('')
_colon = __colon.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `(nthcdr ${ds} ${p})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_identcall : function (_id, _actuals, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=id,actuals
let id = undefined;
let actuals = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_identcall");
id = _id.rwr ()
actuals = _actuals.rwr ()

_.set_top (return_value_stack, `(${id} ${actuals})`);

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
p = _p.rwr ()
actuals = _actuals.rwr ()

_.set_top (return_value_stack, `(funcall ${p} ${actuals})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_emptylistconst : function (__72, __73, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_72,_73
let _72 = undefined;
let _73 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_emptylistconst");
_72 = __72.rwr ()
_73 = __73.rwr ()

_.set_top (return_value_stack, ` nil`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_emptydict : function (__76, __77, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_76,_77
let _76 = undefined;
let _77 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_emptydict");
_76 = __76.rwr ()
_77 = __77.rwr ()

_.set_top (return_value_stack, `(make-hash-table :test :equal)`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_paren : function (__70, _Exp, __71, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_70,Exp,_71
let _70 = undefined;
let Exp = undefined;
let _71 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_paren");
_70 = __70.rwr ()
Exp = _Exp.rwr ()
_71 = __71.rwr ()

_.set_top (return_value_stack, ` ${Exp}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_listconst : function (__74, _PrimaryComma, __75, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_74,PrimaryComma,_75
let _74 = undefined;
let PrimaryComma = undefined;
let _75 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_listconst");
_74 = __74.rwr ()
PrimaryComma = _PrimaryComma.rwr ().join ('')
_75 = __75.rwr ()

_.set_top (return_value_stack, `(list ${PrimaryComma})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_dict : function (__78, _PairComma, __79, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_78,PairComma,_79
let _78 = undefined;
let PairComma = undefined;
let _79 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_dict");
_78 = __78.rwr ()
PairComma = _PairComma.rwr ().join ('')
_79 = __79.rwr ()

_.set_top (return_value_stack, `(fresh-hash (list ${PairComma}))`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_lambda : function (__80, _Formals, __81, _Exp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_80,Formals,_81,Exp
let _80 = undefined;
let Formals = undefined;
let _81 = undefined;
let Exp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_lambda");
_80 = __80.rwr ()
Formals = _Formals.rwr ().join ('')
_81 = __81.rwr ()
Exp = _Exp.rwr ()

_.set_top (return_value_stack, `#'(lambda ${Formals} ${Exp})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_fresh : function (__83, __84, _ident, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,ident,_85
let _83 = undefined;
let _84 = undefined;
let ident = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_fresh");
_83 = __83.rwr ()
_84 = __84.rwr ()
ident = _ident.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(fresh-${ident})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_car : function (__83, __84, _e, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,e,_85
let _83 = undefined;
let _84 = undefined;
let e = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_car");
_83 = __83.rwr ()
_84 = __84.rwr ()
e = _e.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(car ${e})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_cdr : function (__83, __84, _e, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,e,_85
let _83 = undefined;
let _84 = undefined;
let e = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_cdr");
_83 = __83.rwr ()
_84 = __84.rwr ()
e = _e.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(cdr ${e})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_nthargvcdr : function (__83, _lb, _n, _rb, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,lb,n,rb
let _83 = undefined;
let lb = undefined;
let n = undefined;
let rb = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_nthargvcdr");
_83 = __83.rwr ()
lb = _lb.rwr ()
n = _n.rwr ()
rb = _rb.rwr ()

_.set_top (return_value_stack, `(nthcdr *argv* ${n})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_nthargv : function (__83, __84, _n, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,n,_85
let _83 = undefined;
let _84 = undefined;
let n = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_nthargv");
_83 = __83.rwr ()
_84 = __84.rwr ()
n = _n.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(nth *argv* ${n})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_stringcdr : function (__83, __84, _e, __85, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_83,_84,e,_85
let _83 = undefined;
let _84 = undefined;
let e = undefined;
let _85 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_stringcdr");
_83 = __83.rwr ()
_84 = __84.rwr ()
e = _e.rwr ()
_85 = __85.rwr ()

_.set_top (return_value_stack, `(subseq ${e} 1)`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_strcons : function (__strcons, _lp, _e1, __comma, _e2, _rp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_strcons,lp,e1,_comma,e2,rp
let _strcons = undefined;
let lp = undefined;
let e1 = undefined;
let _comma = undefined;
let e2 = undefined;
let rp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_strcons");
_strcons = __strcons.rwr ()
lp = _lp.rwr ()
e1 = _e1.rwr ()
_comma = __comma.rwr ()
e2 = _e2.rwr ()
rp = _rp.rwr ()

_.set_top (return_value_stack, `(concatenate 'string (format nil "~a" ${e1}) ${e2})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_pos : function (__86, _Primary, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_86,Primary
let _86 = undefined;
let Primary = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_pos");
_86 = __86.rwr ()
Primary = _Primary.rwr ()

_.set_top (return_value_stack, `(+ ${Primary} 0)`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_neg : function (__87, _Primary, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_87,Primary
let _87 = undefined;
let Primary = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_neg");
_87 = __87.rwr ()
Primary = _Primary.rwr ()

_.set_top (return_value_stack, `(- 0 ${Primary})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_phi : function (_phi, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=phi
let phi = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_phi");
phi = _phi.rwr ()

_.set_top (return_value_stack, ` nil`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_true : function (__88, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_88
let _88 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_true");
_88 = __88.rwr ()

_.set_top (return_value_stack, ` t`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_false : function (__89, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_89
let _89 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_false");
_89 = __89.rwr ()

_.set_top (return_value_stack, ` nil`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_range : function (__91, __92, _Exp, __93, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_91,_92,Exp,_93
let _91 = undefined;
let _92 = undefined;
let Exp = undefined;
let _93 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_range");
_91 = __91.rwr ()
_92 = __92.rwr ()
Exp = _Exp.rwr ()
_93 = __93.rwr ()

_.set_top (return_value_stack, `(loop for n from 0 below ${Exp} by 1 collect n)`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_string : function (_string, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=string
let string = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_string");
string = _string.rwr ()

_.set_top (return_value_stack, `${string}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_number : function (_number, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=number
let number = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_number");
number = _number.rwr ()

_.set_top (return_value_stack, `${number}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Atom_ident : function (_ident, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=ident
let ident = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Atom_ident");
ident = _ident.rwr ()

_.set_top (return_value_stack, `${ident}`);

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
Primary = _Primary.rwr ()
_94 = __94.rwr ().join ('')

_.set_top (return_value_stack, ` ${Primary}`);

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
Pair = _Pair.rwr ()
_95 = __95.rwr ().join ('')

_.set_top (return_value_stack, ` ${Pair}`);

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
Exp = _Exp.rwr ()

_.set_top (return_value_stack, `${Exp}`);

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
_144 = __144.rwr ()

_.set_top (return_value_stack, `${_144}`);

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
identHead = _identHead.rwr ()
identTail = _identTail.rwr ().join ('')

_.set_top (return_value_stack, `${identHead}${identTail}`);

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
_146 = __146.rwr ()

_.set_top (return_value_stack, `${_146}`);

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
_147 = __147.rwr ()

_.set_top (return_value_stack, `${_147}`);

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
_148 = __148.rwr ()
_149 = __149.rwr ()

_.set_top (return_value_stack, `()`);

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
_150 = __150.rwr ()
Formal = _Formal.rwr ()
CommaFormal = _CommaFormal.rwr ().join ('')
_151 = __151.rwr ()

_.set_top (return_value_stack, `(${Formal}${CommaFormal})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ObjFormals_noformals : function (__148, __149, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_148,_149
let _148 = undefined;
let _149 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ObjFormals_noformals");
_148 = __148.rwr ()
_149 = __149.rwr ()

_.set_top (return_value_stack, `()`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
ObjFormals_withformals : function (__150, _Formal, _CommaFormal, __151, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=_150,Formal,CommaFormal,_151
let _150 = undefined;
let Formal = undefined;
let CommaFormal = undefined;
let _151 = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ObjFormals_withformals");
_150 = __150.rwr ()
Formal = _Formal.rwr ()
CommaFormal = _CommaFormal.rwr ().join ('')
_151 = __151.rwr ()

_.set_top (return_value_stack, `(${Formal}${CommaFormal})`);

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
_148 = __148.rwr ()
_149 = __149.rwr ()

_.set_top (return_value_stack, `()`);

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
_150 = __150.rwr ()
Formal = _Formal.rwr ()
CommaFormal = _CommaFormal.rwr ().join ('')
_151 = __151.rwr ()

_.set_top (return_value_stack, `(${Formal}${CommaFormal})`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Formal_defaultvalue : function (_ident, __152, _Exp, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=ident,_152,Exp
let ident = undefined;
let _152 = undefined;
let Exp = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Formal_defaultvalue");
ident = _ident.rwr ()
_152 = __152.rwr ()
Exp = _Exp.rwr ()

_.set_top (return_value_stack, `:${ident} ${Exp}`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
Formal_plain : function (_ident, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=ident
let ident = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Formal_plain");
ident = _ident.rwr ()

_.set_top (return_value_stack, `${ident}`);

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
_153 = __153.rwr ()
Formal = _Formal.rwr ()

_.set_top (return_value_stack, ` ${Formal}`);

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
_154 = __154.rwr ()
_155 = __155.rwr ()

_.set_top (return_value_stack, ``);

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
_156 = __156.rwr ()
Actual = _Actual.rwr ()
CommaActual = _CommaActual.rwr ().join ('')
_157 = __157.rwr ()

_.set_top (return_value_stack, `${Actual}${CommaActual}`);

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
ParamName = _ParamName.rwr ().join ('')
Exp = _Exp.rwr ()

_.set_top (return_value_stack, ` ${ParamName}${Exp}`);

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
_158 = __158.rwr ()
Actual = _Actual.rwr ()

_.set_top (return_value_stack, ` ${Actual}`);

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
ident = _ident.rwr ()
_159 = __159.rwr ()

_.set_top (return_value_stack, ``);

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
num = _num.rwr ().join ('')
_160 = __160.rwr ()
den = _den.rwr ().join ('')

_.set_top (return_value_stack, `${num}.${den}`);

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
digit = _digit.rwr ().join ('')

_.set_top (return_value_stack, `${digit}`);

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
string = _string.rwr ()
_161 = __161.rwr ()
Exp = _Exp.rwr ()
_162 = __162.rwr ().join ('')

_.set_top (return_value_stack, `(${string} . ${Exp})`);

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
_191 = __191.rwr ()

_.set_top (return_value_stack, ` ${_191} `);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
boolEq : function (_op, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=op
let op = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "boolEq");
op = _op.rwr ()

_.set_top (return_value_stack, `equal`);

rule_name_stack.pop ();
return return_value_stack.pop ();
},
boolNeq : function (_op, ) {
//** foreach_arg (let ☐ = undefined;)
//** argnames=op
let op = undefined;
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "boolNeq");
op = _op.rwr ()

_.set_top (return_value_stack, `!equal`);

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
_192 = __192.rwr ()

_.set_top (return_value_stack, ` nil`);

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
_193 = __193.rwr ()
notdq = _notdq.rwr ().join ('')
_194 = __194.rwr ()

_.set_top (return_value_stack, `${_193}${notdq}${_194}`);

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
_195 = __195.rwr ()
notsq = _notsq.rwr ().join ('')
_196 = __196.rwr ()

_.set_top (return_value_stack, `${_195}${notsq}${_196}`);

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
_197 = __197.rwr ()
notdq = _notdq.rwr ().join ('')
_198 = __198.rwr ()

_.set_top (return_value_stack, `${_197}${notdq}${_198}`);

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
_199 = __199.rwr ()
notsq = _notsq.rwr ().join ('')
_200 = __200.rwr ()

_.set_top (return_value_stack, `${_199}${notsq}${_200}`);

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
any = _any.rwr ()

_.set_top (return_value_stack, `${any}`);

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
any = _any.rwr ()

_.set_top (return_value_stack, `${any}`);

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
_203 = __203.rwr ()
notnl = _notnl.rwr ().join ('')
nl = _nl.rwr ()

_.set_top (return_value_stack, `; ${notnl}${nl}`);

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
_204 = __204.rwr ()

_.set_top (return_value_stack, `${_204}`);

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
any = _any.rwr ()

_.set_top (return_value_stack, `${any}`);

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
comment = _comment.rwr ()

_.set_top (return_value_stack, `${comment}`);

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
        return cst.message;	
    }
}

import * as fs from 'fs';
let src = fs.readFileSync(0, 'utf-8');
var result = main (src);
console.log (result);

