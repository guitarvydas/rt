defvar counter ⇐ 0

defvar digits ⇐ [
    ‛₀’, ‛₁’, ‛₂’, ‛₃’, ‛₄’, ‛₅’,
    ‛₆’, ‛₇’, ‛₈’, ‛₉’,
    ‛₁₀’, ‛₁₁’, ‛₁₂’, ‛₁₃’, ‛₁₄’,
    ‛₁₅’, ‛₁₆’, ‛₁₇’, ‛₁₈’, ‛₁₉’,
    ‛₂₀’, ‛₂₁’, ‛₂₂’, ‛₂₃’, ‛₂₄’,
    ‛₂₅’, ‛₂₆’, ‛₂₇’, ‛₂₈’, ‛₂₉’
]

defn gensym (s) {
    global counter
    name_with_id ≡ ‛«s»«subscripted_digit (counter)»’
    counter ⇐ counter + 1
    return name_with_id
}

defn subscripted_digit (n) {
  global digits
  if (n >=  0 and n <=  29) {
    return digits [n]
  } else {
    return ‛₊«n»’
  }
}

defobj Datum () {
      • data ⇐ ϕ
      • clone ⇐ ϕ
      • reclaim ⇐ ϕ
      • srepr ⇐ ϕ
      • kind ⇐ ϕ
      • raw ⇐ ϕ
}

defn new_datum_string (s) {
    d ≡ fresh (Datum)
    d.data ⇐ s
    d.clone ⇐ λ: clone_datum_string (d)
    d.reclaim ⇐ λ: reclaim_datum_string (d)    
    d.srepr ⇐ λ: srepr_datum_string (d)
    d.raw ⇐ λ: raw_datum_string (d)    
    d.kind ⇐ λ: ‛string’
    return d
}

defn clone_datum_string (d) {
  d ≡ new_datum_string (d.data)
  return d
}

defn reclaim_datum_string (src) {
  pass
}

defn srepr_datum_string (d) {
  return d.data
}

defn raw_datum_string (d) {
  return bytearray (d.data,‛UTF_8’)
}

defn new_datum_bang () {
    p ≡ Datum ()
    p.data ⇐ ⊤
    p.clone ⇐ λ: clone_datum_bang (p)
    p.reclaim ⇐ λ: reclaim_datum_bang (p)
    p.srepr ⇐ λ: srepr_datum_bang ()
    p.raw ⇐ λ: raw_datum_bang ()    
    p.kind ⇐ λ: ‛bang’
    return p
}

defn clone_datum_bang (d) {
    return new_datum_bang ()
}

defn reclaim_datum_bang (d) {
    pass
}

defn srepr_datum_bang () {
    return ‛!’
}

defn raw_datum_bang () {
    return []
}

defn new_datum_tick () {
    p ≡ new_datum_bang ()
    p.kind ⇐ λ: ‛tick’
    p.clone ⇐ λ: new_datum_tick ()
    p.srepr ⇐ λ: srepr_datum_tick ()
    p.raw ⇐ λ: raw_datum_tick ()
    return p
}

defn srepr_datum_tick () {
    return ‛.’
}

defn raw_datum_tick () {
    return []
}

defn new_datum_bytes (b) {
    p ≡ Datum ()
    p.data ⇐ b
    p.clone ⇐ clone_datum_bytes
    p.reclaim ⇐ λ: reclaim_datum_bytes (p)
    p.srepr ⇐ λ: srepr_datum_bytes (b)
    p.raw ⇐ λ: raw_datum_bytes (b)
    p.kind ⇐ λ: ‛bytes’
    return p
}

defn clone_datum_bytes (src) {
    p ≡ Datum ()
    p ≡ src
    p.data ⇐ src.clone ()
    return p
}

defn reclaim_datum_bytes (src) {
    pass
}

defn srepr_datum_bytes (d) {
    return d.data.decode (‛utf_8’)
}
defn raw_datum_bytes (d) {
    return d.data
}

defn new_datum_handle (h) {
    return new_datum_int (h)
}

defn new_datum_int (i) {
    p ≡ Datum ()
    p.data ⇐ i
    p.clone ⇐ λ: clone_int (i)
    p.reclaim ⇐ λ: reclaim_int (i)
    p.srepr ⇐ λ: srepr_datum_int (i)
    p.raw ⇐ λ: raw_datum_int (i)
    p.kind ⇐ λ: ‛int’
    return p
}

defn clone_int (i) {
    p ≡ new_datum_int (i)
    return p
}

defn reclaim_int (src) {
    pass
}

defn srepr_datum_int (i) {
  return str (i)
}

defn raw_datum_int (i) {
    return i
}

# Message passed to a leaf component.
#
# `port` refers to the name of the incoming or outgoing port of this component.
# `datum` is the data attached to this message.
defobj Message (port, datum) {
        • port ⇐ port
        • datum ⇐ datum
}

defn clone_port (s) {
    return clone_string (s)
}

# Utility for making a `Message`. Used to safely ‛seed’ messages
# entering the very top of a network.
defn make_message (port, datum) {
    p ≡ clone_string (port)
    m ≡ Message (port ∷ p, datum ∷ datum.clone ())
    return m
}

# Clones a message. Primarily used internally for ‛fanning out’ a message to multiple destinations.
defn message_clone (message) {
    m ≡ Message (port ∷ clone_port (message.port), datum ∷ message.datum.clone ())
    return m
}

# Frees a message.
defn destroy_message (msg) {
    # during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages
    pass
}

defn destroy_datum (msg) {
    pass
}

defn destroy_port (msg) {
    pass
}

#####
defn format_message (m) {
    if m = ϕ {
        return ‛ϕ’ }
    else {
        return ‛⟪‛«m.port»’⦂‛«m.datum.srepr ()»’⟫’ }
}

# dynamic routing descriptors

defconst drInject ≡ ‛inject’
defconst drSend ≡ ‛send’
defconst drInOut ≡ ‛inout’
defconst drForward ≡ ‛forward’
defconst drDown ≡ ‛down’
defconst drUp ≡ ‛up’
defconst drAcross ≡ ‛across’
defconst drThrough ≡ ‛through’

# See ‛class_free programming’ starting at 45:01 of https://www.youtube.com/watch?v=XFTOG895C7c


defn make_Routing_Descriptor (action, component, port, message) {
    return {
        ‛action’: action,
        ‛component’: component,
        ‛port’: port,
        ‛message’: message
        }
}

