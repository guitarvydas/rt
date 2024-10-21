defn deracer_handler (eh, msg) {
    inst ⇐ eh.instance_data
    if inst.state = “idle” {
        if “1” = msg.port{
            inst.buffer.first ⇐ msg
            inst.state ⇐ “waitingForSecond”}
        elif “2” = msg.port{
            inst.buffer.second ⇐ msg
            inst.state ⇐ “waitingForFirst”}
        else{
            runtime_error (strcons (“bad msg.port (case A) for deracer ”, msg.port))}}
    elif inst.state = “waitingForFirst” {
        if “1” = msg.port{
            inst.buffer.first ⇐ msg
            send_first_then_second (eh, inst)
            inst.state ⇐ “idle”}
        else{
            runtime_error (strcons (“bad msg.port (case B) for deracer ”, msg.port))}}
    elif inst.state = “waitingForSecond”{
        if “2” = msg.port{
            inst.buffer.second ⇐ msg
            send_first_then_second (eh, inst)
            inst.state ⇐ “idle”}
        else{
            runtime_error (strcons (“bad msg.port (case C) for deracer ”, msg.port))}}
    else{
        runtime_error (“bad state for deracer {eh.state}”)}
}

defn low_level_read_text_file_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol(“Low Level Read Text File”)
    return make_leaf (name_with_id, owner, ϕ, low_level_read_text_file_handler)
}

defn low_level_read_text_file_handler (eh, msg) {
    fname ≡ msg.datum.srepr ()
    # low_level_read_text_file_handler (eh, msg, fname, “”, “✗”)
}

defn ensure_string_datum_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol(“Ensure String Datum”)
    return make_leaf (name_with_id, owner, ϕ, ensure_string_datum_handler)
}

defn ensure_string_datum_handler (eh, msg) {
    if “string” = msg.datum.kind (){
        forward (eh, “”, msg)}
    else{
        emsg ≡ strcons (“*** ensure: type error (expected a string datum) but got ”, msg.datum)
        send_string (eh, “✗”, emsg, msg)}
}

defobj Syncfilewrite_Data () {
        • filename ⇐ “”
}

⌈ temp copy for bootstrap, sends “done“ (error during bootstrap if not wired)⌉
defn syncfilewrite_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“syncfilewrite”)
    inst ≡ Syncfilewrite_Data ()
    return make_leaf (name_with_id, owner, inst, syncfilewrite_handler)
}

defn syncfilewrite_handler (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    if “filename” = msg.port {
        inst.filename ⇐ msg.datum.srepr ()}
    elif “input” = msg.port {
        contents ≡ msg.datum.srepr ()
        deftemp f ⇐ open (inst.filename, “w”)
        if f != ϕ{
            f.write (msg.datum.srepr ())
            f.close ()
            send (eh, “done”, new_datum_bang (), msg)}
        else{
            send_string (eh, “✗”, strcons (“open error on file ”, inst.filename), msg)}}
}

defobj StringConcat_Instance_Data () {
        • buffer1 ⇐ ϕ
        • buffer2 ⇐ ϕ
        • count ⇐ 0
}

defn stringconcat_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“stringconcat”)
    instp ≡ StringConcat_Instance_Data ()
    return make_leaf (name_with_id, owner, instp, stringconcat_handler)
}

defn stringconcat_handler (eh, msg) {
    deftemp inst ⇐ eh.instance_data
    if “1” = msg.port{
        inst.buffer1 ⇐ clone_string (msg.datum.srepr ())
        inst.count ⇐ inst.count + 1
        maybe_stringconcat (eh, inst, msg)}
    elif “2” = msg.port{
        inst.buffer2 ⇐ clone_string (msg.datum.srepr ())
        inst.count ⇐ inst.count + 1
        maybe_stringconcat (eh, inst, msg)}
    else{
        runtime_error (strcons (“bad msg.port for stringconcat: ”, msg.port))
    }
}

defn maybe_stringconcat (eh, inst, msg) {
    if (0 = len (inst.buffer1)) and (0 = len (inst.buffer2)){
        runtime_error (“something is wrong in stringconcat, both strings are 0 length”)}
    if inst.count >= 2{
        deftemp concatenated_string ⇐ “”
        if 0 = len (inst.buffer1){
            concatenated_string ⇐ inst.buffer2}
        elif 0 = len (inst.buffer2){
            concatenated_string ⇐ inst.buffer1}
        else{
            concatenated_string ⇐ inst.buffer1 + inst.buffer2}        
        send_string (eh, “”, concatenated_string, msg)
        inst.buffer1 ⇐ ϕ
        inst.buffer2 ⇐ ϕ
        inst.count ⇐ 0}
}

⌈⌉

⌈ this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here⌉
defn shell_out_instantiate (reg, owner, name, template_data) {
    name_with_id ≡ gensymbol (“shell_out”)
    cmd ≡ shlex.split (template_data)
    return make_leaf (name_with_id, owner, cmd, shell_out_handler)
}

defn shell_out_handler (eh, msg) {
    cmd ≡ eh.instance_data
    s ≡ msg.datum.srepr ()
    [stdout, stderr] ⇐ run_command (eh, cmd, s)
    if stderr != ϕ{
        send_string (eh, “✗”, stderr, msg)}
    else{
        send_string (eh, “”, stdout, msg)}
}

defn string_constant_instantiate (reg, owner, name, template_data) {
    global root_project
    global root_0D
    name_with_id ≡ gensymbol (“strconst”)
    deftemp s ⇐ template_data
    if root_project != “”{
        s ⇐ re.sub (“_00_”, root_project, s)}
    if root_0D != “”{
        s ⇐ re.sub (“_0D_”, root_0D, s)}
    return make_leaf (name_with_id, owner, s, string_constant_handler)
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

import sys

⌈ usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ...⌉
⌈ where ${_00_} is the root directory for the project⌉
⌈ where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python)⌉



