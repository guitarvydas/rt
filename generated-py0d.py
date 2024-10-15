

counter =  0
digits = [ "₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀", "₂₁", "₂₂", "₂₃", "₂₄", "₂₅", "₂₆", "₂₇", "₂₈", "₂₉"]
def gensymbol (s):
    global counter
    name_with_id =  str( s) + subscripted_digit ( counter)
    counter =  counter+ 1
    return  name_with_id

def subscripted_digit (n):
    global digits
    if ( n >=  0 and  n <=  29):
        return  digits [ n]
    else:
        return  str( "₊") +  n 
    

class Datum:
    def __init__ (self):
        self.data =  None
        self.clone =  None
        self.reclaim =  None
        self.srepr =  None
        self.kind =  None
        self.raw =  None 

def new_datum_string (s):
    d =  Datum ()
    d.data =  s
    d.clone =  lambda : clone_datum_string ( d)
    d.reclaim =  lambda : reclaim_datum_string ( d)
    d.srepr =  lambda : srepr_datum_string ( d)
    d.raw =  lambda : raw_datum_string ( d)
    d.kind =  lambda :  "string"
    return  d

def clone_datum_string (d):
    d = new_datum_string ( d.data)
    return  d

def reclaim_datum_string (src):
    pass

def srepr_datum_string (d):
    return  d.data

def raw_datum_string (d):
    return bytearray ( d.data, "UTF_8")

def new_datum_bang ():
    p = Datum ()
    p.data =  True
    p.clone =  lambda : clone_datum_bang ( p)
    p.reclaim =  lambda : reclaim_datum_bang ( p)
    p.srepr =  lambda : srepr_datum_bang ()
    p.raw =  lambda : raw_datum_bang ()
    p.kind =  lambda :  "bang"
    return  p

def clone_datum_bang (d):
    return new_datum_bang ()

def reclaim_datum_bang (d):
    pass

def srepr_datum_bang ():
    return  "!"

def raw_datum_bang ():
    return []

def new_datum_tick ():
    p = new_datum_bang ()
    p.kind =  lambda :  "tick"
    p.clone =  lambda : new_datum_tick ()
    p.srepr =  lambda : srepr_datum_tick ()
    p.raw =  lambda : raw_datum_tick ()
    return  p

def srepr_datum_tick ():
    return  "."

def raw_datum_tick ():
    return []

def new_datum_bytes (b):
    p = Datum ()
    p.data =  b
    p.clone =  clone_datum_bytes
    p.reclaim =  lambda : reclaim_datum_bytes ( p)
    p.srepr =  lambda : srepr_datum_bytes ( b)
    p.raw =  lambda : raw_datum_bytes ( b)
    p.kind =  lambda :  "bytes"
    return  p

def clone_datum_bytes (src):
    p = Datum ()
    p =  src
    p.data =  src.clone ()
    return  p

def reclaim_datum_bytes (src):
    pass

def srepr_datum_bytes (d):
    return  d.data.decode ( "UTF_8")

def raw_datum_bytes (d):
    return  d.data

def new_datum_handle (h):
    return new_datum_int ( h)

def new_datum_int (i):
    p = Datum ()
    p.data =  i
    p.clone =  lambda : clone_int ( i)
    p.reclaim =  lambda : reclaim_int ( i)
    p.srepr =  lambda : srepr_datum_int ( i)
    p.raw =  lambda : raw_datum_int ( i)
    p.kind =  lambda :  "int"
    return  p

def clone_int (i):
    p = new_datum_int ( i)
    return  p

def reclaim_int (src):
    pass

def srepr_datum_int (i):
    return str ( i)

def raw_datum_int (i):
    return  i
# Message passed to a leaf component.## `port` refers to the name of the incoming or outgoing port of this component.# `datum` is the data attached to this message.
class Message:
    def __init__ (self,port,datum):
        self.port =  port
        self.datum =  datum 

def clone_port (s):
    return clone_string ( s)
# Utility for making a `Message`. Used to safely “seed“ messages# entering the very top of a network.
def make_message (port,datum):
    p = clone_string ( port)
    m = Message (port= p,datum= datum.clone ())
    return  m
# Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations.
def message_clone (message):
    m = Message (port=clone_port ( message.port),datum= message.datum.clone ())
    return  m
# Frees a message.
def destroy_message (msg):
    # during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages
    pass

def destroy_datum (msg):
    pass

def destroy_port (msg):
    pass
#
def format_message (m):
    if  m ==  None:
        return  "ϕ"
    else:
        return  str( "⟪") +  str( m.port) +  str( "⦂") +  str( m.datum.srepr ()) +  "⟫"    
    
