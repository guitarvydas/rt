

def install (reg):                                          #line 1
    register_component ( reg,Template ( "Count", None, instantiator))#line 2#line 3#line 4

counter =  0                                                #line 5
direction =  1                                              #line 6#line 7
def handler (eh,msg):                                       #line 8
    global counter, direction                               #line 9
    if  msg. port ==  "adv":                                #line 10
        counter =  counter+ direction                       #line 11
        send_int ( eh, "", counter, msg)                    #line 12
    elif  msg. port ==  "rev":                              #line 13
        direction =  direction* - 1                         #line 14#line 15#line 16#line 17

def instantiator (reg,owner,name,template_data):            #line 18
    name_with_id = gensymbol ( "Count")                     #line 19
    return make_leaf ( name_with_id, owner, None, handler)  #line 20#line 21





