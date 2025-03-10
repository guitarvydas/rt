


defobj Component_Registry () {
        • templates ⇐ {}
}

defobj Template () {
        • name ⇐ ϕ
        • template_data ⇐ ϕ
        • instantiator ⇐ ϕ
}

defn mkTemplate (name, template_data, instantiator) {
     deftemp templ ⇐ #fresh (Template)
     templ.name ⇐ name
     templ.template_data ⇐ template_data
     templ.instantiator ⇐ instantiator
     return templ
}

defn read_and_convert_json_file (pathname, filename) {
    # read_and_convert_json_file (pathname, filename)
}

defn json2internal (pathname, container_xml) {
    fname ≡ #basename (container_xml)
    routings ≡ read_and_convert_json_file (pathname, fname)
    return routings
}

defn delete_decls (d) {
    pass
}

defn make_component_registry () {
    return #fresh (Component_Registry)
}

defn register_component (reg, template) { return abstracted_register_component (reg, template,  ⊥) }
defn register_component_allow_overwriting (reg, template) { return abstracted_register_component (reg, template,  ⊤) }

defn abstracted_register_component (reg, template, ok_to_overwrite) {
    name ≡ mangle_name (template.name)
    if reg != ϕ and name in reg.templates and not ok_to_overwrite {
        load_error (#strcons (“Component /”, #strcons (template.name, “/ already declared”)))
	return reg
    } else {
        reg.templates@name ⇐ template
	return reg
    }
}

defn get_component_instance (reg, full_name, owner) {
    template_name ≡ mangle_name (full_name)
    if template_name in reg.templates {
        template ≡ reg.templates@template_name
        if (template = ϕ) {
            load_error (#strcons (“Registry Error (A): Can't find component /”, #strcons (template_name, “/”)))
            return ϕ
        } else {
            owner_name ≡ “”
            instance_name ≡ template_name
            if ϕ != owner {
                owner_name ⇐ owner.name
                instance_name ⇐ #strcons (owner_name, #strcons (“.”, template_name))
            } else {
                instance_name ⇐ template_name
	    }
            instance ≡ template.instantiator (reg, owner, instance_name, template.template_data)
            return instance
	}
    } else {
        load_error (#strcons (“Registry Error (B): Can't find component /”, #strcons (template_name, “/”)))
        return ϕ
    }
}

defn dump_registry (reg) {
    nl ()
    #print_stdout (“*** PALETTE ***”)
    for c in reg.templates{
        print (c.name)}
    #print_stdout (“***************”)
    nl ()
}

defn print_stats (reg) {
    #print_stdout (#strcons (“registry statistics: ”, reg.stats))
}

defn mangle_name (s) {
    ⌈ trim name to remove code from Container component names _ deferred until later (or never)⌉
    return s
}

defn generate_shell_components (reg, container_list) {
    ⌈ [⌉
    ⌈     {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},⌉
    ⌈     {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []}⌉
    ⌈ ]⌉
    if ϕ != container_list {
        for diagram in container_list {
            ⌈ loop through every component in the diagram and look for names that start with “$“ or “'“ ⌉
            ⌈ {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]},⌉
            for child_descriptor in diagram@“children” {
                if first_char_is (child_descriptor@“name”, “$”) {
                    name ≡ child_descriptor@“name”
                    cmd ≡ #stringcdr (name).strip ()
                    generated_leaf ≡ mkTemplate (name,  cmd, ↪︎shell_out_instantiate)
                    register_component (reg, generated_leaf)
                } elif first_char_is (child_descriptor@“name”, “'”) {
                    name ≡ child_descriptor@“name”
                    s ≡ #stringcdr (name)
                    generated_leaf ≡ mkTemplate (name,  s, ↪︎string_constant_instantiate)
                    register_component_allow_overwriting (reg, generated_leaf)
		}
	    }
	}
    }
    return reg
}

defn first_char (s) {
    return #stringcar (s)
}

defn first_char_is (s, c) {
    return c = first_char (s)
}


⌈ TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here⌉
⌈ I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped⌉


⌈ Data for an asyncronous component _ effectively, a function with input⌉
⌈ and output queues of messages.⌉
⌈⌉
⌈ Components can either be a user_supplied function (“lea“), or a “container“⌉
⌈ that routes messages to child components according to a list of connections⌉
⌈ that serve as a message routing table.⌉
⌈⌉
⌈ Child components themselves can be leaves or other containers.⌉
⌈⌉
⌈ `handler` invokes the code that is attached to this component.⌉
⌈⌉
⌈ `instance_data` is a pointer to instance data that the `leaf_handler`⌉
⌈ function may want whenever it is invoked again.⌉
⌈⌉

⌈ Eh_States :: enum { idle, active }⌉
defobj Eh () {
        • name ⇐ “”
        • inq ⇐ #freshQueue ()
        • outq ⇐ #freshQueue ()
        • owner ⇐ ϕ
        • children ⇐ []
        • visit_ordering ⇐ # freshQueue ()
        • connections ⇐ []
        • routings ⇐ #freshQueue ()
        • handler ⇐ ϕ
        • finject ⇐ ϕ
        • instance_data ⇐ ϕ
        • state ⇐ “idle”
        ⌈ bootstrap debugging⌉
        • kind ⇐ ϕ ⌈ enum { container, leaf, }⌉
}

⌈ Creates a component that acts as a container. It is the same as a `Eh` instance⌉
⌈ whose handler function is `container_handler`.⌉
defn make_container (name, owner) {
    deftemp eh ⇐ #fresh (Eh)
    eh.name ⇐ name
    eh.owner ⇐ owner
    eh.handler ⇐ ↪︎container_handler
    eh.finject ⇐ ↪︎container_injector
    eh.state ⇐ “idle”
    eh.kind ⇐ “container”
    return eh
}

⌈ Creates a new leaf component out of a handler function, and a data parameter⌉
⌈ that will be passed back to your handler when called.⌉

defn make_leaf (name, owner, instance_data, handler) {
    deftemp eh ⇐ #fresh (Eh)
    eh.name ⇐ #strcons (owner.name, #strcons (“.”, name))
    eh.owner ⇐ owner
    eh.handler ⇐ handler
    eh.instance_data ⇐ instance_data
    eh.state ⇐ “idle”
    eh.kind ⇐ “leaf”
    return eh
}

⌈ Sends a message on the given `port` with `data`, placing it on the output⌉
⌈ of the given component.⌉

defn send (eh,port,datum,causingMessage) {
    msg ≡ make_message(port, datum)
    put_output (eh, msg)
}

defn send_string (eh, port, s, causingMessage) {
    datum ≡ new_datum_string (s)
    msg ≡ make_message(port, datum)
    put_output (eh, msg)
}

defn forward (eh, port, msg) {
    fwdmsg ≡ make_message(port, msg.datum)
    put_output (eh, fwdmsg)
}

defn inject (eh, msg) {
    eh.finject (eh, msg)
}

⌈ Returns a list of all output messages on a container.⌉
⌈ For testing / debugging purposes.⌉

defn output_list (eh) {
    return eh.outq
}

⌈ Utility for printing an array of messages.⌉
defn print_output_list (eh) {
    #print_stdout (“{”)
    for m in #queue2list (eh.outq) {
        #print_stdout (format_message (m))
    }
    #print_stdout (“}”)
}

defn spaces (n) {
    deftemp s ⇐ “”
    for i in range (n){
        s ⇐ s + “ ”}
    return s
}

defn set_active (eh) {
    eh.state ⇐ “active”
}

defn set_idle (eh) {
    eh.state ⇐ “idle”
}

⌈ Utility for printing a specific output message.⌉

defn fetch_first_output (eh, port) {
    for msg in #queue2list (eh.outq) {
        if (msg.port = port){
            return msg.datum}}
    return ϕ
}

