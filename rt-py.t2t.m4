% rewrite

Main [ TopLevel+] = ‛«TopLevel»’

TopLevel_defvar [ Defvar] =‛«Defvar»’
TopLevel_defn [ Defn] =‛«Defn»’
TopLevel_defclass [ Defclass] =‛«Defclass»’
TopLevel_import [ Import] =‛«Import»’
kw [ s] = ‛«s»’
Defvar [ __ lval _eq e] = ‛\n«lval» = «e»’
Defn [ _4 ident Formals StatementBlock] = ‛\ndef «ident» «Formals»:«StatementBlock»’
Defclass [ _6 ident _7 Definit _8] = ‛\nclass «ident»:⤷\n«Definit»⤶\n’
Import [ _10 ident] = ‛\nimport «ident»’
StatementBlock [ _11 Statement _12] = ‛⤷«Statement»⤶\n’
Definit [ _14 _15 _17 _18 ident formals* _20 _21 InitStatement+ _22] = ‛def __init__ (self«formals»):⤷\n«InitStatement»⤶\n’

Rec_Statement_globals [ _24 ident1  cidents* scope?] =‛\nglobal «ident1»«cidents»«scope»’
CommaIdent [_comma ident] = ‛, «ident»’
Rec_Statement_if [ IfStatement scope?] =‛«IfStatement»«scope»’
Rec_Statement_pass [ _27 scope?] =‛\npass«scope»’
Rec_Statement_return [ _29 ReturnExp scope?] =‛\nreturn «ReturnExp»«scope»’
Rec_Statement_for [ ForStatement scope?] =‛«ForStatement»«scope»«scope»’
Rec_Statement_while [ WhileStatement scope?] =‛«WhileStatement»«scope»’
Rec_Statement_try [ TryStatement scope?] =‛«TryStatement»«scope»’
Rec_Statement_assignment [ Assignment scope?] =‛«Assignment»«scope»’
Rec_Statement_call [ Lval scope?] =‛\n«Lval»«scope»’
InitStatement [ _31 _32 ident _33 Exp] = ‛\nself.«ident» = «Exp»’
IfStatement [ _35 Exp StatementBlock ElifStatement* ElseStatement?] = ‛\nif «Exp»:«StatementBlock»«ElifStatement»«ElseStatement»’
ElifStatement [ _37 Exp StatementBlock] = ‛elif «Exp»:«StatementBlock»’
ElseStatement [ _39 StatementBlock] = ‛else:«StatementBlock»’
ForStatement [ _41 ident _43 Exp StatementBlock] = ‛\nfor «ident» in «Exp»:«StatementBlock»’
WhileStatement [ _45 Exp StatementBlock] = ‛\nwhile «Exp»:«StatementBlock»’
TryStatement [ _47 StatementBlock ExceptBlock+] = ‛\ntry:\n«StatementBlock»«ExceptBlock»’

ExceptBlock_as [ _49 Exp _51 ident StatementBlock] =‛except «Exp» as «ident»:«StatementBlock»’
ExceptBlock_basic [ _53 ident StatementBlock] =‛except «ident»:«StatementBlock»’

Assignment_pluseq [ Lval _54 Exp] = ‛\n«Lval» += «Exp»’
Assignment_multiple [ _55 Lval1  Lval2+ _57 _58 Exp] =‛\n[«Lval1»«Lval2»] = «Exp»’
Assignment_single [ Lval _59 Exp] =‛\n«Lval» = «Exp»’
CommaLval [_comma Lval] = ‛, «Lval»’

ReturnExp_multiple [ _60 Exp1 Exp2+ _62] =‛[«Exp1»«Exp2»]’
ReturnExp_single [ Exp] =‛«Exp»’
CommaExp [_comma e] = ‛, «e»’
Exp [ BooleanExp] = ‛«BooleanExp»’

BooleanExp_boolop [ BooleanExp boolOp BooleanNot] =‛«BooleanExp»«boolOp»«BooleanNot»’
BooleanExp_basic [ BooleanNot] =‛«BooleanNot»’

BooleanNot_not [ _64 BooleanExp] =‛not «BooleanExp»’
BooleanNot_basic [ AddExp] =‛«AddExp»’

AddExp_plus [ AddExp _65 MulExp] =‛«AddExp»«_65»«MulExp»’
AddExp_minus [ AddExp _66 MulExp] =‛«AddExp»«_66»«MulExp»’
AddExp_basic [ MulExp] =‛«MulExp»’

MulExp_times [ MulExp _67 ExpExp] =‛«MulExp»«_67»«ExpExp»’
MulExp_divide [ MulExp _68 ExpExp] =‛«MulExp»«_68»«ExpExp»’
MulExp_basic [ ExpExp] =‛«ExpExp»’

ExpExp_power [ Primary _69 ExpExp] =‛«Primary»«_69»«ExpExp»’
ExpExp_basic [ Primary] =‛«Primary»’

