

counter =  0
digits = [ "₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"  "₁₀"  "₁₁"  "₁₂"  "₁₃"  "₁₄"  "₁₅"  "₁₆"  "₁₇"  "₁₈"  "₁₉"  "₂₀"  "₂₁"  "₂₂"  "₂₃"  "₂₄"  "₂₅"  "₂₆"  "₂₇"  "₂₈"  "₂₉" ]
(defun gensym ( s)
  global counter
  name_with_id =  str( s) + (subscripted_digit   counter)
  counter =  counter+ 1
  return  name_with_id
)
(defun subscripted_digit ( n)
  global digits
  if ( n >=  0 and  n <=  29):
    return  digits [ n]
  else:
    return  str( "₊") +  n 
  
)
class Datum:
  def __init__ (self):
    self.data =  None
    self.clone =  None
    self.reclaim =  None
    self.srepr =  None
    self.kind =  None
    self.raw =  None 

(defun new_datum_string ( s)
  d =  Datum ()
  d.data =  s
  d.clone =  lambda : (clone_datum_string   d)
  d.reclaim =  lambda : (reclaim_datum_string   d)
  d.srepr =  lambda : (srepr_datum_string   d)
  d.raw =  lambda : (raw_datum_string   d)
  d.kind =  lambda :  "string"
  return  d
)
(defun clone_datum_string ( d)
  d = (new_datum_string   d.data)
  return  d
)
(defun reclaim_datum_string ( src)
  pass
)
(defun srepr_datum_string ( d)
  return  d.data
)
(defun raw_datum_string ( d)
  return (bytearray   d.data  "UTF_8")
)
(defun new_datum_bang ()
  p = (Datum )
  p.data =  True
  p.clone =  lambda : (clone_datum_bang   p)
  p.reclaim =  lambda : (reclaim_datum_bang   p)
  p.srepr =  lambda : (srepr_datum_bang )
  p.raw =  lambda : (raw_datum_bang )
  p.kind =  lambda :  "bang"
  return  p
)
(defun clone_datum_bang ( d)
  return (new_datum_bang )
)
(defun reclaim_datum_bang ( d)
  pass
)
(defun srepr_datum_bang ()
  return  "!"
)
(defun raw_datum_bang ()
  return []
)
(defun new_datum_tick ()
  p = (new_datum_bang )
  p.kind =  lambda :  "tick"
  p.clone =  lambda : (new_datum_tick )
  p.srepr =  lambda : (srepr_datum_tick )
  p.raw =  lambda : (raw_datum_tick )
  return  p
)
(defun srepr_datum_tick ()
  return  "."
)
(defun raw_datum_tick ()
  return []
)
(defun new_datum_bytes ( b)
  p = (Datum )
  p.data =  b
  p.clone =  clone_datum_bytes
  p.reclaim =  lambda : (reclaim_datum_bytes   p)
  p.srepr =  lambda : (srepr_datum_bytes   b)
  p.raw =  lambda : (raw_datum_bytes   b)
  p.kind =  lambda :  "bytes"
  return  p
)
(defun clone_datum_bytes ( src)
  p = (Datum )
  p =  src
  p.data = ( src.clone )
  return  p
)
(defun reclaim_datum_bytes ( src)
  pass
)
(defun srepr_datum_bytes ( d)
  return ( d.data.decode   "UTF_8")
)
(defun raw_datum_bytes ( d)
  return  d.data
)
(defun new_datum_handle ( h)
  return (new_datum_int   h)
)
(defun new_datum_int ( i)
  p = (Datum )
  p.data =  i
  p.clone =  lambda : (clone_int   i)
  p.reclaim =  lambda : (reclaim_int   i)
  p.srepr =  lambda : (srepr_datum_int   i)
  p.raw =  lambda : (raw_datum_int   i)
  p.kind =  lambda :  "int"
  return  p
)
(defun clone_int ( i)
  p = (new_datum_int   i)
  return  p
)
(defun reclaim_int ( src)
  pass
)
(defun srepr_datum_int ( i)
  return (str   i)
)
(defun raw_datum_int ( i)
  return  i
)
#|  Message passed to a leaf component. |#
#|  |#
#|  `port` refers to the name of the incoming or outgoing port of this component. |#
#|  `datum` is the data attached to this message. |#
class Message:
  def __init__ (self port datum):
    self.port =  port
    self.datum =  datum 

