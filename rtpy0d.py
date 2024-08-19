
defclass⋅D ✓ spaces ⇒  ""
defclass⋅D   ✓ space_A ⇒  ""
defclass⋅D     ✗ space
defclass⋅D       ✗ comment
defclass⋅D         ✗ comment
defclass⋅D           ✗ "#" notnl* nl
defclass⋅D             ✗ "#"
defclass⋅D         ✗ "\u0000".." "
defclass⋅D ✗ Main
defclass⋅D   ✗ TopLevel+
defclass⋅D     ✓ spaces ⇒  ""
defclass⋅D       ✓ space_A ⇒  ""
defclass⋅D         ✗ space
defclass⋅D           ✗ comment
defclass⋅D             ✗ comment
defclass⋅D               ✗ "#" notnl* nl
defclass⋅D                 ✗ "#"
defclass⋅D             ✗ "\u0000".." "
defclass⋅D     ✗ TopLevel
defclass⋅D         ✓ spaces ⇒  ""
defclass⋅D           ✓ space_A ⇒  ""
defclass⋅D             ✗ space
defclass⋅D               ✗ comment
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ "#" notnl* nl
defclass⋅D                     ✗ "#"
defclass⋅D                 ✗ "\u0000".." "
defclass⋅D         ✗ TopLevel_defvar
defclass⋅D           ✓ spaces ⇒  ""
defclass⋅D             ✓ space_A ⇒  ""
defclass⋅D               ✗ space
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ comment
defclass⋅D                     ✗ "#" notnl* nl
defclass⋅D                       ✗ "#"
defclass⋅D                   ✗ "\u0000".." "
defclass⋅D           ✗ Defvar
defclass⋅D             ✗ kw<"defvar"> Lval "=" Exp
defclass⋅D               ✓ spaces ⇒  ""
defclass⋅D                 ✓ space_A ⇒  ""
defclass⋅D                   ✗ space
defclass⋅D                     ✗ comment
defclass⋅D                       ✗ comment
defclass⋅D                         ✗ "#" notnl* nl
defclass⋅D                           ✗ "#"
defclass⋅D                       ✗ "\u0000".." "
defclass⋅D               ✗ kw<"defvar">
defclass⋅D                 ✗ s ~identTail
defclass⋅D                   ✗ $0
defclass⋅D                     ✗ "defvar"
defclass⋅D         ✓ spaces ⇒  ""
defclass⋅D           ✓ space_A ⇒  ""
defclass⋅D             ✗ space
defclass⋅D               ✗ comment
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ "#" notnl* nl
defclass⋅D                     ✗ "#"
defclass⋅D                 ✗ "\u0000".." "
defclass⋅D         ✗ TopLevel_defconst
defclass⋅D           ✓ spaces ⇒  ""
defclass⋅D             ✓ space_A ⇒  ""
defclass⋅D               ✗ space
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ comment
defclass⋅D                     ✗ "#" notnl* nl
defclass⋅D                       ✗ "#"
defclass⋅D                   ✗ "\u0000".." "
defclass⋅D           ✗ Defconst
defclass⋅D             ✗ kw<"defconst"> Lval "=" Exp
defclass⋅D               ✓ spaces ⇒  ""
defclass⋅D                 ✓ space_A ⇒  ""
defclass⋅D                   ✗ space
defclass⋅D                     ✗ comment
defclass⋅D                       ✗ comment
defclass⋅D                         ✗ "#" notnl* nl
defclass⋅D                           ✗ "#"
defclass⋅D                       ✗ "\u0000".." "
defclass⋅D               ✗ kw<"defconst">
defclass⋅D                 ✗ s ~identTail
defclass⋅D                   ✗ $0
defclass⋅D                     ✗ "defconst"
defclass⋅D         ✓ spaces ⇒  ""
defclass⋅D           ✓ space_A ⇒  ""
defclass⋅D             ✗ space
defclass⋅D               ✗ comment
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ "#" notnl* nl
defclass⋅D                     ✗ "#"
defclass⋅D                 ✗ "\u0000".." "
defclass⋅D         ✗ TopLevel_defn
defclass⋅D           ✓ spaces ⇒  ""
defclass⋅D             ✓ space_A ⇒  ""
defclass⋅D               ✗ space
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ comment
defclass⋅D                     ✗ "#" notnl* nl
defclass⋅D                       ✗ "#"
defclass⋅D                   ✗ "\u0000".." "
defclass⋅D           ✗ Defn
defclass⋅D             ✗ kw<"defn"> ident Formals StatementBlock
defclass⋅D               ✓ spaces ⇒  ""
defclass⋅D                 ✓ space_A ⇒  ""
defclass⋅D                   ✗ space
defclass⋅D                     ✗ comment
defclass⋅D                       ✗ comment
defclass⋅D                         ✗ "#" notnl* nl
defclass⋅D                           ✗ "#"
defclass⋅D                       ✗ "\u0000".." "
defclass⋅D               ✗ kw<"defn">
defclass⋅D                 ✗ s ~identTail
defclass⋅D                   ✗ $0
defclass⋅D                     ✗ "defn"
defclass⋅D         ✓ spaces ⇒  ""
defclass⋅D           ✓ space_A ⇒  ""
defclass⋅D             ✗ space
defclass⋅D               ✗ comment
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ "#" notnl* nl
defclass⋅D                     ✗ "#"
defclass⋅D                 ✗ "\u0000".." "
defclass⋅D         ✗ TopLevel_defclass
defclass⋅D           ✓ spaces ⇒  ""
defclass⋅D             ✓ space_A ⇒  ""
defclass⋅D               ✗ space
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ comment
defclass⋅D                     ✗ "#" notnl* nl
defclass⋅D                       ✗ "#"
defclass⋅D                   ✗ "\u0000".." "
defclass⋅D           ✗ Defclass
defclass⋅D             ✗ kw<"defclass"> ident ClassFormals "{" Definit "}"
defclass⋅D               ✓ spaces ⇒  ""
defclass⋅D                 ✓ space_A ⇒  ""
defclass⋅D                   ✗ space
defclass⋅D                     ✗ comment
defclass⋅D                       ✗ comment
defclass⋅D                         ✗ "#" notnl* nl
defclass⋅D                           ✗ "#"
defclass⋅D                       ✗ "\u0000".." "
defclass⋅D               ✓ kw<"defclass"> ⇒  "defclass"
defclass⋅D                 ✓ s ~identTail ⇒  "defclass"
defclass⋅D                   ✓ $0 ⇒  "defclass"
defclass⋅D                     ✓ "defclass" ⇒  "defclass"
⋅Datum⋅()⋅                   ✓ ~identTail ⇒  ""
⋅Datum⋅()⋅                     ✗ identTail
⋅Datum⋅()⋅                         ✗ alnum
⋅Datum⋅()⋅                             ✗ letter
⋅Datum⋅()⋅                                 ✗ lower
⋅Datum⋅()⋅                                   ✗ Unicode [Ll] character
⋅Datum⋅()⋅                                 ✗ upper
⋅Datum⋅()⋅                                   ✗ Unicode [Lu] character
⋅Datum⋅()⋅                                 ✗ unicodeLtmo
⋅Datum⋅()⋅                                   ✗ Unicode [Ltmo] character
⋅Datum⋅()⋅                             ✗ digit
⋅Datum⋅()⋅                               ✗ "0".."9"
⋅Datum⋅()⋅                         ✗ identHead
⋅Datum⋅()⋅                             ✗ "_"
⋅Datum⋅()⋅                             ✗ letter
⋅Datum⋅()⋅                                 ✗ lower
⋅Datum⋅()⋅                                   ✗ Unicode [Ll] character
⋅Datum⋅()⋅                                 ✗ upper
⋅Datum⋅()⋅                                   ✗ Unicode [Lu] character
⋅Datum⋅()⋅                                 ✗ unicodeLtmo
⋅Datum⋅()⋅                                   ✗ Unicode [Ltmo] character
⋅Datum⋅()⋅               ✓ spaces ⇒  "⋅"
⋅Datum⋅()⋅                 ✓ space_A ⇒  "⋅"
⋅Datum⋅()⋅                   ✓ space ⇒  "⋅"
⋅Datum⋅()⋅                     ✓ comment ⇒  "⋅"
⋅Datum⋅()⋅                       ✗ comment
⋅Datum⋅()⋅                         ✗ "#" notnl* nl
⋅Datum⋅()⋅                           ✗ "#"
⋅Datum⋅()⋅                       ✓ "\u0000".." " ⇒  "⋅"
Datum⋅()⋅{                   ✗ space
Datum⋅()⋅{                     ✗ comment
Datum⋅()⋅{                       ✗ comment
Datum⋅()⋅{                         ✗ "#" notnl* nl
Datum⋅()⋅{                           ✗ "#"
Datum⋅()⋅{                       ✗ "\u0000".." "
Datum⋅()⋅{               ✓ ident ⇒  "Datum"
Datum⋅()⋅{                 ✓ ~keyword identHead identTail* ⇒  "Datum"
Datum⋅()⋅{                   ✓ ~keyword ⇒  ""
Datum⋅()⋅{                     ✗ keyword
Datum⋅()⋅{                         ✗ kw<"fresh">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "fresh"
Datum⋅()⋅{                         ✗ kw<"defvar">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "defvar"
Datum⋅()⋅{                         ✗ kw<"defconst">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "defconst"
Datum⋅()⋅{                         ✗ kw<"defn">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "defn"
Datum⋅()⋅{                         ✗ kw<"defclass">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "defclass"
Datum⋅()⋅{                         ✗ kw<"•">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "•"
Datum⋅()⋅{                         ✗ kw<"useglobal">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "useglobal"
Datum⋅()⋅{                         ✗ kw<"pass">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "pass"
Datum⋅()⋅{                         ✗ kw<"return">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "return"
Datum⋅()⋅{                         ✗ kw<"if">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "if"
Datum⋅()⋅{                         ✗ kw<"elif">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "elif"
Datum⋅()⋅{                         ✗ kw<"else">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "else"
Datum⋅()⋅{                         ✗ kw<"and">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "and"
Datum⋅()⋅{                         ✗ kw<"or">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "or"
Datum⋅()⋅{                         ✗ kw<"in">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "in"
Datum⋅()⋅{                         ✗ kw<"not">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "not"
Datum⋅()⋅{                         ✗ kw<"range">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "range"
Datum⋅()⋅{                         ✗ kw<"while">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "while"
Datum⋅()⋅{                         ✗ kw<"f\"">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "f\""
Datum⋅()⋅{                         ✗ kw<"f'">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "f'"
Datum⋅()⋅{                         ✗ kw<"import">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "import"
Datum⋅()⋅{                         ✗ kw<"try">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "try"
Datum⋅()⋅{                         ✗ kw<"except">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "except"
Datum⋅()⋅{                         ✗ kw<"as">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "as"
Datum⋅()⋅{                         ✗ kw<"λ">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "λ"
Datum⋅()⋅{                         ✗ kw<"car">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "car"
Datum⋅()⋅{                         ✗ kw<"cdr">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "cdr"
Datum⋅()⋅{                         ✗ kw<"stringcdr">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "stringcdr"
Datum⋅()⋅{                         ✗ kw<"argvcdr">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "argvcdr"
Datum⋅()⋅{                         ✗ kw<"nthargv">
Datum⋅()⋅{                           ✗ s ~identTail
Datum⋅()⋅{                             ✗ $0
Datum⋅()⋅{                               ✗ "nthargv"
Datum⋅()⋅{                   ✓ identHead ⇒  "D"
Datum⋅()⋅{                       ✗ "_"
Datum⋅()⋅{                       ✓ letter ⇒  "D"
Datum⋅()⋅{                           ✗ lower
Datum⋅()⋅{                             ✗ Unicode [Ll] character
Datum⋅()⋅{                           ✓ upper ⇒  "D"
Datum⋅()⋅{                             ✓ Unicode [Lu] character ⇒  "D"
atum⋅()⋅{␊                   ✓ identTail* ⇒  "atum"
atum⋅()⋅{␊                     ✓ identTail ⇒  "a"
atum⋅()⋅{␊                         ✓ alnum ⇒  "a"
atum⋅()⋅{␊                             ✓ letter ⇒  "a"
atum⋅()⋅{␊                                 ✓ lower ⇒  "a"
atum⋅()⋅{␊                                   ✓ Unicode [Ll] character ⇒  "a"
tum⋅()⋅{␊⋅                     ✓ identTail ⇒  "t"
tum⋅()⋅{␊⋅                         ✓ alnum ⇒  "t"
tum⋅()⋅{␊⋅                             ✓ letter ⇒  "t"
tum⋅()⋅{␊⋅                                 ✓ lower ⇒  "t"
tum⋅()⋅{␊⋅                                   ✓ Unicode [Ll] character ⇒  "t"
um⋅()⋅{␊⋅⋅                     ✓ identTail ⇒  "u"
um⋅()⋅{␊⋅⋅                         ✓ alnum ⇒  "u"
um⋅()⋅{␊⋅⋅                             ✓ letter ⇒  "u"
um⋅()⋅{␊⋅⋅                                 ✓ lower ⇒  "u"
um⋅()⋅{␊⋅⋅                                   ✓ Unicode [Ll] character ⇒  "u"
m⋅()⋅{␊⋅⋅⋅                     ✓ identTail ⇒  "m"
m⋅()⋅{␊⋅⋅⋅                         ✓ alnum ⇒  "m"
m⋅()⋅{␊⋅⋅⋅                             ✓ letter ⇒  "m"
m⋅()⋅{␊⋅⋅⋅                                 ✓ lower ⇒  "m"
m⋅()⋅{␊⋅⋅⋅                                   ✓ Unicode [Ll] character ⇒  "m"
⋅()⋅{␊⋅⋅⋅⋅                     ✗ identTail
⋅()⋅{␊⋅⋅⋅⋅                         ✗ alnum
⋅()⋅{␊⋅⋅⋅⋅                             ✗ letter
⋅()⋅{␊⋅⋅⋅⋅                                 ✗ lower
⋅()⋅{␊⋅⋅⋅⋅                                   ✗ Unicode [Ll] character
⋅()⋅{␊⋅⋅⋅⋅                                 ✗ upper
⋅()⋅{␊⋅⋅⋅⋅                                   ✗ Unicode [Lu] character
⋅()⋅{␊⋅⋅⋅⋅                                 ✗ unicodeLtmo
⋅()⋅{␊⋅⋅⋅⋅                                   ✗ Unicode [Ltmo] character
⋅()⋅{␊⋅⋅⋅⋅                             ✗ digit
⋅()⋅{␊⋅⋅⋅⋅                               ✗ "0".."9"
⋅()⋅{␊⋅⋅⋅⋅                         ✗ identHead
⋅()⋅{␊⋅⋅⋅⋅                             ✗ "_"
⋅()⋅{␊⋅⋅⋅⋅                             ✗ letter
⋅()⋅{␊⋅⋅⋅⋅                                 ✗ lower
⋅()⋅{␊⋅⋅⋅⋅                                   ✗ Unicode [Ll] character
⋅()⋅{␊⋅⋅⋅⋅                                 ✗ upper
⋅()⋅{␊⋅⋅⋅⋅                                   ✗ Unicode [Lu] character
⋅()⋅{␊⋅⋅⋅⋅                                 ✗ unicodeLtmo
⋅()⋅{␊⋅⋅⋅⋅                                   ✗ Unicode [Ltmo] character
⋅()⋅{␊⋅⋅⋅⋅               ✓ spaces ⇒  "⋅"
⋅()⋅{␊⋅⋅⋅⋅                 ✓ space_A ⇒  "⋅"
⋅()⋅{␊⋅⋅⋅⋅                   ✓ space ⇒  "⋅"
⋅()⋅{␊⋅⋅⋅⋅                     ✓ comment ⇒  "⋅"
⋅()⋅{␊⋅⋅⋅⋅                       ✗ comment
⋅()⋅{␊⋅⋅⋅⋅                         ✗ "#" notnl* nl
⋅()⋅{␊⋅⋅⋅⋅                           ✗ "#"
⋅()⋅{␊⋅⋅⋅⋅                       ✓ "\u0000".." " ⇒  "⋅"
()⋅{␊⋅⋅⋅⋅⋅                   ✗ space
()⋅{␊⋅⋅⋅⋅⋅                     ✗ comment
()⋅{␊⋅⋅⋅⋅⋅                       ✗ comment
()⋅{␊⋅⋅⋅⋅⋅                         ✗ "#" notnl* nl
()⋅{␊⋅⋅⋅⋅⋅                           ✗ "#"
()⋅{␊⋅⋅⋅⋅⋅                       ✗ "\u0000".." "
()⋅{␊⋅⋅⋅⋅⋅               ✓ ClassFormals ⇒  "()"
()⋅{␊⋅⋅⋅⋅⋅                   ✓ spaces ⇒  ""
()⋅{␊⋅⋅⋅⋅⋅                     ✓ space_A ⇒  ""
()⋅{␊⋅⋅⋅⋅⋅                       ✗ space
()⋅{␊⋅⋅⋅⋅⋅                         ✗ comment
()⋅{␊⋅⋅⋅⋅⋅                           ✗ comment
()⋅{␊⋅⋅⋅⋅⋅                             ✗ "#" notnl* nl
()⋅{␊⋅⋅⋅⋅⋅                               ✗ "#"
()⋅{␊⋅⋅⋅⋅⋅                           ✗ "\u0000".." "
()⋅{␊⋅⋅⋅⋅⋅                   ✓ ClassFormals_noformals ⇒  "()"
()⋅{␊⋅⋅⋅⋅⋅                     ✓ "(" ")" ⇒  "()"
()⋅{␊⋅⋅⋅⋅⋅                       ✓ spaces ⇒  ""
()⋅{␊⋅⋅⋅⋅⋅                         ✓ space_A ⇒  ""
()⋅{␊⋅⋅⋅⋅⋅                           ✗ space
()⋅{␊⋅⋅⋅⋅⋅                             ✗ comment
()⋅{␊⋅⋅⋅⋅⋅                               ✗ comment
()⋅{␊⋅⋅⋅⋅⋅                                 ✗ "#" notnl* nl
()⋅{␊⋅⋅⋅⋅⋅                                   ✗ "#"
()⋅{␊⋅⋅⋅⋅⋅                               ✗ "\u0000".." "
()⋅{␊⋅⋅⋅⋅⋅                       ✓ "(" ⇒  "("
)⋅{␊⋅⋅⋅⋅⋅⋅                       ✓ spaces ⇒  ""
)⋅{␊⋅⋅⋅⋅⋅⋅                         ✓ space_A ⇒  ""
)⋅{␊⋅⋅⋅⋅⋅⋅                           ✗ space
)⋅{␊⋅⋅⋅⋅⋅⋅                             ✗ comment
)⋅{␊⋅⋅⋅⋅⋅⋅                               ✗ comment
)⋅{␊⋅⋅⋅⋅⋅⋅                                 ✗ "#" notnl* nl
)⋅{␊⋅⋅⋅⋅⋅⋅                                   ✗ "#"
)⋅{␊⋅⋅⋅⋅⋅⋅                               ✗ "\u0000".." "
)⋅{␊⋅⋅⋅⋅⋅⋅                       ✓ ")" ⇒  ")"
⋅{␊⋅⋅⋅⋅⋅⋅•               ✓ spaces ⇒  "⋅"
⋅{␊⋅⋅⋅⋅⋅⋅•                 ✓ space_A ⇒  "⋅"
⋅{␊⋅⋅⋅⋅⋅⋅•                   ✓ space ⇒  "⋅"
⋅{␊⋅⋅⋅⋅⋅⋅•                     ✓ comment ⇒  "⋅"
⋅{␊⋅⋅⋅⋅⋅⋅•                       ✗ comment
⋅{␊⋅⋅⋅⋅⋅⋅•                         ✗ "#" notnl* nl
⋅{␊⋅⋅⋅⋅⋅⋅•                           ✗ "#"
⋅{␊⋅⋅⋅⋅⋅⋅•                       ✓ "\u0000".." " ⇒  "⋅"
{␊⋅⋅⋅⋅⋅⋅•d                   ✗ space
{␊⋅⋅⋅⋅⋅⋅•d                     ✗ comment
{␊⋅⋅⋅⋅⋅⋅•d                       ✗ comment
{␊⋅⋅⋅⋅⋅⋅•d                         ✗ "#" notnl* nl
{␊⋅⋅⋅⋅⋅⋅•d                           ✗ "#"
{␊⋅⋅⋅⋅⋅⋅•d                       ✗ "\u0000".." "
{␊⋅⋅⋅⋅⋅⋅•d               ✓ "{" ⇒  "{"
␊⋅⋅⋅⋅⋅⋅•da               ✓ spaces ⇒  "␊⋅⋅⋅⋅⋅⋅"
␊⋅⋅⋅⋅⋅⋅•da                 ✓ space_A ⇒  "␊⋅⋅⋅⋅⋅⋅"
␊⋅⋅⋅⋅⋅⋅•da                   ✓ space ⇒  "␊"
␊⋅⋅⋅⋅⋅⋅•da                     ✓ comment ⇒  "␊"
␊⋅⋅⋅⋅⋅⋅•da                       ✗ comment
␊⋅⋅⋅⋅⋅⋅•da                         ✗ "#" notnl* nl
␊⋅⋅⋅⋅⋅⋅•da                           ✗ "#"
␊⋅⋅⋅⋅⋅⋅•da                       ✓ "\u0000".." " ⇒  "␊"
⋅⋅⋅⋅⋅⋅•dat                   ✓ space ⇒  "⋅"
⋅⋅⋅⋅⋅⋅•dat                     ✓ comment ⇒  "⋅"
⋅⋅⋅⋅⋅⋅•dat                       ✗ comment
⋅⋅⋅⋅⋅⋅•dat                         ✗ "#" notnl* nl
⋅⋅⋅⋅⋅⋅•dat                           ✗ "#"
⋅⋅⋅⋅⋅⋅•dat                       ✓ "\u0000".." " ⇒  "⋅"
⋅⋅⋅⋅⋅•data                   ✓ space ⇒  "⋅"
⋅⋅⋅⋅⋅•data                     ✓ comment ⇒  "⋅"
⋅⋅⋅⋅⋅•data                       ✗ comment
⋅⋅⋅⋅⋅•data                         ✗ "#" notnl* nl
⋅⋅⋅⋅⋅•data                           ✗ "#"
⋅⋅⋅⋅⋅•data                       ✓ "\u0000".." " ⇒  "⋅"
⋅⋅⋅⋅•data⋅                   ✓ space ⇒  "⋅"
⋅⋅⋅⋅•data⋅                     ✓ comment ⇒  "⋅"
⋅⋅⋅⋅•data⋅                       ✗ comment
⋅⋅⋅⋅•data⋅                         ✗ "#" notnl* nl
⋅⋅⋅⋅•data⋅                           ✗ "#"
⋅⋅⋅⋅•data⋅                       ✓ "\u0000".." " ⇒  "⋅"
⋅⋅⋅•data⋅=                   ✓ space ⇒  "⋅"
⋅⋅⋅•data⋅=                     ✓ comment ⇒  "⋅"
⋅⋅⋅•data⋅=                       ✗ comment
⋅⋅⋅•data⋅=                         ✗ "#" notnl* nl
⋅⋅⋅•data⋅=                           ✗ "#"
⋅⋅⋅•data⋅=                       ✓ "\u0000".." " ⇒  "⋅"
⋅⋅•data⋅=⋅                   ✓ space ⇒  "⋅"
⋅⋅•data⋅=⋅                     ✓ comment ⇒  "⋅"
⋅⋅•data⋅=⋅                       ✗ comment
⋅⋅•data⋅=⋅                         ✗ "#" notnl* nl
⋅⋅•data⋅=⋅                           ✗ "#"
⋅⋅•data⋅=⋅                       ✓ "\u0000".." " ⇒  "⋅"
⋅•data⋅=⋅ϕ                   ✓ space ⇒  "⋅"
⋅•data⋅=⋅ϕ                     ✓ comment ⇒  "⋅"
⋅•data⋅=⋅ϕ                       ✗ comment
⋅•data⋅=⋅ϕ                         ✗ "#" notnl* nl
⋅•data⋅=⋅ϕ                           ✗ "#"
⋅•data⋅=⋅ϕ                       ✓ "\u0000".." " ⇒  "⋅"
•data⋅=⋅ϕ␊                   ✗ space
•data⋅=⋅ϕ␊                     ✗ comment
•data⋅=⋅ϕ␊                       ✗ comment
•data⋅=⋅ϕ␊                         ✗ "#" notnl* nl
•data⋅=⋅ϕ␊                           ✗ "#"
•data⋅=⋅ϕ␊                       ✗ "\u0000".." "
•data⋅=⋅ϕ␊               ✗ Definit
•data⋅=⋅ϕ␊                 ✗ InitStatement+
•data⋅=⋅ϕ␊                   ✓ spaces ⇒  ""
•data⋅=⋅ϕ␊                     ✓ space_A ⇒  ""
•data⋅=⋅ϕ␊                       ✗ space
•data⋅=⋅ϕ␊                         ✗ comment
•data⋅=⋅ϕ␊                           ✗ comment
•data⋅=⋅ϕ␊                             ✗ "#" notnl* nl
•data⋅=⋅ϕ␊                               ✗ "#"
•data⋅=⋅ϕ␊                           ✗ "\u0000".." "
•data⋅=⋅ϕ␊                   ✗ InitStatement
•data⋅=⋅ϕ␊                     ✗ kw<"•"> ident "=" Exp
•data⋅=⋅ϕ␊                       ✓ spaces ⇒  ""
•data⋅=⋅ϕ␊                         ✓ space_A ⇒  ""
•data⋅=⋅ϕ␊                           ✗ space
•data⋅=⋅ϕ␊                             ✗ comment
•data⋅=⋅ϕ␊                               ✗ comment
•data⋅=⋅ϕ␊                                 ✗ "#" notnl* nl
•data⋅=⋅ϕ␊                                   ✗ "#"
•data⋅=⋅ϕ␊                               ✗ "\u0000".." "
•data⋅=⋅ϕ␊                       ✗ kw<"•">
•data⋅=⋅ϕ␊                         ✗ s ~identTail
•data⋅=⋅ϕ␊                           ✓ $0 ⇒  "•"
•data⋅=⋅ϕ␊                             ✓ "•" ⇒  "•"
data⋅=⋅ϕ␊⋅                           ✗ ~identTail
data⋅=⋅ϕ␊⋅                             ✓ identTail ⇒  "d"
data⋅=⋅ϕ␊⋅                                 ✓ alnum ⇒  "d"
data⋅=⋅ϕ␊⋅                                     ✓ letter ⇒  "d"
data⋅=⋅ϕ␊⋅                                         ✓ lower ⇒  "d"
data⋅=⋅ϕ␊⋅                                           ✓ Unicode [Ll] character ⇒  "d"
defclass⋅D         ✓ spaces ⇒  ""
defclass⋅D           ✓ space_A ⇒  ""
defclass⋅D             ✗ space
defclass⋅D               ✗ comment
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ "#" notnl* nl
defclass⋅D                     ✗ "#"
defclass⋅D                 ✗ "\u0000".." "
defclass⋅D         ✗ TopLevel_import
defclass⋅D           ✓ spaces ⇒  ""
defclass⋅D             ✓ space_A ⇒  ""
defclass⋅D               ✗ space
defclass⋅D                 ✗ comment
defclass⋅D                   ✗ comment
defclass⋅D                     ✗ "#" notnl* nl
defclass⋅D                       ✗ "#"
defclass⋅D                   ✗ "\u0000".." "
defclass⋅D           ✗ Import
defclass⋅D             ✗ kw<"import"> ident
defclass⋅D               ✓ spaces ⇒  ""
defclass⋅D                 ✓ space_A ⇒  ""
defclass⋅D                   ✗ space
defclass⋅D                     ✗ comment
defclass⋅D                       ✗ comment
defclass⋅D                         ✗ "#" notnl* nl
defclass⋅D                           ✗ "#"
defclass⋅D                       ✗ "\u0000".." "
defclass⋅D               ✗ kw<"import">
defclass⋅D                 ✗ s ~identTail
defclass⋅D                   ✗ $0
defclass⋅D                     ✗ "import"