####
defn make_Send_Descriptor (component, port, message, cause_port, cause_message) {
    rdesc ≡ make_Routing_Descriptor (action ∷ drSend, component ∷ component, port ∷ port, message ∷ message)
    return {
        ‛action’: drSend,
        ‛component’: rdesc@component,
        ‛port’: rdesc@port,
        ‛message’: rdesc@message,
        ‛cause_port’: cause_port,
        ‛cause_message’: cause_message,
        ‛fmt’: fmt_send
        }
}

defn log_send (sender, sender_port, msg, cause_msg) {
    send_desc ≡ make_Send_Descriptor (component ∷ sender, port ∷ sender_port, message ∷ msg, cause_port ∷ cause_msg.port, cause_message ∷ cause_msg)
    append_routing_descriptor (container ∷ sender.owner, desc ∷ send_desc)
}

defn log_send_string (sender, sender_port, msg, cause_msg) {
    send_desc ≡ make_Send_Descriptor (sender, sender_port, msg, cause_msg.port, cause_msg)
    append_routing_descriptor (container ∷ sender.owner, desc ∷ send_desc)
}

defn fmt_send (desc, indent) {
    return ‛’
}

defn fmt_send_string (desc, indent) {
    return fmt_send (desc, indent)
}

####
defn make_Forward_Descriptor (component, port, message, cause_port, cause_message) {
    rdesc ≡ make_Routing_Descriptor (action ∷ drSend, component ∷ component, port ∷ port, message ∷ message)
    fmt_forward ≡ λ (desc) : ‛’
    return {
        ‛action’: drForward,
        ‛component’: rdesc@component,
        ‛port’: rdesc@port,
        ‛message’: rdesc@message,
        ‛cause_port’: cause_port,
        ‛cause_message’: cause_message,
        ‛fmt’: fmt_forward
        }
}

defn log_forward (sender, sender_port, msg, cause_msg) {
    pass # when needed, it is too frequent to bother logging
}

defn fmt_forward (desc) {
    print (‛*** Error fmt_forward «desc»’)
    quit ()
}

####
defn make_Inject_Descriptor (receiver, port, message) {
    rdesc ≡ make_Routing_Descriptor (action ∷ drInject, component ∷ receiver, port ∷ port, message ∷ message)
    return {
        ‛action’: drInject,
        ‛component’: rdesc@component,
        ‛port’: rdesc@port,
        ‛message’: rdesc@message,
        ‛fmt’ : fmt_inject
        }
}

defn log_inject (receiver, port, msg) {
    inject_desc ≡ make_Inject_Descriptor (receiver ∷ receiver, port ∷ port, message ∷ msg)
    append_routing_descriptor (container ∷ receiver, desc ∷ inject_desc)
}

defn fmt_inject (desc, indent) {
    return ‛\n«indent»⟹  «desc@component.name».‛«desc@port»’ «format_message (desc@message)»’
}

####
defn make_Down_Descriptor (container, source_port, source_message, target, target_port, target_message) {
    return {
        ‛action’: drDown,
        ‛container’: container,
        ‛source_port’: source_port,
        ‛source_message’: source_message,
        ‛target’: target,
        ‛target_port’: target_port,
        ‛target_message’: target_message,
        ‛fmt’ : fmt_down
        }
}

defn log_down (container, source_port, source_message, target, target_port, target_message) {
    rdesc ≡ make_Down_Descriptor (container, source_port, source_message, target, target_port, target_message)
    append_routing_descriptor (container, rdesc)
}

defn fmt_down (desc, indent) {
    return ‛\n«indent»↓ «desc@container.name».‛«desc@source_port»’ ➔ «desc@target.name».‛«desc@target_port»’ «format_message (desc@target_message)»’
}

####
defn make_Up_Descriptor (source, source_port, source_message, container, container_port, container_message) {
    return {
        ‛action’: drUp,
        ‛source’: source,
        ‛source_port’: source_port,
        ‛source_message’: source_message,
        ‛container’: container,
        ‛container_port’: container_port,
        ‛container_message’: container_message,
        ‛fmt’ : fmt_up
        }
}

defn log_up (source, source_port, source_message, container, target_port, target_message) {
    rdesc ≡ make_Up_Descriptor (source, source_port, source_message, container, target_port, target_message)
    append_routing_descriptor (container, rdesc)
}

defn fmt_up (desc, indent) {
    return ‛\n«indent»↑ «desc@source.name».‛«desc@source_port»’ ➔ «desc@container.name».‛«desc@container_port»’ «format_message (desc@container_message)»’
}

defn make_Across_Descriptor (container, source, source_port, source_message, target, target_port, target_message) {
    return {
        ‛action’: drAcross,
        ‛container’: container,
        ‛source’: source,
        ‛source_port’: source_port,
        ‛source_message’: source_message,
        ‛target’: target,
        ‛target_port’: target_port,
        ‛target_message’: target_message,
        ‛fmt’ : fmt_across
        }
}

defn log_across (container, source, source_port, source_message, target, target_port, target_message) {
    rdesc ≡ make_Across_Descriptor (container, source, source_port, source_message, target, target_port, target_message)
    append_routing_descriptor (container, rdesc)
}

defn fmt_across (desc, indent) {
    return ‛\n«indent»→ «desc@source.name».‛«desc@source_port»’ ➔ «desc@target.name».‛«desc@target_port»’  «format_message (desc@target_message)»’
}

####
defn make_Through_Descriptor (container, source_port, source_message, target_port, message) {
    return {
        ‛action’: drThrough,
        ‛container’: container,
        ‛source_port’: source_port,
        ‛source_message’: source_message,
        ‛target_port’: target_port,
        ‛message’: message,
        ‛fmt’ : fmt_through
        }
}

defn log_through (container, source_port, source_message, target_port, message) {
    rdesc ≡ make_Through_Descriptor (container, source_port, source_message, target_port, message)
    append_routing_descriptor (container, rdesc)
}

defn fmt_through (desc, indent) {
    return ‛\n«indent»⇶ «desc @container.name».‛«desc@source_port»’ ➔ «desc@container.name».‛«desc@target_port»’ «format_message (desc@message)»’
}

####
defn make_InOut_Descriptor (container, component, in_message, out_port, out_message) {
    return {
        ‛action’: drInOut,
        ‛container’: container,
        ‛component’: component,
        ‛in_message’: in_message,
        ‛out_message’: out_message,
        ‛fmt’ : fmt_inout
        }
}

defn log_inout (container, component, in_message) {
    if component.outq.empty () {
        log_inout_no_output (container ∷ container, component ∷ component, in_message ∷ in_message) }
    else {
        log_inout_recursively (container ∷ container, component ∷ component, in_message ∷ in_message, out_messages ∷ list (component.outq.queue)) }
}

