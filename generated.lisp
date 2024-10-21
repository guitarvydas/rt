

counter =  0⎩1⎭
⎩2⎭

digits = [⎩3⎭
"₀", "₁", "₂", "₃", "₄", "₅",⎩4⎭
"₆", "₇", "₈", "₉",⎩5⎭
"₁₀", "₁₁", "₁₂", "₁₃", "₁₄",⎩6⎭
"₁₅", "₁₆", "₁₇", "₁₈", "₁₉",⎩7⎭
"₂₀", "₂₁", "₂₂", "₂₃", "₂₄",⎩8⎭
"₂₅", "₂₆", "₂₇", "₂₈", "₂₉"]⎩9⎭
⎩10⎭
⎩11⎭

def gensymbol (s):⎩12⎭

  global counter⎩13⎭

  name_with_id =  str( s) + subscripted_digit ( counter) ⎩14⎭

  counter =  counter+ 1⎩15⎭

  return  name_with_id⎩16⎭
  ⎩17⎭

⎩18⎭

def subscripted_digit (n):⎩19⎭

  global digits⎩20⎭

  if ( n >=  0 and  n <=  29):⎩21⎭

    return  digits [ n]⎩22⎭

  else:⎩23⎭

    return  str( "₊") +  n ⎩24⎭
    ⎩25⎭

  ⎩26⎭

⎩27⎭

class Datum:
  def __init__ (self,):⎩28⎭

    self.data =  None ⎩29⎭

    self.clone =  None ⎩30⎭

    self.reclaim =  None ⎩31⎭

    self.srepr =  None ⎩32⎭

    self.kind =  None ⎩33⎭

    self.raw =  None ⎩34⎭
    ⎩35⎭

⎩36⎭

def new_datum_string (s):⎩37⎭

  d =  Datum ()⎩38⎭

  d. data =  s⎩39⎭

  d. clone =  lambda : clone_datum_string ( d)⎩40⎭

  d. reclaim =  lambda : reclaim_datum_string ( d)⎩41⎭

  d. srepr =  lambda : srepr_datum_string ( d)⎩42⎭

  d. raw =  lambda : raw_datum_string ( d)⎩43⎭

  d. kind =  lambda :  "string"⎩44⎭

  return  d⎩45⎭
  ⎩46⎭

⎩47⎭

def clone_datum_string (d):⎩48⎭

  d = new_datum_string ( d. data)⎩49⎭

  return  d⎩50⎭
  ⎩51⎭

⎩52⎭

def reclaim_datum_string (src):⎩53⎭

  pass⎩54⎭
  ⎩55⎭

⎩56⎭

def srepr_datum_string (d):⎩57⎭

  return  d. data⎩58⎭
  ⎩59⎭

⎩60⎭

def raw_datum_string (d):⎩61⎭

  return bytearray ( d. data, "UTF_8")⎩62⎭
  ⎩63⎭

⎩64⎭

def new_datum_bang ():⎩65⎭

  p = Datum ()⎩66⎭

  p. data =  True⎩67⎭

  p. clone =  lambda : clone_datum_bang ( p)⎩68⎭

  p. reclaim =  lambda : reclaim_datum_bang ( p)⎩69⎭

  p. srepr =  lambda : srepr_datum_bang ()⎩70⎭

  p. raw =  lambda : raw_datum_bang ()⎩71⎭

  p. kind =  lambda :  "bang"⎩72⎭

  return  p⎩73⎭
  ⎩74⎭

⎩75⎭

def clone_datum_bang (d):⎩76⎭

  return new_datum_bang ()⎩77⎭
  ⎩78⎭

⎩79⎭

def reclaim_datum_bang (d):⎩80⎭

  pass⎩81⎭
  ⎩82⎭

⎩83⎭

def srepr_datum_bang ():⎩84⎭

  return  "!"⎩85⎭
  ⎩86⎭

⎩87⎭

def raw_datum_bang ():⎩88⎭

  return []⎩89⎭
  ⎩90⎭

⎩91⎭

def new_datum_tick ():⎩92⎭

  p = new_datum_bang ()⎩93⎭

  p. kind =  lambda :  "tick"⎩94⎭

  p. clone =  lambda : new_datum_tick ()⎩95⎭

  p. srepr =  lambda : srepr_datum_tick ()⎩96⎭

  p. raw =  lambda : raw_datum_tick ()⎩97⎭

  return  p⎩98⎭
  ⎩99⎭

⎩100⎭

def srepr_datum_tick ():⎩101⎭

  return  "."⎩102⎭
  ⎩103⎭

⎩104⎭

def raw_datum_tick ():⎩105⎭

  return []⎩106⎭
  ⎩107⎭

⎩108⎭

def new_datum_bytes (b):⎩109⎭

  p = Datum ()⎩110⎭

  p. data =  b⎩111⎭

  p. clone =  clone_datum_bytes⎩112⎭

  p. reclaim =  lambda : reclaim_datum_bytes ( p)⎩113⎭

  p. srepr =  lambda : srepr_datum_bytes ( b)⎩114⎭

  p. raw =  lambda : raw_datum_bytes ( b)⎩115⎭

  p. kind =  lambda :  "bytes"⎩116⎭

  return  p⎩117⎭
  ⎩118⎭

⎩119⎭

def clone_datum_bytes (src):⎩120⎭

  p = Datum ()⎩121⎭

  p =  src⎩122⎭

  p. data =  src.clone ()⎩123⎭

  return  p⎩124⎭
  ⎩125⎭

⎩126⎭

def reclaim_datum_bytes (src):⎩127⎭

  pass⎩128⎭
  ⎩129⎭

⎩130⎭

def srepr_datum_bytes (d):⎩131⎭

  return  d. data.decode ( "UTF_8")⎩132⎭
  ⎩133⎭


def raw_datum_bytes (d):⎩134⎭

  return  d. data⎩135⎭
  ⎩136⎭

⎩137⎭

def new_datum_handle (h):⎩138⎭

  return new_datum_int ( h)⎩139⎭
  ⎩140⎭

⎩141⎭

def new_datum_int (i):⎩142⎭

  p = Datum ()⎩143⎭

  p. data =  i⎩144⎭

  p. clone =  lambda : clone_int ( i)⎩145⎭

  p. reclaim =  lambda : reclaim_int ( i)⎩146⎭

  p. srepr =  lambda : srepr_datum_int ( i)⎩147⎭

  p. raw =  lambda : raw_datum_int ( i)⎩148⎭

  p. kind =  lambda :  "int"⎩149⎭

  return  p⎩150⎭
  ⎩151⎭

⎩152⎭

def clone_int (i):⎩153⎭

  p = new_datum_int ( i)⎩154⎭

  return  p⎩155⎭
  ⎩156⎭

⎩157⎭

def reclaim_int (src):⎩158⎭

  pass⎩159⎭
  ⎩160⎭

⎩161⎭

def srepr_datum_int (i):⎩162⎭

  return str ( i)⎩163⎭
  ⎩164⎭

⎩165⎭

def raw_datum_int (i):⎩166⎭

  return  i⎩167⎭
  ⎩168⎭

⎩169⎭

#|                                                                              #line  Message passed to a leaf component. |#⎩170⎭

#|                                                                              #line  |#⎩171⎭

#|                                                                              #line  `port` refers to the name of the incoming or outgoing port of this component. |#⎩172⎭

#|                                                                              #line  `datum` is the data attached to this message. |#⎩173⎭

class Message:
  def __init__ (self,port,datum):⎩174⎭

    self.port =  port ⎩175⎭

    self.datum =  datum ⎩176⎭
    ⎩177⎭

⎩178⎭

def clone_port (s):⎩179⎭

  return clone_string ( s)⎩180⎭
  ⎩181⎭

⎩182⎭

#|                                                                              #line  Utility for making a `Message`. Used to safely “seed“ messages |#⎩183⎭

#|                                                                              #line  entering the very top of a network. |#⎩184⎭

def make_message (port,datum):⎩185⎭

  p = clone_string ( port)⎩186⎭

  m = Message (port= p,datum= datum.clone ())⎩187⎭

  return  m⎩188⎭
  ⎩189⎭

⎩190⎭

#|                                                                              #line  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |#⎩191⎭

def message_clone (message):⎩192⎭

  m = Message (port=clone_port ( message. port),datum= message. datum.clone ())⎩193⎭

  return  m⎩194⎭
  ⎩195⎭

⎩196⎭

#|                                                                              #line  Frees a message. |#⎩197⎭

def destroy_message (msg):⎩198⎭


  #|                                                                            #line  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |#⎩199⎭

  pass⎩200⎭
  ⎩201⎭

⎩202⎭

def destroy_datum (msg):⎩203⎭

  pass⎩204⎭
  ⎩205⎭

⎩206⎭

def destroy_port (msg):⎩207⎭

  pass⎩208⎭
  ⎩209⎭

⎩210⎭

#|                                                                              #line  |#⎩211⎭

def format_message (m):⎩212⎭

  if  m ==  None:⎩213⎭

    return  "ϕ"⎩214⎭

  else:⎩215⎭

    return  str( "⟪") +  str( m. port) +  str( "⦂") +  str( m. datum.srepr ()) +  "⟫"    ⎩219⎭
    ⎩220⎭

  ⎩221⎭

⎩222⎭

