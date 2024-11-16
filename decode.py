

def decode_install (reg):                                   #line 1
    register_component ( reg,Template ( "Decode", None, decode_instantiator))#line 2#line 3#line 4

decode_digits = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]#line 5
def decode_handler (eh,msg):                                #line 6
    global decode_digits                                    #line 7
    i = int ( msg. datum.raw ())                            #line 8
    if  i >=  0 and  i <=  9:                               #line 9
        send_string ( eh, decode_digits [ i], decode_digits [ i], msg)#line 10#line 11
    send_bang ( eh, "done", msg)                            #line 12#line 13#line 14

def decode_instantiator (reg,owner,name,template_data):     #line 15
    name_with_id = gensymbol ( "Decode")                    #line 16
    return make_leaf ( name_with_id, owner, None, decode_handler)#line 17