defn log_inout_no_output (container, component, in_message) {
    rdesc ≡ make_InOut_Descriptor (container ∷ container, component ∷ component, in_message ∷ in_message,
                                   out_port ∷ ϕ, out_message ∷ ϕ)
    append_routing_descriptor (container, rdesc)
}

defn log_inout_single (container, component, in_message, out_message) {
    rdesc ≡ make_InOut_Descriptor (container ∷ container, component ∷ component, in_message ∷ in_message,
                                   out_port ∷ ϕ, out_message ∷ out_message)
    append_routing_descriptor (container, rdesc)
}

defn log_inout_recursively (container, component, in_message, out_messages ∷ []) {
    if [] = out_messages {
        pass }
    else {
        m ≡ car (out_messages)
        rest ≡ cdr (out_messages)
        log_inout_single (container ∷ container, component ∷ component, in_message ∷ in_message, out_message ∷ m)
        log_inout_recursively (container ∷ container, component ∷ component, in_message ∷ in_message, out_messages ∷ rest) }
}

defn fmt_inout (desc, indent) {
    outm ≡ desc@out_message
    if ϕ = outm {
        return ‛\n«indent»  ⊥’}
    else {
        return ‛\n«indent»  ∴ «desc@component.name» «format_message (outm)»’}
}

defn log_tick (container, component, in_message) {
    pass
}

####
defn routing_trace_all (container) {
    indent ≡ ‛’
    lis ≡ list (container.routings.queue)
    return recursive_routing_trace (container, lis, indent)
}

defn recursive_routing_trace (container, lis, indent) {
    if [] = lis {
        return ‛’}
    else {
        desc ≡ first (lis)
        formatted ≡ desc@fmt (desc, indent)
        return formatted + recursive_routing_trace (container, rest (lis), indent + ‛  ’)}
}

defconst enumDown ≡ 0
defconst enumAcross ≡ 1
defconst enumUp ≡ 2
defconst enumThrough ≡ 3

defn container_instantiator (reg, owner, container_name, desc) {
    global enumDown, enumUp, enumAcross, enumThrough
    container ≡ make_container (container_name, owner)
    children ≡ []
    children_by_id ≡ {} # not strictly necessary, but, we can remove 1 runtime lookup by ‛compiling it out’ here
    # collect children
    for child_desc in desc@children {
        child_instance ≡ get_component_instance (reg, child_desc@name, container)
        children.append (child_instance)
        children_by_id [child_desc@id] ≡ child_instance }
    container.children ⇐ children
    me ≡ container
    
    connectors ≡ []
    for proto_conn in desc@connections {
        source_component ≡ ϕ
        target_component ≡ ϕ
        connector ≡ Connector ()
        if proto_conn@dir = enumDown {
            # JSON: {‛dir’: 0, ‛source’: {‛name’: ‛’, ‛id’: 0}, ‛source_port’: ‛’, ‛target’: {‛name’: ‛Echo’, ‛id’: 12}, ‛target_port’: ‛’},
            connector.direction ⇐ ‛down’
            connector.sender ⇐ Sender (me.name, me, proto_conn@source_port)
            target_component ≡ children_by_id [proto_conn@target@id]
            if (target_component = ϕ) {
                load_error (‛internal error: .Down connection target internal error «proto_conn@target»’)}
            else{
                connector.receiver ⇐ Receiver (target_component.name, target_component.inq, proto_conn@target_port, target_component)
                connectors.append (connector) }}
        elif proto_conn@dir = enumAcross {
            connector.direction ⇐ ‛across’
            source_component ≡ children_by_id [proto_conn@source@id]
            target_component ≡ children_by_id [proto_conn@target@id]
            if source_component = ϕ {
                load_error (‛internal error: .Across connection source not ok «proto_conn@source»’) }
            else {
                connector.sender ⇐ Sender (source_component.name, source_component, proto_conn@source_port)
                if target_component = ϕ {
                    load_error (‛internal error: .Across connection target not ok «proto_conn.target»’) }
                else {
                    connector.receiver ⇐ Receiver (target_component.name, target_component.inq, proto_conn@target_port, target_component)
                    connectors.append (connector)}}}
        elif proto_conn@dir = enumUp {
            connector.direction ⇐ ‛up’
            source_component ≡ children_by_id [proto_conn@source@id]
            if source_component = ϕ {
                print (‛internal error: .Up connection source not ok «proto_conn@source»’) }
            else {
                connector.sender ⇐ Sender (source_component.name, source_component, proto_conn@source_port)
                connector.receiver ⇐ Receiver (me.name, container.outq, proto_conn@target_port, me)
                connectors.append (connector) }}
        elif proto_conn@dir = enumThrough {
            connector.direction ⇐ ‛through’
            connector.sender ⇐ Sender (me.name, me, proto_conn@source_port)
            connector.receiver ⇐ Receiver (me.name, container.outq, proto_conn@target_port, me)
            connectors.append (connector) }}
            
    container.connections ⇐ connectors
    return container
}

# The default handler for container components.
defn container_handler (container, message) {
    route (container ∷ container, from_component ∷ container, message ∷ message) # references to ‛self’ are replaced by the container during instantiation
    while any_child_ready (container) {
        step_children (container, message)}
}

# Frees the given container and associated data.
defn destroy_container (eh) {
    pass
}

defn fifo_is_empty (fifo) {
    return fifo.empty ()
}

# Routing connection for a container component. The `direction` field has
# no affect on the default message routing system _ it is there for debugging
# purposes, or for reading by other tools.

defobj Connector () {
        • direction ⇐ ϕ # down, across, up, through
        • sender ⇐ ϕ
        • receiver ⇐ ϕ
}

# `Sender` is used to ‛pattern match’ which `Receiver` a message should go to,
# based on component ID (pointer) and port name.

defobj Sender (name, component, port) {
        • name ⇐ name
        • component ⇐ component # from
        • port ⇐ port # from‛s port
}

# `Receiver` is a handle to a destination queue, and a `port` name to assign
# to incoming messages to this queue.

defobj Receiver (name, queue, port, component) {
        • name ⇐ name
        • queue ⇐ queue # queue (input | output) of receiver
        • port ⇐ port # destination port
        • component ⇐ component # to (for bootstrap debug)
}

# Checks if two senders match, by pointer equality and port name matching.
defn sender_eq (s1, s2) {
    same_components ≡ (s1.component = s2.component)
    same_ports ≡ (s1.port = s2.port)
    return same_components and same_ports
}

# Delivers the given message to the receiver of this connector.

defn deposit (parent, conn, message) {
    new_message ≡ make_message (port ∷ conn.receiver.port, datum ∷ message.datum)
    log_connection (parent, conn, new_message)
    push_message (parent, conn.receiver.component, conn.receiver.queue, new_message)
}

