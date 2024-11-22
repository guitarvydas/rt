

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
    def __init__ (self,name,template_data,instantiator):    #line 7
        self.name =  name                                   #line 8
        self.template_data =  template_data                 #line 9
        self.instantiator =  instantiator                   #line 10#line 11
                                                            #line 12
def make_component_registry ():                             #line 13
    return Component_Registry ()                            #line 14#line 15#line 16

def register_component (reg,template):
    return abstracted_register_component ( reg, template)   #line 17#line 18

def abstracted_register_component (reg,template):           #line 19
    name =  template.name                                   #line 20
    templates_alist =  reg.templates                        #line 21
    reg.insert (NIY ( "templates",  templates_alist.insert (NIY ( name,  template))))#line 22
    return  reg                                             #line 23#line 24#line 25

def test ():                                                #line 26
    reg = make_component_registry ()                        #line 27
    reg = register_component ( reg,Template ( "c1", 1, 2))  #line 28
    reg = register_component ( reg,Template ( "c2", 3, 4))  #line 29
    reg = register_component ( reg,Template ( "c3", 5, 6))  #line 30
    print (( "c2" in  reg.templates))                       #line 31
    return  reg.templates [ "c2"]                           #line 32#line 33





