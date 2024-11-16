

def count_install (reg):                                    #line 1
    register_component ( reg,Template ( "Count", None, count_instantiator))#line 2#line 3#line 4

count_counter =  0                                          #line 5
direction =  1                                              #line 6#line 7
def count_handler (eh,msg):                                 #line 8
    global count_counter, direction                         #line 9
    if  msg. port ==  "adv":                                #line 10
        count_counter =  count_counter+ direction           #line 11
        send_int ( eh, "", count_counter, msg)              #line 12
    elif  msg. port ==  "rev":                              #line 13
        direction =  direction* - 1                         #line 14#line 15#line 16#line 17

def count_instantiator (reg,owner,name,template_data):      #line 18
    name_with_id = gensymbol ( "Count")                     #line 19
    return make_leaf ( name_with_id, owner, None, count_handler)#line 20#line 21