defn force_tick (parent, eh) {
    bug_tick_msg ≡ make_message (‛.’, new_datum_tick ())
    push_message (parent, eh, eh.inq, tick_msg)
    return tick_msg
}

defn push_message (parent, receiver, inq, m) {
    inq.put (m)
    parent.visit_ordering.put (receiver)
}

defn is_self (child, container) {
    # in an earlier version ‛self’ was denoted as ϕ
    return child = container
}

defn step_child (child, msg) {
    before_state ≡ child.state
    child.handler(child, msg)
    after_state ≡ child.state
    return [before_state = ‛idle’ and after_state != ‛idle’, 
            before_state != ‛idle’ and after_state != ‛idle’,
            before_state != ‛idle’ and after_state = ‛idle’]
}

defn save_message (eh, msg) {
    eh.saved_messages.put (msg)
}

defn fetch_saved_message_and_clear (eh) {
    return eh.saved_messages.get ()
}

defn step_children (container, causingMessage) {
    container.state ⇐ ‛idle’
    for child in list (container.visit_ordering.queue) {
        # child = container represents self, skip it
        if (not (is_self (child, container))){
            if (not (child.inq.empty ())){
                msg ≡ child.inq.get ()
                [began_long_run, continued_long_run, ended_long_run] ⇐ step_child (child, msg)
                if began_long_run {
                    save_message (child, msg)}
                elif continued_long_run {
                    pass }
                elif ended_long_run {
                    log_inout (container ∷ container, component ∷ child, in_message ∷ fetch_saved_message_and_clear (child))}
                else {
                    log_inout (container ∷ container, component ∷ child, in_message ∷ msg)}
                destroy_message(msg)}
            else {
                if child.state !=  ‛idle’ {
                    msg ≡ force_tick (container, child)
                    child.handler(child, msg)
                    log_tick (container ∷ container, component ∷ child, in_message ∷ msg)
                    destroy_message(msg)}}
            
            if child.state = ‛active’ {
                # if child remains active, then the container must remain active and must propagate ‛ticks’ to child
                container.state ⇐ ‛active’}
            
            while (not (child.outq.empty ())) {
                msg ≡ child.outq.get ()
                route(container, child, msg)
                destroy_message(msg)}}}


}

defn attempt_tick (parent, eh) {
    if eh.state != ‛idle’ {
        force_tick (parent, eh)}
}

defn is_tick (msg) {
    return ‛tick’ = msg.datum.kind ()
}

# Routes a single message to all matching destinations, according to
# the container’s connection network.

defn route (container, from_component, message) {
    deftemp was_sent ⇐ ⊥ # for checking that output went somewhere (at least during bootstrap)
    deftemp fromname ⇐ ‛’
    if is_tick (message){
        for child in container.children {
            attempt_tick (container, child, message) }
        was_sent ⇐ ⊤ }
    else {
        if (not (is_self (from_component, container))) {
            fromname ⇐ from_component.name }
        from_sender ≡ Sender (name ∷ fromname, component ∷ from_component, port ∷ message.port)
        
        for connector in container.connections {
            if sender_eq (from_sender, connector.sender) {
                deposit (container, connector, message)
                was_sent ⇐ ⊤}}}
    if not (was_sent) {
        print (‛\n\n*** Error: ***’)
        dump_possible_connections (container)
        print_routing_trace (container)
        print (‛***’)
        print (‛«container.name»: message ‛«message.port»’ from «fromname» dropped on floor...’)
        print (‛***’)
        exit () }
}

defn dump_possible_connections (container) {
    print (‛*** possible connections for «container.name»:’)
    for connector in container.connections {
        print (‛«connector.direction» «connector.sender.name».«connector.sender.port» -> «connector.receiver.name».«connector.receiver.port»’) }
}

defn any_child_ready (container) {
    for child in container.children {
        if child_is_ready(child) {
            return ⊤}}
    return ⊥
}

defn child_is_ready (eh) {
    return (not (eh.outq.empty ())) or (not (eh.inq.empty ())) or ( eh.state != ‛idle’) or (any_child_ready (eh))
}

defn print_routing_trace (eh) {
    print (routing_trace_all (eh))
}

defn append_routing_descriptor (container, desc) {
    container.routings.put (desc)
}

defn log_connection (container, connector, message) {
    if ‛down’ = connector.direction{
        log_down (container ∷ container,
	          source_port ∷ connector.sender.port,
		  source_message ∷ ϕ,
		  target ∷ connector.receiver.component,
		  target_port ∷ connector.receiver.port,
                  target_message ∷ message) }
    elif ‛up’ = connector.direction {
        log_up (source ∷ connector.sender.component, source_port ∷ connector.sender.port, source_message ∷ ϕ, container ∷ container, target_port ∷ connector.receiver.port,
                  target_message ∷ message) }
    elif ‛across’ = connector.direction {
        log_across (container ∷ container,
                    source ∷ connector.sender.component, source_port ∷ connector.sender.port, source_message ∷ ϕ,
                    target ∷ connector.receiver.component, target_port ∷ connector.receiver.port, target_message ∷ message) }
    elif ‛through’ = connector.direction {
        log_through (container ∷ container, source_port ∷ connector.sender.port, source_message ∷ ϕ,
                     target_port ∷ connector.receiver.port, message ∷ message) }
    else {
        print (‛*** FATAL error: in log_connection /«connector.direction»/ /«message.port»/ /«message.datum.srepr ()»/’)
        exit () }
}

defn container_injector (container, message) {
    log_inject (receiver ∷ container, port ∷ message.port, msg ∷ message)
    container_handler (container, message)
}

import os
import json
import sys


defobj Component_Registry () {
        • templates ⇐ {}
}

defobj Template (name, template_data, instantiator) {
        • name ⇐ name
        • template_data ⇐ template_data
        • instantiator ⇐ instantiator
}
defn read_and_convert_json_file (filename) {
    try {
        fil ≡ open(filename, ‛r’)
        json_data ≡ fil.read()
        routings ≡ json.loads(json_data)
	fil.close ()
        return routings }
    except FileNotFoundError {
        print (‛File not found: «filename»’)
        return ϕ}
    except json.JSONDecodeError as e {
        print (‛Error decoding JSON in file: «e»’)
        return ϕ}
}

defn json2internal (container_xml) {
    fname ≡ os.path.basename (container_xml)
    routings ≡ read_and_convert_json_file (fname)
    return routings
}

defn delete_decls (d) {
    pass
}

defn make_component_registry () {
    return Component_Registry ()
}