(defun clone_port ( s)
  return (clone_string   s)
)
#|  Utility for making a `Message`. Used to safely “seed“ messages |#
#|  entering the very top of a network. |#
(defun make_message ( port datum)
  p = (clone_string   port)
  m = (Message   p ( datum.clone ))
  return  m
)
#|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |#
(defun message_clone ( message)
  m = (Message  (clone_port   message.port) ( message.datum.clone ))
  return  m
)
#|  Frees a message. |#
(defun destroy_message ( msg)
  
  #|  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |#
  pass
)
(defun destroy_datum ( msg)
  pass
)
(defun destroy_port ( msg)
  pass
)
#|  |#
(defun format_message ( m)
  if  m ==  None:
    return  "ϕ"
  else:
    return  str( "⟪") +  str( m.port) +  str( "⦂") +  str(( m.datum.srepr )) +  "⟫"    
  
)
#|  dynamic routing descriptors |#
drInject =  "inject"
drSend =  "send"
drInOut =  "inout"
drForward =  "forward"
drDown =  "down"
drUp =  "up"
drAcross =  "across"
drThrough =  "through"
#|  See “class_free programming“ starting at 45:01 of https://www.youtube.com/watch?v=XFTOG895C7c |#
(defun make_Routing_Descriptor ( action component port message)
  return {"action": action, "component": component, "port": port, "message": message }
)
#|  |#
(defun make_Send_Descriptor ( component port message cause_port cause_message)
  rdesc = (make_Routing_Descriptor   drSend  component  port  message)
  return {"action": drSend, "component": rdesc ["component"], "port": rdesc ["port"], "message": rdesc ["message"], "cause_port": cause_port, "cause_message": cause_message, "fmt": fmt_send }
)
(defun log_send ( sender sender_port msg cause_msg)
  send_desc = (make_Send_Descriptor   sender  sender_port  msg  cause_msg.port  cause_msg)
  ((append_routing_descriptor   sender.owner  send_desc) )
)
(defun log_send_string ( sender sender_port msg cause_msg)
  send_desc = (make_Send_Descriptor   sender  sender_port  msg  cause_msg.port  cause_msg)
  ((append_routing_descriptor   sender.owner  send_desc) )
)
(defun fmt_send ( desc indent)
  return  ""
  
  #| return f;\n{indent}⋯ {desc@component.name}.“{desc@cause_port}“ ∴ {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |#
)
(defun fmt_send_string ( desc indent)
  return (fmt_send   desc  indent)
)
#|  |#
(defun make_Forward_Descriptor ( component port message cause_port cause_message)
  rdesc = (make_Routing_Descriptor   drSend  component  port  message)
  fmt_forward =  lambda desc:  ""
  return {"action": drForward, "component": rdesc ["component"], "port": rdesc ["port"], "message": rdesc ["message"], "cause_port": cause_port, "cause_message": cause_message, "fmt": fmt_forward }
)
(defun log_forward ( sender sender_port msg cause_msg)
  pass
  
  #|  when needed, it is too frequent to bother logging |#
)
(defun fmt_forward ( desc)
  ((print   str( "*** Error fmt_forward ") +  desc )
  ((quit ) ))
)
#|  |#
(defun make_Inject_Descriptor ( receiver port message)
  rdesc = (make_Routing_Descriptor   drInject  receiver  port  message)
  return {"action": drInject, "component": rdesc ["component"], "port": rdesc ["port"], "message": rdesc ["message"], "fmt": fmt_inject }
)
(defun log_inject ( receiver port msg)
  inject_desc = (make_Inject_Descriptor   receiver  port  msg)
  ((append_routing_descriptor   receiver  inject_desc) )
)
(defun fmt_inject ( desc indent)
  
  #| return f'\n{indent}⟹  {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |#
  return  str( "\n") +  str( indent) +  str( "⟹  ") +  str( desc ["component"].name) +  str( ".") +  str( desc ["port"]) +  str( " ") + (format_message   desc ["message"])       
)
#|  |#
(defun make_Down_Descriptor ( container source_port source_message target target_port target_message)
  return {"action": drDown, "container": container, "source_port": source_port, "source_message": source_message, "target": target, "target_port": target_port, "target_message": target_message, "fmt": fmt_down }
)
(defun log_down ( container source_port source_message target target_port target_message)
  rdesc = (make_Down_Descriptor   container  source_port  source_message  target  target_port  target_message)
  ((append_routing_descriptor   container  rdesc) )
)
(defun fmt_down ( desc indent)
  
  #| return f'\n{indent}↓ {desc@container.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“ {format_message (desc@target_message)}' |#
  return  str( "\n") +  str( indent) +  str( " ↓ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"].name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + (format_message   desc ["target_message"])           
)
#|  |#
(defun make_Up_Descriptor ( source source_port source_message container container_port container_message)
  return {"action": drUp, "source": source, "source_port": source_port, "source_message": source_message, "container": container, "container_port": container_port, "container_message": container_message, "fmt": fmt_up }
)
(defun log_up ( source source_port source_message container target_port target_message)
  rdesc = (make_Up_Descriptor   source  source_port  source_message  container  target_port  target_message)
  ((append_routing_descriptor   container  rdesc) )
)
(defun fmt_up ( desc indent)
  
  #| return f'\n{indent}↑ {desc@source.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@container_port}“ {format_message (desc@container_message)}' |#
  return  str( "\n") +  str( indent) +  str( "↑ ") +  str( desc ["source"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["container_port"]) +  str( " ") + (format_message   desc ["container_message"])           
)
(defun make_Across_Descriptor ( container source source_port source_message target target_port target_message)
  return {"action": drAcross, "container": container, "source": source, "source_port": source_port, "source_message": source_message, "target": target, "target_port": target_port, "target_message": target_message, "fmt": fmt_across }
)
(defun log_across ( container source source_port source_message target target_port target_message)
  rdesc = (make_Across_Descriptor   container  source  source_port  source_message  target  target_port  target_message)
  ((append_routing_descriptor   container  rdesc) )
)
(defun fmt_across ( desc indent)
  
  #| return f'\n{indent}→ {desc@source.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“  {format_message (desc@target_message)}' |#
  return  str( "\n") +  str( indent) +  str( "→ ") +  str( desc ["source"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"].name) +  str( ".") +  str( desc ["target_port"]) +  str( "  ") + (format_message   desc ["target_message"])           
)
#|  |#
(defun make_Through_Descriptor ( container source_port source_message target_port message)
  return {"action": drThrough, "container": container, "source_port": source_port, "source_message": source_message, "target_port": target_port, "message": message, "fmt": fmt_through }
)
(defun log_through ( container source_port source_message target_port message)
  rdesc = (make_Through_Descriptor   container  source_port  source_message  target_port  message)
  ((append_routing_descriptor   container  rdesc) )
)
(defun fmt_through ( desc indent)
  
  #| return f'\n{indent}⇶ {desc @container.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@target_port}“ {format_message (desc@message)}' |#
  return  str( "\n") +  str( indent) +  str( "⇶ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + (format_message   desc ["message"])           
)
#|  |#
(defun make_InOut_Descriptor ( container component in_message out_port out_message)
  return {"action": drInOut, "container": container, "component": component, "in_message": in_message, "out_message": out_message, "fmt": fmt_inout }
)
(defun log_inout ( container component in_message)
  if ( component.outq.empty ):
    ((log_inout_no_output   container  component  in_message) )
  else:
    ((log_inout_recursively   container  component  in_message (list   component.outq.queue)) )
  
)
(defun log_inout_no_output ( container component in_message)
  rdesc = (make_InOut_Descriptor   container  component  in_message  None  None)
  ((append_routing_descriptor   container  rdesc) )
)
(defun log_inout_single ( container component in_message out_message)
  rdesc = (make_InOut_Descriptor   container  component  in_message  None  out_message)
  ((append_routing_descriptor   container  rdesc) )
)
(defun log_inout_recursively ( container component in_message out_messages=[])
  if [] ==  out_messages:
    pass
  else:
    m =   out_messages[0]
    rest =   out_messages[1:]
    ((log_inout_single   container  component  in_message  m)
    ((log_inout_recursively   container  component  in_message  rest) ))
  
)
(defun fmt_inout ( desc indent)
  outm =  desc ["out_message"]
  if  None ==  outm:
    return  str( "\n") +  str( indent) +  "  ⊥"  
  else:
    return  str( "\n") +  str( indent) +  str( "  ∴ ") +  str( desc ["component"].name) +  str( " ") + (format_message   outm)     
  
)
(defun log_tick ( container component in_message)
  pass
)
#|  |#
(defun routing_trace_all ( container)
  indent =  ""
  lis = (list   container.routings.queue)
  return (recursive_routing_trace   container  lis  indent)
)
(defun recursive_routing_trace ( container lis indent)
  if [] ==  lis:
    return  ""
  else:
    desc = (first   lis)
    formatted = ( desc ["fmt"]   desc  indent)
    return  formatted+(recursive_routing_trace   container (rest   lis)  indent+ "  ")
  
)
enumDown =  0
enumAcross =  1
enumUp =  2
enumThrough =  3
(defun container_instantiator ( reg owner container_name desc)
  global enumDown enumUp enumAcross enumThrough
  container = (make_container   container_name  owner)
  children = []
  children_by_id = {}
  
  #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |#
  
  #|  collect children |#
  for child_desc in  desc ["children"]:
    child_instance = (get_component_instance   reg  child_desc ["name"]  container)
    (( children.append   child_instance)
    children_by_id [ child_desc ["id"]] =  child_instance)
  
  container.children =  children
  me =  container
  connectors = []
  for proto_conn in  desc ["connections"]:
    source_component =  None
    target_component =  None
    connector = (Connector )
    if  proto_conn ["dir"] ==  enumDown:
      
      #|  JSON: {'dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |#
      connector.direction =  "down"
      connector.sender = (Sender   me.name  me  proto_conn ["source_port"])
      target_component =  children_by_id [ proto_conn ["target"] ["id"]]
      if ( target_component ==  None):
        ((load_error   str( "internal error: .Down connection target internal error ") +  proto_conn ["target"] ) )
      else:
        connector.receiver = (Receiver   target_component.name  target_component.inq  proto_conn ["target_port"]  target_component)
        (( connectors.append   connector) )
      
    elif  proto_conn ["dir"] ==  enumAcross:
      connector.direction =  "across"
      source_component =  children_by_id [ proto_conn ["source"] ["id"]]
      target_component =  children_by_id [ proto_conn ["target"] ["id"]]
      if  source_component ==  None:
        ((load_error   str( "internal error: .Across connection source not ok ") +  proto_conn ["source"] ) )
      else:
        connector.sender = (Sender   source_component.name  source_component  proto_conn ["source_port"])
        if  target_component ==  None:
          ((load_error   str( "internal error: .Across connection target not ok ") +  proto_conn.target ) )
        else:
          connector.receiver = (Receiver   target_component.name  target_component.inq  proto_conn ["target_port"]  target_component)
          (( connectors.append   connector) )
        
      
    elif  proto_conn ["dir"] ==  enumUp:
      connector.direction =  "up"
      source_component =  children_by_id [ proto_conn ["source"] ["id"]]
      if  source_component ==  None:
        ((print   str( "internal error: .Up connection source not ok ") +  proto_conn ["source"] ) )
      else:
        connector.sender = (Sender   source_component.name  source_component  proto_conn ["source_port"])
        connector.receiver = (Receiver   me.name  container.outq  proto_conn ["target_port"]  me)
        (( connectors.append   connector) )
      
    elif  proto_conn ["dir"] ==  enumThrough:
      connector.direction =  "through"
      connector.sender = (Sender   me.name  me  proto_conn ["source_port"])
      connector.receiver = (Receiver   me.name  container.outq  proto_conn ["target_port"]  me)
      (( connectors.append   connector) )
    
  
  container.connections =  connectors
  return  container
)
#|  The default handler for container components. |#
(defun container_handler ( container message)
  ((route   container  container  message)
  
  #|  references to 'self' are replaced by the container during instantiation |#
  while (any_child_ready   container):
    ((step_children   container  message) )
  )
)
#|  Frees the given container and associated data. |#
(defun destroy_container ( eh)
  pass
)
(defun fifo_is_empty ( fifo)
  return ( fifo.empty )
)
#|  Routing connection for a container component. The `direction` field has |#
#|  no affect on the default message routing system _ it is there for debugging |#
#|  purposes, or for reading by other tools. |#
class Connector:
  def __init__ (self):
    self.direction =  None
    #|  down, across, up, through |#
    self.sender =  None
    self.receiver =  None 

#|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |#
#|  based on component ID (pointer) and port name. |#
class Sender:
  def __init__ (self name component port):
    self.name =  name
    self.component =  component
    #|  from |#
    self.port =  port
    #|  from's port |#

#|  `Receiver` is a handle to a destination queue, and a `port` name to assign |#
#|  to incoming messages to this queue. |#
class Receiver:
  def __init__ (self name queue port component):
    self.name =  name
    self.queue =  queue
    #|  queue (input | output) of receiver |#
    self.port =  port
    #|  destination port |#
    self.component =  component
    #|  to (for bootstrap debug) |#

#|  Checks if two senders match, by pointer equality and port name matching. |#
(defun sender_eq ( s1 s2)
  same_components = ( s1.component ==  s2.component)
  same_ports = ( s1.port ==  s2.port)
  return  same_components and  same_ports
)
#|  Delivers the given message to the receiver of this connector. |#
(defun deposit ( parent conn message)
  new_message = (make_message   conn.receiver.port  message.datum)
  ((log_connection   parent  conn  new_message)
  ((push_message   parent  conn.receiver.component  conn.receiver.queue  new_message) ))
)
(defun force_tick ( parent eh)
  tick_msg = (make_message   "." (new_datum_tick ))
  ((push_message   parent  eh  eh.inq  tick_msg)
  return  tick_msg)
)
(defun push_message ( parent receiver inq m)
  (( inq.put   m)
  (( parent.visit_ordering.put   receiver) ))
)
(defun is_self ( child container)
  
  #|  in an earlier version “self“ was denoted as ϕ |#
  return  child ==  container
)
(defun step_child ( child msg)
  before_state =  child.state
  (( child.handler   child  msg)
  after_state =  child.state
  return [ before_state ==  "idle" and  after_state!= "idle"  before_state!= "idle" and  after_state!= "idle"  before_state!= "idle" and  after_state ==  "idle"])
)
(defun save_message ( eh msg)
  (( eh.saved_messages.put   msg) )
)
(defun fetch_saved_message_and_clear ( eh)
  return ( eh.saved_messages.get )
)
(defun step_children ( container causingMessage)
  container.state =  "idle"
  for child in (list   container.visit_ordering.queue):
    
    #|  child = container represents self, skip it |#
    if (not ((is_self   child  container))):
      if (not (( child.inq.empty ))):
        msg = ( child.inq.get )
        [ began_long_run  continued_long_run  ended_long_run] = (step_child   child  msg)
        if  began_long_run:
          ((save_message   child  msg) )
        elif  continued_long_run:
          pass
        elif  ended_long_run:
          ((log_inout   container  child (fetch_saved_message_and_clear   child)) )
        else:
          ((log_inout   container  child  msg) )
        
        ((destroy_message   msg) )
      else:
        if  child.state!= "idle":
          msg = (force_tick   container  child)
          (( child.handler   child  msg)
          ((log_tick   container  child  msg)
          ((destroy_message   msg) )))
        
      
      if  child.state ==  "active":
        
        #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |#
        container.state =  "active"
      
      while (not (( child.outq.empty ))):
        msg = ( child.outq.get )
        ((route   container  child  msg)
        ((destroy_message   msg) ))
      
    
  
)
(defun attempt_tick ( parent eh)
  if  eh.state!= "idle":
    ((force_tick   parent  eh) )
  
)
(defun is_tick ( msg)
  return  "tick" == ( msg.datum.kind )
)
#|  Routes a single message to all matching destinations, according to |#
#|  the container's connection network. |#
(defun route ( container from_component message)
  was_sent =  False
  
  #|  for checking that output went somewhere (at least during bootstrap) |#
  fromname =  ""
  if (is_tick   message):
    for child in  container.children:
      ((attempt_tick   container  child  message) )
    
    was_sent =  True
  else:
    if (not ((is_self   from_component  container))):
      fromname =  from_component.name
    
    from_sender = (Sender   fromname  from_component  message.port)
    for connector in  container.connections:
      if (sender_eq   from_sender  connector.sender):
        ((deposit   container  connector  message)
        was_sent =  True)
      
    
  
  if not ( was_sent):
    ((print   "\n\n*** Error: ***")
    ((dump_possible_connections   container)
    ((print_routing_trace   container)
    ((print   "***")
    ((print   str( container.name) +  str( ": message '") +  str( message.port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )
    ((print   "***")
    ((exit ) )))))))
  
)
(defun dump_possible_connections ( container)
  ((print   str( "*** possible connections for ") +  str( container.name) +  ":"  )
  for connector in  container.connections:
    ((print   str( connector.direction) +  str( " ") +  str( connector.sender.name) +  str( ".") +  str( connector.sender.port) +  str( " -> ") +  str( connector.receiver.name) +  str( ".") +  connector.receiver.port        ) )
  )
)
(defun any_child_ready ( container)
  for child in  container.children:
    if (child_is_ready   child):
      return  True
    
  
  return  False
)
(defun child_is_ready ( eh)
  return (not (( eh.outq.empty ))) or (not (( eh.inq.empty ))) or ( eh.state!= "idle") or ((any_child_ready   eh))
)
(defun print_routing_trace ( eh)
  ((print  (routing_trace_all   eh)) )
)
(defun append_routing_descriptor ( container desc)
  (( container.routings.put   desc) )
)
(defun log_connection ( container connector message)
  if  "down" ==  connector.direction:
    ((log_down   container  connector.sender.port  None  connector.receiver.component  connector.receiver.port  message) )
  elif  "up" ==  connector.direction:
    ((log_up   connector.sender.component  connector.sender.port  None  container  connector.receiver.port  message) )
  elif  "across" ==  connector.direction:
    ((log_across   container  connector.sender.component  connector.sender.port  None  connector.receiver.component  connector.receiver.port  message) )
  elif  "through" ==  connector.direction:
    ((log_through   container  connector.sender.port  None  connector.receiver.port  message) )
  else:
    ((print   str( "*** FATAL error: in log_connection /") +  str( connector.direction) +  str( "/ /") +  str( message.port) +  str( "/ /") +  str(( message.datum.srepr )) +  "/"      )
    ((exit ) ))
  
)
(defun container_injector ( container message)
  ((log_inject   container  message.port  message)
  ((container_handler   container  message) ))
)
import os
import json
import sys
class Component_Registry:
  def __init__ (self):
    self.templates = {} 

class Template:
  def __init__ (self name template_data instantiator):
    self.name =  name
    self.template_data =  template_data
    self.instantiator =  instantiator 

(defun read_and_convert_json_file ( filename)
  try:
  
    fil = (open   filename  "r")
    json_data = ( fil.read )
    routings = ( json.loads   json_data)
    (( fil.close )
    return  routings)
  except FileNotFoundError:
    ((print   str( "File not found: ") +  filename )
    return  None)
  except  json.JSONDecodeError as e:
    ((print   str( "Error decoding JSON in file: ") +  e )
    return  None)
  
)
(defun json2internal ( container_xml)
  fname = ( os.path.basename   container_xml)
  routings = (read_and_convert_json_file   fname)
  return  routings
)
(defun delete_decls ( d)
  pass
)
(defun make_component_registry ()
  return (Component_Registry )
)
(defun register_component ( reg template ok_to_overwrite= False)
  name = (mangle_name   template.name)
  if  name in  reg.templates and not  ok_to_overwrite:
    ((load_error   str( "Component ") +  str( template.name) +  " already declared"  ) )
  
  reg.templates [ name] =  template
  return  reg
)
(defun register_multiple_components ( reg templates)
  for template in  templates:
    ((register_component   reg  template) )
  
)
(defun get_component_instance ( reg full_name owner)
  template_name = (mangle_name   full_name)
  if  template_name in  reg.templates:
    template =  reg.templates [ template_name]
    if ( template ==  None):
      ((load_error   str( "Registry Error: Can't find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )
      return  None)
    else:
      owner_name =  ""
      instance_name =  template_name
      if  None!= owner:
        owner_name =  owner.name
        instance_name =  str( owner_name) +  str( ".") +  template_name  
      else:
        instance_name =  template_name
      
      instance = ( template.instantiator   reg  owner  instance_name  template.template_data)
      instance.depth = (calculate_depth   instance)
      return  instance
    
  else:
    ((load_error   str( "Registry Error: Can't find component ") +  str( template_name) +  " (does it need to be declared in components_to_include_in_project?"  )
    return  None)
  
)
(defun calculate_depth ( eh)
  if  eh.owner ==  None:
    return  0
  else:
    return  1+(calculate_depth   eh.owner)
  
)
(defun dump_registry ( reg)
  ((print )
  ((print   "*** PALETTE ***")
  for c in  reg.templates:
    ((print   c.name) )
  
  ((print   "***************")
  ((print ) ))))
)
(defun print_stats ( reg)
  ((print   str( "registry statistics: ") +  reg.stats ) )
)
(defun mangle_name ( s)
  
  #|  trim name to remove code from Container component names _ deferred until later (or never) |#
  return  s
)
import subprocess
(defun generate_shell_components ( reg container_list)
  
  #|  [ |#
  
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |#
  
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |#
  
  #|  ] |#
  if  None!= container_list:
    for diagram in  container_list:
      
      #|  loop through every component in the diagram and look for names that start with “$“ |#
      
      #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |#
      for child_descriptor in  diagram ["children"]:
        if (first_char_is   child_descriptor ["name"]  "$"):
          name =  child_descriptor ["name"]
          cmd = (  name[1:] .strip )
          generated_leaf = (Template   name  shell_out_instantiate  cmd)
          ((register_component   reg  generated_leaf) )
        elif (first_char_is   child_descriptor ["name"]  "'"):
          name =  child_descriptor ["name"]
          s =   name[1:]
          generated_leaf = (Template   name  string_constant_instantiate  s)
          ((register_component   reg  generated_leaf  True) )
        
      
    
  
)
(defun first_char ( s)
  return   s[0] 
)
(defun first_char_is ( s c)
  return  c == (first_char   s)
)
#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |#
#|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |#
(defun run_command ( eh cmd s)
  ret = ( subprocess.run   cmd  True  s  "UTF_8")
  if not ( ret.returncode ==  0):
    if  ret.stderr!= None:
      return [ ""  ret.stderr]
    else:
      return [ ""  str( "error in shell_out ") +  ret.returncode ]
    
  else:
    return [ ret.stdout  None]
  
)
#|  Data for an asyncronous component _ effectively, a function with input |#
#|  and output queues of messages. |#
#|  |#
#|  Components can either be a user_supplied function (“lea“), or a “container“ |#
#|  that routes messages to child components according to a list of connections |#
#|  that serve as a message routing table. |#
#|  |#
#|  Child components themselves can be leaves or other containers. |#
#|  |#
#|  `handler` invokes the code that is attached to this component. |#
#|  |#
#|  `instance_data` is a pointer to instance data that the `leaf_handler` |#
#|  function may want whenever it is invoked again. |#
#|  |#
import queue
import sys
#|  Eh_States :: enum { idle, active } |#
class Eh:
  def __init__ (self):
    self.name =  ""
    self.inq = ( queue.Queue )
    self.outq = ( queue.Queue )
    self.owner =  None
    self.saved_messages = ( queue.LifoQueue )
    #|  stack of saved message(s) |#
    self.inject =  injector_NIY
    self.children = []
    self.visit_ordering = ( queue.Queue )
    self.connections = []
    self.routings = ( queue.Queue )
    self.handler =  None
    self.instance_data =  None
    self.state =  "idle"
    #|  bootstrap debugging |#
    self.kind =  None
    #|  enum { container, leaf, } |#
    self.trace =  False
    #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |#
    self.depth =  0
    #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |#

#|  Creates a component that acts as a container. It is the same as a `Eh` instance |#
#|  whose handler function is `container_handler`. |#
(defun make_container ( name owner)
  eh = (Eh )
  eh.name =  name
  eh.owner =  owner
  eh.handler =  container_handler
  eh.inject =  container_injector
  eh.state =  "idle"
  eh.kind =  "container"
  return  eh
)
#|  Creates a new leaf component out of a handler function, and a data parameter |#
#|  that will be passed back to your handler when called. |#
(defun make_leaf ( name owner instance_data handler)
  eh = (Eh )
  eh.name =  str( owner.name) +  str( ".") +  name
  eh.owner =  owner
  eh.handler =  handler
  eh.instance_data =  instance_data
  eh.state =  "idle"
  eh.kind =  "leaf"
  return  eh
)
#|  Sends a message on the given `port` with `data`, placing it on the output |#
#|  of the given component. |#
(defun send ( eh port datum causingMessage)
  msg = (make_message   port  datum)
  ((log_send   eh  port  msg  causingMessage)
  ((put_output   eh  msg) ))
)
(defun send_string ( eh port s causingMessage)
  datum = (new_datum_string   s)
  msg = (make_message   port  datum)
  ((log_send_string   eh  port  msg  causingMessage)
  ((put_output   eh  msg) ))
)
(defun forward ( eh port msg)
  fwdmsg = (make_message   port  msg.datum)
  ((log_forward   eh  port  msg  msg)
  ((put_output   eh  msg) ))
)
(defun inject ( eh msg)
  (( eh.inject   eh  msg) )
)
#|  Returns a list of all output messages on a container. |#
#|  For testing / debugging purposes. |#
(defun output_list ( eh)
  return  eh.outq
)
#|  Utility for printing an array of messages. |#
(defun print_output_list ( eh)
  for m in (list   eh.outq.queue):
    ((print  (format_message   m)) )
  
)
(defun spaces ( n)
  s =  ""
  for i in range( n):
    s =  s+ " "
  
  return  s
)
(defun set_active ( eh)
  eh.state =  "active"
)
(defun set_idle ( eh)
  eh.state =  "idle"
)
#|  Utility for printing a specific output message. |#
(defun fetch_first_output ( eh port)
  for msg in (list   eh.outq.queue):
    if ( msg.port ==  port):
      return  msg.datum
    
  
  return  None
)
(defun print_specific_output ( eh port= "" stderr= False)
  datum = (fetch_first_output   eh  port)
  outf =  None
  if  datum!= None:
    if  stderr:
      
      #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |#
      outf =  sys.stderr
    else:
      outf =  sys.stdout
    
    ((print  ( datum.srepr )  outf) )
  
)
(defun put_output ( eh msg)
  (( eh.outq.put   msg) )
)
(defun injector_NIY ( eh msg)
  
  #|  print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“') |#
  ((print   str( "Injector not implemented for this component ") +  str( eh.name) +  str( " kind ∷ ") +  str( eh.kind) +  str( ",  port ∷ ") +  msg.port     )
  ((exit ) ))
)
import sys
import re
import subprocess
import shlex
root_project =  ""
root_0D =  ""
(defun set_environment ( rproject r0D)
  global root_project
  global root_0D
  root_project =  rproject
  root_0D =  r0D
)
(defun probe_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "?")
  return (make_leaf   name_with_id  owner  None  probe_handler)
)
(defun probeA_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "?A")
  return (make_leaf   name_with_id  owner  None  probe_handler)
)
(defun probeB_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "?B")
  return (make_leaf   name_with_id  owner  None  probe_handler)
)
(defun probeC_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "?C")
  return (make_leaf   name_with_id  owner  None  probe_handler)
)
(defun probe_handler ( eh msg)
  s = ( msg.datum.srepr )
  ((print   str( "... probe ") +  str( eh.name) +  str( ": ") +  s     sys.stderr) )
)
(defun trash_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "trash")
  return (make_leaf   name_with_id  owner  None  trash_handler)
)
(defun trash_handler ( eh msg)
  
  #|  to appease dumped_on_floor checker |#
  pass
)
class TwoMessages:
  def __init__ (self first second):
    self.first =  first
    self.second =  second 

#|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |#
class Deracer_Instance_Data:
  def __init__ (self state buffer):
    self.state =  state
    self.buffer =  buffer 

(defun reclaim_Buffers_from_heap ( inst)
  pass
)
(defun deracer_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "deracer")
  inst = (Deracer_Instance_Data   "idle" (TwoMessages   None  None))
  inst.state =  "idle"
  eh = (make_leaf   name_with_id  owner  inst  deracer_handler)
  return  eh
)
(defun send_first_then_second ( eh inst)
  ((forward   eh  "1"  inst.buffer.first)
  ((forward   eh  "2"  inst.buffer.second)
  ((reclaim_Buffers_from_heap   inst) )))
)
(defun deracer_handler ( eh msg)
  inst =  eh.instance_data
  if  inst.state ==  "idle":
    if  "1" ==  msg.port:
      inst.buffer.first =  msg
      inst.state =  "waitingForSecond"
    elif  "2" ==  msg.port:
      inst.buffer.second =  msg
      inst.state =  "waitingForFirst"
    else:
      ((runtime_error   str( "bad msg.port (case A) for deracer ") +  msg.port ) )
    
  elif  inst.state ==  "waitingForFirst":
    if  "1" ==  msg.port:
      inst.buffer.first =  msg
      ((send_first_then_second   eh  inst)
      inst.state =  "idle")
    else:
      ((runtime_error   str( "bad msg.port (case B) for deracer ") +  msg.port ) )
    
  elif  inst.state ==  "waitingForSecond":
    if  "2" ==  msg.port:
      inst.buffer.second =  msg
      ((send_first_then_second   eh  inst)
      inst.state =  "idle")
    else:
      ((runtime_error   str( "bad msg.port (case C) for deracer ") +  msg.port ) )
    
  else:
    ((runtime_error   "bad state for deracer {eh.state}") )
  
)
(defun low_level_read_text_file_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "Low Level Read Text File")
  return (make_leaf   name_with_id  owner  None  low_level_read_text_file_handler)
)
(defun low_level_read_text_file_handler ( eh msg)
  fname = ( msg.datum.srepr )
  try:
  
    f = (open   fname)
  except  Exception as e:
    f =  None
  
  if  f!= None:
    data = ( f.read )
    if  data!= None:
      ((send_string   eh  ""  data  msg) )
    else:
      emsg =  str( "read error on file ") +  fname
      ((send_string   eh  "✗"  emsg  msg) )
    
    (( f.close ) )
  else:
    emsg =  str( "open error on file ") +  fname
    ((send_string   eh  "✗"  emsg  msg) )
  
)
(defun ensure_string_datum_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "Ensure String Datum")
  return (make_leaf   name_with_id  owner  None  ensure_string_datum_handler)
)
(defun ensure_string_datum_handler ( eh msg)
  if  "string" == ( msg.datum.kind ):
    ((forward   eh  ""  msg) )
  else:
    emsg =  str( "*** ensure: type error (expected a string datum) but got ") +  msg.datum
    ((send_string   eh  "✗"  emsg  msg) )
  
)
class Syncfilewrite_Data:
  def __init__ (self):
    self.filename =  "" 

