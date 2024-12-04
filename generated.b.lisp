
                                                            #|line 1|# #|line 2|# #|line 3|#
(defclass Component_Registry ()                             #|line 4|#
  (
    (templates :accessor templates :initarg :templates :initform  (dict-fresh))  #|line 5|#)) #|line 6|#

                                                            #|line 7|#
(defclass Template ()                                       #|line 8|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 9|#
    (template_data :accessor template_data :initarg :template_data :initform  nil)  #|line 10|#
    (instantiator :accessor instantiator :initarg :instantiator :initform  nil)  #|line 11|#)) #|line 12|#

                                                            #|line 13|#
(defun Template (&optional  name  template_data  instantiator)
  (declare (ignorable  name  template_data  instantiator))  #|line 14|#
  (let (( templ  (make-instance 'Template)                  #|line 15|#))
    (declare (ignorable  templ))
    (setf (slot-value  templ 'name)  name)                  #|line 16|#
    (setf (slot-value  templ 'template_data)  template_data) #|line 17|#
    (setf (slot-value  templ 'instantiator)  instantiator)  #|line 18|#
    (return-from Template  templ)                           #|line 19|#) #|line 20|#
  )
(defun read_and_convert_json_file (&optional  pathname  filename)
  (declare (ignorable  pathname  filename))                 #|line 22|#

  ;; read json from a named file and convert it into internal form (a list of Container alists)
  (with-open-file (f (format nil "~a/~a.lisp" pathname filename) :direction :input)
    (deep-expand (read f)))
                                                            #|line 23|# #|line 24|#
  )
(defun json2internal (&optional  pathname  container_xml)
  (declare (ignorable  pathname  container_xml))            #|line 26|#
  (let ((fname  container_xml                               #|line 27|#))
    (declare (ignorable fname))
    (let ((routings (funcall (quote read_and_convert_json_file)   pathname  fname  #|line 28|#)))
      (declare (ignorable routings))
      (return-from json2internal  routings)                 #|line 29|#)) #|line 30|#
  )
(defun delete_decls (&optional  d)
  (declare (ignorable  d))                                  #|line 32|#
  #| pass |#                                                #|line 33|# #|line 34|#
  )
(defun make_component_registry (&optional )
  (declare (ignorable ))                                    #|line 36|#
  (return-from make_component_registry  (make-instance 'Component_Registry) #|line 37|#) #|line 38|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component (funcall (quote abstracted_register_component)   reg  template  nil )) #|line 40|#
  )
(defun register_component_allow_overwriting (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component_allow_overwriting (funcall (quote abstracted_register_component)   reg  template  t )) #|line 41|#
  )
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)
  (declare (ignorable  reg  template  ok_to_overwrite))     #|line 43|#
  (let ((name (funcall (quote mangle_name)  (slot-value  template 'name)  #|line 44|#)))
    (declare (ignorable name))
    (cond
      (( and  ( dict-in?   name (slot-value  reg 'templates)) (not  ok_to_overwrite)) #|line 45|#
        (funcall (quote load_error)   (concatenate 'string  "Component /"  (concatenate 'string (slot-value  template 'name)  "/ already declared"))  #|line 46|#)
        (return-from abstracted_register_component  reg)    #|line 47|#
        )
      (t                                                    #|line 48|#
        (setf (gethash name (slot-value  reg 'templates))  template) #|line 49|#
        (return-from abstracted_register_component  reg)    #|line 50|# #|line 51|#
        )))                                                 #|line 52|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 54|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 55|#)))
    (declare (ignorable template_name))
    (cond
      (( dict-in?   template_name (slot-value  reg 'templates)) #|line 56|#
        (let ((template (gethash template_name (slot-value  reg 'templates))))
          (declare (ignorable template))                    #|line 57|#
          (cond
            (( equal    template  nil)                      #|line 58|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error (A): Can;t find component /"  (concatenate 'string  template_name  "/"))  #|line 59|#)
              (return-from get_component_instance  nil)     #|line 60|#
              )
            (t                                              #|line 61|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 62|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 63|#
                  (cond
                    ((not (equal   nil  owner))             #|line 64|#
                      (setf  owner_name (slot-value  owner 'name)) #|line 65|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))) #|line 66|#
                      )
                    (t                                      #|line 67|#
                      (setf  instance_name  template_name)  #|line 68|#
                      ))
                  (let ((instance (funcall (slot-value  template 'instantiator)   reg  owner  instance_name (slot-value  template 'template_data)  #|line 69|#)))
                    (declare (ignorable instance))
                    (return-from get_component_instance  instance))))
              )))                                           #|line 70|#
        )
      (t                                                    #|line 71|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 72|#)
        (return-from get_component_instance  nil)           #|line 73|#
        )))                                                 #|line 74|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 76|#
  (funcall (quote nl) )                                     #|line 77|#
  (format *standard-output* "~a"  "*** PALETTE ***")        #|line 78|#
  (loop for c in (slot-value  reg 'templates)
    do
      (progn
        c                                                   #|line 79|#
        (funcall (quote print)  (slot-value  c 'name) )     #|line 80|#
        ))
  (format *standard-output* "~a"  "***************")        #|line 81|#
  (funcall (quote nl) )                                     #|line 82|# #|line 83|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 85|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (slot-value  reg 'stats))) #|line 86|# #|line 87|#
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
  (cond
    ((not (equal   nil  container_list))                    #|line 99|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 100|#
            #|  loop through every component in the diagram and look for names that start with “$“ |# #|line 101|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 102|#
            (loop for child_descriptor in (gethash  "children"  diagram)
              do
                (progn
                  child_descriptor                          #|line 103|#
                  (cond
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "$" ) #|line 104|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 105|#
                        (let ((cmd (funcall (slot-value  (subseq  name 1) 'strip) )))
                          (declare (ignorable cmd))         #|line 106|#
                          (let ((generated_leaf (funcall (quote Template)   name  #'shell_out_instantiate  cmd  #|line 107|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 108|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 109|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 110|#
                        (let ((s  (subseq  name 1)          #|line 111|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote Template)   name  #'string_constant_instantiate  s  #|line 112|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 113|#)))) #|line 114|#
                      ))                                    #|line 115|#
                  ))                                        #|line 116|#
            ))                                              #|line 117|#
      ))
  (return-from generate_shell_components  reg)              #|line 118|# #|line 119|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 121|#
  (return-from first_char  (char  s 0)                      #|line 122|#) #|line 123|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 125|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 126|#))) #|line 127|#
  )                                                         #|line 129|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 130|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 131|# #|line 132|# #|line 133|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 134|# #|  and output queues of messages. |# #|line 135|# #|  |# #|line 136|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 137|# #|  that routes messages to child components according to a list of connections |# #|line 138|# #|  that serve as a message routing table. |# #|line 139|# #|  |# #|line 140|# #|  Child components themselves can be leaves or other containers. |# #|line 141|# #|  |# #|line 142|# #|  `handler` invokes the code that is attached to this component. |# #|line 143|# #|  |# #|line 144|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 145|# #|  function may want whenever it is invoked again. |# #|line 146|# #|  |# #|line 147|# #|line 148|# #|  Eh_States :: enum { idle, active } |# #|line 149|#
(defclass Eh ()                                             #|line 150|#
  (
    (name :accessor name :initarg :name :initform  "")      #|line 151|#
    (inq :accessor inq :initarg :inq :initform  (make-instance 'Queue) #|line 152|#)
    (outq :accessor outq :initarg :outq :initform  (make-instance 'Queue) #|line 153|#)
    (owner :accessor owner :initarg :owner :initform  nil)  #|line 154|#
    (saved_messages :accessor saved_messages :initarg :saved_messages :initform  nil)  #|  stack of saved message(s) |# #|line 155|#
    (children :accessor children :initarg :children :initform  nil)  #|line 156|#
    (visit_ordering :accessor visit_ordering :initarg :visit_ordering :initform  (make-instance 'Queue) #|line 157|#)
    (connections :accessor connections :initarg :connections :initform  nil)  #|line 158|#
    (routings :accessor routings :initarg :routings :initform  (make-instance 'Queue) #|line 159|#)
    (handler :accessor handler :initarg :handler :initform  nil)  #|line 160|#
    (finject :accessor finject :initarg :finject :initform  nil)  #|line 161|#
    (instance_data :accessor instance_data :initarg :instance_data :initform  nil)  #|line 162|#
    (state :accessor state :initarg :state :initform  "idle")  #|line 163|# #|  bootstrap debugging |# #|line 164|#
    (kind :accessor kind :initarg :kind :initform  nil)  #|  enum { container, leaf, } |# #|line 165|#)) #|line 166|#

                                                            #|line 167|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 168|# #|  whose handler function is `container_handler`. |# #|line 169|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 170|#
  (let (( eh  (make-instance 'Eh)                           #|line 171|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  name)                     #|line 172|#
    (setf (slot-value  eh 'owner)  owner)                   #|line 173|#
    (setf (slot-value  eh 'handler)  #'container_handler)   #|line 174|#
    (setf (slot-value  eh 'finject)  #'container_injector)  #|line 175|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 176|#
    (setf (slot-value  eh 'kind)  "container")              #|line 177|#
    (return-from make_container  eh)                        #|line 178|#) #|line 179|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 181|# #|  that will be passed back to your handler when called. |# #|line 182|# #|line 183|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 184|#
  (let (( eh  (make-instance 'Eh)                           #|line 185|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  (concatenate 'string (slot-value  owner 'name)  (concatenate 'string  "."  name)) #|line 186|#)
    (setf (slot-value  eh 'owner)  owner)                   #|line 187|#
    (setf (slot-value  eh 'handler)  handler)               #|line 188|#
    (setf (slot-value  eh 'instance_data)  instance_data)   #|line 189|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 190|#
    (setf (slot-value  eh 'kind)  "leaf")                   #|line 191|#
    (return-from make_leaf  eh)                             #|line 192|#) #|line 193|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 195|# #|  of the given component. |# #|line 196|# #|line 197|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 198|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 199|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 200|#)) #|line 201|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 203|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 204|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 205|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 206|#))) #|line 207|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 209|#
  (let ((fwdmsg (funcall (quote make_message)   port (slot-value  msg 'datum)  #|line 210|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 211|#)) #|line 212|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 214|#
  (funcall (slot-value  eh 'finject)   eh  msg              #|line 215|#) #|line 216|#
  ) #|  Returns a list of all output messages on a container. |# #|line 218|# #|  For testing / debugging purposes. |# #|line 219|# #|line 220|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 221|#
  (return-from output_list (slot-value  eh 'outq))          #|line 222|# #|line 223|#
  ) #|  Utility for printing an array of messages. |#       #|line 225|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 226|#
  (loop for m in (queue2list (slot-value  eh 'outq))
    do
      (progn
        m                                                   #|line 227|#
        (format *standard-output* "~a" (funcall (quote format_message)   m )) #|line 228|#
        ))                                                  #|line 229|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 231|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 232|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 233|#
          (setf  s (+  s  " "))                             #|line 234|#
          ))
    (return-from spaces  s)                                 #|line 235|#) #|line 236|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 238|#
  (setf (slot-value  eh 'state)  "active")                  #|line 239|# #|line 240|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 242|#
  (setf (slot-value  eh 'state)  "idle")                    #|line 243|# #|line 244|#
  ) #|  Utility for printing a specific output message. |#  #|line 246|# #|line 247|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 248|#
  (loop for msg in (queue2list (slot-value  eh 'outq))
    do
      (progn
        msg                                                 #|line 249|#
        (cond
          (( equal   (slot-value  msg 'port)  port)         #|line 250|#
            (return-from fetch_first_output (slot-value  msg 'datum))
            ))                                              #|line 251|#
        ))
  (return-from fetch_first_output  nil)                     #|line 252|# #|line 253|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 255|#
  #|  port ∷ “” |#                                          #|line 256|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 257|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (funcall (slot-value  datum 'srepr) )) #|line 258|#) #|line 259|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 260|#
  #|  port ∷ “” |#                                          #|line 261|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 262|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 263|#
    (format *error-output* "~a" (funcall (slot-value  datum 'srepr) )) #|line 264|#) #|line 265|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 267|#
  (funcall (slot-value (slot-value  eh 'outq) 'put)   msg   #|line 268|#) #|line 269|#
  )
(defparameter  root_project  "")                            #|line 271|#
(defparameter  root_0D  "")                                 #|line 272|# #|line 273|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 274|# #|line 275|# #|line 276|#
  (setf  root_project  rproject)                            #|line 277|#
  (setf  root_0D  r0D)                                      #|line 278|# #|line 279|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 281|#
  (let ((name_with_id (funcall (quote gensymbol)   "?"      #|line 282|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 283|#))) #|line 284|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 285|#
  (let ((name_with_id (funcall (quote gensymbol)   "?A"     #|line 286|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 287|#))) #|line 288|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 290|#
  (let ((name_with_id (funcall (quote gensymbol)   "?B"     #|line 291|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 292|#))) #|line 293|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 295|#
  (let ((name_with_id (funcall (quote gensymbol)   "?C"     #|line 296|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 297|#))) #|line 298|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 300|#
  (let ((s (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
    (declare (ignorable s))                                 #|line 301|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (slot-value  eh 'name)  (concatenate 'string  ": "  s)))) #|line 302|#) #|line 303|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 305|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 306|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 307|#))) #|line 308|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 310|#
  #|  to appease dumped_on_floor checker |#                 #|line 311|#
  #| pass |#                                                #|line 312|# #|line 313|#
  )
(defclass TwoMessages ()                                    #|line 314|#
  (
    (firstmsg :accessor firstmsg :initarg :firstmsg :initform  nil)  #|line 315|#
    (secondmsg :accessor secondmsg :initarg :secondmsg :initform  nil)  #|line 316|#)) #|line 317|#

                                                            #|line 318|# #|  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } |# #|line 319|#
(defclass Deracer_Instance_Data ()                          #|line 320|#
  (
    (state :accessor state :initarg :state :initform  nil)  #|line 321|#
    (buffer :accessor buffer :initarg :buffer :initform  nil)  #|line 322|#)) #|line 323|#

                                                            #|line 324|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 325|#
  #| pass |#                                                #|line 326|# #|line 327|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 329|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 330|#)))
    (declare (ignorable name_with_id))
    (let (( inst  (make-instance 'Deracer_Instance_Data)    #|line 331|#))
      (declare (ignorable  inst))
      (setf (slot-value  inst 'state)  "idle")              #|line 332|#
      (setf (slot-value  inst 'buffer)  (make-instance 'TwoMessages) #|line 333|#)
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 334|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 335|#))) #|line 336|#
  )
(defun send_firstmsg_then_secondmsg (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 338|#
  (funcall (quote forward)   eh  "1" (slot-value (slot-value  inst 'buffer) 'firstmsg)  #|line 339|#)
  (funcall (quote forward)   eh  "2" (slot-value (slot-value  inst 'buffer) 'secondmsg)  #|line 340|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 341|#) #|line 342|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 344|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 345|#
    (cond
      (( equal   (slot-value  inst 'state)  "idle")         #|line 346|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 347|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 348|#
            (setf (slot-value  inst 'state)  "waitingForSecondmsg") #|line 349|#
            )
          (( equal    "2" (slot-value  msg 'port))          #|line 350|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 351|#
            (setf (slot-value  inst 'state)  "waitingForFirstmsg") #|line 352|#
            )
          (t                                                #|line 353|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (slot-value  msg 'port)) )
            ))                                              #|line 354|#
        )
      (( equal   (slot-value  inst 'state)  "waitingForFirstmsg") #|line 355|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 356|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 357|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 358|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 359|#
            )
          (t                                                #|line 360|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (slot-value  msg 'port)) )
            ))                                              #|line 361|#
        )
      (( equal   (slot-value  inst 'state)  "waitingForSecondmsg") #|line 362|#
        (cond
          (( equal    "2" (slot-value  msg 'port))          #|line 363|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 364|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 365|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 366|#
            )
          (t                                                #|line 367|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (slot-value  msg 'port)) )
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
  (let ((fname (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
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
    (( equal    "string" (funcall (slot-value (slot-value  msg 'datum) 'kind) )) #|line 389|#
      (funcall (quote forward)   eh  ""  msg )              #|line 390|#
      )
    (t                                                      #|line 391|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value  msg 'datum)) #|line 392|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 393|#
      ))                                                    #|line 394|#
  )
(defclass Syncfilewrite_Data ()                             #|line 396|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 397|#)) #|line 398|#

                                                            #|line 399|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 400|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 401|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 402|#)))
    (declare (ignorable name_with_id))
    (let ((inst  (make-instance 'Syncfilewrite_Data)        #|line 403|#))
      (declare (ignorable inst))
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 404|#)))) #|line 405|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 407|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 408|#
    (cond
      (( equal    "filename" (slot-value  msg 'port))       #|line 409|#
        (setf (slot-value  inst 'filename) (funcall (slot-value (slot-value  msg 'datum) 'srepr) )) #|line 410|#
        )
      (( equal    "input" (slot-value  msg 'port))          #|line 411|#
        (let ((contents (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
          (declare (ignorable contents))                    #|line 412|#
          (let (( f (funcall (quote open)  (slot-value  inst 'filename)  "w"  #|line 413|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 414|#
                (funcall (slot-value  f 'write)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 415|#)
                (funcall (slot-value  f 'close) )           #|line 416|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 417|#
                )
              (t                                            #|line 418|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value  inst 'filename))  msg )
                ))))                                        #|line 419|#
        )))                                                 #|line 420|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 422|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 423|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 424|#
    (scount :accessor scount :initarg :scount :initform  0)  #|line 425|#)) #|line 426|#

                                                            #|line 427|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 428|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 429|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringConcat_Instance_Data) #|line 430|#))
      (declare (ignorable instp))
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 431|#)))) #|line 432|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 434|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 435|#
    (cond
      (( equal    "1" (slot-value  msg 'port))              #|line 436|#
        (setf (slot-value  inst 'buffer1) (funcall (quote clone_string)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 437|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 438|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 439|#
        )
      (( equal    "2" (slot-value  msg 'port))              #|line 440|#
        (setf (slot-value  inst 'buffer2) (funcall (quote clone_string)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 441|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 442|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 443|#
        )
      (t                                                    #|line 444|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (slot-value  msg 'port))  #|line 445|#) #|line 446|#
        )))                                                 #|line 447|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 449|#
  (cond
    (( and  ( equal    0 (length (slot-value  inst 'buffer1))) ( equal    0 (length (slot-value  inst 'buffer2)))) #|line 450|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 451|#
      ))
  (cond
    (( >=  (slot-value  inst 'scount)  2)                   #|line 452|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 453|#
        (cond
          (( equal    0 (length (slot-value  inst 'buffer1))) #|line 454|#
            (setf  concatenated_string (slot-value  inst 'buffer2)) #|line 455|#
            )
          (( equal    0 (length (slot-value  inst 'buffer2))) #|line 456|#
            (setf  concatenated_string (slot-value  inst 'buffer1)) #|line 457|#
            )
          (t                                                #|line 458|#
            (setf  concatenated_string (+ (slot-value  inst 'buffer1) (slot-value  inst 'buffer2))) #|line 459|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 460|#)
        (setf (slot-value  inst 'buffer1)  nil)             #|line 461|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 462|#
        (setf (slot-value  inst 'scount)  0))               #|line 463|#
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
  (let ((cmd (slot-value  eh 'instance_data)))
    (declare (ignorable cmd))                               #|line 476|#
    (let ((s (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
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
  (let ((s (slot-value  eh 'instance_data)))
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
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 518|# #|  where ${_00_} is the root directory for the project |# #|line 519|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 520|# #|line 521|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 522|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 523|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 524|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 525|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 526|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 527|#
                  (funcall (quote register_component)   reg (funcall (quote Template)  (gethash  "name"  container)  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 528|#) #|line 529|#
                  )))                                       #|line 530|#
          ))
    (format *standard-output* "~a"  reg)                    #|line 531|#
    (setf  reg (funcall (quote initialize_stock_components)   reg  #|line 532|#))
    (return-from initialize_component_palette  reg)         #|line 533|#) #|line 534|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 536|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 537|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 538|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (funcall (slot-value  err 'srepr) ) )))) #|line 539|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___") #|line 540|#
          (funcall (quote print_specific_output)   main_container  error_port ) #|line 541|#
          ))))                                              #|line 542|#
  ) #|  debugging helpers |#                                #|line 544|# #|line 545|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 546|#
  (format *standard-output* "~a"  "")                       #|line 547|# #|line 548|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 550|#
  (funcall (quote nl) )                                     #|line 551|#
  (format *standard-output* "~a"  "___ Outputs ___")        #|line 552|#
  (funcall (quote print_output_list)   main_container       #|line 553|#) #|line 554|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 556|#
  #|  remove whitespace from front and back of string |#    #|line 557|#
  (return-from trimws (funcall (slot-value  s 'strip) ))    #|line 558|# #|line 559|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 561|#
  (return-from clone_string  s                              #|line 562|# #|line 563|#) #|line 564|#
  )
(defparameter  load_errors  nil)                            #|line 565|#
(defparameter  runtime_errors  nil)                         #|line 566|# #|line 567|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 568|# #|line 569|#
  (format *standard-output* "~a"  s)                        #|line 570|#
  (format *standard-output* "
  ")                                                        #|line 571|#
  (setf  load_errors  t)                                    #|line 572|# #|line 573|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 575|# #|line 576|#
  (format *standard-output* "~a"  s)                        #|line 577|#
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
  )                                                         #|line 594|# #|  all of the the built_in leaves are listed here |# #|line 595|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 596|# #|line 597|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 598|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "1then2"  nil  #'deracer_instantiate )  #|line 599|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?"  nil  #'probe_instantiate )  #|line 600|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?A"  nil  #'probeA_instantiate )  #|line 601|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?B"  nil  #'probeB_instantiate )  #|line 602|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?C"  nil  #'probeC_instantiate )  #|line 603|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "trash"  nil  #'trash_instantiate )  #|line 604|#) #|line 605|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 606|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 607|#) #|line 608|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 609|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 610|#)
  #|  for fakepipe |#                                       #|line 611|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 612|#) #|line 613|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 615|#

  (get-main-args)
                                                            #|line 616|# #|line 617|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 619|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 620|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 621|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 622|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 623|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 624|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 625|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 626|#)))))) #|line 627|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 629|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 630|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 631|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 632|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 633|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 634|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 635|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 636|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 637|#)
            #|  get entrypoint container |#                 #|line 638|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 639|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 640|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 644|#) #|line 645|#
                  ))
              (cond
                ((not  load_errors)                         #|line 646|#
                  (let (( arg (funcall (quote new_datum_string)   arg  #|line 647|#)))
                    (declare (ignorable  arg))
                    (let (( msg (funcall (quote make_message)   ""  arg  #|line 648|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 649|#)
                      (cond
                        ( show_all_outputs                  #|line 650|#
                          (funcall (quote dump_outputs)   main_container  #|line 651|#)
                          )
                        (t                                  #|line 652|#
                          (funcall (quote print_error_maybe)   main_container  #|line 653|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  ""  #|line 654|#)))
                            (declare (ignorable outp))
                            (cond
                              (( equal    nil  outp)        #|line 655|#
                                (format *standard-output* "~a"  "(no outputs)") #|line 656|#
                                )
                              (t                            #|line 657|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 658|#) #|line 659|#
                                )))                         #|line 660|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 661|#
                          (format *standard-output* "~a"  "--- done ---") #|line 662|# #|line 663|#
                          ))))                              #|line 664|#
                  ))))))))                                  #|line 665|#
  )                                                         #|line 667|# #|line 668|# #|  utility functions  |# #|line 669|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))       #|line 670|#
  (let ((datum (funcall (quote new_datum_int)   i           #|line 671|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_message  #|line 672|#)) #|line 673|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))          #|line 675|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 676|#
    (funcall (quote send)   eh  port  datum  causing_message  #|line 677|#)) #|line 678|#
  )