Primary_paren [ _70 Exp _71] =‛«_70»«Exp»«_71»’
Primary_emptylistconst [ _72 _73] =‛«_72»«_73»’
Primary_listconst [ _74 PrimaryComma+ _75] =‛«_74»«PrimaryComma»«_75»’
Primary_emptydict [ _76 _77] =‛«_76»«_77»’
Primary_dict [ _78 PairComma+ _79] =‛«_78»«PairComma»«_79»’
Primary_lambda [ _80 Formals? _81 Exp] =‛ lambda «Formals»: «Exp»’
Primary_fresh [ _83 _84 ident _85] =‛ «ident» ()’
Primary_pos [ _86 Primary] =‛ +«Primary»’
Primary_neg [ _87 Primary] =‛ -«Primary»’
Primary_phi [ phi] =‛ None’
Primary_true [ _88] =‛ True’
Primary_false [ _89] =‛ False’
Primary_range [ _91 _92 Exp _93] =‛«_91»«_92»«Exp»«_93»’
Primary_string [ string] =‛«string»’
Primary_number [ number] =‛«number»’
Primary_identwithtail [ ident PrimaryTail] =‛«ident»«PrimaryTail»’
Primary_ident [ ident] =‛«ident»’
PrimaryComma [ Primary _94?] = ‛«Primary»«_94»’
PairComma [ Pair _95?] = ‛«Pair»«_95»’
Lval [ Exp PrimaryTail?] = ‛«Exp»«PrimaryTail»’
keyword [ _144] = ‛«_144»’
ident [ identHead identTail*] = ‛«identHead»«identTail»’
identHead [ _146] = ‛«_146»’
identTail [ _147] = ‛«_147»’

Formals_noformals [ _148 _149] =‛«_148»«_149»’
Formals_withformals [ _150 Formal CommaFormal* _151] =‛«_150»«Formal»«CommaFormal»«_151»’
LambdaFormals_noformals [ _148 _149] =‛’
LambdaFormals_withformals [ _150 Formal CommaFormal* _151] =‛«Formal»«CommaFormal»’
Formal [ ident  _152 Exp?] = ‛«ident»«_152»«Exp»’
CommaFormal [ _153 Formal] = ‛«_153»«Formal»’

Actuals_noactuals [ _154 _155] =‛«_154»«_155»’
Actuals_actuals [ _156 Actual CommaActual* _157] =‛«_156»«Actual»«CommaActual»«_157»’
Actual [ ParamName? Exp] = ‛«ParamName»«Exp»’
CommaActual [ _158 Actual] = ‛«_158»«Actual»’
ParamName [ ident _159] = ‛«ident»«_159»’

number_fract [ num* _160 den+] =‛«num»«_160»«den»’
number_whole [ digit+] =‛«digit»’
Pair [ string _161 Exp _162?] = ‛«string»«_161»«Exp»«_162»’

PrimaryTail_dictlookup [ _eyes key PrimaryTail?] =‛["«key»"]«PrimaryTail»’
PrimaryTail_methodcall [ MethodCall PrimaryTail?] =‛«MethodCall»«PrimaryTail»’
PrimaryTail_offsetref [ OffsetRef PrimaryTail?] =‛«OffsetRef»«PrimaryTail»’
PrimaryTail_lookup [ FieldLookup PrimaryTail?] =‛«FieldLookup»«PrimaryTail»’
PrimaryTail_slice [ Slice PrimaryTail?] =‛«Slice»«PrimaryTail»’
MethodCall [ Actuals] = ‛«Actuals»’
OffsetRef [ _163 ident] = ‛«_163»«ident»’

FieldLookup_slicefirst [ _164 _165 _166] =‛«_164»«_165»«_166»’
FieldLookup_lookup [ _167 Exp _168] =‛«_167»«Exp»«_168»’

Slice_slicewhole [ _169 _170 _171] =‛«_169»«_170»«_171»’
Slice_slicerest [ _172 _173 _174 _175] =‛«_172»«_173»«_174»«_175»’
Slice_nthslice [ _176 digit+ _177 _178] =‛«_176»«digit»«_177»«_178»’
boolOp [ _191] = ‛ «_191» ’
phi [ _192] = ‛ None’

string_fdqstring [ _193 notdq* _194] =‛«_193»«notdq»«_194»’
string_fsqstring [ _195 notsq* _196] =‛«_195»«notsq»«_196»’
string_dqstring [ _197 notdq* _198] =‛«_197»«notdq»«_198»’
string_sqstring [ _199 notsq* _200] =‛«_199»«notsq»«_200»’
notdq [ any] = ‛«any»’
notsq [ any] = ‛«any»’
comment [ _203 notnl* nl] = ‛«_203»«notnl»«nl»’
nl [ _204] = ‛«_204»’
notnl [ any] = ‛«any»’
space [ comment] = ‛«comment»’