defn register_component (reg, template, ok_to_overwrite ∷ ⊥) {
    name ≡ mangle_name (template.name)
    if name in reg.templates and not ok_to_overwrite {
        load_error (‛Component «template.name» already declared’)}
    reg.templates[name] ≡ template
    return reg
}

defn register_multiple_components (reg, templates) {
    for template in templates {
        register_component (reg, template)}
}

defn get_component_instance (reg, full_name, owner) {
    template_name ≡ mangle_name (full_name)
    if template_name in reg.templates {
        template ≡ reg.templates[template_name]
        if (template = ϕ) {
            load_error (‛Registry Error: Can‛t find component «template_name» (does it need to be declared in components_to_include_in_project?’)
            return ϕ}
        else {
            owner_name ≡ ‛’
            instance_name ≡ ‛«template_name»’
            if ϕ != owner {
                owner_name ≡ owner.name
                instance_name ≡ ‛«owner_name».«template_name»’}
            else{
                instance_name ≡ ‛«template_name»’}
            instance ≡ template.instantiator (reg, owner, instance_name, template.template_data)
            instance.depth ⇐ calculate_depth (instance)
            return instance }}
    else {
            load_error (‛Registry Error: Can’t find component «template_name» (does it need to be declared in components_to_include_in_project?’)
            return ϕ}
}
defn calculate_depth (eh) {
    if eh.owner = ϕ {
        return 0}
    else {
        return 1 + calculate_depth (eh.owner)}
}

defn dump_registry (reg) {
    print ()
    print (‛*** PALETTE ***’)
    for c in reg.templates{
        print (c.name)}
    print (‛***************’)
    print ()
}

defn print_stats (reg) {
    print (‛registry statistics: «reg.stats»’)
}

defn mangle_name (s) {
    # trim name to remove code from Container component names _ deferred until later (or never)
    return s
}

import subprocess
defn generate_shell_components (reg, container_list) {
    # [
    #     {‛file’: ‛simple0d.drawio’, ‛name’: ‛main’, ‛children’: [{‛name’: ‛Echo’, ‛id’: 5}], ‛connections’: [...]},
    #     {‛file’: ‛simple0d.drawio’, ‛name’: ‛...’, ‛children’: [], ‛connections’: []}
    # ]
    if ϕ != container_list {
        for diagram in container_list{
            # loop through every component in the diagram and look for names that start with ‛$’
            # {‛file’: ‛simple0d.drawio’, ‛name’: ‛main’, ‛children’: [{‛name’: ‛Echo’, ‛id’: 5}], ‛connections’: [...]},
            for child_descriptor in diagram@children{
                if first_char_is (child_descriptor@name, ‛$’){
                    name ≡ child_descriptor@name
                    cmd ≡ stringcdr (name).strip ()
                    generated_leaf ≡ Template (name ∷ name, instantiator ∷ shell_out_instantiate, template_data ∷ cmd)
                    register_component (reg, generated_leaf)}
                elif first_char_is (child_descriptor@name, ‛'’){
                    name ≡ child_descriptor@name
                    s ≡ stringcdr (name)
                    generated_leaf ≡ Template (name ∷ name, instantiator ∷ string_constant_instantiate, template_data ∷ s)
                    register_component (reg, generated_leaf, ok_to_overwrite ∷ ⊤)}}}}
}

defn first_char (s) {
    return car (s)
}

defn first_char_is (s, c) {
    return c = first_char (s)
}

# this needs to be rewritten to use the low_level ‛shell_out’ component, this can be done solely as a diagram without using python code here
# I‛ll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped
defn run_command (eh, cmd, s) {
    ret ≡ subprocess.run (cmd, capture_output ∷ ⊤, input ∷ s, encoding ∷ ‛utf_8’)
    if  not (ret.returncode = 0){
        if ret.stderr != ϕ{
            return [‛’, ret.stderr]}
        else{
            return [‛’, ‛error in shell_out «ret.returncode»’]}}
    else{
        return [ret.stdout, ϕ]}
}

# Data for an asyncronous component _ effectively, a function with input
# and output queues of messages.
#
# Components can either be a user_supplied function (‛leaf’), or a ‛container’
# that routes messages to child components according to a list of connections
# that serve as a message routing table.
#
# Child components themselves can be leaves or other containers.
#
# `handler` invokes the code that is attached to this component.
#
# `instance_data` is a pointer to instance data that the `leaf_handler`
# function may want whenever it is invoked again.
#

import queue
import sys


# Eh_States :: enum { idle, active }
defobj Eh () {
        • name ⇐ ‛’
        • inq ⇐ queue.Queue ()
        • outq ⇐ queue.Queue ()
        • owner ⇐ ϕ
        • saved_messages ⇐ queue.LifoQueue () ## stack of saved message(s)
        • inject ⇐ injector_NIY
        • children ⇐ []
        • visit_ordering ⇐ queue.Queue ()
        • connections ⇐ []
        • routings ⇐ queue.Queue ()
        • handler ⇐ ϕ
        • instance_data ⇐ ϕ
        • state ⇐ ‛idle’
        # bootstrap debugging
        • kind ⇐ ϕ # enum { container, leaf, }
        • trace ⇐ ⊥ # set ’⊤‛ if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component)
        • depth ⇐ 0 # hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc.
}

# Creates a component that acts as a container. It is the same as a `Eh` instance
# whose handler function is `container_handler`.
defn make_container (name, owner) {
    eh ≡ Eh ()
    eh.name ⇐ name
    eh.owner ⇐ owner
    eh.handler ⇐ container_handler
    eh.inject ⇐ container_injector
    eh.state ⇐ ‛idle’
    eh.kind ⇐ ‛container’
    return eh
}

# Creates a new leaf component out of a handler function, and a data parameter
# that will be passed back to your handler when called.

defn make_leaf (name, owner, instance_data, handler) {
    eh ≡ Eh ()
    eh.name ⇐ ‛«owner.name».«name»’
    eh.owner ⇐ owner
    eh.handler ⇐ handler
    eh.instance_data ⇐ instance_data
    eh.state ⇐ ‛idle’
    eh.kind ⇐ ‛leaf’
    return eh
}

# Sends a message on the given `port` with `data`, placing it on the output
# of the given component.

defn send (eh,port,datum,causingMessage) {
    msg ≡ make_message(port, datum)
    log_send (sender ∷ eh, sender_port ∷ port, msg ∷ msg, cause_msg ∷ causingMessage)
    put_output (eh, msg)
}

defn send_string (eh, port, s, causingMessage) {
    datum ≡ new_datum_string (s)
    msg ≡ make_message(port ∷ port, datum ∷ datum)
    log_send_string (sender ∷ eh, sender_port ∷ port, msg ∷ msg, cause_msg ∷ causingMessage)
    put_output (eh, msg)
}

defn forward (eh, port, msg) {
    fwdmsg ≡ make_message(port, msg.datum)
    log_forward (sender ∷ eh, sender_port ∷ port, msg ∷ msg, cause_msg ∷ msg)
    put_output (eh, msg)
}

defn inject (eh, msg) {
    eh.inject (eh, msg)
}

# Returns a list of all output messages on a container.
# For testing / debugging purposes.

defn output_list (eh) {
    return eh.outq
}

# Utility for printing an array of messages.
defn print_output_list (eh) {
    for m in list (eh.outq.queue) {
        print (format_message (m))}
}

defn spaces (n) {
    deftemp s ⇐ ‛’
    for i in range (n){
        s ⇐ s + ‛ ’}
    return s
}

defn set_active (eh) {
    eh.state ⇐ ‛active’
}

defn set_idle (eh) {
    eh.state ⇐ ‛idle’
}

# Utility for printing a specific output message.

defn fetch_first_output (eh, port) {
    for msg in list (eh.outq.queue) {
        if (msg.port = port){
            return msg.datum}}
    return ϕ
}

defn print_specific_output (eh, port ∷ ‛’, stderr ∷ ⊥) {
    deftemp datum ⇐ fetch_first_output (eh, port)
    deftemp outf ⇐ ϕ
    if datum != ϕ{
        if stderr{              # I don’t remember why I found it useful to print to stderr during bootstrapping, so I‛ve left it in...
            outf ⇐ sys.stderr}
        else{
            outf ⇐ sys.stdout}
        print (datum.srepr (), file ∷ outf)}
}

defn put_output (eh, msg) {
    eh.outq.put (msg)
}

defn injector_NIY (eh, msg) {
    print (f’Injector not implemented for this component ‛{eh.name}’ kind ∷ {eh.kind} port ∷ ‛{msg.port}’‛)
    exit ()
}

import sys
import re
import subprocess
import shlex

defvar root_project ⇐ ‛’
defvar root_0D ⇐ ‛’

defn set_environment (rproject, r0D) {
    global root_project
    global root_0D
    root_project ⇐ rproject
    root_0D ⇐ r0D
}

defn probe_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym (‛?’)
    return make_leaf (name ∷ name_with_id, owner ∷ owner, instance_data ∷ ϕ, handler ∷ probe_handler)
}
defn probeA_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym (‛?A’)
    return make_leaf (name ∷ name_with_id, owner ∷ owner, instance_data ∷ ϕ, handler ∷ probe_handler)
}