defn initialize_component_palette (root_project, root_0D, diagram_source_files) {
    reg ≡ make_component_registry ()
    for diagram_source in diagram_source_files{
        all_containers_within_single_file ≡ json2internal (diagram_source)
        generate_shell_components (reg, all_containers_within_single_file)
        for container in all_containers_within_single_file{
            register_component (reg, Template (name ∷ container@name , template_data ∷ container, instantiator ∷ container_instantiator))}}
    initialize_stock_components (reg)
    return reg
}

defn print_error_maybe (main_container) {
    error_port ≡ “✗”
    err ≡ fetch_first_output (main_container, error_port)
    if (err !=  ϕ) and (0 < len (trimws (err.srepr ()))){
        print (“___ !!! ERRORS !!! ___”)
        print_specific_output (main_container, error_port, ⊥)}
}

⌈ debugging helpers⌉

defn dump_outputs (main_container) {
    print ()
    print (“___ Outputs ___”)
    print_output_list (main_container)
}

defn trace_outputs (main_container) {
    print ()
    print (“___ Message Traces ___”)
    print_routing_trace (main_container)
}

defn dump_hierarchy (main_container) {
    print ()
    print (strcons (“___ Hierarchy ___”, (build_hierarchy (main_container))))
}

defn build_hierarchy (c) {
    deftemp s ⇐ “”
    for child in c.children{
        s ⇐ strcons (s, build_hierarchy (child))}
    deftemp indent ⇐ “”
    for i in range (c.depth){
        indent ⇐ indent + “  ”}
    return strcons (“\n”, strcons (indent, strcons (“(”, strcons (c.name, strcons (s, “)”)))))
}

defn dump_connections (c) {
    print ()
    print (“___ connections ___”)
    dump_possible_connections (c)
    for child in c.children{
        print ()
        dump_possible_connections (child)}
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
    instance_name ≡ gensymbol (“fakepipe”)
    return make_leaf (instance_name, owner, ϕ, fakepipename_handler)
}

defvar rand ⇐ 0

defn fakepipename_handler (eh, msg) {
    global rand
    rand ⇐ rand + 1 ⌈ not very random, but good enough _ 'rand' must be unique within a single run⌉
    send_string (eh, “”, strcons (“/tmp/fakepipe”, rand), msg)
}


⌈ all of the the built_in leaves are listed here⌉
⌈ future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project⌉


defn initialize_stock_components (reg) {
    register_component (reg, Template ( “1then2”, ϕ, deracer_instantiate))
    register_component (reg, Template ( “?”, ϕ, probe_instantiate))
    register_component (reg, Template ( “?A”, ϕ, probeA_instantiate))
    register_component (reg, Template ( “?B”, ϕ, probeB_instantiate))
    register_component (reg, Template ( “?C”, ϕ, probeC_instantiate))
    register_component (reg, Template ( “trash”, ϕ, trash_instantiate))

    register_component (reg, Template ( “Low Level Read Text File”, ϕ, low_level_read_text_file_instantiate))
    register_component (reg, Template ( “Ensure String Datum”, ϕ, ensure_string_datum_instantiate))

    register_component (reg, Template ( “syncfilewrite”, ϕ, syncfilewrite_instantiate))
    register_component (reg, Template ( “stringconcat”, ϕ, stringconcat_instantiate))
    ⌈ for fakepipe⌉
    register_component (reg, Template ( “fakepipename”, ϕ, fakepipename_instantiate))
}


defn initialize () {
    root_of_project ≡ nthargv (1) 
    root_of_0D ≡ nthargv (2)
    arg ≡ nthargv (3)
    main_container_name ≡ nthargv (4)
    diagram_names ≡ nthargvcdr (5)
    palette ≡ initialize_component_palette (root_project, root_0D, diagram_names)
    return [palette, [root_of_project, root_of_0D, main_container_name, diagram_names, arg]]
}

defn start (palette, env, show_hierarchy∷False, show_connections∷False, show_traces∷False, show_all_outputs∷False) {
    root_of_project ≡ env [0]
    root_of_0D ≡ env [1]
    main_container_name ≡ env [2]
    diagram_names ≡ env [3]
    arg ≡ env [4]
    set_environment (root_of_project, root_of_0D)
    ⌈ get entrypoint container⌉
    main_container ⇐ get_component_instance(palette, main_container_name, owner∷ϕ)
    if ϕ = main_container {
        load_error (strcons (“Couldn't find container with page name ”,
	              strcons (main_container_name,
		        strcons (“ in files ”,
			  strcons (diagram_source_files, “(check tab names, or disable compression?)”)))))
    }
    if show_hierarchy {
        dump_hierarchy (main_container)
    }
    if show_connections {
        dump_connections (main_container)
    }
    if not load_errors {
        arg ⇐ new_datum_string (arg)
        msg ⇐ make_message(“”, arg)
        inject (main_container, msg)
        if show_all_outputs {
            dump_outputs (main_container)
        } else {
            print_error_maybe (main_container)
            print_specific_output (main_container, port∷“”, stderr∷False)
            if show_traces {
                print (“--- routing traces ---”)
                print (routing_trace_all (main_container))
             }
        }
        if show_all_outputs {
            print (“--- done ---”)
        }
    }
}



⌈ utility functions ⌉
defn send_int (eh, port, i, causing_message) {
    datum ≡ new_datum_int (i)
    send (eh, port, datum, causing_message)
}

defn send_bang (eh, port, causing_message) {
    datum ≡ new_datum_bang ()
    send (eh, port, datum, causing_message)            
}
  
