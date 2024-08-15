
'use strict'

import {_} from './support.mjs';
import * as ohm from 'ohm-js';

let return_value_stack = [];
let rule_name_stack = [];


const grammar = String.raw`
rt {

  Main = TopLevel+
  TopLevel =
    | Defvar -- defvar
    | Defn -- defn
    | Defclass -- defclass
    | Import -- import

   kw<s> = s ~identTail

   Defvar = kw<"defvar"> Lval "=" Exp
   Defn = kw<"defn"> ident Formals StatementBlock
   Defclass = kw<"defclass"> ident "{" Definit "}"
   Import = kw<"import"> ident

   StatementBlock = "{" Rec_Statement "}"

   Definit = kw<"definit"> "(" kw<"self"> ":" ident CommaFormal* ")" "{" InitStatement+ "}"

   Rec_Statement =
     | kw<"global"> ident CommaIdent* Rec_Statement? -- globals
     | IfStatement Rec_Statement? -- if
     | kw<"pass"> Rec_Statement? -- pass
     | kw<"return"> ReturnExp Rec_Statement? -- return
     | ForStatement Rec_Statement? -- for
     | WhileStatement Rec_Statement? -- while
     | TryStatement Rec_Statement? -- try
     | Assignment Rec_Statement? -- assignment
     | Lval Rec_Statement? -- call
   CommaIdent = "," ident

   InitStatement = kw<"self"> "." ident "=" Exp

   IfStatement = kw<"if"> Exp StatementBlock ElifStatement* ElseStatement?
   ElifStatement = kw<"elif"> Exp StatementBlock
   ElseStatement = kw<"else"> StatementBlock

   ForStatement = kw<"for"> ident kw<"in"> Exp StatementBlock
   WhileStatement = kw<"while"> Exp StatementBlock

   TryStatement = kw<"try"> StatementBlock ExceptBlock+
   ExceptBlock =
     | kw<"except"> Exp kw<"as"> ident StatementBlock -- as
     | kw<"except"> ident StatementBlock -- basic
   
   Assignment = 
     | Lval "+=" Exp -- pluseq
     | "[" Lval CommaLval+ "]" "=" Exp -- multiple
     | Lval "=" Exp -- single

   CommaLval = "," Lval

    ReturnExp =
      | "[" Exp CommaExp+ "]" -- multiple
      | Exp -- single

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
      | "(" Exp ")"  -- paren
      | "[" "]" -- emptylistconst
      | "[" PrimaryComma+ "]" -- listconst
      | "{" "}" -- emptydict
      | "{" PairComma+ "}" -- dict
      | "λ" LambdaFormals? ":" Exp -- lambda
      | kw<"fresh"> "(" ident ")" -- fresh
      | kw<"car"> "(" Exp ")" -- car
      | kw<"cdr"> "(" Exp ")" -- cdr
      | "+" Primary   -- pos
      | "-" Primary   -- neg
      | phi -- phi
      | "⊤" -- true
      | "⊥" -- false
      | kw<"range"> "(" Exp ")" -- range
      | string -- string
      | number -- number
      | ident PrimaryTail -- identwithtail
      | ident -- ident


  PrimaryTail =
    | "@" ident PrimaryTail? -- dictlookup
    | MethodCall PrimaryTail? -- methodcall
    | OffsetRef PrimaryTail? -- offsetref
    | FieldLookup PrimaryTail? -- lookup
    | Slice PrimaryTail? -- slice

  FieldLookup =
    | "[" Exp "]" -- lookup

  Slice =
    | "[" ":" "]" -- slicewhole
    | "[" digit+ ":" "]" -- nthslice


    PrimaryComma = Primary ","?
    PairComma = Pair ","?
    
    Lval = Exp PrimaryTail?





    keyword = (
        kw<"fresh">
      | kw<"defvar">
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

  MethodCall = Actuals
  
  OffsetRef = "." ident


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
Main : function (TopLevel, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Main");

TopLevel = TopLevel.rwr ().join ('')

_.set_top (return_value_stack, `${TopLevel}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_defvar : function (Defvar, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_defvar");

Defvar = Defvar.rwr ()

_.set_top (return_value_stack, `${Defvar}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_defn : function (Defn, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_defn");

Defn = Defn.rwr ()

_.set_top (return_value_stack, `${Defn}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_defclass : function (Defclass, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_defclass");

Defclass = Defclass.rwr ()

_.set_top (return_value_stack, `${Defclass}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
TopLevel_import : function (Import, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TopLevel_import");

Import = Import.rwr ()

_.set_top (return_value_stack, `${Import}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
kw : function (s, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "kw");

s = s.rwr ()

_.set_top (return_value_stack, `${s}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Defvar : function (__, lval, _eq, e, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defvar");

__ = __.rwr ()
lval = lval.rwr ()
_eq = _eq.rwr ()
e = e.rwr ()

_.set_top (return_value_stack, `\n${lval} = ${e}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Defn : function (_4, ident, Formals, StatementBlock, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defn");

_4 = _4.rwr ()
ident = ident.rwr ()
Formals = Formals.rwr ()
StatementBlock = StatementBlock.rwr ()

_.set_top (return_value_stack, `\ndef ${ident} ${Formals}:${StatementBlock}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Defclass : function (_6, ident, _7, Definit, _8, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Defclass");

_6 = _6.rwr ()
ident = ident.rwr ()
_7 = _7.rwr ()
Definit = Definit.rwr ()
_8 = _8.rwr ()

_.set_top (return_value_stack, `\nclass ${ident}:⤷\n${Definit}⤶\n`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Import : function (_10, ident, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Import");

_10 = _10.rwr ()
ident = ident.rwr ()

_.set_top (return_value_stack, `\nimport ${ident}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
StatementBlock : function (_11, Statement, _12, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "StatementBlock");

_11 = _11.rwr ()
Statement = Statement.rwr ()
_12 = _12.rwr ()

_.set_top (return_value_stack, `⤷${Statement}⤶\n`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Definit : function (_14, _15, _17, _18, ident, formals, _20, _21, InitStatement, _22, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Definit");

_14 = _14.rwr ()
_15 = _15.rwr ()
_17 = _17.rwr ()
_18 = _18.rwr ()
ident = ident.rwr ()
formals = formals.rwr ().join ('')
_20 = _20.rwr ()
_21 = _21.rwr ()
InitStatement = InitStatement.rwr ().join ('')
_22 = _22.rwr ()

_.set_top (return_value_stack, `def __init__ (self${formals}):⤷\n${InitStatement}⤶\n`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_globals : function (_24, ident1, cidents, scope, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_globals");

_24 = _24.rwr ()
ident1 = ident1.rwr ()
cidents = cidents.rwr ().join ('')
scope = scope.rwr ().join ('')

_.set_top (return_value_stack, `\nglobal ${ident1}${cidents}${scope}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaIdent : function (_comma, ident, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaIdent");

_comma = _comma.rwr ()
ident = ident.rwr ()

_.set_top (return_value_stack, `, ${ident}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_if : function (IfStatement, scope, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_if");

IfStatement = IfStatement.rwr ()
scope = scope.rwr ().join ('')

_.set_top (return_value_stack, `${IfStatement}${scope}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_pass : function (_27, scope, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_pass");

_27 = _27.rwr ()
scope = scope.rwr ().join ('')

_.set_top (return_value_stack, `\npass${scope}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_return : function (_29, ReturnExp, scope, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_return");

_29 = _29.rwr ()
ReturnExp = ReturnExp.rwr ()
scope = scope.rwr ().join ('')

_.set_top (return_value_stack, `\nreturn ${ReturnExp}${scope}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_for : function (ForStatement, scope, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_for");

ForStatement = ForStatement.rwr ()
scope = scope.rwr ().join ('')

_.set_top (return_value_stack, `${ForStatement}${scope}${scope}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_while : function (WhileStatement, scope, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_while");

WhileStatement = WhileStatement.rwr ()
scope = scope.rwr ().join ('')

_.set_top (return_value_stack, `${WhileStatement}${scope}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_try : function (TryStatement, scope, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_try");

TryStatement = TryStatement.rwr ()
scope = scope.rwr ().join ('')

_.set_top (return_value_stack, `${TryStatement}${scope}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_assignment : function (Assignment, scope, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_assignment");

Assignment = Assignment.rwr ()
scope = scope.rwr ().join ('')

_.set_top (return_value_stack, `${Assignment}${scope}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Rec_Statement_call : function (Lval, scope, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Rec_Statement_call");

Lval = Lval.rwr ()
scope = scope.rwr ().join ('')

_.set_top (return_value_stack, `\n${Lval}${scope}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
InitStatement : function (_31, _32, ident, _33, Exp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "InitStatement");

_31 = _31.rwr ()
_32 = _32.rwr ()
ident = ident.rwr ()
_33 = _33.rwr ()
Exp = Exp.rwr ()

_.set_top (return_value_stack, `\nself.${ident} = ${Exp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
IfStatement : function (_35, Exp, StatementBlock, ElifStatement, ElseStatement, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "IfStatement");

_35 = _35.rwr ()
Exp = Exp.rwr ()
StatementBlock = StatementBlock.rwr ()
ElifStatement = ElifStatement.rwr ().join ('')
ElseStatement = ElseStatement.rwr ().join ('')

_.set_top (return_value_stack, `\nif ${Exp}:${StatementBlock}${ElifStatement}${ElseStatement}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ElifStatement : function (_37, Exp, StatementBlock, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ElifStatement");

_37 = _37.rwr ()
Exp = Exp.rwr ()
StatementBlock = StatementBlock.rwr ()

_.set_top (return_value_stack, `elif ${Exp}:${StatementBlock}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ElseStatement : function (_39, StatementBlock, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ElseStatement");

_39 = _39.rwr ()
StatementBlock = StatementBlock.rwr ()

_.set_top (return_value_stack, `else:${StatementBlock}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ForStatement : function (_41, ident, _43, Exp, StatementBlock, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ForStatement");

_41 = _41.rwr ()
ident = ident.rwr ()
_43 = _43.rwr ()
Exp = Exp.rwr ()
StatementBlock = StatementBlock.rwr ()

_.set_top (return_value_stack, `\nfor ${ident} in ${Exp}:${StatementBlock}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
WhileStatement : function (_45, Exp, StatementBlock, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "WhileStatement");

_45 = _45.rwr ()
Exp = Exp.rwr ()
StatementBlock = StatementBlock.rwr ()

_.set_top (return_value_stack, `\nwhile ${Exp}:${StatementBlock}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
TryStatement : function (_47, StatementBlock, ExceptBlock, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "TryStatement");

_47 = _47.rwr ()
StatementBlock = StatementBlock.rwr ()
ExceptBlock = ExceptBlock.rwr ().join ('')

_.set_top (return_value_stack, `\ntry:\n${StatementBlock}${ExceptBlock}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ExceptBlock_as : function (_49, Exp, _51, ident, StatementBlock, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ExceptBlock_as");

_49 = _49.rwr ()
Exp = Exp.rwr ()
_51 = _51.rwr ()
ident = ident.rwr ()
StatementBlock = StatementBlock.rwr ()

_.set_top (return_value_stack, `except ${Exp} as ${ident}:${StatementBlock}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ExceptBlock_basic : function (_53, ident, StatementBlock, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ExceptBlock_basic");

_53 = _53.rwr ()
ident = ident.rwr ()
StatementBlock = StatementBlock.rwr ()

_.set_top (return_value_stack, `except ${ident}:${StatementBlock}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Assignment_pluseq : function (Lval, _54, Exp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Assignment_pluseq");

Lval = Lval.rwr ()
_54 = _54.rwr ()
Exp = Exp.rwr ()

_.set_top (return_value_stack, `\n${Lval} += ${Exp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Assignment_multiple : function (_55, Lval1, Lval2, _57, _58, Exp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Assignment_multiple");

_55 = _55.rwr ()
Lval1 = Lval1.rwr ()
Lval2 = Lval2.rwr ().join ('')
_57 = _57.rwr ()
_58 = _58.rwr ()
Exp = Exp.rwr ()

_.set_top (return_value_stack, `\n[${Lval1}${Lval2}] = ${Exp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Assignment_single : function (Lval, _59, Exp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Assignment_single");

Lval = Lval.rwr ()
_59 = _59.rwr ()
Exp = Exp.rwr ()

_.set_top (return_value_stack, `\n${Lval} = ${Exp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaLval : function (_comma, Lval, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaLval");

_comma = _comma.rwr ()
Lval = Lval.rwr ()

_.set_top (return_value_stack, `, ${Lval}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ReturnExp_multiple : function (_60, Exp1, Exp2, _62, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ReturnExp_multiple");

_60 = _60.rwr ()
Exp1 = Exp1.rwr ()
Exp2 = Exp2.rwr ().join ('')
_62 = _62.rwr ()

_.set_top (return_value_stack, `[${Exp1}${Exp2}]`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ReturnExp_single : function (Exp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ReturnExp_single");

Exp = Exp.rwr ()

_.set_top (return_value_stack, `${Exp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaExp : function (_comma, e, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaExp");

_comma = _comma.rwr ()
e = e.rwr ()

_.set_top (return_value_stack, `, ${e}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Exp : function (BooleanExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Exp");

BooleanExp = BooleanExp.rwr ()

_.set_top (return_value_stack, `${BooleanExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
BooleanExp_boolop : function (BooleanExp, boolOp, BooleanNot, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "BooleanExp_boolop");

BooleanExp = BooleanExp.rwr ()
boolOp = boolOp.rwr ()
BooleanNot = BooleanNot.rwr ()

_.set_top (return_value_stack, `${BooleanExp}${boolOp}${BooleanNot}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
BooleanExp_basic : function (BooleanNot, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "BooleanExp_basic");

BooleanNot = BooleanNot.rwr ()

_.set_top (return_value_stack, `${BooleanNot}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
BooleanNot_not : function (_64, BooleanExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "BooleanNot_not");

_64 = _64.rwr ()
BooleanExp = BooleanExp.rwr ()

_.set_top (return_value_stack, `not ${BooleanExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
BooleanNot_basic : function (AddExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "BooleanNot_basic");

AddExp = AddExp.rwr ()

_.set_top (return_value_stack, `${AddExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
AddExp_plus : function (AddExp, _65, MulExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "AddExp_plus");

AddExp = AddExp.rwr ()
_65 = _65.rwr ()
MulExp = MulExp.rwr ()

_.set_top (return_value_stack, `${AddExp}${_65}${MulExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
AddExp_minus : function (AddExp, _66, MulExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "AddExp_minus");

AddExp = AddExp.rwr ()
_66 = _66.rwr ()
MulExp = MulExp.rwr ()

_.set_top (return_value_stack, `${AddExp}${_66}${MulExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
AddExp_basic : function (MulExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "AddExp_basic");

MulExp = MulExp.rwr ()

_.set_top (return_value_stack, `${MulExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
MulExp_times : function (MulExp, _67, ExpExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "MulExp_times");

MulExp = MulExp.rwr ()
_67 = _67.rwr ()
ExpExp = ExpExp.rwr ()

_.set_top (return_value_stack, `${MulExp}${_67}${ExpExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
MulExp_divide : function (MulExp, _68, ExpExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "MulExp_divide");

MulExp = MulExp.rwr ()
_68 = _68.rwr ()
ExpExp = ExpExp.rwr ()

_.set_top (return_value_stack, `${MulExp}${_68}${ExpExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
MulExp_basic : function (ExpExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "MulExp_basic");

ExpExp = ExpExp.rwr ()

_.set_top (return_value_stack, `${ExpExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ExpExp_power : function (Primary, _69, ExpExp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ExpExp_power");

Primary = Primary.rwr ()
_69 = _69.rwr ()
ExpExp = ExpExp.rwr ()

_.set_top (return_value_stack, `${Primary}${_69}${ExpExp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ExpExp_basic : function (Primary, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ExpExp_basic");

Primary = Primary.rwr ()

_.set_top (return_value_stack, `${Primary}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_paren : function (_70, Exp, _71, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_paren");

_70 = _70.rwr ()
Exp = Exp.rwr ()
_71 = _71.rwr ()

_.set_top (return_value_stack, `${_70}${Exp}${_71}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_emptylistconst : function (_72, _73, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_emptylistconst");

_72 = _72.rwr ()
_73 = _73.rwr ()

_.set_top (return_value_stack, `${_72}${_73}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_listconst : function (_74, PrimaryComma, _75, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_listconst");

_74 = _74.rwr ()
PrimaryComma = PrimaryComma.rwr ().join ('')
_75 = _75.rwr ()

_.set_top (return_value_stack, `${_74}${PrimaryComma}${_75}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_emptydict : function (_76, _77, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_emptydict");

_76 = _76.rwr ()
_77 = _77.rwr ()

_.set_top (return_value_stack, `${_76}${_77}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_dict : function (_78, PairComma, _79, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_dict");

_78 = _78.rwr ()
PairComma = PairComma.rwr ().join ('')
_79 = _79.rwr ()

_.set_top (return_value_stack, `${_78}${PairComma}${_79}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_lambda : function (_80, Formals, _81, Exp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_lambda");

_80 = _80.rwr ()
Formals = Formals.rwr ().join ('')
_81 = _81.rwr ()
Exp = Exp.rwr ()

_.set_top (return_value_stack, ` lambda ${Formals}: ${Exp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_fresh : function (_83, _84, ident, _85, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_fresh");

_83 = _83.rwr ()
_84 = _84.rwr ()
ident = ident.rwr ()
_85 = _85.rwr ()

_.set_top (return_value_stack, ` ${ident} ()`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_car : function (_83, _84, e, _85, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_car");

_83 = _83.rwr ()
_84 = _84.rwr ()
e = e.rwr ()
_85 = _85.rwr ()

_.set_top (return_value_stack, ` ${e}[0] `);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_cdr : function (_83, _84, e, _85, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_cdr");

_83 = _83.rwr ()
_84 = _84.rwr ()
e = e.rwr ()
_85 = _85.rwr ()

_.set_top (return_value_stack, ` ${e}[1:] `);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_pos : function (_86, Primary, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_pos");

_86 = _86.rwr ()
Primary = Primary.rwr ()

_.set_top (return_value_stack, ` +${Primary}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_neg : function (_87, Primary, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_neg");

_87 = _87.rwr ()
Primary = Primary.rwr ()

_.set_top (return_value_stack, ` -${Primary}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_phi : function (phi, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_phi");

phi = phi.rwr ()

_.set_top (return_value_stack, ` None`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_true : function (_88, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_true");

_88 = _88.rwr ()

_.set_top (return_value_stack, ` True`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_false : function (_89, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_false");

_89 = _89.rwr ()

_.set_top (return_value_stack, ` False`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_range : function (_91, _92, Exp, _93, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_range");

_91 = _91.rwr ()
_92 = _92.rwr ()
Exp = Exp.rwr ()
_93 = _93.rwr ()

_.set_top (return_value_stack, `${_91}${_92}${Exp}${_93}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_string : function (string, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_string");

string = string.rwr ()

_.set_top (return_value_stack, `${string}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_number : function (number, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_number");

number = number.rwr ()

_.set_top (return_value_stack, `${number}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_identwithtail : function (ident, PrimaryTail, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_identwithtail");

ident = ident.rwr ()
PrimaryTail = PrimaryTail.rwr ()

_.set_top (return_value_stack, `${ident}${PrimaryTail}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Primary_ident : function (ident, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Primary_ident");

ident = ident.rwr ()

_.set_top (return_value_stack, `${ident}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
PrimaryComma : function (Primary, _94, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "PrimaryComma");

Primary = Primary.rwr ()
_94 = _94.rwr ().join ('')

_.set_top (return_value_stack, `${Primary}${_94}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
PairComma : function (Pair, _95, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "PairComma");

Pair = Pair.rwr ()
_95 = _95.rwr ().join ('')

_.set_top (return_value_stack, `${Pair}${_95}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Lval : function (Exp, PrimaryTail, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Lval");

Exp = Exp.rwr ()
PrimaryTail = PrimaryTail.rwr ().join ('')

_.set_top (return_value_stack, `${Exp}${PrimaryTail}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
keyword : function (_144, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "keyword");

_144 = _144.rwr ()

_.set_top (return_value_stack, `${_144}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ident : function (identHead, identTail, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ident");

identHead = identHead.rwr ()
identTail = identTail.rwr ().join ('')

_.set_top (return_value_stack, `${identHead}${identTail}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
identHead : function (_146, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "identHead");

_146 = _146.rwr ()

_.set_top (return_value_stack, `${_146}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
identTail : function (_147, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "identTail");

_147 = _147.rwr ()

_.set_top (return_value_stack, `${_147}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Formals_noformals : function (_148, _149, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Formals_noformals");

_148 = _148.rwr ()
_149 = _149.rwr ()

_.set_top (return_value_stack, `${_148}${_149}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Formals_withformals : function (_150, Formal, CommaFormal, _151, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Formals_withformals");

_150 = _150.rwr ()
Formal = Formal.rwr ()
CommaFormal = CommaFormal.rwr ().join ('')
_151 = _151.rwr ()

_.set_top (return_value_stack, `${_150}${Formal}${CommaFormal}${_151}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
LambdaFormals_noformals : function (_148, _149, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "LambdaFormals_noformals");

_148 = _148.rwr ()
_149 = _149.rwr ()

_.set_top (return_value_stack, ``);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
LambdaFormals_withformals : function (_150, Formal, CommaFormal, _151, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "LambdaFormals_withformals");

_150 = _150.rwr ()
Formal = Formal.rwr ()
CommaFormal = CommaFormal.rwr ().join ('')
_151 = _151.rwr ()

_.set_top (return_value_stack, `${Formal}${CommaFormal}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Formal : function (ident, _152, Exp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Formal");

ident = ident.rwr ()
_152 = _152.rwr ()
Exp = Exp.rwr ().join ('')

_.set_top (return_value_stack, `${ident}${_152}${Exp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaFormal : function (_153, Formal, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaFormal");

_153 = _153.rwr ()
Formal = Formal.rwr ()

_.set_top (return_value_stack, `${_153}${Formal}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Actuals_noactuals : function (_154, _155, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Actuals_noactuals");

_154 = _154.rwr ()
_155 = _155.rwr ()

_.set_top (return_value_stack, `${_154}${_155}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Actuals_actuals : function (_156, Actual, CommaActual, _157, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Actuals_actuals");

_156 = _156.rwr ()
Actual = Actual.rwr ()
CommaActual = CommaActual.rwr ().join ('')
_157 = _157.rwr ()

_.set_top (return_value_stack, `${_156}${Actual}${CommaActual}${_157}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Actual : function (ParamName, Exp, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Actual");

ParamName = ParamName.rwr ().join ('')
Exp = Exp.rwr ()

_.set_top (return_value_stack, `${ParamName}${Exp}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
CommaActual : function (_158, Actual, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "CommaActual");

_158 = _158.rwr ()
Actual = Actual.rwr ()

_.set_top (return_value_stack, `${_158}${Actual}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
ParamName : function (ident, _159, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "ParamName");

ident = ident.rwr ()
_159 = _159.rwr ()

_.set_top (return_value_stack, `${ident}${_159}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
number_fract : function (num, _160, den, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "number_fract");

num = num.rwr ().join ('')
_160 = _160.rwr ()
den = den.rwr ().join ('')

_.set_top (return_value_stack, `${num}${_160}${den}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
number_whole : function (digit, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "number_whole");

digit = digit.rwr ().join ('')

_.set_top (return_value_stack, `${digit}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Pair : function (string, _161, Exp, _162, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Pair");

string = string.rwr ()
_161 = _161.rwr ()
Exp = Exp.rwr ()
_162 = _162.rwr ().join ('')

_.set_top (return_value_stack, `${string}${_161}${Exp}${_162}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
PrimaryTail_dictlookup : function (_eyes, key, PrimaryTail, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "PrimaryTail_dictlookup");

_eyes = _eyes.rwr ()
key = key.rwr ()
PrimaryTail = PrimaryTail.rwr ().join ('')

_.set_top (return_value_stack, `["${key}"]${PrimaryTail}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
PrimaryTail_methodcall : function (MethodCall, PrimaryTail, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "PrimaryTail_methodcall");

MethodCall = MethodCall.rwr ()
PrimaryTail = PrimaryTail.rwr ().join ('')

_.set_top (return_value_stack, `${MethodCall}${PrimaryTail}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
PrimaryTail_offsetref : function (OffsetRef, PrimaryTail, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "PrimaryTail_offsetref");

OffsetRef = OffsetRef.rwr ()
PrimaryTail = PrimaryTail.rwr ().join ('')

_.set_top (return_value_stack, `${OffsetRef}${PrimaryTail}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
PrimaryTail_lookup : function (FieldLookup, PrimaryTail, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "PrimaryTail_lookup");

FieldLookup = FieldLookup.rwr ()
PrimaryTail = PrimaryTail.rwr ().join ('')

_.set_top (return_value_stack, `${FieldLookup}${PrimaryTail}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
PrimaryTail_slice : function (Slice, PrimaryTail, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "PrimaryTail_slice");

Slice = Slice.rwr ()
PrimaryTail = PrimaryTail.rwr ().join ('')

_.set_top (return_value_stack, `${Slice}${PrimaryTail}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
MethodCall : function (Actuals, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "MethodCall");

Actuals = Actuals.rwr ()

_.set_top (return_value_stack, `${Actuals}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
OffsetRef : function (_163, ident, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "OffsetRef");

_163 = _163.rwr ()
ident = ident.rwr ()

_.set_top (return_value_stack, `${_163}${ident}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
FieldLookup_lookup : function (_167, Exp, _168, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "FieldLookup_lookup");

_167 = _167.rwr ()
Exp = Exp.rwr ()
_168 = _168.rwr ()

_.set_top (return_value_stack, `${_167}${Exp}${_168}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Slice_slicewhole : function (_169, _170, _171, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Slice_slicewhole");

_169 = _169.rwr ()
_170 = _170.rwr ()
_171 = _171.rwr ()

_.set_top (return_value_stack, `${_169}${_170}${_171}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
Slice_nthslice : function (_176, digit, _177, _178, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "Slice_nthslice");

_176 = _176.rwr ()
digit = digit.rwr ().join ('')
_177 = _177.rwr ()
_178 = _178.rwr ()

_.set_top (return_value_stack, `${_176}${digit}${_177}${_178}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
boolOp : function (_191, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "boolOp");

_191 = _191.rwr ()

_.set_top (return_value_stack, ` ${_191} `);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
phi : function (_192, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "phi");

_192 = _192.rwr ()

_.set_top (return_value_stack, ` None`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
string_fdqstring : function (_193, notdq, _194, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "string_fdqstring");

_193 = _193.rwr ()
notdq = notdq.rwr ().join ('')
_194 = _194.rwr ()

_.set_top (return_value_stack, `${_193}${notdq}${_194}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
string_fsqstring : function (_195, notsq, _196, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "string_fsqstring");

_195 = _195.rwr ()
notsq = notsq.rwr ().join ('')
_196 = _196.rwr ()

_.set_top (return_value_stack, `${_195}${notsq}${_196}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
string_dqstring : function (_197, notdq, _198, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "string_dqstring");

_197 = _197.rwr ()
notdq = notdq.rwr ().join ('')
_198 = _198.rwr ()

_.set_top (return_value_stack, `${_197}${notdq}${_198}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
string_sqstring : function (_199, notsq, _200, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "string_sqstring");

_199 = _199.rwr ()
notsq = notsq.rwr ().join ('')
_200 = _200.rwr ()

_.set_top (return_value_stack, `${_199}${notsq}${_200}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
notdq : function (any, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "notdq");

any = any.rwr ()

_.set_top (return_value_stack, `${any}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
notsq : function (any, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "notsq");

any = any.rwr ()

_.set_top (return_value_stack, `${any}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
comment : function (_203, notnl, nl, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "comment");

_203 = _203.rwr ()
notnl = notnl.rwr ().join ('')
nl = nl.rwr ()

_.set_top (return_value_stack, `${_203}${notnl}${nl}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
nl : function (_204, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "nl");

_204 = _204.rwr ()

_.set_top (return_value_stack, `${_204}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
notnl : function (any, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "notnl");

any = any.rwr ()

_.set_top (return_value_stack, `${any}`);


rule_name_stack.pop ();
return return_value_stack.pop ();
},
space : function (comment, ) {
return_value_stack.push ("");
rule_name_stack.push ("");
_.set_top (rule_name_stack, "space");

comment = comment.rwr ()

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
	return parser.trace (src).toString ();
    }
}

import * as fs from 'fs';
let src = fs.readFileSync(0, 'utf-8');
var result = main (src);
console.log (result);