#|                                                                              #line  dynamic routing descriptors |#⎩223⎭
⎩224⎭

drInject =  "inject"⎩225⎭

drSend =  "send"⎩226⎭

drInOut =  "inout"⎩227⎭

drForward =  "forward"⎩228⎭

drDown =  "down"⎩229⎭

drUp =  "up"⎩230⎭

drAcross =  "across"⎩231⎭

drThrough =  "through"⎩232⎭
⎩233⎭

#|                                                                              #line  See “class_free programming“ starting at 45:01 of https://www.youtube.com/watch?v=XFTOG895C7c |#⎩234⎭
⎩235⎭
⎩236⎭

def make_Routing_Descriptor (action,component,port,message):⎩237⎭

  return {⎩238⎭
  "action": action,⎩239⎭
  "component": component,⎩240⎭
  "port": port,⎩241⎭
  "message": message⎩242⎭
  }⎩243⎭
  ⎩244⎭

⎩245⎭

#|                                                                              #line  |#⎩246⎭

def make_Send_Descriptor (component,port,message,cause_port,cause_message):⎩247⎭

  rdesc = make_Routing_Descriptor (action= drSend,component= component,port= port,message= message)⎩248⎭

  return {⎩249⎭
  "action": drSend,⎩250⎭
  "component": rdesc ["component"],⎩251⎭
  "port": rdesc ["port"],⎩252⎭
  "message": rdesc ["message"],⎩253⎭
  "cause_port": cause_port,⎩254⎭
  "cause_message": cause_message,⎩255⎭
  "fmt": fmt_send⎩256⎭
  }⎩257⎭
  ⎩258⎭

⎩259⎭

def log_send (sender,sender_port,msg,cause_msg):⎩260⎭

  send_desc = make_Send_Descriptor (component= sender,port= sender_port,message= msg,cause_port= cause_msg. port,cause_message= cause_msg)⎩261⎭

  append_routing_descriptor (container= sender. owner,desc= send_desc)⎩262⎭
  ⎩263⎭

⎩264⎭

def log_send_string (sender,sender_port,msg,cause_msg):⎩265⎭

  send_desc = make_Send_Descriptor ( sender, sender_port, msg, cause_msg. port, cause_msg)⎩266⎭

  append_routing_descriptor (container= sender. owner,desc= send_desc)⎩267⎭
  ⎩268⎭

⎩269⎭

def fmt_send (desc,indent):⎩270⎭

  return  ""⎩271⎭


  #|                                                                            #line return f;\n{indent}⋯ {desc@component.name}.“{desc@cause_port}“ ∴ {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |#⎩272⎭
  ⎩273⎭

⎩274⎭

def fmt_send_string (desc,indent):⎩275⎭

  return fmt_send ( desc, indent)⎩276⎭
  ⎩277⎭

⎩278⎭

#|                                                                              #line  |#⎩279⎭

def make_Forward_Descriptor (component,port,message,cause_port,cause_message):⎩280⎭

  rdesc = make_Routing_Descriptor (action= drSend,component= component,port= port,message= message)⎩281⎭

  fmt_forward =  lambda desc:  ""⎩282⎭

  return {⎩283⎭
  "action": drForward,⎩284⎭
  "component": rdesc ["component"],⎩285⎭
  "port": rdesc ["port"],⎩286⎭
  "message": rdesc ["message"],⎩287⎭
  "cause_port": cause_port,⎩288⎭
  "cause_message": cause_message,⎩289⎭
  "fmt": fmt_forward⎩290⎭
  }⎩291⎭
  ⎩292⎭

⎩293⎭

def log_forward (sender,sender_port,msg,cause_msg):⎩294⎭

  pass

  #|                                                                            #line  when needed, it is too frequent to bother logging |#⎩295⎭
  ⎩296⎭

⎩297⎭

def fmt_forward (desc):⎩298⎭

  print ( str( "*** Error fmt_forward ") +  desc )⎩299⎭

  quit ()⎩300⎭
  ⎩301⎭

⎩302⎭

#|                                                                              #line  |#⎩303⎭

def make_Inject_Descriptor (receiver,port,message):⎩304⎭

  rdesc = make_Routing_Descriptor (action= drInject,component= receiver,port= port,message= message)⎩305⎭

  return {⎩306⎭
  "action": drInject,⎩307⎭
  "component": rdesc ["component"],⎩308⎭
  "port": rdesc ["port"],⎩309⎭
  "message": rdesc ["message"],⎩310⎭
  "fmt": fmt_inject⎩311⎭
  }⎩312⎭
  ⎩313⎭

⎩314⎭

def log_inject (receiver,port,msg):⎩315⎭

  inject_desc = make_Inject_Descriptor (receiver= receiver,port= port,message= msg)⎩316⎭

  append_routing_descriptor (container= receiver,desc= inject_desc)⎩317⎭
  ⎩318⎭

⎩319⎭

def fmt_inject (desc,indent):⎩320⎭


  #|                                                                            #line return f'\n{indent}⟹  {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |#⎩321⎭

  return  str( "\n") +  str( indent) +  str( "⟹  ") +  str( desc ["component"]. name) +  str( ".") +  str( desc ["port"]) +  str( " ") + format_message ( desc ["message"])       ⎩328⎭
  ⎩329⎭

⎩330⎭

#|                                                                              #line  |#⎩331⎭

def make_Down_Descriptor (container,source_port,source_message,target,target_port,target_message):⎩332⎭

  return {⎩333⎭
  "action": drDown,⎩334⎭
  "container": container,⎩335⎭
  "source_port": source_port,⎩336⎭
  "source_message": source_message,⎩337⎭
  "target": target,⎩338⎭
  "target_port": target_port,⎩339⎭
  "target_message": target_message,⎩340⎭
  "fmt": fmt_down⎩341⎭
  }⎩342⎭
  ⎩343⎭

⎩344⎭

def log_down (container,source_port,source_message,target,target_port,target_message):⎩345⎭

  rdesc = make_Down_Descriptor ( container, source_port, source_message, target, target_port, target_message)⎩346⎭

  append_routing_descriptor ( container, rdesc)⎩347⎭
  ⎩348⎭

⎩349⎭