defn probeB_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym(‛?B’)
    return make_leaf (name ∷ name_with_id, owner ∷ owner, instance_data ∷ ϕ, handler ∷ probe_handler)
}

defn probeC_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym(‛?C’)
    return make_leaf (name ∷ name_with_id, owner ∷ owner, instance_data ∷ ϕ, handler ∷ probe_handler)
}

defn probe_handler (eh, msg) {
    s ≡ msg.datum.srepr ()
    print (‛... probe «eh.name»: «s»’, file ∷ sys.stderr)
}

defn trash_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym (‛trash’)
    return make_leaf (name ∷ name_with_id, owner ∷ owner, instance_data ∷ ϕ, handler ∷ trash_handler)
}

defn trash_handler (eh, msg) {
    # to appease dumped_on_floor checker
    pass
}
defobj TwoMessages (first, second) {
        • first ⇐ first
        • second ⇐ second
}

# Deracer_States :: enum { idle, waitingForFirst, waitingForSecond }
defobj Deracer_Instance_Data (state, buffer) {
        • state ⇐ state
        • buffer ⇐ buffer
}

defn reclaim_Buffers_from_heap (inst) {
    pass
}

defn deracer_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym (‛deracer’)
    inst ≡ Deracer_Instance_Data (‛idle’, TwoMessages (ϕ, ϕ))
    inst.state ⇐ ‛idle’
    eh ≡ make_leaf (name ∷ name_with_id, owner ∷ owner, instance_data ∷ inst, handler ∷ deracer_handler)
    return eh
}

defn send_first_then_second (eh, inst) {
    forward (eh, ‛1’, inst.buffer.first)
    forward (eh, ‛2’, inst.buffer.second)
    reclaim_Buffers_from_heap (inst)
}

defn deracer_handler (eh, msg) {
    inst ⇐ eh.instance_data
    if inst.state = ‛idle’ {
        if ‛1’ = msg.port{
            inst.buffer.first ⇐ msg
            inst.state ⇐ ‛waitingForSecond’}
        elif ‛2’ = msg.port{
            inst.buffer.second ⇐ msg
            inst.state ⇐ ‛waitingForFirst’}
        else{
            runtime_error (‛bad msg.port (case A) for deracer «msg.port»’)}}
    elif inst.state = ‛waitingForFirst’ {
        if ‛1’ = msg.port{
            inst.buffer.first ⇐ msg
            send_first_then_second (eh, inst)
            inst.state ⇐ ‛idle’}
        else{
            runtime_error (‛bad msg.port (case B) for deracer «msg.port»’)}}
    elif inst.state = ‛waitingForSecond’{
        if ‛2’ = msg.port{
            inst.buffer.second ⇐ msg
            send_first_then_second (eh, inst)
            inst.state ⇐ ‛idle’}
        else{
            runtime_error (‛bad msg.port (case C) for deracer «msg.port»’)}}
    else{
        runtime_error (‛bad state for deracer {eh.state}’)}
}

defn low_level_read_text_file_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym(‛Low Level Read Text File’)
    return make_leaf (name_with_id, owner, ϕ, low_level_read_text_file_handler)
}

defn low_level_read_text_file_handler (eh, msg) {
    fname ≡ msg.datum.srepr ()
    try{
        f ≡ open (fname)}
    except Exception as e{
        f ≡ ϕ}
    if f != ϕ{
        data ≡ f.read ()
        if data!= ϕ{
            send_string (eh, ‛’, data, msg)}
        else{
            emsg ≡ ‛read error on file «fname»’
            send_string (eh, ‛✗’, emsg, msg)}
        f.close ()}
    else{
        emsg ≡ ‛open error on file «fname»’
        send_string (eh, ‛✗’, emsg, msg)}
}

defn ensure_string_datum_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym(‛Ensure String Datum’)
    return make_leaf (name_with_id, owner, ϕ, ensure_string_datum_handler)
}

