⌈ dynamic routing descriptors⌉

defconst drInject ≡ “inject”
defconst drSend ≡ “send”
defconst drInOut ≡ “inout”
defconst drForward ≡ “forward”
defconst drDown ≡ “down”
defconst drUp ≡ “up”
defconst drAcross ≡ “across”
defconst drThrough ≡ “through”

⌈ See “class_free programming“ starting at 45:01 of https://www.youtube.com/watch?v=XFTOG895C7c⌉


defn make_Routing_Descriptor (action, component, port, message) {
    return {
        “action”: action,
        “component”: component,
        “port”: port,
        “message”: message
        }
}

⌈⌉
defn make_Send_Descriptor (component, port, message, cause_port, cause_message) {
    rdesc ≡ make_Routing_Descriptor (drSend, component, port, message)
    return {
        “action”: drSend,
        “component”: rdesc@component,
        “port”: rdesc@port,
        “message”: rdesc@message,
        “cause_port”: cause_port,
        “cause_message”: cause_message,
        “fmt”: fmt_send
        }
}

defn log_send (sender, sender_port, msg, cause_msg) {
    send_desc ≡ make_Send_Descriptor (sender, sender_port, msg, cause_msg.port, cause_msg)
    append_routing_descriptor (sender.owner, send_desc)
}

defn log_send_string (sender, sender_port, msg, cause_msg) {
    send_desc ≡ make_Send_Descriptor (sender, sender_port, msg, cause_msg.port, cause_msg)
    append_routing_descriptor (sender.owner, send_desc)
}

defn fmt_send (desc, indent) {
    return “”
    ⌈return f'\n{indent}⋯ {desc@component.name}.“{desc@cause_port}“ ∴ {desc@component.name}.“{desc@port}“ {format_message (desc@message)}'⌉
}

defn fmt_send_string (desc, indent) {
    return fmt_send (desc, indent)
}

⌈⌉
defn make_Forward_Descriptor (component, port, message, cause_port, cause_message) {
    rdesc ≡ make_Routing_Descriptor (drSend, component, port, message)
    fmt_forward ≡ λ (desc) : “”
    return {
        “action”: drForward,
        “component”: rdesc@component,
        “port”: rdesc@port,
        “message”: rdesc@message,
        “cause_port”: cause_port,
        “cause_message”: cause_message,
        “fmt”: fmt_forward
        }
}

defn log_forward (sender, sender_port, msg, cause_msg) {
    pass ⌈ when needed, it is too frequent to bother logging⌉
}

defn fmt_forward (desc) {
    print (strcons (“*** Error fmt_forward ”, desc))
    quit ()
}

⌈⌉
defn make_Inject_Descriptor (receiver, port, message) {
    rdesc ≡ make_Routing_Descriptor (drInject,  receiver,  port,  message)
    return {
        “action”: drInject,
        “component”: rdesc@component,
        “port”: rdesc@port,
        “message”: rdesc@message,
        “fmt” : fmt_inject
        }
}

defn log_inject (receiver, port, msg) {
    inject_desc ≡ make_Inject_Descriptor (receiver, port, msg)
    append_routing_descriptor (receiver, inject_desc)
}

defn fmt_inject (desc, indent) {
    ⌈return f'\n{indent}⟹  {desc@component.name}.“{desc@port}“ {format_message (desc@message)}'⌉
    return strcons (“\n”,
             strcons (indent,
	       strcons (“⟹  ”,
	         strcons (desc@component.name,
		   strcons (“.”,
		     strcons (desc@port,
		       strcons (“ ”, format_message (desc@message))))))))
}

⌈⌉
defn make_Down_Descriptor (container, source_port, source_message, target, target_port, target_message) {
    return {
        “action”: drDown,
        “container”: container,
        “source_port”: source_port,
        “source_message”: source_message,
        “target”: target,
        “target_port”: target_port,
        “target_message”: target_message,
        “fmt” : fmt_down
        }
}

defn log_down (container, source_port, source_message, target, target_port, target_message) {
    rdesc ≡ make_Down_Descriptor (container, source_port, source_message, target, target_port, target_message)
    append_routing_descriptor (container, rdesc)
}

