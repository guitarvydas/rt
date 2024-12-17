
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
(defun mkTemplate (&optional  name  template_data  instantiator)
  (declare (ignorable  name  template_data  instantiator))  #|line 14|#
  (let (( templ  (make-instance 'Template)                  #|line 15|#))
    (declare (ignorable  templ))
    (setf (slot-value  templ 'name)  name)                  #|line 16|#
    (setf (slot-value  templ 'template_data)  template_data) #|line 17|#
    (setf (slot-value  templ 'instantiator)  instantiator)  #|line 18|#
    (return-from mkTemplate  templ)                         #|line 19|#) #|line 20|#
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
      (( and  ( dict-in?  ( and  (not (equal   reg  nil))  name) (slot-value  reg 'templates)) (not  ok_to_overwrite)) #|line 45|#
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
  (format *standard-output* "~a~%"  "*** PALETTE ***")      #|line 78|#
  (loop for c in (slot-value  reg 'templates)
    do
      (progn
        c                                                   #|line 79|#
        (funcall (quote print)  (slot-value  c 'name) )     #|line 80|#
        ))
  (format *standard-output* "~a~%"  "***************")      #|line 81|#
  (funcall (quote nl) )                                     #|line 82|# #|line 83|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 85|#
  (format *standard-output* "~a~%"  (concatenate 'string  "registry statistics: " (slot-value  reg 'stats))) #|line 86|# #|line 87|#
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
            #|  loop through every component in the diagram and look for names that start with “$“ or “'“  |# #|line 101|#
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
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  cmd  #'shell_out_instantiate  #|line 107|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 108|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 109|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 110|#
                        (let ((s  (subseq  name 1)          #|line 111|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  s  #'string_constant_instantiate  #|line 112|#)))
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
    (children :accessor children :initarg :children :initform  nil)  #|line 155|#
    (visit_ordering :accessor visit_ordering :initarg :visit_ordering :initform  (make-instance 'Queue) #|line 156|#)
    (connections :accessor connections :initarg :connections :initform  nil)  #|line 157|#
    (routings :accessor routings :initarg :routings :initform  (make-instance 'Queue) #|line 158|#)
    (handler :accessor handler :initarg :handler :initform  nil)  #|line 159|#
    (finject :accessor finject :initarg :finject :initform  nil)  #|line 160|#
    (instance_data :accessor instance_data :initarg :instance_data :initform  nil)  #|line 161|#
    (state :accessor state :initarg :state :initform  "idle")  #|line 162|# #|  bootstrap debugging |# #|line 163|#
    (kind :accessor kind :initarg :kind :initform  nil)  #|  enum { container, leaf, } |# #|line 164|#)) #|line 165|#

                                                            #|line 166|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 167|# #|  whose handler function is `container_handler`. |# #|line 168|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 169|#
  (let (( eh  (make-instance 'Eh)                           #|line 170|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  name)                     #|line 171|#
    (setf (slot-value  eh 'owner)  owner)                   #|line 172|#
    (setf (slot-value  eh 'handler)  #'container_handler)   #|line 173|#
    (setf (slot-value  eh 'finject)  #'container_injector)  #|line 174|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 175|#
    (setf (slot-value  eh 'kind)  "container")              #|line 176|#
    (return-from make_container  eh)                        #|line 177|#) #|line 178|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 180|# #|  that will be passed back to your handler when called. |# #|line 181|# #|line 182|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 183|#
  (let (( eh  (make-instance 'Eh)                           #|line 184|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  (concatenate 'string (slot-value  owner 'name)  (concatenate 'string  "."  name)) #|line 185|#)
    (setf (slot-value  eh 'owner)  owner)                   #|line 186|#
    (setf (slot-value  eh 'handler)  handler)               #|line 187|#
    (setf (slot-value  eh 'instance_data)  instance_data)   #|line 188|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 189|#
    (setf (slot-value  eh 'kind)  "leaf")                   #|line 190|#
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
  (let ((fwdmsg (funcall (quote make_message)   port (slot-value  msg 'datum)  #|line 209|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 210|#)) #|line 211|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 213|#
  (funcall (slot-value  eh 'finject)   eh  msg              #|line 214|#) #|line 215|#
  ) #|  Returns a list of all output messages on a container. |# #|line 217|# #|  For testing / debugging purposes. |# #|line 218|# #|line 219|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 220|#
  (return-from output_list (slot-value  eh 'outq))          #|line 221|# #|line 222|#
  ) #|  Utility for printing an array of messages. |#       #|line 224|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 225|#
  (format *standard-output* "~a~%"  "{")                    #|line 226|#
  (loop for m in (queue2list (slot-value  eh 'outq))
    do
      (progn
        m                                                   #|line 227|#
        (format *standard-output* "~a~%" (funcall (quote format_message)   m )) #|line 228|# #|line 229|#
        ))
  (format *standard-output* "~a~%"  "}")                    #|line 230|# #|line 231|#
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
  (setf (slot-value  eh 'state)  "active")                  #|line 241|# #|line 242|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 244|#
  (setf (slot-value  eh 'state)  "idle")                    #|line 245|# #|line 246|#
  ) #|  Utility for printing a specific output message. |#  #|line 248|# #|line 249|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 250|#
  (loop for msg in (queue2list (slot-value  eh 'outq))
    do
      (progn
        msg                                                 #|line 251|#
        (cond
          (( equal   (slot-value  msg 'port)  port)         #|line 252|#
            (return-from fetch_first_output (slot-value  msg 'datum))
            ))                                              #|line 253|#
        ))
  (return-from fetch_first_output  nil)                     #|line 254|# #|line 255|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 257|#
  #|  port ∷ “” |#                                          #|line 258|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 259|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a~%" (funcall (slot-value  datum 'srepr) )) #|line 260|#) #|line 261|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 262|#
  #|  port ∷ “” |#                                          #|line 263|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 264|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 265|#
    (format *error-output* "~a~%" (funcall (slot-value  datum 'srepr) )) #|line 266|#) #|line 267|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 269|#
  (enqueue (slot-value  eh 'outq)  msg)                     #|line 270|# #|line 271|#
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
  (let ((s (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
    (declare (ignorable s))                                 #|line 303|#
    (format *error-output* "~a~%"  (concatenate 'string  "... probe "  (concatenate 'string (slot-value  eh 'name)  (concatenate 'string  ": "  s)))) #|line 304|#) #|line 305|#
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
(defclass TwoMessages ()                                    #|line 316|#
  (
    (firstmsg :accessor firstmsg :initarg :firstmsg :initform  nil)  #|line 317|#
    (secondmsg :accessor secondmsg :initarg :secondmsg :initform  nil)  #|line 318|#)) #|line 319|#

                                                            #|line 320|# #|  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } |# #|line 321|#
(defclass Deracer_Instance_Data ()                          #|line 322|#
  (
    (state :accessor state :initarg :state :initform  nil)  #|line 323|#
    (buffer :accessor buffer :initarg :buffer :initform  nil)  #|line 324|#)) #|line 325|#

                                                            #|line 326|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 327|#
  #| pass |#                                                #|line 328|# #|line 329|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 331|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 332|#)))
    (declare (ignorable name_with_id))
    (let (( inst  (make-instance 'Deracer_Instance_Data)    #|line 333|#))
      (declare (ignorable  inst))
      (setf (slot-value  inst 'state)  "idle")              #|line 334|#
      (setf (slot-value  inst 'buffer)  (make-instance 'TwoMessages) #|line 335|#)
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 336|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 337|#))) #|line 338|#
  )
(defun send_firstmsg_then_secondmsg (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 340|#
  (funcall (quote forward)   eh  "1" (slot-value (slot-value  inst 'buffer) 'firstmsg)  #|line 341|#)
  (funcall (quote forward)   eh  "2" (slot-value (slot-value  inst 'buffer) 'secondmsg)  #|line 342|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 343|#) #|line 344|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 346|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 347|#
    (cond
      (( equal   (slot-value  inst 'state)  "idle")         #|line 348|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 349|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 350|#
            (setf (slot-value  inst 'state)  "waitingForSecondmsg") #|line 351|#
            )
          (( equal    "2" (slot-value  msg 'port))          #|line 352|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 353|#
            (setf (slot-value  inst 'state)  "waitingForFirstmsg") #|line 354|#
            )
          (t                                                #|line 355|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (slot-value  msg 'port)) )
            ))                                              #|line 356|#
        )
      (( equal   (slot-value  inst 'state)  "waitingForFirstmsg") #|line 357|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 358|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 359|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 360|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 361|#
            )
          (t                                                #|line 362|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (slot-value  msg 'port)) )
            ))                                              #|line 363|#
        )
      (( equal   (slot-value  inst 'state)  "waitingForSecondmsg") #|line 364|#
        (cond
          (( equal    "2" (slot-value  msg 'port))          #|line 365|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 366|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 367|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 368|#
            )
          (t                                                #|line 369|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (slot-value  msg 'port)) )
            ))                                              #|line 370|#
        )
      (t                                                    #|line 371|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}" ) #|line 372|#
        )))                                                 #|line 373|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 375|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 376|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 377|#))) #|line 378|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 380|#
  (let ((fname (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
    (declare (ignorable fname))                             #|line 381|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 382|#) #|line 383|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 385|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 386|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 387|#))) #|line 388|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 390|#
  (cond
    (( equal    "string" (funcall (slot-value (slot-value  msg 'datum) 'kind) )) #|line 391|#
      (funcall (quote forward)   eh  ""  msg )              #|line 392|#
      )
    (t                                                      #|line 393|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value  msg 'datum)) #|line 394|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 395|#
      ))                                                    #|line 396|#
  )
(defclass Syncfilewrite_Data ()                             #|line 398|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 399|#)) #|line 400|#

                                                            #|line 401|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 402|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 403|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 404|#)))
    (declare (ignorable name_with_id))
    (let ((inst  (make-instance 'Syncfilewrite_Data)        #|line 405|#))
      (declare (ignorable inst))
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 406|#)))) #|line 407|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 409|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 410|#
    (cond
      (( equal    "filename" (slot-value  msg 'port))       #|line 411|#
        (setf (slot-value  inst 'filename) (funcall (slot-value (slot-value  msg 'datum) 'srepr) )) #|line 412|#
        )
      (( equal    "input" (slot-value  msg 'port))          #|line 413|#
        (let ((contents (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
          (declare (ignorable contents))                    #|line 414|#
          (let (( f (funcall (quote open)  (slot-value  inst 'filename)  "w"  #|line 415|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 416|#
                (funcall (slot-value  f 'write)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 417|#)
                (funcall (slot-value  f 'close) )           #|line 418|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 419|#
                )
              (t                                            #|line 420|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value  inst 'filename))  msg )
                ))))                                        #|line 421|#
        )))                                                 #|line 422|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 424|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 425|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 426|#
    (scount :accessor scount :initarg :scount :initform  0)  #|line 427|#)) #|line 428|#

                                                            #|line 429|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 430|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 431|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringConcat_Instance_Data) #|line 432|#))
      (declare (ignorable instp))
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 433|#)))) #|line 434|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 436|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 437|#
    (cond
      (( equal    "1" (slot-value  msg 'port))              #|line 438|#
        (setf (slot-value  inst 'buffer1) (funcall (quote clone_string)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 439|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 440|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 441|#
        )
      (( equal    "2" (slot-value  msg 'port))              #|line 442|#
        (setf (slot-value  inst 'buffer2) (funcall (quote clone_string)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 443|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 444|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 445|#
        )
      (t                                                    #|line 446|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (slot-value  msg 'port))  #|line 447|#) #|line 448|#
        )))                                                 #|line 449|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 451|#
  (cond
    (( and  ( equal    0 (length (slot-value  inst 'buffer1))) ( equal    0 (length (slot-value  inst 'buffer2)))) #|line 452|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 453|#
      ))
  (cond
    (( >=  (slot-value  inst 'scount)  2)                   #|line 454|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 455|#
        (cond
          (( equal    0 (length (slot-value  inst 'buffer1))) #|line 456|#
            (setf  concatenated_string (slot-value  inst 'buffer2)) #|line 457|#
            )
          (( equal    0 (length (slot-value  inst 'buffer2))) #|line 458|#
            (setf  concatenated_string (slot-value  inst 'buffer1)) #|line 459|#
            )
          (t                                                #|line 460|#
            (setf  concatenated_string (+ (slot-value  inst 'buffer1) (slot-value  inst 'buffer2))) #|line 461|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 462|#)
        (setf (slot-value  inst 'buffer1)  nil)             #|line 463|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 464|#
        (setf (slot-value  inst 'scount)  0))               #|line 465|#
      ))                                                    #|line 466|#
  ) #|  |#                                                  #|line 468|# #|line 469|# #|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 470|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 471|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 472|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 473|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 474|#)))) #|line 475|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 477|#
  (let ((cmd (slot-value  eh 'instance_data)))
    (declare (ignorable cmd))                               #|line 478|#
    (let ((s (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
      (declare (ignorable s))                               #|line 479|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 480|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 481|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 482|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 483|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 484|#
              (cond
                ((not (equal   rc  0))                      #|line 485|#
                  (funcall (quote send_string)   eh  "✗"  stderr  msg  #|line 486|#)
                  )
                (t                                          #|line 487|#
                  (funcall (quote send_string)   eh  ""  stdout  msg  #|line 488|#) #|line 489|#
                  ))))))))                                  #|line 490|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 492|# #|line 493|# #|line 494|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 495|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 496|#
      (cond
        ((not (equal   root_project  ""))                   #|line 497|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 498|#) #|line 499|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 500|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 501|#) #|line 502|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 503|#)))) #|line 504|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 506|#
  (let ((s (slot-value  eh 'instance_data)))
    (declare (ignorable s))                                 #|line 507|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 508|#)) #|line 509|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 511|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 512|#
  (return-from string_make_persistent  s)                   #|line 513|# #|line 514|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 516|#
  (return-from string_clone  s)                             #|line 517|# #|line 518|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 520|# #|  where ${_00_} is the root directory for the project |# #|line 521|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 522|# #|line 523|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 524|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 525|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 526|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 527|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 528|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 529|#
                  (funcall (quote register_component)   reg (funcall (quote mkTemplate)  (gethash  "name"  container)  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 530|#) #|line 531|#
                  )))                                       #|line 532|#
          ))
    (funcall (quote initialize_stock_components)   reg      #|line 533|#)
    (return-from initialize_component_palette  reg)         #|line 534|#) #|line 535|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 537|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 538|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 539|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (funcall (slot-value  err 'srepr) ) )))) #|line 540|#
          (format *standard-output* "~a~%"  "___ !!! ERRORS !!! ___") #|line 541|#
          (funcall (quote print_specific_output)   main_container  error_port ) #|line 542|#
          ))))                                              #|line 543|#
  ) #|  debugging helpers |#                                #|line 545|# #|line 546|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 547|#
  (format *standard-output* "~a~%"  "")                     #|line 548|# #|line 549|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 551|#
  (funcall (quote nl) )                                     #|line 552|#
  (format *standard-output* "~a~%"  "___ Outputs ___")      #|line 553|#
  (funcall (quote print_output_list)   main_container       #|line 554|#) #|line 555|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 557|#
  #|  remove whitespace from front and back of string |#    #|line 558|#
  (return-from trimws (funcall (slot-value  s 'strip) ))    #|line 559|# #|line 560|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 562|#
  (return-from clone_string  s                              #|line 563|# #|line 564|#) #|line 565|#
  )
(defparameter  load_errors  nil)                            #|line 566|#
(defparameter  runtime_errors  nil)                         #|line 567|# #|line 568|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 569|# #|line 570|#
  (format *standard-output* "~a~%"  s)                      #|line 571|#
  (format *standard-output* "
  ")                                                        #|line 572|#
  (setf  load_errors  t)                                    #|line 573|# #|line 574|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 576|# #|line 577|#
  (format *standard-output* "~a~%"  s)                      #|line 578|#
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
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "1then2"  nil  #'deracer_instantiate )  #|line 600|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?"  nil  #'probe_instantiate )  #|line 601|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?A"  nil  #'probeA_instantiate )  #|line 602|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?B"  nil  #'probeB_instantiate )  #|line 603|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?C"  nil  #'probeC_instantiate )  #|line 604|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "trash"  nil  #'trash_instantiate )  #|line 605|#) #|line 606|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 607|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 608|#) #|line 609|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 610|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 611|#)
  #|  for fakepipe |#                                       #|line 612|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 613|#) #|line 614|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 616|#
  (return-from argv
    (get-main-args)
                                                            #|line 617|#) #|line 618|#
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
                  (let (( marg (funcall (quote new_datum_string)   arg  #|line 648|#)))
                    (declare (ignorable  marg))
                    (let (( msg (funcall (quote make_message)   ""  marg  #|line 649|#)))
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
                                (format *standard-output* "~a~%"  "(no outputs)") #|line 657|#
                                )
                              (t                            #|line 658|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 659|#) #|line 660|#
                                )))                         #|line 661|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 662|#
                          (format *standard-output* "~a~%"  "--- done ---") #|line 663|# #|line 664|#
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





