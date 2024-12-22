


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