defn print_specific_output (eh, port) {
    ⌈ port ∷ “”⌉
    deftemp datum ⇐ fetch_first_output (eh, port)
    #print_stdout (datum.v)
}
defn print_specific_output_to_stderr (eh, port) {
    ⌈ port ∷ “”⌉
    deftemp datum ⇐ fetch_first_output (eh, port)
    ⌈ I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in...⌉
    #print_stderr (datum.v)
}

defn put_output (eh, msg) {
    #enqueue (eh.outq, msg)
}

defvar root_project ⇐ “”
defvar root_0D ⇐ “”

defn set_environment (rproject, r0D) {
    global root_project
    global root_0D
    root_project ⇐ rproject
    root_0D ⇐ r0D
}

defn probeA_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“?A”)
    return make_leaf (name_with_id, owner,  ϕ,  ↪︎probe_handler)
}

defn probeB_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol(“?B”)
    return make_leaf (name_with_id, owner,  ϕ,  ↪︎probe_handler)
}

defn probeC_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol(“?C”)
    return make_leaf (name_with_id, owner,  ϕ,  ↪︎probe_handler)
}

defn probe_handler (eh, msg) {
    s ≡ msg.datum.v
    #print_stderr (#strcons (“... probe ”, #strcons (eh.name, #strcons (“: ”, s))))
}

