
                                                            #|line 1|# #|line 2|# #|line 3|#
(defclass Component_Registry ()                             #|line 4|#
  (
    (templates :accessor templates :initarg :templates :initform  nil)  #|line 5|#)) #|line 6|#

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
    (setf (slot-value 'name  templ)  name)                  #|line 16|#
    (setf (slot-value 'template_data  templ)  template_data) #|line 17|#
    (setf (slot-value 'instantiator  templ)  instantiator)  #|line 18|#
    (return-from Template  templ)                           #|line 19|#) #|line 20|#
  )
(defun read_and_convert_json_file (&optional  pathname  filename)
  (declare (ignorable  pathname  filename))                 #|line 22|#

  ;; read json from a named file and convert it into internal form (a list of Container alists)
  (with-open-file (f (format nil "~a/~a.lisp" pathname filename) :direction :input)
    (read f))
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
  (let ((name (funcall (quote mangle_name)  (slot-value 'name  template)  #|line 44|#)))
    (declare (ignorable name))
    (cond
      (( and  ( dict-in?   name (slot-value 'templates  reg)) (not  ok_to_overwrite)) #|line 45|#
        (funcall (quote load_error)   (concatenate 'string  "Component /"  (concatenate 'string (slot-value 'name  template)  "/ already declared"))  #|line 46|#)
        (return-from abstracted_register_component  reg)    #|line 47|#
        )
      (t                                                    #|line 48|#
        (setf (slot-value 'templates  reg) (cons (cons  name  template) (slot-value 'templates  reg))) #|line 49|#
        (return-from abstracted_register_component  reg)    #|line 50|# #|line 51|#
        )))                                                 #|line 52|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 54|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 55|#)))
    (declare (ignorable template_name))
    (cond
      (( dict-in?   template_name (slot-value 'templates  reg)) #|line 56|#
        (let ((template (gethash template_name (slot-value 'templates  reg))))
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
                      (setf  owner_name (slot-value 'name  owner)) #|line 65|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))) #|line 66|#
                      )
                    (t                                      #|line 67|#
                      (setf  instance_name  template_name)  #|line 68|#
                      ))
                  (let ((instance (funcall (slot-value 'instantiator  template)   reg  owner  instance_name (slot-value 'template_data  template)  #|line 69|#)))
                    (declare (ignorable instance))
                    (setf (slot-value 'depth  instance) (funcall (quote calculate_depth)   instance  #|line 70|#))
                    (return-from get_component_instance  instance))))
              )))                                           #|line 71|#
        )
      (t                                                    #|line 72|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 73|#)
        (return-from get_component_instance  nil)           #|line 74|#
        )))                                                 #|line 75|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                 #|line 76|#
  (cond
    (( equal   (slot-value 'owner  eh)  nil)                #|line 77|#
      (return-from calculate_depth  0)                      #|line 78|#
      )
    (t                                                      #|line 79|#
      (return-from calculate_depth (+  1 (funcall (quote calculate_depth)  (slot-value 'owner  eh) ))) #|line 80|#
      ))                                                    #|line 81|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 83|#
  (funcall (quote nl) )                                     #|line 84|#
  (format *standard-output* "~a"  "*** PALETTE ***")        #|line 85|#
  (loop for c in (slot-value 'templates  reg)
    do
      (progn
        c                                                   #|line 86|#
        (funcall (quote print)  (slot-value 'name  c) )     #|line 87|#
        ))
  (format *standard-output* "~a"  "***************")        #|line 88|#
  (funcall (quote nl) )                                     #|line 89|# #|line 90|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 92|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (slot-value 'stats  reg))) #|line 93|# #|line 94|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 96|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 97|#
  (return-from mangle_name  s)                              #|line 98|# #|line 99|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 101|#
  #|  [ |#                                                  #|line 102|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 103|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 104|#
  #|  ] |#                                                  #|line 105|#
  (cond
    ((not (equal   nil  container_list))                    #|line 106|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 107|#
            #|  loop through every component in the diagram and look for names that start with “$“ |# #|line 108|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 109|#
            (loop for child_descriptor in (gethash  "children"  diagram)
              do
                (progn
                  child_descriptor                          #|line 110|#
                  (cond
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "$" ) #|line 111|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 112|#
                        (let ((cmd (funcall (slot-value 'strip  (subseq  name 1)) )))
                          (declare (ignorable cmd))         #|line 113|#
                          (let ((generated_leaf (funcall (quote Template)   name  #'shell_out_instantiate  cmd  #|line 114|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 115|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 116|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 117|#
                        (let ((s  (subseq  name 1)          #|line 118|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote Template)   name  #'string_constant_instantiate  s  #|line 119|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 120|#)))) #|line 121|#
                      ))                                    #|line 122|#
                  ))                                        #|line 123|#
            ))                                              #|line 124|#
      ))
  (return-from generate_shell_components  reg)              #|line 125|# #|line 126|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 128|#
  (return-from first_char  (char  s 0)                      #|line 129|#) #|line 130|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 132|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 133|#))) #|line 134|#
  )                                                         #|line 136|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 137|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 138|# #|line 139|# #|line 140|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 141|# #|  and output queues of messages. |# #|line 142|# #|  |# #|line 143|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 144|# #|  that routes messages to child components according to a list of connections |# #|line 145|# #|  that serve as a message routing table. |# #|line 146|# #|  |# #|line 147|# #|  Child components themselves can be leaves or other containers. |# #|line 148|# #|  |# #|line 149|# #|  `handler` invokes the code that is attached to this component. |# #|line 150|# #|  |# #|line 151|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 152|# #|  function may want whenever it is invoked again. |# #|line 153|# #|  |# #|line 154|# #|line 155|# #|  Eh_States :: enum { idle, active } |# #|line 156|#
(defclass Eh ()                                             #|line 157|#
  (
    (name :accessor name :initarg :name :initform  "")      #|line 158|#
    (inq :accessor inq :initarg :inq :initform  (make-instance 'Queue) #|line 159|#)
    (outq :accessor outq :initarg :outq :initform  (make-instance 'Queue) #|line 160|#)
    (owner :accessor owner :initarg :owner :initform  nil)  #|line 161|#
    (saved_messages :accessor saved_messages :initarg :saved_messages :initform  nil)  #|  stack of saved message(s) |# #|line 162|#
    (children :accessor children :initarg :children :initform  nil)  #|line 163|#
    (visit_ordering :accessor visit_ordering :initarg :visit_ordering :initform  (make-instance 'Queue) #|line 164|#)
    (connections :accessor connections :initarg :connections :initform  nil)  #|line 165|#
    (routings :accessor routings :initarg :routings :initform  (make-instance 'Queue) #|line 166|#)
    (handler :accessor handler :initarg :handler :initform  nil)  #|line 167|#
    (finject :accessor finject :initarg :finject :initform  nil)  #|line 168|#
    (instance_data :accessor instance_data :initarg :instance_data :initform  nil)  #|line 169|#
    (state :accessor state :initarg :state :initform  "idle")  #|line 170|# #|  bootstrap debugging |# #|line 171|#
    (kind :accessor kind :initarg :kind :initform  nil)  #|  enum { container, leaf, } |# #|line 172|#)) #|line 173|#

                                                            #|line 174|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 175|# #|  whose handler function is `container_handler`. |# #|line 176|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 177|#
  (let (( eh  (make-instance 'Eh)                           #|line 178|#))
    (declare (ignorable  eh))
    (setf (slot-value 'name  eh)  name)                     #|line 179|#
    (setf (slot-value 'owner  eh)  owner)                   #|line 180|#
    (setf (slot-value 'handler  eh)  #'container_handler)   #|line 181|#
    (setf (slot-value 'finject  eh)  #'container_injector)  #|line 182|#
    (setf (slot-value 'state  eh)  "idle")                  #|line 183|#
    (setf (slot-value 'kind  eh)  "container")              #|line 184|#
    (return-from make_container  eh)                        #|line 185|#) #|line 186|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 188|# #|  that will be passed back to your handler when called. |# #|line 189|# #|line 190|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 191|#
  (let (( eh  (make-instance 'Eh)                           #|line 192|#))
    (declare (ignorable  eh))
    (setf (slot-value 'name  eh)  (concatenate 'string (slot-value 'name  owner)  (concatenate 'string  "."  name)) #|line 193|#)
    (setf (slot-value 'owner  eh)  owner)                   #|line 194|#
    (setf (slot-value 'handler  eh)  handler)               #|line 195|#
    (setf (slot-value 'instance_data  eh)  instance_data)   #|line 196|#
    (setf (slot-value 'state  eh)  "idle")                  #|line 197|#
    (setf (slot-value 'kind  eh)  "leaf")                   #|line 198|#
    (return-from make_leaf  eh)                             #|line 199|#) #|line 200|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 202|# #|  of the given component. |# #|line 203|# #|line 204|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 205|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 206|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 207|#)) #|line 208|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 210|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 211|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 212|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 213|#))) #|line 214|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 216|#
  (let ((fwdmsg (funcall (quote make_message)   port (slot-value 'datum  msg)  #|line 217|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 218|#)) #|line 219|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 221|#
  (funcall (slot-value 'finject  eh)   eh  msg              #|line 222|#) #|line 223|#
  ) #|  Returns a list of all output messages on a container. |# #|line 225|# #|  For testing / debugging purposes. |# #|line 226|# #|line 227|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 228|#
  (return-from output_list (slot-value 'outq  eh))          #|line 229|# #|line 230|#
  ) #|  Utility for printing an array of messages. |#       #|line 232|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 233|#
  (loop for m in (funcall (quote list)  (slot-value 'queue (slot-value 'outq  eh)) )
    do
      (progn
        m                                                   #|line 234|#
        (format *standard-output* "~a" (funcall (quote format_message)   m )) #|line 235|#
        ))                                                  #|line 236|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 238|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 239|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 240|#
          (setf  s (+  s  " "))                             #|line 241|#
          ))
    (return-from spaces  s)                                 #|line 242|#) #|line 243|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 245|#
  (setf (slot-value 'state  eh)  "active")                  #|line 246|# #|line 247|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 249|#
  (setf (slot-value 'state  eh)  "idle")                    #|line 250|# #|line 251|#
  ) #|  Utility for printing a specific output message. |#  #|line 253|# #|line 254|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 255|#
  (loop for msg in (funcall (quote list)  (slot-value 'queue (slot-value 'outq  eh)) )
    do
      (progn
        msg                                                 #|line 256|#
        (cond
          (( equal   (slot-value 'port  msg)  port)         #|line 257|#
            (return-from fetch_first_output (slot-value 'datum  msg))
            ))                                              #|line 258|#
        ))
  (return-from fetch_first_output  nil)                     #|line 259|# #|line 260|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 262|#
  #|  port ∷ “” |#                                          #|line 263|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 264|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (funcall (slot-value 'srepr  datum) )) #|line 265|#) #|line 266|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 267|#
  #|  port ∷ “” |#                                          #|line 268|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 269|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 270|#
    (format *error-output* "~a" (funcall (slot-value 'srepr  datum) )) #|line 271|#) #|line 272|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 274|#
  (funcall (slot-value 'put (slot-value 'outq  eh))   msg   #|line 275|#) #|line 276|#
  )
(defparameter  root_project  "")                            #|line 278|#
(defparameter  root_0D  "")                                 #|line 279|# #|line 280|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 281|# #|line 282|# #|line 283|#
  (setf  root_project  rproject)                            #|line 284|#
  (setf  root_0D  r0D)                                      #|line 285|# #|line 286|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 288|#
  (let ((name_with_id (funcall (quote gensymbol)   "?"      #|line 289|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 290|#))) #|line 291|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 292|#
  (let ((name_with_id (funcall (quote gensymbol)   "?A"     #|line 293|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 294|#))) #|line 295|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 297|#
  (let ((name_with_id (funcall (quote gensymbol)   "?B"     #|line 298|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 299|#))) #|line 300|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 302|#
  (let ((name_with_id (funcall (quote gensymbol)   "?C"     #|line 303|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 304|#))) #|line 305|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 307|#
  (let ((s (funcall (slot-value 'srepr (slot-value 'datum  msg)) )))
    (declare (ignorable s))                                 #|line 308|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (slot-value 'name  eh)  (concatenate 'string  ": "  s)))) #|line 309|#) #|line 310|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 312|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 313|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 314|#))) #|line 315|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 317|#
  #|  to appease dumped_on_floor checker |#                 #|line 318|#
  #| pass |#                                                #|line 319|# #|line 320|#
  )
(defclass TwoMessages ()                                    #|line 321|#
  (
    (firstmsg :accessor firstmsg :initarg :firstmsg :initform  nil)  #|line 322|#
    (secondmsg :accessor secondmsg :initarg :secondmsg :initform  nil)  #|line 323|#)) #|line 324|#

                                                            #|line 325|# #|  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } |# #|line 326|#
(defclass Deracer_Instance_Data ()                          #|line 327|#
  (
    (state :accessor state :initarg :state :initform  nil)  #|line 328|#
    (buffer :accessor buffer :initarg :buffer :initform  nil)  #|line 329|#)) #|line 330|#

                                                            #|line 331|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 332|#
  #| pass |#                                                #|line 333|# #|line 334|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 336|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 337|#)))
    (declare (ignorable name_with_id))
    (let (( inst  (make-instance 'Deracer_Instance_Data)    #|line 338|#))
      (declare (ignorable  inst))
      (setf (slot-value 'state  inst)  "idle")              #|line 339|#
      (setf (slot-value 'buffer  inst)  (make-instance 'TwoMessages) #|line 340|#)
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 341|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 342|#))) #|line 343|#
  )
(defun send_firstmsg_then_secondmsg (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 345|#
  (funcall (quote forward)   eh  "1" (slot-value 'firstmsg (slot-value 'buffer  inst))  #|line 346|#)
  (funcall (quote forward)   eh  "2" (slot-value 'secondmsg (slot-value 'buffer  inst))  #|line 347|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 348|#) #|line 349|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 351|#
  (let (( inst (slot-value 'instance_data  eh)))
    (declare (ignorable  inst))                             #|line 352|#
    (cond
      (( equal   (slot-value 'state  inst)  "idle")         #|line 353|#
        (cond
          (( equal    "1" (slot-value 'port  msg))          #|line 354|#
            (setf (slot-value 'firstmsg (slot-value 'buffer  inst))  msg) #|line 355|#
            (setf (slot-value 'state  inst)  "waitingForSecondmsg") #|line 356|#
            )
          (( equal    "2" (slot-value 'port  msg))          #|line 357|#
            (setf (slot-value 'secondmsg (slot-value 'buffer  inst))  msg) #|line 358|#
            (setf (slot-value 'state  inst)  "waitingForFirstmsg") #|line 359|#
            )
          (t                                                #|line 360|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (slot-value 'port  msg)) )
            ))                                              #|line 361|#
        )
      (( equal   (slot-value 'state  inst)  "waitingForFirstmsg") #|line 362|#
        (cond
          (( equal    "1" (slot-value 'port  msg))          #|line 363|#
            (setf (slot-value 'firstmsg (slot-value 'buffer  inst))  msg) #|line 364|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 365|#)
            (setf (slot-value 'state  inst)  "idle")        #|line 366|#
            )
          (t                                                #|line 367|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (slot-value 'port  msg)) )
            ))                                              #|line 368|#
        )
      (( equal   (slot-value 'state  inst)  "waitingForSecondmsg") #|line 369|#
        (cond
          (( equal    "2" (slot-value 'port  msg))          #|line 370|#
            (setf (slot-value 'secondmsg (slot-value 'buffer  inst))  msg) #|line 371|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 372|#)
            (setf (slot-value 'state  inst)  "idle")        #|line 373|#
            )
          (t                                                #|line 374|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (slot-value 'port  msg)) )
            ))                                              #|line 375|#
        )
      (t                                                    #|line 376|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}" ) #|line 377|#
        )))                                                 #|line 378|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 380|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 381|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 382|#))) #|line 383|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 385|#
  (let ((fname (funcall (slot-value 'srepr (slot-value 'datum  msg)) )))
    (declare (ignorable fname))                             #|line 386|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 387|#) #|line 388|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 390|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 391|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 392|#))) #|line 393|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 395|#
  (cond
    (( equal    "string" (funcall (slot-value 'kind (slot-value 'datum  msg)) )) #|line 396|#
      (funcall (quote forward)   eh  ""  msg )              #|line 397|#
      )
    (t                                                      #|line 398|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value 'datum  msg)) #|line 399|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 400|#
      ))                                                    #|line 401|#
  )
(defclass Syncfilewrite_Data ()                             #|line 403|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 404|#)) #|line 405|#

                                                            #|line 406|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 407|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 408|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 409|#)))
    (declare (ignorable name_with_id))
    (let ((inst  (make-instance 'Syncfilewrite_Data)        #|line 410|#))
      (declare (ignorable inst))
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 411|#)))) #|line 412|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 414|#
  (let (( inst (slot-value 'instance_data  eh)))
    (declare (ignorable  inst))                             #|line 415|#
    (cond
      (( equal    "filename" (slot-value 'port  msg))       #|line 416|#
        (setf (slot-value 'filename  inst) (funcall (slot-value 'srepr (slot-value 'datum  msg)) )) #|line 417|#
        )
      (( equal    "input" (slot-value 'port  msg))          #|line 418|#
        (let ((contents (funcall (slot-value 'srepr (slot-value 'datum  msg)) )))
          (declare (ignorable contents))                    #|line 419|#
          (let (( f (funcall (quote open)  (slot-value 'filename  inst)  "w"  #|line 420|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 421|#
                (funcall (slot-value 'write  f)  (funcall (slot-value 'srepr (slot-value 'datum  msg)) )  #|line 422|#)
                (funcall (slot-value 'close  f) )           #|line 423|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 424|#
                )
              (t                                            #|line 425|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value 'filename  inst))  msg )
                ))))                                        #|line 426|#
        )))                                                 #|line 427|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 429|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 430|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 431|#
    (scount :accessor scount :initarg :scount :initform  0)  #|line 432|#)) #|line 433|#

                                                            #|line 434|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 435|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 436|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringConcat_Instance_Data) #|line 437|#))
      (declare (ignorable instp))
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 438|#)))) #|line 439|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 441|#
  (let (( inst (slot-value 'instance_data  eh)))
    (declare (ignorable  inst))                             #|line 442|#
    (cond
      (( equal    "1" (slot-value 'port  msg))              #|line 443|#
        (setf (slot-value 'buffer1  inst) (funcall (quote clone_string)  (funcall (slot-value 'srepr (slot-value 'datum  msg)) )  #|line 444|#))
        (setf (slot-value 'scount  inst) (+ (slot-value 'scount  inst)  1)) #|line 445|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 446|#
        )
      (( equal    "2" (slot-value 'port  msg))              #|line 447|#
        (setf (slot-value 'buffer2  inst) (funcall (quote clone_string)  (funcall (slot-value 'srepr (slot-value 'datum  msg)) )  #|line 448|#))
        (setf (slot-value 'scount  inst) (+ (slot-value 'scount  inst)  1)) #|line 449|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 450|#
        )
      (t                                                    #|line 451|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (slot-value 'port  msg))  #|line 452|#) #|line 453|#
        )))                                                 #|line 454|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 456|#
  (cond
    (( and  ( equal    0 (length (slot-value 'buffer1  inst))) ( equal    0 (length (slot-value 'buffer2  inst)))) #|line 457|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 458|#
      ))
  (cond
    (( >=  (slot-value 'scount  inst)  2)                   #|line 459|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 460|#
        (cond
          (( equal    0 (length (slot-value 'buffer1  inst))) #|line 461|#
            (setf  concatenated_string (slot-value 'buffer2  inst)) #|line 462|#
            )
          (( equal    0 (length (slot-value 'buffer2  inst))) #|line 463|#
            (setf  concatenated_string (slot-value 'buffer1  inst)) #|line 464|#
            )
          (t                                                #|line 465|#
            (setf  concatenated_string (+ (slot-value 'buffer1  inst) (slot-value 'buffer2  inst))) #|line 466|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 467|#)
        (setf (slot-value 'buffer1  inst)  nil)             #|line 468|#
        (setf (slot-value 'buffer2  inst)  nil)             #|line 469|#
        (setf (slot-value 'scount  inst)  0))               #|line 470|#
      ))                                                    #|line 471|#
  ) #|  |#                                                  #|line 473|# #|line 474|# #|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 475|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 476|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 477|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 478|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 479|#)))) #|line 480|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 482|#
  (let ((cmd (slot-value 'instance_data  eh)))
    (declare (ignorable cmd))                               #|line 483|#
    (let ((s (funcall (slot-value 'srepr (slot-value 'datum  msg)) )))
      (declare (ignorable s))                               #|line 484|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 485|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 486|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 487|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 488|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 489|#
              (cond
                ((not (equal   rc  0))                      #|line 490|#
                  (funcall (quote send_string)   eh  "✗"  stderr  msg  #|line 491|#)
                  )
                (t                                          #|line 492|#
                  (funcall (quote send_string)   eh  ""  stdout  msg  #|line 493|#) #|line 494|#
                  ))))))))                                  #|line 495|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 497|# #|line 498|# #|line 499|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 500|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 501|#
      (cond
        ((not (equal   root_project  ""))                   #|line 502|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 503|#) #|line 504|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 505|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 506|#) #|line 507|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 508|#)))) #|line 509|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 511|#
  (let ((s (slot-value 'instance_data  eh)))
    (declare (ignorable s))                                 #|line 512|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 513|#)) #|line 514|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 516|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 517|#
  (return-from string_make_persistent  s)                   #|line 518|# #|line 519|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 521|#
  (return-from string_clone  s)                             #|line 522|# #|line 523|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 525|# #|  where ${_00_} is the root directory for the project |# #|line 526|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 527|# #|line 528|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 529|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 530|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 531|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 532|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 533|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 534|#
                  (funcall (quote register_component)   reg (funcall (quote Template)  (gethash  "name"  container)  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 535|#) #|line 536|#
                  )))                                       #|line 537|#
          ))
    (format *standard-output* "~a"  reg)                    #|line 538|#
    (setf  reg (funcall (quote initialize_stock_components)   reg  #|line 539|#))
    (return-from initialize_component_palette  reg)         #|line 540|#) #|line 541|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 543|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 544|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 545|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (funcall (slot-value 'srepr  err) ) )))) #|line 546|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___") #|line 547|#
          (funcall (quote print_specific_output)   main_container  error_port ) #|line 548|#
          ))))                                              #|line 549|#
  ) #|  debugging helpers |#                                #|line 551|# #|line 552|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 553|#
  (format *standard-output* "~a"  "")                       #|line 554|# #|line 555|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 557|#
  (funcall (quote nl) )                                     #|line 558|#
  (format *standard-output* "~a"  "___ Outputs ___")        #|line 559|#
  (funcall (quote print_output_list)   main_container       #|line 560|#) #|line 561|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 563|#
  #|  remove whitespace from front and back of string |#    #|line 564|#
  (return-from trimws (funcall (slot-value 'strip  s) ))    #|line 565|# #|line 566|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 568|#
  (return-from clone_string  s                              #|line 569|# #|line 570|#) #|line 571|#
  )
(defparameter  load_errors  nil)                            #|line 572|#
(defparameter  runtime_errors  nil)                         #|line 573|# #|line 574|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 575|# #|line 576|#
  (format *standard-output* "~a"  s)                        #|line 577|#
  (format *standard-output* "
  ")                                                        #|line 578|#
  (setf  load_errors  t)                                    #|line 579|# #|line 580|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 582|# #|line 583|#
  (format *standard-output* "~a"  s)                        #|line 584|#
  (setf  runtime_errors  t)                                 #|line 585|# #|line 586|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 588|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 589|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 590|#))) #|line 591|#
  )
(defparameter  rand  0)                                     #|line 593|# #|line 594|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 595|# #|line 596|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |# #|line 597|#
  (funcall (quote send_string)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg  #|line 598|#) #|line 599|#
  )                                                         #|line 601|# #|  all of the the built_in leaves are listed here |# #|line 602|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 603|# #|line 604|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 605|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "1then2"  nil  #'deracer_instantiate )  #|line 606|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?"  nil  #'probe_instantiate )  #|line 607|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?A"  nil  #'probeA_instantiate )  #|line 608|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?B"  nil  #'probeB_instantiate )  #|line 609|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?C"  nil  #'probeC_instantiate )  #|line 610|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "trash"  nil  #'trash_instantiate )  #|line 611|#) #|line 612|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 613|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 614|#) #|line 615|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 616|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 617|#)
  #|  for fakepipe |#                                       #|line 618|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 619|#) #|line 620|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 622|#

  (get-main-args)
                                                            #|line 623|# #|line 624|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 626|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 627|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 628|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 629|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 630|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 631|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 632|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 633|#)))))) #|line 634|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 636|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 637|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 638|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 639|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 640|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 641|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 642|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 643|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 644|#)
            #|  get entrypoint container |#                 #|line 645|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 646|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 647|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 651|#) #|line 652|#
                  ))
              (cond
                ((not  load_errors)                         #|line 653|#
                  (let (( arg (funcall (quote new_datum_string)   arg  #|line 654|#)))
                    (declare (ignorable  arg))
                    (let (( msg (funcall (quote make_message)   ""  arg  #|line 655|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 656|#)
                      (cond
                        ( show_all_outputs                  #|line 657|#
                          (funcall (quote dump_outputs)   main_container  #|line 658|#)
                          )
                        (t                                  #|line 659|#
                          (funcall (quote print_error_maybe)   main_container  #|line 660|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  ""  #|line 661|#)))
                            (declare (ignorable outp))
                            (cond
                              (( equal    nil  outp)        #|line 662|#
                                (format *standard-output* "~a"  "(no outputs)") #|line 663|#
                                )
                              (t                            #|line 664|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 665|#) #|line 666|#
                                )))                         #|line 667|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 668|#
                          (format *standard-output* "~a"  "--- done ---") #|line 669|# #|line 670|#
                          ))))                              #|line 671|#
                  ))))))))                                  #|line 672|#
  )                                                         #|line 674|# #|line 675|# #|  utility functions  |# #|line 676|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))       #|line 677|#
  (let ((datum (funcall (quote new_datum_int)   i           #|line 678|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_message  #|line 679|#)) #|line 680|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))          #|line 682|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 683|#
    (funcall (quote send)   eh  port  datum  causing_message  #|line 684|#)) #|line 685|#
  )