# dynamic routing descriptors
drInject =  "inject"
drSend =  "send"
drInOut =  "inout"
drForward =  "forward"
drDown =  "down"
drUp =  "up"
drAcross =  "across"
drThrough =  "through"# See “class_free programming“ starting at 45:01 of https://www.youtube.com/watch?v=XFTOG895C7c
def make_Routing_Descriptor (action,component,port,message):
    return {"action": action,"component": component,"port": port,"message": message}
#
def make_Send_Descriptor (component,port,message,cause_port,cause_message):
    rdesc = make_Routing_Descriptor (action= drSend,component= component,port= port,message= message)
    return {"action": drSend,"component": rdesc ["component"],"port": rdesc ["port"],"message": rdesc ["message"],"cause_port": cause_port,"cause_message": cause_message,"fmt": fmt_send}

def log_send (sender,sender_port,msg,cause_msg):
    send_desc = make_Send_Descriptor (component= sender,port= sender_port,message= msg,cause_port= cause_msg.port,cause_message= cause_msg)
    append_routing_descriptor (container= sender.owner,desc= send_desc)

def log_send_string (sender,sender_port,msg,cause_msg):
    send_desc = make_Send_Descriptor ( sender, sender_port, msg, cause_msg.port, cause_msg)
    append_routing_descriptor (container= sender.owner,desc= send_desc)

def fmt_send (desc,indent):
    return  ""
    #return f;\n{indent}⋯ {desc@component.name}.“{desc@cause_port}“ ∴ {desc@component.name}.“{desc@port}“ {format_message (desc@message)}'

def fmt_send_string (desc,indent):
    return fmt_send ( desc, indent)
#
def make_Forward_Descriptor (component,port,message,cause_port,cause_message):
    rdesc = make_Routing_Descriptor (action= drSend,component= component,port= port,message= message)
    fmt_forward =  lambda desc:  ""
    return {"action": drForward,"component": rdesc ["component"],"port": rdesc ["port"],"message": rdesc ["message"],"cause_port": cause_port,"cause_message": cause_message,"fmt": fmt_forward}

def log_forward (sender,sender_port,msg,cause_msg):
    pass
    # when needed, it is too frequent to bother logging

def fmt_forward (desc):
    print ( str( "*** Error fmt_forward ") +  desc )
    quit ()
#
def make_Inject_Descriptor (receiver,port,message):
    rdesc = make_Routing_Descriptor (action= drInject,component= receiver,port= port,message= message)
    return {"action": drInject,"component": rdesc ["component"],"port": rdesc ["port"],"message": rdesc ["message"],"fmt": fmt_inject}

def log_inject (receiver,port,msg):
    inject_desc = make_Inject_Descriptor (receiver= receiver,port= port,message= msg)
    append_routing_descriptor (container= receiver,desc= inject_desc)

def fmt_inject (desc,indent):
    #return f'\n{indent}⟹  {desc@component.name}.“{desc@port}“ {format_message (desc@message)}'
    return  str( "\n") +  str( indent) +  str( "⟹  ") +  str( desc ["component"].name) +  str( ".") +  str( desc ["port"]) +  str( " ") + format_message ( desc ["message"])       
#
def make_Down_Descriptor (container,source_port,source_message,target,target_port,target_message):
    return {"action": drDown,"container": container,"source_port": source_port,"source_message": source_message,"target": target,"target_port": target_port,"target_message": target_message,"fmt": fmt_down}

def log_down (container,source_port,source_message,target,target_port,target_message):
    rdesc = make_Down_Descriptor ( container, source_port, source_message, target, target_port, target_message)
    append_routing_descriptor ( container, rdesc)

def fmt_down (desc,indent):
    #return f'\n{indent}↓ {desc@container.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“ {format_message (desc@target_message)}'
    return  str( "\n") +  str( indent) +  str( " ↓ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"].name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + format_message ( desc ["target_message"])           
#
def make_Up_Descriptor (source,source_port,source_message,container,container_port,container_message):
    return {"action": drUp,"source": source,"source_port": source_port,"source_message": source_message,"container": container,"container_port": container_port,"container_message": container_message,"fmt": fmt_up}

def log_up (source,source_port,source_message,container,target_port,target_message):
    rdesc = make_Up_Descriptor ( source, source_port, source_message, container, target_port, target_message)
    append_routing_descriptor ( container, rdesc)