defn trash_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“trash”)
    return make_leaf (name_with_id, owner, ϕ, ↪︎trash_handler)
}

defn trash_handler (eh, msg) {
    ⌈ to appease dumped_on_floor checker⌉
    pass
}
defobj TwoMessages () {
        • firstmsg ⇐ ϕ
        • secondmsg ⇐ ϕ
}

⌈ Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg }⌉
defobj Deracer_Instance_Data () {
        • state ⇐ ϕ
        • buffer ⇐ ϕ
}

defn reclaim_Buffers_from_heap (inst) {
    pass
}

defn deracer_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“deracer”)
    deftemp inst ⇐ #fresh (Deracer_Instance_Data)
    inst.state ⇐ “idle”
    inst.buffer ⇐ #fresh (TwoMessages)
    eh ≡ make_leaf (name_with_id, owner, inst, ↪︎deracer_handler)
    return eh
}

defn send_firstmsg_then_secondmsg (eh, inst) {
    forward (eh, “1”, inst.buffer.firstmsg)
    forward (eh, “2”, inst.buffer.secondmsg)
    reclaim_Buffers_from_heap (inst)
}

defn deracer_handler (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    if inst.state = “idle” {
        if “1” = msg.port {
            inst.buffer.firstmsg ⇐ msg
            inst.state ⇐ “waitingForSecondmsg”
        } elif “2” = msg.port {
            inst.buffer.secondmsg ⇐ msg
            inst.state ⇐ “waitingForFirstmsg”
        } else {
            runtime_error (#strcons (“bad msg.port (case A) for deracer ”, msg.port))
	}
    } elif inst.state = “waitingForFirstmsg” {
        if “1” = msg.port {
            inst.buffer.firstmsg ⇐ msg
            send_firstmsg_then_secondmsg (eh, inst)
            inst.state ⇐ “idle”
        } else {
            runtime_error (#strcons (“bad msg.port (case B) for deracer ”, msg.port))
	}
    } elif inst.state = “waitingForSecondmsg” {
        if “2” = msg.port {
            inst.buffer.secondmsg ⇐ msg
            send_firstmsg_then_secondmsg (eh, inst)
            inst.state ⇐ “idle”
        } else {
            runtime_error (#strcons (“bad msg.port (case C) for deracer ”, msg.port))
	}
    } else {
        runtime_error (“bad state for deracer {eh.state}”)
    }
}

defn low_level_read_text_file_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol(“Low Level Read Text File”)
    return make_leaf (name_with_id, owner, ϕ,  ↪︎low_level_read_text_file_handler)
}

defn low_level_read_text_file_handler (eh, msg) {
    fname ≡ msg.datum.v
    # low_level_read_text_file_handler (eh, msg, fname, “”, “✗”)
}

defn ensure_string_datum_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol(“Ensure String Datum”)
    return make_leaf (name_with_id, owner, ϕ, ↪︎ensure_string_datum_handler)
}

defn ensure_string_datum_handler (eh, msg) {
    if “string” = msg.datum.kind () {
        forward (eh, “”, msg)
    } else {
        emsg ≡ #strcons (“*** ensure: type error (expected a string datum) but got ”, msg.datum)
        send_string (eh, “✗”, emsg, msg)
    }
}

defobj Syncfilewrite_Data () {
        • filename ⇐ “”
}

⌈ temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)⌉
defn syncfilewrite_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“syncfilewrite”)
    inst ≡ #fresh (Syncfilewrite_Data)
    return make_leaf (name_with_id, owner, inst, ↪︎syncfilewrite_handler)
}

