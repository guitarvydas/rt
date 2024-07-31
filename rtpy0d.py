--- !!! ERRORS !!! ---
while loading operation rwr: (_ = {
    fname_stack : [],
    fname : function () { return _.fname_stack [0]; },
    push_fname : function (s) { _.fname_stack.push (s); },
    pop_fname : function () { _.fname_stack.pop (); return ""; }
}
,
{
Main: function (TopLevel) {
_ruleEnter ("Main");
TopLevel = TopLevel.rwr ().join ('');

_ruleExit ("Main");
return `${TopLevel}`;
},
TopLevel_defvar: function (Defvar) {
_ruleEnter ("TopLevel_defvar");
Defvar = Defvar.rwr ();

_ruleExit ("TopLevel_defvar");
return `${Defvar}`;
},
TopLevel_defn: function (Defn) {
_ruleEnter ("TopLevel_defn");
Defn = Defn.rwr ();

_ruleExit ("TopLevel_defn");
return `${Defn}`;
},
TopLevel_defclass: function (Defclass) {
_ruleEnter ("TopLevel_defclass");
Defclass = Defclass.rwr ();

_ruleExit ("TopLevel_defclass");
return `${Defclass}`;
},
TopLevel_import: function (Import) {
_ruleEnter ("TopLevel_import");
Import = Import.rwr ();

_ruleExit ("TopLevel_import");
return `${Import}`;
},
kw: function (s) {
_ruleEnter ("kw");
s = s.rwr ();

_ruleExit ("kw");
return `${s}`;
},
Defvar: function (_,lval,_eq,e) {
_ruleEnter ("Defvar");
_ = _.rwr ();
lval = lval.rwr ();
_eq = _eq.rwr ();
e = e.rwr ();

_ruleExit ("Defvar");
return `
(defparameter ${lval} ${e})`;
},
Defn: function (_4,ident,Formals,StatementBlock) {
_ruleEnter ("Defn");
var _0 = `${_.push_fname (ident.rwr ())}`;

_4 = _4.rwr ();
ident = ident.rwr ();
Formals = Formals.rwr ();
StatementBlock = StatementBlock.rwr ();

_ruleExit ("Defn");
return `
(defun ${ident} ${Formals} ${StatementBlock})${_.pop_fname ()}`;
},
Defclass: function (_6,ident,_7,Definit,_8) {
_ruleEnter ("Defclass");
_6 = _6.rwr ();
ident = ident.rwr ();
_7 = _7.rwr ();
Definit = Definit.rwr ();
_8 = _8.rwr ();

_ruleExit ("Defclass");
return `
class ${ident}:⤷
${Definit}⤶
`;
},
Import: function (_10,ident) {
_ruleEnter ("Import");
_10 = _10.rwr ();
ident = ident.rwr ();

_ruleExit ("Import");
return `
import ${ident}`;
},
StatementBlock: function (_11,Statement,_12) {
_ruleEnter ("StatementBlock");
_11 = _11.rwr ();
Statement = Statement.rwr ();
_12 = _12.rwr ();

_ruleExit ("StatementBlock");
return `⤷${Statement}⤶
`;
},
Rec_Statement: function (stmt,rec) {
_ruleEnter ("Rec_Statement");
stmt = stmt.rwr ();
rec = rec.rwr ().join ('');

_ruleExit ("Rec_Statement");
return `${stmt}${rec}`;
},
Definit: function (_14,_15,_17,_18,ident,formals,_20,_21,InitStatement,_22) {
_ruleEnter ("Definit");
_14 = _14.rwr ();
_15 = _15.rwr ();
_17 = _17.rwr ();
_18 = _18.rwr ();
ident = ident.rwr ();
formals = formals.rwr ().join ('');
_20 = _20.rwr ();
_21 = _21.rwr ();
InitStatement = InitStatement.rwr ().join ('');
_22 = _22.rwr ();

_ruleExit ("Definit");
return `def __init__ (self${formals}):⤷
${InitStatement}⤶
`;
},
Statement_globals: function (_24,ident1,cidents) {
_ruleEnter ("Statement_globals");
_24 = _24.rwr ();
ident1 = ident1.rwr ();
cidents = cidents.rwr ().join ('');

_ruleExit ("Statement_globals");
return ``;
},
CommaIdent: function (_comma,ident) {
_ruleEnter ("CommaIdent");
_comma = _comma.rwr ();
ident = ident.rwr ();

_ruleExit ("CommaIdent");
return ` ${ident}`;
},
Statement_if: function (IfStatement) {
_ruleEnter ("Statement_if");
IfStatement = IfStatement.rwr ();

_ruleExit ("Statement_if");
return `${IfStatement}`;
},
Statement_pass: function (_27) {
_ruleEnter ("Statement_pass");
_27 = _27.rwr ();

_ruleExit ("Statement_pass");
return `
pass`;
},
Statement_return: function (_29,ReturnExp) {
_ruleEnter ("Statement_return");
_29 = _29.rwr ();
ReturnExp = ReturnExp.rwr ();

_ruleExit ("Statement_return");
return `
${ReturnExp}`;
},
Statement_for: function (ForStatement) {
_ruleEnter ("Statement_for");
ForStatement = ForStatement.rwr ();

_ruleExit ("Statement_for");
return `${ForStatement}`;
},
Statement_while: function (WhileStatement) {
_ruleEnter ("Statement_while");
WhileStatement = WhileStatement.rwr ();

_ruleExit ("Statement_while");
return `${WhileStatement}`;
},
Statement_try: function (TryStatement) {
_ruleEnter ("Statement_try");
TryStatement = TryStatement.rwr ();

_ruleExit ("Statement_try");
return `${TryStatement}`;
},
Statement_assignment: function (Assignment) {
_ruleEnter ("Statement_assignment");
Assignment = Assignment.rwr ();

_ruleExit ("Statement_assignment");
return `${Assignment}`;
},
Statement_call: function (Lval) {
_ruleEnter ("Statement_call");
Lval = Lval.rwr ();

_ruleExit ("Statement_call");
return `
${Lval}`;
},
InitStatement: function (_31,_32,ident,_33,Exp) {
_ruleEnter ("InitStatement");
_31 = _31.rwr ();
_32 = _32.rwr ();
ident = ident.rwr ();
_33 = _33.rwr ();
Exp = Exp.rwr ();

_ruleExit ("InitStatement");
return `
self.${ident} = ${Exp}`;
},
IfStatement: function (_35,Exp,StatementBlock,ElifStatement,ElseStatement) {
_ruleEnter ("IfStatement");
_35 = _35.rwr ();
Exp = Exp.rwr ();
StatementBlock = StatementBlock.rwr ();
ElifStatement = ElifStatement.rwr ().join ('');
ElseStatement = ElseStatement.rwr ().join ('');

_ruleExit ("IfStatement");
return `
if ${Exp}:${StatementBlock}${ElifStatement}${ElseStatement}`;
},
ElifStatement: function (_37,Exp,StatementBlock) {
_ruleEnter ("ElifStatement");
_37 = _37.rwr ();
Exp = Exp.rwr ();
StatementBlock = StatementBlock.rwr ();

_ruleExit ("ElifStatement");
return `elif ${Exp}:${StatementBlock}`;
},
ElseStatement: function (_39,StatementBlock) {
_ruleEnter ("ElseStatement");
_39 = _39.rwr ();
StatementBlock = StatementBlock.rwr ();

_ruleExit ("ElseStatement");
return `else:${StatementBlock}`;
},
ForStatement: function (_41,ident,_43,Exp,StatementBlock) {
_ruleEnter ("ForStatement");
_41 = _41.rwr ();
ident = ident.rwr ();
_43 = _43.rwr ();
Exp = Exp.rwr ();
StatementBlock = StatementBlock.rwr ();

_ruleExit ("ForStatement");
return `
for ${ident} in ${Exp}:${StatementBlock}`;
},
WhileStatement: function (_45,Exp,StatementBlock) {
_ruleEnter ("WhileStatement");
_45 = _45.rwr ();
Exp = Exp.rwr ();
StatementBlock = StatementBlock.rwr ();

_ruleExit ("WhileStatement");
return `
while ${Exp}:${StatementBlock}`;
},
TryStatement: function (_47,StatementBlock,ExceptBlock) {
_ruleEnter ("TryStatement");
_47 = _47.rwr ();
StatementBlock = StatementBlock.rwr ();
ExceptBlock = ExceptBlock.rwr ().join ('');

_ruleExit ("TryStatement");
return `
try:
${StatementBlock}${ExceptBlock}`;
},
ExceptBlock_as: function (_49,Exp,_51,ident,StatementBlock) {
_ruleEnter ("ExceptBlock_as");
_49 = _49.rwr ();
Exp = Exp.rwr ();
_51 = _51.rwr ();
ident = ident.rwr ();
StatementBlock = StatementBlock.rwr ();

_ruleExit ("ExceptBlock_as");
return `except ${Exp} as ${ident}:${StatementBlock}`;
},
ExceptBlock_basic: function (_53,ident,StatementBlock) {
_ruleEnter ("ExceptBlock_basic");
_53 = _53.rwr ();
ident = ident.rwr ();
StatementBlock = StatementBlock.rwr ();

_ruleExit ("ExceptBlock_basic");
return `except ${ident}:${StatementBlock}`;
},
Assignment_pluseq: function (Lval,_54,Exp) {
_ruleEnter ("Assignment_pluseq");
Lval = Lval.rwr ();
_54 = _54.rwr ();
Exp = Exp.rwr ();

_ruleExit ("Assignment_pluseq");
return `
(incf ${Lval} ${Exp})`;
},
Assignment_multiple: function (_55,Lval1,Lval2,_57,_58,Exp) {
_ruleEnter ("Assignment_multiple");
_55 = _55.rwr ();
Lval1 = Lval1.rwr ();
Lval2 = Lval2.rwr ().join ('');
_57 = _57.rwr ();
_58 = _58.rwr ();
Exp = Exp.rwr ();

_ruleExit ("Assignment_multiple");
return `
[${Lval1}${Lval2}] = ${Exp}`;
},
Assignment_single: function (Lval,_59,Exp) {
_ruleEnter ("Assignment_single");
Lval = Lval.rwr ();
_59 = _59.rwr ();
Exp = Exp.rwr ();

_ruleExit ("Assignment_single");
return `
(setf ${Lval} ${Exp})`;
},
CommaLval: function (_comma,Lval) {
_ruleEnter ("CommaLval");
_comma = _comma.rwr ();
Lval = Lval.rwr ();

_ruleExit ("CommaLval");
return `, ${Lval}`;
},
ReturnExp_multiple: function (_60,Exp1,Exp2,_62) {
_ruleEnter ("ReturnExp_multiple");
_60 = _60.rwr ();
Exp1 = Exp1.rwr ();
Exp2 = Exp2.rwr ().join ('');
_62 = _62.rwr ();

_ruleExit ("ReturnExp_multiple");
return `[${Exp1}${Exp2}]`;
},
ReturnExp_single: function (Exp) {
_ruleEnter ("ReturnExp_single");
Exp = Exp.rwr ();

_ruleExit ("ReturnExp_single");
return `(return-from ${_.fname ()} ${Exp})`;
},
CommaExp: function (_comma,e) {
_ruleEnter ("CommaExp");
_comma = _comma.rwr ();
e = e.rwr ();

_ruleExit ("CommaExp");
return `, ${e}`;
},
Exp: function (BooleanExp) {
_ruleEnter ("Exp");
BooleanExp = BooleanExp.rwr ();

_ruleExit ("Exp");
return `${BooleanExp}`;
},
BooleanExp_boolop: function (BooleanExp,boolOp,BooleanNot) {
_ruleEnter ("BooleanExp_boolop");
BooleanExp = BooleanExp.rwr ();
boolOp = boolOp.rwr ();
BooleanNot = BooleanNot.rwr ();

_ruleExit ("BooleanExp_boolop");
return `${BooleanExp}${boolOp}${BooleanNot}`;
},
BooleanExp_basic: function (BooleanNot) {
_ruleEnter ("BooleanExp_basic");
BooleanNot = BooleanNot.rwr ();

_ruleExit ("BooleanExp_basic");
return `${BooleanNot}`;
},
BooleanNot_not: function (_64,BooleanExp) {
_ruleEnter ("BooleanNot_not");
_64 = _64.rwr ();
BooleanExp = BooleanExp.rwr ();

_ruleExit ("BooleanNot_not");
return `not ${BooleanExp}`;
},
BooleanNot_basic: function (AddExp) {
_ruleEnter ("BooleanNot_basic");
AddExp = AddExp.rwr ();

_ruleExit ("BooleanNot_basic");
return `${AddExp}`;
},
AddExp_plus: function (AddExp,_65,MulExp) {
_ruleEnter ("AddExp_plus");
AddExp = AddExp.rwr ();
_65 = _65.rwr ();
MulExp = MulExp.rwr ();

_ruleExit ("AddExp_plus");
return `${AddExp}${_65}${MulExp}`;
},
AddExp_minus: function (AddExp,_66,MulExp) {
_ruleEnter ("AddExp_minus");
AddExp = AddExp.rwr ();
_66 = _66.rwr ();
MulExp = MulExp.rwr ();

_ruleExit ("AddExp_minus");
return `${AddExp}${_66}${MulExp}`;
},
AddExp_basic: function (MulExp) {
_ruleEnter ("AddExp_basic");
MulExp = MulExp.rwr ();

_ruleExit ("AddExp_basic");
return `${MulExp}`;
},
MulExp_times: function (MulExp,_67,ExpExp) {
_ruleEnter ("MulExp_times");
MulExp = MulExp.rwr ();
_67 = _67.rwr ();
ExpExp = ExpExp.rwr ();

_ruleExit ("MulExp_times");
return `${MulExp}${_67}${ExpExp}`;
},
MulExp_divide: function (MulExp,_68,ExpExp) {
_ruleEnter ("MulExp_divide");
MulExp = MulExp.rwr ();
_68 = _68.rwr ();
ExpExp = ExpExp.rwr ();

_ruleExit ("MulExp_divide");
return `${MulExp}${_68}${ExpExp}`;
},
MulExp_basic: function (ExpExp) {
_ruleEnter ("MulExp_basic");
ExpExp = ExpExp.rwr ();

_ruleExit ("MulExp_basic");
return `${ExpExp}`;
},
ExpExp_power: function (PriExp,_69,ExpExp) {
_ruleEnter ("ExpExp_power");
PriExp = PriExp.rwr ();
_69 = _69.rwr ();
ExpExp = ExpExp.rwr ();

_ruleExit ("ExpExp_power");
return `${PriExp}${_69}${ExpExp}`;
},
ExpExp_basic: function (PriExp) {
_ruleEnter ("ExpExp_basic");
PriExp = PriExp.rwr ();

_ruleExit ("ExpExp_basic");
return `${PriExp}`;
},
PriExp_paren: function (_70,Exp,_71) {
_ruleEnter ("PriExp_paren");
_70 = _70.rwr ();
Exp = Exp.rwr ();
_71 = _71.rwr ();

_ruleExit ("PriExp_paren");
return `${_70}${Exp}${_71}`;
},
PriExp_emptylistconst: function (_72,_73) {
_ruleEnter ("PriExp_emptylistconst");
_72 = _72.rwr ();
_73 = _73.rwr ();

_ruleExit ("PriExp_emptylistconst");
return ` nil`;
},
PriExp_listconst: function (_74,PriExpComma,_75) {
_ruleEnter ("PriExp_listconst");
_74 = _74.rwr ();
PriExpComma = PriExpComma.rwr ().join ('');
_75 = _75.rwr ();

_ruleExit ("PriExp_listconst");
return `'(${PriExpComma} )`;
},
PriExp_emptydict: function (_76,_77) {
_ruleEnter ("PriExp_emptydict");
_76 = _76.rwr ();
_77 = _77.rwr ();

_ruleExit ("PriExp_emptydict");
return `${_76}${_77}`;
},
PriExp_dict: function (_78,PairComma,_79) {
_ruleEnter ("PriExp_dict");
_78 = _78.rwr ();
PairComma = PairComma.rwr ().join ('');
_79 = _79.rwr ();

_ruleExit ("PriExp_dict");
return `${_78}${PairComma}${_79}`;
},
PriExp_lambda: function (_80,Formals,_81,Exp) {
_ruleEnter ("PriExp_lambda");
_80 = _80.rwr ();
Formals = Formals.rwr ().join ('');
_81 = _81.rwr ();
Exp = Exp.rwr ();

_ruleExit ("PriExp_lambda");
return ` lambda ${Formals}: ${Exp}`;
},
PriExp_fresh: function (_83,_84,ident,_85) {
_ruleEnter ("PriExp_fresh");
_83 = _83.rwr ();
_84 = _84.rwr ();
ident = ident.rwr ();
_85 = _85.rwr ();

_ruleExit ("PriExp_fresh");
return ` ${ident} ()`;
},
PriExp_pos: function (_86,PriExp) {
_ruleEnter ("PriExp_pos");
_86 = _86.rwr ();
PriExp = PriExp.rwr ();

_ruleExit ("PriExp_pos");
return ` +${PriExp}`;
},
PriExp_neg: function (_87,PriExp) {
_ruleEnter ("PriExp_neg");
_87 = _87.rwr ();
PriExp = PriExp.rwr ();

_ruleExit ("PriExp_neg");
return ` -${PriExp}`;
},
PriExp_phi: function (phi) {
_ruleEnter ("PriExp_phi");
phi = phi.rwr ();

_ruleExit ("PriExp_phi");
return ` None`;
},
PriExp_true: function (_88) {
_ruleEnter ("PriExp_true");
_88 = _88.rwr ();

_ruleExit ("PriExp_true");
return ` True`;
},
PriExp_false: function (_89) {
_ruleEnter ("PriExp_false");
_89 = _89.rwr ();

_ruleExit ("PriExp_false");
return ` False`;
},
PriExp_range: function (_91,_92,Exp,_93) {
_ruleEnter ("PriExp_range");
_91 = _91.rwr ();
_92 = _92.rwr ();
Exp = Exp.rwr ();
_93 = _93.rwr ();

_ruleExit ("PriExp_range");
return `${_91}${_92}${Exp}${_93}`;
},
PriExp_string: function (string) {
_ruleEnter ("PriExp_string");
string = string.rwr ();

_ruleExit ("PriExp_string");
return `${string}`;
},
PriExp_number: function (number) {
_ruleEnter ("PriExp_number");
number = number.rwr ();

_ruleExit ("PriExp_number");
return `${number}`;
},
PriExp_identwithtail: function (ident,PrimaryTail) {
_ruleEnter ("PriExp_identwithtail");
ident = ident.rwr ();
PrimaryTail = PrimaryTail.rwr ();

_ruleExit ("PriExp_identwithtail");
return `${ident}${PrimaryTail}`;
},
PriExp_ident: function (ident) {
_ruleEnter ("PriExp_ident");
ident = ident.rwr ();

_ruleExit ("PriExp_ident");
return `${ident}`;
},
PriExpComma: function (PriExp,_94) {
_ruleEnter ("PriExpComma");
PriExp = PriExp.rwr ();
_94 = _94.rwr ().join ('');

_ruleExit ("PriExpComma");
return `${PriExp} `;
},
PairComma: function (Pair,_95) {
_ruleEnter ("PairComma");
Pair = Pair.rwr ();
_95 = _95.rwr ().join ('');

_ruleExit ("PairComma");
return `${Pair}${_95}`;
},
Lval: function (Exp,PrimaryTail) {
_ruleEnter ("Lval");
Exp = Exp.rwr ();
PrimaryTail = PrimaryTail.rwr ().join ('');

_ruleExit ("Lval");
return `${Exp}${PrimaryTail}`;
},
keyword: function (_144) {
_ruleEnter ("keyword");
_144 = _144.rwr ();

_ruleExit ("keyword");
return `${_144}`;
},
ident: function (identHead,identTail) {
_ruleEnter ("ident");
identHead = identHead.rwr ();
identTail = identTail.rwr ().join ('');

_ruleExit ("ident");
return `${identHead}${identTail}`;
},
identHead: function (_146) {
_ruleEnter ("identHead");
_146 = _146.rwr ();

_ruleExit ("identHead");
return `${_146}`;
},
identTail: function (_147) {
_ruleEnter ("identTail");
_147 = _147.rwr ();

_ruleExit ("identTail");
return `${_147}`;
},
Formals_noformals: function (_148,_149) {
_ruleEnter ("Formals_noformals");
_148 = _148.rwr ();
_149 = _149.rwr ();

_ruleExit ("Formals_noformals");
return `${_148}${_149}`;
},
Formals_withformals: function (_150,Formal,CommaFormal,_151) {
_ruleEnter ("Formals_withformals");
_150 = _150.rwr ();
Formal = Formal.rwr ();
CommaFormal = CommaFormal.rwr ().join ('');
_151 = _151.rwr ();

_ruleExit ("Formals_withformals");
return `${_150}${Formal}${CommaFormal}${_151}`;
},
LambdaFormals_noformals: function (_148,_149) {
_ruleEnter ("LambdaFormals_noformals");
_148 = _148.rwr ();
_149 = _149.rwr ();

_ruleExit ("LambdaFormals_noformals");
return ``;
},
LambdaFormals_withformals: function (_150,Formal,CommaFormal,_151) {
_ruleEnter ("LambdaFormals_withformals");
_150 = _150.rwr ();
Formal = Formal.rwr ();
CommaFormal = CommaFormal.rwr ().join ('');
_151 = _151.rwr ();

_ruleExit ("LambdaFormals_withformals");
return `${Formal}${CommaFormal}`;
},
Formal: function (ident,_152,Exp) {
_ruleEnter ("Formal");
ident = ident.rwr ();
_152 = _152.rwr ();
Exp = Exp.rwr ().join ('');

_ruleExit ("Formal");
return `${ident}${_152}${Exp}`;
},
CommaFormal: function (_153,Formal) {
_ruleEnter ("CommaFormal");
_153 = _153.rwr ();
Formal = Formal.rwr ();

_ruleExit ("CommaFormal");
return `${_153}${Formal}`;
},
Actuals_noactuals: function (_154,_155) {
_ruleEnter ("Actuals_noactuals");
_154 = _154.rwr ();
_155 = _155.rwr ();

_ruleExit ("Actuals_noactuals");
return `${_154}${_155}`;
},
Actuals_actuals: function (_156,Actual,CommaActual,_157) {
_ruleEnter ("Actuals_actuals");
_156 = _156.rwr ();
Actual = Actual.rwr ();
CommaActual = CommaActual.rwr ().join ('');
_157 = _157.rwr ();

_ruleExit ("Actuals_actuals");
return `${_156}${Actual}${CommaActual}${_157}`;
},
Actual: function (ParamName,Exp) {
_ruleEnter ("Actual");
ParamName = ParamName.rwr ().join ('');
Exp = Exp.rwr ();

_ruleExit ("Actual");
return `${ParamName}${Exp}`;
},
CommaActual: function (_158,Actual) {
_ruleEnter ("CommaActual");
_158 = _158.rwr ();
Actual = Actual.rwr ();

_ruleExit ("CommaActual");
return `${_158}${Actual}`;
},
ParamName: function (ident,_159) {
_ruleEnter ("ParamName");
ident = ident.rwr ();
_159 = _159.rwr ();

_ruleExit ("ParamName");
return `${ident}${_159}`;
},
number_fract: function (digit,_160,digit) {
_ruleEnter ("number_fract");
digit = digit.rwr ().join ('');
_160 = _160.rwr ();
digit = digit.rwr ().join ('');

_ruleExit ("number_fract");
return `${digit}${_160}${digit}`;
},
number_whole: function (digit) {
_ruleEnter ("number_whole");
digit = digit.rwr ().join ('');

_ruleExit ("number_whole");
return `${digit}`;
},
Pair: function (string,_161,Exp,_162) {
_ruleEnter ("Pair");
string = string.rwr ();
_161 = _161.rwr ();
Exp = Exp.rwr ();
_162 = _162.rwr ().join ('');

_ruleExit ("Pair");
return `${string}${_161}${Exp}${_162}`;
},
PrimaryTail_methodcall: function (MethodCall,PrimaryTail) {
_ruleEnter ("PrimaryTail_methodcall");
MethodCall = MethodCall.rwr ();
PrimaryTail = PrimaryTail.rwr ().join ('');

_ruleExit ("PrimaryTail_methodcall");
return `${MethodCall}${PrimaryTail}`;
},
PrimaryTail_offsetref: function (OffsetRef,PrimaryTail) {
_ruleEnter ("PrimaryTail_offsetref");
OffsetRef = OffsetRef.rwr ();
PrimaryTail = PrimaryTail.rwr ().join ('');

_ruleExit ("PrimaryTail_offsetref");
return `${OffsetRef}${PrimaryTail}`;
},
PrimaryTail_lookup: function (FieldLookup,PrimaryTail) {
_ruleEnter ("PrimaryTail_lookup");
FieldLookup = FieldLookup.rwr ();
PrimaryTail = PrimaryTail.rwr ().join ('');

_ruleExit ("PrimaryTail_lookup");
return `${FieldLookup}${PrimaryTail}`;
},
PrimaryTail_slice: function (Slice,PrimaryTail) {
_ruleEnter ("PrimaryTail_slice");
Slice = Slice.rwr ();
PrimaryTail = PrimaryTail.rwr ().join ('');

_ruleExit ("PrimaryTail_slice");
return `${Slice}${PrimaryTail}`;
},
MethodCall: function (Actuals) {
_ruleEnter ("MethodCall");
Actuals = Actuals.rwr ();

_ruleExit ("MethodCall");
return `${Actuals}`;
},
OffsetRef: function (_163,ident) {
_ruleEnter ("OffsetRef");
_163 = _163.rwr ();
ident = ident.rwr ();

_ruleExit ("OffsetRef");
return `${_163}${ident}`;
},
FieldLookup_slicefirst: function (_164,_165,_166) {
_ruleEnter ("FieldLookup_slicefirst");
_164 = _164.rwr ();
_165 = _165.rwr ();
_166 = _166.rwr ();

_ruleExit ("FieldLookup_slicefirst");
return `${_164}${_165}${_166}`;
},
FieldLookup_lookup: function (_167,Exp,_168) {
_ruleEnter ("FieldLookup_lookup");
_167 = _167.rwr ();
Exp = Exp.rwr ();
_168 = _168.rwr ();

_ruleExit ("FieldLookup_lookup");
return `${_167}${Exp}${_168}`;
},
Slice_slicewhole: function (_169,_170,_171) {
_ruleEnter ("Slice_slicewhole");
_169 = _169.rwr ();
_170 = _170.rwr ();
_171 = _171.rwr ();

_ruleExit ("Slice_slicewhole");
return `${_169}${_170}${_171}`;
},
Slice_slicerest: function (_172,_173,_174,_175) {
_ruleEnter ("Slice_slicerest");
_172 = _172.rwr ();
_173 = _173.rwr ();
_174 = _174.rwr ();
_175 = _175.rwr ();

_ruleExit ("Slice_slicerest");
return `${_172}${_173}${_174}${_175}`;
},
Slice_nthslice: function (_176,digit,_177,_178) {
_ruleEnter ("Slice_nthslice");
_176 = _176.rwr ();
digit = digit.rwr ().join ('');
_177 = _177.rwr ();
_178 = _178.rwr ();

_ruleExit ("Slice_nthslice");
return `${_176}${digit}${_177}${_178}`;
},
boolOp: function (_191) {
_ruleEnter ("boolOp");
_191 = _191.rwr ();

_ruleExit ("boolOp");
return ` ${_191} `;
},
phi: function (_192) {
_ruleEnter ("phi");
_192 = _192.rwr ();

_ruleExit ("phi");
return ` None`;
},
string_fdqstring: function (_193,notdq,_194) {
_ruleEnter ("string_fdqstring");
_193 = _193.rwr ();
notdq = notdq.rwr ().join ('');
_194 = _194.rwr ();

_ruleExit ("string_fdqstring");
return `${_193}${notdq}${_194}`;
},
string_fsqstring: function (_195,notsq,_196) {
_ruleEnter ("string_fsqstring");
_195 = _195.rwr ();
notsq = notsq.rwr ().join ('');
_196 = _196.rwr ();

_ruleExit ("string_fsqstring");
return `${_195}${notsq}${_196}`;
},
string_dqstring: function (_197,notdq,_198) {
_ruleEnter ("string_dqstring");
_197 = _197.rwr ();
notdq = notdq.rwr ().join ('');
_198 = _198.rwr ();

_ruleExit ("string_dqstring");
return `${_197}${notdq}${_198}`;
},
string_sqstring: function (_199,notsq,_200) {
_ruleEnter ("string_sqstring");
_199 = _199.rwr ();
notsq = notsq.rwr ().join ('');
_200 = _200.rwr ();

_ruleExit ("string_sqstring");
return `${_199}${notsq}${_200}`;
},
notdq: function (any) {
_ruleEnter ("notdq");
any = any.rwr ();

_ruleExit ("notdq");
return `${any}`;
},
notsq: function (any) {
_ruleEnter ("notsq");
any = any.rwr ();

_ruleExit ("notsq");
return `${any}`;
},
comment: function (_203,notnl,nl) {
_ruleEnter ("comment");
_203 = _203.rwr ();
notnl = notnl.rwr ().join ('');
nl = nl.rwr ();

_ruleExit ("comment");
return `${_203}${notnl}${nl}`;
},
nl: function (_204) {
_ruleEnter ("nl");
_204 = _204.rwr ();

_ruleExit ("nl");
return `${_204}`;
},
notnl: function (any) {
_ruleEnter ("notnl");
any = any.rwr ();

_ruleExit ("notnl");
return `${any}`;
},
space: function (comment) {
_ruleEnter ("space");
comment = comment.rwr ();

_ruleExit ("space");
return `${comment}`;
},

    _terminal: function () { _ruleEnter ("_terminal"); _ruleExit ("_terminal"); return this.sourceString; },
    _iter: function (...children) {_ruleEnter ("_iter"); _ruleExit ("_iter");  return children.map(c => c.rwr ()); },
    spaces: function (x) {_ruleEnter ("spaces"); _ruleExit ("spaces");  return this.sourceString; },
    space: function (x) {_ruleEnter ("space"); _ruleExit ("space");  return this.sourceString; }
}): Found errors in the action dictionary of the 'rwr' operation:
- Semantic action 'Rec_Statement' has the wrong arity: expected 1, got 2
- 'Statement_globals' is not a valid semantic action for 'rt'
- 'Statement_if' is not a valid semantic action for 'rt'
- 'Statement_pass' is not a valid semantic action for 'rt'
- 'Statement_return' is not a valid semantic action for 'rt'
- 'Statement_for' is not a valid semantic action for 'rt'
- 'Statement_while' is not a valid semantic action for 'rt'
- 'Statement_try' is not a valid semantic action for 'rt'
- 'Statement_assignment' is not a valid semantic action for 'rt'
- 'Statement_call' is not a valid semantic action for 'rt'
$grammarName="{grammarName}" grammFilename="/tmp/fakepipe2" rwrFilename="/tmp/fakepipe1"
[try using "node /tmp/fakepipe1", to get better error reporting]
