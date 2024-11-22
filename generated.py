

import sys
import re
import subprocess
import shlex
import os
import json
import queue
                                                            #line 1#line 2
class Component_Registry:
    def __init__ (self,):                                   #line 3
        self.templates = {}                                 #line 4#line 5
                                                            #line 6
class Template:
    def __init__ (self,name):                               #line 7
        self.name =  name                                   #line 8#line 9
                                                            #line 10
def make_component_registry ():                             #line 11
    return Component_Registry ()                            #line 12#line 13#line 14

def register_component (reg,template):
    return abstracted_register_component ( reg, template)   #line 15#line 16

def abstracted_register_component (reg,template):           #line 17
    name =  template.name                                   #line 18
    templates_alist =  reg.templates                        #line 19
    reg.insert (NIY ( "templates",  templates_alist.insert (NIY ( name,  template))))#line 20
    return  reg                                             #line 21#line 22#line 23

def test ():                                                #line 24
    reg = make_component_registry ()                        #line 25
    reg = register_component ( reg,Template ( "c1"))        #line 26
    reg = register_component ( reg,Template ( "c2"))        #line 27
    reg = register_component ( reg,Template ( "c3"))        #line 28
    print (( "c2" in  reg.templates))                       #line 29
    return  reg.templates [c2]                              #line 30#line 31