defn syncfilewrite_handler (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    if “filename” = msg.port {
        inst.filename ⇐ msg.datum.v
    } elif “input” = msg.port {
        contents ≡ msg.datum.v
        deftemp f ⇐ open (inst.filename, “w”)
        if f != ϕ {
            f.write (msg.datum.v)
            f.close ()
            send (eh, “done”, new_datum_bang (), msg)
        } else {
            send_string (eh, “✗”, #strcons (“open error on file ”, inst.filename), msg)
	}
    }
}

defobj StringConcat_Instance_Data () {
        • buffer1 ⇐ “”
        • buffer2 ⇐ “”
        • scount ⇐ 0
}

defn stringconcat_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“stringconcat”)
    instp ≡ #fresh (StringConcat_Instance_Data)
    return make_leaf (name_with_id, owner, instp, ↪︎stringconcat_handler)
}

defn stringconcat_handler (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    if “1” = msg.port{
        inst.buffer1  ⇐ clone_string (msg.datum.v)
        inst.scount ⇐ inst.scount + 1
        maybe_stringconcat (eh, inst, msg)
    } elif “2” = msg.port {
        inst.buffer2 ⇐ clone_string (msg.datum.v)
        inst.scount ⇐ inst.scount + 1
        maybe_stringconcat (eh, inst, msg)
    } else {
        runtime_error (#strcons (“bad msg.port for stringconcat: ”, msg.port))
    }
}

defn maybe_stringconcat (eh, inst, msg) {
    if inst.scount >= 2 {
        if (0 = #len (inst.buffer1)) and (0 = #len (inst.buffer2)) {
    	    runtime_error (“something is wrong in stringconcat, both strings are 0 length”)
	} else {
	    deftemp concatenated_string ⇐ “”
	    if 0 = #len (inst.buffer1) {
		concatenated_string ⇐ inst.buffer2
	    } elif 0 = #len (inst.buffer2) {
		concatenated_string ⇐ inst.buffer1
	    } else {
		concatenated_string ⇐ inst.buffer1 + inst.buffer2
	    }    
	    send_string (eh, “”, concatenated_string, msg)
	    inst.buffer1 ⇐ “”
	    inst.buffer2 ⇐ “”
	    inst.scount ⇐ 0
	}
    }
}

⌈⌉

⌈ this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here⌉
defn shell_out_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“shell_out”)
    cmd ≡ #split_string_for_shell (template_data)
    return make_leaf (name_with_id, owner, cmd, ↪︎shell_out_handler)
}

defn shell_out_handler (eh, msg) {
    cmd ≡ eh.instance_data
    s ≡ msg.datum.v
    deftemp ret ⇐ ϕ
    deftemp rc ⇐ ϕ
    deftemp stdout ⇐ ϕ
    deftemp stderr ⇐ ϕ
    #run_command (cmd, s, ret, rc, stdout, stderr)
    if rc != 0 {
        send_string (eh, “✗”, stderr, msg)
    } else {
        send_string (eh, “”, stdout, msg)
    }
}

defn string_constant_instantiate (reg, owner, name, template_data) {
    global root_project
    global root_0D
    name_with_id ≡ gensymbol (“strconst”)
    deftemp s ⇐ template_data
    if root_project != “” {
        s ⇐ #substitute (“_00_”, root_project, s)
    }
    if root_0D != “” {
        s ⇐ #substitute (“_0D_”, root_0D, s)
    }
    return make_leaf (name_with_id, owner, s, ↪︎string_constant_handler)
}