def fmt_up (desc,indent):
    #return f'\n{indent}↑ {desc@source.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@container_port}“ {format_message (desc@container_message)}'
    return  str( "\n") +  str( indent) +  str( "↑ ") +  str( desc ["source"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["container_port"]) +  str( " ") + format_message ( desc ["container_message"])           

def make_Across_Descriptor (container,source,source_port,source_message,target,target_port,target_message):
    return {"action": drAcross,"container": container,"source": source,"source_port": source_port,"source_message": source_message,"target": target,"target_port": target_port,"target_message": target_message,"fmt": fmt_across}

def log_across (container,source,source_port,source_message,target,target_port,target_message):
    rdesc = make_Across_Descriptor ( container, source, source_port, source_message, target, target_port, target_message)
    append_routing_descriptor ( container, rdesc)

def fmt_across (desc,indent):
    #return f'\n{indent}→ {desc@source.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“  {format_message (desc@target_message)}'
    return  str( "\n") +  str( indent) +  str( "→ ") +  str( desc ["source"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["target"].name) +  str( ".") +  str( desc ["target_port"]) +  str( "  ") + format_message ( desc ["target_message"])           
#
def make_Through_Descriptor (container,source_port,source_message,target_port,message):
    return {"action": drThrough,"container": container,"source_port": source_port,"source_message": source_message,"target_port": target_port,"message": message,"fmt": fmt_through}

def log_through (container,source_port,source_message,target_port,message):
    rdesc = make_Through_Descriptor ( container, source_port, source_message, target_port, message)
    append_routing_descriptor ( container, rdesc)

def fmt_through (desc,indent):
    #return f'\n{indent}⇶ {desc @container.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@target_port}“ {format_message (desc@message)}'
    return  str( "\n") +  str( indent) +  str( "⇶ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["source_port"]) +  str( " ➔ ") +  str( desc ["container"].name) +  str( ".") +  str( desc ["target_port"]) +  str( " ") + format_message ( desc ["message"])           
#
def make_InOut_Descriptor (container,component,in_message,out_port,out_message):
    return {"action": drInOut,"container": container,"component": component,"in_message": in_message,"out_message": out_message,"fmt": fmt_inout}

def log_inout (container,component,in_message):
    if  component.outq.empty ():
        log_inout_no_output (container= container,component= component,in_message= in_message)
    else:
        log_inout_recursively (container= container,component= component,in_message= in_message,out_messages=list ( component.outq.queue))
    

def log_inout_no_output (container,component,in_message):
    rdesc = make_InOut_Descriptor (container= container,component= component,in_message= in_message,out_port= None,out_message= None)
    append_routing_descriptor ( container, rdesc)

def log_inout_single (container,component,in_message,out_message):
    rdesc = make_InOut_Descriptor (container= container,component= component,in_message= in_message,out_port= None,out_message= out_message)
    append_routing_descriptor ( container, rdesc)

def log_inout_recursively (container,component,in_message,out_messages=[]):
    if [] ==  out_messages:
        pass
    else:
        m =   out_messages[0]
        rest =   out_messages[1:]
        log_inout_single (container= container,component= component,in_message= in_message,out_message= m)
        log_inout_recursively (container= container,component= component,in_message= in_message,out_messages= rest)
    

def fmt_inout (desc,indent):
    outm =  desc ["out_message"]
    if  None ==  outm:
        return  str( "\n") +  str( indent) +  "  ⊥"  
    else:
        return  str( "\n") +  str( indent) +  str( "  ∴ ") +  str( desc ["component"].name) +  str( " ") + format_message ( outm)     
    

def log_tick (container,component,in_message):
    pass
#
def routing_trace_all (container):
    indent =  ""
    lis = list ( container.routings.queue)
    return recursive_routing_trace ( container, lis, indent)

def recursive_routing_trace (container,lis,indent):
    if [] ==  lis:
        return  ""
    else:
        desc = first ( lis)
        formatted =  desc ["fmt"] ( desc, indent)
        return  formatted+recursive_routing_trace ( container,rest ( lis), indent+ "  ")
    

enumDown =  0
enumAcross =  1
enumUp =  2
enumThrough =  3
def container_instantiator (reg,owner,container_name,desc):
    global enumDown, enumUp, enumAcross, enumThrough
    container = make_container ( container_name, owner)
    children = []
    children_by_id = {}
    # not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here
    # collect children
    for child_desc in  desc ["children"]:
        child_instance = get_component_instance ( reg, child_desc ["name"], container)
        children.append ( child_instance)
        children_by_id [ child_desc ["id"]] =  child_instance
    
    container.children =  children
    me =  container
    connectors = []
    for proto_conn in  desc ["connections"]:
        source_component =  None
        target_component =  None
        connector = Connector ()
        if  proto_conn ["dir"] ==  enumDown:
            # JSON: {'dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''},
            connector.direction =  "down"
            connector.sender = Sender ( me.name, me, proto_conn ["source_port"])
            target_component =  children_by_id [ proto_conn ["target"] ["id"]]
            if ( target_component ==  None):
                load_error ( str( "internal error: .Down connection target internal error ") +  proto_conn ["target"] )
            else:
                connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn ["target_port"], target_component)
                connectors.append ( connector)
            
        elif  proto_conn ["dir"] ==  enumAcross:
            connector.direction =  "across"
            source_component =  children_by_id [ proto_conn ["source"] ["id"]]
            target_component =  children_by_id [ proto_conn ["target"] ["id"]]
            if  source_component ==  None:
                load_error ( str( "internal error: .Across connection source not ok ") +  proto_conn ["source"] )
            else:
                connector.sender = Sender ( source_component.name, source_component, proto_conn ["source_port"])
                if  target_component ==  None:
                    load_error ( str( "internal error: .Across connection target not ok ") +  proto_conn.target )
                else:
                    connector.receiver = Receiver ( target_component.name, target_component.inq, proto_conn ["target_port"], target_component)
                    connectors.append ( connector)
                
            
        elif  proto_conn ["dir"] ==  enumUp:
            connector.direction =  "up"
            source_component =  children_by_id [ proto_conn ["source"] ["id"]]
            if  source_component ==  None:
                print ( str( "internal error: .Up connection source not ok ") +  proto_conn ["source"] )
            else:
                connector.sender = Sender ( source_component.name, source_component, proto_conn ["source_port"])
                connector.receiver = Receiver ( me.name, container.outq, proto_conn ["target_port"], me)
                connectors.append ( connector)
            
        elif  proto_conn ["dir"] ==  enumThrough:
            connector.direction =  "through"
            connector.sender = Sender ( me.name, me, proto_conn ["source_port"])
            connector.receiver = Receiver ( me.name, container.outq, proto_conn ["target_port"], me)
            connectors.append ( connector)
        
    
    container.connections =  connectors
    return  container
# The default handler for container components.
def container_handler (container,message):
    route (container= container,from_component= container,message= message)
    # references to 'self' are replaced by the container during instantiation
    while any_child_ready ( container):
        step_children ( container, message)
    
# Frees the given container and associated data.
def destroy_container (eh):
    pass

def fifo_is_empty (fifo):
    return  fifo.empty ()
# Routing connection for a container component. The `direction` field has# no affect on the default message routing system _ it is there for debugging# purposes, or for reading by other tools.
class Connector:
    def __init__ (self):
        self.direction =  None # down, across, up, through
        self.sender =  None
        self.receiver =  None 
# `Sender` is used to “pattern match“ which `Receiver` a message should go to,# based on component ID (pointer) and port name.
class Sender:
    def __init__ (self,name,component,port):
        self.name =  name
        self.component =  component # from
        self.port =  port # from's port
# `Receiver` is a handle to a destination queue, and a `port` name to assign# to incoming messages to this queue.
class Receiver:
    def __init__ (self,name,queue,port,component):
        self.name =  name
        self.queue =  queue # queue (input | output) of receiver
        self.port =  port # destination port
        self.component =  component # to (for bootstrap debug)
# Checks if two senders match, by pointer equality and port name matching.
def sender_eq (s1,s2):
    same_components = ( s1.component ==  s2.component)
    same_ports = ( s1.port ==  s2.port)
    return  same_components and  same_ports
# Delivers the given message to the receiver of this connector.
def deposit (parent,conn,message):
    new_message = make_message (port= conn.receiver.port,datum= message.datum)
    log_connection ( parent, conn, new_message)
    push_message ( parent, conn.receiver.component, conn.receiver.queue, new_message)

def force_tick (parent,eh):
    tick_msg = make_message ( ".",new_datum_tick ())
    push_message ( parent, eh, eh.inq, tick_msg)
    return  tick_msg

def push_message (parent,receiver,inq,m):
    inq.put ( m)
    parent.visit_ordering.put ( receiver)

def is_self (child,container):
    # in an earlier version “self“ was denoted as ϕ
    return  child ==  container

def step_child (child,msg):
    before_state =  child.state
    child.handler ( child, msg)
    after_state =  child.state
    return [ before_state ==  "idle" and  after_state!= "idle",  before_state!= "idle" and  after_state!= "idle",  before_state!= "idle" and  after_state ==  "idle"]

def save_message (eh,msg):
    eh.saved_messages.put ( msg)

def fetch_saved_message_and_clear (eh):
    return  eh.saved_messages.get ()

def step_children (container,causingMessage):
    container.state =  "idle"
    for child in list ( container.visit_ordering.queue):
        # child = container represents self, skip it
        if (not (is_self ( child, container))):
            if (not ( child.inq.empty ())):
                msg =  child.inq.get ()
                [ began_long_run,  continued_long_run,  ended_long_run] = step_child ( child, msg)
                if  began_long_run:
                    save_message ( child, msg)
                elif  continued_long_run:
                    pass
                elif  ended_long_run:
                    log_inout (container= container,component= child,in_message=fetch_saved_message_and_clear ( child))
                else:
                    log_inout (container= container,component= child,in_message= msg)
                
                destroy_message ( msg)
            else:
                if  child.state!= "idle":
                    msg = force_tick ( container, child)
                    child.handler ( child, msg)
                    log_tick (container= container,component= child,in_message= msg)
                    destroy_message ( msg)
                
            
            if  child.state ==  "active":
                # if child remains active, then the container must remain active and must propagate “ticks“ to child
                container.state =  "active"
            
            while (not ( child.outq.empty ())):
                msg =  child.outq.get ()
                route ( container, child, msg)
                destroy_message ( msg)
            
        
    

def attempt_tick (parent,eh):
    if  eh.state!= "idle":
        force_tick ( parent, eh)
    

def is_tick (msg):
    return  "tick" ==  msg.datum.kind ()
# Routes a single message to all matching destinations, according to# the container's connection network.
def route (container,from_component,message):
    was_sent =  False
    # for checking that output went somewhere (at least during bootstrap)
    fromname =  ""
    if is_tick ( message):
        for child in  container.children:
            attempt_tick ( container, child, message)
        
        was_sent =  True
    else:
        if (not (is_self ( from_component, container))):
            fromname =  from_component.name
        
        from_sender = Sender (name= fromname,component= from_component,port= message.port)
        for connector in  container.connections:
            if sender_eq ( from_sender, connector.sender):
                deposit ( container, connector, message)
                was_sent =  True
            
        
    
    if not ( was_sent):
        print ( "\n\n*** Error: ***")
        dump_possible_connections ( container)
        print_routing_trace ( container)
        print ( "***")
        print ( str( container.name) +  str( ": message '") +  str( message.port) +  str( "' from ") +  str( fromname) +  " dropped on floor..."     )
        print ( "***")
        exit ()
    

def dump_possible_connections (container):
    print ( str( "*** possible connections for ") +  str( container.name) +  ":"  )
    for connector in  container.connections:
        print ( str( connector.direction) +  str( " ") +  str( connector.sender.name) +  str( ".") +  str( connector.sender.port) +  str( " -> ") +  str( connector.receiver.name) +  str( ".") +  connector.receiver.port        )
    

def any_child_ready (container):
    for child in  container.children:
        if child_is_ready ( child):
            return  True
        
    
    return  False

def child_is_ready (eh):
    return (not ( eh.outq.empty ())) or (not ( eh.inq.empty ())) or ( eh.state!= "idle") or (any_child_ready ( eh))

def print_routing_trace (eh):
    print (routing_trace_all ( eh))

def append_routing_descriptor (container,desc):
    container.routings.put ( desc)

def log_connection (container,connector,message):
    if  "down" ==  connector.direction:
        log_down (container= container,source_port= connector.sender.port,source_message= None,target= connector.receiver.component,target_port= connector.receiver.port,target_message= message)
    elif  "up" ==  connector.direction:
        log_up (source= connector.sender.component,source_port= connector.sender.port,source_message= None,container= container,target_port= connector.receiver.port,target_message= message)
    elif  "across" ==  connector.direction:
        log_across (container= container,source= connector.sender.component,source_port= connector.sender.port,source_message= None,target= connector.receiver.component,target_port= connector.receiver.port,target_message= message)
    elif  "through" ==  connector.direction:
        log_through (container= container,source_port= connector.sender.port,source_message= None,target_port= connector.receiver.port,message= message)
    else:
        print ( str( "*** FATAL error: in log_connection /") +  str( connector.direction) +  str( "/ /") +  str( message.port) +  str( "/ /") +  str( message.datum.srepr ()) +  "/"      )
        exit ()
    

def container_injector (container,message):
    log_inject (receiver= container,port= message.port,msg= message)
    container_handler ( container, message)