defn ensure_string_datum_handler (eh, msg) {
    if ‛string’ = msg.datum.kind (){
        forward (eh, ‛’, msg)}
    else{
        emsg ≡ ‛*** ensure: type error (expected a string datum) but got «msg.datum»’
        send_string (eh, ‛✗’, emsg, msg)}
}

defobj Syncfilewrite_Data () {
        • filename ⇐ ‛’
}

# temp copy for bootstrap, sends ‛done’ (error during bootstrap if not wired)
defn syncfilewrite_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym (‛syncfilewrite’)
    inst ≡ Syncfilewrite_Data ()
    return make_leaf (name_with_id, owner, inst, syncfilewrite_handler)
}

defn syncfilewrite_handler (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    if ‛filename’ = msg.port {
        inst.filename ⇐ msg.datum.srepr ()}
    elif ‛input’ = msg.port {
        contents ≡ msg.datum.srepr ()
        deftemp f ⇐ open (inst.filename, ‛w’)
        if f != ϕ{
            f.write (msg.datum.srepr ())
            f.close ()
            send (eh, ‛done’, new_datum_bang (), msg)}
        else{
            send_string (eh, ‛✗’, ‛open error on file «inst.filename»’, msg)}}
}

defobj StringConcat_Instance_Data () {
        • buffer1 ⇐ ϕ
        • buffer2 ⇐ ϕ
        • count ⇐ 0
}

defn stringconcat_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym (‛stringconcat’)
    instp ≡ StringConcat_Instance_Data ()
    return make_leaf (name_with_id, owner, instp, stringconcat_handler)
}

defn stringconcat_handler (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    if ‛1’ = msg.port{
        inst.buffer1 ⇐ clone_string (msg.datum.srepr ())
        inst.count ⇐ inst.count + 1
        maybe_stringconcat (eh, inst, msg)}
    elif ‛2’ = msg.port{
        inst.buffer2 ⇐ clone_string (msg.datum.srepr ())
        inst.count ⇐ inst.count + 1
        maybe_stringconcat (eh, inst, msg)}
    else{
        runtime_error (‛bad msg.port for stringconcat: «msg.port»’)}
}

defn maybe_stringconcat (eh, inst, msg) {
    if (0 = len (inst.buffer1)) and (0 = len (inst.buffer2)){
        runtime_error (‛something is wrong in stringconcat, both strings are 0 length’)}
    if inst.count >= 2{
        deftemp concatenated_string ⇐ ‛’
        if 0 = len (inst.buffer1){
            concatenated_string ⇐ inst.buffer2}
        elif 0 = len (inst.buffer2){
            concatenated_string ⇐ inst.buffer1}
        else{
            concatenated_string ⇐ inst.buffer1 + inst.buffer2}        
        send_string (eh, ‛’, concatenated_string, msg)
        inst.buffer1 ⇐ ϕ
        inst.buffer2 ⇐ ϕ
        inst.count ⇐ 0}
}

####

# this needs to be rewritten to use the low_level ‛shell_out’ component, this can be done solely as a diagram without using python code here
defn shell_out_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensym (‛shell_out’)
    cmd ≡ shlex.split (template_data)
    return make_leaf (name_with_id, owner, cmd, shell_out_handler)
}

defn shell_out_handler (eh, msg) {
    cmd ≡ eh.instance_data
    s ≡ msg.datum.srepr ()
    [stdout, stderr] ⇐ run_command (eh, cmd, s)
    if stderr != ϕ{
        send_string (eh, ‛✗’, stderr, msg)}
    else{
        send_string (eh, ‛’, stdout, msg)}
}

defn string_constant_instantiate (reg, owner, name, template_data) {
    global root_project
    global root_0D
    name_with_id ≡ gensym (‛strconst’)
    deftemp s ⇐ template_data
    if root_project != ‛’{
        s ⇐ re.sub (‛_00_’, root_project, s)}
    if root_0D != ‛’{
        s ⇐ re.sub (‛_0D_’, root_0D, s)}
    return make_leaf (name_with_id, owner, s, string_constant_handler)
}

defn string_constant_handler (eh, msg) {
    s ≡ eh.instance_data
    send_string (eh, ‛’, s, msg)
}

defn string_make_persistent (s) {
    # this is here for non_GC languages like Odin, it is a no_op for GC languages like Python
    return s
}

defn string_clone (s) {
    return s
}

import sys

# usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...
# where ${_00_} is the root directory for the project
# where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)

defn parse_command_line_args () {
    global root_project
    global root_0D
    # return a 5_element array [root_project, root_0D, arg, main_container_name, [diagram_names]]
    if (len (sys.argv) < (5+1)){
        load_error (‛usage: ${_00_} ${_0D_} app <arg> <main tab name> <diagram file name 1> ...’)
        return ϕ}
    else{
        root_project ⇐ nthargv (1)
        root_0D ⇐ nthargv (2)
        arg ≡ nthargv (3)
        main_container_name ≡ nthargv (4)
        diagram_source_files ≡ argvcdr (5)
        return [root_project, root_0D, arg, main_container_name, diagram_source_files]}
}

defn initialize_component_palette (root_project, root_0D, diagram_source_files, project_specific_components_subroutine) {
    reg ≡ make_component_registry ()
    for diagram_source in diagram_source_files{
        all_containers_within_single_file ≡ json2internal (diagram_source)
        generate_shell_components (reg, all_containers_within_single_file)
        for container in all_containers_within_single_file{
            register_component (reg, Template (name ∷ container [‛name’] , template_data ∷ container, instantiator ∷ container_instantiator))}}
    initialize_stock_components (reg)
    project_specific_components_subroutine (root_project, root_0D, reg) # add user specified components (probably only leaves)
    return reg
}

defn print_error_maybe (main_container) {
    error_port ≡ ‛✗’
    err ≡ fetch_first_output (main_container, error_port)
    if (err !=  ϕ) and (0 < len (trimws (err.srepr ()))){
        print (‛___ !!! ERRORS !!! ___’)
        print_specific_output (main_container, error_port, ⊥)}
}

# debugging helpers

defn dump_outputs (main_container) {
    print ()
    print (‛___ Outputs ___’)
    print_output_list (main_container)
}

defn trace_outputs (main_container) {
    print ()
    print (‛___ Message Traces ___’)
    print_routing_trace (main_container)
}

defn dump_hierarchy (main_container) {
    print ()
    print (‛___ Hierarchy ___«(build_hierarchy (main_container))»’)
}

defn build_hierarchy (c) {
    deftemp s ⇐ ‛’
    for child in c.children{
        s ⇐ ‛«s»«build_hierarchy (child)»’}
    deftemp indent ⇐ ‛’
    for i in range (c.depth){
        indent ⇐ indent + ‛  ’}
    return ‛\n«indent»(«c.name»«s»)’
}