defn string_constant_handler (eh, msg) {
    s ≡ eh.instance_data
    send_string (eh, “”, s, msg)
}

defn string_make_persistent (s) {
    ⌈ this is here for non_GC languages like Odin, it is a no_op for GC languages like Python⌉
    return s
}

defn string_clone (s) {
    return s
}

⌈ usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...⌉
⌈ where ${_00_} is the root directory for the project⌉
⌈ where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)⌉

defn initialize_component_palette (root_project, root_0D, diagram_source_files) {
    deftemp reg ⇐ make_component_registry ()
    for diagram_source in diagram_source_files {
        all_containers_within_single_file ≡ json2internal (root_project, diagram_source)
        reg ⇐ generate_shell_components (reg, all_containers_within_single_file)
        for container in all_containers_within_single_file {
            register_component (reg, mkTemplate (container@“name” , ⌈ template_data=⌉ container, ⌈ instantiator=⌉ ↪︎container_instantiator))
	}
    }
    initialize_stock_components (reg)
    return reg
}

defn print_error_maybe (main_container) {
    error_port ≡ “✗”
    err ≡ fetch_first_output (main_container, error_port)
    if (err !=  ϕ) and (0 < #len (trimws (err.v))) {
        #print_stdout (“___ !!! ERRORS !!! ___”)
        print_specific_output (main_container, error_port)
    }
}

⌈ debugging helpers⌉

defn nl () {
    #print_stdout (“”)
}

defn dump_outputs (main_container) {
    nl ()
    #print_stdout (“___ Outputs ___”)
    print_output_list (main_container)
}

defn trimws (s) {
    ⌈ remove whitespace from front and back of string⌉
    return s.strip ()
}

defn clone_string (s) {
    return s

}
defvar load_errors ⇐ ⊥
defvar runtime_errors ⇐ ⊥

defn load_error (s) {
    global load_errors
    #print_stdout (s)
    #print_nl ()
    load_errors ⇐ ⊤
}

defn runtime_error (s) {
    global runtime_errors
    #print_stdout (s)
    runtime_errors ⇐ ⊤
}

defn fakepipename_instantiate (reg, owner, name, template_data) {
    instance_name ≡ gensymbol (“fakepipe”)
    return make_leaf (instance_name, owner, ϕ, ↪︎fakepipename_handler)
}

defvar rand ⇐ 0

defn fakepipename_handler (eh, msg) {
    global rand
    rand ⇐ rand + 1 ⌈ not very random, but good enough _ 'rand' must be unique within a single run⌉
    send_string (eh, “”, #strcons (“/tmp/fakepipe”, rand), msg)
}


defobj Switch1star_Instance_Data () {
        • state ⇐ “1”
}

defn switch1star_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“switch1*”)
    instp ≡ #fresh (Switch1star_Instance_Data)
    return make_leaf (name_with_id, owner, instp, ↪︎switch1star_handler)
}

defn switch1star_handler (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    whichOutput ≡ inst.state
    if “” = msg.port {
	if “1” = whichOutput {
	    forward (eh, “1”, msg)
	    inst.state ⇐ “*”
	} elif “*” = whichOutput {
	    forward (eh, “*”, msg)
	} else {
	    send (eh, “✗”, “internal error bad state in switch1*”, msg)
	}
    } elif “reset” = msg.port {
	    inst.state ⇐ “1”
    } else {
        send (eh, “✗”, “internal error bad message for switch1*”, msg)
    }
}

defobj Latch_Instance_Data () {
        • datum ⇐ ϕ
}

defn latch_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“latch”)
    instp ≡ #fresh (Latch_Instance_Data)
    return make_leaf (name_with_id, owner, instp, ↪︎latch_handler)
}

