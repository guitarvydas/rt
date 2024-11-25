
                                                            #|line 1|# #|line 2|# #|line 3|#
(defun Component_Registry (&optional )                      #|line 4|#
  (list
    (cons "templates"  nil)                                 #|line 5|#) #|line 6|#)
                                                            #|line 7|#
(defun Template (&optional  name  template_data  instantiator) #|line 8|#
  (list
    (cons "name"  name)                                     #|line 9|#
    (cons "template_data"  template_data)                   #|line 10|#
    (cons "instantiator"  instantiator)                     #|line 11|#) #|line 12|#)
                                                            #|line 13|#
(defun read_and_convert_json_file (&optional  pathname  filename)
  (declare (ignorable  pathname  filename))                 #|line 14|#

  ;; read json from a named file and convert it into internal form (a list of Container alists)
  (with-open-file (f (format nil "~a/~a.lisp" pathname filename) :direction :input)
    (read f))
                                                            #|line 15|# #|line 16|#
  )
(defun json2internal (&optional  pathname  container_xml)
  (declare (ignorable  pathname  container_xml))            #|line 18|#
  (let ((fname  container_xml                               #|line 19|#))
    (declare (ignorable fname))
    (let ((routings (funcall (quote read_and_convert_json_file)   pathname  fname  #|line 20|#)))
      (declare (ignorable routings))
      (return-from json2internal  routings)                 #|line 21|#)) #|line 22|#
  )
(defun delete_decls (&optional  d)
  (declare (ignorable  d))                                  #|line 24|#
  #| pass |#                                                #|line 25|# #|line 26|#
  )
(defun make_component_registry (&optional )
  (declare (ignorable ))                                    #|line 28|#
  (return-from make_component_registry (funcall (quote Component_Registry) )) #|line 29|# #|line 30|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component (funcall (quote abstracted_register_component)   reg  template  nil )) #|line 32|#
  )
(defun register_component_allow_overwriting (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component_allow_overwriting (funcall (quote abstracted_register_component)   reg  template  t )) #|line 33|#
  )
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)
  (declare (ignorable  reg  template  ok_to_overwrite))     #|line 35|#
  (let ((name (funcall (quote mangle_name)  (field "name"  template)  #|line 36|#)))
    (declare (ignorable name))
    (cond
      (( and  (dict-in?  name (field "templates"  reg)) (not  ok_to_overwrite)) #|line 37|#
        (funcall (quote load_error)   (concatenate 'string  "Component /"  (concatenate 'string (field "name"  template)  "/ already declared"))  #|line 38|#)
        (return-from abstracted_register_component  reg)    #|line 39|#
        )
      (t                                                    #|line 40|#
        (let ((templates_alist (field "templates"  reg)))
          (declare (ignorable templates_alist))             #|line 41|#
          (setf  reg (cons (cons  "templates" (setf  templates_alist (cons (cons  name  template)  templates_alist)))  reg)) #|line 42|#
          (return-from abstracted_register_component  reg)  #|line 43|#) #|line 44|#
        )))                                                 #|line 45|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 47|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 48|#)))
    (declare (ignorable template_name))
    (cond
      (( dict-in?   template_name (field "templates"  reg)) #|line 49|#
        (let ((template (nth  template_name (field "templates"  reg))))
          (declare (ignorable template))                    #|line 50|#
          (cond
            (( equal    template  nil)                      #|line 51|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error (A): Can;t find component /"  (concatenate 'string  template_name  "/"))  #|line 52|#)
              (return-from get_component_instance  nil)     #|line 53|#
              )
            (t                                              #|line 54|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 55|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 56|#
                  (cond
                    ((not (equal   nil  owner))             #|line 57|#
                      (setf  owner_name (field "name"  owner)) #|line 58|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))) #|line 59|#
                      )
                    (t                                      #|line 60|#
                      (setf  instance_name  template_name)  #|line 61|#
                      ))
                  (let ((instance (funcall (field "instantiator"  template)   reg  owner  instance_name (field "template_data"  template)  #|line 62|#)))
                    (declare (ignorable instance))
                    (setf (field "depth"  instance) (funcall (quote calculate_depth)   instance  #|line 63|#))
                    (return-from get_component_instance  instance))))
              )))                                           #|line 64|#
        )
      (t                                                    #|line 65|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 66|#)
        (return-from get_component_instance  nil)           #|line 67|#
        )))                                                 #|line 68|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                 #|line 69|#
  (cond
    (( equal   (field "owner"  eh)  nil)                    #|line 70|#
      (return-from calculate_depth  0)                      #|line 71|#
      )
    (t                                                      #|line 72|#
      (return-from calculate_depth (+  1 (funcall (quote calculate_depth)  (field "owner"  eh) ))) #|line 73|#
      ))                                                    #|line 74|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 76|#
  (funcall (quote nl) )                                     #|line 77|#
  (format *standard-output* "~a"  "*** PALETTE ***")        #|line 78|#
  (loop for c in (field "templates"  reg)
    do
      (progn
        c                                                   #|line 79|#
        (funcall (quote print)  (field "name"  c) )         #|line 80|#
        ))
  (format *standard-output* "~a"  "***************")        #|line 81|#
  (funcall (quote nl) )                                     #|line 82|# #|line 83|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 85|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (field "stats"  reg))) #|line 86|# #|line 87|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 89|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 90|#
  (return-from mangle_name  s)                              #|line 91|# #|line 92|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 94|#
  #|  [ |#                                                  #|line 95|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 96|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 97|#
  #|  ] |#                                                  #|line 98|#
  (let (( regkvs  reg))
    (declare (ignorable  regkvs))                           #|line 99|#
    (cond
      ((not (equal   nil  container_list))                  #|line 100|#
        (loop for diagram in  container_list
          do
            (progn
              diagram                                       #|line 101|#
              #|  loop through every component in the diagram and look for names that start with “$“ |# #|line 102|#
              #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 103|#
              (loop for child_descriptor in (dict-lookup   diagram  "children")
                do
                  (progn
                    child_descriptor                        #|line 104|#
                    (cond
                      ((funcall (quote first_char_is)  (dict-lookup   child_descriptor  "name")  "$" ) #|line 105|#
                        (let ((name (dict-lookup   child_descriptor  "name")))
                          (declare (ignorable name))        #|line 106|#
                          (let ((cmd (funcall (field "strip"  (subseq  name 1)) )))
                            (declare (ignorable cmd))       #|line 107|#
                            (let ((generated_leaf (funcall (quote Template)   name  #'shell_out_instantiate  cmd  #|line 108|#)))
                              (declare (ignorable generated_leaf))
                              (setf  regkvs (cons (funcall (quote register_component)   regkvs  generated_leaf )  regkvs)) #|line 109|#)))
                        )
                      ((funcall (quote first_char_is)  (dict-lookup   child_descriptor  "name")  "'" ) #|line 110|#
                        (let ((name (dict-lookup   child_descriptor  "name")))
                          (declare (ignorable name))        #|line 111|#
                          (let ((s  (subseq  name 1)        #|line 112|#))
                            (declare (ignorable s))
                            (let ((generated_leaf (funcall (quote Template)   name  #'string_constant_instantiate  s  #|line 113|#)))
                              (declare (ignorable generated_leaf))
                              (setf  regkvs (cons (funcall (quote register_component_allow_overwriting)   regkvs  generated_leaf )  regkvs)) #|line 114|#))) #|line 115|#
                        ))                                  #|line 116|#
                    ))                                      #|line 117|#
              ))                                            #|line 118|#
        ))
    (return-from generate_shell_components  regkvs)         #|line 119|#) #|line 120|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 122|#
  (return-from first_char  (char  s 0)                      #|line 123|#) #|line 124|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 126|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 127|#))) #|line 128|#
  )                                                         #|line 130|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 131|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 132|# #|line 133|# #|line 134|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 135|# #|  and output queues of messages. |# #|line 136|# #|  |# #|line 137|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 138|# #|  that routes messages to child components according to a list of connections |# #|line 139|# #|  that serve as a message routing table. |# #|line 140|# #|  |# #|line 141|# #|  Child components themselves can be leaves or other containers. |# #|line 142|# #|  |# #|line 143|# #|  `handler` invokes the code that is attached to this component. |# #|line 144|# #|  |# #|line 145|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 146|# #|  function may want whenever it is invoked again. |# #|line 147|# #|  |# #|line 148|# #|line 149|# #|  Eh_States :: enum { idle, active } |# #|line 150|#
(defun Eh (&optional )                                      #|line 151|#
  (list
    (cons "name"  "")                                       #|line 152|#
    (cons "inq"  (make-instance 'Queue)                     #|line 153|#)
    (cons "outq"  (make-instance 'Queue)                    #|line 154|#)
    (cons "owner"  nil)                                     #|line 155|#
    (cons "saved_messages"  nil)  #|  stack of saved message(s) |# #|line 156|#
    (cons "children"  nil)                                  #|line 157|#
    (cons "visit_ordering"  (make-instance 'Queue)          #|line 158|#)
    (cons "connections"  nil)                               #|line 159|#
    (cons "routings"  (make-instance 'Queue)                #|line 160|#)
    (cons "handler"  nil)                                   #|line 161|#
    (cons "instance_data"  nil)                             #|line 162|#
    (cons "state"  "idle")                                  #|line 163|# #|  bootstrap debugging |# #|line 164|#
    (cons "kind"  nil)  #|  enum { container, leaf, } |#    #|line 165|#
    (cons "trace"  nil)  #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |# #|line 166|#
    (cons "depth"  0)  #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |# #|line 167|#) #|line 168|#)
                                                            #|line 169|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 170|# #|  whose handler function is `container_handler`. |# #|line 171|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 172|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 173|#
    (setf (field "name"  eh)  name)                         #|line 174|#
    (setf (field "owner"  eh)  owner)                       #|line 175|#
    (setf (field "handler"  eh)  #'container_handler)       #|line 176|#
    (setf (field "inject"  eh)  #'container_injector)       #|line 177|#
    (setf (field "state"  eh)  "idle")                      #|line 178|#
    (setf (field "kind"  eh)  "container")                  #|line 179|#
    (return-from make_container  eh)                        #|line 180|#) #|line 181|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 183|# #|  that will be passed back to your handler when called. |# #|line 184|# #|line 185|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 186|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 187|#
    (setf (field "name"  eh)  (concatenate 'string (field "name"  owner)  (concatenate 'string  "."  name)) #|line 188|#)
    (setf (field "owner"  eh)  owner)                       #|line 189|#
    (setf (field "handler"  eh)  handler)                   #|line 190|#
    (setf (field "instance_data"  eh)  instance_data)       #|line 191|#
    (setf (field "state"  eh)  "idle")                      #|line 192|#
    (setf (field "kind"  eh)  "leaf")                       #|line 193|#
    (return-from make_leaf  eh)                             #|line 194|#) #|line 195|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 197|# #|  of the given component. |# #|line 198|# #|line 199|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 200|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 201|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 202|#)) #|line 203|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 205|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 206|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 207|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 208|#))) #|line 209|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 211|#
  (let ((fwdmsg (funcall (quote make_message)   port (field "datum"  msg)  #|line 212|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 213|#)) #|line 214|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 216|#
  (funcall (field "inject"  eh)   eh  msg                   #|line 217|#) #|line 218|#
  ) #|  Returns a list of all output messages on a container. |# #|line 220|# #|  For testing / debugging purposes. |# #|line 221|# #|line 222|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 223|#
  (return-from output_list (field "outq"  eh))              #|line 224|# #|line 225|#
  ) #|  Utility for printing an array of messages. |#       #|line 227|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 228|#
  (loop for m in (funcall (quote list)  (field "queue" (field "outq"  eh)) )
    do
      (progn
        m                                                   #|line 229|#
        (format *standard-output* "~a" (funcall (quote format_message)   m )) #|line 230|#
        ))                                                  #|line 231|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 233|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 234|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 235|#
          (setf  s (+  s  " "))                             #|line 236|#
          ))
    (return-from spaces  s)                                 #|line 237|#) #|line 238|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 240|#
  (setf (field "state"  eh)  "active")                      #|line 241|# #|line 242|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 244|#
  (setf (field "state"  eh)  "idle")                        #|line 245|# #|line 246|#
  ) #|  Utility for printing a specific output message. |#  #|line 248|# #|line 249|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 250|#
  (loop for msg in (funcall (quote list)  (field "queue" (field "outq"  eh)) )
    do
      (progn
        msg                                                 #|line 251|#
        (cond
          (( equal   (field "port"  msg)  port)             #|line 252|#
            (return-from fetch_first_output (field "datum"  msg))
            ))                                              #|line 253|#
        ))
  (return-from fetch_first_output  nil)                     #|line 254|# #|line 255|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 257|#
  #|  port ∷ “” |#                                          #|line 258|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 259|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (funcall (field "srepr"  datum) )) #|line 260|#) #|line 261|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 262|#
  #|  port ∷ “” |#                                          #|line 263|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 264|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 265|#
    (format *error-output* "~a" (funcall (field "srepr"  datum) )) #|line 266|#) #|line 267|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 269|#
  (funcall (field "put" (field "outq"  eh))   msg           #|line 270|#) #|line 271|#
  )
(defparameter  root_project  "")                            #|line 273|#
(defparameter  root_0D  "")                                 #|line 274|# #|line 275|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 276|# #|line 277|# #|line 278|#
  (setf  root_project  rproject)                            #|line 279|#
  (setf  root_0D  r0D)                                      #|line 280|# #|line 281|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 283|#
  (let ((name_with_id (funcall (quote gensymbol)   "?"      #|line 284|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 285|#))) #|line 286|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 287|#
  (let ((name_with_id (funcall (quote gensymbol)   "?A"     #|line 288|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 289|#))) #|line 290|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 292|#
  (let ((name_with_id (funcall (quote gensymbol)   "?B"     #|line 293|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 294|#))) #|line 295|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 297|#
  (let ((name_with_id (funcall (quote gensymbol)   "?C"     #|line 298|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 299|#))) #|line 300|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 302|#
  (let ((s (funcall (field "srepr" (field "datum"  msg)) )))
    (declare (ignorable s))                                 #|line 303|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (field "name"  eh)  (concatenate 'string  ": "  s)))) #|line 304|#) #|line 305|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 307|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 308|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 309|#))) #|line 310|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 312|#
  #|  to appease dumped_on_floor checker |#                 #|line 313|#
  #| pass |#                                                #|line 314|# #|line 315|#
  )
(defun TwoMessages (&optional  first  second)               #|line 316|#
  (list
    (cons "first"  first)                                   #|line 317|#
    (cons "second"  second)                                 #|line 318|#) #|line 319|#)
                                                            #|line 320|# #|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |# #|line 321|#
(defun Deracer_Instance_Data (&optional  state  buffer)     #|line 322|#
  (list
    (cons "state"  state)                                   #|line 323|#
    (cons "buffer"  buffer)                                 #|line 324|#) #|line 325|#)
                                                            #|line 326|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 327|#
  #| pass |#                                                #|line 328|# #|line 329|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 331|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 332|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Deracer_Instance_Data)   "idle" (funcall (quote TwoMessages)   nil  nil )  #|line 333|#)))
      (declare (ignorable inst))
      (setf (field "state"  inst)  "idle")                  #|line 334|#
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 335|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 336|#))) #|line 337|#
  )
(defun send_first_then_second (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 339|#
  (funcall (quote forward)   eh  "1" (field "first" (field "buffer"  inst))  #|line 340|#)
  (funcall (quote forward)   eh  "2" (field "second" (field "buffer"  inst))  #|line 341|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 342|#) #|line 343|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 345|#
  (let (( inst (field "instance_data"  eh)))
    (declare (ignorable  inst))                             #|line 346|#
    (cond
      (( equal   (field "state"  inst)  "idle")             #|line 347|#
        (cond
          (( equal    "1" (field "port"  msg))              #|line 348|#
            (setf (field "first" (field "buffer"  inst))  msg) #|line 349|#
            (setf (field "state"  inst)  "waitingForSecond") #|line 350|#
            )
          (( equal    "2" (field "port"  msg))              #|line 351|#
            (setf (field "second" (field "buffer"  inst))  msg) #|line 352|#
            (setf (field "state"  inst)  "waitingForFirst") #|line 353|#
            )
          (t                                                #|line 354|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (field "port"  msg)) )
            ))                                              #|line 355|#
        )
      (( equal   (field "state"  inst)  "waitingForFirst")  #|line 356|#
        (cond
          (( equal    "1" (field "port"  msg))              #|line 357|#
            (setf (field "first" (field "buffer"  inst))  msg) #|line 358|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 359|#)
            (setf (field "state"  inst)  "idle")            #|line 360|#
            )
          (t                                                #|line 361|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (field "port"  msg)) )
            ))                                              #|line 362|#
        )
      (( equal   (field "state"  inst)  "waitingForSecond") #|line 363|#
        (cond
          (( equal    "2" (field "port"  msg))              #|line 364|#
            (setf (field "second" (field "buffer"  inst))  msg) #|line 365|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 366|#)
            (setf (field "state"  inst)  "idle")            #|line 367|#
            )
          (t                                                #|line 368|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (field "port"  msg)) )
            ))                                              #|line 369|#
        )
      (t                                                    #|line 370|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}" ) #|line 371|#
        )))                                                 #|line 372|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 374|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 375|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 376|#))) #|line 377|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 379|#
  (let ((fname (funcall (field "srepr" (field "datum"  msg)) )))
    (declare (ignorable fname))                             #|line 380|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 381|#) #|line 382|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 384|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 385|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 386|#))) #|line 387|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 389|#
  (cond
    (( equal    "string" (funcall (field "kind" (field "datum"  msg)) )) #|line 390|#
      (funcall (quote forward)   eh  ""  msg )              #|line 391|#
      )
    (t                                                      #|line 392|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (field "datum"  msg)) #|line 393|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 394|#
      ))                                                    #|line 395|#
  )
(defun Syncfilewrite_Data (&optional )                      #|line 397|#
  (list
    (cons "filename"  "")                                   #|line 398|#) #|line 399|#)
                                                            #|line 400|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 401|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 402|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 403|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Syncfilewrite_Data) )))
      (declare (ignorable inst))                            #|line 404|#
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 405|#)))) #|line 406|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 408|#
  (let (( inst (field "instance_data"  eh)))
    (declare (ignorable  inst))                             #|line 409|#
    (cond
      (( equal    "filename" (field "port"  msg))           #|line 410|#
        (setf (field "filename"  inst) (funcall (field "srepr" (field "datum"  msg)) )) #|line 411|#
        )
      (( equal    "input" (field "port"  msg))              #|line 412|#
        (let ((contents (funcall (field "srepr" (field "datum"  msg)) )))
          (declare (ignorable contents))                    #|line 413|#
          (let (( f (funcall (quote open)  (field "filename"  inst)  "w"  #|line 414|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 415|#
                (funcall (field "write"  f)  (funcall (field "srepr" (field "datum"  msg)) )  #|line 416|#)
                (funcall (field "close"  f) )               #|line 417|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 418|#
                )
              (t                                            #|line 419|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (field "filename"  inst))  msg )
                ))))                                        #|line 420|#
        )))                                                 #|line 421|#
  )
(defun StringConcat_Instance_Data (&optional )              #|line 423|#
  (list
    (cons "buffer1"  nil)                                   #|line 424|#
    (cons "buffer2"  nil)                                   #|line 425|#
    (cons "count"  0)                                       #|line 426|#) #|line 427|#)
                                                            #|line 428|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 429|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 430|#)))
    (declare (ignorable name_with_id))
    (let ((instp (funcall (quote StringConcat_Instance_Data) )))
      (declare (ignorable instp))                           #|line 431|#
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 432|#)))) #|line 433|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 435|#
  (let (( inst (field "instance_data"  eh)))
    (declare (ignorable  inst))                             #|line 436|#
    (cond
      (( equal    "1" (field "port"  msg))                  #|line 437|#
        (setf (field "buffer1"  inst) (funcall (quote clone_string)  (funcall (field "srepr" (field "datum"  msg)) )  #|line 438|#))
        (setf (field "count"  inst) (+ (field "count"  inst)  1)) #|line 439|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 440|#
        )
      (( equal    "2" (field "port"  msg))                  #|line 441|#
        (setf (field "buffer2"  inst) (funcall (quote clone_string)  (funcall (field "srepr" (field "datum"  msg)) )  #|line 442|#))
        (setf (field "count"  inst) (+ (field "count"  inst)  1)) #|line 443|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 444|#
        )
      (t                                                    #|line 445|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (field "port"  msg))  #|line 446|#) #|line 447|#
        )))                                                 #|line 448|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 450|#
  (cond
    (( and  ( equal    0 (length (field "buffer1"  inst))) ( equal    0 (length (field "buffer2"  inst)))) #|line 451|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 452|#
      ))
  (cond
    (( >=  (field "count"  inst)  2)                        #|line 453|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 454|#
        (cond
          (( equal    0 (length (field "buffer1"  inst)))   #|line 455|#
            (setf  concatenated_string (field "buffer2"  inst)) #|line 456|#
            )
          (( equal    0 (length (field "buffer2"  inst)))   #|line 457|#
            (setf  concatenated_string (field "buffer1"  inst)) #|line 458|#
            )
          (t                                                #|line 459|#
            (setf  concatenated_string (+ (field "buffer1"  inst) (field "buffer2"  inst))) #|line 460|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 461|#)
        (setf (field "buffer1"  inst)  nil)                 #|line 462|#
        (setf (field "buffer2"  inst)  nil)                 #|line 463|#
        (setf (field "count"  inst)  0))                    #|line 464|#
      ))                                                    #|line 465|#
  ) #|  |#                                                  #|line 467|# #|line 468|# #|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 469|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 470|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 471|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 472|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 473|#)))) #|line 474|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 476|#
  (let ((cmd (field "instance_data"  eh)))
    (declare (ignorable cmd))                               #|line 477|#
    (let ((s (funcall (field "srepr" (field "datum"  msg)) )))
      (declare (ignorable s))                               #|line 478|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 479|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 480|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 481|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 482|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 483|#
              (cond
                ((not (equal   rc  0))                      #|line 484|#
                  (funcall (quote send_string)   eh  "✗"  stderr  msg  #|line 485|#)
                  )
                (t                                          #|line 486|#
                  (funcall (quote send_string)   eh  ""  stdout  msg  #|line 487|#) #|line 488|#
                  ))))))))                                  #|line 489|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 491|# #|line 492|# #|line 493|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 494|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 495|#
      (cond
        ((not (equal   root_project  ""))                   #|line 496|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 497|#) #|line 498|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 499|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 500|#) #|line 501|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 502|#)))) #|line 503|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 505|#
  (let ((s (field "instance_data"  eh)))
    (declare (ignorable s))                                 #|line 506|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 507|#)) #|line 508|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 510|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 511|#
  (return-from string_make_persistent  s)                   #|line 512|# #|line 513|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 515|#
  (return-from string_clone  s)                             #|line 516|# #|line 517|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 519|# #|  where ${_00_} is the root directory for the project |# #|line 520|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 521|# #|line 522|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 523|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 524|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 525|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 526|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 527|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 528|#
                  (setf  reg (cons (funcall (quote register_component)   reg (funcall (quote Template)  (dict-lookup   container  "name")  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator ) )  reg)) #|line 529|# #|line 530|#
                  )))                                       #|line 531|#
          ))
    (format *standard-output* "~a"  reg)                    #|line 532|#
    (setf  reg (funcall (quote initialize_stock_components)   reg  #|line 533|#))
    (return-from initialize_component_palette  reg)         #|line 534|#) #|line 535|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 537|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 538|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 539|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (funcall (field "srepr"  err) ) )))) #|line 540|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___") #|line 541|#
          (funcall (quote print_specific_output)   main_container  error_port ) #|line 542|#
          ))))                                              #|line 543|#
  ) #|  debugging helpers |#                                #|line 545|# #|line 546|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 547|#
  (format *standard-output* "~a"  "")                       #|line 548|# #|line 549|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 551|#
  (funcall (quote nl) )                                     #|line 552|#
  (format *standard-output* "~a"  "___ Outputs ___")        #|line 553|#
  (funcall (quote print_output_list)   main_container       #|line 554|#) #|line 555|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 557|#
  #|  remove whitespace from front and back of string |#    #|line 558|#
  (return-from trimws (funcall (field "strip"  s) ))        #|line 559|# #|line 560|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 562|#
  (return-from clone_string  s                              #|line 563|# #|line 564|#) #|line 565|#
  )
(defparameter  load_errors  nil)                            #|line 566|#
(defparameter  runtime_errors  nil)                         #|line 567|# #|line 568|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 569|# #|line 570|#
  (format *standard-output* "~a"  s)                        #|line 571|#
  (format *standard-output* "
  ")                                                        #|line 572|#
  (setf  load_errors  t)                                    #|line 573|# #|line 574|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 576|# #|line 577|#
  (format *standard-output* "~a"  s)                        #|line 578|#
  (setf  runtime_errors  t)                                 #|line 579|# #|line 580|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 582|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 583|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 584|#))) #|line 585|#
  )
(defparameter  rand  0)                                     #|line 587|# #|line 588|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 589|# #|line 590|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |# #|line 591|#
  (funcall (quote send_string)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg  #|line 592|#) #|line 593|#
  )                                                         #|line 595|# #|  all of the the built_in leaves are listed here |# #|line 596|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 597|# #|line 598|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 599|#
  (let (( regkvs (funcall (quote register_component)   reg (funcall (quote Template)   "1then2"  nil  #'deracer_instantiate )  #|line 600|#)))
    (declare (ignorable  regkvs))
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "?"  nil  #'probe_instantiate ) )  regkvs)) #|line 601|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "?A"  nil  #'probeA_instantiate ) )  regkvs)) #|line 602|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "?B"  nil  #'probeB_instantiate ) )  regkvs)) #|line 603|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "?C"  nil  #'probeC_instantiate ) )  regkvs)) #|line 604|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "trash"  nil  #'trash_instantiate ) )  regkvs)) #|line 605|# #|line 606|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate ) )  regkvs)) #|line 607|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate ) )  regkvs)) #|line 608|# #|line 609|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "syncfilewrite"  nil  #'syncfilewrite_instantiate ) )  regkvs)) #|line 610|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "stringconcat"  nil  #'stringconcat_instantiate ) )  regkvs)) #|line 611|#
    #|  for fakepipe |#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "fakepipename"  nil  #'fakepipename_instantiate ) )  regkvs)) #|line 612|#
    (return-from initialize_stock_components  regkvs)       #|line 613|#) #|line 614|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 616|#

  (get-main-args)
                                                            #|line 617|# #|line 618|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 620|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 621|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 622|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 623|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 624|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 625|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 626|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 627|#)))))) #|line 628|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 630|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 631|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 632|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 633|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 634|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 635|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 636|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 637|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 638|#)
            #|  get entrypoint container |#                 #|line 639|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 640|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 641|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 645|#) #|line 646|#
                  ))
              (cond
                ((not  load_errors)                         #|line 647|#
                  (let (( arg (funcall (quote new_datum_string)   arg  #|line 648|#)))
                    (declare (ignorable  arg))
                    (let (( msg (funcall (quote make_message)   ""  arg  #|line 649|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 650|#)
                      (cond
                        ( show_all_outputs                  #|line 651|#
                          (funcall (quote dump_outputs)   main_container  #|line 652|#)
                          )
                        (t                                  #|line 653|#
                          (funcall (quote print_error_maybe)   main_container  #|line 654|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  ""  #|line 655|#)))
                            (declare (ignorable outp))
                            (cond
                              (( equal    nil  outp)        #|line 656|#
                                (format *standard-output* "~a"  "(no outputs)") #|line 657|#
                                )
                              (t                            #|line 658|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 659|#) #|line 660|#
                                )))                         #|line 661|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 662|#
                          (format *standard-output* "~a"  "--- done ---") #|line 663|# #|line 664|#
                          ))))                              #|line 665|#
                  ))))))))                                  #|line 666|#
  )                                                         #|line 668|# #|line 669|# #|  utility functions  |# #|line 670|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))       #|line 671|#
  (let ((datum (funcall (quote new_datum_int)   i           #|line 672|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_message  #|line 673|#)) #|line 674|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))          #|line 676|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 677|#
    (funcall (quote send)   eh  port  datum  causing_message  #|line 678|#)) #|line 679|#
  )





