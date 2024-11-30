
                                                            #|line 1|# #|line 2|# #|line 3|#
(defclass Component_Registry ()                             #|line 4|#
  (
    (templates :accessor templates :initarg :templates :initform  nil)  #|line 5|#)) #|line 6|#

                                                            #|line 7|#
(defclass Template ()                                       #|line 8|#
  (
    (name :accessor name :initarg :name :initform  name)    #|line 9|#
    (template_data :accessor template_data :initarg :template_data :initform  template_data)  #|line 10|#
    (instantiator :accessor instantiator :initarg :instantiator :initform  instantiator)  #|line 11|#)) #|line 12|#

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
  (let ((name (funcall (quote mangle_name)  (slot-value 'name  template)  #|line 36|#)))
    (declare (ignorable name))
    (cond
      (( and  (dict-in?  name (slot-value 'templates  reg)) (not  ok_to_overwrite)) #|line 37|#
        (funcall (quote load_error)   (concatenate 'string  "Component /"  (concatenate 'string (slot-value 'name  template)  "/ already declared"))  #|line 38|#)
        (return-from abstracted_register_component  reg)    #|line 39|#
        )
      (t                                                    #|line 40|#
        (setf (slot-value 'templates  reg) (cons (cons  name  template) (slot-value 'templates  reg))) #|line 41|#
        (return-from abstracted_register_component  reg)    #|line 42|# #|line 43|#
        )))                                                 #|line 44|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 46|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 47|#)))
    (declare (ignorable template_name))
    (cond
      (( dict-in?   template_name (slot-value 'templates  reg)) #|line 48|#
        (let ((template (gethash template_name (slot-value 'templates  reg))))
          (declare (ignorable template))                    #|line 49|#
          (cond
            (( equal    template  nil)                      #|line 50|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error (A): Can;t find component /"  (concatenate 'string  template_name  "/"))  #|line 51|#)
              (return-from get_component_instance  nil)     #|line 52|#
              )
            (t                                              #|line 53|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 54|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 55|#
                  (cond
                    ((not (equal   nil  owner))             #|line 56|#
                      (setf  owner_name (slot-value 'name  owner)) #|line 57|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))) #|line 58|#
                      )
                    (t                                      #|line 59|#
                      (setf  instance_name  template_name)  #|line 60|#
                      ))
                  (let ((instance (funcall (slot-value 'instantiator  template)   reg  owner  instance_name (slot-value 'template_data  template)  #|line 61|#)))
                    (declare (ignorable instance))
                    (setf (slot-value 'depth  instance) (funcall (quote calculate_depth)   instance  #|line 62|#))
                    (return-from get_component_instance  instance))))
              )))                                           #|line 63|#
        )
      (t                                                    #|line 64|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 65|#)
        (return-from get_component_instance  nil)           #|line 66|#
        )))                                                 #|line 67|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                 #|line 68|#
  (cond
    (( equal   (slot-value 'owner  eh)  nil)                #|line 69|#
      (return-from calculate_depth  0)                      #|line 70|#
      )
    (t                                                      #|line 71|#
      (return-from calculate_depth (+  1 (funcall (quote calculate_depth)  (slot-value 'owner  eh) ))) #|line 72|#
      ))                                                    #|line 73|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 75|#
  (funcall (quote nl) )                                     #|line 76|#
  (format *standard-output* "~a"  "*** PALETTE ***")        #|line 77|#
  (loop for c in (slot-value 'templates  reg)
    do
      (progn
        c                                                   #|line 78|#
        (funcall (quote print)  (slot-value 'name  c) )     #|line 79|#
        ))
  (format *standard-output* "~a"  "***************")        #|line 80|#
  (funcall (quote nl) )                                     #|line 81|# #|line 82|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 84|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (slot-value 'stats  reg))) #|line 85|# #|line 86|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 88|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 89|#
  (return-from mangle_name  s)                              #|line 90|# #|line 91|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 93|#
  #|  [ |#                                                  #|line 94|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 95|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 96|#
  #|  ] |#                                                  #|line 97|#
  (cond
    ((not (equal   nil  container_list))                    #|line 98|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 99|#
            #|  loop through every component in the diagram and look for names that start with “$“ |# #|line 100|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 101|#
            (loop for child_descriptor in (gethash  "children"  diagram)
              do
                (progn
                  child_descriptor                          #|line 102|#
                  (cond
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "$" ) #|line 103|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 104|#
                        (let ((cmd (funcall (slot-value 'strip  (subseq  name 1)) )))
                          (declare (ignorable cmd))         #|line 105|#
                          (let ((generated_leaf (funcall (quote Template)   name  #'shell_out_instantiate  cmd  #|line 106|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 107|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 108|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 109|#
                        (let ((s  (subseq  name 1)          #|line 110|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote Template)   name  #'string_constant_instantiate  s  #|line 111|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 112|#)))) #|line 113|#
                      ))                                    #|line 114|#
                  ))                                        #|line 115|#
            ))                                              #|line 116|#
      ))
  (return-from generate_shell_components  reg)              #|line 117|# #|line 118|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 120|#
  (return-from first_char  (char  s 0)                      #|line 121|#) #|line 122|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 124|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 125|#))) #|line 126|#
  )                                                         #|line 128|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 129|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 130|# #|line 131|# #|line 132|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 133|# #|  and output queues of messages. |# #|line 134|# #|  |# #|line 135|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 136|# #|  that routes messages to child components according to a list of connections |# #|line 137|# #|  that serve as a message routing table. |# #|line 138|# #|  |# #|line 139|# #|  Child components themselves can be leaves or other containers. |# #|line 140|# #|  |# #|line 141|# #|  `handler` invokes the code that is attached to this component. |# #|line 142|# #|  |# #|line 143|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 144|# #|  function may want whenever it is invoked again. |# #|line 145|# #|  |# #|line 146|# #|line 147|# #|  Eh_States :: enum { idle, active } |# #|line 148|#
(defclass Eh ()                                             #|line 149|#
  (
    (name :accessor name :initarg :name :initform  "")      #|line 150|#
    (inq :accessor inq :initarg :inq :initform  (make-instance 'Queue) #|line 151|#)
    (outq :accessor outq :initarg :outq :initform  (make-instance 'Queue) #|line 152|#)
    (owner :accessor owner :initarg :owner :initform  nil)  #|line 153|#
    (saved_messages :accessor saved_messages :initarg :saved_messages :initform  nil)  #|  stack of saved message(s) |# #|line 154|#
    (children :accessor children :initarg :children :initform  nil)  #|line 155|#
    (visit_ordering :accessor visit_ordering :initarg :visit_ordering :initform  (make-instance 'Queue) #|line 156|#)
    (connections :accessor connections :initarg :connections :initform  nil)  #|line 157|#
    (routings :accessor routings :initarg :routings :initform  (make-instance 'Queue) #|line 158|#)
    (handler :accessor handler :initarg :handler :initform  nil)  #|line 159|#
    (inject :accessor inject :initarg :inject :initform  nil)  #|line 160|#
    (instance_data :accessor instance_data :initarg :instance_data :initform  nil)  #|line 161|#
    (state :accessor state :initarg :state :initform  "idle")  #|line 162|# #|  bootstrap debugging |# #|line 163|#
    (kind :accessor kind :initarg :kind :initform  nil)  #|  enum { container, leaf, } |# #|line 164|#)) #|line 165|#

                                                            #|line 166|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 167|# #|  whose handler function is `container_handler`. |# #|line 168|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 169|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 170|#
    (setf (slot-value 'name  eh)  name)                     #|line 171|#
    (setf (slot-value 'owner  eh)  owner)                   #|line 172|#
    (setf (slot-value 'handler  eh)  #'container_handler)   #|line 173|#
    (setf (slot-value 'inject  eh)  #'container_injector)   #|line 174|#
    (setf (slot-value 'state  eh)  "idle")                  #|line 175|#
    (setf (slot-value 'kind  eh)  "container")              #|line 176|#
    (return-from make_container  eh)                        #|line 177|#) #|line 178|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 180|# #|  that will be passed back to your handler when called. |# #|line 181|# #|line 182|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 183|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 184|#
    (setf (slot-value 'name  eh)  (concatenate 'string (slot-value 'name  owner)  (concatenate 'string  "."  name)) #|line 185|#)
    (setf (slot-value 'owner  eh)  owner)                   #|line 186|#
    (setf (slot-value 'handler  eh)  handler)               #|line 187|#
    (setf (slot-value 'instance_data  eh)  instance_data)   #|line 188|#
    (setf (slot-value 'state  eh)  "idle")                  #|line 189|#
    (setf (slot-value 'kind  eh)  "leaf")                   #|line 190|#
    (return-from make_leaf  eh)                             #|line 191|#) #|line 192|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 194|# #|  of the given component. |# #|line 195|# #|line 196|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 197|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 198|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 199|#)) #|line 200|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 202|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 203|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 204|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 205|#))) #|line 206|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 208|#
  (let ((fwdmsg (funcall (quote make_message)   port (slot-value 'datum  msg)  #|line 209|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 210|#)) #|line 211|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 213|#
  (funcall (slot-value 'inject  eh)   eh  msg               #|line 214|#) #|line 215|#
  ) #|  Returns a list of all output messages on a container. |# #|line 217|# #|  For testing / debugging purposes. |# #|line 218|# #|line 219|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 220|#
  (return-from output_list (slot-value 'outq  eh))          #|line 221|# #|line 222|#
  ) #|  Utility for printing an array of messages. |#       #|line 224|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 225|#
  (loop for m in (funcall (quote list)  (slot-value 'queue (slot-value 'outq  eh)) )
    do
      (progn
        m                                                   #|line 226|#
        (format *standard-output* "~a" (funcall (quote format_message)   m )) #|line 227|#
        ))                                                  #|line 228|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 230|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 231|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 232|#
          (setf  s (+  s  " "))                             #|line 233|#
          ))
    (return-from spaces  s)                                 #|line 234|#) #|line 235|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 237|#
  (setf (slot-value 'state  eh)  "active")                  #|line 238|# #|line 239|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 241|#
  (setf (slot-value 'state  eh)  "idle")                    #|line 242|# #|line 243|#
  ) #|  Utility for printing a specific output message. |#  #|line 245|# #|line 246|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 247|#
  (loop for msg in (funcall (quote list)  (slot-value 'queue (slot-value 'outq  eh)) )
    do
      (progn
        msg                                                 #|line 248|#
        (cond
          (( equal   (slot-value 'port  msg)  port)         #|line 249|#
            (return-from fetch_first_output (slot-value 'datum  msg))
            ))                                              #|line 250|#
        ))
  (return-from fetch_first_output  nil)                     #|line 251|# #|line 252|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 254|#
  #|  port ∷ “” |#                                          #|line 255|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 256|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (funcall (slot-value 'srepr  datum) )) #|line 257|#) #|line 258|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 259|#
  #|  port ∷ “” |#                                          #|line 260|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 261|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 262|#
    (format *error-output* "~a" (funcall (slot-value 'srepr  datum) )) #|line 263|#) #|line 264|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 266|#
  (funcall (slot-value 'put (slot-value 'outq  eh))   msg   #|line 267|#) #|line 268|#
  )
(defparameter  root_project  "")                            #|line 270|#
(defparameter  root_0D  "")                                 #|line 271|# #|line 272|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 273|# #|line 274|# #|line 275|#
  (setf  root_project  rproject)                            #|line 276|#
  (setf  root_0D  r0D)                                      #|line 277|# #|line 278|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 280|#
  (let ((name_with_id (funcall (quote gensymbol)   "?"      #|line 281|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 282|#))) #|line 283|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 284|#
  (let ((name_with_id (funcall (quote gensymbol)   "?A"     #|line 285|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 286|#))) #|line 287|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 289|#
  (let ((name_with_id (funcall (quote gensymbol)   "?B"     #|line 290|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 291|#))) #|line 292|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 294|#
  (let ((name_with_id (funcall (quote gensymbol)   "?C"     #|line 295|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 296|#))) #|line 297|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 299|#
  (let ((s (funcall (slot-value 'srepr (slot-value 'datum  msg)) )))
    (declare (ignorable s))                                 #|line 300|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (slot-value 'name  eh)  (concatenate 'string  ": "  s)))) #|line 301|#) #|line 302|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 304|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 305|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 306|#))) #|line 307|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 309|#
  #|  to appease dumped_on_floor checker |#                 #|line 310|#
  #| pass |#                                                #|line 311|# #|line 312|#
  )
(defclass TwoMessages ()                                    #|line 313|#
  (
    (firstmsg :accessor firstmsg :initarg :firstmsg :initform  firstmsg)  #|line 314|#
    (secondmsg :accessor secondmsg :initarg :secondmsg :initform  secondmsg)  #|line 315|#)) #|line 316|#

                                                            #|line 317|# #|  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } |# #|line 318|#
(defclass Deracer_Instance_Data ()                          #|line 319|#
  (
    (state :accessor state :initarg :state :initform  state)  #|line 320|#
    (buffer :accessor buffer :initarg :buffer :initform  buffer)  #|line 321|#)) #|line 322|#

                                                            #|line 323|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 324|#
  #| pass |#                                                #|line 325|# #|line 326|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 328|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 329|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Deracer_Instance_Data)   "idle" (funcall (quote TwoMessages)   nil  nil )  #|line 330|#)))
      (declare (ignorable inst))
      (setf (slot-value 'state  inst)  "idle")              #|line 331|#
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 332|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 333|#))) #|line 334|#
  )
(defun send_firstmsg_then_secondmsg (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 336|#
  (funcall (quote forward)   eh  "1" (slot-value 'firstmsg (slot-value 'buffer  inst))  #|line 337|#)
  (funcall (quote forward)   eh  "2" (slot-value 'secondmsg (slot-value 'buffer  inst))  #|line 338|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 339|#) #|line 340|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 342|#
  (let (( inst (slot-value 'instance_data  eh)))
    (declare (ignorable  inst))                             #|line 343|#
    (cond
      (( equal   (slot-value 'state  inst)  "idle")         #|line 344|#
        (cond
          (( equal    "1" (slot-value 'port  msg))          #|line 345|#
            (setf (slot-value 'firstmsg (slot-value 'buffer  inst))  msg) #|line 346|#
            (setf (slot-value 'state  inst)  "waitingForSecondmsg") #|line 347|#
            )
          (( equal    "2" (slot-value 'port  msg))          #|line 348|#
            (setf (slot-value 'secondmsg (slot-value 'buffer  inst))  msg) #|line 349|#
            (setf (slot-value 'state  inst)  "waitingForFirstmsg") #|line 350|#
            )
          (t                                                #|line 351|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (slot-value 'port  msg)) )
            ))                                              #|line 352|#
        )
      (( equal   (slot-value 'state  inst)  "waitingForFirstmsg") #|line 353|#
        (cond
          (( equal    "1" (slot-value 'port  msg))          #|line 354|#
            (setf (slot-value 'firstmsg (slot-value 'buffer  inst))  msg) #|line 355|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 356|#)
            (setf (slot-value 'state  inst)  "idle")        #|line 357|#
            )
          (t                                                #|line 358|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (slot-value 'port  msg)) )
            ))                                              #|line 359|#
        )
      (( equal   (slot-value 'state  inst)  "waitingForSecondmsg") #|line 360|#
        (cond
          (( equal    "2" (slot-value 'port  msg))          #|line 361|#
            (setf (slot-value 'secondmsg (slot-value 'buffer  inst))  msg) #|line 362|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 363|#)
            (setf (slot-value 'state  inst)  "idle")        #|line 364|#
            )
          (t                                                #|line 365|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (slot-value 'port  msg)) )
            ))                                              #|line 366|#
        )
      (t                                                    #|line 367|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}" ) #|line 368|#
        )))                                                 #|line 369|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 371|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 372|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 373|#))) #|line 374|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 376|#
  (let ((fname (funcall (slot-value 'srepr (slot-value 'datum  msg)) )))
    (declare (ignorable fname))                             #|line 377|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 378|#) #|line 379|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 381|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 382|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 383|#))) #|line 384|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 386|#
  (cond
    (( equal    "string" (funcall (slot-value 'kind (slot-value 'datum  msg)) )) #|line 387|#
      (funcall (quote forward)   eh  ""  msg )              #|line 388|#
      )
    (t                                                      #|line 389|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value 'datum  msg)) #|line 390|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 391|#
      ))                                                    #|line 392|#
  )
(defclass Syncfilewrite_Data ()                             #|line 394|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 395|#)) #|line 396|#

                                                            #|line 397|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 398|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 399|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 400|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Syncfilewrite_Data) )))
      (declare (ignorable inst))                            #|line 401|#
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 402|#)))) #|line 403|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 405|#
  (let (( inst (slot-value 'instance_data  eh)))
    (declare (ignorable  inst))                             #|line 406|#
    (cond
      (( equal    "filename" (slot-value 'port  msg))       #|line 407|#
        (setf (slot-value 'filename  inst) (funcall (slot-value 'srepr (slot-value 'datum  msg)) )) #|line 408|#
        )
      (( equal    "input" (slot-value 'port  msg))          #|line 409|#
        (let ((contents (funcall (slot-value 'srepr (slot-value 'datum  msg)) )))
          (declare (ignorable contents))                    #|line 410|#
          (let (( f (funcall (quote open)  (slot-value 'filename  inst)  "w"  #|line 411|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 412|#
                (funcall (slot-value 'write  f)  (funcall (slot-value 'srepr (slot-value 'datum  msg)) )  #|line 413|#)
                (funcall (slot-value 'close  f) )           #|line 414|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 415|#
                )
              (t                                            #|line 416|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value 'filename  inst))  msg )
                ))))                                        #|line 417|#
        )))                                                 #|line 418|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 420|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 421|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 422|#
    (count :accessor count :initarg :count :initform  0)    #|line 423|#)) #|line 424|#

                                                            #|line 425|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 426|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 427|#)))
    (declare (ignorable name_with_id))
    (let ((instp (funcall (quote StringConcat_Instance_Data) )))
      (declare (ignorable instp))                           #|line 428|#
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 429|#)))) #|line 430|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 432|#
  (let (( inst (slot-value 'instance_data  eh)))
    (declare (ignorable  inst))                             #|line 433|#
    (cond
      (( equal    "1" (slot-value 'port  msg))              #|line 434|#
        (setf (slot-value 'buffer1  inst) (funcall (quote clone_string)  (funcall (slot-value 'srepr (slot-value 'datum  msg)) )  #|line 435|#))
        (setf (slot-value 'count  inst) (+ (slot-value 'count  inst)  1)) #|line 436|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 437|#
        )
      (( equal    "2" (slot-value 'port  msg))              #|line 438|#
        (setf (slot-value 'buffer2  inst) (funcall (quote clone_string)  (funcall (slot-value 'srepr (slot-value 'datum  msg)) )  #|line 439|#))
        (setf (slot-value 'count  inst) (+ (slot-value 'count  inst)  1)) #|line 440|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 441|#
        )
      (t                                                    #|line 442|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (slot-value 'port  msg))  #|line 443|#) #|line 444|#
        )))                                                 #|line 445|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 447|#
  (cond
    (( and  ( equal    0 (length (slot-value 'buffer1  inst))) ( equal    0 (length (slot-value 'buffer2  inst)))) #|line 448|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 449|#
      ))
  (cond
    (( >=  (slot-value 'count  inst)  2)                    #|line 450|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 451|#
        (cond
          (( equal    0 (length (slot-value 'buffer1  inst))) #|line 452|#
            (setf  concatenated_string (slot-value 'buffer2  inst)) #|line 453|#
            )
          (( equal    0 (length (slot-value 'buffer2  inst))) #|line 454|#
            (setf  concatenated_string (slot-value 'buffer1  inst)) #|line 455|#
            )
          (t                                                #|line 456|#
            (setf  concatenated_string (+ (slot-value 'buffer1  inst) (slot-value 'buffer2  inst))) #|line 457|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 458|#)
        (setf (slot-value 'buffer1  inst)  nil)             #|line 459|#
        (setf (slot-value 'buffer2  inst)  nil)             #|line 460|#
        (setf (slot-value 'count  inst)  0))                #|line 461|#
      ))                                                    #|line 462|#
  ) #|  |#                                                  #|line 464|# #|line 465|# #|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 466|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 467|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 468|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 469|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 470|#)))) #|line 471|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 473|#
  (let ((cmd (slot-value 'instance_data  eh)))
    (declare (ignorable cmd))                               #|line 474|#
    (let ((s (funcall (slot-value 'srepr (slot-value 'datum  msg)) )))
      (declare (ignorable s))                               #|line 475|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 476|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 477|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 478|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 479|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 480|#
              (cond
                ((not (equal   rc  0))                      #|line 481|#
                  (funcall (quote send_string)   eh  "✗"  stderr  msg  #|line 482|#)
                  )
                (t                                          #|line 483|#
                  (funcall (quote send_string)   eh  ""  stdout  msg  #|line 484|#) #|line 485|#
                  ))))))))                                  #|line 486|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 488|# #|line 489|# #|line 490|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 491|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 492|#
      (cond
        ((not (equal   root_project  ""))                   #|line 493|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 494|#) #|line 495|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 496|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 497|#) #|line 498|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 499|#)))) #|line 500|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 502|#
  (let ((s (slot-value 'instance_data  eh)))
    (declare (ignorable s))                                 #|line 503|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 504|#)) #|line 505|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 507|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 508|#
  (return-from string_make_persistent  s)                   #|line 509|# #|line 510|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 512|#
  (return-from string_clone  s)                             #|line 513|# #|line 514|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 516|# #|  where ${_00_} is the root directory for the project |# #|line 517|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 518|# #|line 519|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 520|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 521|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 522|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 523|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 524|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 525|#
                  (funcall (quote register_component)   reg (funcall (quote Template)  (gethash  "name"  container)  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 526|#) #|line 527|#
                  )))                                       #|line 528|#
          ))
    (format *standard-output* "~a"  reg)                    #|line 529|#
    (setf  reg (funcall (quote initialize_stock_components)   reg  #|line 530|#))
    (return-from initialize_component_palette  reg)         #|line 531|#) #|line 532|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 534|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 535|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 536|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (funcall (slot-value 'srepr  err) ) )))) #|line 537|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___") #|line 538|#
          (funcall (quote print_specific_output)   main_container  error_port ) #|line 539|#
          ))))                                              #|line 540|#
  ) #|  debugging helpers |#                                #|line 542|# #|line 543|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 544|#
  (format *standard-output* "~a"  "")                       #|line 545|# #|line 546|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 548|#
  (funcall (quote nl) )                                     #|line 549|#
  (format *standard-output* "~a"  "___ Outputs ___")        #|line 550|#
  (funcall (quote print_output_list)   main_container       #|line 551|#) #|line 552|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 554|#
  #|  remove whitespace from front and back of string |#    #|line 555|#
  (return-from trimws (funcall (slot-value 'strip  s) ))    #|line 556|# #|line 557|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 559|#
  (return-from clone_string  s                              #|line 560|# #|line 561|#) #|line 562|#
  )
(defparameter  load_errors  nil)                            #|line 563|#
(defparameter  runtime_errors  nil)                         #|line 564|# #|line 565|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 566|# #|line 567|#
  (format *standard-output* "~a"  s)                        #|line 568|#
  (format *standard-output* "
  ")                                                        #|line 569|#
  (setf  load_errors  t)                                    #|line 570|# #|line 571|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 573|# #|line 574|#
  (format *standard-output* "~a"  s)                        #|line 575|#
  (setf  runtime_errors  t)                                 #|line 576|# #|line 577|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 579|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 580|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 581|#))) #|line 582|#
  )
(defparameter  rand  0)                                     #|line 584|# #|line 585|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 586|# #|line 587|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |# #|line 588|#
  (funcall (quote send_string)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg  #|line 589|#) #|line 590|#
  )                                                         #|line 592|# #|  all of the the built_in leaves are listed here |# #|line 593|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 594|# #|line 595|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 596|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "1then2"  nil  #'deracer_instantiate )  #|line 597|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?"  nil  #'probe_instantiate )  #|line 598|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?A"  nil  #'probeA_instantiate )  #|line 599|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?B"  nil  #'probeB_instantiate )  #|line 600|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?C"  nil  #'probeC_instantiate )  #|line 601|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "trash"  nil  #'trash_instantiate )  #|line 602|#) #|line 603|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 604|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 605|#) #|line 606|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 607|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 608|#)
  #|  for fakepipe |#                                       #|line 609|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 610|#) #|line 611|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 613|#

  (get-main-args)
                                                            #|line 614|# #|line 615|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 617|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 618|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 619|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 620|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 621|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 622|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 623|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 624|#)))))) #|line 625|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 627|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 628|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 629|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 630|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 631|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 632|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 633|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 634|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 635|#)
            #|  get entrypoint container |#                 #|line 636|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 637|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 638|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 642|#) #|line 643|#
                  ))
              (cond
                ((not  load_errors)                         #|line 644|#
                  (let (( arg (funcall (quote new_datum_string)   arg  #|line 645|#)))
                    (declare (ignorable  arg))
                    (let (( msg (funcall (quote make_message)   ""  arg  #|line 646|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 647|#)
                      (cond
                        ( show_all_outputs                  #|line 648|#
                          (funcall (quote dump_outputs)   main_container  #|line 649|#)
                          )
                        (t                                  #|line 650|#
                          (funcall (quote print_error_maybe)   main_container  #|line 651|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  ""  #|line 652|#)))
                            (declare (ignorable outp))
                            (cond
                              (( equal    nil  outp)        #|line 653|#
                                (format *standard-output* "~a"  "(no outputs)") #|line 654|#
                                )
                              (t                            #|line 655|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 656|#) #|line 657|#
                                )))                         #|line 658|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 659|#
                          (format *standard-output* "~a"  "--- done ---") #|line 660|# #|line 661|#
                          ))))                              #|line 662|#
                  ))))))))                                  #|line 663|#
  )                                                         #|line 665|# #|line 666|# #|  utility functions  |# #|line 667|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))       #|line 668|#
  (let ((datum (funcall (quote new_datum_int)   i           #|line 669|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_message  #|line 670|#)) #|line 671|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))          #|line 673|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 674|#
    (funcall (quote send)   eh  port  datum  causing_message  #|line 675|#)) #|line 676|#
  )