defn fmt_down (desc, indent) {
    ⌈return f'\n{indent}↓ {desc@container.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“ {format_message (desc@target_message)}'⌉
    return strcons (“\n”,
             strcons (indent,
	       strcons (“ ↓ ”,
	         strcons (desc@container.name,
		   strcons (“.”,
		     strcons (desc@source_port,
		       strcons (“ ➔ ”,
		         strcons (desc@target.name,
			   strcons (“.”,
			     strcons (desc@target_port,
			       strcons (“ ”, format_message (desc@target_message))))))))))))
}

⌈⌉
defn make_Up_Descriptor (source, source_port, source_message, container, container_port, container_message) {
    return {
        “action”: drUp,
        “source”: source,
        “source_port”: source_port,
        “source_message”: source_message,
        “container”: container,
        “container_port”: container_port,
        “container_message”: container_message,
        “fmt” : fmt_up
        }
}

defn log_up (source, source_port, source_message, container, target_port, target_message) {
    rdesc ≡ make_Up_Descriptor (source, source_port, source_message, container, target_port, target_message)
    append_routing_descriptor (container, rdesc)
}

defn fmt_up (desc, indent) {
    ⌈return f'\n{indent}↑ {desc@source.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@container_port}“ {format_message (desc@container_message)}'⌉
    return strcons (“\n”,
             strcons (indent,
	       strcons (“↑ ”,
	         strcons (desc@source.name,
		   strcons (“.”,
		     strcons (desc@source_port,
		       strcons (“ ➔ ”,
		         strcons (desc@container.name,
			   strcons (“.”,
			     strcons (desc@container_port,
			       strcons (“ ”, format_message (desc@container_message))))))))))))
}

defn make_Across_Descriptor (container, source, source_port, source_message, target, target_port, target_message) {
    return {
        “action”: drAcross,
        “container”: container,
        “source”: source,
        “source_port”: source_port,
        “source_message”: source_message,
        “target”: target,
        “target_port”: target_port,
        “target_message”: target_message,
        “fmt” : fmt_across
        }
}

defn log_across (container, source, source_port, source_message, target, target_port, target_message) {
    rdesc ≡ make_Across_Descriptor (container, source, source_port, source_message, target, target_port, target_message)
    append_routing_descriptor (container, rdesc)
}

defn fmt_across (desc, indent) {
    ⌈return f'\n{indent}→ {desc@source.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“  {format_message (desc@target_message)}'⌉
    return strcons (“\n”,
             strcons (indent,
	       strcons (“→ ”,
	         strcons (desc@source.name,
		   strcons (“.”,
		     strcons (desc@source_port,
		       strcons (“ ➔ ”,
		         strcons (desc@target.name,
			   strcons (“.”,
			     strcons (desc@target_port,
			       strcons (“  ”, format_message (desc@target_message))))))))))))
}

⌈⌉
defn make_Through_Descriptor (container, source_port, source_message, target_port, message) {
    return {
        “action”: drThrough,
        “container”: container,
        “source_port”: source_port,
        “source_message”: source_message,
        “target_port”: target_port,
        “message”: message,
        “fmt” : fmt_through
        }
}

defn log_through (container, source_port, source_message, target_port, message) {
    rdesc ≡ make_Through_Descriptor (container, source_port, source_message, target_port, message)
    append_routing_descriptor (container, rdesc)
}

defn fmt_through (desc, indent) {
    ⌈return f'\n{indent}⇶ {desc @container.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@target_port}“ {format_message (desc@message)}'⌉
    return strcons (“\n”,
             strcons (indent,
	       strcons (“⇶ ”,
	         strcons (desc@container.name,
		   strcons (“.”,
		     strcons (desc@source_port,
		       strcons (“ ➔ ”,
		         strcons (desc@container.name,
			   strcons (“.”,
			     strcons (desc@target_port,
			       strcons (“ ”, format_message (desc@message))))))))))))
}

⌈⌉
defn make_InOut_Descriptor (container, component, in_message, out_port, out_message) {
    return {
        “action”: drInOut,
        “container”: container,
        “component”: component,
        “in_message”: in_message,
        “out_message”: out_message,
        “fmt” : fmt_inout
        }
}