defn dump_connections (c) {
    print ()
    print (‛___ connections ___’)
    dump_possible_connections (c)
    for child in c.children{
        print ()
        dump_possible_connections (child)}
}

defn trimws (s) {
    # remove whitespace from front and back of string
    return s.strip ()
}

defn clone_string (s) {
    return s

}
defvar load_errors ⇐ ⊥
defvar runtime_errors ⇐ ⊥

defn load_error (s) {
    global load_errors
    print (s)
    quit ()
    load_errors ⇐ ⊤
}

defn runtime_error (s) {
    global runtime_errors
    print (s)
    quit ()
    runtime_errors ⇐ ⊤
}

defn fakepipename_instantiate (reg, owner, name, template_data) {
    instance_name ≡ gensym (‛fakepipe’)
    return make_leaf (instance_name, owner, ϕ, fakepipename_handler)
}

defvar rand ⇐ 0

defn fakepipename_handler (eh, msg) {
    global rand
    rand ⇐ rand + 1 # not very random, but good enough _ ’rand‛ must be unique within a single run
    send_string (eh, ‛’, ‛/tmp/fakepipe«rand»’, msg)
}

defobj OhmJS_Instance_Data () {
        • pathname_0D_ ⇐ ϕ
        • grammar_name ⇐ ϕ
        • grammar_filename ⇐ ϕ
        • semantics_filename ⇐ ϕ
        • s ⇐ ϕ
}

defn ohmjs_instantiate (reg, owner, name, template_data) {
    instance_name ≡ gensym (‛OhmJS’)
    inst ≡ OhmJS_Instance_Data () # all fields have zero value before any messages are received
    return make_leaf (instance_name, owner, inst, ohmjs_handle)
}

defn ohmjs_maybe (eh, inst, causingMsg) {
    if ϕ != inst.pathname_0D_ and ϕ != inst.grammar_name and ϕ != inst.grammar_filename and ϕ != inst.semantics_filename and ϕ != inst.s{
        cmd ≡ [‛«inst.pathname_0D_»/std/ohmjs.js’, ‛«inst.grammar_name»’, ‛«inst.grammar_filename»’, ‛«inst.semantics_filename»’]
        [captured_output, err] ≡ run_command (eh, cmd, inst.s)

        if err = ϕ{
            err ≡ ‛’}
        errstring ≡ trimws (err)
        if len (errstring) = 0{
            send_string (eh, ‛’, trimws (captured_output), causingMsg)}
        else{
            send_string (eh, ‛✗’, errstring, causingMsg)}
        inst.pathname_0D_ ⇐ ϕ
        inst.grammar_name ⇐ ϕ
        inst.grammar_filename ⇐ ϕ
        inst.semantics_filename ⇐ ϕ
        inst.s ⇐ ϕ}
}

defn ohmjs_handle (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    if msg.port = ‛0D path’{
        inst.pathname_0D_ ⇐ clone_string (msg.datum.srepr ())
        ohmjs_maybe (eh, inst, msg)}
    elif msg.port = ‛grammar name’{
        inst.grammar_name ⇐ clone_string (msg.datum.srepr ())
        ohmjs_maybe (eh, inst, msg)}
    elif msg.port = ‛grammar’{
        inst.grammar_filename ⇐ clone_string (msg.datum.srepr ())
        ohmjs_maybe (eh, inst, msg)}
    elif msg.port = ‛semantics’{
        inst.semantics_filename ⇐ clone_string (msg.datum.srepr ())
        ohmjs_maybe (eh, inst, msg)}
    elif msg.port = ‛input’{
        inst.s ⇐ clone_string (msg.datum.srepr ())
        ohmjs_maybe (eh, inst, msg)}
    else{
        emsg ≡ ‛!!! ERROR: OhmJS got an illegal message port «msg.port»’
        send_string (eh, ‛✗’, emsg, msg)}
}

# all of the the built_in leaves are listed here
# future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project


defn initialize_stock_components (reg) {
    register_component (reg, Template ( ‛1then2’, ϕ, deracer_instantiate))
    register_component (reg, Template ( ‛?’, ϕ, probe_instantiate))
    register_component (reg, Template ( ‛?A’, ϕ, probeA_instantiate))
    register_component (reg, Template ( ‛?B’, ϕ, probeB_instantiate))
    register_component (reg, Template ( ‛?C’, ϕ, probeC_instantiate))
    register_component (reg, Template ( ‛trash’, ϕ, trash_instantiate))

    register_component (reg, Template ( ‛Low Level Read Text File’, ϕ, low_level_read_text_file_instantiate))
    register_component (reg, Template ( ‛Ensure String Datum’, ϕ, ensure_string_datum_instantiate))

    register_component (reg, Template ( ‛syncfilewrite’, ϕ, syncfilewrite_instantiate))
    register_component (reg, Template ( ‛stringconcat’, ϕ, stringconcat_instantiate))
    # for fakepipe
    register_component (reg, Template ( ‛fakepipename’, ϕ, fakepipename_instantiate))
    # for transpiler (ohmjs)
    register_component (reg, Template ( ‛OhmJS’, ϕ, ohmjs_instantiate))
    # register_component (reg, ϕ, string_constant (‛RWR’))
    # register_component (reg, ϕ, string_constant (‛0d/python/std/rwr.ohm’))
    # register_component (reg, ϕ, string_constant (‛0d/python/std/rwr.sem.js’))
}

defn run (pregistry, root_project, root_0D, arg, main_container_name, diagram_source_files, injectfn,
              show_hierarchy ∷ ⊤, show_connections ∷ ⊤, show_traces ∷ ⊤, show_all_outputs ∷ ⊤) {
    set_environment (root_project, root_0D)
    # get entrypoint container
    deftemp main_container ⇐ get_component_instance(pregistry, main_container_name, owner ∷ ϕ)
    if ϕ = main_container{
        load_error (‛Couldn’t find container with page name «main_container_name» in files «diagram_source_files» (check tab names, or disable compression?)‛)»
    if show_hierarchy«
        dump_hierarchy (main_container)»
    if show_connections«
        dump_connections (main_container)»
    if not load_errors«
        injectfn (root_project, root_0D, arg, main_container)»
    if show_all_outputs«
        dump_outputs (main_container)»
    else«
        print_error_maybe (main_container)
        print_specific_output (main_container, port ∷ ’‛, stderr ∷ ⊥)»
    if show_traces«
        print (’___ routing traces ___‛)
        print (routing_trace_all (main_container))»
    if show_all_outputs«
        print (’___ done ___’)}
}