def fmt_down (desc,indent):⎩350⎭


  #|                                                                            #line return f'\n{indent}↓ {desc@container.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“ {format_message (desc@target_message)}' |#⎩351⎭

  return  str( "\n") +  str( indent) +  str( " ↓ ") +  str( desc ["container"]. name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"]. name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + format_message ( desc ["target_message"])           ⎩362⎭
  ⎩363⎭

⎩364⎭

#|                                                                              #line  |#⎩365⎭

def make_Up_Descriptor (source,source_port,source_message,container,container_port,container_message):⎩366⎭

  return {⎩367⎭
  "action": drUp,⎩368⎭
  "source": source,⎩369⎭
  "source_port": source_port,⎩370⎭
  "source_message": source_message,⎩371⎭
  "container": container,⎩372⎭
  "container_port": container_port,⎩373⎭
  "container_message": container_message,⎩374⎭
  "fmt": fmt_up⎩375⎭
  }⎩376⎭
  ⎩377⎭

⎩378⎭

def log_up (source,source_port,source_message,container,target_port,target_message):⎩379⎭

  rdesc = make_Up_Descriptor ( source, source_port, source_message, container, target_port, target_message)⎩380⎭

  append_routing_descriptor ( container, rdesc)⎩381⎭
  ⎩382⎭

⎩383⎭

def fmt_up (desc,indent):⎩384⎭


  #|                                                                            #line return f'\n{indent}↑ {desc@source.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@container_port}“ {format_message (desc@container_message)}' |#⎩385⎭

  return  str( "\n") +  str( indent) +  str( "↑ ") +  str( desc ["source"]. name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"]. name) +  str( ".") +  str( desc ["container_port"]) +  str( " ") + format_message ( desc ["container_message"])           ⎩396⎭
  ⎩397⎭

⎩398⎭

def make_Across_Descriptor (container,source,source_port,source_message,target,target_port,target_message):⎩399⎭

  return {⎩400⎭
  "action": drAcross,⎩401⎭
  "container": container,⎩402⎭
  "source": source,⎩403⎭
  "source_port": source_port,⎩404⎭
  "source_message": source_message,⎩405⎭
  "target": target,⎩406⎭
  "target_port": target_port,⎩407⎭
  "target_message": target_message,⎩408⎭
  "fmt": fmt_across⎩409⎭
  }⎩410⎭
  ⎩411⎭

⎩412⎭

def log_across (container,source,source_port,source_message,target,target_port,target_message):⎩413⎭

  rdesc = make_Across_Descriptor ( container, source, source_port, source_message, target, target_port, target_message)⎩414⎭

  append_routing_descriptor ( container, rdesc)⎩415⎭
  ⎩416⎭

⎩417⎭

def fmt_across (desc,indent):⎩418⎭


  #|                                                                            #line return f'\n{indent}→ {desc@source.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“  {format_message (desc@target_message)}' |#⎩419⎭

  return  str( "\n") +  str( indent) +  str( "→ ") +  str( desc ["source"]. name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"]. name) +  str( ".") +  str( desc ["target_port"]) +  str( "  ") + format_message ( desc ["target_message"])           ⎩430⎭
  ⎩431⎭

⎩432⎭

#|                                                                              #line  |#⎩433⎭

def make_Through_Descriptor (container,source_port,source_message,target_port,message):⎩434⎭

  return {⎩435⎭
  "action": drThrough,⎩436⎭
  "container": container,⎩437⎭
  "source_port": source_port,⎩438⎭
  "source_message": source_message,⎩439⎭
  "target_port": target_port,⎩440⎭
  "message": message,⎩441⎭
  "fmt": fmt_through⎩442⎭
  }⎩443⎭
  ⎩444⎭

⎩445⎭

def log_through (container,source_port,source_message,target_port,message):⎩446⎭

  rdesc = make_Through_Descriptor ( container, source_port, source_message, target_port, message)⎩447⎭

  append_routing_descriptor ( container, rdesc)⎩448⎭
  ⎩449⎭

⎩450⎭

def fmt_through (desc,indent):⎩451⎭


  #|                                                                            #line return f'\n{indent}⇶ {desc @container.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@target_port}“ {format_message (desc@message)}' |#⎩452⎭

  return  str( "\n") +  str( indent) +  str( "⇶ ") +  str( desc ["container"]. name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"]. name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + format_message ( desc ["message"])           ⎩463⎭
  ⎩464⎭

⎩465⎭

#|                                                                              #line  |#⎩466⎭

def make_InOut_Descriptor (container,component,in_message,out_port,out_message):⎩467⎭

  return {⎩468⎭
  "action": drInOut,⎩469⎭
  "container": container,⎩470⎭
  "component": component,⎩471⎭
  "in_message": in_message,⎩472⎭
  "out_message": out_message,⎩473⎭
  "fmt": fmt_inout⎩474⎭
  }⎩475⎭
  ⎩476⎭

⎩477⎭

def log_inout (container,component,in_message):⎩478⎭

  if  component. outq.empty ():⎩479⎭

    log_inout_no_output (container= container,component= component,in_message= in_message)⎩480⎭

  else:⎩481⎭

    log_inout_recursively (container= container,component= component,in_message= in_message,out_messages=list ( component. outq. queue))⎩482⎭

  ⎩483⎭

⎩484⎭

def log_inout_no_output (container,component,in_message):⎩485⎭

  rdesc = make_InOut_Descriptor (container= container,component= component,in_message= in_message,⎩486⎭
  out_port= None,out_message= None)⎩487⎭

  append_routing_descriptor ( container, rdesc)⎩488⎭
  ⎩489⎭

⎩490⎭

def log_inout_single (container,component,in_message,out_message):⎩491⎭

  rdesc = make_InOut_Descriptor (container= container,component= component,in_message= in_message,⎩492⎭
  out_port= None,out_message= out_message)⎩493⎭

  append_routing_descriptor ( container, rdesc)⎩494⎭
  ⎩495⎭

⎩496⎭

def log_inout_recursively (container,component,in_message,out_messages=[]):⎩497⎭

  if [] ==  out_messages:⎩498⎭

    pass⎩499⎭

  else:⎩500⎭

    m =   out_messages[0] ⎩501⎭

    rest =   out_messages[1:] ⎩502⎭

    log_inout_single (container= container,component= component,in_message= in_message,out_message= m)⎩503⎭

    log_inout_recursively (container= container,component= component,in_message= in_message,out_messages= rest)⎩504⎭

  ⎩505⎭

⎩506⎭

def fmt_inout (desc,indent):⎩507⎭

  outm =  desc ["out_message"]⎩508⎭

  if  None ==  outm:⎩509⎭

    return  str( "\n") +  str( indent) +  "  ⊥"  ⎩510⎭

  else:⎩511⎭

    return  str( "\n") +  str( indent) +  str( "  ∴ ") +  str( desc ["component"]. name) +  str( " ") + format_message ( outm)     ⎩516⎭
    ⎩517⎭

  ⎩518⎭

⎩519⎭

def log_tick (container,component,in_message):⎩520⎭

  pass⎩521⎭
  ⎩522⎭

⎩523⎭

#|                                                                              #line  |#⎩524⎭

def routing_trace_all (container):⎩525⎭

  indent =  ""⎩526⎭

  lis = list ( container. routings. queue)⎩527⎭

  return recursive_routing_trace ( container, lis, indent)⎩528⎭
  ⎩529⎭

⎩530⎭

def recursive_routing_trace (container,lis,indent):⎩531⎭

  if [] ==  lis:⎩532⎭

    return  ""⎩533⎭

  else:⎩534⎭

    desc = first ( lis)⎩535⎭

    formatted =  desc ["fmt"] ( desc, indent)⎩536⎭

    return  formatted+recursive_routing_trace ( container,rest ( lis), indent+ "  ")⎩537⎭

  ⎩538⎭

⎩539⎭

enumDown =  0⎩540⎭

enumAcross =  1⎩541⎭

enumUp =  2⎩542⎭

enumThrough =  3⎩543⎭
⎩544⎭

def container_instantiator (reg,owner,container_name,desc):⎩545⎭

  global enumDown, enumUp, enumAcross, enumThrough⎩546⎭

  container = make_container ( container_name, owner)⎩547⎭

  children = []⎩548⎭

  children_by_id = {}

  #|                                                                            #line  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |#⎩549⎭


  #|                                                                            #line  collect children |#⎩550⎭

  for child_desc in  desc ["children"]:⎩551⎭

    child_instance = get_component_instance ( reg, child_desc ["name"], container)⎩552⎭

    children.append ( child_instance)⎩553⎭

    children_by_id [ child_desc ["id"]] =  child_instance⎩554⎭


  container. children =  children⎩555⎭

  me =  container⎩556⎭
  ⎩557⎭

  connectors = []⎩558⎭

  for proto_conn in  desc ["connections"]:⎩559⎭

    source_component =  None⎩560⎭

    target_component =  None⎩561⎭

    connector = Connector ()⎩562⎭

    if  proto_conn ["dir"] ==  enumDown:⎩563⎭


      #|                                                                        #line  JSON: {'dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |#⎩564⎭

      connector. direction =  "down"⎩565⎭

      connector. sender = Sender ( me. name, me, proto_conn ["source_port"])⎩566⎭

      target_component =  children_by_id [ proto_conn ["target"] ["id"]]⎩567⎭

      if ( target_component ==  None):⎩568⎭

        load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn ["target"] )⎩569⎭

      else:⎩570⎭

        connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)⎩571⎭

        connectors.append ( connector)
      ⎩572⎭

    elif  proto_conn ["dir"] ==  enumAcross:⎩573⎭

      connector. direction =  "across"⎩574⎭

      source_component =  children_by_id [ proto_conn ["source"] ["id"]]⎩575⎭

      target_component =  children_by_id [ proto_conn ["target"] ["id"]]⎩576⎭

      if  source_component ==  None:⎩577⎭

        load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn ["source"] )⎩578⎭

      else:⎩579⎭

        connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])⎩580⎭

        if  target_component ==  None:⎩581⎭

          load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn. target )⎩582⎭

        else:⎩583⎭

          connector. receiver = Receiver ( target_component. name, target_component. inq, proto_conn ["target_port"], target_component)⎩584⎭

          connectors.append ( connector)

      ⎩585⎭

    elif  proto_conn ["dir"] ==  enumUp:⎩586⎭

      connector. direction =  "up"⎩587⎭

      source_component =  children_by_id [ proto_conn ["source"] ["id"]]⎩588⎭

      if  source_component ==  None:⎩589⎭

        print ( str( "internal error: .Up connection source not ok ") +  proto_conn ["source"] )⎩590⎭

      else:⎩591⎭

        connector. sender = Sender ( source_component. name, source_component, proto_conn ["source_port"])⎩592⎭

        connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)⎩593⎭

        connectors.append ( connector)
      ⎩594⎭

    elif  proto_conn ["dir"] ==  enumThrough:⎩595⎭

      connector. direction =  "through"⎩596⎭

      connector. sender = Sender ( me. name, me, proto_conn ["source_port"])⎩597⎭

      connector. receiver = Receiver ( me. name, container. outq, proto_conn ["target_port"], me)⎩598⎭

      connectors.append ( connector)
    ⎩599⎭

  ⎩600⎭

  container. connections =  connectors⎩601⎭

  return  container⎩602⎭
  ⎩603⎭

⎩604⎭

#|                                                                              #line  The default handler for container components. |#⎩605⎭

def container_handler (container,message):⎩606⎭

  route (container= container,from_component= container,message= message)

  #|                                                                            #line  references to 'self' are replaced by the container during instantiation |#⎩607⎭

  while any_child_ready ( container):⎩608⎭

    step_children ( container, message)⎩609⎭

  ⎩610⎭

⎩611⎭

#|                                                                              #line  Frees the given container and associated data. |#⎩612⎭

def destroy_container (eh):⎩613⎭

  pass⎩614⎭
  ⎩615⎭

⎩616⎭

def fifo_is_empty (fifo):⎩617⎭

  return  fifo.empty ()⎩618⎭
  ⎩619⎭

⎩620⎭

#|                                                                              #line  Routing connection for a container component. The `direction` field has |#⎩621⎭

#|                                                                              #line  no affect on the default message routing system _ it is there for debugging |#⎩622⎭

#|                                                                              #line  purposes, or for reading by other tools. |#⎩623⎭
⎩624⎭

