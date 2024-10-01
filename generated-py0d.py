

def  initialize  ():
    root_of_project  =  sys.argv[0]
    root_of_0D  =  sys.argv[1]
    arg  =  sys.argv[2]
    main_container_name  =  sys.argv[3]
    diagram_names  =  sys.argv[4]
    palette  =  initialize_component_palette  ( root_project , root_0D , diagram_names )
    return [ palette , [ root_of_project , root_of_0D , main_container_name , diagram_names , arg ]]





