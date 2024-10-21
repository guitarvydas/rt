

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





