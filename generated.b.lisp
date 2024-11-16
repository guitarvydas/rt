
                                                            #|line 1|# #|line 2|# #|line 3|#
(defun Component_Registry (&optional )                      #|line 4|#
  (list
    (cons (quote templates)  nil)                           #|line 5|#) #|line 6|#)
                                                            #|line 7|#
(defun Template (&optional  name  template_data  instantiator) #|line 8|#
  (list
    (cons (quote name)  name)                               #|line 9|#
    (cons (quote template_data)  template_data)             #|line 10|#
    (cons (quote instantiator)  instantiator)               #|line 11|#) #|line 12|#)
                                                            #|line 13|#
(defun read_and_convert_json_file (&optional  filename)
  (declare (ignorable  filename))                           #|line 14|#

  ;; read json from a named file and convert it into internal form (a tree of routings)
  ;; return the routings from the function or raise an error
  (with-open-file (json-stream "~/projects/rtlarson/eyeballs.json" :direction :input)
    (json:decode-json json-stream))
                                                            #|line 15|# #|line 16|#
  )
(defun json2internal (&optional  container_xml)
  (declare (ignorable  container_xml))                      #|line 18|#
  (let ((fname (let ((p (parse-namestring  container_xml)))(format nil "~a.~a" (pathname-name p) (pathname-type p))) #|line 19|#))
    (declare (ignorable fname))
    (let ((routings (funcall (quote read_and_convert_json_file)   fname  #|line 20|#)))
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
  (let ((name (funcall (quote mangle_name)  (cdr (assoc (quote  name)  template))  #|line 36|#)))
    (declare (ignorable name))
    (cond
      (( and  ( assoc   name (cdr (assoc (quote  templates)  reg))) (not  ok_to_overwrite)) #|line 37|#
        (funcall (quote load_error)   (concatenate 'string  "Component "  (concatenate 'string (cdr (assoc (quote  name)  template))  " already declared")) ) #|line 38|#
        ))
    (setf (cdr (assoc (quote (nth  name  templates))  reg))  template) #|line 39|#
    (return-from abstracted_register_component  reg)        #|line 40|#) #|line 41|#
  )
(defun register_multiple_components (&optional  reg  templates)
  (declare (ignorable  reg  templates))                     #|line 43|#
  (loop for template in  templates
    do
      (progn
        template                                            #|line 44|#
        (funcall (quote register_component)   reg  template ) #|line 45|#
        ))                                                  #|line 46|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 48|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 49|#)))
    (declare (ignorable template_name))
    (cond
      (( assoc   template_name (cdr (assoc (quote  templates)  reg))) #|line 50|#
        (let ((template (cdr (assoc (quote (nth  template_name  templates))  reg))))
          (declare (ignorable template))                    #|line 51|#
          (cond
            (( equal    template  nil)                      #|line 52|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error: Can;t find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?"))  #|line 53|#)
              (return-from get_component_instance  nil)     #|line 54|#
              )
            (t                                              #|line 55|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 56|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 57|#
                  (cond
                    ((not (equal   nil  owner))             #|line 58|#
                      (setf  owner_name (cdr (assoc (quote  name)  owner))) #|line 59|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))) #|line 60|#
                      )
                    (t                                      #|line 61|#
                      (setf  instance_name  template_name)  #|line 62|#
                      ))
                  (let ((instance (cdr (assoc (quote (funcall (quote instantiator)   reg  owner  instance_name (cdr (assoc (quote  template_data)  template))  #|line 63|#))  template))))
                    (declare (ignorable instance))
                    (setf (cdr (assoc (quote  depth)  instance)) (funcall (quote calculate_depth)   instance  #|line 64|#))
                    (return-from get_component_instance  instance))))
              )))                                           #|line 65|#
        )
      (t                                                    #|line 66|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error: Can't find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?"))  #|line 67|#)
        (return-from get_component_instance  nil)           #|line 68|#
        )))                                                 #|line 69|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                 #|line 70|#
  (cond
    (( equal   (cdr (assoc (quote  owner)  eh))  nil)       #|line 71|#
      (return-from calculate_depth  0)                      #|line 72|#
      )
    (t                                                      #|line 73|#
      (return-from calculate_depth (+  1 (funcall (quote calculate_depth)  (cdr (assoc (quote  owner)  eh)) ))) #|line 74|#
      ))                                                    #|line 75|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 77|#
  (funcall (quote nl) )                                     #|line 78|#
  (format *standard-output* "~a"  "*** PALETTE ***")        #|line 79|#
  (loop for c in (cdr (assoc (quote  templates)  reg))
    do
      (progn
        c                                                   #|line 80|#
        (funcall (quote print)  (cdr (assoc (quote  name)  c)) ) #|line 81|#
        ))
  (format *standard-output* "~a"  "***************")        #|line 82|#
  (funcall (quote nl) )                                     #|line 83|# #|line 84|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 86|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (cdr (assoc (quote  stats)  reg)))) #|line 87|# #|line 88|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 90|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 91|#
  (return-from mangle_name  s)                              #|line 92|# #|line 93|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 95|#
  #|  [ |#                                                  #|line 96|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 97|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 98|#
  #|  ] |#                                                  #|line 99|#
  (cond
    ((not (equal   nil  container_list))                    #|line 100|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 101|#
            #|  loop through every component in the diagram and look for names that start with “$“ |# #|line 102|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 103|#
            (loop for child_descriptor in (cdr (assoc (quote children)  diagram))
              do
                (progn
                  child_descriptor                          #|line 104|#
                  (cond
                    ((funcall (quote first_char_is)  (cdr (assoc (quote name)  child_descriptor))  "$" ) #|line 105|#
                      (let ((name (cdr (assoc (quote name)  child_descriptor))))
                        (declare (ignorable name))          #|line 106|#
                        (let ((cmd (cdr (assoc (quote (funcall (quote strip) ))  (subseq  name 1)))))
                          (declare (ignorable cmd))         #|line 107|#
                          (let ((generated_leaf (funcall (quote Template)   name  #'shell_out_instantiate  cmd  #|line 108|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 109|#))))
                      )
                    ((funcall (quote first_char_is)  (cdr (assoc (quote name)  child_descriptor))  "'" ) #|line 110|#
                      (let ((name (cdr (assoc (quote name)  child_descriptor))))
                        (declare (ignorable name))          #|line 111|#
                        (let ((s  (subseq  name 1)          #|line 112|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote Template)   name  #'string_constant_instantiate  s  #|line 113|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 114|#)))) #|line 115|#
                      ))                                    #|line 116|#
                  ))                                        #|line 117|#
            ))                                              #|line 118|#
      ))                                                    #|line 119|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 121|#
  (return-from first_char  (car  s)                         #|line 122|#) #|line 123|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 125|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 126|#))) #|line 127|#
  )                                                         #|line 129|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 130|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 131|# #|line 132|# #|line 133|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 134|# #|  and output queues of messages. |# #|line 135|# #|  |# #|line 136|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 137|# #|  that routes messages to child components according to a list of connections |# #|line 138|# #|  that serve as a message routing table. |# #|line 139|# #|  |# #|line 140|# #|  Child components themselves can be leaves or other containers. |# #|line 141|# #|  |# #|line 142|# #|  `handler` invokes the code that is attached to this component. |# #|line 143|# #|  |# #|line 144|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 145|# #|  function may want whenever it is invoked again. |# #|line 146|# #|  |# #|line 147|# #|line 148|# #|  Eh_States :: enum { idle, active } |# #|line 149|#
(defun Eh (&optional )                                      #|line 150|#
  (list
    (cons (quote name)  "")                                 #|line 151|#
    (cons (quote inq)  (make-instance 'Queue)               #|line 152|#)
    (cons (quote outq)  (make-instance 'Queue)              #|line 153|#)
    (cons (quote owner)  nil)                               #|line 154|#
    (cons (quote saved_messages)  nil)  #|  stack of saved message(s) |# #|line 155|#
    (cons (quote children)  nil)                            #|line 156|#
    (cons (quote visit_ordering)  (make-instance 'Queue)    #|line 157|#)
    (cons (quote connections)  nil)                         #|line 158|#
    (cons (quote routings)  (make-instance 'Queue)          #|line 159|#)
    (cons (quote handler)  nil)                             #|line 160|#
    (cons (quote instance_data)  nil)                       #|line 161|#
    (cons (quote state)  "idle")                            #|line 162|# #|  bootstrap debugging |# #|line 163|#
    (cons (quote kind)  nil)  #|  enum { container, leaf, } |# #|line 164|#
    (cons (quote trace)  nil)  #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |# #|line 165|#
    (cons (quote depth)  0)  #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |# #|line 166|#) #|line 167|#)
                                                            #|line 168|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 169|# #|  whose handler function is `container_handler`. |# #|line 170|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 171|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 172|#
    (setf (cdr (assoc (quote  name)  eh))  name)            #|line 173|#
    (setf (cdr (assoc (quote  owner)  eh))  owner)          #|line 174|#
    (setf (cdr (assoc (quote  handler)  eh))  #'container_handler) #|line 175|#
    (setf (cdr (assoc (quote  inject)  eh))  #'container_injector) #|line 176|#
    (setf (cdr (assoc (quote  state)  eh))  "idle")         #|line 177|#
    (setf (cdr (assoc (quote  kind)  eh))  "container")     #|line 178|#
    (return-from make_container  eh)                        #|line 179|#) #|line 180|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 182|# #|  that will be passed back to your handler when called. |# #|line 183|# #|line 184|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 185|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 186|#
    (setf (cdr (assoc (quote  name)  eh))  (concatenate 'string (cdr (assoc (quote  name)  owner))  (concatenate 'string  "."  name)) #|line 187|#)
    (setf (cdr (assoc (quote  owner)  eh))  owner)          #|line 188|#
    (setf (cdr (assoc (quote  handler)  eh))  handler)      #|line 189|#
    (setf (cdr (assoc (quote  instance_data)  eh))  instance_data) #|line 190|#
    (setf (cdr (assoc (quote  state)  eh))  "idle")         #|line 191|#
    (setf (cdr (assoc (quote  kind)  eh))  "leaf")          #|line 192|#
    (return-from make_leaf  eh)                             #|line 193|#) #|line 194|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 196|# #|  of the given component. |# #|line 197|# #|line 198|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 199|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 200|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 201|#)) #|line 202|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 204|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 205|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 206|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 207|#))) #|line 208|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 210|#
  (let ((fwdmsg (funcall (quote make_message)   port (cdr (assoc (quote  datum)  msg))  #|line 211|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 212|#)) #|line 213|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 215|#
  (cdr (assoc (quote (funcall (quote inject)   eh  msg      #|line 216|#))  eh)) #|line 217|#
  ) #|  Returns a list of all output messages on a container. |# #|line 219|# #|  For testing / debugging purposes. |# #|line 220|# #|line 221|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 222|#
  (return-from output_list (cdr (assoc (quote  outq)  eh))) #|line 223|# #|line 224|#
  ) #|  Utility for printing an array of messages. |#       #|line 226|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 227|#
  (loop for m in (funcall (quote list)  (cdr (assoc (quote (cdr (assoc (quote  queue)  outq)))  eh)) )
    do
      (progn
        m                                                   #|line 228|#
        (format *standard-output* "~a" (funcall (quote format_message)   m )) #|line 229|#
        ))                                                  #|line 230|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 232|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 233|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 234|#
          (setf  s (+  s  " "))                             #|line 235|#
          ))
    (return-from spaces  s)                                 #|line 236|#) #|line 237|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 239|#
  (setf (cdr (assoc (quote  state)  eh))  "active")         #|line 240|# #|line 241|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 243|#
  (setf (cdr (assoc (quote  state)  eh))  "idle")           #|line 244|# #|line 245|#
  ) #|  Utility for printing a specific output message. |#  #|line 247|# #|line 248|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 249|#
  (loop for msg in (funcall (quote list)  (cdr (assoc (quote (cdr (assoc (quote  queue)  outq)))  eh)) )
    do
      (progn
        msg                                                 #|line 250|#
        (cond
          (( equal   (cdr (assoc (quote  port)  msg))  port) #|line 251|#
            (return-from fetch_first_output (cdr (assoc (quote  datum)  msg)))
            ))                                              #|line 252|#
        ))
  (return-from fetch_first_output  nil)                     #|line 253|# #|line 254|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 256|#
  #|  port ∷ “” |#                                          #|line 257|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 258|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (cdr (assoc (quote (funcall (quote srepr) ))  datum))) #|line 259|#) #|line 260|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 261|#
  #|  port ∷ “” |#                                          #|line 262|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 263|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 264|#
    (format *error-output* "~a" (cdr (assoc (quote (funcall (quote srepr) ))  datum))) #|line 265|#) #|line 266|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 268|#
  (cdr (assoc (quote (cdr (assoc (quote (funcall (quote put)   msg  #|line 269|#))  outq)))  eh)) #|line 270|#
  )
(defparameter  root_project  "")                            #|line 272|#
(defparameter  root_0D  "")                                 #|line 273|# #|line 274|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 275|# #|line 276|# #|line 277|#
  (setf  root_project  rproject)                            #|line 278|#
  (setf  root_0D  r0D)                                      #|line 279|# #|line 280|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 282|#
  (let ((name_with_id (funcall (quote gensymbol)   "?"      #|line 283|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 284|#))) #|line 285|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 286|#
  (let ((name_with_id (funcall (quote gensymbol)   "?A"     #|line 287|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 288|#))) #|line 289|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 291|#
  (let ((name_with_id (funcall (quote gensymbol)   "?B"     #|line 292|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 293|#))) #|line 294|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 296|#
  (let ((name_with_id (funcall (quote gensymbol)   "?C"     #|line 297|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 298|#))) #|line 299|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 301|#
  (let ((s (cdr (assoc (quote (cdr (assoc (quote (funcall (quote srepr) ))  datum)))  msg))))
    (declare (ignorable s))                                 #|line 302|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (cdr (assoc (quote  name)  eh))  (concatenate 'string  ": "  s)))) #|line 303|#) #|line 304|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 306|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 307|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 308|#))) #|line 309|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 311|#
  #|  to appease dumped_on_floor checker |#                 #|line 312|#
  #| pass |#                                                #|line 313|# #|line 314|#
  )
(defun TwoMessages (&optional  first  second)               #|line 315|#
  (list
    (cons (quote first)  first)                             #|line 316|#
    (cons (quote second)  second)                           #|line 317|#) #|line 318|#)
                                                            #|line 319|# #|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |# #|line 320|#
(defun Deracer_Instance_Data (&optional  state  buffer)     #|line 321|#
  (list
    (cons (quote state)  state)                             #|line 322|#
    (cons (quote buffer)  buffer)                           #|line 323|#) #|line 324|#)
                                                            #|line 325|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 326|#
  #| pass |#                                                #|line 327|# #|line 328|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 330|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 331|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Deracer_Instance_Data)   "idle" (funcall (quote TwoMessages)   nil  nil )  #|line 332|#)))
      (declare (ignorable inst))
      (setf (cdr (assoc (quote  state)  inst))  "idle")     #|line 333|#
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 334|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 335|#))) #|line 336|#
  )
(defun send_first_then_second (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 338|#
  (funcall (quote forward)   eh  "1" (cdr (assoc (quote (cdr (assoc (quote  first)  buffer)))  inst))  #|line 339|#)
  (funcall (quote forward)   eh  "2" (cdr (assoc (quote (cdr (assoc (quote  second)  buffer)))  inst))  #|line 340|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 341|#) #|line 342|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 344|#
  (let (( inst (cdr (assoc (quote  instance_data)  eh))))
    (declare (ignorable  inst))                             #|line 345|#
    (cond
      (( equal   (cdr (assoc (quote  state)  inst))  "idle") #|line 346|#
        (cond
          (( equal    "1" (cdr (assoc (quote  port)  msg))) #|line 347|#
            (setf (cdr (assoc (quote (cdr (assoc (quote  first)  buffer)))  inst))  msg) #|line 348|#
            (setf (cdr (assoc (quote  state)  inst))  "waitingForSecond") #|line 349|#
            )
          (( equal    "2" (cdr (assoc (quote  port)  msg))) #|line 350|#
            (setf (cdr (assoc (quote (cdr (assoc (quote  second)  buffer)))  inst))  msg) #|line 351|#
            (setf (cdr (assoc (quote  state)  inst))  "waitingForFirst") #|line 352|#
            )
          (t                                                #|line 353|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (cdr (assoc (quote  port)  msg))) )
            ))                                              #|line 354|#
        )
      (( equal   (cdr (assoc (quote  state)  inst))  "waitingForFirst") #|line 355|#
        (cond
          (( equal    "1" (cdr (assoc (quote  port)  msg))) #|line 356|#
            (setf (cdr (assoc (quote (cdr (assoc (quote  first)  buffer)))  inst))  msg) #|line 357|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 358|#)
            (setf (cdr (assoc (quote  state)  inst))  "idle") #|line 359|#
            )
          (t                                                #|line 360|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (cdr (assoc (quote  port)  msg))) )
            ))                                              #|line 361|#
        )
      (( equal   (cdr (assoc (quote  state)  inst))  "waitingForSecond") #|line 362|#
        (cond
          (( equal    "2" (cdr (assoc (quote  port)  msg))) #|line 363|#
            (setf (cdr (assoc (quote (cdr (assoc (quote  second)  buffer)))  inst))  msg) #|line 364|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 365|#)
            (setf (cdr (assoc (quote  state)  inst))  "idle") #|line 366|#
            )
          (t                                                #|line 367|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (cdr (assoc (quote  port)  msg))) )
            ))                                              #|line 368|#
        )
      (t                                                    #|line 369|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}" ) #|line 370|#
        )))                                                 #|line 371|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 373|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 374|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 375|#))) #|line 376|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 378|#
  (let ((fname (cdr (assoc (quote (cdr (assoc (quote (funcall (quote srepr) ))  datum)))  msg))))
    (declare (ignorable fname))                             #|line 379|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 380|#) #|line 381|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 383|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 384|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 385|#))) #|line 386|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 388|#
  (cond
    (( equal    "string" (cdr (assoc (quote (cdr (assoc (quote (funcall (quote kind) ))  datum)))  msg))) #|line 389|#
      (funcall (quote forward)   eh  ""  msg )              #|line 390|#
      )
    (t                                                      #|line 391|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (cdr (assoc (quote  datum)  msg))) #|line 392|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 393|#
      ))                                                    #|line 394|#
  )
(defun Syncfilewrite_Data (&optional )                      #|line 396|#
  (list
    (cons (quote filename)  "")                             #|line 397|#) #|line 398|#)
                                                            #|line 399|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 400|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 401|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 402|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Syncfilewrite_Data) )))
      (declare (ignorable inst))                            #|line 403|#
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 404|#)))) #|line 405|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 407|#
  (let (( inst (cdr (assoc (quote  instance_data)  eh))))
    (declare (ignorable  inst))                             #|line 408|#
    (cond
      (( equal    "filename" (cdr (assoc (quote  port)  msg))) #|line 409|#
        (setf (cdr (assoc (quote  filename)  inst)) (cdr (assoc (quote (cdr (assoc (quote (funcall (quote srepr) ))  datum)))  msg))) #|line 410|#
        )
      (( equal    "input" (cdr (assoc (quote  port)  msg))) #|line 411|#
        (let ((contents (cdr (assoc (quote (cdr (assoc (quote (funcall (quote srepr) ))  datum)))  msg))))
          (declare (ignorable contents))                    #|line 412|#
          (let (( f (funcall (quote open)  (cdr (assoc (quote  filename)  inst))  "w"  #|line 413|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 414|#
                (cdr (assoc (quote (funcall (quote write)  (cdr (assoc (quote (cdr (assoc (quote (funcall (quote srepr) ))  datum)))  msg))  #|line 415|#))  f))
                (cdr (assoc (quote (funcall (quote close) ))  f)) #|line 416|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 417|#
                )
              (t                                            #|line 418|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (cdr (assoc (quote  filename)  inst)))  msg )
                ))))                                        #|line 419|#
        )))                                                 #|line 420|#
  )
(defun StringConcat_Instance_Data (&optional )              #|line 422|#
  (list
    (cons (quote buffer1)  nil)                             #|line 423|#
    (cons (quote buffer2)  nil)                             #|line 424|#
    (cons (quote count)  0)                                 #|line 425|#) #|line 426|#)
                                                            #|line 427|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 428|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 429|#)))
    (declare (ignorable name_with_id))
    (let ((instp (funcall (quote StringConcat_Instance_Data) )))
      (declare (ignorable instp))                           #|line 430|#
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 431|#)))) #|line 432|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 434|#
  (let (( inst (cdr (assoc (quote  instance_data)  eh))))
    (declare (ignorable  inst))                             #|line 435|#
    (cond
      (( equal    "1" (cdr (assoc (quote  port)  msg)))     #|line 436|#
        (setf (cdr (assoc (quote  buffer1)  inst)) (funcall (quote clone_string)  (cdr (assoc (quote (cdr (assoc (quote (funcall (quote srepr) ))  datum)))  msg))  #|line 437|#))
        (setf (cdr (assoc (quote  count)  inst)) (+ (cdr (assoc (quote  count)  inst))  1)) #|line 438|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 439|#
        )
      (( equal    "2" (cdr (assoc (quote  port)  msg)))     #|line 440|#
        (setf (cdr (assoc (quote  buffer2)  inst)) (funcall (quote clone_string)  (cdr (assoc (quote (cdr (assoc (quote (funcall (quote srepr) ))  datum)))  msg))  #|line 441|#))
        (setf (cdr (assoc (quote  count)  inst)) (+ (cdr (assoc (quote  count)  inst))  1)) #|line 442|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 443|#
        )
      (t                                                    #|line 444|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (cdr (assoc (quote  port)  msg)))  #|line 445|#) #|line 446|#
        )))                                                 #|line 447|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 449|#
  (cond
    (( and  ( equal    0 (length (cdr (assoc (quote  buffer1)  inst)))) ( equal    0 (length (cdr (assoc (quote  buffer2)  inst))))) #|line 450|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 451|#
      ))
  (cond
    (( >=  (cdr (assoc (quote  count)  inst))  2)           #|line 452|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 453|#
        (cond
          (( equal    0 (length (cdr (assoc (quote  buffer1)  inst)))) #|line 454|#
            (setf  concatenated_string (cdr (assoc (quote  buffer2)  inst))) #|line 455|#
            )
          (( equal    0 (length (cdr (assoc (quote  buffer2)  inst)))) #|line 456|#
            (setf  concatenated_string (cdr (assoc (quote  buffer1)  inst))) #|line 457|#
            )
          (t                                                #|line 458|#
            (setf  concatenated_string (+ (cdr (assoc (quote  buffer1)  inst)) (cdr (assoc (quote  buffer2)  inst)))) #|line 459|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 460|#)
        (setf (cdr (assoc (quote  buffer1)  inst))  nil)    #|line 461|#
        (setf (cdr (assoc (quote  buffer2)  inst))  nil)    #|line 462|#
        (setf (cdr (assoc (quote  count)  inst))  0))       #|line 463|#
      ))                                                    #|line 464|#
  ) #|  |#                                                  #|line 466|# #|line 467|# #|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 468|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 469|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 470|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 471|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 472|#)))) #|line 473|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 475|#
  (let ((cmd (cdr (assoc (quote  instance_data)  eh))))
    (declare (ignorable cmd))                               #|line 476|#
    (let ((s (cdr (assoc (quote (cdr (assoc (quote (funcall (quote srepr) ))  datum)))  msg))))
      (declare (ignorable s))                               #|line 477|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 478|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 479|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 480|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 481|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 482|#
              (cond
                ((not (equal   rc  0))                      #|line 483|#
                  (funcall (quote send_string)   eh  "✗"  stderr  msg  #|line 484|#)
                  )
                (t                                          #|line 485|#
                  (funcall (quote send_string)   eh  ""  stdout  msg  #|line 486|#) #|line 487|#
                  ))))))))                                  #|line 488|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 490|# #|line 491|# #|line 492|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 493|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 494|#
      (cond
        ((not (equal   root_project  ""))                   #|line 495|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 496|#) #|line 497|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 498|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 499|#) #|line 500|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 501|#)))) #|line 502|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 504|#
  (let ((s (cdr (assoc (quote  instance_data)  eh))))
    (declare (ignorable s))                                 #|line 505|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 506|#)) #|line 507|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 509|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 510|#
  (return-from string_make_persistent  s)                   #|line 511|# #|line 512|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 514|#
  (return-from string_clone  s)                             #|line 515|# #|line 516|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 518|# #|  where ${_00_} is the root directory for the project |# #|line 519|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 520|# #|line 521|# #|line 522|# #|line 523|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 524|#
  (let ((reg (funcall (quote make_component_registry) )))
    (declare (ignorable reg))                               #|line 525|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 526|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   diagram_source  #|line 527|#)))
            (declare (ignorable all_containers_within_single_file))
            (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 528|#)
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 529|#
                  (funcall (quote register_component)   reg (funcall (quote Template)  (cdr (assoc (quote name)  container))  #|  template_data =  |# container  #|  instantiator =  |# #'container_instantiator ) )
                  )))                                       #|line 530|#
          ))
    (funcall (quote initialize_stock_components)   reg      #|line 531|#)
    (return-from initialize_component_palette  reg)         #|line 532|#) #|line 533|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 535|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 536|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 537|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (cdr (assoc (quote (funcall (quote srepr) ))  err)) )))) #|line 538|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___") #|line 539|#
          (funcall (quote print_specific_output)   main_container  error_port ) #|line 540|#
          ))))                                              #|line 541|#
  ) #|  debugging helpers |#                                #|line 543|# #|line 544|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 545|#
  (format *standard-output* "~a"  "")                       #|line 546|# #|line 547|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 549|#
  (funcall (quote nl) )                                     #|line 550|#
  (format *standard-output* "~a"  "___ Outputs ___")        #|line 551|#
  (funcall (quote print_output_list)   main_container       #|line 552|#) #|line 553|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 555|#
  #|  remove whitespace from front and back of string |#    #|line 556|#
  (return-from trimws (cdr (assoc (quote (funcall (quote strip) ))  s))) #|line 557|# #|line 558|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 560|#
  (return-from clone_string  s                              #|line 561|# #|line 562|#) #|line 563|#
  )
(defparameter  load_errors  nil)                            #|line 564|#
(defparameter  runtime_errors  nil)                         #|line 565|# #|line 566|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 567|# #|line 568|#
  (format *standard-output* "~a"  s)                        #|line 569|#
  (funcall (quote quit) )                                   #|line 570|#
  (setf  load_errors  t)                                    #|line 571|# #|line 572|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 574|# #|line 575|#
  (format *standard-output* "~a"  s)                        #|line 576|#
  (funcall (quote quit) )                                   #|line 577|#
  (setf  runtime_errors  t)                                 #|line 578|# #|line 579|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 581|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 582|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 583|#))) #|line 584|#
  )
(defparameter  rand  0)                                     #|line 586|# #|line 587|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 588|# #|line 589|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |# #|line 590|#
  (funcall (quote send_string)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg  #|line 591|#) #|line 592|#
  )                                                         #|line 594|# #|  all of the the built_in leaves are listed here |# #|line 595|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 596|# #|line 597|# #|line 598|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 599|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "1then2"  nil  #'deracer_instantiate )  #|line 600|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?"  nil  #'probe_instantiate )  #|line 601|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?A"  nil  #'probeA_instantiate )  #|line 602|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?B"  nil  #'probeB_instantiate )  #|line 603|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?C"  nil  #'probeC_instantiate )  #|line 604|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "trash"  nil  #'trash_instantiate )  #|line 605|#) #|line 606|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 607|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 608|#) #|line 609|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 610|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 611|#)
  #|  for fakepipe |#                                       #|line 612|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 613|#) #|line 614|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 616|#

  (error 'NIY)
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
            (let ((palette (funcall (quote initialize_component_palette)   root_project  root_0D  diagram_names  #|line 626|#)))
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
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name "  (concatenate 'string  main_container_name  (concatenate 'string  " in files "  (concatenate 'string  diagram_names  "(check tab names, or disable compression?)"))))  #|line 645|#) #|line 646|#
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





