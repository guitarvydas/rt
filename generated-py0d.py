

def  start  ( palette , env , show_hierarchy = False , show_connections = False , show_traces = False , show_all_outputs = False ):
    root_of_project  =  env  [0]
    root_of_0D  =  env  [1]
    main_container_name  =  env  [2]
    diagram_names  =  env  [3]
    arg  =  env  [4]
    set_environment  ( root_of_project , root_of_0D )
    # get entrypoint container
    main_container  =  get_component_instance  ( palette , main_container_name , owner = None)
    if  None ==  main_container :
        load_error  ( str("Couldn;t find container with page name ") +  str( main_container_name ) +  str(" in files ") +  str( diagram_source_files ) + "(check tab names, or disable compression?)"    )
    
    if  show_hierarchy :
        dump_hierarchy  ( main_container )
    
    if  show_connections :
        dump_connections  ( main_container )
    
    if not  load_errors :
        arg  =  new_datum_string  ( arg )
        msg  =  make_message  ("", arg )
        inject  ( main_container , msg )
        if  show_all_outputs :
            dump_outputs  ( main_container )
        else:
            print_error_maybe  ( main_container )
            print_specific_output  ( main_container , port ="", stderr = False )
            if  show_traces :
                print  ("--- routing traces ---")
                print  ( routing_trace_all  ( main_container ))
            
        
        if  show_all_outputs :
            print  ("--- done ---")
        
    