#|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |#
(defun syncfilewrite_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "syncfilewrite")
  inst = (Syncfilewrite_Data )
  return (make_leaf   name_with_id  owner  inst  syncfilewrite_handler)
)
(defun syncfilewrite_handler ( eh msg)
  inst =  eh.instance_data
  if  "filename" ==  msg.port:
    inst.filename = ( msg.datum.srepr )
  elif  "input" ==  msg.port:
    contents = ( msg.datum.srepr )
    f = (open   inst.filename  "w")
    if  f!= None:
      (( f.write  ( msg.datum.srepr ))
      (( f.close )
      ((send   eh  "done" (new_datum_bang )  msg) )))
    else:
      ((send_string   eh  "✗"  str( "open error on file ") +  inst.filename   msg) )
    
  
)
class StringConcat_Instance_Data:
  def __init__ (self):
    self.buffer1 =  None
    self.buffer2 =  None
    self.count =  0 

(defun stringconcat_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "stringconcat")
  instp = (StringConcat_Instance_Data )
  return (make_leaf   name_with_id  owner  instp  stringconcat_handler)
)
(defun stringconcat_handler ( eh msg)
  inst =  eh.instance_data
  if  "1" ==  msg.port:
    inst.buffer1 = (clone_string  ( msg.datum.srepr ))
    inst.count =  inst.count+ 1
    ((maybe_stringconcat   eh  inst  msg) )
  elif  "2" ==  msg.port:
    inst.buffer2 = (clone_string  ( msg.datum.srepr ))
    inst.count =  inst.count+ 1
    ((maybe_stringconcat   eh  inst  msg) )
  else:
    ((runtime_error   str( "bad msg.port for stringconcat: ") +  msg.port ) )
  
)
(defun maybe_stringconcat ( eh inst msg)
  if ( 0 == (len   inst.buffer1)) and ( 0 == (len   inst.buffer2)):
    ((runtime_error   "something is wrong in stringconcat, both strings are 0 length") )
  
  if  inst.count >=  2:
    concatenated_string =  ""
    if  0 == (len   inst.buffer1):
      concatenated_string =  inst.buffer2
    elif  0 == (len   inst.buffer2):
      concatenated_string =  inst.buffer1
    else:
      concatenated_string =  inst.buffer1+ inst.buffer2
    
    ((send_string   eh  ""  concatenated_string  msg)
    inst.buffer1 =  None
    inst.buffer2 =  None
    inst.count =  0)
  
)
#|  |#
#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |#
(defun shell_out_instantiate ( reg owner name template_data)
  name_with_id = (gensym   "shell_out")
  cmd = ( shlex.split   template_data)
  return (make_leaf   name_with_id  owner  cmd  shell_out_handler)
)
(defun shell_out_handler ( eh msg)
  cmd =  eh.instance_data
  s = ( msg.datum.srepr )
  [ stdout  stderr] = (run_command   eh  cmd  s)
  if  stderr!= None:
    ((send_string   eh  "✗"  stderr  msg) )
  else:
    ((send_string   eh  ""  stdout  msg) )
  
)
(defun string_constant_instantiate ( reg owner name template_data)
  global root_project
  global root_0D
  name_with_id = (gensym   "strconst")
  s =  template_data
  if  root_project!= "":
    s = ( re.sub   "_00_"  root_project  s)
  
  if  root_0D!= "":
    s = ( re.sub   "_0D_"  root_0D  s)
  
  return (make_leaf   name_with_id  owner  s  string_constant_handler)
)
(defun string_constant_handler ( eh msg)
  s =  eh.instance_data
  ((send_string   eh  ""  s  msg) )
)
(defun string_make_persistent ( s)
  
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |#
  return  s
)
(defun string_clone ( s)
  return  s
)
import sys
#|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |#
#|  where ${_00_} is the root directory for the project |#
#|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |#
(defun initialize_component_palette ( root_project root_0D diagram_source_files)
  reg = (make_component_registry )
  for diagram_source in  diagram_source_files:
    all_containers_within_single_file = (json2internal   diagram_source)
    ((generate_shell_components   reg  all_containers_within_single_file)
    for container in  all_containers_within_single_file:
      ((register_component   reg (Template   container ["name"]  container  container_instantiator)) )
    )
  
  ((initialize_stock_components   reg)
  return  reg)
)
(defun print_error_maybe ( main_container)
  error_port =  "✗"
  err = (fetch_first_output   main_container  error_port)
  if ( err!= None) and ( 0 < (len  (trimws  ( err.srepr )))):
    ((print   "___ !!! ERRORS !!! ___")
    ((print_specific_output   main_container  error_port  False) ))
  
)
#|  debugging helpers |#
(defun dump_outputs ( main_container)
  ((print )
  ((print   "___ Outputs ___")
  ((print_output_list   main_container) )))
)
(defun trace_outputs ( main_container)
  ((print )
  ((print   "___ Message Traces ___")
  ((print_routing_trace   main_container) )))
)
(defun dump_hierarchy ( main_container)
  ((print )
  ((print   str( "___ Hierarchy ___") + ((build_hierarchy   main_container)) ) ))
)
(defun build_hierarchy ( c)
  s =  ""
  for child in  c.children:
    s =  str( s) + (build_hierarchy   child) 
  
  indent =  ""
  for i in range( c.depth):
    indent =  indent+ "  "
  
  return  str( "\n") +  str( indent) +  str( "(") +  str( c.name) +  str( s) +  ")"     
)
(defun dump_connections ( c)
  ((print )
  ((print   "___ connections ___")
  ((dump_possible_connections   c)
  for child in  c.children:
    ((print )
    ((dump_possible_connections   child) ))
  )))
)
(defun trimws ( s)
  
  #|  remove whitespace from front and back of string |#
  return ( s.strip )
)
(defun clone_string ( s)
  return  s
)
load_errors =  False
runtime_errors =  False
(defun load_error ( s)
  global load_errors
  ((print   s)
  ((quit )
  load_errors =  True))
)
(defun runtime_error ( s)
  global runtime_errors
  ((print   s)
  ((quit )
  runtime_errors =  True))
)
(defun fakepipename_instantiate ( reg owner name template_data)
  instance_name = (gensym   "fakepipe")
  return (make_leaf   instance_name  owner  None  fakepipename_handler)
)
rand =  0
(defun fakepipename_handler ( eh msg)
  global rand
  rand =  rand+ 1
  
  #|  not very random, but good enough _ 'rand' must be unique within a single run |#
  ((send_string   eh  ""  str( "/tmp/fakepipe") +  rand   msg) )
)
#|  all of the the built_in leaves are listed here |#
#|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |#
(defun initialize_stock_components ( reg)
  ((register_component   reg (Template   "1then2"  None  deracer_instantiate))
  ((register_component   reg (Template   "?"  None  probe_instantiate))
  ((register_component   reg (Template   "?A"  None  probeA_instantiate))
  ((register_component   reg (Template   "?B"  None  probeB_instantiate))
  ((register_component   reg (Template   "?C"  None  probeC_instantiate))
  ((register_component   reg (Template   "trash"  None  trash_instantiate))
  ((register_component   reg (Template   "Low Level Read Text File"  None  low_level_read_text_file_instantiate))
  ((register_component   reg (Template   "Ensure String Datum"  None  ensure_string_datum_instantiate))
  ((register_component   reg (Template   "syncfilewrite"  None  syncfilewrite_instantiate))
  ((register_component   reg (Template   "stringconcat"  None  stringconcat_instantiate))
  
  #|  for fakepipe |#
  ((register_component   reg (Template   "fakepipename"  None  fakepipename_instantiate)) )))))))))))
)
(defun initialize ()
  root_of_project =  sys.argv[1]
  root_of_0D =  sys.argv[2]
  arg =  sys.argv[3]
  main_container_name =  sys.argv[4]
  diagram_names =  sys.argv[5:]
  palette = (initialize_component_palette   root_project  root_0D  diagram_names)
  return [ palette [ root_of_project  root_of_0D  main_container_name  diagram_names  arg ]]
)
(defun start ( palette env show_hierarchy= False show_connections= False show_traces= False show_all_outputs= False)
  root_of_project =  env [ 0]
  root_of_0D =  env [ 1]
  main_container_name =  env [ 2]
  diagram_names =  env [ 3]
  arg =  env [ 4]
  ((set_environment   root_of_project  root_of_0D)
  
  #|  get entrypoint container |#
  main_container = (get_component_instance   palette  main_container_name  None)
  if  None ==  main_container:
    ((load_error   str( "Couldn't find container with page name ") +  str( main_container_name) +  str( " in files ") +  str( diagram_source_files) +  "(check tab names, or disable compression?)"    ) )
  
  if  show_hierarchy:
    ((dump_hierarchy   main_container) )
  
  if  show_connections:
    ((dump_connections   main_container) )
  
  if not  load_errors:
    arg = (new_datum_string   arg)
    msg = (make_message   ""  arg)
    ((inject   main_container  msg)
    if  show_all_outputs:
      ((dump_outputs   main_container) )
    else:
      ((print_error_maybe   main_container)
      ((print_specific_output   main_container  ""  False)
      if  show_traces:
        ((print   "--- routing traces ---")
        ((print  (routing_trace_all   main_container)) ))
      ))
    
    if  show_all_outputs:
      ((print   "--- done ---") )
    )
  )
)
#|  utility functions  |#
(defun send_int ( eh port i causing_message)
  datum = (new_datum_int   i)
  ((send   eh  port  datum  causing_message) )
)
(defun send_bang ( eh port causing_message)
  datum = (new_datum_bang )
  ((send   eh  port  datum  causing_message) )
)