class Connector:
  def __init__ (self,):⎩625⎭

    self.direction =  None
    #|                                                                          #line  down, across, up, through |#⎩626⎭

    self.sender =  None ⎩627⎭

    self.receiver =  None ⎩628⎭
    ⎩629⎭

⎩630⎭

#|                                                                              #line  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |#⎩631⎭

#|                                                                              #line  based on component ID (pointer) and port name. |#⎩632⎭
⎩633⎭

class Sender:
  def __init__ (self,name,component,port):⎩634⎭

    self.name =  name ⎩635⎭

    self.component =  component
    #|                                                                          #line  from |#⎩636⎭

    self.port =  port
    #|                                                                          #line  from's port |#⎩637⎭
    ⎩638⎭

⎩639⎭

#|                                                                              #line  `Receiver` is a handle to a destination queue, and a `port` name to assign |#⎩640⎭

#|                                                                              #line  to incoming messages to this queue. |#⎩641⎭
⎩642⎭

class Receiver:
  def __init__ (self,name,queue,port,component):⎩643⎭

    self.name =  name ⎩644⎭

    self.queue =  queue
    #|                                                                          #line  queue (input | output) of receiver |#⎩645⎭

    self.port =  port
    #|                                                                          #line  destination port |#⎩646⎭

    self.component =  component
    #|                                                                          #line  to (for bootstrap debug) |#⎩647⎭
    ⎩648⎭

⎩649⎭

#|                                                                              #line  Checks if two senders match, by pointer equality and port name matching. |#⎩650⎭

def sender_eq (s1,s2):⎩651⎭

  same_components = ( s1. component ==  s2. component)⎩652⎭

  same_ports = ( s1. port ==  s2. port)⎩653⎭

  return  same_components and  same_ports⎩654⎭
  ⎩655⎭

⎩656⎭

#|                                                                              #line  Delivers the given message to the receiver of this connector. |#⎩657⎭
⎩658⎭

def deposit (parent,conn,message):⎩659⎭

  new_message = make_message (port= conn. receiver. port,datum= message. datum)⎩660⎭

  log_connection ( parent, conn, new_message)⎩661⎭

  push_message ( parent, conn. receiver. component, conn. receiver. queue, new_message)⎩662⎭
  ⎩663⎭

⎩664⎭

def force_tick (parent,eh):⎩665⎭

  tick_msg = make_message ( ".",new_datum_tick ())⎩666⎭

  push_message ( parent, eh, eh. inq, tick_msg)⎩667⎭

  return  tick_msg⎩668⎭
  ⎩669⎭

⎩670⎭

def push_message (parent,receiver,inq,m):⎩671⎭

  inq.put ( m)⎩672⎭

  parent. visit_ordering.put ( receiver)⎩673⎭
  ⎩674⎭

⎩675⎭

def is_self (child,container):⎩676⎭


  #|                                                                            #line  in an earlier version “self“ was denoted as ϕ |#⎩677⎭

  return  child ==  container⎩678⎭
  ⎩679⎭

⎩680⎭

def step_child (child,msg):⎩681⎭

  before_state =  child. state⎩682⎭

  child.handler ( child, msg)⎩683⎭

  after_state =  child. state⎩684⎭

  return [ before_state ==  "idle" and  after_state!= "idle",⎩685⎭
  before_state!= "idle" and  after_state!= "idle",⎩686⎭
  before_state!= "idle" and  after_state ==  "idle"]⎩687⎭
  ⎩688⎭

⎩689⎭

def save_message (eh,msg):⎩690⎭

  eh. saved_messages.put ( msg)⎩691⎭
  ⎩692⎭

⎩693⎭

def fetch_saved_message_and_clear (eh):⎩694⎭

  return  eh. saved_messages.get ()⎩695⎭
  ⎩696⎭

⎩697⎭

def step_children (container,causingMessage):⎩698⎭

  container. state =  "idle"⎩699⎭

  for child in list ( container. visit_ordering. queue):⎩700⎭


    #|                                                                          #line  child = container represents self, skip it |#⎩701⎭

    if (not (is_self ( child, container))):⎩702⎭

      if (not ( child. inq.empty ())):⎩703⎭

        msg =  child. inq.get ()⎩704⎭

        [ began_long_run, continued_long_run, ended_long_run] = step_child ( child, msg)⎩705⎭

        if  began_long_run:⎩706⎭

          save_message ( child, msg)⎩707⎭

        elif  continued_long_run:⎩708⎭

          pass⎩709⎭

        elif  ended_long_run:⎩710⎭

          log_inout (container= container,component= child,in_message=fetch_saved_message_and_clear ( child))⎩711⎭

        else:⎩712⎭

          log_inout (container= container,component= child,in_message= msg)⎩713⎭


        destroy_message ( msg)⎩714⎭

      else:⎩715⎭

        if  child. state!= "idle":⎩716⎭

          msg = force_tick ( container, child)⎩717⎭

          child.handler ( child, msg)⎩718⎭

          log_tick (container= container,component= child,in_message= msg)⎩719⎭

          destroy_message ( msg)
        ⎩720⎭

      ⎩721⎭

      if  child. state ==  "active":⎩722⎭


        #|                                                                      #line  if child remains active, then the container must remain active and must propagate “ticks“ to child |#⎩723⎭

        container. state =  "active"⎩724⎭

      ⎩725⎭

      while (not ( child. outq.empty ())):⎩726⎭

        msg =  child. outq.get ()⎩727⎭

        route ( container, child, msg)⎩728⎭

        destroy_message ( msg)

    ⎩729⎭

  ⎩730⎭
  ⎩731⎭
  ⎩732⎭

⎩733⎭

def attempt_tick (parent,eh):⎩734⎭

  if  eh. state!= "idle":⎩735⎭

    force_tick ( parent, eh)⎩736⎭

  ⎩737⎭

⎩738⎭

def is_tick (msg):⎩739⎭

  return  "tick" ==  msg. datum.kind ()⎩740⎭
  ⎩741⎭

⎩742⎭

#|                                                                              #line  Routes a single message to all matching destinations, according to |#⎩743⎭

#|                                                                              #line  the container's connection network. |#⎩744⎭
⎩745⎭