defn latch_handler (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    if “” = msg.port {
        inst.datum ⇐ msg.datum
    } elif “release” = msg.port {
        deftemp d ⇐ inst.datum
        send (eh, “”, d, msg)
        inst.datum ⇐ ϕ
    } else {
        send (eh, “✗”, “internal error bad message for latch”, msg)
    }
}

⌈ all of the the built_in leaves are listed here⌉
⌈ future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project⌉

defn initialize_stock_components (reg) {
    register_component (reg, mkTemplate ( “1then2”, ϕ, ↪︎deracer_instantiate))
    register_component (reg, mkTemplate ( “?A”, ϕ, ↪︎probeA_instantiate))
    register_component (reg, mkTemplate ( “?B”, ϕ, ↪︎probeB_instantiate))
    register_component (reg, mkTemplate ( “?C”, ϕ, ↪︎probeC_instantiate))
    register_component (reg, mkTemplate ( “trash”, ϕ, ↪︎trash_instantiate))

    register_component (reg, mkTemplate ( “Low Level Read Text File”, ϕ, ↪︎low_level_read_text_file_instantiate))
    register_component (reg, mkTemplate ( “Ensure String Datum”, ϕ, ↪︎ensure_string_datum_instantiate))

    register_component (reg, mkTemplate ( “syncfilewrite”, ϕ, ↪︎syncfilewrite_instantiate))
    register_component (reg, mkTemplate ( “stringconcat”, ϕ, ↪︎stringconcat_instantiate))
    register_component (reg, mkTemplate ( “switch1*”, ϕ, ↪︎switch1star_instantiate))
    register_component (reg, mkTemplate ( “latch”, ϕ, ↪︎latch_instantiate))
       ⌈ for fakepipe⌉
    register_component (reg, mkTemplate ( “fakepipename”, ϕ, ↪︎fakepipename_instantiate))
}

defn argv () {
    return #get_argv ()
}

defn initialize () {
    root_of_project ≡ #nthargv (1) 
    root_of_0D ≡ #nthargv (2)
    arg ≡ #nthargv (3)
    main_container_name ≡ #nthargv (4)
    diagram_names ≡ #nthargvcdr (5)
    palette ≡ initialize_component_palette (root_of_project, root_of_0D, diagram_names)
    return [palette, [root_of_project, root_of_0D, main_container_name, diagram_names, arg]]
}

defn start (palette, env) { start_helper (palette, env, ⊥) }
defn start_show_all (palette, env) { start_helper (palette, env, ⊤) }
defn start_helper (palette, env, show_all_outputs) {
    root_of_project ≡ env [0]
    root_of_0D ≡ env [1]
    main_container_name ≡ env [2]
    diagram_names ≡ env [3]
    arg ≡ env [4]
    set_environment (root_of_project, root_of_0D)
    ⌈ get entrypoint container⌉
    deftemp main_container ⇐ get_component_instance(palette, main_container_name, ϕ)
    if ϕ = main_container {
        load_error (#strcons (“Couldn't find container with page name /”,
	              #strcons (main_container_name,
		        #strcons (“/ in files ”,
			  #strcons (#asstr (diagram_names), “ (check tab names, or disable compression?)”)))))
    }
    if not load_errors {
        deftemp marg ⇐ new_datum_string (arg)
        deftemp msg ⇐ make_message(“”, marg)
        inject (main_container, msg)
        if show_all_outputs {
            dump_outputs (main_container)
        } else {
            print_error_maybe (main_container)
	    outp ≡ fetch_first_output (main_container, “”)
	    if ϕ = outp {
                #print_stdout (“«««no outputs»»»)”)
            } else {
                print_specific_output (main_container, “”)
            }
        }
        if show_all_outputs {
            #print_stdout (“--- done ---”)
        }
    }
}


⌈ utility functions ⌉
defn send_int (eh, port, i, causing_message) {
    datum ≡ new_datum_string (#asstr (i))
    send (eh, port, datum, causing_message)
}

defn send_bang (eh, port, causing_message) {
    datum ≡ new_datum_bang ()
    send (eh, port, datum, causing_message)            
}