defn log_inout (container, component, in_message) {
    if component.outq.empty () {
        log_inout_no_output (container, component, in_message) }
    else {
        log_inout_recursively (container, component, in_message, list (component.outq.queue)) }
}

defn log_inout_no_output (container, component, in_message) {
    rdesc ≡ make_InOut_Descriptor (container, component, in_message, ϕ, ϕ)
    append_routing_descriptor (container, rdesc)
}

defn log_inout_single (container, component, in_message, out_message) {
    rdesc ≡ make_InOut_Descriptor (container,  component, in_message, ϕ, out_message)
    append_routing_descriptor (container, rdesc)
}

defn log_inout_recursively (container, component, in_message, out_messages) {
    if [] = out_messages {
        pass }
    else {
        m ≡ car (out_messages)
        rest ≡ cdr (out_messages)
        log_inout_single (container, component, in_message, m)
        log_inout_recursively (container, component, in_message, rest) }
}

defn fmt_inout (desc, indent) {
    outm ≡ desc@out_message
    if ϕ = outm {
        return strcons (“\n”, strcons (indent, “  ⊥”))
    } else {
        return strcons (“\n”, 
                 strcons (indent,
		   strcons (“  ∴ ”,
		     strcons (desc@component.name,
		       strcons (“ ”, format_message (outm))))))
    }
}

defn log_tick (container, component, in_message) {
    pass
}

⌈⌉
defn routing_trace_all (container) {
    indent ≡ “”
    lis ≡ list (container.routings.queue)
    return recursive_routing_trace (container, lis, indent)
}

defn recursive_routing_trace (container, lis, indent) {
    if [] = lis {
        return “”}
    else {
        desc ≡ first (lis)
        formatted ≡ desc@fmt (desc, indent)
        return formatted + recursive_routing_trace (container, rest (lis), indent + “  ”)}
}

defn log_connection (container, connector, message) {
    if “down” = connector.direction{
        log_down (container,
	          ⌈ source port = ⌉connector.sender.port,
		  ⌈ source message = ⌉ϕ,
		  ⌈ target = ⌉connector.receiver.component,
		  ⌈ target port = ⌉connector.receiver.port,
                  ⌈ target message = ⌉message) }
    elif “up” = connector.direction {
        log_up (connector.sender.component, connector.sender.port, ϕ, container, connector.receiver.port, message) }
    elif “across” = connector.direction {
        log_across (container,
                    connector.sender.component, connector.sender.port, ϕ,
                    connector.receiver.component, connector.receiver.port, message) }
    elif “through” = connector.direction {
        log_through (container, connector.sender.port, ϕ,
                     connector.receiver.port, message) }
    else {
        print (strcons (“*** FATAL error: in log_connection /”, strcons (connector.direction, strcons (“/ /”, strcons (message.port, strcons (“/ /”, strcons (message.datum.srepr (), “/”)))))))
        exit () }
}

defn step_children (container, causingMessage) {
    container.state ⇐ “idle”
    for child in list (container.visit_ordering.queue) {
        ⌈ child = container represents self, skip it⌉
        if (not (is_self (child, container))){
            if (not (child.inq.empty ())){
                msg ≡ child.inq.get ()
                [began_long_run, continued_long_run, ended_long_run] ⇐ step_child (child, msg)
                if began_long_run {
                    save_message (child, msg)}
                elif continued_long_run {
                    pass }
                elif ended_long_run {
                    ⌈log_inout (container, child, fetch_saved_message_and_clear (child))⌉}
                else {
                    ⌈log_inout (container, child, msg)⌉}
                destroy_message(msg)}
            else {
                if child.state !=  “idle” {
                    msg ≡ force_tick (container, child)
                    child.handler(child, msg)
                    ⌈log_tick (container, child, msg)⌉
                    destroy_message(msg)}}
            
            if child.state = “active” {
                ⌈ if child remains active, then the container must remain active and must propagate “ticks“ to child⌉
                container.state ⇐ “active”}
            
            while (not (child.outq.empty ())) {
                msg ≡ child.outq.get ()
                route(container, child, msg)
                destroy_message(msg)}}}


}