def route (container,from_component,message):⎩746⎭

  was_sent =  False

  #|                                                                            #line  for checking that output went somewhere (at least during bootstrap) |#⎩747⎭

  fromname =  ""⎩748⎭

  if is_tick ( message):⎩749⎭

    for child in  container. children:⎩750⎭

      attempt_tick ( container, child, message)⎩751⎭


    was_sent =  True⎩752⎭

  else:⎩753⎭

    if (not (is_self ( from_component, container))):⎩754⎭

      fromname =  from_component. name⎩755⎭


    from_sender = Sender (name= fromname,component= from_component,port= message. port)⎩756⎭
    ⎩757⎭

    for connector in  container. connections:⎩758⎭

      if sender_eq ( from_sender, connector. sender):⎩759⎭

        deposit ( container, connector, message)⎩760⎭

        was_sent =  True

    ⎩761⎭


  if not ( was_sent):⎩762⎭

    print ( "\n\n*** Error: ***")⎩763⎭

    dump_possible_connections ( container)⎩764⎭

    print_routing_trace ( container)⎩765⎭

    print ( "***")⎩766⎭

    print ( str( container. name) +  str( ": message '") +  str( message. port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )⎩767⎭

    print ( "***")⎩768⎭

    exit ()⎩769⎭

  ⎩770⎭

⎩771⎭

def dump_possible_connections (container):⎩772⎭

  print ( str( "*** possible connections for ") +  str( container. name) +  ":"  )⎩773⎭

  for connector in  container. connections:⎩774⎭

    print ( str( connector. direction) +  str( " ") +  str( connector. sender. name) +  str( ".") +  str( connector. sender. port) +  str( " -> ") +  str( connector. receiver. name) +  str( ".") +  connector. receiver. port        )⎩775⎭

  ⎩776⎭

⎩777⎭

def any_child_ready (container):⎩778⎭

  for child in  container. children:⎩779⎭

    if child_is_ready ( child):⎩780⎭

      return  True
    ⎩781⎭


  return  False⎩782⎭
  ⎩783⎭

⎩784⎭

def child_is_ready (eh):⎩785⎭

  return (not ( eh. outq.empty ())) or (not ( eh. inq.empty ())) or ( eh. state!= "idle") or (any_child_ready ( eh))⎩786⎭
  ⎩787⎭

⎩788⎭

def print_routing_trace (eh):⎩789⎭

  print (routing_trace_all ( eh))⎩790⎭
  ⎩791⎭

⎩792⎭

def append_routing_descriptor (container,desc):⎩793⎭

  container. routings.put ( desc)⎩794⎭
  ⎩795⎭

⎩796⎭

def log_connection (container,connector,message):⎩797⎭

  if  "down" ==  connector. direction:⎩798⎭

    log_down (container= container,⎩799⎭
    source_port= connector. sender. port,⎩800⎭
    source_message= None,⎩801⎭
    target= connector. receiver. component,⎩802⎭
    target_port= connector. receiver. port,⎩803⎭
    target_message= message)⎩804⎭

  elif  "up" ==  connector. direction:⎩805⎭

    log_up (source= connector. sender. component,source_port= connector. sender. port,source_message= None,container= container,target_port= connector. receiver. port,⎩806⎭
    target_message= message)⎩807⎭

  elif  "across" ==  connector. direction:⎩808⎭

    log_across (container= container,⎩809⎭
    source= connector. sender. component,source_port= connector. sender. port,source_message= None,⎩810⎭
    target= connector. receiver. component,target_port= connector. receiver. port,target_message= message)⎩811⎭

  elif  "through" ==  connector. direction:⎩812⎭

    log_through (container= container,source_port= connector. sender. port,source_message= None,⎩813⎭
    target_port= connector. receiver. port,message= message)⎩814⎭

  else:⎩815⎭

    print ( str( "*** FATAL error: in log_connection /") +  str( connector. direction) +  str( "/ /") +  str( message. port) +  str( "/ /") +  str( message. datum.srepr ()) +  "/"      )⎩816⎭

    exit ()⎩817⎭

  ⎩818⎭

⎩819⎭

def container_injector (container,message):⎩820⎭

  log_inject (receiver= container,port= message. port,msg= message)⎩821⎭

  container_handler ( container, message)⎩822⎭
  ⎩823⎭

⎩824⎭







import os⎩1⎭

import json⎩2⎭

import sys⎩3⎭
⎩4⎭
⎩5⎭

class Component_Registry:
  def __init__ (self,):⎩6⎭

    self.templates = {} ⎩7⎭
    ⎩8⎭

⎩9⎭

class Template:
  def __init__ (self,name,template_data,instantiator):⎩10⎭

    self.name =  name ⎩11⎭

    self.template_data =  template_data ⎩12⎭

    self.instantiator =  instantiator ⎩13⎭
    ⎩14⎭

⎩15⎭

def read_and_convert_json_file (filename):⎩16⎭

  try:
    fil = open(filename, "r")
    json_data = fil.read()
    routings = json.loads(json_data)
    fil.close ()
    return routings
  except FileNotFoundError:
    print (f"File not found: '{filename}'")
    return None
  except json.JSONDecodeError as e:
    print ("Error decoding JSON in file: '{e}'")
    return None
  ⎩17⎭
  ⎩18⎭

⎩19⎭

def json2internal (container_xml):⎩20⎭

  fname =  os. path.basename ( container_xml)⎩21⎭

  routings = read_and_convert_json_file ( fname)⎩22⎭

  return  routings⎩23⎭
  ⎩24⎭

⎩25⎭

def delete_decls (d):⎩26⎭

  pass⎩27⎭
  ⎩28⎭

⎩29⎭

def make_component_registry ():⎩30⎭

  return Component_Registry ()⎩31⎭
  ⎩32⎭

⎩33⎭

def register_component (reg,template,ok_to_overwrite= False):⎩34⎭

  name = mangle_name ( template. name)⎩35⎭

  if  name in  reg. templates and not  ok_to_overwrite:⎩36⎭

    load_error ( str( "Component ") +  str( template. name) +  " already declared"  )⎩37⎭


  reg. templates [ name] =  template⎩38⎭

  return  reg⎩39⎭
  ⎩40⎭

⎩41⎭

def register_multiple_components (reg,templates):⎩42⎭

  for template in  templates:⎩43⎭

    register_component ( reg, template)⎩44⎭

  ⎩45⎭

⎩46⎭

def get_component_instance (reg,full_name,owner):⎩47⎭

  template_name = mangle_name ( full_name)⎩48⎭

  if  template_name in  reg. templates:⎩49⎭

    template =  reg. templates [ template_name]⎩50⎭

    if ( template ==  None):⎩51⎭

      load_error ( str( "Registry Error: Can;t find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )⎩52⎭

      return  None⎩53⎭

    else:⎩54⎭

      owner_name =  ""⎩55⎭

      instance_name =  template_name⎩56⎭

      if  None!= owner:⎩57⎭

        owner_name =  owner. name⎩58⎭

        instance_name =  str( owner_name) +  str( ".") +  template_name  ⎩59⎭

      else:⎩60⎭

        instance_name =  template_name⎩61⎭


      instance =  template.instantiator ( reg, owner, instance_name, template. template_data)⎩62⎭

      instance. depth = calculate_depth ( instance)⎩63⎭

      return  instance
    ⎩64⎭

  else:⎩65⎭

    load_error ( str( "Registry Error: Can't find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )⎩66⎭

    return  None⎩67⎭

  ⎩68⎭


def calculate_depth (eh):⎩69⎭

  if  eh. owner ==  None:⎩70⎭

    return  0⎩71⎭

  else:⎩72⎭

    return  1+calculate_depth ( eh. owner)⎩73⎭

  ⎩74⎭

⎩75⎭

def dump_registry (reg):⎩76⎭

  print ()⎩77⎭

  print ( "*** PALETTE ***")⎩78⎭

  for c in  reg. templates:⎩79⎭

    print ( c. name)⎩80⎭


  print ( "***************")⎩81⎭

  print ()⎩82⎭
  ⎩83⎭

⎩84⎭

def print_stats (reg):⎩85⎭

  print ( str( "registry statistics: ") +  reg. stats )⎩86⎭
  ⎩87⎭

⎩88⎭

def mangle_name (s):⎩89⎭


  #|                                                                            #line  trim name to remove code from Container component names _ deferred until later (or never) |#⎩90⎭

  return  s⎩91⎭
  ⎩92⎭

⎩93⎭

import subprocess⎩94⎭

def generate_shell_components (reg,container_list):⎩95⎭


  #|                                                                            #line  [ |#⎩96⎭


  #|                                                                            #line      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |#⎩97⎭


  #|                                                                            #line      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |#⎩98⎭


  #|                                                                            #line  ] |#⎩99⎭

  if  None!= container_list:⎩100⎭

    for diagram in  container_list:⎩101⎭


      #|                                                                        #line  loop through every component in the diagram and look for names that start with “$“ |#⎩102⎭


      #|                                                                        #line  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |#⎩103⎭

      for child_descriptor in  diagram ["children"]:⎩104⎭

        if first_char_is ( child_descriptor ["name"], "$"):⎩105⎭

          name =  child_descriptor ["name"]⎩106⎭

          cmd =   name[1:] .strip ()⎩107⎭

          generated_leaf = Template (name= name,instantiator= shell_out_instantiate,template_data= cmd)⎩108⎭

          register_component ( reg, generated_leaf)⎩109⎭

        elif first_char_is ( child_descriptor ["name"], "'"):⎩110⎭

          name =  child_descriptor ["name"]⎩111⎭

          s =   name[1:] ⎩112⎭

          generated_leaf = Template (name= name,instantiator= string_constant_instantiate,template_data= s)⎩113⎭

          register_component ( reg, generated_leaf,ok_to_overwrite= True)


    ⎩114⎭

  ⎩115⎭

⎩116⎭

def first_char (s):⎩117⎭

  return   s[0] ⎩118⎭
  ⎩119⎭

⎩120⎭

def first_char_is (s,c):⎩121⎭

  return  c == first_char ( s)⎩122⎭
  ⎩123⎭

⎩124⎭

#|                                                                              #line  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |#⎩125⎭

#|                                                                              #line  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |#⎩126⎭

def run_command (eh,cmd,s):⎩127⎭

  ret =  subprocess.run ( cmd,capture_output= True,input= s,encoding= "UTF_8")⎩128⎭

  if not ( ret. returncode ==  0):⎩129⎭

    if  ret. stderr!= None:⎩130⎭

      return [ "", ret. stderr]⎩131⎭

    else:⎩132⎭

      return [ "", str( "error in shell_out ") +  ret. returncode ]
    ⎩133⎭

  else:⎩134⎭

    return [ ret. stdout, None]⎩135⎭

  ⎩136⎭

⎩137⎭

#|                                                                              #line  Data for an asyncronous component _ effectively, a function with input |#⎩138⎭

#|                                                                              #line  and output queues of messages. |#⎩139⎭

#|                                                                              #line  |#⎩140⎭

#|                                                                              #line  Components can either be a user_supplied function (“lea“), or a “container“ |#⎩141⎭

#|                                                                              #line  that routes messages to child components according to a list of connections |#⎩142⎭

#|                                                                              #line  that serve as a message routing table. |#⎩143⎭

#|                                                                              #line  |#⎩144⎭

#|                                                                              #line  Child components themselves can be leaves or other containers. |#⎩145⎭

#|                                                                              #line  |#⎩146⎭

#|                                                                              #line  `handler` invokes the code that is attached to this component. |#⎩147⎭

#|                                                                              #line  |#⎩148⎭

#|                                                                              #line  `instance_data` is a pointer to instance data that the `leaf_handler` |#⎩149⎭

#|                                                                              #line  function may want whenever it is invoked again. |#⎩150⎭

#|                                                                              #line  |#⎩151⎭
⎩152⎭

import queue⎩153⎭

import sys⎩154⎭
⎩155⎭
⎩156⎭

#|                                                                              #line  Eh_States :: enum { idle, active } |#⎩157⎭

class Eh:
  def __init__ (self,):⎩158⎭

    self.name =  "" ⎩159⎭

    self.inq =  queue.Queue () ⎩160⎭

    self.outq =  queue.Queue () ⎩161⎭

    self.owner =  None ⎩162⎭

    self.saved_messages =  queue.LifoQueue ()
    #|                                                                          #line  stack of saved message(s) |#⎩163⎭

    self.inject =  injector_NIY ⎩164⎭

    self.children = [] ⎩165⎭

    self.visit_ordering =  queue.Queue () ⎩166⎭

    self.connections = [] ⎩167⎭

    self.routings =  queue.Queue () ⎩168⎭

    self.handler =  None ⎩169⎭

    self.instance_data =  None ⎩170⎭

    self.state =  "idle" ⎩171⎭

    #|                                                                          #line  bootstrap debugging |#⎩172⎭

    self.kind =  None
    #|                                                                          #line  enum { container, leaf, } |#⎩173⎭

    self.trace =  False
    #|                                                                          #line  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |#⎩174⎭

    self.depth =  0
    #|                                                                          #line  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |#⎩175⎭
    ⎩176⎭

⎩177⎭

#|                                                                              #line  Creates a component that acts as a container. It is the same as a `Eh` instance |#⎩178⎭

#|                                                                              #line  whose handler function is `container_handler`. |#⎩179⎭

def make_container (name,owner):⎩180⎭

  eh = Eh ()⎩181⎭

  eh. name =  name⎩182⎭

  eh. owner =  owner⎩183⎭

  eh. handler =  container_handler⎩184⎭

  eh. inject =  container_injector⎩185⎭

  eh. state =  "idle"⎩186⎭

  eh. kind =  "container"⎩187⎭

  return  eh⎩188⎭
  ⎩189⎭

⎩190⎭

#|                                                                              #line  Creates a new leaf component out of a handler function, and a data parameter |#⎩191⎭

#|                                                                              #line  that will be passed back to your handler when called. |#⎩192⎭
⎩193⎭

def make_leaf (name,owner,instance_data,handler):⎩194⎭

  eh = Eh ()⎩195⎭

  eh. name =  str( owner. name) +  str( ".") +  name  ⎩196⎭

  eh. owner =  owner⎩197⎭

  eh. handler =  handler⎩198⎭

  eh. instance_data =  instance_data⎩199⎭

  eh. state =  "idle"⎩200⎭

  eh. kind =  "leaf"⎩201⎭

  return  eh⎩202⎭
  ⎩203⎭

⎩204⎭

#|                                                                              #line  Sends a message on the given `port` with `data`, placing it on the output |#⎩205⎭

#|                                                                              #line  of the given component. |#⎩206⎭
⎩207⎭

def send (eh,port,datum,causingMessage):⎩208⎭

  msg = make_message ( port, datum)⎩209⎭

  log_send (sender= eh,sender_port= port,msg= msg,cause_msg= causingMessage)⎩210⎭

  put_output ( eh, msg)⎩211⎭
  ⎩212⎭

⎩213⎭

def send_string (eh,port,s,causingMessage):⎩214⎭

  datum = new_datum_string ( s)⎩215⎭

  msg = make_message (port= port,datum= datum)⎩216⎭

  log_send_string (sender= eh,sender_port= port,msg= msg,cause_msg= causingMessage)⎩217⎭

  put_output ( eh, msg)⎩218⎭
  ⎩219⎭

⎩220⎭

def forward (eh,port,msg):⎩221⎭

  fwdmsg = make_message ( port, msg. datum)⎩222⎭

  log_forward (sender= eh,sender_port= port,msg= msg,cause_msg= msg)⎩223⎭

  put_output ( eh, msg)⎩224⎭
  ⎩225⎭

⎩226⎭

def inject (eh,msg):⎩227⎭

  eh.inject ( eh, msg)⎩228⎭
  ⎩229⎭

⎩230⎭

#|                                                                              #line  Returns a list of all output messages on a container. |#⎩231⎭

#|                                                                              #line  For testing / debugging purposes. |#⎩232⎭
⎩233⎭

def output_list (eh):⎩234⎭

  return  eh. outq⎩235⎭
  ⎩236⎭

⎩237⎭

#|                                                                              #line  Utility for printing an array of messages. |#⎩238⎭

def print_output_list (eh):⎩239⎭

  for m in list ( eh. outq. queue):⎩240⎭

    print (format_message ( m))⎩241⎭

  ⎩242⎭

⎩243⎭

def spaces (n):⎩244⎭

  s =  ""⎩245⎭

  for i in range( n):⎩246⎭

    s =  s+ " "⎩247⎭


  return  s⎩248⎭
  ⎩249⎭

⎩250⎭

def set_active (eh):⎩251⎭

  eh. state =  "active"⎩252⎭
  ⎩253⎭

⎩254⎭

def set_idle (eh):⎩255⎭

  eh. state =  "idle"⎩256⎭
  ⎩257⎭

⎩258⎭

#|                                                                              #line  Utility for printing a specific output message. |#⎩259⎭
⎩260⎭

def fetch_first_output (eh,port):⎩261⎭

  for msg in list ( eh. outq. queue):⎩262⎭

    if ( msg. port ==  port):⎩263⎭

      return  msg. datum
    ⎩264⎭


  return  None⎩265⎭
  ⎩266⎭

⎩267⎭

def print_specific_output (eh,port= "",stderr= False):⎩268⎭

  datum = fetch_first_output ( eh, port)⎩269⎭

  outf =  None⎩270⎭

  if  datum!= None:⎩271⎭

    if  stderr:

      #|                                                                        #line  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |#⎩272⎭

      outf =  sys. stderr⎩273⎭

    else:⎩274⎭

      outf =  sys. stdout⎩275⎭


    print ( datum.srepr (),file= outf)⎩276⎭

  ⎩277⎭

⎩278⎭

def put_output (eh,msg):⎩279⎭

  eh. outq.put ( msg)⎩280⎭
  ⎩281⎭

⎩282⎭

def injector_NIY (eh,msg):⎩283⎭


  #|                                                                            #line  print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“') |#⎩284⎭

  print ( str( "Injector not implemented for this component ") +  str( eh. name) +  str( " kind ∷ ") +  str( eh. kind) +  str( ",  port ∷ ") +  msg. port     )⎩289⎭

  exit ()⎩290⎭
  ⎩291⎭

⎩292⎭

import sys⎩293⎭

import re⎩294⎭

import subprocess⎩295⎭

import shlex⎩296⎭
⎩297⎭

root_project =  ""⎩298⎭

root_0D =  ""⎩299⎭
⎩300⎭

def set_environment (rproject,r0D):⎩301⎭

  global root_project⎩302⎭

  global root_0D⎩303⎭

  root_project =  rproject⎩304⎭

  root_0D =  r0D⎩305⎭
  ⎩306⎭

⎩307⎭

def probe_instantiate (reg,owner,name,template_data):⎩308⎭

  name_with_id = gensymbol ( "?")⎩309⎭

  return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= probe_handler)⎩310⎭
  ⎩311⎭


def probeA_instantiate (reg,owner,name,template_data):⎩312⎭

  name_with_id = gensymbol ( "?A")⎩313⎭

  return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= probe_handler)⎩314⎭
  ⎩315⎭

⎩316⎭

def probeB_instantiate (reg,owner,name,template_data):⎩317⎭

  name_with_id = gensymbol ( "?B")⎩318⎭

  return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= probe_handler)⎩319⎭
  ⎩320⎭

⎩321⎭

def probeC_instantiate (reg,owner,name,template_data):⎩322⎭

  name_with_id = gensymbol ( "?C")⎩323⎭

  return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= probe_handler)⎩324⎭
  ⎩325⎭

⎩326⎭

def probe_handler (eh,msg):⎩327⎭

  s =  msg. datum.srepr ()⎩328⎭

  print ( str( "... probe ") +  str( eh. name) +  str( ": ") +  s   ,file= sys. stderr)⎩329⎭
  ⎩330⎭

⎩331⎭

def trash_instantiate (reg,owner,name,template_data):⎩332⎭

  name_with_id = gensymbol ( "trash")⎩333⎭

  return make_leaf (name= name_with_id,owner= owner,instance_data= None,handler= trash_handler)⎩334⎭
  ⎩335⎭

⎩336⎭

def trash_handler (eh,msg):⎩337⎭


  #|                                                                            #line  to appease dumped_on_floor checker |#⎩338⎭

  pass⎩339⎭
  ⎩340⎭


class TwoMessages:
  def __init__ (self,first,second):⎩341⎭

    self.first =  first ⎩342⎭

    self.second =  second ⎩343⎭
    ⎩344⎭

⎩345⎭

#|                                                                              #line  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |#⎩346⎭

class Deracer_Instance_Data:
  def __init__ (self,state,buffer):⎩347⎭

    self.state =  state ⎩348⎭

    self.buffer =  buffer ⎩349⎭
    ⎩350⎭

⎩351⎭

def reclaim_Buffers_from_heap (inst):⎩352⎭

  pass⎩353⎭
  ⎩354⎭

⎩355⎭

def deracer_instantiate (reg,owner,name,template_data):⎩356⎭

  name_with_id = gensymbol ( "deracer")⎩357⎭

  inst = Deracer_Instance_Data ( "idle",TwoMessages ( None, None))⎩358⎭

  inst. state =  "idle"⎩359⎭

  eh = make_leaf (name= name_with_id,owner= owner,instance_data= inst,handler= deracer_handler)⎩360⎭

  return  eh⎩361⎭
  ⎩362⎭

⎩363⎭

def send_first_then_second (eh,inst):⎩364⎭

  forward ( eh, "1", inst. buffer. first)⎩365⎭

  forward ( eh, "2", inst. buffer. second)⎩366⎭

  reclaim_Buffers_from_heap ( inst)⎩367⎭
  ⎩368⎭

⎩369⎭

def deracer_handler (eh,msg):⎩370⎭

  inst =  eh. instance_data⎩371⎭

  if  inst. state ==  "idle":⎩372⎭

    if  "1" ==  msg. port:⎩373⎭

      inst. buffer. first =  msg⎩374⎭

      inst. state =  "waitingForSecond"⎩375⎭

    elif  "2" ==  msg. port:⎩376⎭

      inst. buffer. second =  msg⎩377⎭

      inst. state =  "waitingForFirst"⎩378⎭

    else:⎩379⎭

      runtime_error ( str( "bad msg.port (case A) for deracer ") +  msg. port )
    ⎩380⎭

  elif  inst. state ==  "waitingForFirst":⎩381⎭

    if  "1" ==  msg. port:⎩382⎭

      inst. buffer. first =  msg⎩383⎭

      send_first_then_second ( eh, inst)⎩384⎭

      inst. state =  "idle"⎩385⎭

    else:⎩386⎭

      runtime_error ( str( "bad msg.port (case B) for deracer ") +  msg. port )
    ⎩387⎭

  elif  inst. state ==  "waitingForSecond":⎩388⎭

    if  "2" ==  msg. port:⎩389⎭

      inst. buffer. second =  msg⎩390⎭

      send_first_then_second ( eh, inst)⎩391⎭

      inst. state =  "idle"⎩392⎭

    else:⎩393⎭

      runtime_error ( str( "bad msg.port (case C) for deracer ") +  msg. port )
    ⎩394⎭

  else:⎩395⎭

    runtime_error ( "bad state for deracer {eh.state}")⎩396⎭

  ⎩397⎭

⎩398⎭

def low_level_read_text_file_instantiate (reg,owner,name,template_data):⎩399⎭

  name_with_id = gensymbol ( "Low Level Read Text File")⎩400⎭

  return make_leaf ( name_with_id, owner, None, low_level_read_text_file_handler)⎩401⎭
  ⎩402⎭

⎩403⎭

def low_level_read_text_file_handler (eh,msg):⎩404⎭

  fname =  msg. datum.srepr ()⎩405⎭

  try:
    f = open (fname)
  except Exception as e:
    f = None
  if f != None:
    data = f.read ()
    if data!= None:
      send_string (eh, "", data, msg)
    else:
      send_string (eh, "✗", f"read error on file '{fname}'", msg)
    f.close ()
  else:
    send_string (eh, "✗", f"open error on file '{fname}'", msg)
  ⎩406⎭
  ⎩407⎭

⎩408⎭

def ensure_string_datum_instantiate (reg,owner,name,template_data):⎩409⎭

  name_with_id = gensymbol ( "Ensure String Datum")⎩410⎭

  return make_leaf ( name_with_id, owner, None, ensure_string_datum_handler)⎩411⎭
  ⎩412⎭

⎩413⎭

def ensure_string_datum_handler (eh,msg):⎩414⎭

  if  "string" ==  msg. datum.kind ():⎩415⎭

    forward ( eh, "", msg)⎩416⎭

  else:⎩417⎭

    emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg. datum ⎩418⎭

    send_string ( eh, "✗", emsg, msg)⎩419⎭

  ⎩420⎭

⎩421⎭

class Syncfilewrite_Data:
  def __init__ (self,):⎩422⎭

    self.filename =  "" ⎩423⎭
    ⎩424⎭

⎩425⎭

#|                                                                              #line  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |#⎩426⎭

def syncfilewrite_instantiate (reg,owner,name,template_data):⎩427⎭

  name_with_id = gensymbol ( "syncfilewrite")⎩428⎭

  inst = Syncfilewrite_Data ()⎩429⎭

  return make_leaf ( name_with_id, owner, inst, syncfilewrite_handler)⎩430⎭
  ⎩431⎭

⎩432⎭

def syncfilewrite_handler (eh,msg):⎩433⎭

  inst =  eh. instance_data⎩434⎭

  if  "filename" ==  msg. port:⎩435⎭

    inst. filename =  msg. datum.srepr ()⎩436⎭

  elif  "input" ==  msg. port:⎩437⎭

    contents =  msg. datum.srepr ()⎩438⎭

    f = open ( inst. filename, "w")⎩439⎭

    if  f!= None:⎩440⎭

      f.write ( msg. datum.srepr ())⎩441⎭

      f.close ()⎩442⎭

      send ( eh, "done",new_datum_bang (), msg)⎩443⎭

    else:⎩444⎭

      send_string ( eh, "✗", str( "open error on file ") +  inst. filename , msg)
    ⎩445⎭

  ⎩446⎭

⎩447⎭

class StringConcat_Instance_Data:
  def __init__ (self,):⎩448⎭

    self.buffer1 =  None ⎩449⎭

    self.buffer2 =  None ⎩450⎭

    self.count =  0 ⎩451⎭
    ⎩452⎭

⎩453⎭

def stringconcat_instantiate (reg,owner,name,template_data):⎩454⎭

  name_with_id = gensymbol ( "stringconcat")⎩455⎭

  instp = StringConcat_Instance_Data ()⎩456⎭

  return make_leaf ( name_with_id, owner, instp, stringconcat_handler)⎩457⎭
  ⎩458⎭

⎩459⎭

def stringconcat_handler (eh,msg):⎩460⎭

  inst =  eh. instance_data⎩461⎭

  if  "1" ==  msg. port:⎩462⎭

    inst. buffer1 = clone_string ( msg. datum.srepr ())⎩463⎭

    inst. count =  inst. count+ 1⎩464⎭

    maybe_stringconcat ( eh, inst, msg)⎩465⎭

  elif  "2" ==  msg. port:⎩466⎭

    inst. buffer2 = clone_string ( msg. datum.srepr ())⎩467⎭

    inst. count =  inst. count+ 1⎩468⎭

    maybe_stringconcat ( eh, inst, msg)⎩469⎭

  else:⎩470⎭

    runtime_error ( str( "bad msg.port for stringconcat: ") +  msg. port )⎩471⎭
    ⎩472⎭

  ⎩473⎭

⎩474⎭

def maybe_stringconcat (eh,inst,msg):⎩475⎭

  if ( 0 == len ( inst. buffer1)) and ( 0 == len ( inst. buffer2)):⎩476⎭

    runtime_error ( "something is wrong in stringconcat, both strings are 0 length")⎩477⎭


  if  inst. count >=  2:⎩478⎭

    concatenated_string =  ""⎩479⎭

    if  0 == len ( inst. buffer1):⎩480⎭

      concatenated_string =  inst. buffer2⎩481⎭

    elif  0 == len ( inst. buffer2):⎩482⎭

      concatenated_string =  inst. buffer1⎩483⎭

    else:⎩484⎭

      concatenated_string =  inst. buffer1+ inst. buffer2⎩485⎭


    send_string ( eh, "", concatenated_string, msg)⎩486⎭

    inst. buffer1 =  None⎩487⎭

    inst. buffer2 =  None⎩488⎭

    inst. count =  0⎩489⎭

  ⎩490⎭

⎩491⎭

#|                                                                              #line  |#⎩492⎭
⎩493⎭

#|                                                                              #line  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |#⎩494⎭

def shell_out_instantiate (reg,owner,name,template_data):⎩495⎭

  name_with_id = gensymbol ( "shell_out")⎩496⎭

  cmd =  shlex.split ( template_data)⎩497⎭

  return make_leaf ( name_with_id, owner, cmd, shell_out_handler)⎩498⎭
  ⎩499⎭

⎩500⎭

def shell_out_handler (eh,msg):⎩501⎭

  cmd =  eh. instance_data⎩502⎭

  s =  msg. datum.srepr ()⎩503⎭

  [ stdout, stderr] = run_command ( eh, cmd, s)⎩504⎭

  if  stderr!= None:⎩505⎭

    send_string ( eh, "✗", stderr, msg)⎩506⎭

  else:⎩507⎭

    send_string ( eh, "", stdout, msg)⎩508⎭

  ⎩509⎭

⎩510⎭

def string_constant_instantiate (reg,owner,name,template_data):⎩511⎭

  global root_project⎩512⎭

  global root_0D⎩513⎭

  name_with_id = gensymbol ( "strconst")⎩514⎭

  s =  template_data⎩515⎭

  if  root_project!= "":⎩516⎭

    s =  re.sub ( "_00_", root_project, s)⎩517⎭


  if  root_0D!= "":⎩518⎭

    s =  re.sub ( "_0D_", root_0D, s)⎩519⎭


  return make_leaf ( name_with_id, owner, s, string_constant_handler)⎩520⎭
  ⎩521⎭

⎩522⎭

def string_constant_handler (eh,msg):⎩523⎭

  s =  eh. instance_data⎩524⎭

  send_string ( eh, "", s, msg)⎩525⎭
  ⎩526⎭

⎩527⎭

def string_make_persistent (s):⎩528⎭


  #|                                                                            #line  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |#⎩529⎭

  return  s⎩530⎭
  ⎩531⎭

⎩532⎭

def string_clone (s):⎩533⎭

  return  s⎩534⎭
  ⎩535⎭

⎩536⎭

import sys⎩537⎭
⎩538⎭

#|                                                                              #line  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |#⎩539⎭

#|                                                                              #line  where ${_00_} is the root directory for the project |#⎩540⎭

#|                                                                              #line  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |#⎩541⎭
⎩542⎭
⎩543⎭
⎩544⎭

def initialize_component_palette (root_project,root_0D,diagram_source_files):⎩545⎭

  reg = make_component_registry ()⎩546⎭

  for diagram_source in  diagram_source_files:⎩547⎭

    all_containers_within_single_file = json2internal ( diagram_source)⎩548⎭

    generate_shell_components ( reg, all_containers_within_single_file)⎩549⎭

    for container in  all_containers_within_single_file:⎩550⎭

      register_component ( reg,Template (name= container ["name"],template_data= container,instantiator= container_instantiator))
    ⎩551⎭


  initialize_stock_components ( reg)⎩552⎭

  return  reg⎩553⎭
  ⎩554⎭

⎩555⎭

def print_error_maybe (main_container):⎩556⎭

  error_port =  "✗"⎩557⎭

  err = fetch_first_output ( main_container, error_port)⎩558⎭

  if ( err!= None) and ( 0 < len (trimws ( err.srepr ()))):⎩559⎭

    print ( "___ !!! ERRORS !!! ___")⎩560⎭

    print_specific_output ( main_container, error_port, False)⎩561⎭

  ⎩562⎭

⎩563⎭

#|                                                                              #line  debugging helpers |#⎩564⎭
⎩565⎭

def dump_outputs (main_container):⎩566⎭

  print ()⎩567⎭

  print ( "___ Outputs ___")⎩568⎭

  print_output_list ( main_container)⎩569⎭
  ⎩570⎭

⎩571⎭

def trace_outputs (main_container):⎩572⎭

  print ()⎩573⎭

  print ( "___ Message Traces ___")⎩574⎭

  print_routing_trace ( main_container)⎩575⎭
  ⎩576⎭

⎩577⎭

def dump_hierarchy (main_container):⎩578⎭

  print ()⎩579⎭

  print ( str( "___ Hierarchy ___") + (build_hierarchy ( main_container)) )⎩580⎭
  ⎩581⎭

⎩582⎭

def build_hierarchy (c):⎩583⎭

  s =  ""⎩584⎭

  for child in  c. children:⎩585⎭

    s =  str( s) + build_hierarchy ( child) ⎩586⎭


  indent =  ""⎩587⎭

  for i in range( c. depth):⎩588⎭

    indent =  indent+ "  "⎩589⎭


  return  str( "\n") +  str( indent) +  str( "(") +  str( c. name) +  str( s) +  ")"     ⎩590⎭
  ⎩591⎭

⎩592⎭

def dump_connections (c):⎩593⎭

  print ()⎩594⎭

  print ( "___ connections ___")⎩595⎭

  dump_possible_connections ( c)⎩596⎭

  for child in  c. children:⎩597⎭

    print ()⎩598⎭

    dump_possible_connections ( child)⎩599⎭

  ⎩600⎭

⎩601⎭

def trimws (s):⎩602⎭


  #|                                                                            #line  remove whitespace from front and back of string |#⎩603⎭

  return  s.strip ()⎩604⎭
  ⎩605⎭

⎩606⎭

def clone_string (s):⎩607⎭

  return  s⎩608⎭
  ⎩609⎭
  ⎩610⎭


load_errors =  False⎩611⎭

runtime_errors =  False⎩612⎭
⎩613⎭

def load_error (s):⎩614⎭

  global load_errors⎩615⎭

  print ( s)⎩616⎭

  quit ()⎩617⎭

  load_errors =  True⎩618⎭
  ⎩619⎭

⎩620⎭

def runtime_error (s):⎩621⎭

  global runtime_errors⎩622⎭

  print ( s)⎩623⎭

  quit ()⎩624⎭

  runtime_errors =  True⎩625⎭
  ⎩626⎭

⎩627⎭

def fakepipename_instantiate (reg,owner,name,template_data):⎩628⎭

  instance_name = gensymbol ( "fakepipe")⎩629⎭

  return make_leaf ( instance_name, owner, None, fakepipename_handler)⎩630⎭
  ⎩631⎭

⎩632⎭

rand =  0⎩633⎭
⎩634⎭

def fakepipename_handler (eh,msg):⎩635⎭

  global rand⎩636⎭

  rand =  rand+ 1

  #|                                                                            #line  not very random, but good enough _ 'rand' must be unique within a single run |#⎩637⎭

  send_string ( eh, "", str( "/tmp/fakepipe") +  rand , msg)⎩638⎭
  ⎩639⎭

⎩640⎭
⎩641⎭

#|                                                                              #line  all of the the built_in leaves are listed here |#⎩642⎭

#|                                                                              #line  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |#⎩643⎭
⎩644⎭
⎩645⎭

def initialize_stock_components (reg):⎩646⎭

  register_component ( reg,Template ( "1then2", None, deracer_instantiate))⎩647⎭

  register_component ( reg,Template ( "?", None, probe_instantiate))⎩648⎭

  register_component ( reg,Template ( "?A", None, probeA_instantiate))⎩649⎭

  register_component ( reg,Template ( "?B", None, probeB_instantiate))⎩650⎭

  register_component ( reg,Template ( "?C", None, probeC_instantiate))⎩651⎭

  register_component ( reg,Template ( "trash", None, trash_instantiate))⎩652⎭
  ⎩653⎭

  register_component ( reg,Template ( "Low Level Read Text File", None, low_level_read_text_file_instantiate))⎩654⎭

  register_component ( reg,Template ( "Ensure String Datum", None, ensure_string_datum_instantiate))⎩655⎭
  ⎩656⎭

  register_component ( reg,Template ( "syncfilewrite", None, syncfilewrite_instantiate))⎩657⎭

  register_component ( reg,Template ( "stringconcat", None, stringconcat_instantiate))⎩658⎭


  #|                                                                            #line  for fakepipe |#⎩659⎭

  register_component ( reg,Template ( "fakepipename", None, fakepipename_instantiate))⎩660⎭
  ⎩661⎭

⎩662⎭
⎩663⎭

def initialize ():⎩664⎭

  root_of_project =  sys.argv[ 1] ⎩665⎭

  root_of_0D =  sys.argv[ 2] ⎩666⎭

  arg =  sys.argv[ 3] ⎩667⎭

  main_container_name =  sys.argv[ 4] ⎩668⎭

  diagram_names =  sys.argv[ 5:] ⎩669⎭

  palette = initialize_component_palette ( root_project, root_0D, diagram_names)⎩670⎭

  return [ palette,[ root_of_project, root_of_0D, main_container_name, diagram_names, arg]]⎩671⎭
  ⎩672⎭

⎩673⎭

def start (palette,env,show_hierarchy= False,show_connections= False,show_traces= False,show_all_outputs= False):⎩674⎭

  root_of_project =  env [ 0]⎩675⎭

  root_of_0D =  env [ 1]⎩676⎭

  main_container_name =  env [ 2]⎩677⎭

  diagram_names =  env [ 3]⎩678⎭

  arg =  env [ 4]⎩679⎭

  set_environment ( root_of_project, root_of_0D)⎩680⎭


  #|                                                                            #line  get entrypoint container |#⎩681⎭

  main_container = get_component_instance ( palette, main_container_name,owner= None)⎩682⎭

  if  None ==  main_container:⎩683⎭

    load_error ( str( "Couldn't find container with page name ") +  str( main_container_name) +  str( " in files ") +  str( diagram_source_files) +  "(check tab names, or disable compression?)"    )⎩687⎭
    ⎩688⎭


  if  show_hierarchy:⎩689⎭

    dump_hierarchy ( main_container)⎩690⎭
    ⎩691⎭


  if  show_connections:⎩692⎭

    dump_connections ( main_container)⎩693⎭
    ⎩694⎭


  if not  load_errors:⎩695⎭

    arg = new_datum_string ( arg)⎩696⎭

    msg = make_message ( "", arg)⎩697⎭

    inject ( main_container, msg)⎩698⎭

    if  show_all_outputs:⎩699⎭

      dump_outputs ( main_container)⎩700⎭

    else:⎩701⎭

      print_error_maybe ( main_container)⎩702⎭

      print_specific_output ( main_container,port= "",stderr= False)⎩703⎭

      if  show_traces:⎩704⎭

        print ( "--- routing traces ---")⎩705⎭

        print (routing_trace_all ( main_container))⎩706⎭
        ⎩707⎭

      ⎩708⎭


    if  show_all_outputs:⎩709⎭

      print ( "--- done ---")⎩710⎭
      ⎩711⎭

    ⎩712⎭

  ⎩713⎭

⎩714⎭
⎩715⎭
⎩716⎭

#|                                                                              #line  utility functions  |#⎩717⎭

def send_int (eh,port,i,causing_message):⎩718⎭

  datum = new_datum_int ( i)⎩719⎭

  send ( eh, port, datum, causing_message)⎩720⎭
  ⎩721⎭

⎩722⎭

def send_bang (eh,port,causing_message):⎩723⎭

  datum = new_datum_bang ()⎩724⎭

  send ( eh, port, datum, causing_message)⎩725⎭
  ⎩726⎭

⎩727⎭





